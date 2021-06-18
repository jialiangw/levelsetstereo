function D_pred = optimization(imL, D_gt, D_left_gt, valid_pixs, M_multi_res, M_lowest_res, phi, B, parameters, mask_fg, mask_bg, occ_bg, boundary_mask)

[H,W] = size(phi);
[X,Y] = meshgrid([1:W], [1:H]');

%% evolution process
delta_theta = 0; % delta_theta map: initialize as a dummy 0.
D = 0;  % initialize as a dummy 0. this is the disparity map after each iteration

figure('units','normalized','outerposition',[0 0 1.0 1.0]);

for i = 1:parameters.maxIter
    
    %% compute curvature
    [K, phi_x, phi_y, Nx, Ny] = curvature(phi);
    
    %% compute dirac function
    dirac = (1.0/pi)./(1.0^2.+phi.^2);
    
    %% figure out fg pixels, bg visible pixels and bg occluded pixels
    [in, out, occ] = find_fg_bg_visible_pixels(phi, delta_theta);
    
    %% compute weights for patch voting.
    if i <= 1
        weights = ones(size(M_multi_res,1),size(M_multi_res,2),size(M_multi_res,4));
    else
        weights = compute_patch_voting_weights(M_multi_res,occ,in,delta_theta,parameters.patch_sizes);
    end
    
    %% patch votes
    if i <= 1
        theta_p_gauss = patch_gaussian_vote(M_multi_res, parameters.max_disp, parameters.patch_sizes);
    else
        theta_p_gauss = patch_gaussian_vote(M_multi_res, parameters.max_disp, parameters.patch_sizes, parameters.wta_lambda, D);
    end
    
    %% weighted pixel consensus using Product of Gaussian
    M_est = pixel_consensus_gaussian_vote(theta_p_gauss, weights, parameters.patch_sizes);
    sigma = sqrt(squeeze(M_est(:,:,1)));
    consensus_weight = 1./squeeze(M_est(:,:,1));
    consensus_mean = squeeze(M_est(:,:,2));
    
    %% estimate foreground model
    theta_1 = estimate_global_model(X,Y,consensus_weight,consensus_mean,in,valid_pixs);
    
    %% estimate background model
    theta_2 = estimate_global_model(X,Y,consensus_weight,consensus_mean,out,valid_pixs);
    
    %% compute M(x,y,theta_1), M(x,y,theta_2) and B(x,y,theta_1)
    [M_theta1, M_theta2_, B_theta1] = linear_interp1(theta_1, parameters.max_disp, M_lowest_res, B, theta_2, X, Y);
    
    %% conmpute delta_theta
    delta_theta = compute_delta_theta(theta_1,theta_2,X,Y);
    
    %% shift M(x+-\delta\theta,y,theta_2)
    M_theta2 = shift_M_for_45(M_theta2_, phi, delta_theta);
    
    %% boundary term in our equation
    boundary_term = calculate_boundary_term(B_theta1, Nx, Ny, K);
    boundary_term(boundary_term<-1)=-1;
    boundary_term(boundary_term>1)=1;
    
    %% handle don't care regions
    M_theta1(~valid_pixs)=0;
    M_theta2(~valid_pixs)=0;
    
    %% compute dphi/dt
    dphi_dt = dirac.* (parameters.mu * boundary_term - M_theta1 + M_theta2);
    
    %% plot at the initialization, before any update
    if i == 1
        D = update_D(phi,theta_1,theta_2,X,Y);
        [D_left_pred, occ_left_pred] = Dcyc2Dleft(D, phi, theta_1, theta_2);
        contour_pts = find_current_boundary_pixels(phi);
        
        show_viz(contour_pts,i,D_gt,D_left_gt,imL,true,D_left_pred,occ_left_pred, ...
            mask_fg, mask_bg, occ_bg, boundary_mask, parameters.stereo_pair, ...
            consensus_mean, parameters, sigma, D, occ);
        pause(0.01)
    end
    
    %% do the update
    phi = phi + parameters.dt*dphi_dt;
    
    %% compute the current boundaries
    contour_pts = find_current_boundary_pixels(phi);
    
    %% update D
    D = update_D(phi,theta_1,theta_2,X,Y);
    
    %% signed distance function reinitialization
    if mod(i,parameters.iters_to_reinitialize) == 0
        phi = reinitialize_phi_to_signed_dist_func(phi, contour_pts, parameters.sign_distance_multiplier);
    end
    
    phi = medfilt2(phi,[7,7],'symmetric');
    
    %% display and save gif
    if mod(i,50) == 0 || i < 10
        disp(['Iteration ', num2str(i)]);
        if length(theta_1) == 3 && length(theta_2) == 3
            disp(['theta 1: ', num2str(round(theta_1(1),6)), 'x+', num2str(round(theta_1(2),6)), 'y+', num2str(round(theta_1(3),6))])
            disp(['theta 2: ', num2str(round(theta_2(1),6)), 'x+', num2str(round(theta_2(2),6)), 'y+', num2str(round(theta_2(3),6))])
        elseif length(theta_1) == 6 && length(theta_2) == 6
            disp(['theta 1: ', num2str(round(theta_1(1),6)), 'x^2+', num2str(round(theta_1(2),6)), 'y^2+', num2str(round(theta_1(3),6)), 'xy+ ', num2str(round(theta_1(4),6)), 'x+', num2str(round(theta_1(5),6)), 'y+', num2str(round(theta_1(6),6))])
            disp(['theta 2: ', num2str(round(theta_2(1),6)), 'x^2+', num2str(round(theta_2(2),6)), 'y^2+', num2str(round(theta_2(3),6)), 'xy+ ', num2str(round(theta_2(4),6)), 'x+', num2str(round(theta_2(5),6)), 'y+', num2str(round(theta_2(6),6))])
        elseif length(theta_1) == 10 && length(theta_2) == 10
            disp(['theta 1:', num2str(theta_1)])
            disp(['theta 2:', num2str(theta_2)])
        end
        
        [D_left_pred, occ_left_pred] = Dcyc2Dleft(D, phi, theta_1, theta_2);
        [in, out, occ] = find_fg_bg_visible_pixels(phi, delta_theta);
        show_viz(contour_pts,i,D_gt,D_left_gt,imL,true,D_left_pred,occ_left_pred, ...
            mask_fg, mask_bg, occ_bg, boundary_mask, parameters.stereo_pair, consensus_mean, parameters, sigma, ...
            D, occ);
        pause(0.01)
    end
    
end
D_pred = D;

end


function [M_theta1, M_theta2, B_theta1] = linear_interp1(theta_1s, max_disp, avg_cvs, B, theta_2,X,Y)
    H = size(avg_cvs,1);
    W = size(avg_cvs,2);
    [X,Y] = meshgrid([1:W], [1:H]');

    % theta1 all fg models
    for i = 1:size(theta_1s,1)
        if size(theta_1s,1) > 1
            theta_1 = squeeze(theta_1s(i,:));
        else
            theta_1 = theta_1s;
        end
        % disparity map with theta1
        if length(theta_1) == 3
            theta1_dmap = (theta_1(1)*X+theta_1(2)*Y+theta_1(3));
        elseif length(theta_1) == 6
            theta1_dmap = (theta_1(1)*X.^2+theta_1(2)*Y.^2+theta_1(3)*Y.*X+theta_1(4)*X+theta_1(5)*Y+theta_1(6));
        elseif length(theta_1) == 10
            theta1_dmap = (theta_1(1)*X.^3 + theta_1(2)*X.^2.*Y + theta_1(3)*X.*Y.^2 + theta_1(4)*Y.^3 + theta_1(5)*X.^2 + theta_1(6)*Y.^2 + theta_1(7)*X.*Y + theta_1(8)*X + theta_1(9)*Y + theta_1(10));            
        end

        % find the nearest two disparities and interpolate
        theta1_d_ceil = ceil(theta1_dmap);
        theta1_d_ceil(theta1_d_ceil>max_disp) = max_disp;
        theta1_d_ceil(theta1_d_ceil<1) = 1;
        theta1_d_floor = floor(theta1_dmap);
        theta1_d_floor(theta1_d_floor>max_disp) = max_disp;
        theta1_d_floor(theta1_d_floor<1) = 1;

        % interpolation weight
        ceil_weight = (theta1_dmap - theta1_d_floor);
        floor_weight = (theta1_d_ceil - theta1_dmap);
        theta1_d_ceil_inds = sub2ind(size(avg_cvs), Y,X,theta1_d_ceil);
        theta1_d_floor_inds = sub2ind(size(avg_cvs), Y,X,theta1_d_floor);

        % happens when ceil is the same as floor (the model is integer disparity in pw constant)
        ceil_weight((ceil_weight==0) & (floor_weight==0)) = 1;

        % interpolation
        if i == 1
            M_theta1 = ceil_weight.*avg_cvs(theta1_d_ceil_inds) + floor_weight.*avg_cvs(theta1_d_floor_inds);
            B_theta1 = ceil_weight.*B(theta1_d_ceil_inds) + floor_weight.*B(theta1_d_floor_inds);
            
            % added Feb 12, 2020
            M_theta1((theta1_dmap>max_disp+1) | (theta1_dmap<0)) = 1;
            B_theta1((theta1_dmap>max_disp+1) | (theta1_dmap<0)) = 1;
            % how to handle out of bound
            
        else
            new_M_theta1 = ceil_weight.*avg_cvs(theta1_d_ceil_inds) + floor_weight.*avg_cvs(theta1_d_floor_inds);
            new_B_theta1 = ceil_weight.*B(theta1_d_ceil_inds) + floor_weight.*B(theta1_d_floor_inds);
            indicator = new_M_theta1 < M_theta1;
            B_theta1(indicator) = new_B_theta1(indicator);
            M_theta1(indicator) = new_M_theta1(indicator);
        end
    end

    
    
    % do the same thing for background pixels
    if length(theta_2) == 3
        theta2_dmap = (theta_2(1)*X+theta_2(2)*Y+theta_2(3));
    elseif length(theta_2) == 6
        theta2_dmap = (theta_2(1)*X.^2+theta_2(2)*Y.^2+theta_2(3)*Y.*X+theta_2(4)*X+theta_2(5)*Y+theta_2(6));
    elseif length(theta_2) == 10
        theta2_dmap = (theta_2(1)*X.^3 + theta_2(2)*X.^2.^Y + theta_2(3)*X.*Y.^2 + theta_2(4)*Y.^3 + theta_2(5)*X.^2 + theta_2(6)*Y.^2 + theta_2(7)*X.*Y + theta_2(8)*X + theta_2(9)*Y + theta_2(10)); 
    end
    theta2_d_ceil = ceil(theta2_dmap);
    theta2_d_ceil(theta2_d_ceil>max_disp) = max_disp;
    theta2_d_ceil(theta2_d_ceil<1) = 1;
    theta2_d_floor = floor(theta2_dmap);
    theta2_d_floor(theta2_d_floor>max_disp) = max_disp;
    theta2_d_floor(theta2_d_floor<1) = 1;
    ceil_weight = (theta2_dmap - theta2_d_floor);
    floor_weight = (theta2_d_ceil - theta2_dmap);
    theta2_d_ceil_inds = sub2ind(size(avg_cvs), Y,X,theta2_d_ceil);
    theta2_d_floor_inds = sub2ind(size(avg_cvs), Y,X,theta2_d_floor);
    % happens when ceil is the same as floor (the model is integer disparity pw constant)
    ceil_weight((ceil_weight==0) & (floor_weight==0)) = 1;
    
    M_theta2 = ceil_weight.*avg_cvs(theta2_d_ceil_inds) + floor_weight.*avg_cvs(theta2_d_floor_inds);
    M_theta2((theta2_dmap>max_disp+1) | (theta2_dmap<0)) = 1;
end
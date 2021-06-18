
function theta_p = patch_gaussian_vote(cvs, maxD, patch_sizes, lambda, prev_d)
    
    if nargin > 3
        d_map = zeros(1,1,maxD);
        d_map(1,1,:) = [1:maxD];
        cvs = cvs + lambda*abs(d_map - prev_d);
    end
    

    [min_val, theta_p] = min(cvs,[],3);
    
    % find the mean matching score
    mean_val = squeeze(mean(cvs,3));   
    min_val = squeeze(min_val);
    theta_p = squeeze(theta_p);
    sigma = 1/(mean_val - min_val + 1e-8)*maxD;
    theta_p = cat(4, theta_p, sigma);
end

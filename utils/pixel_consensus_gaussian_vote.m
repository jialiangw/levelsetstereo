function M_est = pixel_consensus_gaussian_vote(theta_p, weights, patch_sizes)
    M_est = zeros(size(theta_p,1),size(theta_p,2),2)+1e-8; % (sigma2, mean)
    one_over_sigma2 = 1./squeeze(theta_p(:,:,:,2)).^2;
    d_over_sigma2 = squeeze(theta_p(:,:,:,1)).*one_over_sigma2;
    
    % estimate sigma2
    for i = 1:length(patch_sizes)
        if size(patch_sizes,1) == 1
            ksize = patch_sizes(i);
            M_est(:,:,1) = M_est(:,:,1) + conv2(conv2(one_over_sigma2(:,:,i).*weights(:,:,i), ones(ksize,1), 'same'), ones(1,ksize),'same');
        else
            ksize = squeeze(patch_sizes(:,i));
            M_est(:,:,1) = M_est(:,:,1) + conv2(conv2(one_over_sigma2(:,:,i).*weights(:,:,i), ones(ksize(1),1), 'same'), ones(1,ksize(2)),'same');
        end
    end
    M_est(:,:,1) = 1./M_est(:,:,1); % sigma2
    
    % estimate d_mean
    for i = 1:length(patch_sizes)
        if size(patch_sizes,1) == 1
            ksize = patch_sizes(i);
            M_est(:,:,2) = M_est(:,:,2) + conv2(conv2(d_over_sigma2(:,:,i).*weights(:,:,i), ones(ksize,1), 'same'), ones(1,ksize),'same');
        else
            ksize = squeeze(patch_sizes(:,i));
            M_est(:,:,2) = M_est(:,:,2) + conv2(conv2(d_over_sigma2(:,:,i).*weights(:,:,i), ones(ksize(1),1), 'same'), ones(1,ksize(2)),'same'); 
        end
    end
    M_est(:,:,2) = M_est(:,:,2).*M_est(:,:,1);
    
end
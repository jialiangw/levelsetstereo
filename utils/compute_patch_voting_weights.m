function weights = compute_patch_voting_weights(cvs,occ,in,delta_theta,patch_sizes)
    delta_theta = round(delta_theta);
    if size(patch_sizes,1) == 2
        patch_sizes = squeeze(patch_sizes(2,:));
    end

    weights = ones(size(cvs,1),size(cvs,2),size(cvs,4));
    % patches that are entirely within occluded region
    for i = 1:length(patch_sizes)
        se = strel('square',patch_sizes(i));
        weights(:,:,i) = 1 - imerode(occ,se);
    end
    % 
    
    for i = 1:length(patch_sizes)
        halfpatch = (patch_sizes(i)+1)/2;
        % find left occlusion boundary pixels
        [ybl,xbl] = find(in & ~[ones(size(cvs,1),1), in(:,1:end-1)]); 
        inds = sub2ind(size(in),ybl,xbl);
        % find delta theta here
        occ_width = delta_theta(inds);
        for ii = 1:length(xbl)
            start_ind=max(1,round(xbl(ii)-halfpatch));
            end_ind=min(size(cvs,2),round(xbl(ii)-occ_width(ii)+halfpatch));
            weights(ybl(ii),start_ind:end_ind,i)=0;
        end
        
        % find right occlusion boundary pixels
        [ybr,xbr] = find(in & ~[in(:,2:end),ones(size(cvs,1),1)]);
        % find their indices
        inds = sub2ind(size(in), ybr, xbr);
        % find the disparity change at the occlusion boundary
        occ_width = delta_theta(inds);
        
        for ii = 1:length(xbr)
            start_ind=max(1,round(xbr(ii)+occ_width(ii)-halfpatch));
            end_ind=min(round(xbr(ii)+halfpatch),size(cvs,2));
           
            weights(ybr(ii),start_ind:end_ind,i)=0;
        end
        
    end
    
end
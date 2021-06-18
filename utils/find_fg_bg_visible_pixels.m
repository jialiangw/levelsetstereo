function [in,out,occ] = find_fg_bg_visible_pixels(phi, delta_theta)
    % in: phi > 0
    % out: phi < 0 and it is not occluded
    % delta_theta: 1 number if pw-constant, 2d map is pw-linear or higher
    % note: this function uses 45 degree geometry to cast shadows to
    % determine which pixels are occluded and which pixels are not
    % So it is an approximation:
    % (1) it looks at the disparity change at the boundary to determine the
    % amount of occluded pixels, which assumes the bg to be fronto-parallel
    % (2) it assumes the fg is long enough so we do not consider the
    % violation of the so-called ordering constraint
    
    delta_theta = round(delta_theta);
    [H,W] = size(phi);
    in = phi >= 0;
    
    if length(delta_theta) == 1
        if delta_theta >= 1
            out = phi < 0;
            % find left occlusion boundary pixels
            [ybl,xbl] = find(in & ~[ones(H,1), in(:,1:end-1)]);
            for ii = 1:length(xbl)
                % occludes delta_theta pixels to the left
                if xbl(ii) - delta_theta >= 1
                    out(ybl(ii),xbl(ii)-delta_theta:xbl(ii)-1) = false;
                else
                    out(ybl(ii),1:xbl(ii)-1) = false;
                end
            end
            % find right occlusion boundary pixels
            [ybr,xbr] = find(in & ~[in(:,2:end),ones(H,1)]);
            for ii = 1:length(xbr)
                % occludes delta_theta pixels to the right
                if xbr(ii) + delta_theta <= W
                    out(ybr(ii),xbr(ii)+1:xbr(ii)+delta_theta) = false;
                else
                    out(ybr(ii),xbr(ii)+1:end) = false;
                end
            end
        else
            out = phi < 0;
        end
    else
        out = phi < 0;
        
        % find left occlusion boundary pixels
        [ybl,xbl] = find(in & ~[ones(H,1), in(:,1:end-1)]);
        % find their indices
        inds = sub2ind(size(in), ybl, xbl);
        % find the disparity change at the occlusion boundary
        delta_theta_l = delta_theta(inds);
        
        for ii = 1:length(xbl)
            % occludes delta_theta pixels to the left
            if xbl(ii) - delta_theta_l(ii) >= 1 && xbl(ii) > 1
                out(ybl(ii),xbl(ii)-delta_theta_l(ii):xbl(ii)-1) = false;
            else
                out(ybl(ii),1:xbl(ii)-1) = false;
            end
        end
        
        % find right occlusion boundary pixels
        [ybr,xbr] = find(in & ~[in(:,2:end),ones(H,1)]);
        % find their indices
        inds = sub2ind(size(in), ybr, xbr);
        % find the disparity change at the occlusion boundary
        delta_theta_r = delta_theta(inds);
        
        for ii = 1:length(xbr)
            % occludes delta_theta pixels to the right
            if xbr(ii) + delta_theta_r(ii) <= W && xbr(ii) < W
                out(ybr(ii),xbr(ii)+1:xbr(ii)+delta_theta_r(ii)) = false;
            else
                out(ybr(ii),xbr(ii)+1:end) = false;
            end
        end
    end
    occ = (phi < 0) & (~out);
end
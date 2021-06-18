function ccv = build_cyc_cost_vol(imL, imR, max_disp, ksize)
    if nargin < 4
        ksize = 5;
    end
    
    if length(ksize) == 1
        %%% featL and featR must be H x W x F
        % 1. compute mean absolute difference of featL and featR
        H = size(imL, 1);
        W = size(imL, 2);

        ccv = zeros(H,W,max_disp);
        
        for i = 1:max_disp
            
            if length(size(imL)) == 2  % grayscale

                init_l = [imL(:,i+1:end), repmat(imL(:,end), 1, i)];
                init_r = [repmat(imR(:,1), 1, i), imR(:,1:end-i)];

                ccv(:,:,i) = conv2(conv2(abs(init_l - init_r), ones(ksize,1), 'same'), ones(1,ksize),'same');
            else  % rgb
                init_l = cat(2, imL(:,i+1:end,:), repmat(imL(:,end,:), 1, i, 1));
                init_r = cat(2, repmat(imR(:,1,:), 1, i, 1), imR(:,1:end-i,:));
                
                diff = convn(convn(abs(init_l - init_r), ones(ksize,1,1), 'same'), ones(1,ksize,1),'same');
                ccv(:,:,i) = mean(diff,3);

            end
        end
    
    else
        % ksize: height x width
        H = size(imL, 1);
        W = size(imL, 2);

        ccv = zeros(H,W,max_disp);

        for i = 1:max_disp

            init_l = [imL(:,i+1:end), repmat(imL(:,end), 1, i)];
            init_r = [repmat(imR(:,1), 1, i), imR(:,1:end-i)];

            ccv(:,:,i) = conv2(conv2(abs(init_l - init_r), ones(ksize(1),1), 'same'), ones(1,ksize(2)),'same');
        end        
        
    end
        
    
end


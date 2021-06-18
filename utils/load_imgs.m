function [imL, imR, D, D_left] = load_imgs(stereo_pair, stereo_dir)
    if nargin < 2
        stereo_dir = 'stereo_test_images/';
    end
    
    if strcmp(stereo_pair(1:3), 'Fal') 
        imL = (double(imread([stereo_dir, stereo_pair, '/im_l.jpg'])));
        imR = (double(imread([stereo_dir, stereo_pair, '/im_r.jpg'])));
    elseif strcmp(stereo_pair(1:3), 'Mid') 
        imL = (double(imread([stereo_dir, stereo_pair, '/im_l_color.png'])));
        imR = (double(imread([stereo_dir, stereo_pair, '/im_r_color.png'])));       
    end
    
    % normalize the left and right images
    imL = imL/max(imL(:));
    imR = imR/max(imR(:));
    
    % load ground truth cyclopean disparity
    load([stereo_dir, stereo_pair, '/disp_c.mat']);
    
    % load ground truth left dispairty
    D_left = load([stereo_dir, stereo_pair, '/disp_l.mat']);
    try
        D_left = D_left.disp1;
    catch
        D_left = D_left.D;
    end
end
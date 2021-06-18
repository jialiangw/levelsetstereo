clear
close all
addpath(genpath('./utils'))
stereo_ind = 15; % which test image? from 1 to 15

%% load default parameters for all stimuli
read_im_and_load_default_params; 

%% each scene may have slightly different parameter for finding monocular edges in Sobel filter
load_edge_threds_and_crop_images; % load image specific parameters, and crop some images

%% cyclopean cost volume
M_multi_res = build_hierarchy_of_CVs(imL, imR, parameters.max_disp, parameters.patch_sizes, parameters.border_crop);
M_level1 = squeeze(M_multi_res(:,:,:,1));  % the cost volume do we use to update \phi(x)

%% convert RGB images to grayscale because Matlab's Sobel filter only takes grayscale images
imL_color = imL;
imR_color = imR;
if length(size(imL)) == 3
    imL = rgb2gray(imL);
    imR = rgb2gray(imR);
end

%% monocular boundary score
B_mono = 1-monocular_edge_into_cv(imL, imR, parameters.max_disp, parameters.edge_thred);

%% crop borders
crop_borders;

%% occlusion boundary score by correlation gradient
B_occ = compute_occlusion_score_using_disp_grad(M_level1, parameters);

%% boundary term
B = 0.2*B_occ + 0.8*B_mono + 0.1;

%% valid pixels
valid_pixs = true(size(D));

%% initialize phi
phi = init_phi(stereo_pair, imL)*parameters.sign_distance_multiplier;

%% run the main function, grid search parameters
D_pred = optimization(imL_color, D, D_left, valid_pixs, M_multi_res, M_level1, phi, B, parameters, mask_fg, mask_bg, occ_bg, boundary_mask);

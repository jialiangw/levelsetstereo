% which scene
if stereo_ind == 1
    stereo_pair = 'Middlebury2006/Monopoly';
elseif stereo_ind == 2
    stereo_pair = 'Middlebury2006/Bowling2';
elseif stereo_ind == 3
    stereo_pair = 'Middlebury2006/Flowerpots';
elseif stereo_ind == 4
    stereo_pair = 'Middlebury2006/Baby1';
elseif stereo_ind == 5
    stereo_pair = 'FallingThings/bleach_cleanser_temple_3_im_2';
elseif stereo_ind == 6
    stereo_pair = 'FallingThings/cracker_box_kitchen_1_im_20';
elseif stereo_ind == 7
    stereo_pair = 'FallingThings/meat_can_kitchen_3_im_68';
elseif stereo_ind == 8
    stereo_pair = 'FallingThings/sugar_box_kitchen_2_im_62';
elseif stereo_ind == 9
    stereo_pair = 'FallingThings/sugar_box_kitchen_2_im_63';
elseif stereo_ind == 10
    stereo_pair = 'FallingThings/pudding_box_kitchen_1_im_70';
elseif stereo_ind == 11
    stereo_pair = 'FallingThings/tamato_can_temple_0_im_30';
elseif stereo_ind == 12
    stereo_pair = 'FallingThings/tuna_fish_can_kitchen_0_im_34';
elseif stereo_ind == 13
    stereo_pair = 'FallingThings/master_chef_kitchen_0_im_71';
elseif stereo_ind == 14
    stereo_pair = 'FallingThings/power_drill_temple_0_im_10';
elseif stereo_ind == 15
    stereo_pair = 'FallingThings/pitch_base_temple_4_im_12';
end

%% parameters
parameters = {}; % data structure to store parameters
parameters.stereo_pair = stereo_pair;

parameters.maxIter = 1500;                    % maximum iterations;
parameters.mu = 4.0;                         % length penalty
parameters.dt = 0.2;                         % step size
parameters.patch_sizes = [3, 9, 18];            % patch sizes to build a hierachy of cost volumes

parameters.iters_to_reinitialize = 10;        % Inf: do not reinitialize
parameters.sign_distance_multiplier = 0.01;   

if strcmp(stereo_pair(1:3), 'Mid') % crop this amount from the stimuli border (not necessary)
    parameters.border_crop = 50;
else
    parameters.border_crop = 100;
end

%% read image and load parameters that depend on the image pair
[imL, imR, D, D_left] = load_imgs(stereo_pair);

parameters.max_disp = ceil(max(50,max(D(:))+10));            % maximum disparity we consider
parameters.wta_lambda = 0.4/parameters.max_disp;      % lambda in weighted wta equation


%% read regions of interest

% ground truth foreground, background and occluded regions
mask_fg = double(imread(['stereo_test_images/', stereo_pair, '/interest_fg.png']));
mask_bg = double(imread(['stereo_test_images/', stereo_pair, '/interest_bg.png']));
occ_bg = double(imread(['stereo_test_images/', stereo_pair, '/left_occ.png']));
occ_bg = squeeze(occ_bg(:,:,1));

% ground truth boundary
boundary_mask = double(imread(['stereo_test_images/', stereo_pair, '/boundary.png']));
boundary_mask = squeeze(boundary_mask(:,:,1));

% the pixel immediately to the left and to the right of the boundary is dont care region
boundary_mask = imdilate(boundary_mask, strel(ones(1,3)));




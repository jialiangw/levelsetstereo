%% specific params
parameters.occ_boundary_thred = 0.02;

if strcmp(stereo_pair(1:3), 'Fal')
    parameters.edge_thred = 0.08;
else
    parameters.edge_thred = 0.06;
end


if strcmp(stereo_pair, 'Middlebury2006/Monopoly') % scene 1
    parameters.edge_thred = 0.07;
end

if strcmp(stereo_pair, 'Middlebury2006/Bowling2')  % scene 2
    imL = imL(70:end-10,1:350,:);
    imR = imR(70:end-10,1:350,:);
    D = D(70:end-10,1:350);
    D_left = D_left(70:end-10,1:350);
    mask_fg = mask_fg(70:end-10,1:350);
    mask_bg = mask_bg(70:end-10,1:350);
    boundary_mask = boundary_mask(70:end-10,1:350);
    occ_bg = occ_bg(70:end-10,1:350);
%     M_multi_res = M_multi_res(70:end-10,1:350,:,:);
%     M_level1 = M_level1(70:end-10,1:350,:);
    
    parameters.edge_thred = 0.1;
end

if strcmp(stereo_pair, 'Middlebury2006/Flowerpots')  % scene 3
    imL = imL(71:325,1:500,:);
    imR = imR(71:325,1:500,:);
    D = D(71:325,1:500);
    D_left = D_left(71:325,1:500);
    mask_fg = mask_fg(71:325,1:500);
    mask_bg = mask_bg(71:325,1:500);
    boundary_mask = boundary_mask(71:325,1:500);
    occ_bg = occ_bg(71:325,1:500);
%     M_multi_res = M_multi_res(71:325,1:500,:,:);
%     M_level1 = M_level1(71:325,1:500,:);
    
    parameters.edge_thred = 0.02;
end

if strcmp(stereo_pair, 'Middlebury2006/Baby1') % scene 4
    imL = imL(1:350,:,:);
    imR = imR(1:350,:,:);
    D = D(1:350,:);
    D_left = D_left(1:350,:);
    mask_fg = mask_fg(1:350,:);
    mask_bg = mask_bg(1:350,:);
    boundary_mask = boundary_mask(1:350,:);
    occ_bg = occ_bg(1:350,:);
%     M_multi_res = M_multi_res(1:350,:,:,:);
%     M_level1 = M_level1(1:350,:,:);
end

if strcmp(stereo_pair, 'FallingThings/bleach_cleanser_temple_3_im_2') % scene 5
    parameters.edge_thred = 0.07;
    imL = imL(:,1:780,:);
    imR = imR(:,1:780,:);
    D = D(:,1:780);
    D_left = D_left(:,1:780);
    
    mask_fg = mask_fg(:,1:780);
    mask_bg = mask_bg(:,1:780);
    boundary_mask = boundary_mask(:,1:780);
    occ_bg = occ_bg(:,1:780);
%     M_multi_res = M_multi_res(:,1:780,:,:);
%     M_level1 = M_level1(:,1:780,:);
end

if strcmp(stereo_pair, 'FallingThings/cracker_box_kitchen_1_im_20') % scene 6
    parameters.edge_thred = 0.08;
end

if strcmp(stereo_pair, 'FallingThings/meat_can_kitchen_3_im_68') % scene 7
    parameters.edge_thred = 0.04;
end

if strcmp(stereo_pair, 'FallingThings/sugar_box_kitchen_2_im_62') % scene 8
    parameters.edge_thred = 0.03;
end

if strcmp(stereo_pair, 'FallingThings/sugar_box_kitchen_2_im_63') % scene 9
    parameters.edge_thred = 0.04;
    parameters.occ_boundary_thred = 0.01;
end

if strcmp(stereo_pair, 'FallingThings/pudding_box_kitchen_1_im_70') % scene 10
    parameters.edge_thred = 0.04;
end

if strcmp(stereo_pair, 'FallingThings/tamato_can_temple_0_im_30') % scene 11
    parameters.edge_thred = 0.04;
end

if strcmp(stereo_pair, 'FallingThings/tuna_fish_can_kitchen_0_im_34') % scene 12
    parameters.edge_thred = 0.15;
end

if strcmp(stereo_pair, 'FallingThings/master_chef_kitchen_0_im_71') % scene 13
    parameters.edge_thred = 0.04;
end

if strcmp(stereo_pair, 'FallingThings/power_drill_temple_0_im_10') % scene 14
    parameters.edge_thred = 0.12;
end

if strcmp(stereo_pair, 'FallingThings/pitch_base_temple_4_im_12') % scene 15
    parameters.edge_thred = 0.04;
end

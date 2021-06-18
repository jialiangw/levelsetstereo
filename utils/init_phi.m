function phi = init_phi(stereo_pair, imL)

phi_shape = "medium";

if strcmp(stereo_pair, 'Middlebury2006/Monopoly')   % scene 1
    phi_shape = 'ellipse'; cx = 285; cy = 250;rx = 50;ry = 140;
end
if strcmp(stereo_pair, 'Middlebury2006/Bowling2')   % scene 2
    phi_shape = 'ellipse'; cx = 105; cy = 270;rx = 55;ry = 300;
end
if strcmp(stereo_pair, 'Middlebury2006/Flowerpots') % scene 3
    phi_shape = 'ellipse'; cx = 200; cy = 100;rx = 70;ry = 70;
end
if strcmp(stereo_pair, 'Middlebury2006/Baby1') % scene 4
    phi_shape = 'ellipse'; cx = 220;cy = 120;rx = 180;ry = 180;
end
if strcmp(stereo_pair, 'FallingThings/bleach_cleanser_temple_3_im_2') % scene 5
    phi_shape = 'ellipse'; cx = 430; cy = 200;rx = 120; ry = 120;
end
if strcmp(stereo_pair, 'FallingThings/cracker_box_kitchen_1_im_20') % scene 6
    ;
end
if strcmp(stereo_pair, 'FallingThings/meat_can_kitchen_3_im_68') % scene 7
    phi_shape = 'user'; cx = 350; cy = 200; r = 60; % spam
end
if strcmp(stereo_pair, 'FallingThings/sugar_box_kitchen_2_im_62') % scene 8
    phi_shape = 'ellipse'; cx = 412;cy = 221;rx = 60;ry = 110;
end
if strcmp(stereo_pair, 'FallingThings/sugar_box_kitchen_2_im_63') % scene 9
    phi_shape = 'user'; cx = 265;cy = 225;r = 135;
end
if strcmp(stereo_pair, 'FallingThings/pudding_box_kitchen_1_im_70') % scene 10
    ;
end
if strcmp(stereo_pair, 'FallingThings/tamato_can_temple_0_im_30') % scene 11
    phi_shape = 'ellipse'; cx = 350; cy = 200;rx = 100;ry = 70;
end
if strcmp(stereo_pair, 'FallingThings/tuna_fish_can_kitchen_0_im_34') % scene 12
    phi_shape = 'user'; cx = 300;cy = 100;r = 70;
end
if strcmp(stereo_pair, 'FallingThings/master_chef_kitchen_0_im_71') % scene 13
    phi_shape = 'user'; cx = 350;cy = 250;r = 75;
end
if strcmp(stereo_pair, 'FallingThings/power_drill_temple_0_im_10') % scene 14
    phi_shape = 'ellipse'; cx = 400; cy = 160;rx = 120; ry = 130;
end
if strcmp(stereo_pair, 'FallingThings/pitch_base_temple_4_im_12') % scene 15
    phi_shape = 'ellipse'; cx = 430; cy = 180;rx = 100; ry = 100;
end


if strcmp(phi_shape, 'sin')
    phi = (sin(pi/85*[1:size(imL,1)]') .* sin(pi/35*[1:size(imL,2)])); % checkerboard
elseif strcmp(phi_shape, 'user')
    % user defined circle
    [y,x] = meshgrid(1:size(imL,2),1:size(imL,1));
    n = zeros(size(x));
    n((x-cy).^2+(y-cx).^2<r.^2) = 1;
    mask = zeros(size(imL));
    mask(1:size(n,1),1:size(n,2)) = n;
    phi = -(bwdist(mask)-bwdist(1-mask)+im2double(mask)); % circle
elseif strcmp(phi_shape, 'ellipse')
    % user defined Ellipse
    [y,x] = meshgrid(1:size(imL,2),1:size(imL,1));
    n = zeros(size(x));
    n((x-cy).^2/ry^2+(y-cx).^2/rx^2 < 1) = 1;
    mask = zeros(size(imL));
    mask(1:size(n,1),1:size(n,2)) = n;
    phi = -(bwdist(mask)-bwdist(1-mask)+im2double(mask)); % circle
else
    mask = maskcircle2(imL,phi_shape);
    mask = mask(:,:,1);
    phi = -(bwdist(mask)-bwdist(1-mask)+im2double(mask)); % circle
    %         phi = phi/max(abs(phi(:)));
end
end
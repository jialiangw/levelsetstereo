function show_viz(contour_pts,iter,D_gt,D_left_gt,imL,save_gif,D_left,occ_pred,mask_fg, mask_bg, ...
    occ_gt, boundary_mask, stereo_pair, consensus_vote, parameters, sigma, ...
    D, occ)

% plot the left image
subplot(2, 3, 1);
imshow(imL);
title('Left image');
set(gca,'YTickLabel',[]);
set(gca,'xTickLabel',[]);


% plot the contour on top of the ground truth disparity
subplot(2,3, 2);
my_plot_range = [min(D_left_gt(:))*0.9,max(D_left_gt(:))*1.1];

D_gt(D_gt == 0) = NaN;
imagesc(D_gt*2,my_plot_range)
axis image;
axis off;
hold on;

if iter == 0
    scatter(contour_pts(1,:), contour_pts(2,:), 5, [0,0,0], 'filled');
else
    scatter(contour_pts(1,:), contour_pts(2,:), 5, 'r', 'filled');
end
iterNum=['contour after ' num2str(iter), ' iterations, on top of GT disparity'];
title(iterNum);
hold off
cmap = [1 1 1; parula(256)];
colormap(gca,cmap)

subplot(2,3,3);
imagesc(1./sigma);
title('one over sigma');
axis image;
axis off;

subplot(2,3,4);
imagesc(consensus_vote*2, my_plot_range)
hold on
hold off
title('consensus mean (\bar{d})')
axis image;
axis off;

% plot the current disparity map
subplot(2, 3, 5);
D(occ==1)=NaN;
imagesc(D*2,my_plot_range);
title('current D map')
axis image;
axis off;

% computing errors 

% find region of interest and get rid of regions without GT
mask_fg = mask_fg & ~boundary_mask & D_left_gt~=0;
mask_bg = mask_bg & ~boundary_mask & D_left_gt~=0;
mask_all = mask_fg | mask_bg;
mask_visible = mask_all & (~occ_gt);
occ_gt = occ_gt & mask_bg;

% process the prediction
occ_pred = occ_pred & mask_all;
[x1,y1] = find(occ_pred);

error_all = abs(D_left - D_left_gt).*mask_visible;
pbp_all = sum(error_all(:)>4.0)/sum(mask_visible(:));

% F score over all occluded pixels
true_pos = occ_pred & occ_gt;  true_pos = sum(true_pos(:));
precision2 = true_pos/sum(occ_pred(:));
recall2 = true_pos/sum(occ_gt(:));
F_score2 = 2*precision2*recall2/(recall2+precision2);

error_string = ['Ours all bad-4: ', num2str(pbp_all*100) ...
    , '.precision,', num2str(precision2), '.recall,' num2str(recall2), '.F-score,', num2str(F_score2)]


subplot(2,3,6);
D_left_gt((occ_gt == 1) & (~isnan(D_left_gt))) = 32;
imagesc(D_left_gt,my_plot_range)
hold on
hold off
colormap(gca,cmap)
title('true disp')
axis image;
axis off;


if save_gif
    frame = getframe(gcf);
    im = frame2im(frame);   % extract image from current figure;
    [I, map] = rgb2ind(im,256);
    if iter == 1
        iter = 0;
    end
    
    if iter==0
        imwrite(I, map, ['results/', stereo_pair, 'cyclopean_noise', num2str(parameters.dt), num2str(parameters.wta_lambda), '.gif'], 'gif', 'Loopcount', inf,...
            'DelayTime', 0.3);  % initialize GIF file;
    else
        imwrite(I, map, ['results/', stereo_pair, 'cyclopean_noise', num2str(parameters.dt), num2str(parameters.wta_lambda), '.gif'], 'gif', 'WriteMode', 'append',...
            'DelayTime', 0.2);  % add new frame every each 5 iterations;
    end
end
end
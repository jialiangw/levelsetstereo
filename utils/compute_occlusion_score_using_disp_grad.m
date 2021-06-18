function occlusion_boundary_score = compute_occlusion_score_using_disp_grad(cvs,parameters)
    % just use the correlation gradient as occlusion boundary score.
    k = 10;
    sigma = 3;
    G1=fspecial('gaussian',[round(k*sigma), round(4*k*sigma)], sigma);
    [Gx,Gy] = gradient(G1);
    final_Gx = zeros(size(Gx,1),size(Gx,2),1);
    final_Gx(:,:,1)=Gx;
    occlusion_boundary_score = abs(convn(cvs,final_Gx,'same'));
    occlusion_boundary_score = occlusion_boundary_score > parameters.occ_boundary_thred;
    occlusion_boundary_score=bwdistsc(uint8(occlusion_boundary_score),[1 1 1]);
    
    occlusion_boundary_score = occlusion_boundary_score/max(occlusion_boundary_score(:));
end

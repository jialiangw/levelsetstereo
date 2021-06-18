function cvs = build_hierarchy_of_CVs(imL, imR, max_disp, window_sz,cut_border)
    cvs = single(zeros(size(imL,1)-2*cut_border, size(imL,2)-2*cut_border,max_disp,length(window_sz)));
    cnt = 1;
    for i=window_sz
        cvi = single(build_cyc_cost_vol(imL, imR, max_disp, i));
        cvi = cvi(cut_border+1:end-cut_border,cut_border+1:end-cut_border,:);
        cvi = (cvi - min(cvi(:)))/(max(cvi(:))-min(cvi(:))); % normalize
        cvs(:,:,:,cnt) = cvi;
        cnt = cnt + 1;
    end

end
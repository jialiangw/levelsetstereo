function occ = disp2occ(disp_map)
    occ = zeros(size(disp_map));
    for i = 1:size(disp_map,1)
        for j = 2:size(disp_map,2)
            delta_d = round(disp_map(i,j) - disp_map(i,j-1));
            if delta_d >= 1
                if j-delta_d > 1
                    occ(i,j-delta_d:j-1) = 1;
                else
                    occ(i,1:j-1) = 1;
                end
            end
        end
    end
end
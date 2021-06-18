function contour_pts = find_current_boundary_pixels(phi)
    contour_pts = contourc(double(phi),[0,0]);
    contour_pts(:,contour_pts(1,:)==0)=[];
end
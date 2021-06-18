function phi_out = reinitialize_phi_to_signed_dist_func(phi, contour_pts, dt)
    % reinitialize the distance map for active contour
    boundary_map = false(size(phi));
    boundary_inds = sub2ind(size(phi), round(contour_pts(2,:)), round(contour_pts(1,:)));
    boundary_map(boundary_inds)=true;
    phi_out = bwdist(boundary_map)*dt;
    
    phi_out = phi_out.*(phi>=0) - phi_out.*(phi<0);
end

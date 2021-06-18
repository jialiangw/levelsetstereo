function boundary_term = calculate_boundary_term(B_theta1, Nx, Ny, K)
    Bx = ([B_theta1(:,2:end), B_theta1(:,end)] - [B_theta1(:,1),B_theta1(:,1:end-1)])/2;
    By = ([B_theta1(2:end,:); B_theta1(end,:)] - [B_theta1(1,:);B_theta1(1:end-1,:)])/2;
    
    N_dot_gradB = Bx.* Nx + By .* Ny;
    B_dot_K = B_theta1 .* K;
    
    boundary_term = B_dot_K + N_dot_gradB;
end
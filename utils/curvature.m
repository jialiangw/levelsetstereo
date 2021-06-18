function [K, phi_xcen_derivative, phi_ycen_derivative, Nx, Ny] = curvature(phi)
     [K, phi_xcen_derivative, phi_ycen_derivative, Nx, Ny] = curvature_mathematica_separable_gauss_dev(phi);
end

function [K, fx, fy, Nx, Ny] = curvature_mathematica_separable_gauss_dev(phi)
    kernel_sz = 7;
    sigma = 4;
    [G1,Gx_1d,Gy_1d] = create_separable_gauss_gradient_filter(kernel_sz, sigma);
    
    fx = conv2(G1', Gx_1d, phi, 'same');
    fy = conv2(Gy_1d, G1, phi,'same');
    fx = fix_boundaries(fx, kernel_sz); 
    fy = fix_boundaries(fy, kernel_sz);
    
    fxx = conv2(G1', Gx_1d, fx, 'same');
    fyy = conv2(Gy_1d, G1, fy, 'same');
    fxy = conv2(Gy_1d, G1, fx, 'same');
    
    grad2 = fx.^2 + fy.^2;
    K = ((fxx.*fy.^2 - 2*fxy.*fx.*fy + fyy.*fx.^2) ./ (grad2.^1.5 + 1e-16));
    K(K>10) = 10;
    K(K<-10) = -10;
    
    Nx = fx./sqrt(grad2+1e-16);
    Ny = fy./sqrt(grad2+1e-16);
end  

function [G1,Gx_1d,Gy_1d] = create_separable_gauss_gradient_filter(k, sigma)
   Wx = floor((k/2)*sigma); 
   if Wx < 1
      Wx = 1;
   end
   x = [-Wx:Wx];

   G1 = 1/(sqrt(2*pi)*sigma)*exp(-(x.^2)/(2*sigma^2));
   Gx_1d = -1/(sqrt(2*pi)*sigma)*(x/sigma^2).*exp(-(x.^2)/(2*sigma^2));
   Gy_1d = Gx_1d';
   
end

function fx = fix_boundaries(fx, kernel_sz)
    fx(1:kernel_sz,:)=repmat(fx(kernel_sz+1,:),kernel_sz,1);
    fx(end-kernel_sz+1:end,:)=repmat(fx(end-kernel_sz,:),kernel_sz,1);
    fx(:,1:kernel_sz)=repmat(fx(:,kernel_sz+1),1,kernel_sz);
    fx(:,end-kernel_sz+1:end)=repmat(fx(:,end-kernel_sz),1,kernel_sz);
end


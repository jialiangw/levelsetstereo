function [D_left, occ_left] = Dcyc2Dleft(D, phi, theta_1, theta_2)
    D_left = zeros(size(D));
    in_left = zeros(size(D));
    
    if length(theta_1) > 3
    
        % for every pixel in the left image, find whether the corresponding
        % cyclopean pixel is in foreground or background
        for y=1:size(D,1)
            for x=1:size(D,2)
                a = theta_1(1);
                b = theta_1(3)*y+theta_1(4)+1;
                k = theta_1(2)*y^2+theta_1(5)*y+theta_1(6)-x;
                if b^2-4*a*k >= 0 
                    x_c = (- b + sqrt(b^2-4*a*k))/(2*a);
                    if x_c <= size(D,2) && x_c >= 1
                        phi_interp = (x_c - floor(x_c))*phi(y, ceil(x_c)) + (ceil(x_c) - x_c)*phi(y, floor(x_c));
                        if phi_interp > 0
                            in_left(y,x) = 1;
                        end
                    end  
                end
            end
        end

        % find the disparities at each pixel
        for y=1:size(D,1)
            for x=1:size(D,2)
                if in_left(y, x) == 1
                    a = theta_1(1);
                    b = theta_1(3)*y+theta_1(4)+1;
                    k = theta_1(2)*y^2+theta_1(5)*y+theta_1(6)-x;
                    x_c = (- b + sqrt(b^2-4*a*k))/(2*a);
                    D_left(y, x) = theta_1(1)*x_c.^2 + theta_1(2)*y.^2 + theta_1(3)*x_c.*y + theta_1(4)*x_c + theta_1(5)*y + theta_1(6);

                else
                    a = theta_2(1);
                    b = theta_2(3)*y+theta_2(4)+1;
                    k = theta_2(2)*y^2+theta_2(5)*y+theta_2(6)-x;
                    x_c = (- b + sqrt(b^2-4*a*k))/(2*a);                
                    D_left(y, x) = theta_2(1)*x_c.^2 + theta_2(2)*y.^2 + theta_2(3)*x_c.*y + theta_2(4)*x_c + theta_2(5)*y + theta_2(6);

                end


            end
        end
        D_left = D_left*2;
    else
        for y=1:size(D,1)
            for x=1:size(D,2)
                x_left = x + round(D(y,x));
                if x_left < size(D_left,2) && D_left(y, x_left) == 0
                    D_left(y, x_left) = D(y,x)*2;
                end
            end
        end
    end
    occ_left = zeros(size(in_left));
    % find occluded pixels in the left image
    boundaries = (D_left - [D_left(:,1), D_left(:,1:end-1)]) > 1;
    for y=1:size(D,1)
        for x=1:size(D,2)
            if x >= 2 && boundaries(y,x) && ~in_left(y,x-1)
                occ_width = D_left(y,x) - D_left(y,x-1);
                occ_st = max(1, x - round(occ_width));
                occ_left(y, occ_st:x-1) = 1 * (~in_left(y, occ_st:x-1));
            end
        end
    end

end
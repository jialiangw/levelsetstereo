function M_theta2 = shift_M_for_45(M_theta2, phi, delta_theta)
    M_theta2 = shift_M_for_45_helper(M_theta2, phi, delta_theta);
end

function M_theta2 = shift_M_for_45_helper(M_theta2, phi, delta_theta)
    % delta_theta is 1 number if pw constant
    % 2d map: ax+b if pw linear
    phi_x = [phi(:,2:end), phi(:,end)] - [phi(:,1),phi(:,1:end-1)];
    
    [H,W] = size(phi_x);
    M_theta2_backup = M_theta2;
    phix_sign = sign(phi_x);
        
    if length(delta_theta) == 1
        delta_theta = delta_theta * ones(size(phi));
    end

    for ii=1:W
        for jj=1:H
            if delta_theta(jj,ii) >= 1
                if ii>2 && ii <size(phi,2) && phi(jj,ii) > 0 && phi(jj,ii-1) < 0 && phi(jj,ii+1) < 0
                    % SINGLE PIXEL FOREGROUND
%                     this_x_ind = ii-delta_theta(jj,ii)-1;   %%%%% JW OCT 13
                    this_x_ind = ii-delta_theta(jj,ii); 

                    % handle the boundaries
                    if this_x_ind < 1
                        M_theta2(jj,ii) = M_theta2_backup(jj,1);
                    elseif this_x_ind > W
                        M_theta2(jj,ii) = M_theta2_backup(jj,W);
                    else
                        this_x_ind_floor = floor(this_x_ind);
                        this_x_ind_ceil = ceil(this_x_ind);
                        M_theta2(jj,ii) = M_theta2_backup(jj,this_x_ind_floor)*(this_x_ind_ceil-this_x_ind) + M_theta2_backup(jj,this_x_ind_ceil)*(this_x_ind-this_x_ind_floor);
                    end
                    
                    this_x_ind = ii+delta_theta(jj,ii);

                    % handle the boundaries
                    if this_x_ind < 1
                        M_theta2(jj,ii) = M_theta2_backup(jj,1);
                    elseif this_x_ind > W
                        M_theta2(jj,ii) = M_theta2_backup(jj,W);
                    else
                        this_x_ind_floor = floor(this_x_ind);
                        this_x_ind_ceil = ceil(this_x_ind);
                        M_theta2(jj,ii) = M_theta2_backup(jj,this_x_ind_floor)*(this_x_ind_ceil-this_x_ind) + M_theta2_backup(jj,this_x_ind_ceil)*(this_x_ind-this_x_ind_floor);
                    end                          
                else
                    % foreground more than 1 pixel long
                    this_x_ind = ii-(delta_theta(jj,ii))*phix_sign(jj,ii);
                    % handle the boundaries
                    if this_x_ind < 1
                        M_theta2(jj,ii) = M_theta2_backup(jj,1);
                    elseif this_x_ind > W
                        M_theta2(jj,ii) = M_theta2_backup(jj,W);
                    else
                        this_x_ind_floor = floor(this_x_ind);
                        this_x_ind_ceil = ceil(this_x_ind);
                        M_theta2(jj,ii) = M_theta2_backup(jj,this_x_ind_floor)*(this_x_ind_ceil-this_x_ind) + M_theta2_backup(jj,this_x_ind_ceil)*(this_x_ind-this_x_ind_floor);
                    end
                    

                end
            end
        end
    end
end



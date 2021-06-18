function D = update_D(phi,theta_1,theta_2,X,Y)
    if length(theta_1) == 3 && length(theta_2) == 3
        D = (phi>=0).* (theta_1(1)*X + theta_1(2)*Y + theta_1(3)) + ...
                      (phi<0).* (theta_2(1)*X + theta_2(2)*Y + theta_2(3));
    elseif length(theta_1) == 6 && length(theta_2) == 6
        D = (phi>=0).* (theta_1(1)*X.^2 + theta_1(2)*Y.^2 + theta_1(3)*X.*Y + theta_1(4)*X + theta_1(5)*Y + theta_1(6)) + ...
                      (phi<0).* (theta_2(1)*X.^2 + theta_2(2)*Y.^2 + theta_2(3)*X.*Y + theta_2(4)*X + theta_2(5)*Y + theta_2(6));
    elseif length(theta_1) == 10 && length(theta_2) == 10
        D = (phi>=0).* (theta_1(1)*X.^3 + theta_1(2)*X.^2.*Y + theta_1(3)*X.*Y.^2 + theta_1(4)*Y.^3 + theta_1(5)*X.^2 + theta_1(6)*Y.^2 + theta_1(7)*X.*Y + theta_1(8)*X + theta_1(9)*Y + theta_1(10)) + ...
                      (phi<0).* (theta_2(1)*X.^3 + theta_2(2)*X.^2.*Y + theta_2(3)*X.*Y.^2 + theta_2(4)*Y.^3 + theta_2(5)*X.^2 + theta_2(6)*Y.^2 + theta_2(7)*X.*Y + theta_2(8)*X + theta_2(9)*Y + theta_2(10));
    end
end
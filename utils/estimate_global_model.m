function theta = estimate_global_model(X,Y,weight,vote,inliers,valid_pixs)
   theta = central_method(X,Y,weight,vote,inliers,valid_pixs);
end

function theta = central_method(X,Y,weight,vote,inliers,valid_pixs)
    inliers = inliers & valid_pixs;
   
    M = [X(inliers).^2.*weight(inliers), Y(inliers).^2.*weight(inliers), Y(inliers).*X(inliers).*weight(inliers), ...
        X(inliers).*weight(inliers), Y(inliers).*weight(inliers), ...
        weight(inliers)];
    c = [weight(inliers).*vote(inliers)];
    if rank(M) < 5
        theta = [0;0;0;0;0;0];
    else
        theta = M \ c;  % ax + by + c = d
    end
    theta = theta';


end
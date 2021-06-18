function output_vol = monocular_edge_into_cv(imL, imR, max_disp,edge_thred)
%     if nargin < 4
%         soft_edge_sigma = 64;
%     end

%     imL = imgaussfilt(imL,soft_edge_sigma);
%     imR = imgaussfilt(imR,soft_edge_sigma);
%     imL = (imL - min(imL(:)))./(max(imL(:)) - min(imL(:))); % normalize to 0 to 1
%     imR = (imR - min(imR(:)))./(max(imR(:)) - min(imR(:))); % normalize to 0 to 1
    
    if 0
        imL = padarray(imL, [1,1], 'replicate', 'both');
        imR = padarray(imR, [1,1], 'replicate', 'both');

        imLx = 1/8*conv2(conv2(imL, [1 0 -1] ,'valid'), [1;2;1] ,'valid');
        imLy = 1/8*conv2(conv2(imL, [1;0;-1] ,'valid'), [1 2 1] ,'valid');

        imRx = 1/8*conv2(conv2(imR, [1 0 -1] ,'valid'), [1;2;1] ,'valid');
        imRy = 1/8*conv2(conv2(imR, [1;0;-1] ,'valid'), [1 2 1] ,'valid');    


        edge1 = sqrt(imLx.^2 + imLy.^ 2);
        edge2 = sqrt(imRx.^2 + imRy.^ 2);

        edge1(edge1>=0.5) = 1;
        edge1(edge1<0.5) = 0;
        edge2(edge2>=0.5) = 1;
        edge2(edge2<0.5) = 0;  

        edge1 = uint8(edge1);
        edge2 = uint8(edge2);
    else
        [~,~,Gv1,Gh1] = edge(imL,'Sobel');
        [~,~,Gv2,Gh2] = edge(imR,'Sobel');
        edge1 = sqrt(Gh1.^2 + Gv1.^ 2)>edge_thred;
        edge2 = sqrt(Gh2.^2 + Gv2.^ 2)>edge_thred;

        
%         keyboard;
    end
%     edge1 = imgaussfilt(edge1,soft_edge_sigma);
%     edge2 = imgaussfilt(edge2,soft_edge_sigma);
%     edge1 = 0.5*(edge1 - min(edge1(:)))./(max(edge1(:)) - min(edge1(:)));
%     edge2 = 0.5*(edge2 - min(edge2(:)))./(max(edge2(:)) - min(edge2(:)));
    if sum(edge1(:))>0
        edge1 = bwdist(edge1);
    end
    if sum(edge2(:))>0
        edge2 = bwdist(edge2);
    end
    edge1 = -0.5*(edge1 - max(edge1(:)))/max(edge1(:)+1e-16);
    edge2 = -0.5*(edge2 - max(edge2(:)))/max(edge2(:)+1e-16);
    output_vol = zeros(size(imL,1),size(imL,2),max_disp);
    for i = 1:max_disp
        output_vol(:,:,i) = [edge1(:,i:end), zeros(size(imL,1),i-1)] + [zeros(size(imL,1),i), edge2(:,1:end-i)];
    end
%     output_vol = (output_vol - min(output_vol(:)))/(max(output_vol(:))-min(output_vol(:))+1e-16);
end
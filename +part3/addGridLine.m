function img = addGridLine(img, r)
    %% �Ӹ��߸���
    % ��
    margin = int16(4 * r(1,1)) + 1;
    width = int16(2 * r(1,2));
    weight = int16(140 * r(1,3)) + 100;
    img(margin:margin+width,:) = weight;
    % ��
    margin = int16(4 * r(2,1)) + 1;
    width = int16(2 * r(2,2));
    weight = int16(140 * r(2,3)) + 100;
    img(size(img,1)-margin-width:size(img,1)-margin,:) = weight;
    % ��
    margin = int16(4 * r(3,1)) + 1;
    width = int16(2 * r(3,2));
    weight = int16(140 * r(3,3)) + 100;
    img(:,margin:margin+width) = weight;
    % ��
    margin = int16(4 * r(4,1)) + 1;
    width = int16(2 * r(4,2));
    weight = int16(140 * r(4,3)) + 100;
    img(:,size(img,2)-margin-width:size(img,2)-margin) = weight;
end
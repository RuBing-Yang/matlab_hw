
function img = rodancorrection()
    clear all
    close all
    img = imread('sudo.jpg');
    img = rgb2gray(img);
    temp = img;
    temp=edge(temp);
    theta = 1:90;
    R = radon(temp,theta);
    [~,angle] = find(R >= max(max(R)));
    angle = 90 - angle;
    img = imcomplement(img);
    img = imrotate(img,angle,'bilinear','crop');
    img = imcomplement(img);
    %img = imcrop(img,[angle*n/100,angle*m/100,n-2*angle*n/100+5,m-2*angle*m/100]);
    %figure,imshow(img);title('rodan');
end
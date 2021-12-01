function img = rodancorrection()
    clear all
    close all
    img = imread('sudo.jpg');
    img = rgb2gray(img);
    temp = img;
    temp=edge(temp);
    theta = 1:180;
    R = radon(temp,theta);
    [~,angle] = find(R >= max(max(R)));
    angle = 90 - angle;
    img = imrotate(img,angle,'bilinear','crop');
    %figure,imshow(img);title('rodanĞ£Õı');
end
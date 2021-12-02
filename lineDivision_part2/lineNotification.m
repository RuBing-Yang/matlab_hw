function nums = lineNotification(Im)
clc
Im = imread('E:\奇奇怪怪的作业\tmp3.jpg');
Im = rgb2gray(Im);
threshold = graythresh(Im);
bw = im2bw(Im, 0.7);
[m,n] = size(bw);
bw = edge(bw, 'canny');
[H, theta, rho] = hough(bw, 'RhoResolution', 1.5, 'Theta', -90:0.1:89);
p = houghpeaks(H, 20,'threshold', ceil(0.5*max(H(:))));
lines = houghlines(bw,theta,rho,p,'FillGap',300,'MinLength',10);



i = 1;
j = 1;
xAddr1 = zeros;
yAddr1 = zeros;
xAddr2 = zeros;
yAddr2 = zeros;
for k = 1 : length(lines)
   if ( abs(lines(k).point1(1)-lines(k).point2(1)) < abs(lines(k).point1(2)-lines(k).point2(2)))
       yAddr1(i) = min(lines(k).point1(1), lines(k).point2(1));
       yAddr2(i) = max(lines(k).point1(1), lines(k).point2(1));
       i = i + 1;
   else
       xAddr1(j) = min(lines(k).point1(2), lines(k).point2(2));
       xAddr2(j) = max(lines(k).point1(2), lines(k).point2(2));
       j = j + 1;
   end
end
if length(xAddr1) < 16
    if length(xAddr1) == 8
        xAddr = cat(2, xAddr1, xAddr2);
        xAddr(17) = 0;
        xAddr(18) = m;
    else
        xAddr1 = sort(xAddr1);
        xAddr1 = xAddr1(2:10);
        xAddr2 = sort(xAddr2);
        xAddr2 = xAddr2(1:9);
        xAddr = cat(2, xAddr1, xAddr2);
    end
else
    if length(xAddr1) == 16
        xAddr = xAddr1;
        xAddr(17) = 0;
        xAddr(18) = m;
    else
        xAddr1 = sort(xAddr1);
        xAddr = xAddr1(2:19);
    end
end
if length(yAddr1) < 16
    if length(yAddr1) == 8
        yAddr = cat(2, yAddr1, yAddr2);
        yAddr(17) = 0;
        yAddr(18) = n;
    else
        yAddr1 = sort(yAddr1);
        yAddr1 = yAddr1(2:10);
        yAddr2 = sort(yAddr2);
        yAddr2 = yAddr2(1:9);
        yAddr = cat(2, yAddr1, yAddr2);
    end
else
    if length(yAddr1) == 16
        yAddr = yAddr1;
        yAddr(17) = 0;
        yAddr(18) = n;
    else
        yAddr1 = sort(yAddr1);
        yAddr = yAddr1(2:19);
    end
end
xAddr = sort(xAddr);
yAddr = sort(yAddr);
disp(xAddr)

i1=1; i2=2;
j1=1; j2=2;
count = 1;
nums = zeros;
for k = 1 : 81
    if i1==1
        ti1 = i1;
    else
        ti1 = i1 - 1;
    end
    if j1==1
        tj1 = j1;
    else
        tj1 = j1 - 1;
    end
    if i2==18
        ti2 = i2;
    else
        ti2 = i2 + 1;
    end
    if j2==18
        tj2 = j2;
    else
        tj2 = j2 + 1;
    end
    %subplot(9,9,count), imshow(Im(xAddr(ti1)+1:xAddr(ti2)-1, yAddr(tj1)+1:yAddr(tj2)-1));
    nums(count) = Im(xAddr(ti1)+1:xAddr(ti2)-1, yAddr(tj1)+1:yAddr(tj2)-1);
    j1=j1+2; j2=j2+2;
    count = count + 1;
    if j1==19
        j1=1; j2=2;
        i1=i1+2; i2=i2+2;
    end
end
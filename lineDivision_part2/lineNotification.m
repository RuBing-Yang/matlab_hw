function nums = lineNotification(Im)
clc
%Im = imread('E:\奇奇怪怪的作业\tmp2.png');
Im = rgb2gray(Im);
threshold = graythresh(Im);
bw = im2bw(Im, threshold);
[m,n] = size(bw);
for i = 2:m-1
   for j = 2:n-1
       %同上下元素判断       
       if(bw(i,j)~=bw(i+1,j) && bw(i,j)~=bw(i-1,j))
           bw(i,j) = 1;
       %同左右元素判断
       elseif(bw(i,j)~=bw(i,j+1) && bw(i,j)~=bw(i,j-1))
           bw(i,j) = 1;
       %同斜边元素判断
       elseif(bw(i,j)~=bw(i+1,j+1) && bw(i,j)~=bw(i-1,j-1))
           bw(i,j) = 1;
       %同斜边元素判断
       elseif(bw(i,j)~=bw(i-1,j+1) && bw(i,j)~=bw(i+1,j-1))
           bw(i,j) = 1;
       end
   end
end
bw = edge(bw, 'canny');
[H, theta, rho] = hough(bw, 'Theta', -90:0.1:89);
p = houghpeaks(H, 16,'threshold', ceil(0.5*max(H(:))));
lines = houghlines(bw,theta,rho,p,'FillGap',100,'MinLength',20);


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
    xAddr = cat(2, xAddr1, xAddr2);
else
    xAddr = xAddr1;
end
if length(yAddr1) < 16
    yAddr = cat(2, yAddr1, yAddr2);
else
    yAddr = yAddr1;
end
yAddr(17) = 0;
yAddr(18) = n;
xAddr(17) = 0;
xAddr(18) = m;
xAddr = sort(xAddr);
yAddr = sort(yAddr);
disp(xAddr)

i1=1; i2=2;
j1=1; j2=2;
count = 1;
nums = zeros;
for k = 1 : 81
    %subplot(9,9,count), imshow(Im(xAddr(i1)+1:xAddr(i2)-1, yAddr(j1)+1:yAddr(j2)-1));
    nums(count) = Im(xAddr(i1)+1:xAddr(i2)-1, yAddr(j1)+1:yAddr(j2)-1);
    j1=j1+2; j2=j2+2;
    count = count + 1;
    if j1==19
        j1=1; j2=2;
        i1=i1+2; i2=i2+2;
    end
end
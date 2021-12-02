function draw(board)
%DRAW 绘制原题与答案的图解
%   此处显示详细说明
clc; close all;
p = imread("+images/blank.jpg");
image = imresize(p,[1200 1200]);
str = string(board);
figure;imshow(image);
hold on

pos=70:130:1200;
for i=1:1:9
    for j=1:1:9
        t=text(pos(1,j),pos(1,i),str(i,j));
        t.Color='r';
        t.FontSize=35;
    end
end
saveas(gcf,'+images/ans.jpg');
end


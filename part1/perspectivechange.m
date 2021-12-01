function img = perspectivechange()
    clear all
    close all
    img = imread('sudo.jpg');
    img = rgb2gray(img);
    figure,imshow(img);
    title('请依次点击数独的左上、右上、左下、右下顶点');
    [M, N] = size(img);
    dots = ginput(4);
    width = round(sqrt((dots(1,1)-dots(2,1))^2+(dots(1,2)-dots(2,2))^2)); 
    height = round(sqrt((dots(1,1)-dots(3,1))^2+(dots(1,2)-dots(3,2))^2));
    %matlab第一个参数表示y
    oldNode_y = [dots(1,1) dots(2,1) dots(3,1) dots(4,1)];
    oldNode_x = [dots(1,2) dots(2,2) dots(3,2) dots(4,2)];
    newNode_y=[dots(1,1) dots(1,1) dots(1,1)+height dots(1,1)+height];     
    newNode_x=[dots(1,2) dots(1,2)+width dots(1,2) dots(1,2)+width];
    A = [oldNode_x(1) oldNode_y(1) 1 0 0 0 -newNode_x(1)*oldNode_x(1) -newNode_x(1)*oldNode_y(1);             
         0 0 0 oldNode_x(1) oldNode_y(1) 1 -newNode_y(1)*oldNode_x(1) -newNode_y(1)*oldNode_y(1);
         oldNode_x(2) oldNode_y(2) 1 0 0 0 -newNode_x(2)*oldNode_x(2) -newNode_x(2)*oldNode_y(2);
         0 0 0 oldNode_x(2) oldNode_y(2) 1 -newNode_y(2)*oldNode_x(2) -newNode_y(2)*oldNode_y(2);
         oldNode_x(3) oldNode_y(3) 1 0 0 0 -newNode_x(3)*oldNode_x(3) -newNode_x(3)*oldNode_y(3);
         0 0 0 oldNode_x(3) oldNode_y(3) 1 -newNode_y(3)*oldNode_x(3) -newNode_y(3)*oldNode_y(3);
         oldNode_x(4) oldNode_y(4) 1 0 0 0 -newNode_x(4)*oldNode_x(4) -newNode_x(4)*oldNode_y(4);
         0 0 0 oldNode_x(4) oldNode_y(4) 1 -newNode_y(4)*oldNode_x(4) -newNode_y(4)*oldNode_y(4)];
     B = [newNode_x(1) newNode_y(1) newNode_x(2) newNode_y(2) newNode_x(3) newNode_y(3) newNode_x(4) newNode_y(4)]';
    fa = (A)\B;        
    a = fa(1);b = fa(2);c = fa(3);
    d = fa(4);e = fa(5);f = fa(6);
    g = fa(7);h = fa(8);

    rot=[d e f;
         a b c;
         g h 1];       
    %变换后图像左上点
    node1=rot*[1 1 1]'/(g*1+h*1+1);  
    %变换后图像右上点
    node2=rot*[1 N 1]'/(g*1+h*N+1); 
    %变换后图像左下点
    node3=rot*[M 1 1]'/(g*M+h*1+1); 
    %变换后图像右下点
    node4=rot*[M N 1]'/(g*M+h*N+1); 
    
   
    height = round(max([node1(1) node2(1) node3(1) node4(1)])-min([node1(1) node2(1) node3(1) node4(1)]));     
    width = round(max([node1(2) node2(2) node3(2) node4(2)])-min([node1(2) node2(2) node3(2) node4(2)]));      
    imgn=zeros(height,width);

    delta_y = round(abs(min([node1(1) node2(1) node3(1) node4(1)])));            
    delta_x = round(abs(min([node1(2) node2(2) node3(2) node4(2)])));           

    for i = 1-delta_y:height-delta_y  
        for j = 1-delta_x:width-delta_x
            pix = rot\[i j 1]';      
            pix = ([g*pix(1)-1 h*pix(1);g*pix(2) h*pix(2)-1])\[-pix(1) -pix(2)]';
            if pix(1) >= 0.5 && pix(2) >= 0.5 && pix(1) <= M && pix(2) <= N
                if round(pix(1)) == round(oldNode_x(1)) && round(pix(2)) == round(oldNode_y(1)) 
                    x1 = j+delta_x;
                    y1 = i+delta_y;
                    disp(x1);
                    disp(y1);
                end 
                if round(pix(1)) == round(oldNode_x(4)) && round(pix(2)) == round(oldNode_y(4)) 
                    x2 = j+delta_x;
                    y2 = i+delta_y;
                    disp(x2);
                    disp(y2);
                end 
                imgn(i+delta_y,j+delta_x)=img(round(pix(1)),round(pix(2))); 
            end  
        end
    end
    
img = uint8(imgn);
img = imcrop(img,[x1 - 5,y1-5,x2-x1+10,y2-y1+10]);
%figure,imshow(img);
end
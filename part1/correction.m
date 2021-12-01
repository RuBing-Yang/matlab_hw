function img = correction(type)
    if type == 0
        img = rodancorrection();
    else
        img = perspectivechange();
    end   
    figure,imshow(img);title('Ð£Õý');
end


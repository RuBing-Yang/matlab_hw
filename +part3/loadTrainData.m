function loadTrainData(channelNum, normal)
    %% 加载存储训练图像
    % normal=1时不加格线
    sizeTrain = 2000;
    imgTrain = part3.readMNIST(0, '+part3/train-images.idx3-ubyte', sizeTrain);
    labelTrain = part3.readMNIST(1, '+part3/train-labels.idx1-ubyte', sizeTrain);
    zeroImds = zeros(size(imgTrain,1), size(imgTrain,2), int16(sizeTrain/10));
    zeroImds = imnoise(zeroImds,'salt & pepper');
    if normal ~= 1
        rng('default');
        r = rand(4, 3, size(imgTrain,3));
        for i = int16(1:size(imgTrain,3))
            imgTrain(:,:,i) = part3.addGridLine(imgTrain(:,:,i), r(:,:,i));
            imgTrain(:,:,i) = part3.my_translate(imgTrain(:,:,i));
        end
        rng('default');
        r = rand(4, 3, size(zeroImds,3));
        for i = int16(1:size(zeroImds,3))
            zeroImds(:,:,i) = part3.addGridLine(zeroImds(:,:,i), r(:,:,i));
            zeroImds(:,:,i) = part3.my_translate(zeroImds(:,:,i));
        end
    end
    imgTrain = imgTrain / 255.0;
    imgTrain = reshape(imgTrain, size(imgTrain,1), size(imgTrain, 2), 1, size(imgTrain, 3));
    zeroImds = zeroImds / 255.0;
    zeroImds = reshape(zeroImds, size(zeroImds,1), size(zeroImds, 2), 1, size(zeroImds, 3));
    if channelNum == 3
        imgTrain = cat(3, imgTrain, imgTrain, imgTrain);
        zeroImds = cat(3, zeroImds, zeroImds, zeroImds);
    end  
    
    mkdir('+part3/train');
    for i = 0:9
        mkdir('+part3/train/', num2str(i));
    end
    count = zeros(9);
    for i = int16(1:size(imgTrain,4))
        if labelTrain(i) == 0
            continue;
        end
        imwrite(imgTrain(:,:,:,i), ['+part3/train/', num2str(labelTrain(i)), '/',num2str(count(labelTrain(i))), '.jpg']);
        count(labelTrain(i)) = count(labelTrain(i)) + 1;
    end
    for i = int16(1:size(zeroImds,4))
        imwrite(zeroImds(:,:,:,i), ['+part3/train/0/',num2str(i-1), '.jpg']);
    end
end
function loadTestData(channelNum, normal)
    %% º”‘ÿ¥Ê¥¢≤‚ ‘ÕºœÒ
    sizeTest = 100;
    imgTest = part3.readMNIST(0, '+part3/t10k-images.idx3-ubyte', sizeTest);
    labelTest = part3.readMNIST(1, '+part3/t10k-labels.idx1-ubyte', sizeTest);
    zeroImds = zeros(size(imgTest,1), size(imgTest,2), int16(sizeTest/10));
    zeroImds = imnoise(zeroImds,'salt & pepper');
    if normal ~= 1
        rng('default');
        r = rand(4, 3, size(imgTest,3));
        for i = int16(1:size(imgTest,3))
            imgTest(:,:,i) = part3.addGridLine(imgTest(:,:,i), r(:,:,i));
            imgTest(:,:,i) = part3.my_translate(imgTest(:,:,i));
        end
        rng('default');
        r = rand(4, 3, size(zeroImds,3));
        for i = int16(1:size(zeroImds,3))
            zeroImds(:,:,i) = part3.addGridLine(zeroImds(:,:,i), r(:,:,i));
            zeroImds(:,:,i) = part3.my_translate(zeroImds(:,:,i));
        end
    end
    imgTest = imgTest / 255.0;
    imgTest = reshape(imgTest, size(imgTest,1), size(imgTest,2), 1, sizeTest);
    zeroImds = zeroImds / 255.0;
    zeroImds = reshape(zeroImds, size(zeroImds,1), size(zeroImds, 2), 1, size(zeroImds, 3));
    if channelNum == 3
        imgTest = cat(3, imgTest, imgTest, imgTest);
        zeroImds = cat(3, zeroImds, zeroImds, zeroImds);
    end
    mkdir('+part3/test');
    for i = 0:9
        mkdir('+part3/test/', num2str(i));
    end
    count = zeros(9);
    for  i = int16(1:sizeTest)
        if labelTest(i) == 0
            continue;
        end
        imwrite(imgTest(:,:,:,i), ['+part3/test/', num2str(labelTest(i)), '/',num2str(count(labelTest(i))), '.jpg']);
        count(labelTest(i)) = count(labelTest(i)) + 1;
    end
    for i = int16(1:size(zeroImds,4))
        imwrite(zeroImds(:,:,:,i), ['+part3/test/0/',num2str(i-1), '.jpg']);
    end
end
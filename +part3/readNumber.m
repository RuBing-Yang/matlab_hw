function numbers = readNumber(inImgs)
    %% 加载训练和测试数据
    channelNum = 3; %输入数据是三通道图像
    selectNet = 2; %选择VGG-16
    normal = 0; %进行数据增广
    numbers = zeros(9,9);
    inImgs = 255 - inImgs; %灰度图黑白取反
    if exist('+part3/test', 'dir') == 0
        part3.loadTestData(channelNum, normal);
    end
    if selectNet == 1
        if exist('+part3/myLenet.mat') == 0
            if exist('+part3/train', 'dir') == 0
                part3.loadTrainData(channelNum, normal);
            end
            part3.trainLenet();
        end
        load ('+part3/myLenet.mat', 'myLenet');
        net = myLenet;
        %part3.testResult(myLenet);
    elseif selectNet == 2
        if exist('+part3/myGooglenet.mat') == 0
            if exist('+part3/train', 'dir') == 0
                part3.loadTrainData(channelNum, normal);
            end
            part3.trainGooglenet();
        end
        load ('+part3/myGooglenet.mat', 'myGooglenet');
        net = myGooglenet;
        %part3.testResult(myGooglenet)
    else
        if exist('+part3/myVgg.mat') == 0
            if exist('+part3/train', 'dir') == 0
                part3.loadTrainData(channelNum, normal);
            end
            part3.trainVgg();
        end
        load ('+part3/myVgg.mat', 'myVgg');
        net = myVgg;
        %part3.testResult(myVgg)
    end
    
    for i = (1:45)
        imwrite(inImgs(:,:,i), ['+part3/temp1/',num2str(i-1), '.jpg']);
    end
    for i = (46:81)
        imwrite(inImgs(:,:,i), ['+part3/temp2/',num2str(i-1), '.jpg']);
    end
    inputSize = net.Layers(1).InputSize;
    imdsTest1 = imageDatastore('+part3/temp1', ...
        'IncludeSubfolders',false); 
    augmentTest = augmentedImageDatastore(inputSize(1:2),imdsTest1);
    [numbers(1:5,:), probs] = classify(net,augmentTest);
    imdsTest2 = imageDatastore('+part3/temp2', ...
        'IncludeSubfolders',false); 
    augmentTest = augmentedImageDatastore(inputSize(1:2),imdsTest2);
    [numbers(6:9,:), probs] = classify(net,augmentTest);
    numbers
end
function readNumber()
    %% ����ѵ���Ͳ�������
    channelNum = 3;
    if exist('train', 'dir') == 0
        loadTrainData(channelNum, 0);
    end
    if exist('test', 'dir') == 0
        loadTestData(channelNum, 0);
    end
    trainVgg();
end

function zeroImds = addZeroImds(s, num)
    %% �����ֿո���
    zeroImds = zeros(s, s, num);
    zeroImds = imnoise(zeroImds,'salt & pepper');
end

function img = my_translate(img)
    randn('seed',sum(100*clock));
    r = rand(2);
    x = 10 * r(1,1) - 5;
    y = 10 * r(1,2) - 5;
    img = imtranslate(img, [x, y]);
end

function img = addGridLine(img)
    %% �Ӹ��߸���
    % ��
    randn('seed',sum(1000*clock));
    r = rand(4);
    margin = int16(4 * r(1,1)) + 1;
    width = int16(2 * r(1,2));
    weight = int16(140 * r(1,3)) + 100;
    img(margin:margin+width,:) = weight;
    % ��
    margin = int16(4 * r(2,1)) + 1;
    width = int16(2 * r(2,2));
    weight = int16(140 * r(2,3)) + 100;
    img(size(img,1)-margin-width:size(img,1)-margin,:) = weight;
    % ��
    margin = int16(4 * r(3,1)) + 1;
    width = int16(2 * r(3,2));
    weight = int16(140 * r(3,3)) + 100;
    img(:,margin:margin+width) = weight;
    % ��
    margin = int16(4 * r(4,1)) + 1;
    width = int16(2 * r(4,2));
    weight = int16(140 * r(4,3)) + 100;
    img(:,size(img,2)-margin-width:size(img,2)-margin) = weight;
end

function loadTrainData(channelNum, normal)
    %% ���ش洢ѵ��ͼ��
    % normal=1ʱ���Ӹ���
    sizeTrain = 1000;
    imgTrain = readMNIST(0, 'train-images.idx3-ubyte', sizeTrain);
    labelTrain = readMNIST(1, 'train-labels.idx1-ubyte', sizeTrain);
    zeroImds = addZeroImds(size(imgTrain,1), int16(sizeTrain/10));
    if normal ~= 1
        for i = int16(1:size(imgTrain,4))
            imgTrain(:,:,:,i) = addGridLine(imgTrain(:,:,:,i));
            %imgTrain(:,:,:,i) = my_translate(imgTrain(:,:,:,i));
        end
        for i = int16(1:size(zeroImds,4))
            zeroImds(:,:,:,i) = addGridLine(zeroImds(:,:,:,i));
            %zeroImds(:,:,:,i) = my_translate(zeroImds(:,:,:,i));
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
    
    mkdir('train');
    for i = 0:9
        mkdir('train/', num2str(i));
    end
    count = zeros(9);
    for i = int16(1:size(imgTrain,4))
        if labelTrain(i) == 0
            continue;
        end
        imwrite(imgTrain(:,:,:,i), ['train/', num2str(labelTrain(i)), '/',num2str(count(labelTrain(i))), '.jpg']);
        count(labelTrain(i)) = count(labelTrain(i)) + 1;
    end
    for i = int16(1:size(zeroImds,4))
        imwrite(zeroImds(:,:,:,i), ['train/0/',num2str(i-1), '.jpg']);
    end
end

function loadTestData(channelNum, normal)
    %% ���ش洢����ͼ��
    sizeTest = 200;
    imgTest = readMNIST(0, 't10k-images.idx3-ubyte', sizeTest);
    labelTest = readMNIST(1, 't10k-labels.idx1-ubyte', sizeTest);
    if normal ~= 1
        for i = int16(1:size(imgTest,4))
            imgTest(:,:,:,i) = addGridLine(imgTest(:,:,:,i));
            %imgTest(:,:,:,i) = my_translate(imgTest(:,:,:,i));
        end
    end
    imgTest = imgTest / 255.0;
    imgTest = reshape(imgTest, size(imgTest,1), size(imgTest,2), 1, sizeTest);
    if channelNum == 3
        imgTest = cat(3, imgTest, imgTest, imgTest);
    end
    mkdir('test');
    for i = 1:9
        mkdir('test/', num2str(i));
    end
    count = zeros(9);
    for  i = int16(1:sizeTest)
        if labelTest(i) == 0
            continue;
        end
        imwrite(imgTest(:,:,:,i), ['test/', num2str(labelTest(i)), '/',num2str(count(labelTest(i))), '.jpg']);
        count(labelTest(i)) = count(labelTest(i)) + 1;
    end
end


function [imdsTrain, imdsValidation, numClasses] = dataPretreat(s, normal)
    %% ��������
    % normal=1ʱ�����Ŵ���Сƫ��
    imds = imageDatastore('train', ...
        'IncludeSubfolders',true, ...
        'LabelSource','foldernames'); 
    [imdsTrain,imdsValidation] = splitEachLabel(imds,0.7);
    numClasses = numel(categories(imdsTrain.Labels));
    pixelRange = [-30 30];
    scaleRange = [0.9 1.1];
    imageAugmenter = imageDataAugmenter( ...
        'RandXReflection',true, ...
        'RandXTranslation',pixelRange, ...
        'RandYTranslation',pixelRange, ...
        'RandXScale',scaleRange, ...
        'RandYScale',scaleRange);
    if normal == 1
        imdsTrain = augmentedImageDatastore(s(1:2),imdsTrain);
        imdsValidation = augmentedImageDatastore(s(1:2),imdsValidation);
    else
        imdsTrain = augmentedImageDatastore(s(1:2),imdsTrain, ...
            'DataAugmentation',imageAugmenter);
        imdsValidation = augmentedImageDatastore(s(1:2),imdsValidation, ...
            'DataAugmentation',imageAugmenter);
    end

end


function trainLenet()
    %% LeNet-5Ǩ��ѧϰ
    layers = lenet5TLfun();
    inputSize = layers(1).InputSize;
    [imdsTrain, imdsValidation, numClasses] = dataPretreat(inputSize, 0);
    options = trainingOptions('sgdm', ...
        'LearnRateSchedule','piecewise', ...
        'LearnRateDropFactor',0.1, ...
        'LearnRateDropPeriod',30,...
        'MiniBatchSize',128, ...
        'MaxEpochs',30, ...
        'InitialLearnRate',5e-4, ...
        'ValidationData',imdsValidation, ...
        'ValidationFrequency',3, ...
        'Shuffle','every-epoch', ...
        'Verbose',false, ...
        'Plots','training-progress');
    net = trainNetwork(imdsTrain, layers, options);
end


function trainGooglenet()
    %% GoogLeNetǨ��ѧϰ
    net = googlenet;
    inputSize = net.Layers(1).InputSize;
    [imdsTrain, imdsValidation, numClasses] = dataPretreat(inputSize, 1);
    
    % �滻��󼸲�
    % analyzeNetwork(net);
    lgraph = layerGraph(net);
    lgraph = removeLayers(lgraph, {'loss3-classifier','prob','output'});
    newLayers = [
        fullyConnectedLayer(numClasses,'Name','fc','WeightLearnRateFactor',10,'BiasLearnRateFactor',10)
        softmaxLayer('Name','softmax')
        classificationLayer('Name','classoutput')];
    lgraph = addLayers(lgraph,newLayers);
    lgraph = connectLayers(lgraph,'pool5-drop_7x7_s1','fc');
    %figure('Units','normalized','Position',[0.3 0.3 0.4 0.4]);
    %plot(lgraph)
    %ylim([0,10])

    % �����ʼ�㣬��ֹ�����
    layers = lgraph.Layers;
    connections = lgraph.Connections;
    layers(1:10) = freezeWeights(layers(1:10));
    lgraph = createLgraphUsingConnections(layers,connections);


    %% ѵ������
    miniBatchSize = 10;
    valFrequency = floor(numel(augimdsTrain.Files)/miniBatchSize);
    options = trainingOptions('sgdm', ...
        'MiniBatchSize',miniBatchSize, ...
        'MaxEpochs',6, ...
        'InitialLearnRate',3e-4, ...
        'Shuffle','every-epoch', ...
        'ValidationData',augimdsValidation, ...
        'ValidationFrequency',valFrequency, ...
        'Verbose',false, ...
        'Plots','training-progress');
    net = trainNetwork(imdsTrain,lgraph,options);


    %% �����֤
    [YPred,probs] = classify(net,augimdsValidation);
    accuracy = mean(YPred == imdsValidation.Labels);
    accuracy
    idx = randperm(numel(imdsValidation.Files),4);
    figure
    for i = 1:4
        subplot(2,2,i)
        I = readimage(imdsValidation,idx(i));
        imshow(I);
        label = YPred(idx(i));
        title(string(label) + ", " + num2str(100*max(probs(idx(i),:)),3) + "%");
    end

    % ����������
    myGooglenet = net;
    save ('myGooglenet.mat', 'myGooglenet');
end


function trainVgg()
    %% Vgg-16Ǩ��ѧϰ
    net = vgg16;
    inputSize = net.Layers(1).InputSize;
    [imdsTrain, imdsValidation, numClasses] = dataPretreat(inputSize, 1);
    
    % �滻���һ��ȫ���Ӳ�ͷ��������
    % analyzeNetwork(net);
    lgraph = layerGraph(net.Layers);
    newLearnableLayer = fullyConnectedLayer(numClasses, ...
        'Name','new_fc', ...
        'WeightLearnRateFactor',10, ...
        'BiasLearnRateFactor',10);
    lgraph = replaceLayer(lgraph,'fc8',newLearnableLayer);
    newClassLayer = classificationLayer('Name','new_classoutput');
    lgraph = replaceLayer(lgraph,'output',newClassLayer);
    %figure('Units','normalized','Position',[0.3 0.3 0.4 0.4]);
    %plot(lgraph)
    %ylim([0,10])

    %% ѵ������
    miniBatchSize = 8;
    valFrequency = floor(numel(imdsTrain.Files)/miniBatchSize);
    options = trainingOptions('sgdm', ...
        'MiniBatchSize',miniBatchSize, ...
        'MaxEpochs',6, ...
        'InitialLearnRate',3e-4, ...
        'Shuffle','every-epoch', ...
        'ValidationData',imdsValidation, ...
        'ValidationFrequency',valFrequency, ...
        'Verbose',false, ...
        'Plots','training-progress');
    net = trainNetwork(imdsTrain,lgraph,options);


    %% �����֤
    imdsTest = imageDatastore('test', ...
        'IncludeSubfolders',true, ...
        'LabelSource','foldernames'); 
    imdsTest = augmentedImageDatastore(inputSize(1:2),imdsTest);
    [YPred,probs] = classify(net,imdsTest);
    accuracy = mean(YPred == imdsTest.Labels);
    accuracy
    idx = randperm(numel(imdsTest.Files),4);
    figure
    for i = 1:4
        subplot(2,2,i)
        I = readimage(imdsTest,idx(i));
        imshow(I)
        label = YPred(idx(i));
        title(string(label) + ", " + num2str(100*max(probs(idx(i),:)),3) + "%");
    end

    % ����������
    myVgg = net;
    save ('myVgg.mat', 'myVgg');
end
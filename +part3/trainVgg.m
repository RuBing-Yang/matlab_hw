function trainVgg()
    %% Vgg-16迁移学习
    net = vgg16;
    inputSize = net.Layers(1).InputSize;
    [imdsTrain, imdsValidation, numClasses] = part3.dataPretreat(inputSize, 1);
    
    % 替换最后一个全连接层和分类输出层
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

    %% 训练网络
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

    % 保存网络结果
    myVgg = net;
    save ('myVgg.mat', 'myVgg');
end
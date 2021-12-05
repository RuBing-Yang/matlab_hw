function trainGooglenet()
    %% GoogLeNetǨ��ѧϰ
    net = googlenet;
    inputSize = net.Layers(1).InputSize;
    [imdsTrain, imdsValidation, numClasses] = part3.dataPretreat(inputSize, 1);
    
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

    % ����������
    myGooglenet = net;
    save ('+part3/myGooglenet.mat', 'myGooglenet');

    %% �����֤
    [YPred,probs] = classify(net,imdsValidation);
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

end
function testResult(net)
    net
    %% �����֤
    inputSize = net.Layers(1).InputSize;
    imdsTest = imageDatastore('+part3/test', ...
        'IncludeSubfolders',true, ...
        'LabelSource','foldernames'); 
    augmentTest = augmentedImageDatastore(inputSize(1:2),imdsTest);
    [YPred, probs] = classify(net,augmentTest);
    accuracy = mean(YPred == imdsTest.Labels);
    accuracy
    idx = randperm(numel(imdsTest.Files),4);
    figure
    for i = 1:4
        subplot(2,2,i)
        I = readimage(imdsTest,idx(i));
        imshow(I)
        label = YPred(idx(i));
        max(probs(idx(i),:))
        title("����Ϊ" + string(label) + ", ���Ŷ�" + num2str(100*max(probs(idx(i),:)),3) + "%");
    end
end
function loadImgData(channelNum, normal)
    if exist('+part3/train', 'dir') == 0
        part3.loadTrainData(channelNum, normal);
    end
    if exist('+part3/test', 'dir') == 0
        part3.loadTestData(channelNum, normal);
    end
end
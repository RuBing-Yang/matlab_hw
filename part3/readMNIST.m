
function res = readMNIST(flag, filename, readDigits)
    if flag == 0
        res = read_MNIST_img(filename, readDigits);
    else
        res = read_MNIST_label(filename, readDigits);
    end
end

function imgs = read_MNIST_img(imgFile, readDigits)
    fid = fopen(imgFile, 'r', 'b');
    header = fread(fid, 1, 'int32');
    if header ~= 2051
        error('Invalid image file header');
    end
    fread(fid, 1, 'int32');
    h = fread(fid, 1, 'int32');
    w = fread(fid, 1, 'int32');
    imgs = zeros([h w readDigits]);
    for i=1:readDigits
        for y=1:h
            imgs(y,:,i) = fread(fid, w, 'uint8');
        end
    end
    fclose(fid);
end 

function labels = read_MNIST_label(labelFile, readDigits)
    fid = fopen(labelFile, 'r', 'b');
    header = fread(fid, 1, 'int32');
    if header ~= 2049
        error('Invalid label file header');
    end
    fread(fid, 1, 'int32');
    labels = fread(fid, readDigits, 'uint8');
    fclose(fid);
end


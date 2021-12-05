
function res = readMNIST(flag, filename, readDigits)
    if flag == 0
        fid = fopen(filename, 'r', 'b');
        header = fread(fid, 1, 'int32');
        if header ~= 2051
            error('Invalid image file header');
        end
        fread(fid, 1, 'int32');
        h = fread(fid, 1, 'int32');
        w = fread(fid, 1, 'int32');
        res = zeros([h w readDigits]);
    for i=1:readDigits
        for y=1:h
            res(y,:,i) = fread(fid, w, 'uint8');
        end
    end
    fclose(fid);
    else
        fid = fopen(filename, 'r', 'b');
        header = fread(fid, 1, 'int32');
        if header ~= 2049
            error('Invalid label file header');
        end
        fread(fid, 1, 'int32');
        res = fread(fid, readDigits, 'uint8');
        fclose(fid);
    end
end


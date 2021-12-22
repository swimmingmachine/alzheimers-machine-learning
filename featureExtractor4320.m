% 4320 Feature extraction dem@care data June 2017, C. Bian

load('rawData.mat')

for f=1:size(rawData,1)
    featureByDyads4320 = cell([38,3]);
    featureMatrix4320=[];
    dyadsRow = 0;
    
    for k=1:size(rawData{f,2},1)
        if ~isempty(rawData{f,2}{k,1})
            feature = normFeatures4320(rawData{f,2}{k,1},str2double(rawData{f,2}{k,2}));
            featureMatrix4320=[featureMatrix4320;feature];
            % arrange array layout by dyads
            if rem(k,2) == 1
                dyadsRow = dyadsRow+1;
                dyadsCol = 1;
                featureByDyads4320(dyadsRow,dyadsCol) = {feature};
            else
                dyadsCol = 2;
                featureByDyads4320(dyadsRow,dyadsCol:end) = {feature, rawData{f,2}{k,3}(2:4)};
            end
            % Save each feature to a feature vector
            % featureVector4320(k,1:2) = {rawData{1,2}{k,3},feature};
        end
    end

    featureMatrix = featureMatrix4320;
    featureByDyads = featureByDyads4320;
    %save('featureVector4320.mat','featureVector4320');
    matrixFName = sprintf('featureMatrix4320_%d.mat', f);
    dyadFName = sprintf('featureByDyads4320_%d.mat', f);
    save(matrixFName, 'featureMatrix');
    save(dyadFName, 'featureByDyads');
end

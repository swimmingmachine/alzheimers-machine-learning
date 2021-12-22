% New Feature extraction dem@care data June 2017, C. Bian

% load raw data file
load('rawData.mat')

% loop 5 folders/frequency settings
for f=1:size(rawData,1)
    featureByDyads = cell([38,3]);
    featureMatrixNew=[];
    dyadsRow = 0;
    % loop 78 subjects in a selected folder/frequency setting
    for k=1:size(rawData{f,2},1)
        if ~isempty(rawData{f,2}{k,1})
            feature = normFeatures(rawData{f,2}{k,1},str2double(rawData{f,2}{k,2}),50); 
            featureMatrixNew = [featureMatrixNew;feature];
            
            % arrange array layout by dyads
            if rem(k,2) == 1
                dyadsRow = dyadsRow+1;
                dyadsCol = 1;
                featureByDyads(dyadsRow,dyadsCol) = {feature};
            else
                dyadsCol = 2;
                featureByDyads(dyadsRow,dyadsCol:end) = {feature, rawData{f,2}{k,3}(2:4)};
            end

            % save each feature to a feature vector
            % featureVectorNew(k,1:2) = {rawData{m,2}{k,3},feature};
        end
    end

    featureMatrix = featureMatrixNew;
    matrixFName = sprintf('featureMatrixNew%d.mat', f);
    dyadFName = sprintf('featureByDyads%d.mat', f);
    %save('featureVectorNew.mat','featureVectorNew');
    save(matrixFName, 'featureMatrix');
    save(dyadFName, 'featureByDyads');
end
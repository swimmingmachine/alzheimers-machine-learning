% New Feature extraction dem@care data June 2017, C. Bian
%function extractDomainFeatures(rawData)
% the function accepts rawdata to extract domain knowledge features
% the input raw data can be 24h rawData or subset of rawData

% load raw data file
% load('rawData.mat')

% loop 5 folders/frequency settings
for f=1:size(rawData,1)
    domainFeatureByDyads = cell([38,3]);
    domainFeatureMatrix=[];
    dyadsRow = 0;
    % loop 78 subjects in each selected folder/frequency setting
    for k=1:size(rawData{f,2},1)
        if ~isempty(rawData{f,2}{k,1})
            % extract domain features for 24h raw data
            domainFeature24h = detectIntervals(rawData{f,2}{k,1});
            domainFeatureMid2morning = detectIntervals(mid2morningRawData{f,2}{k,1});
            domainFeatureMorning = detectIntervals(morningRawData{f,2}{k,1});
            domainFeatureAfternoon = detectIntervals(afternoonRawData{f,2}{k,1});
            domainFeatureAfternoon2mid = detectIntervals(afternoon2midRawData{f,2}{k,1});
            label = str2double(rawData{f,2}{k,2});
            if label == 2
                label = 1;
            end
            domainFeature = [domainFeature24h domainFeatureMid2morning(1,3:4) domainFeatureMorning(1,3:4) domainFeatureAfternoon(1,3:4) domainFeatureAfternoon2mid(1,3:4) label];
            domainFeatureMatrix = [domainFeatureMatrix;domainFeature];
            
            % arrange array layout by dyads
            if rem(k,2) == 1
                dyadsRow = dyadsRow+1;
                dyadsCol = 1;
                domainFeatureByDyads(dyadsRow,dyadsCol) = {domainFeature};
            else
                dyadsCol = 2;
                domainFeatureByDyads(dyadsRow,dyadsCol:end) = {domainFeature, rawData{f,2}{k,3}(2:4)};
            end

            % save each feature to a feature vector
            % featureVectorNew(k,1:2) = {rawData{m,2}{k,3},feature};
        end
    end
    
    % just for unifying the matrix variable names used later by ML
    featureMatrix = domainFeatureMatrix;
    featureByDyads = domainFeatureByDyads;
    
    matrixFName = sprintf('domainFeatureMatrix%d.mat', f);
    dyadFName = sprintf('domainFeatureByDyads%d.mat', f);
    %save('featureVectorNew.mat','featureVectorNew');
    % save feature matrix and unify the variable name to featureMatrix and
    % featureByDyads
    save(matrixFName, 'featureMatrix');
    save(dyadFName, 'featureByDyads');
end
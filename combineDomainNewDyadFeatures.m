function [domainNewDyadFeature]= combineDomainNewDyadFeatures(numFile)
% load features file
    fileToLoad = sprintf('domainFeatureByDyads%d.mat', numFile);
    load(fileToLoad);
    fm1 = featureByDyads;
    fileToLoad = sprintf('featureByDyads%d.mat', numFile);
    load(fileToLoad);
    fm2 = featureByDyads;
    domainNewDyadFeature = [];
    
    % combine feature data 
    fprintf('\nCombining features\n');
    for m = 1:size(fm1,1)
        % get data part
        domainFeatureDataHC1 = fm1{m,1}(:,1:end-1);
        domainFeatureDataAD1 = fm1{m,2}(:,1:end-1);
        newFeatureDataHC2 = fm2{m,1}(:,1:end-1);
        newFeatureDataAD2 = fm2{m,2}(:,1:end-1);
        % get label part (as labels are the same for all datasets, so just take labels in fm1)
        labelHC = fm1{m,1}(:,end);
        labelAD = fm1{m,2}(:,end);
        % combine all data
        dataHC=[domainFeatureDataHC1 newFeatureDataHC2 labelHC];
        dataAD = [domainFeatureDataAD1 newFeatureDataAD2 labelAD];
        
        domainNewDyadFeature=[domainNewDyadFeature; dataHC dataAD fm1(m,3)];
    end
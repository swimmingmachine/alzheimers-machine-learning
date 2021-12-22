%Classification - Leave one dyad/pair of subjects cross validation

mdlEvl = [];
for numFile=1:5
    % ATTENTION: choose one of the following code block for data loading
    
    % Block 1 - for combined 15 features only - load new featureByDyad file
    %{
    fileToLoad = sprintf('featureByDyads%d.mat', numFile);
    load(fileToLoad);
    fprintf('\nLoaded file-%s\n',fileToLoad);
    featureByDyadsNew = featureByDyads;
    %}
    
    % Block 2 - load featureByDyads file (for 4320 feature and domain feature data files)
    %{
    fileToLoad = sprintf('domainFeatureByDyads%d.mat', numFile);
    %fileToLoad = sprintf('featureByDyads4320_%d.mat', numFile);
    load(fileToLoad);
    fprintf('\nLoaded file-%s\n',fileToLoad);
    %}
    
    % Block 3 - load combined 10 new and domain feature
    %{
    domainNewDyadFeature = combineDomainNewDyadFeatures(numFile);
    featureByDyads = domainNewDyadFeature;
    %}
    
    % Bloc 4 - load combined feature (can be any combination e.g. domain+5+10 or domain +10 or domain+5)
    % Note: change inside function loadCombineData to choose what files to
    % combine
    domainNewPCADyadFeatures = combineDomainNewPCADyadFeatures(numFile);
    featureByDyads = domainNewPCADyadFeatures;
    
    numDyads=length(featureByDyads);
    recog=zeros(2,2);
    scoreRF=[];
    TL=[];
    data=[];
    label=[];
    dyadsRow = 0;
    features = cell(38,2);
    
    % pca - only for 4320 features
    if size(featureByDyads{1,1},2) == 4321 
        for i=1:numDyads
            for k=1:2
                data=[data;featureByDyads{i,k}(1,1:end-1)];
                label=[label;featureByDyads{i,k}(1,end)];
            end
        end
        fprintf('\nPerforming PCA\n');
        [coeff,score] = pca(data);
        data = score(:,1:5); %5 pc components
        % (re)create featureByDyads matrix
        for m=1:size(data,1)
            if rem(m,2) == 1
                dyadsRow = dyadsRow+1;
                dyadsCol = 1;
                features(dyadsRow,dyadsCol) = {data(m,:)};
            else
                dyadsCol = 2;
                features(dyadsRow,dyadsCol) = {data(m,:)};
            end
        end
    end
    
    for i=1:numDyads
        X=circshift(1:numDyads,[0 i]);
        testIndex=X(1);
        trainIndex=X(2:numDyads);
        fprintf('\nTest Subject %d, Number-%d\n',i,testIndex);
        train=[];
        test=[];
        trainLabel=[];
        testLabel=[];
        for j=1:length(trainIndex)
            for k=1:2 %because it is a pair
                % ATTENTION! use one of the following code blocks based on
                % the type of features to use, comment out the other code
                % blocks
                
                %Code Block - 15 Features
                % build training dataset using 15 combined features (5 PCA + 10)
                %f = [features{trainIndex(1,j),k}(1,1:end) featureByDyadsNew{trainIndex(1,j),k}(1,1:end-1)];
                %train=[train;f];
                
                %Code Block - 4320 Features
                %{
                % building training dataset using 4320 features
                train=[train;features{trainIndex(1,j),k}(1,1:end)];
                %train=[train;featureByDyads{trainIndex(1,j),k}(1,1:end-1)];
                trainLabel=[trainLabel;featureByDyads{trainIndex(1,j),k}(1,end)+1];
                %}
                
                %Code Block - Domain Knowledge Features
                train=[train;featureByDyads{trainIndex(1,j),k}(1,1:end-1)];
                trainLabel=[trainLabel;featureByDyads{trainIndex(1,j),k}(1,end)];

            end
        end
        for k=1:2 %because it is a pair
            % ATTENTION! use one of the following code blocks based on
            % the type of features to use, comment out the other code
            % blocks
            
            %Code Block - 15 Features
            % build training set using combined features (5 PCA + 10)
            %tst = [features{testIndex,k}(1,1:end) featureByDyadsNew{testIndex,k}(1,1:end-1)];
            %test=[test;tst];
            
            %Code Block - 4320 Features
            %{
            % building training dataset using 4320 features% use features for 4320
            test=[test;features{testIndex,k}(1,1:end)];
            %test=[test;featureByDyads{testIndex,k}(1,1:end-1)];
            testLabel=[testLabel;featureByDyads{testIndex,k}(1,end)+1];
            %}
            
            %Code Block - Domain Knowledge Features
            test=[test;featureByDyads{testIndex,k}(1,1:end-1)];
            testLabel=[testLabel;featureByDyads{testIndex,k}(1,end)];
        end
        TL=[TL;testLabel];
        
        %Normalization
        [trainNorm, mu, sigma]=zscore(train);
        testNorm=(test-mu)./sigma;
        
        % SVM
%         fprintf('\nTraining SVM\n');
%         SVMmodel=fitcsvm(trainNorm,trainLabel);
%         [predictLabel,sc]=predict(SVMmodel,testNorm);
%         scoreRF=[scoreRF;sc];
%         for j=1:length(testLabel)
%             recog(testLabel(j,1)+1,predictLabel(j,1)+1)=recog(testLabel(j,1)+1,predictLabel(j,1)+1)+1;
%         end

        % Random Forest
%         randomFeature=floor((size(trainNorm,2)).*rand + 1);
%         fprintf('\nTraining Random Forest\n');
%         RF=TreeBagger(100,trainNorm,trainLabel,'NumPredictorsToSample',randomFeature);
%         [predictLabel,sc]=predict(RF,testNorm);
%         scoreRF=[scoreRF;sc];
%         for j=1:length(testLabel)
%             recog(testLabel(j,1)+1,str2double(predictLabel{j,1})+1)=recog(testLabel(j,1)+1,str2double(predictLabel{j,1})+1)+1;
%         end

          % NB
    %     mdl=fitensemble(train,trainLabel,'bag',50,'tree','type','classification');
    %     predictLabel=predict(mdl,test);
    %     for j=1:length(testLabel)
    %         recog(testLabel(j,1),predictLabel(j,1))=recog(testLabel(j,1),predictLabel(j,1))+1;
    %     end
    
        % QDA
        fprintf('\nTraining QDA\n');
        QDAMdl = fitcdiscr(train,trainLabel,'DiscrimType','diagQuadratic');
        [predictLabel,sc]=predict(QDAMdl,test);
        scoreRF=[scoreRF;sc];
        for j=1:length(testLabel)
            recog(testLabel(j,1)+1,predictLabel(j,1)+1)=recog(testLabel(j,1)+1,predictLabel(j,1)+1)+1;
        end
    end
    % calculate accuracy
    accuracy=(recog(1,1)+recog(2,2))/sum(recog(:));
    [X,Y,T,AUC] = perfcurve(TL,scoreRF(:,2),1);
    mdlEvl = [mdlEvl;{accuracy, AUC}];
    %avgAccuracy=mean(accuracy);
end
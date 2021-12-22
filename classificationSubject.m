%Classification - Leave one subject cross validation
mdlEvl=[];
for numFile=1:5
    %numDyads=size(featureMatrix,1)/2;
    recog=zeros(2,2);
    scoreRF=[];
    TL=[];
    
    %ATTENTION: choose one of the following code blocks for loading
    %appropriate data files (.mat)
    
    %{
    % Block 1 - load doemain features files
    fileToLoad = sprintf('domainFeatureMatrix%d.mat', numFile);
    load(fileToLoad);
    fprintf('\nLoaded file-%s\n',fileToLoad);
    data = featureMatrix;
    numSubjects=size(data,1);
    %}
    
    %{
    % Block 2 - load 4320 feature data files
    fileToLoad = sprintf('featureMatrix4320_%d.mat', numFile);
    load(fileToLoad);
    
    data = featureMatrix(:,1:end-1);
    label = featureMatrix(:,end);
    
    % pca for 4320 features
    if size(data,2) == 4320
        fprintf('\nPerforming PCA\n');
        [coeff,score] = pca(data);
        data = score(:,1:5); %5 pc components
    end
    
    data=[data label];
    numSubjects=size(data,1);
    %}
    
    % Block 3 - load combined feature data files by file suffix numberm
    % Note: change inside function loadCombineData to choose what files to
    % combine
    data=loadCombineData(numFile);
    numSubjects=size(data,1);
    
    for i=1:numSubjects
        % prepare train and test dataset
        X=circshift(1:numSubjects,[0 i]);
        testIndex=X(1);
        trainIndex=X(2:numSubjects);
        fprintf('\nTest Subject %d, Number-%d\n',i,testIndex);
        train=[];
        trainLabel=[];
        for j=1:length(trainIndex)
            train=[train;data(trainIndex(1,j),1:end-1)];
            trainLabel=[trainLabel;data(trainIndex(1,j),end)+1];
        end
        test=data(testIndex,1:end-1);
        testLabel=data(testIndex,end)+1;
        TL=[TL;testLabel];

        %Normalization
         [trainNorm, mu, sigma]=zscore(train);
         testNorm=(test-mu)./sigma;

          % SVM - attention: note to use train/test or trainNorm/testNorm
        fprintf('\nTraining SVM\n');
        % for normalization use
        %SVMmodel=fitcsvm(trainNorm,trainLabel);
        SVMmodel=fitcsvm(train,trainLabel);
        % for normalization use
        %[predictLabel,sc]=predict(SVMmodel,testNorm);
        [predictLabel,sc]=predict(SVMmodel,test);
        scoreRF=[scoreRF;sc];
        for j=1:length(testLabel)
            recog(testLabel(j,1),predictLabel(j,1))=recog(testLabel(j,1),predictLabel(j,1))+1;
        end

         %RF - attention: note to use train/test or trainNorm/testNorm
%         randomFeature=floor((size(trainNorm,2)).*rand + 1);
%         fprintf('\nTraining Random Forest\n');
%         RF=TreeBagger(50,trainNorm,trainLabel,'NumPredictorsToSample',randomFeature);
%         [predictLabel,sc]=predict(RF,testNorm);
%         scoreRF=[scoreRF;sc];
%         for j=1:length(testLabel)
%             recog(testLabel(j,1),str2double(predictLabel{j,1}))=recog(testLabel(j,1),str2double(predictLabel{j,1}))+1;
%         end

        % NB
%         mdl=fitcnb(train,trainLabel,'ClassNames',{'1','2'});
%         %mdl=fitensemble(train,trainLabel,'bag',50,'tree','type','classification');
%         predictLabel=predict(mdl,test);
%         predictLabel=str2double(cell2mat(predictLabel));
%         for j=1:length(testLabel)
%             recog(testLabel(j,1),predictLabel(j,1))=recog(testLabel(j,1),predictLabel(j,1))+1;
%         end

     % QDA - attention: note to use train/test or trainNorm/testNorm
%         fprintf('\nTraining QDA\n');
%         QDAMdl = fitcdiscr(trainNorm,trainLabel,'DiscrimType','diagQuadratic');
%         [predictLabel,sc]=predict(QDAMdl,testNorm);
%         scoreRF=[scoreRF;sc];
%         for j=1:length(testLabel)
%             recog(testLabel(j,1),predictLabel(j,1))=recog(testLabel(j,1),predictLabel(j,1))+1;
%         end
        
    end
    % calculate accuracy and AUC
    accuracy=(recog(1,1)+recog(2,2))/sum(recog(:));
    [X,Y,T,AUC] = perfcurve(TL,scoreRF(:,2),1);
    mdlEvl = [mdlEvl;{accuracy, AUC}];
end
% prepare feature/predictors matrix
X = featureMatrixNew(:,1:end-1);
X4320 = featureMatrix4320(:,1:end-1);

% train RF model
RFMdl = TreeBagger(50,X,cogstatus,'OOBPrediction','On','Method','classification',...
    'NumPredictorsToSample',sqrt(size(X,2)));
RFMdl4320 = TreeBagger(50,X4320,cogstatus,'OOBPrediction','On','Method','classification',...
    'NumPredictorsToSample',sqrt(size(X4320,2)));

% cross validate 'leave one subject out' of the RF model


% cross validate 'leave one dyad out' of the RF model
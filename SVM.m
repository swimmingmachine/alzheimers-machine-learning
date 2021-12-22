% prepare feature/predictor matrixes
X = featureMatrixNew(:,1:end-1);
X4320 = featureMatrix4320(:,1:end-1);

% train SVM models
SVMMdl=fitcsvm(X,y);
SVMMdl4320 = fitcsvm(X4320,y);

% cross validation 'leave one subject out' of the SVM model
CVSVMMdl = crossval(SVMModel,'Leaveout','on');
CVSVMMdl4320 = crossval(SVMModel4320,'Leaveout','on');

% cross validation 'leave one dyad out' of the SVM model

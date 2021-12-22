SVMMdl = fitcsvm(X,cogstatus,'Standardize',true);
SVMMdl = fitPosterior(SVMMdl);
[~,score_svm] = resubPredict(SVMMdl);
[Xsvm,Ysvm,Tsvm,AUCsvm] = perfcurve(cogstatus,score_svm(:,2),1);    
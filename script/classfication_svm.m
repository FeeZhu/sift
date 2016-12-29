% 利用svm分类
%
%
%
%% classification script using SVM

% load the BOW representations, the labels, and the train and test set
load(Bow_sift.trainset);
load(Bow_sift.testset);
load(Bow_sift.labels);

%% sift
load([Bow_sift.globaldatapath,'/',pyramid_opts.name])
train_labels = labels(trainset);          % contains the labels of the trainset
train_data = pyramid_all(:,trainset)';          % contains the train data
[train_labels,sindex]=sort(train_labels);    % we sort the labels to ensure that the first label is '1', the second '2' etc
train_data=train_data(sindex,:);
test_labels= labels(testset);           % contains the labels of the testset
test_data= pyramid_all(:,testset)';           % contains the test data
%% train kernal
kernel_train = hist_isect(train_data,train_data);
kernel_train = [(1:size(kernel_train,1))',kernel_train];
%% svm训练
bestcv = 0;
bestc=200;bestg=2;

options=sprintf('-s 0 -t 4 -c %f -b 1 -g %f -q',bestc,bestg);
model=svmtrain(train_labels,kernel_train,options);
%% kernel test
kernel_test = hist_isect(test_data,train_data);
kernel_test = [(1:size(kernel_test,1))',kernel_test];

[predict_label, accuracy , dec_values] = svmpredict(test_labels,kernel_test, model,'-b 1');

confusion_matrix = confusionmat(test_labels,predict_label);
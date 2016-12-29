%%-----------------------------
%配置文件,路径，数据
clear Bow_sift;
rootpath='F:\sift_BOW\';

%%
addpath siftDemoV4;
addpath script;
addpath libsvm;
%% change the Path to images
images=strcat(rootpath,'images');
data=strcat(rootpath,'data');
labels=strcat(rootpath,'labels');

%%
Bow_sift.imgPath=images;
Bow_sift.dataPath=data;
Bow_sift.labelsPath=labels;

%% 设置数据路径
% local and global data paths
Bow_sift.localdatapath=sprintf('%s/local',Bow_sift.dataPath);
Bow_sift.globaldatapath=sprintf('%s/global',Bow_sift.dataPath);

% initialize the training set
Bow_sift.trainset=sprintf('%s/trainset.mat',Bow_sift.labelsPath);
% initialize the test set
Bow_sift.testset=sprintf('%s/testset.mat',Bow_sift.labelsPath);
% initialize the labels
Bow_sift.labels=sprintf('%s/labels.mat',Bow_sift.labelsPath);
% initialize the image names
Bow_sift.image_names=sprintf('%s/image_names.mat',Bow_sift.labelsPath);

%%
% 训练样本和测试样本的路径
Bow_sift.classes = load([Bow_sift.labelsPath,'/classes.mat']);
Bow_sift.classes = Bow_sift.classes.classes;
Bow_sift.nclasses = length(Bow_sift.classes);

load(sprintf('%s',Bow_sift.labels));
Bow_sift.nimages = size(labels,1);

load(Bow_sift.trainset);
load(Bow_sift.testset);
Bow_sift.ntraning = length(find(trainset==1));
Bow_sift.ntesting = length(find(testset==1));

%% creat the directory to save data 
MakeDataDirectory(Bow_sift);


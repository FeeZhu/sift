% Script to get sift features

display('*********** start *********')
clc;
clear;
ini;
detect_opts=[];descriptor_opts=[];dictionary_opts=[];assignment_opts=[];ada_opts=[];

%% 得到sift描述子
descriptor_opts.patchSize=16;                                                   % normalized patch size
descriptor_opts.gridSpacing=8; 
descriptor_opts.maxImageSize=1000;
sift_descript(Bow_sift,descriptor_opts);

%% k均值聚类得到texton
dictionary_opts.dictionarySize = 200;     % 单词大小
dictionary_opts.name='sift_features';     %类别
dictionary_opts.type='sift_dictionary';
CalculateDictionary(Bow_sift, dictionary_opts);
%% 根据聚类单词 
assignment_opts.dictionary_type=dictionary_opts.type;
assignment_opts.featuretype=dictionary_opts.name;
assignment_opts.texton_name='texton_ind';
assignment(Bow_sift,assignment_opts);
%% 构建金字塔
pyramid_opts.name='spatial_pyramid';
pyramid_opts.dictionarySize=dictionary_opts.dictionarySize;
pyramid_opts.pyramidLevels=3;
pyramid_opts.texton_name=assignment_opts.texton_name;
CompilePyramid(Bow_sift,pyramid_opts);
%% 构建相似性度量矩阵，SVM分类
classfication_svm;

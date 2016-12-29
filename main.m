% Script to get sift features

display('*********** start *********')
clc;
clear;
ini;
detect_opts=[];descriptor_opts=[];dictionary_opts=[];assignment_opts=[];ada_opts=[];

%% �õ�sift������
descriptor_opts.patchSize=16;                                                   % normalized patch size
descriptor_opts.gridSpacing=8; 
descriptor_opts.maxImageSize=1000;
sift_descript(Bow_sift,descriptor_opts);

%% k��ֵ����õ�texton
dictionary_opts.dictionarySize = 200;     % ���ʴ�С
dictionary_opts.name='sift_features';     %���
dictionary_opts.type='sift_dictionary';
CalculateDictionary(Bow_sift, dictionary_opts);
%% ���ݾ��൥�� 
assignment_opts.dictionary_type=dictionary_opts.type;
assignment_opts.featuretype=dictionary_opts.name;
assignment_opts.texton_name='texton_ind';
assignment(Bow_sift,assignment_opts);
%% ����������
pyramid_opts.name='spatial_pyramid';
pyramid_opts.dictionarySize=dictionary_opts.dictionarySize;
pyramid_opts.pyramidLevels=3;
pyramid_opts.texton_name=assignment_opts.texton_name;
CompilePyramid(Bow_sift,pyramid_opts);
%% ���������Զ�������SVM����
classfication_svm;

function [ ] = assignment( opts,assignment_opts)
%根据聚类结果分配种类，构建词袋直方图
%   Detailed explanation goes here

%% 初始化
   load(opts.image_names);
   nimages=opts.nimages;
   vocabulary=getfield(load([opts.globaldatapath,'/','sift_dictionary']),'dictionary');
   vocabulary_size=size(vocabulary,1);  %单词个数
   featuretype=assignment_opts.featuretype;
   
%% 构建词袋
   BOW=[];
   for ii=1:nimages
        image_dir=sprintf('%s/%s/',opts.localdatapath,num2string(ii,4));                    % location where detector is saved
        inFName = fullfile(image_dir, sprintf('%s', featuretype));
        load(inFName, 'features');
        points = features.descrips;
        
        texton_ind.wid = features.wid;
        texton_ind.hgt = features.hgt;
        texton_ind.x = features.locs(:,1);
        texton_ind.y = features.locs(:,2);
        
        %计算最近的单词
        d2 = EuclideanDistance(points, vocabulary);
        [minz, index] = min(d2', [], 1);
        BOW(:,ii)=hist(index,(1:vocabulary_size));
        texton_ind.data = index;
        save ([image_dir,'/',assignment_opts.texton_name],'texton_ind');
       % save ([image_dir,'/','texton_ind'],'index');
   end
   
   BOW=do_normalize(BOW,1);                                                 % normalize the BOW histograms to sum-up to one.
   save ([opts.globaldatapath,'/','BOW_Hist'],'BOW');                      % save the BOW representation
end


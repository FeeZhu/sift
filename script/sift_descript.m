function [] = sift_descript( opts,descriptor_opts )
%读取训练样本图像得到sift特征描述子
%   Detailed explanation goes here
%
%
maxImageSize = descriptor_opts.maxImageSize;
gridSpacing = descriptor_opts.gridSpacing;
patchSize = descriptor_opts.patchSize;

%% load image and compute sift descrips
 load(opts.image_names);         % load image in data set
 nimages=opts.nimages;           % number of images in data set
 for i=1:nimages
    % I=imread([opts.imgPath,'/',image_names{i}]);
     I=load_images([opts.imgPath,'/',image_names{i}]);
     [hgt wid] = size(I);
     
     %计算原图像的大小
     if(min(hgt,wid) > maxImageSize)
         I = imresize(I, maxImageSize/min(hgt,wid), 'bicubic');
            fprintf('Loaded %s: original size %d x %d, resizing to %d x %d\n', ...
                image_names{i}, wid, hgt, size(I,2), size(I,1));
            [hgt wid] = size(I);
     end
     
     [image, descrips, locs] = sift([opts.imgPath,'/',image_names{i}]);
     %保存sift特征
     features.descrips=descrips;
     features.locs=locs;
     features.wid = wid;
     features.hgt = hgt;
     features.patchSize=patchSize;
     
     image_dir=sprintf('%s/%s/',opts.localdatapath,num2string(i,4));
     save ([image_dir,'/','sift_features'], 'features');
     imwrite(image,[image_dir,'/','image.tif']);
 end
end


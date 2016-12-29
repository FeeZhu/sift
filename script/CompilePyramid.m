function [ pyramid_all ] = CompilePyramid(opts,pyramid_opts )
% 构建金字塔模型
% Building Spatial Pyramid
%
fprintf('Building Spatial Pyramid\n');

%% parameters
texton_name=pyramid_opts.texton_name;
dictionarySize = pyramid_opts.dictionarySize;
pyramidLevels = pyramid_opts.pyramidLevels;

binsHigh = 2^(pyramidLevels-1);
pyramid_all = [];
nimages=opts.nimages;           % number of images in data set

%% 
for f=1:nimages
    %载入图像特征数据
    image_dir=sprintf('%s/%s/',opts.localdatapath,num2string(f,4)); % location descriptor
    inFName = fullfile(image_dir, sprintf('%s', texton_name));
    load(inFName, 'texton_ind');
    % 图像的大小
    wid = texton_ind.wid;
    hgt = texton_ind.hgt;
 %% compute histogram at the finest level
    pyramid_cell = cell(pyramidLevels,1);
    pyramid_cell{1} = zeros(binsHigh, binsHigh, dictionarySize);

    for i=1:binsHigh
        for j=1:binsHigh

            % find the coordinates of the current bin
            x_lo = floor(wid/binsHigh * (i-1));
            x_hi = floor(wid/binsHigh * i);
            y_lo = floor(hgt/binsHigh * (j-1));
            y_hi = floor(hgt/binsHigh * j);
            
            texton_patch = texton_ind.data( (texton_ind.x > x_lo) & (texton_ind.x <= x_hi) & ...
                                            (texton_ind.y > y_lo) & (texton_ind.y <= y_hi));
            
            % make histogram of features in bin
            pyramid_cell{1}(i,j,:) = hist(texton_patch, 1:dictionarySize)./length(texton_ind.data);
        end
    end
    
     %% compute histograms at the coarser levels
        num_bins = binsHigh/2;
        for l = 2:pyramidLevels
            pyramid_cell{l} = zeros(num_bins, num_bins, dictionarySize);
            for i=1:num_bins
                for j=1:num_bins
                    pyramid_cell{l}(i,j,:) = ...
                        pyramid_cell{l-1}(2*i-1,2*j-1,:) + pyramid_cell{l-1}(2*i,2*j-1,:) + ...
                        pyramid_cell{l-1}(2*i-1,2*j,:) + pyramid_cell{l-1}(2*i,2*j,:);
                end
            end
            num_bins = num_bins/2;
        end
         %% stack all the histograms with appropriate weights
        pyramid = [];
        for l = 1:pyramidLevels-1
            pyramid = [pyramid pyramid_cell{l}(:)' .* 2^(-l)];
        end
        pyramid = [pyramid pyramid_cell{pyramidLevels}(:)' .* 2^(1-pyramidLevels)];    
        pyramid_all = [pyramid_all; pyramid];       
        
end

    pyramid_all=pyramid_all';
    save ([opts.globaldatapath,'/',pyramid_opts.name],'pyramid_all');
end

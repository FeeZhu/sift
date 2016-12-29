function [] = CalculateDictionary( opts, dictionary_opts)
% 计算视觉单词，k均值聚类 形成单词
% Detailed explanation goes here

dictionarySize = dictionary_opts.dictionarySize;
featureName=dictionary_opts.name;
featuretype=dictionary_opts.type;

%% 调用内置函数kmeans，效率极低。。。。。
%    image_dir=sprintf('%s/%s/',opts.localdatapath,num2string(1,4)); % location descriptor
%    inFName = fullfile(image_dir, sprintf('%s', featureName));
%    sift_descrips=load(inFName);
%    data = sift_descrips.descrips;
%    for i=2:nimages
%    image_dir=sprintf('%s/%s/',opts.localdatapath,num2string(i,4)); % location descriptor
%    inFName = fullfile(image_dir, sprintf('%s', featureName));
%    sift_descrips=load(inFName);
%    data = [data;sift_descrips.descrips];
%save ([opts.globaldatapath,'/',featuretype],'data');
%   [IDX,C]=kmeans(data,dictionarySize);
%% matlab kmeans
    nimages=opts.ntraning;    %train images
    niters=100;                     %maximum iterations
    
    ndata=0;
    data=[];
    f=1;
    while(ndata<dictionarySize)
        
        image_dir=sprintf('%s/%s/',opts.localdatapath,num2string(f,4)); % location descriptor
        inFName = fullfile(image_dir, sprintf('%s', featureName));
        load(inFName, 'features');
        data = [data;features.descrips];
    
        centres = zeros(dictionarySize, size(data,2));
        [ndata, data_dim] = size(data);
        [ncentres, dim] = size(centres);
        f=f+1;
    end
    %%
    %设置初始聚类中心,聚类中心的选择直接影响到聚类结果
    perm = randperm(ndata);
    perm = perm(1:ncentres);
    centres = data(perm, :);
    
    num_points=zeros(1,dictionarySize);
    old_centres = centres;   
    
    for n=1:niters
        e2=max(max(abs(centres - old_centres)));
        inError(n)=e2;
        old_centres = centres;
        tempc = zeros(ncentres, dim);
        num_points=zeros(1,ncentres);
        
        for i=1:nimages
            image_dir=sprintf('%s/%s/',opts.localdatapath,num2string(i,4)); % location descriptor
            inFName = fullfile(image_dir, sprintf('%s',featureName));
            
            load(inFName,'features');
            data = features.descrips;
            [ndata, data_dim] = size(data);
            
            id = eye(ncentres);
            d2 = EuclideanDistance(data,centres);
             [minvals, index] = min(d2', [], 1);
            post = id(index,:); % matrix, if word i is in cluster j, post(i,j)=1, else 0;
            
            num_points = num_points + sum(post, 1);
            
            for j = 1:ncentres
                tempc(j,:) =  tempc(j,:)+sum(data(find(post(:,j)),:), 1);
            end
            
        end
        
        for j = 1:ncentres
            if num_points(j)>0
                centres(j,:) =  tempc(j,:)/num_points(j);
            end
        end
        if n > 1
            % Test for termination
            
            %Threshold
            ThrError=0.009;
            
            if max(max(abs(centres - old_centres))) <0.009
                dictionary= centres;
                fprintf('Saving texton dictionary\n');
                save ([opts.globaldatapath,'/',featuretype],'dictionary');      % save the settings of descriptor in opts.globaldatapath
                break;
            end
            
            fprintf('The %d th interation finished \n',n);
        end
        
    end
    
    save ([opts.globaldatapath,'/',dictionary_opts.name,'_settings'],'dictionary_opts');
    
end


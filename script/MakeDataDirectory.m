function []=MakeDataDirectory(opts)
% makes a directory in 'opts.datapath' descriptors containing 
% a directory for all images in the dataset

% /data
if exist([opts.dataPath],'dir')~=7
    mkdir(opts.dataPath)
end


%/data/global
if exist([opts.dataPath,'/global'],'dir')~=7
    mkdir(opts.dataPath,'global')
end

%/data/local
if exist([opts.dataPath,'/local'],'dir')~=7 % if the dir is not exist, then create it
    mkdir(opts.dataPath,'local')
    for ii=1:opts.nimages
        mkdir(sprintf('%s/local',opts.dataPath),num2string(ii,4));     
    end
end



        
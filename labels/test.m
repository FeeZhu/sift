clc; clear;

ini;

image_names=[];
labels_test=[];
testset=[];
classes={};

file_label = fopen('labels.txt');
class_names = textscan(file_label,'%s');
fclose(file_label);
[num_class, b] = size(class_names{1,1});
classes = class_names{1,1};

num_imgs = 0;  %²âÊÔÑù±¾
for i = 1 : num_class
   class_name = classes{i,1};
    picstr = dir([pre_data_path, '/testing/', class_name, '/*.tif']);
    
    [row,col] = size(picstr);
    picgather = cell(row,1);
    
    for j = 1 : row
        num_imgs = num_imgs + 1
        image_names{num_imgs}=['testing/', class_name,'/' picstr(j).name];
        labels_test(num_imgs,1)=i;
        testset(num_imgs,1)=1;
    end
end
 
save('image_names','image_names');
save('labels_test','labels_test');
testset=logical(testset);
save('testset','testset');
save('classes', 'classes');
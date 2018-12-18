
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hyperspectral Image Classification
% Author: Zijian Liu
% Date: 2018/12/18 Tue
% DataSet: AVIRIS (HSI)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% initialization
clc, clear all;
% load data: im is the hyperspectral image (several freq)
%            imGIS is the class label of HSI
load data.mat; 
[row,col,dim] = size(im);
Std = std(std(im));     
Mean = mean(mean(im));
for i=1:row
    for j=1:col
        im(i,j,:) = (im(i,j,:) - Mean)./ Std; % regulization
    end
end
%% Calculate the position of the class center points
Centres = zeros(17,1,dim);
cnt = zeros(17,1);
for i=1:2:row
    for j=1:col
        Centres(imGIS(i,j)+1,1,:) = Centres(imGIS(i,j)+1,1,:) + im(i,j,:);
        cnt(imGIS(i,j)+1,:) = cnt(imGIS(i,j)+1,:) + 1;
    end
end

for i = 1:17
    if cnt(i)>0
        Centres(i,1,:) = Centres(i,1,:) / cnt(i);
    end
end
Centres(1,:,:) = []; % remove the background

%% Accurancy test
C = 0;B=0;
for i = 2:2:row
    for j = 1:col
        M = [];
        if imGIS(i,j) ~= 0 % background need not to be test
            B = B + 1;
        for k = 1:16
            a = reshape(im(i,j,:)-Centres(k,1,:),[1,200]);
            M = [M,norm(a,2)];
        end
        [~,cls] = min(M);
        if cls == imGIS(i,j)
            C = C + 1;
        else
%             disp(cls)
%             disp(imGIS(100+i,j)+1)
        end
        end
    end
end
fprintf('Total Number is %d\nRecognized Number is %d\nTest Accurancy is %.2f%%\n',B,C,(C/B*100))

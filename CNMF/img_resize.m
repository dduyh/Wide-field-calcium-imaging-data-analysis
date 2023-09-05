clc
clear
close all

%%
folderPath = 'D:\duyh\widefield\20210330\1\';
load([folderPath 'DF_F0_4_gaussion1.mat']);
load([folderPath 'mask.mat']);
ImgSeq = DF_F0_2;
%%
record = zeros(size(ImgSeq));

for i = 1:size(ImgSeq,3)
    Frame = ImgSeq(:,:,i);
    Frame(Frame<2) = 0;
    Frame(mask == 0) = nan;
    record(:,:,i) = Frame(:,:);
end

save([folderPath 'ImgSeq_2sup.mat'], 'record');


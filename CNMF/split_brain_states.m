clc
clear
close all

%%
folderPath = 'D:\duyh\widefield\20210330\1\';
load([folderPath 'ImgSeq_2sup.mat']);
load([folderPath 'uvResults.mat']);
load([folderPath 'brain_state_labels.mat'],'labels_frame');

ImgSeq_all = record;
uvHS_all = uvHS;

rem_frame_all = find(labels_frame(1,:) == 1);
wake_frame_all = find(labels_frame(1,:) == 2);
nrem_frame_all = find(labels_frame(1,:) == 3);
% phasic_rem = find(labels_frame(2,:) == 4);

%%
record = ImgSeq_all(:,:,rem_frame_all(:));
save([folderPath 'REM_all\record.mat'],'record')
%%
record = ImgSeq_all(:,:,wake_frame_all(:));
save([folderPath 'Wake_all\record.mat'],'record')
%%
record = ImgSeq_all(:,:,nrem_frame_all(:));
save([folderPath 'NREM_all\record.mat'],'record')

% %%
% uvHS = uvHS_all(:,:,rem_frame_all(:));
% save([folderPath 'REM_all\uvResults.mat'],'uvHS')
% %%
% uvHS = uvHS_all(:,:,wake_frame_all(:));
% save([folderPath 'Wake_all\uvResults.mat'],'uvHS')
% %%
% uvHS = uvHS_all(:,:,nrem_frame_all(:));
% save([folderPath 'NREM_all\uvResults.mat'],'uvHS')

clc
clear
close all

%%
folderPath = 'D:\duyh\widefield\20210513\';
load([folderPath 'ImgSeq.mat']);
load([folderPath 'uvResults.mat']);

ImgSeq_all = ImgSeq;
uvHS_all = uvHS;
uvCLG_all = uvCLG;

load('D:\duyh\widefield\20210513\labelled_0513.mat')
% figure();
labels = imresize(labels_align_video, [1 50000]);
labels = round(labels);
% subplot(4,1,1); imagesc(labels);

phasic_rem = find(labels(1,:) == 0);
tonic_rem = find(labels(1,:) == 1);
rem_frame_all = union(phasic_rem,tonic_rem); % rem_frame
% subplot(4,1,2); hist(rem,50); xlim([0,50000]);

wake_frame_all = find(labels(1,:) == 2);
% subplot(4,1,3); hist(wake,50); xlim([0,50000]);

nrem_frame_all = find(labels(1,:) == 3);
% subplot(4,1,4); hist(nrem,50); xlim([0,50000]);

rem_frame_300 = [18393:18491 19779:19825 47019:47027 47192:47263 47424:47467 47971:47999]; % rem_frame

wake_frame_300 = [13265:13276 14432:14443 14512:14521 15039:15050 15135:15147 15168:15179 15222:15236 ...
    15447:15460 15539:15552 15699:15711 15804:15819 15855:15865 15897:15907 24322:24409 ...
    30872:30882 31472:31481 31586:31596 45559:45573]; % wake_frame

nrem_frame_300 = [16209:16220 16348:16358 16949:16959 17303:17312 17396:17410 17436:17450 17681:17693 ...
    45732:45743 45788:45800 45842:45853 45891:45941 46035:46049 46117:46161 46323:46333 ...
    46368:46381 46428:46443 46598:46610 46645:46655]; % nrem_frame

%%
ImgSeq = ImgSeq_all(:,:,rem_frame_all(:));
save([folderPath 'rem_all\ImgSeq.mat'],'ImgSeq')
%%
ImgSeq = ImgSeq_all(:,:,wake_frame_all(:));
save([folderPath 'wake_all\ImgSeq.mat'],'ImgSeq')
%%
ImgSeq = ImgSeq_all(:,:,nrem_frame_all(:));
save([folderPath 'nrem_all\ImgSeq.mat'],'ImgSeq')
%%
ImgSeq = ImgSeq_all(:,:,rem_frame_300(:));
save([folderPath 'rem_300\ImgSeq.mat'],'ImgSeq')
%%
ImgSeq = ImgSeq_all(:,:,wake_frame_300(:));
save([folderPath 'wake_300\ImgSeq.mat'],'ImgSeq')
%%
ImgSeq = ImgSeq_all(:,:,nrem_frame_300(:));
save([folderPath 'nrem_300\ImgSeq.mat'],'ImgSeq')


%%
uvHS = uvHS_all(:,:,rem_frame_all(:));
uvCLG = uvCLG_all(:,:,rem_frame_all(:));
save([folderPath 'rem_all\uvResults.mat'],'uvHS','uvCLG')
%%
uvHS = uvHS_all(:,:,wake_frame_all(:));
uvCLG = uvCLG_all(:,:,wake_frame_all(:));
save([folderPath 'wake_all\uvResults.mat'],'uvHS','uvCLG')
%%
uvHS = uvHS_all(:,:,nrem_frame_all(:));
uvCLG = uvCLG_all(:,:,nrem_frame_all(:));
save([folderPath 'nrem_all\uvResults.mat'],'uvHS','uvCLG')
%%
uvHS = uvHS_all(:,:,rem_frame_300(:));
uvCLG = uvCLG_all(:,:,rem_frame_300(:));
save([folderPath 'rem_300\uvResults.mat'],'uvHS','uvCLG')
%%
uvHS = uvHS_all(:,:,wake_frame_300(:));
uvCLG = uvCLG_all(:,:,wake_frame_300(:));
save([folderPath 'wake_300\uvResults.mat'],'uvHS','uvCLG')
%%
uvHS = uvHS_all(:,:,nrem_frame_300(:));
uvCLG = uvCLG_all(:,:,nrem_frame_300(:));
save([folderPath 'nrem_300\uvResults.mat'],'uvHS','uvCLG')

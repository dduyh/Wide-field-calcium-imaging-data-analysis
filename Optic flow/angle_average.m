clc
clear
close all

%%
folderPath = 'D:\duyh\widefield\20210330\1\wake_2\';
%folderPath = 'D:\duyh\paper\OFAMM-v1.0\OFAMM-Sample-Data-master\OFAMM-Sample-Data-master\Simulated_WFI_Data\TravellingCircularWave\';
load([folderPath 'ImgSeq.mat']);
load([folderPath 'mask.mat']);
load([folderPath 'uvResults.mat']);

%% Average Flow Field

%% CLG
% figure(1);
% 
% frameNumber = 25;
% 
% % imagesc frame and mask
% thisframe = ImgSeq(:,:,frameNumber).*mask;
% imagesc(thisframe,[0,30]);
% colormap jet;
% axis square
% axis off
% hold on;
% 
% % show optical flow
% angle_CLG = angle(conj(uvCLG(:,:,:)));
% uvCLG_180 = uvCLG;
% uvCLG_180(angle_CLG < 0) = - uvCLG(angle_CLG < 0);
% 
% mean_uv = mean(uvCLG_180,3);
% 
% u = real(mean_uv);  u = u.*mask;
% v = imag(mean_uv);  v = v.*mask;
% 
% [gridXDown,gridYDown,OpticalFlowDown_u] = mean_downsample(u,3);
% [~,~,OpticalFlowDown_v]                 = mean_downsample(v,3);
% quiver(gridXDown,gridYDown,OpticalFlowDown_u(:,:),OpticalFlowDown_v(:,:),2,'color','w','LineWidth',0.75,'ShowArrowHead','off');
% 
% %quiver(1:size(ImgSeq,1),1:size(ImgSeq,2),u(:,:),v(:,:),2,'color','w','LineWidth',0.75);
% 
% % f = getframe(gcf);
% % imwrite(f.cdata,[folderPath 'Average_angle.png']);

%% HS

figure(2);

%frameNumber = 32;

% imagesc frame and mask
mean_frame = mean(ImgSeq,3);
mean_frame = mean_frame.*mask;
imagesc(mean_frame,[0,30]);
colormap jet;
axis square
axis off
hold on;

% show optical flow
angle_HS = angle(conj(uvHS(:,:,:)));
uvHS_180 = uvHS;
uvHS_180(angle_HS < 0) = - uvHS(angle_HS < 0);

mean_uv = mean(uvHS_180,3);

u = real(mean_uv);  u = u.*mask;
v = imag(mean_uv);  v = v.*mask;

[gridXDown,gridYDown,OpticalFlowDown_u] = mean_downsample(u,3);
[~,~,OpticalFlowDown_v]                 = mean_downsample(v,3);
quiver(gridXDown,gridYDown,OpticalFlowDown_u(:,:),OpticalFlowDown_v(:,:),2,'color','w','LineWidth',0.75,'ShowArrowHead','off');

%quiver(1:size(ImgSeq,1),1:size(ImgSeq,2),u(:,:),v(:,:),2,'color','w','LineWidth',0.75);

f = getframe(gcf);
imwrite(f.cdata,[folderPath 'Average_angle_img_wake_2.png']);

%% Speeds and Angles histogram
Nbins = 15;

minSp = inf;
maxSp = 0;

%% CLG
% InstSpDirCLG = reshape(uvCLG_180, size(uvCLG_180,1)*size(uvCLG_180,2),size(uvCLG_180,3));
% 
% InstSpDirCLG(isnan(InstSpDirCLG))=0;
% InstSpDirCLG(isinf(InstSpDirCLG))=0;
% 
% SpCLG = abs(InstSpDirCLG);
% minSpCLG = quantile(SpCLG(:),0.001);
% maxSpCLG = quantile(SpCLG(:),0.999);
% AngCLG = angle(conj(InstSpDirCLG));
% 
% minSp = min(minSp,minSpCLG);
% maxSp = max(maxSp,maxSpCLG);
% 
% binSize = (maxSp - minSp)/Nbins;
% bins = (binSize/2+minSp):binSize:maxSp;
% 
binsAll = [];
% 
% [binsCLG, ~] = hist(SpCLG(:),bins);
% binsCLG = 100*binsCLG/length(SpCLG(:));
% binsAll = [binsAll;binsCLG];
% InstSpCLG_ele = binsCLG;
% InstSpCLG_bins = bins;
% 
% [tCLG, rCLG] = rose(AngCLG(:),Nbins);
% rCLG = rCLG/max(rCLG);
% InstDirCLG_rho = rCLG;
% InstDirCLG_theta = tCLG;
% 
% h = figure;
% set(h,'numbertitle','off','name','Instantaneous Speeds and Angles histogram','units','inches','position',[1 3.5 6 2.5]);
% c1 = [0.08,0.17,0.55];
% c2 = [0.55,0,0];
% figure(h);
% subplot(121); cla;
% h_bar = bar(bins,binsAll');
% if length(h_bar)>1
%     set(h_bar(1),'facecolor',c1)
%     set(h_bar(2),'facecolor',c2)
% elseif length(h_bar)==1
%     set(h_bar,'facecolor',c1)
% end
% legend('CLG','Location','best')
% 
% maxY = max(binsAll(:));
% xlim([min(bins)-binSize, max(bins)+binSize]);
% ylim([0 maxY*1.1]);
% set(gca,'box','off','TickDir','out');
% xlabel(sprintf('Inst. Speed (p/f)')); ylabel('Percentage');
% 
% figure(h);
% subplot(122); cla;
% 
% hp = polar(tCLG,rCLG);
% set(hp,'color',c1);

%% HS
InstSpDirHS = reshape(uvHS_180, size(uvHS_180,1)*size(uvHS_180,2), size(uvHS_180,3));

InstSpDirHS(isnan(InstSpDirHS))=0;
InstSpDirHS(isinf(InstSpDirHS))=0;

SpHS = abs(InstSpDirHS);
minSpHS = quantile(SpHS(:),0.001);
maxSpHS = quantile(SpHS(:),0.999);
AngHS = angle(conj(InstSpDirHS));

minSp = min(minSp,minSpHS);
maxSp = max(maxSp,maxSpHS);

% calculate bin centers
binSize = (maxSp - minSp)/Nbins;
bins = (binSize/2+minSp):binSize:maxSp;

%binsAll = [];

[binsHS, ~] = hist(SpHS(:),bins);
binsHS = 100*binsHS/length(SpHS(:));
binsAll = [binsAll;binsHS];
InstSpHS_ele = binsHS;
InstSpHS_bins = bins;

[tHS, rHS] = rose(AngHS(:),Nbins);
rHS = rHS/max(rHS);
InstDirHS_rho = rHS;
InstDirHS_theta = tHS;

h = figure;
set(h,'numbertitle','off','name','Instantaneous Speeds and Angles histogram','units','inches','position',[1 3.5 6 2.5]);
c1 = [0.08,0.17,0.55];
c2 = [0.55,0,0];
figure(h);
subplot(121); cla;
h_bar = bar(bins,binsAll');
if length(h_bar)>1
    set(h_bar(1),'facecolor',c1)
    set(h_bar(2),'facecolor',c2)
elseif length(h_bar)==1
    set(h_bar,'facecolor',c2)
end

maxY = max(binsAll(:));
xlim([min(bins)-binSize, max(bins)+binSize]);
ylim([0 maxY*1.1]);
set(gca,'box','off','TickDir','out');
xlabel(sprintf('Inst. Speed (p/f)')); ylabel('Percentage');

figure(h);
subplot(122); cla;
% hp = polar(tCLG,rCLG);
% set(hp,'color',c1);
% hold on;

hp = polar(tHS,rHS);
set(hp,'color',c2);
hold off;
% subplot(121);
% legend('CLG','HS','Location','best')

f = getframe(gcf);
imwrite(f.cdata,[folderPath 'Average_angle_hist_wake_2.png']);

clc
clear
close all

%%
folderPath = 'D:\duyh\widefield\20210513\';
load([folderPath 'ImgSeq.mat']);
load([folderPath 'mask.mat']);
load([folderPath 'uvResults.mat']);
load([folderPath 'SourceSinkSpiralResults.mat']);
% load([folderPath 'brain_state_labels.mat'],'labels_frame');


% rem = find(labels_frame(1,:) == 1);
% wake = find(labels_frame(1,:) == 2);
% nrem = find(labels_frame(1,:) == 3);
% phasic_rem = find(labels_frame(2,:) == 4);

frame = zeros(3,300);
frame(1,:) = [13265:13276 14432:14443 14512:14521 15039:15050 15135:15147 15168:15179 15222:15236 ...
    15447:15460 15539:15552 15699:15711 15804:15819 15855:15865 15897:15907 24322:24409 ...
    30872:30882 31472:31481 31586:31596 45559:45573]; % wake_frame
frame(2,:) = [16209:16220 16348:16358 16949:16959 17303:17312 17396:17410 17436:17450 17681:17693 ...
    45732:45743 45788:45800 45842:45853 45891:45941 46035:46049 46117:46161 46323:46333 ...
    46368:46381 46428:46443 46598:46610 46645:46655]; % nrem_frame
frame(3,:) = [18393:18491 19779:19825 47019:47027 47192:47263 47424:47467 47971:47999]; % rem_frame

%% Create video
writerObj=VideoWriter([folderPath 'recording_HS_5.mp4'], 'MPEG-4');
frame_rate = 10;
writerObj.FrameRate = frame_rate;
open(writerObj);

figure(1); % manually Maximize the figure window
ht = suptitle('Optical Flow Analysis by HS method');
set(ht, 'Position', [0.5 -0.1 0],'fontname','Times New Roman','fontsize',18)
titles = {'Wake';'NREM';'REM'} ;

pos = zeros(3,4); %subfigure position
pos(1,:) = [0.0200    0.1100    0.3    0.8150];
pos(2,:) = [0.3408    0.1100    0.3    0.8150];
pos(3,:) = [0.6616    0.1100    0.3    0.8150];
% pos(4,:) = [0.4    0.08    0.4    0.4];

%% HS method

source = SoSi.HS.source;
sink = SoSi.HS.sink;
contour_source = SoSi.HS.contour_source;
contour_sink = SoSi.HS.contour_sink;

for i = 1:300
    for j = 1:3
        frameNumber = frame(j,i);
        
        % imagesc frame and mask
        h1 = subplot(1,3,j);
        set(h1, 'Position', pos(j,:))
        thisframe = ImgSeq(:,:,frameNumber).*mask;
        imagesc(thisframe,[0,30]);
        colormap jet;
        axis square
        axis off
        title(titles{j},'fontname','Times New Roman','Color','k','FontSize',20);
        h = text(40.0,85.0,['frame: ' num2str(frame(j,i)) '  time: ' num2str(floor(frame(j,i)./frame_rate)) 's']);
        set(h,'fontname','Times New Roman','fontsize',18,'HorizontalAlignment','center');
        hold on;
        
        % show optical flow
        thisuv = uvHS(:,:,frameNumber);
        u = real(thisuv);  u = u.*mask;
        v = imag(thisuv);  v = v.*mask;
        [gridXDown,gridYDown,OpticalFlowDown_u] = mean_downsample(u,3);
        [~,~,OpticalFlowDown_v]                 = mean_downsample(v,3);
        quiver(gridXDown,gridYDown,OpticalFlowDown_u(:,:,1),OpticalFlowDown_v(:,:,1),2,'color','w','LineWidth',0.75);
        hold on;
        
        % display source/sink (Simple or Node source/sink)
        markersize = 3;
        linewidth = 1.2;
        source_color = 'g';
        sink_color = 'w';
        contour_source_color = 'g';
        contour_sink_color = 'w';
        
        %find sources and display
        [~, sourceidx] = find(source(3,:) == frameNumber);
        for idx = sourceidx
            plot(source(1,idx),source(2,idx),'o','color',source_color,'markersize',markersize,'markerfacecolor',source_color)
            hold on;
            plot(contour_source{idx}.xy(1,:),contour_source{idx}.xy(2,:),'-','color',contour_source_color,'linewidth',linewidth)
            hold on
        end
        
        %find sinks and display
        [~, sinkidx] = find(sink(3,:) == frameNumber);
        for idx = sinkidx
            plot(sink(1,idx),sink(2,idx),'o','color',sink_color,'markersize',markersize,'markerfacecolor',sink_color)
            hold on;
            plot(contour_sink{idx}.xy(1,:),contour_sink{idx}.xy(2,:),'-','color',contour_sink_color,'linewidth',linewidth)
            hold on
        end
    end
    
    %     hBar = colorbar('east');
    hBar = colorbar('south');
    set(hBar, 'Position', [0.874    0.1733    0.08038    0.02150])
    % get(hBar, 'Position')
    %     set(hBar, 'Position', [0.7354    0.0823    0.0115    0.1426])
    hBar.Label.String = '\DeltaF / F';
    hBar.Label.FontSize = 12;
    
    fig = getframe(gcf);
    writeVideo(writerObj,fig.cdata);
end

close(writerObj);

%% Create video
writerObj=VideoWriter([folderPath 'recording_CLG_3.mp4'], 'MPEG-4');
frame_rate = 10;
writerObj.FrameRate = frame_rate;
open(writerObj);

figure(2); % manually Maximize the figure window
ht = suptitle('Optical Flow Analysis by CLG method');
set(ht, 'Position', [0.5 -0.1 0],'fontname','Times New Roman','fontsize',18)
titles = {'Wake';'NREM';'REM'} ;

pos = zeros(3,4); %subfigure position
pos(1,:) = [0.0200    0.1100    0.3    0.8150];
pos(2,:) = [0.3408    0.1100    0.3    0.8150];
pos(3,:) = [0.6616    0.1100    0.3    0.8150];
% pos(4,:) = [0.4    0.08    0.4    0.4];

%% CLG method

source = SoSi.CLG.source;
sink = SoSi.CLG.sink;
contour_source = SoSi.CLG.contour_source;
contour_sink = SoSi.CLG.contour_sink;

for i = 1:300
    for j = 1:3
        frameNumber = frame(j,i);
        
        % imagesc frame and mask
        h1 = subplot(1,3,j);
        set(h1, 'Position', pos(j,:))
        thisframe = ImgSeq(:,:,frameNumber).*mask;
        imagesc(thisframe,[0,30]);
        colormap jet;
        axis square
        axis off
        title(titles{j},'fontname','Times New Roman','Color','k','FontSize',20);
        h = text(40.0,85.0,['frame: ' num2str(frame(j,i)) '  time: ' num2str(floor(frame(j,i)./frame_rate)) 's']);
        set(h,'fontname','Times New Roman','fontsize',18,'HorizontalAlignment','center');
        hold on;
        
        % show optical flow
        thisuv = uvCLG(:,:,frameNumber);
        u = real(thisuv);  u = u.*mask;
        v = imag(thisuv);  v = v.*mask;
        [gridXDown,gridYDown,OpticalFlowDown_u] = mean_downsample(u,3);
        [~,~,OpticalFlowDown_v]                 = mean_downsample(v,3);
        quiver(gridXDown,gridYDown,OpticalFlowDown_u(:,:,1),OpticalFlowDown_v(:,:,1),2,'color','w','LineWidth',0.75);
        hold on;
        
        % display source/sink (Simple or Node source/sink)
        markersize = 3;
        linewidth = 1.2;
        source_color = 'g';
        sink_color = 'w';
        contour_source_color = 'g';
        contour_sink_color = 'w';
        
        %find sources and display
        [~, sourceidx] = find(source(3,:) == frameNumber);
        for idx = sourceidx
            plot(source(1,idx),source(2,idx),'o','color',source_color,'markersize',markersize,'markerfacecolor',source_color)
            hold on;
            plot(contour_source{idx}.xy(1,:),contour_source{idx}.xy(2,:),'-','color',contour_source_color,'linewidth',linewidth)
            hold on
        end
        
        %find sinks and display
        [~, sinkidx] = find(sink(3,:) == frameNumber);
        for idx = sinkidx
            plot(sink(1,idx),sink(2,idx),'o','color',sink_color,'markersize',markersize,'markerfacecolor',sink_color)
            hold on;
            plot(contour_sink{idx}.xy(1,:),contour_sink{idx}.xy(2,:),'-','color',contour_sink_color,'linewidth',linewidth)
            hold on
        end
    end
    
    %     hBar = colorbar('east');
    hBar = colorbar('south');
    set(hBar, 'Position', [0.874    0.1733    0.08038    0.02150])
    % get(hBar, 'Position')
    %     set(hBar, 'Position', [0.7354    0.0823    0.0115    0.1426])
    hBar.Label.String = '\DeltaF / F';
    hBar.Label.FontSize = 12;
    
    fig = getframe(gcf);
    writeVideo(writerObj,fig.cdata);
end

close(writerObj);


clc
clear
close all

%%
folderPath = 'D:\duyh\widefield\20210330\1\';
load([folderPath 'ImgSeq.mat']);
load([folderPath 'mask.mat']);
load([folderPath 'uvResults.mat']);
load([folderPath 'SourceSinkSpiralResults.mat']);
load([folderPath 'brain_state_labels.mat'],'labels_frame');

source = SoSi.HS.source;
sink = SoSi.HS.sink;
contour_source = SoSi.HS.contour_source;
contour_sink = SoSi.HS.contour_sink;

rem = find(labels_frame(1,:) == 1);
wake = find(labels_frame(1,:) == 2);
nrem = find(labels_frame(1,:) == 3);
phasic_rem = find(labels_frame(2,:) == 4);

frame = zeros(4,300);
frame(1,:) = [15211:15335 17546:17720]; % wake_frame
frame(2,:) = [8531:8580 8676:8730 8811:8895 9161:9270]; % nrem_frame
frame(3,:) = [13301:13600]; % phasic_rem_frame
frame(4,:) = [14201:14500]; % tonic_rem_frame

%% Create video
writerObj=VideoWriter('D:\duyh\widefield\20210330\1\recording_HS_4_state.mp4', 'MPEG-4');
writerObj.FrameRate = 12.5;
open(writerObj);
figure(1); % manually Maximize the figure window
titles = {'Wake';'NREM';'Phasic REM';'Tonic REM'} ;
      
pos = zeros(4,4); %subfigure position
pos(1,:) = [0.13    0.5538    0.4    0.4];
pos(2,:) = [0.4    0.5538    0.4    0.4];
pos(3,:) = [0.13    0.08    0.4    0.4];
pos(4,:) = [0.4    0.08    0.4    0.4];

%% HS method
for i = 1:300
    for j = 1:4
        frameNumber = frame(j,i);
        
        % imagesc frame and mask
        h1 = subplot(2,2,j);
        set(h1, 'Position', pos(j,:))
        thisframe = ImgSeq(:,:,frameNumber).*mask;
        imagesc(thisframe,[0,30]);
        colormap jet;
        axis square
        axis off
        title(titles{j},'fontname','Times New Roman','Color','k','FontSize',20);
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
    
    hBar = colorbar('east');
    % get(hBar, 'Position')
    set(hBar, 'Position', [0.7354    0.0823    0.0115    0.1426])
    hBar.Label.String = '\DeltaF / F';
    hBar.Label.FontSize = 12;
    
    fig = getframe(gcf);
    writeVideo(writerObj,fig.cdata);
end

close(writerObj);


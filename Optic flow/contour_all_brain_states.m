clc
clear
close all

%%
folderPath = 'D:\duyh\widefield\20210513\';
load([folderPath 'mask.mat']);
load([folderPath 'SourceSinkSpiralResults.mat']);
%load([folderPath 'brain_state_labels.mat'],'labels_frame');

%%
frame = cell(3,1);
% frame(1,:) = [13265:13276 14432:14443 14512:14521 15039:15050 15135:15147 15168:15179 15222:15236 ...
%     15447:15460 15539:15552 15699:15711 15804:15819 15855:15865 15897:15907 24322:24409 ...
%     30872:30882 31472:31481 31586:31596 45559:45573]; % wake_frame
% frame(2,:) = [16209:16220 16348:16358 16949:16959 17303:17312 17396:17410 17436:17450 17681:17693 ...
%     45732:45743 45788:45800 45842:45853 45891:45941 46035:46049 46117:46161 46323:46333 ...
%     46368:46381 46428:46443 46598:46610 46645:46655]; % nrem_frame
% frame(3,:) = [18393:18491 19779:19825 47019:47027 47192:47263 47424:47467 47971:47999]; % rem_frame

load('D:\duyh\widefield\20210513\labelled_0513.mat')
labels = imresize(labels_align_video, [1 50000]);
labels = round(labels);

frame{1} = find(labels(1,:) == 2); % wake_frame
frame{2} = find(labels(1,:) == 3); % nrem_frame
phasic_rem = find(labels(1,:) == 0);
tonic_rem = find(labels(1,:) == 1);
frame{3} = union(phasic_rem,tonic_rem); % rem_frame


%% HS
sink = SoSi.HS.sink;
contour_sink = SoSi.HS.contour_sink;
for i = 1:size(sink,2)
    sink_strength(i) = - contour_sink{i}.strength;
end
% sink_color_thershold = 60;
sink_color_thershold = quantile(sink_strength,0.99,2);
sink_contour_color = colormap(winter(sink_color_thershold));
sink_strength(sink_strength>sink_color_thershold) = sink_color_thershold;

source = SoSi.HS.source;
contour_source = SoSi.HS.contour_source;
for i = 1:size(source,2)
    source_strength(i) = contour_source{i}.strength;
end
% source_color_thershold = 60;
source_color_thershold = quantile(source_strength,0.99,2);
source_contour_color = colormap(hot(source_color_thershold));
source_strength(source_strength>source_color_thershold) = source_color_thershold;


%%
figure(1); % manually Maximize the figure window
ht = suptitle('Contours of Sources and Sinks of Brain States(All frames) by HS method');
set(ht, 'Position', [0.5 -0.02 0],'fontname','Times New Roman','fontsize',18)

titles = {'Wake Source';'NREM Source';'REM Source'; ...
          'Wake Sink';'NREM Sink';'REM Sink'} ;
      
%%      
for i = 1:3
%plot sink contour

h = subplot(2,3,(i+3));
imshow(mask)
hold on

%find sink and display
for frameNumber = frame{i}
    [~, sinkidx] = find(sink(3,:) == frameNumber);
    
    for idx = sinkidx
        markersize = 3;
        sink_color = 'b';
        plot(sink(1,idx),sink(2,idx),'o','color',sink_color,'markersize',markersize,'markerfacecolor',sink_color)
        hold on;
        
        linewidth = 1.2;
        contour_sink_color = sink_contour_color(ceil(sink_strength(idx)),:);
        plot(contour_sink{idx}.xy(1,:),contour_sink{idx}.xy(2,:),'-','color',contour_sink_color,'linewidth',linewidth)
        hold on
    end
end
title(h,titles{i+3},'fontname','Times New Roman','Color','k','FontSize',15);

%plot source contour

h = subplot(2,3,i);
imshow(mask)
hold on

%find sources and display
for frameNumber = frame{i}
    [~, sourceidx] = find(source(3,:) == frameNumber);
    
    for idx = sourceidx
        markersize = 3;
        source_color = 'r';
        plot(source(1,idx),source(2,idx),'o','color',source_color,'markersize',markersize,'markerfacecolor',source_color)
        hold on;
        
        linewidth = 1.2;
        contour_source_color = source_contour_color(ceil(source_strength(idx)),:);
        plot(contour_source{idx}.xy(1,:),contour_source{idx}.xy(2,:),'-','color',contour_source_color,'linewidth',linewidth)
        hold on
    end
end
title(h,titles{i},'fontname','Times New Roman','Color','k','FontSize',15);

end

%% CLG
sink = SoSi.CLG.sink;
contour_sink = SoSi.CLG.contour_sink;
for i = 1:size(sink,2)
    sink_strength(i) = - contour_sink{i}.strength;
end
% sink_color_thershold = 60;
sink_color_thershold = quantile(sink_strength,0.99,2);
sink_contour_color = colormap(winter(sink_color_thershold));
sink_strength(sink_strength>sink_color_thershold) = sink_color_thershold;

source = SoSi.CLG.source;
contour_source = SoSi.CLG.contour_source;
for i = 1:size(source,2)
    source_strength(i) = contour_source{i}.strength;
end
% source_color_thershold = 60;
source_color_thershold = quantile(source_strength,0.99,2);
source_contour_color = colormap(hot(source_color_thershold));
source_strength(source_strength>source_color_thershold) = source_color_thershold;


%%
figure(2); % manually Maximize the figure window
ht = suptitle('Contours of Sources and Sinks of Brain States(All frames) by CLG method');
set(ht, 'Position', [0.5 -0.02 0],'fontname','Times New Roman','fontsize',18)

titles = {'Wake Source';'NREM Source';'REM Source'; ...
          'Wake Sink';'NREM Sink';'REM Sink'} ;
      
%%      
for i = 1:3
%plot sink contour

h = subplot(2,3,(i+3));
imshow(mask)
hold on

%find sink and display
for frameNumber = frame{i}
    [~, sinkidx] = find(sink(3,:) == frameNumber);
    
    for idx = sinkidx
        markersize = 3;
        sink_color = 'b';
        plot(sink(1,idx),sink(2,idx),'o','color',sink_color,'markersize',markersize,'markerfacecolor',sink_color)
        hold on;
        
        linewidth = 1.2;
        contour_sink_color = sink_contour_color(ceil(sink_strength(idx)),:);
        plot(contour_sink{idx}.xy(1,:),contour_sink{idx}.xy(2,:),'-','color',contour_sink_color,'linewidth',linewidth)
        hold on
    end
end
title(h,titles{i+3},'fontname','Times New Roman','Color','k','FontSize',15);

%plot source contour

h = subplot(2,3,i);
imshow(mask)
hold on

%find sources and display
for frameNumber = frame{i}
    [~, sourceidx] = find(source(3,:) == frameNumber);
    
    for idx = sourceidx
        markersize = 3;
        source_color = 'r';
        plot(source(1,idx),source(2,idx),'o','color',source_color,'markersize',markersize,'markerfacecolor',source_color)
        hold on;
        
        linewidth = 1.2;
        contour_source_color = source_contour_color(ceil(source_strength(idx)),:);
        plot(contour_source{idx}.xy(1,:),contour_source{idx}.xy(2,:),'-','color',contour_source_color,'linewidth',linewidth)
        hold on
    end
end
title(h,titles{i},'fontname','Times New Roman','Color','k','FontSize',15);

end

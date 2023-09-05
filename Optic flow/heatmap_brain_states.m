clc
clear
close all

%%
load('D:\duyh\widefield\20210513\SourceSinkSpiralResults.mat')
%load('D:\duyh\widefield\20210330\1\brain_state_labels.mat','labels_frame')

%%
sink = SoSi.HS.sink;
contour_sink = SoSi.HS.contour_sink;
source = SoSi.HS.source;
contour_source = SoSi.HS.contour_source;

% rem = find(labels_frame(1,:) == 1);
% wake = find(labels_frame(1,:) == 2);
% nrem = find(labels_frame(1,:) == 3);
% phasic_rem = find(labels_frame(2,:) == 4);
% tonic_rem = rem(~ismember(rem, phasic_rem));

frame = zeros(3,300);
frame(1,:) = [13265:13276 14432:14443 14512:14521 15039:15050 15135:15147 15168:15179 15222:15236 ...
    15447:15460 15539:15552 15699:15711 15804:15819 15855:15865 15897:15907 24322:24409 ...
    30872:30882 31472:31481 31586:31596 45559:45573]; % wake_frame
frame(2,:) = [16209:16220 16348:16358 16949:16959 17303:17312 17396:17410 17436:17450 17681:17693 ...
    45732:45743 45788:45800 45842:45853 45891:45941 46035:46049 46117:46161 46323:46333 ...
    46368:46381 46428:46443 46598:46610 46645:46655]; % nrem_frame
frame(3,:) = [18393:18491 19779:19825 47019:47027 47192:47263 47424:47467 47971:47999]; % rem_frame

for i = 1:size(source,2)
    source_strength(i) = contour_source{i}.strength;
end
for i = 1:size(sink,2)
    sink_strength(i) = contour_sink{i}.strength;
end

%% HS

figure(1); % manually Maximize the figure window
ht = suptitle('Strength of Sources and Sinks of Brain States(300 frames) by HS method');
set(ht, 'Position', [0.5 -0.02 0],'fontname','Times New Roman','fontsize',18)

titles = {'Wake Source';'NREM Source';'REM Source'; ...
          'Wake Sink';'NREM Sink';'REM Sink'} ;

%%
for i = 1:3
% plot sink heatmap

    h = subplot(2,3,(i+3));
    title(h,titles{i+3},'fontname','Times New Roman','Color','k','FontSize',15);
    hold on
    
    heat_im = zeros(69,69);
    
    for frameNumber = frame(i,:)
        [~, sinkidx] = find(sink(3,:) == frameNumber);
        
        for idx = sinkidx
            for x = 1:69
                xq = repmat(x,[1,69]);
                yq = [1:69];
                in = inpolygon(xq,yq,contour_sink{idx}.xy(1,:),contour_sink{idx}.xy(2,:));
                heat_im(xq(in),yq(in)) = heat_im(xq(in),yq(in)) + sink_strength(idx);
            end
        end
    end
    
    heat_im = heat_im./length(frame(i,:));
    imagesc(heat_im');
    set(gca,'YDir','reverse')
    color = colormap(h,mymap4);
    %hBar = colorbar;
    caxis(h,[-1 1])
    axis square
    axis off
    hold off
    
% plot source heatmap
    
    h = subplot(2,3,i);
    title(h,titles{i},'fontname','Times New Roman','Color','k','FontSize',15);
    hold on
    
    heat_im = zeros(69,69);
    
    for frameNumber = frame(i,:)
        [~, sourceidx] = find(source(3,:) == frameNumber);
        
        for idx = sourceidx
            for x = 1:69
                xq = repmat(x,[1,69]);
                yq = [1:69];
                in = inpolygon(xq,yq,contour_source{idx}.xy(1,:),contour_source{idx}.xy(2,:));
                heat_im(xq(in),yq(in)) = heat_im(xq(in),yq(in)) + source_strength(idx);
            end
        end
    end
    
    heat_im = heat_im./length(frame(i,:));
    imagesc(heat_im');
    set(gca,'YDir','reverse')
    color = colormap(h,mymap4);
    caxis(h,[-1 1])
    axis square
    axis off
    hold off
    
end

hBar = colorbar(h,'east');
get(hBar, 'Position');
set(hBar, 'Position', [0.086458333333333,0.344731977818854,0.014583333333334,0.344115834873691]);
hBar.Label.String = 'Mean Source/Sink Strength';
hBar.Label.FontSize = 12;

%%
sink = SoSi.CLG.sink;
contour_sink = SoSi.CLG.contour_sink;
source = SoSi.CLG.source;
contour_source = SoSi.CLG.contour_source;

% rem = find(labels_frame(1,:) == 1);
% wake = find(labels_frame(1,:) == 2);
% nrem = find(labels_frame(1,:) == 3);
% phasic_rem = find(labels_frame(2,:) == 4);
% tonic_rem = rem(~ismember(rem, phasic_rem));

frame = zeros(3,300);
frame(1,:) = [13265:13276 14432:14443 14512:14521 15039:15050 15135:15147 15168:15179 15222:15236 ...
    15447:15460 15539:15552 15699:15711 15804:15819 15855:15865 15897:15907 24322:24409 ...
    30872:30882 31472:31481 31586:31596 45559:45573]; % wake_frame
frame(2,:) = [16209:16220 16348:16358 16949:16959 17303:17312 17396:17410 17436:17450 17681:17693 ...
    45732:45743 45788:45800 45842:45853 45891:45941 46035:46049 46117:46161 46323:46333 ...
    46368:46381 46428:46443 46598:46610 46645:46655]; % nrem_frame
frame(3,:) = [18393:18491 19779:19825 47019:47027 47192:47263 47424:47467 47971:47999]; % rem_frame

for i = 1:size(source,2)
    source_strength(i) = contour_source{i}.strength;
end
for i = 1:size(sink,2)
    sink_strength(i) = contour_sink{i}.strength;
end

%% CLG

figure(2); % manually Maximize the figure window
ht = suptitle('Strength of Sources and Sinks of Brain States(300 frames) by CLG method');
set(ht, 'Position', [0.5 -0.02 0],'fontname','Times New Roman','fontsize',18)

titles = {'Wake Source';'NREM Source';'REM Source'; ...
          'Wake Sink';'NREM Sink';'REM Sink'} ;

%%
for i = 1:3
% plot sink heatmap

    h = subplot(2,3,(i+3));
    title(h,titles{i+3},'fontname','Times New Roman','Color','k','FontSize',15);
    hold on
    
    heat_im = zeros(69,69);
    
    for frameNumber = frame(i,:)
        [~, sinkidx] = find(sink(3,:) == frameNumber);
        
        for idx = sinkidx
            for x = 1:69
                xq = repmat(x,[1,69]);
                yq = [1:69];
                in = inpolygon(xq,yq,contour_sink{idx}.xy(1,:),contour_sink{idx}.xy(2,:));
                heat_im(xq(in),yq(in)) = heat_im(xq(in),yq(in)) + sink_strength(idx);
            end
        end
    end
    
    heat_im = heat_im./length(frame(i,:));
    imagesc(heat_im');
    set(gca,'YDir','reverse')
    color = colormap(h,mymap4);
    %hBar = colorbar;
    caxis(h,[-1 1])
    axis square
    axis off
    hold off
    
% plot source heatmap
    
    h = subplot(2,3,i);
    title(h,titles{i},'fontname','Times New Roman','Color','k','FontSize',15);
    hold on
    
    heat_im = zeros(69,69);
    
    for frameNumber = frame(i,:)
        [~, sourceidx] = find(source(3,:) == frameNumber);
        
        for idx = sourceidx
            for x = 1:69
                xq = repmat(x,[1,69]);
                yq = [1:69];
                in = inpolygon(xq,yq,contour_source{idx}.xy(1,:),contour_source{idx}.xy(2,:));
                heat_im(xq(in),yq(in)) = heat_im(xq(in),yq(in)) + source_strength(idx);
            end
        end
    end
    
    heat_im = heat_im./length(frame(i,:));
    imagesc(heat_im');
    set(gca,'YDir','reverse')
    color = colormap(h,mymap4);
    caxis(h,[-1 1])
    axis square
    axis off
    hold off
    
end

hBar = colorbar(h,'east');
get(hBar, 'Position');
set(hBar, 'Position', [0.086458333333333,0.344731977818854,0.014583333333334,0.344115834873691]);
hBar.Label.String = 'Mean Source/Sink Strength';
hBar.Label.FontSize = 12;
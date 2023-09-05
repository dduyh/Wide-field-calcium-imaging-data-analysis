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

frame = cell(3,1);
load('D:\duyh\widefield\20210513\labelled_0513.mat')
labels = imresize(labels_align_video, [1 50000]);
labels = round(labels);

frame{1} = find(labels(1,:) == 2); % wake_frame
frame{2} = find(labels(1,:) == 3); % nrem_frame
phasic_rem = find(labels(1,:) == 0);
tonic_rem = find(labels(1,:) == 1);
frame{3} = union(phasic_rem,tonic_rem); % rem_frame

for i = 1:size(source,2)
    source_strength(i) = contour_source{i}.strength;
end
for i = 1:size(sink,2)
    sink_strength(i) = contour_sink{i}.strength;
end

%% HS

figure(1); % manually Maximize the figure window
ht = suptitle('Strength of Sources and Sinks of Brain States(All frames) by HS method');
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
    
    for frameNumber = frame{i}
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
    
    heat_im = heat_im./length(frame{i});
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
    
    for frameNumber = frame{i}
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
    
    heat_im = heat_im./length(frame{i});
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

for i = 1:size(source,2)
    source_strength(i) = contour_source{i}.strength;
end
for i = 1:size(sink,2)
    sink_strength(i) = contour_sink{i}.strength;
end

%% CLG

figure(2); % manually Maximize the figure window
ht = suptitle('Strength of Sources and Sinks of Brain States(All frames) by CLG method');
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
    
    for frameNumber = frame{i}
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
    
    heat_im = heat_im./length(frame{i});
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
    
    for frameNumber = frame{i}
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
    
    heat_im = heat_im./length(frame{i});
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
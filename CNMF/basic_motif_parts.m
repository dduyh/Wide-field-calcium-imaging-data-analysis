clc
clear
close all

%%

folderPath = 'D:\duyh\widefield\20210330\1\Wake_all';
savePath = [folderPath '\motif'];

load([folderPath '\record.mat'])
load('D:\duyh\widefield\20210330\1\brain_state_labels.mat','labels_frame');
rem_frame_all = find(labels_frame(1,:) == 1);

%%
K = 28;
L = 13;
lambda = 0.0005;
maxiter = 300;

vector = reshape(record, size(record,1)*size(record,2),size(record,3));
X = vector(~isnan(vector(:,1)),:);

[W, H, cost, loadings, power] = seqNMF(X, 'K', K, 'L', L, 'lambda', lambda, ...
    'showPlot', 1, 'maxiter', maxiter, 'tolerance', 0, 'lambdaL1W', 0, 'lambdaL1H', 0, ...
    'lambdaOrthoH', 0, 'lambdaOrthoW', 1, 'W_fixed', 0, 'useWupdate', 1,'SortFactors', 0 );

if power ~= 0
    figure(1);
    SimpleWHPlot(W,H);
    title('SeqNMF reconstruction  (parts-based)')
    saveas(gcf,[savePath '\recording_recons_parts_3.png']) ;
    fig_1 = getframe(gcf);
    
    figure(2);
    SimpleWHPlot(W,H,X);
    title(['SeqNMF factors, with raw data (power = ' num2str(power) ')'])
    saveas(gcf,[savePath '\recording_recons_parts_raw_3.png']) ;
    fig_2 = getframe(gcf);
    
    figure(3);
    subplot(2,1,1)
    imshow(fig_1.cdata)
    subplot(2,1,2)
    imshow(fig_2.cdata)
    saveas(gcf,[savePath '\recording_recons_parts_merged_3.png']) ;
    
    Xhat = helper.reconstruct(W,H);
    vectorhat = NaN(size(record,1)*size(record,2),size(record,3));
    vectorhat(~isnan(vector(:,:))) = Xhat(:,:);
    recordhat = reshape(vectorhat, size(record,1), size(record,2), size(record,3));
    
    writerObj=VideoWriter([savePath '\recording_recons_parts_3.avi']);
    frame_rate = 12.5;
    writerObj.FrameRate = frame_rate;
    open(writerObj);
    numFrames = size(record,3);
    
    %%
    figure(4);  % manually Maximize the figure window
    
    for j = 1 : numFrames
        figure(4);
        ht = suptitle([folderPath(end-6:end-4) ' ' folderPath(end-2:end) ...
            '  frame: ' num2str(rem_frame_all(j)) '  time: ' ...
            num2str(floor(rem_frame_all(j)./frame_rate)) 's']);
        set(ht, 'Position', [0.5 -0.1 0],'fontname','Times New Roman','fontsize',18)
        
        subplot(1,2,1)
        im_raw = record(:,:,j);
        imagesc(im_raw,[0 30]);
        colormap(hot)
        axis square
        title('raw image');
        
        subplot(1,2,2)
        im_recons = recordhat(:,:,j);
        imagesc(im_recons,[0 30]);
        axis square
        title('SeqNMF reconstruction (parts-based)')
        
        frame = getframe(gcf);
        writeVideo(writerObj,frame.cdata);
    end
    close(writerObj);
end

save([folderPath '\motif_data_parts_3.mat'], 'W', 'H', 'cost', 'loadings', 'power');

%%
figure(5);  % manually Maximize the figure window
%%
load([folderPath '\motif_data_parts_1.mat'])

vector = reshape(record, size(record,1)*size(record,2),size(record,3));

idx = find(any(H,2));
num = numel(idx);

for j = 1 : num
    
    single_mo(:,:) = W(:,idx(j),:);
    W_nan = NaN(size(record,1)*size(record,2),size(W,3));
    W_nan(~isnan(vector(:,1)),:) = single_mo(:,:);
    single_motif = reshape(W_nan, size(record,1), size(record,2), size(W,3));
    motif_all{j} = single_motif;
    
end

subfolder = [savePath '\motifs_parts_1'];
if isempty(dir(subfolder))
    mkdir(subfolder)
end

for n = 1:size(motif_all,2)
    figure(5);hold on
    
    ht = suptitle([folderPath(end-7:end-4) ' ' folderPath(end-2:end) '  Motif ' num2str(n)]);
    set(ht, 'fontname','Times New Roman','fontsize',18)
    
    single_motif = motif_all{n};
    maximum = max(max(max(single_motif)));
    
    for j = 1:13
        subplot(4,4,j)
        image(:,:) = single_motif(:,:,j);
        image = imgaussfilt(image,[1,1]);
        imagesc(image,[0 maximum])
        %imagesc(image)
        colormap(hot)
        %         caxis([-0.2 1.0])
        axis square
        axis off
        title(['frame' num2str(j)]);
    end
    saveas(gcf, [subfolder '/motif', num2str(n) '.png']);
    hold off
end
clear all
%%
load('G:\LAB\ion\Final_Project\low-dimensional spatiotemporal dynamics underlie cortex-wide neural actiity_CB2020_Timothy Buschman\CortexWideLowDimensionalSpatiotemporalDynamics-master\ProcessedData_DiscoveryEpochs.mat')
%%
K = 28;
L = 13;
lambda = 0.0005;
maxiter = 300;
motif = cell(144,5);

for i = 1 : 144
    fprintf('running recording = %i\n',i)
    record = data{i};
    vector = reshape(record, size(record,1)*size(record,2),size(record,3));
    X = vector(~isnan(vector(:,1)),:);
    %[W, H, cost, loadings, power] = seqNMF(X, 'K', K, 'L', L, 'lambda', lambda, 'showPlot', 1, 'maxiter', maxiter, 'tolerance', 0, 'shift', 0, 'lambdaL1W', 0, 'lambdaL1H', 1, 'lambdaOrthoH', 1, 'lambdaOrthoW', 0, 'W_fixed', 0, 'useWupdate', 1,'SortFactors', 0 );
    [W, H, cost, loadings, power] = seqNMF(X, 'K', K, 'L', L, 'lambda', lambda, 'showPlot', 1, 'maxiter', maxiter, 'tolerance', 0, 'lambdaL1W', 0, 'lambdaL1H', 0, 'lambdaOrthoH', 0, 'lambdaOrthoW', 1, 'W_fixed', 0, 'useWupdate', 1,'SortFactors', 0 );
    motif{i,1} = W;
    motif{i,2} = H;
    motif{i,3} = cost;
    motif{i,4} = loadings;
    motif{i,5} = power;
    
    if power ~= 0
        figure(5);
        SimpleWHPlot(W,H);
        title('SeqNMF reconstruction  (parts-based)')
        saveas(gcf,['I:\LAB\ion\Final_Project\low-dimensional spatiotemporal dynamics underlie cortex-wide neural actiity_CB2020_Timothy Buschman\CortexWideLowDimensionalSpatiotemporalDynamics-master\ProcessedData_DiscoveryEpochs\recording_recons_parts (' num2str(i) ').png']) ;
        fig_1 = getframe(gcf);
        
        figure(6);
        SimpleWHPlot(W,H,X);
        title(['SeqNMF factors, with raw data (power = ' num2str(power) ')'])
        saveas(gcf,['I:\LAB\ion\Final_Project\low-dimensional spatiotemporal dynamics underlie cortex-wide neural actiity_CB2020_Timothy Buschman\CortexWideLowDimensionalSpatiotemporalDynamics-master\ProcessedData_DiscoveryEpochs\recording_recons_parts_raw (' num2str(i) ').png']) ;
        fig_2 = getframe(gcf);
        
        figure(7);
        subplot(2,1,1)
        %subplot('position',[1 1 1 1])
        %axis tight
        imshow(fig_1.cdata)
        subplot(2,1,2)
        %subplot('position',[1 1 1 1])
        imshow(fig_2.cdata)
        saveas(gcf,['I:\LAB\ion\Final_Project\low-dimensional spatiotemporal dynamics underlie cortex-wide neural actiity_CB2020_Timothy Buschman\CortexWideLowDimensionalSpatiotemporalDynamics-master\ProcessedData_DiscoveryEpochs\recording_recons_parts_merged (' num2str(i) ').png']) ;
        
        Xhat = helper.reconstruct(W,H);
        vectorhat = NaN(size(record,1)*size(record,2),size(record,3));
        vectorhat(~isnan(vector(:,:))) = Xhat(:,:);
        recordhat = reshape(vectorhat, size(record,1), size(record,2), size(record,3));
        
        writerObj=VideoWriter(['I:\LAB\ion\Final_Project\low-dimensional spatiotemporal dynamics underlie cortex-wide neural actiity_CB2020_Timothy Buschman\CortexWideLowDimensionalSpatiotemporalDynamics-master\ProcessedData_DiscoveryEpochs\recording_recons_parts (' num2str(i) ').avi']);
        writerObj.FrameRate = 1000/75;
        open(writerObj);
        numFrames = 1560;
        
        for j = 1 : numFrames
            figure(8);
            subplot(1,2,1)
            im_raw = record(:,:,j);
            imagesc(im_raw,[0 1]);
            colormap(hot)
            axis square
            title('raw image');
            
            subplot(1,2,2)
            im_recons = recordhat(:,:,j);
            imagesc(im_recons,[0 1]);
            axis square
            title('SeqNMF reconstruction (parts-based)')
            
            frame = getframe(gcf);
            writeVideo(writerObj,frame.cdata);
        end
        close(writerObj);
    end
end
save('I:\LAB\ion\Final_Project\low-dimensional spatiotemporal dynamics underlie cortex-wide neural actiity_CB2020_Timothy Buschman\CortexWideLowDimensionalSpatiotemporalDynamics-master\motif_data_parts.mat', 'motif');
%%
load('G:\LAB\ion\Final_Project\low-dimensional spatiotemporal dynamics underlie cortex-wide neural actiity_CB2020_Timothy Buschman\CortexWideLowDimensionalSpatiotemporalDynamics-master\motif_data_events.mat')
k = 0;
for i = 1 : 144
    record = data{i};
    vector = reshape(record, size(record,1)*size(record,2),size(record,3));
    
    W = motif{i,1};
    H = motif{i,2};
    idx = find(any(H,2));
    num = numel(idx);
    
    for j = 1 : num
        
        single_mo(:,:) = W(:,idx(j),:);
        W_nan = NaN(size(record,1)*size(record,2),size(W,3));
        W_nan(~isnan(vector(:,1)),:) = single_mo(:,:);
        single_motif = reshape(W_nan, size(record,1), size(record,2), size(W,3));
        motif_all{k+j} = single_motif;
        
    end
    k = k + num;
    clear single_mo
end

subfolder = ['G:\LAB\ion\Final_Project\low-dimensional spatiotemporal dynamics underlie cortex-wide neural actiity_CB2020_Timothy Buschman\CortexWideLowDimensionalSpatiotemporalDynamics-master\motifs_events'];
if isempty(dir(subfolder))
    mkdir(subfolder)
end

for n = 1:size(motif_all,2)
    figure(3);hold on
    %figure('Position', [658   421   437   270]);hold on
    for j = 1:13
        subplot(1,13,j)
        single_motif = motif_all{n};
        image(:,:) = single_motif(:,:,j);
        image = imgaussfilt(image,[1,1]);
        imagesc(image)
        colormap(hot)
        caxis([-0.2 1.0])
        axis square
        axis off
        title(['frame' num2str(j)]);
        %         drawnow
    end
    saveas(gcf, [subfolder '/motif', num2str(n) '.png']);
    hold off
end
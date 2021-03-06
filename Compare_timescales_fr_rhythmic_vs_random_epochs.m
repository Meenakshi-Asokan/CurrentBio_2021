close all
clearvars

data_dir = 'F:\EPHYS\Curr Bio\Dataset\Figure_3';
load(fullfile(data_dir,'reg_rand_rasters.mat'));

%%
%obtain taus
%measure - tau
num_regions = length(reg_rand_rasters);
measure_tau = cell(1,num_regions);
sm = 5;
for r_num = 1:num_regions
    raster_reg = reg_rand_rasters(r_num).raster_reg;
    raster_rand = reg_rand_rasters(r_num).raster_rand;
    
    tau_final_reg = [];
    tau_final_rand = [];
    for i = 1:size(raster_reg,3)
    raster = raster_reg(:,:,i);
    [tau_single_reg(i), tau_final_reg(i), curve] = myfunc_calculate_tau(raster,sm);
    
    raster = raster_rand(:,:,i);
    [tau_single_rand(i), tau_final_rand(i), curve] = myfunc_calculate_tau(raster,sm);
    end
    
    measure_tau{r_num}(1,:) = tau_final_reg;
    measure_tau{r_num}(2,:) = tau_final_rand;
    r_num    
end
%%
%obtain firing rates in 100 ms windows
%measure - fr
num_regions = length(reg_rand_rasters);
measure_fr = cell(1,num_regions);

for r_num = 1:num_regions
    fr_reg = [];
    fr_rand = [];
    raster_reg = reg_rand_rasters(r_num).raster_reg;
    raster_rand = reg_rand_rasters(r_num).raster_rand;
    
    for i = 1:size(raster_reg,3)
    raster = raster_reg(:,:,i);
    fr_reg(i) = mean(mean(raster))*1e3;
    
    raster = raster_rand(:,:,i);
    fr_rand(i) = mean(mean(raster))*1e3;
    end
    
    measure_fr{r_num}(1,:) = fr_reg;
    measure_fr{r_num}(2,:) = fr_rand;
    r_num    
end
%%
data_dir = 'F:\EPHYS\Curr Bio\Dataset\Figure_4';
load(fullfile(data_dir,'rcyc_4_8_12.mat'));

num_cycs = length(rcyc_4_8_12);
measure_tau_rcyc = cell(1,num_cycs);
sm = 5;
for r_num = 1:num_cycs
    raster_reg = rcyc_4_8_12(r_num).raster_reg;
    raster_rand = rcyc_4_8_12(r_num).raster_rand;
    
    tau_final_reg = [];
    tau_final_rand = [];
    for i = 1:size(raster_reg,3)
    raster = raster_reg(:,:,i);
    [tau_single_reg(i), tau_final_reg(i), curve] = myfunc_calculate_tau(raster,sm);
    
    raster = raster_rand(:,:,i);
    [tau_single_rand(i), tau_final_rand(i), curve] = myfunc_calculate_tau(raster,sm);
    end
    
    measure_tau_rcyc{r_num}(1,:) = tau_final_reg;
    measure_tau_rcyc{r_num}(2,:) = tau_final_rand;
    r_num    
end
%%
%choose which measure you want to plot
measure = measure_tau;
% measure = measure_fr;
% measure = measure_tau_rcyc;

%bar plots of mean and sem

mean1 = [];
stderr1 = [];
mean2 = [];
stderr2 = [];
mean_diff = [];
stderr_diff = [];
for r_num = 1:3
    values1 = measure{r_num}(1,:);
    values2 = measure{r_num}(2,:);
    diff = values2 - values1;
    mean_diff  = [mean_diff mean(diff)];
    stderr_diff = [stderr_diff std(diff)/sqrt(length(diff))];
    mean1 =[mean1 mean(values1)];
    stderr1 = [stderr1 std(values1)/sqrt(length(values1))];
    mean2 = [mean2 mean(values2)];
    stderr2 = [stderr2 std(values2)/sqrt(length(values2))];
end


figure();
for i = 1:3
subplot(1,3,i);
bar([mean1(i) mean2(i)]);
hold on
errorbar(1:2,[mean1(i) mean2(i)],[stderr1(i) stderr2(i)],'.');
hold on
set(gca,'xticklabel',{'Rhythm','Rand'})
% ylim([0 25]);
xlim([0 3]);
box off
end
%%
%scatter plots
figure();
lim = 60;
x = 0:0.1:lim;
y = x;
for r_num = 1:3
    if (r_num ==1)
    colorr = 'r';
    elseif (r_num ==2)
    colorr = [0,0.5,0];
    else
    colorr = 'b';
    end
    subplot(1,3,r_num);
    scatter(measure{r_num}(2,:), measure{r_num}(1,:),25,colorr,'filled','MarkerEdgeColor','k','MarkerFaceAlpha',0.5);
    hold on
    plot(x,y,'k--');
    set(gca,'xscale','log')
    set(gca,'yscale','log')
    xlim([2 lim]);
    ylim([2 lim]);
    axis square
end
%%
%mod indices and histograms
%mod_index
mod_index = cell(1,3);
for r_num = 1:3
    mod_index{r_num} = (measure{r_num}(2,:) - measure{r_num}(1,:))./(measure{r_num}(2,:) + measure{r_num}(1,:));
end

%regular histogram
figure();
for r_num = 1:3
    if (r_num ==1)
    colorr = 'r';
    elseif (r_num ==2)
    colorr = [0,0.5,0];
    else
    colorr = 'b';
    end    
    subplot(3,1,r_num);
    h1 = histogram(mod_index{r_num},length(mod_index{r_num}));
    h1.FaceColor = colorr;
    h1.Normalization = 'probability';
    h1.BinWidth = 0.012;  
    xlim([-0.5 0.5]);
    vline(0,'k--');
    box off
    hold on
    vline(mean(mod_index{r_num}),'k');
%     view([90 90])
%     xlim([0 60]);
end


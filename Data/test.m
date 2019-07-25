load('AllDataLugagne_Final_21exp.mat')
for j=1:20
    
    subplot(1,3,1)
    hold off;
    plot(Data.t_samples{1},Data.exp_data{1}(1,:))
    hold on
    plot(Data.t_samples{1},Data.standard_dev{1}(1,:)+Data.exp_data{1}(1,:))
    plot(Data.t_samples{1},-Data.standard_dev{1}(1,:)+Data.exp_data{1}(1,:))
    ylim([0 5000])
    subplot(1,3,2);
    x=0:0.01:1;
    fun=6000.*x./(x+0.4);
    rng(1)
    FUN=[];
    for i=1:8
        FUN=[FUN;fun+fun.*0.1.*(randn(size(fun)))];
    end
    hold off;
    
    plot(x,mean(FUN))
    hold on;
    plot(x,mean(FUN)+std(FUN))
    plot(x,mean(FUN)-std(FUN))
    ylim([0 5000])
    subplot(1,3,3)
    
    hold off;
    
    plot(x,movmean(mean(FUN),j))
    hold on;
    plot(x,movmean(mean(FUN)+std(FUN),j))
    plot(x,movmean(mean(FUN)-std(FUN),j))
    title(['window size ' num2str(j)])
    pause(1);
end


load Data/AllDataLugagne_Final.mat

counter=0;

feval(inputs.model.mexfunction,'sim_CVODES');

for iexp=1:length(inputs.exps.exp_data)
    
    counter=counter+1;
    subplot(8,6,counter);
    
    plot(inputs.exps.t_s{iexp}(1,:),inputs.exps.exp_data{iexp}(:,:),'.')
    hold on;
    ax = gca;
    ax.ColorOrderIndex = 1;
    plot(inputs.exps.t_s{iexp}(1,:),outputs.observables{iexp}(:,:))
    
    title(['Data ' num2str(iexp)])
    counter=counter+1;
    subplot(8,6,counter);
    
    plot(inputs.exps.t_con{iexp}(1,:),[inputs.exps.u{iexp}(1,:) inputs.exps.u{iexp}(1,end)])
    hold on;
    plot(inputs.exps.t_con{iexp}(1,:),[inputs.exps.u{iexp}(2,:) inputs.exps.u{iexp}(2,end)]./35)
    title(['Control ' num2str(iexp)])
    
end

function plot_fit(inputs,privstruct,model_name,logicBased)

counter=0;
feval(inputs.model.mexfunction,'cost_LSQ');
outputs.f
feval(inputs.model.mexfunction,'sim_CVODES');

for iexp=1:length(inputs.exps.exp_data)
    
    counter=counter+1;
    
    subplot(8,9,counter);
    
    plot1=scatter(inputs.exps.t_s{iexp},inputs.exps.exp_data{iexp}(:,1),'r.');
    plot1.MarkerFaceAlpha = .4;
    plot1.MarkerEdgeAlpha = .4;
    
    hold on;
    
    plot1=scatter(inputs.exps.t_s{iexp},inputs.exps.exp_data{iexp}(:,2),'g.');
    plot1.MarkerFaceAlpha = .4;
    plot1.MarkerEdgeAlpha = .4;
    
    ax = gca;
    ax.ColorOrderIndex = 1;
    plot(inputs.exps.t_s{iexp}(1,:),outputs.observables{iexp}(:,1),'k','LineWidth',1)
    hold on;
    plot(inputs.exps.t_s{iexp}(1,:),outputs.observables{iexp}(:,2),'k','LineWidth',1)
    title(['Reporters ' num2str(iexp)])
    xlim([0 inputs.exps.t_f{iexp}]);
    if logicBased,ylim([-0.1 1.1]);end
    
    
    counter=counter+1;
    subplot(8,9,counter);
    yyaxis left
    %       stairs(inputs.exps.t_con{iexp},[inputs.exps.u{iexp}(:,2)])
    stairs(inputs.exps.t_con{iexp},[inputs.exps.u{iexp}(2,:) inputs.exps.u{iexp}(2,end)])
    ylim([-10 110])
    yyaxis right
    %     stairs(inputs.exps.t_con{iexp},[inputs.exps.u{iexp}(:,1)])
    stairs(inputs.exps.t_con{iexp},[inputs.exps.u{iexp}(1,:) inputs.exps.u{iexp}(1,end)])
    ylim([-0.1 1.1])
    %     stairs(inputs.exps.t_con{iexp},[inputs.exps.u{iexp}(1,:) inputs.exps.u{iexp}(1,end)],'b--')
    %     hold on;
    %     stairs(inputs.exps.t_con{iexp},[inputs.exps.u{iexp}(2,:) inputs.exps.u{iexp}(2,end)],'m--')
    hold on;
    %     plot(inputs.exps.t_s{iexp},outputs.simulation{iexp}(:,3),'b')
    %     hold on;
    %     plot(inputs.exps.t_s{iexp}(1,:),outputs.simulation{iexp}(:,4),'m')
    title(['Inducers ' num2str(iexp)])
    xlim([0 inputs.exps.t_f{iexp}]);
    if logicBased,ylim([-0.1 1.1]);end
    
    switch model_name
        
        case 'modelVarun'
            counter=counter+1;
            subplot(8,9,counter);
            plot(inputs.exps.t_s{iexp}(1,:),outputs.simulation{iexp}(:,5),'r')
            hold on;
            plot(inputs.exps.t_s{iexp}(1,:),outputs.simulation{iexp}(:,6),'g')
            title(['mRNA ' num2str(iexp)])
            ylim([-0.1 1.1]);
            xlim([0 inputs.exps.t_f{iexp}]);
            
    end
    
end

end


function plot_fit(inputs,privstruct,model_name,logicBased)

counter=0;
feval(inputs.model.mexfunction,'cost_LSQ');
outputs.f
feval(inputs.model.mexfunction,'sim_CVODES');

for iexp=1:length(inputs.exps.exp_data)
    
    counter=counter+1;
    
    subplot(8,9,counter);
    yyaxis left
    plot1=scatter(inputs.exps.t_s{iexp},inputs.exps.exp_data{iexp}(:,1)+...
        outputs.observables{iexp}(:,1).*mean(.05.*randn(size(inputs.exps.exp_data{iexp}(:,1),1),8)')','r.');
    plot1.MarkerFaceAlpha = .4;
    plot1.MarkerEdgeAlpha = .4;
    
    %     yyaxis left
    %     plot1=scatter(inputs.exps.t_s{iexp},inputs.exps.exp_data{iexp}(:,1),'r.');
    %     plot1.MarkerFaceAlpha = .4;
    %     plot1.MarkerEdgeAlpha = .4;
    
    hold on;
    yyaxis right
    plot1=scatter(inputs.exps.t_s{iexp},inputs.exps.exp_data{iexp}(:,2)+...
        outputs.observables{iexp}(:,2).*mean(.05.*randn(size(inputs.exps.exp_data{iexp}(:,2),1),8)')','g.');
    plot1.MarkerFaceAlpha = .4;
    plot1.MarkerEdgeAlpha = .4;
    
    %     plot1=scatter(inputs.exps.t_s{iexp},inputs.exps.exp_data{iexp}(:,2)+...
    %     outputs.ob{iexp}(:,2)*mean(rand(size(inputs.exps.exp_data{iexp}(:,2),8))),'g.');
    %     plot1.MarkerFaceAlpha = .4;
    %     plot1.MarkerEdgeAlpha = .4;
    
    yyaxis left
    %     plot(inputs.exps.t_s{iexp},outputs.observables{iexp}(:,1),'k-','LineWidth',1.5)
    %     hold on
    %     plot(inputs.exps.t_s{iexp},...
    %         outputs.observables{iexp}(:,1)+inputs.exps.error_data{iexp}(:,1),...
    %         'r','LineWidth',1)
    %     plot(inputs.exps.t_s{iexp},...
    %         outputs.observables{iexp}(:,1)-inputs.exps.error_data{iexp}(:,1),...
    %         'r','LineWidth',1)
    ylim([0 5500])
    hold on;
    
    yyaxis right
    %     plot(inputs.exps.t_s{iexp},outputs.observables{iexp}(:,2),'k-','LineWidth',1.5)
    %     hold on;
    %     plot(inputs.exps.t_s{iexp},...
    %         outputs.observables{iexp}(:,2)+inputs.exps.error_data{iexp}(:,2),...
    %         'g','LineWidth',1)
    %     hold on;
    %     plot(inputs.exps.t_s{iexp},...
    %         outputs.observables{iexp}(:,2)-inputs.exps.error_data{iexp}(:,2),...
    %         'g','LineWidth',1)
    ylim([0 2800])
    
    title(['Reporters ' num2str(iexp)])
    xlim([0 inputs.exps.t_f{iexp}]);
    %if logicBased,ylim([-0.1 1.1]);end
    
    
    counter=counter+1;
    subplot(8,9,counter);
    %     yyaxis left
    %     %       stairs(inputs.exps.t_con{iexp},[inputs.exps.u{iexp}(:,2)])
    %     plot(inputs.exps.t_con{iexp},[inputs.exps.u{iexp}(2,:) ])
    %     ylim([-10 110])
    %     yyaxis right
    %     %     stairs(inputs.exps.t_con{iexp},[inputs.exps.u{iexp}(:,1)])
    %     plot(inputs.exps.t_con{iexp}, inputs.exps.u{iexp}(1,:) )
    %     ylim([-0.1 1.1])
    %     %     stairs(inputs.exps.t_con{iexp},[inputs.exps.u{iexp}(1,:) inputs.exps.u{iexp}(1,end)],'b--')
    %     %     hold on;
    %     %     stairs(inputs.exps.t_con{iexp},[inputs.exps.u{iexp}(2,:) inputs.exps.u{iexp}(2,end)],'m--')
    %     hold on;
    %     %     plot(inputs.exps.t_s{iexp},outputs.simulation{iexp}(:,3),'b')
    %     %     hold on;
    %     %     plot(inputs.exps.t_s{iexp}(1,:),outputs.simulation{iexp}(:,4),'m')
    %     title(['Inducers ' num2str(iexp)])
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


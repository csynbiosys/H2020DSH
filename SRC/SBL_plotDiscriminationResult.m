function  SBL_plotDiscriminationResult(MODELS)


observables={};
for i=1:length(MODELS)
    inputs=MODELS{i}{1};
    privstruct=MODELS{i}{2};
    feval(inputs.model.mexfunction,'sim_CVODES');
    observables{i}=outputs.observables{1};
end


iexp=1;
total_plots=1+inputs.exps.n_obs{iexp}+inputs.model.n_stimulus;
ncols=floor(sqrt(total_plots))+1;
nrows=floor(sqrt(total_plots))+1;

counter=0;

figure;

for i=1:inputs.model.n_stimulus
    
    counter=counter+1;
    subplot(nrows,ncols,counter);
    
    try
        stairs(inputs.exps.t_con{iexp},[inputs.exps.u{iexp}(i,:)])
    catch
        stairs(inputs.exps.t_con{iexp},[inputs.exps.u{iexp}(i,:) inputs.exps.u{iexp}(i,end)])
    end
    title(MODELS{1}{1}.model.stimulus_names(i,:));
    
end


for i=1:inputs.model.n_st
    counter=counter+1;
    labels={};
    for j=1:length(MODELS)
        
        subplot(nrows,ncols,counter);
        title(MODELS{1}{1}.model.st_names(i,:));
        
        plot(inputs.exps.t_s{iexp},observables{j}(:,i),'LineWidth',1)
        hold on;
        labels{j}=['MODEL' num2str(j)];
    end
    legend(labels);
    
end





%
% yyaxis left
% plot(inputs.exps.t_s{iexp},observables{iexp}(:,1),'k-','LineWidth',1.5)
% hold on
% %     plot(inputs.exps.t_s{iexp},...
% %         outputs.observables{iexp}(:,1)+inputs.exps.error_data{iexp}(:,1),...
% %         'r','LineWidth',1)
% %     plot(inputs.exps.t_s{iexp},...
% %         outputs.observables{iexp}(:,1)-inputs.exps.error_data{iexp}(:,1),...
% %         'r','LineWidth',1)
% ylim([0 5500])
% hold on;
%
% yyaxis right
% plot(inputs.exps.t_s{iexp},outputs.observables{iexp}(:,2),'k-','LineWidth',1.5)
% hold on;
% plot(inputs.exps.t_s{iexp},...
%     outputs.observables{iexp}(:,2)+inputs.exps.error_data{iexp}(:,2),...
%     'g','LineWidth',1)
% hold on;
% plot(inputs.exps.t_s{iexp},...
%     outputs.observables{iexp}(:,2)-inputs.exps.error_data{iexp}(:,2),...
%     'g','LineWidth',1)
% ylim([0 2800])
%
% title(['Reporters ' num2str(iexp)])
% xlim([0 inputs.exps.t_f{iexp}]);
% %if logicBased,ylim([-0.1 1.1]);end
%
%
%
%
% ylim([-0.1 1.1])
% xlim([0 inputs.exps.t_f{iexp}]);
%
% yyaxis right
% try
%     stairs(inputs.exps.t_con{iexp},[inputs.exps.u{iexp}(2,:)],'LineWidth',1.5)
% catch
%     stairs(inputs.exps.t_con{iexp},[inputs.exps.u{iexp}(2,:) inputs.exps.u{iexp}(2,end)])
% end
% ylim([-10 110])
% yyaxis right
% title(['Inducers ' num2str(iexp)])
% xlim([0 inputs.exps.t_f{iexp}]);
%
%
% end
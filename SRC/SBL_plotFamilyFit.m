function  SBL_plotFamilyFit(MODELS)

observables={};
for i=1:length(MODELS)
    inputs=MODELS{i}{1};
    privstruct=MODELS{i}{2};
    feval(inputs.model.mexfunction,'sim_CVODES');
    observables{i}=outputs.observables;
end

n_data=0;
for iexp=1:inputs.exps.n_exp
    n_data=n_data+sum(sum(~isnan(inputs.exps.exp_data{iexp}(2:end,:))));
end

labels={};
for i=1:length(MODELS)
    n_par=MODELS{i}{1}.model.n_par;
    AIC=2*n_par+n_data.*log(MODELS{i}{3}.f);
    plot(MODELS{i}{3}.neval,AIC);
    hold on;
    labels{i}=['MODEL' num2str(i) 'NP=' num2str(n_par)];
    ylabel('AIC');
    xlabel('Number of function evaluation');
end
title('Convergence curves for parameter estimation')
figure;



iexp=1;
total_plots=inputs.exps.n_obs{iexp}*inputs.exps.n_exp+inputs.model.n_stimulus*inputs.exps.n_exp;
ncols=floor(sqrt(total_plots))+1;
nrows=floor(sqrt(total_plots))+1;

counter=0;


for iexp=1:inputs.exps.n_exp
    
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
        labels={'Exp data'};
        subplot(nrows,ncols,counter);
        scatter(inputs.exps.t_s{iexp},inputs.exps.exp_data{iexp}(:,i),'LineWidth',1)
        hold on;
        for j=1:length(MODELS)
            
            
            title(MODELS{1}{1}.model.st_names(i,:));
            
            plot(inputs.exps.t_s{iexp},observables{j}{iexp}(:,i),'LineWidth',1)
            
            
            labels{j}=['MODEL' num2str(j)];
            
        end
        legend(labels);
        title([MODELS{1}{1}.model.st_names(i,:) ' EXP ' num2str(iexp)]);
        
    end
    
end




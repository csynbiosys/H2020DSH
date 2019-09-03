function  SBL_plotFamilyFit(MODELS)

valid_model=[];

observables={};
for i=1:length(MODELS)
    if ~isempty(MODELS{i})
        valid_models(i)=1;
        inputs=MODELS{i}{1};
        privstruct=MODELS{i}{2};
        feval(inputs.model.mexfunction,'sim_CVODES');
        observables{i}=outputs.observables;
    else
        valid_models(i)=0;
    end
end

first_valid_model=find(valid_models);
first_valid_model=first_valid_model(1);

n_data=0;
for iexp=1:inputs.exps.n_exp
    n_data=n_data+sum(sum(~isnan(inputs.exps.exp_data{iexp}(2:end,:))));
end

figure;

labels={};
counter=0;
for i=1:length(MODELS)
    
    if ~isempty(MODELS{i})
        n_par=MODELS{i}{1}.model.n_par;
        %AIC=2*n_par+n_data.*log(MODELS{i}{3}.f);
        plot(MODELS{i}{3}.neval,MODELS{i}{3}.f);
        hold on;
        counter=counter+1;
        labels{counter}=['MODEL ' num2str(i) ' NPars=' num2str(n_par)];
    end
    ylabel('\chi^2');
    xlabel('Number of function evaluations');
end
title('Convergence curves for parameter estimation')
legend(labels);

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
        title(inputs.model.stimulus_names(i,:));
        
    end
    
   
    for i=1:inputs.model.n_st
        counter=counter+1;
        labels={'Exp data'};
        subplot(nrows,ncols,counter);
        scatter(inputs.exps.t_s{iexp},inputs.exps.exp_data{iexp}(:,i),'LineWidth',1)
        hold on;
         counter_2=0;
        for j=1:length(MODELS)
            
            title(inputs.model.st_names(i,:));
            if ~isempty(MODELS{j})
                 counter_2=counter_2+1;
                plot(inputs.exps.t_s{iexp},observables{j}{iexp}(:,i),'LineWidth',1)
                labels{counter_2+1}=['MODEL' num2str(j)];
            end
            
        end
        legend(labels);
        title([inputs.model.st_names(i,:) ' EXP ' num2str(iexp)]);
        
    end
    
end




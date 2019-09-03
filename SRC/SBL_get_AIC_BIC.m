function  SBL_plotFamilyFit(MODELS)

valid_model=[];

observables={};
w_res={};
for i=1:length(MODELS)
    if ~isempty(MODELS{i})
        valid_models(i)=1;
        inputs=MODELS{i}{1};
        privstruct=MODELS{i}{2};
        feval(inputs.model.mexfunction,'sim_CVODES');
        observables{i}=outputs.observables;
        feval(inputs.model.mexfunction,'sim_CVODES');
        observables{i}=outputs.observables;
        w_res{i}=outputs.w_res;
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

end




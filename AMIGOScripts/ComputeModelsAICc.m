function [AICc] = ComputeModelsAICc(models,fit_results)
    
for model_idx = 1:length(models)
    exps_indexTraining = models(model_idx).model.exp_training_idx;
    npar = models(model_idx).model.n_par; 
    
    for iexp=1:length(exps_indexTraining)
        exp_indexData = exps_indexTraining(iexp);
        % nR normalised residuals
        nR{iexp} = (fit_results{1,model_idx}.best_sim.sim.states{1,exp_indexData} - fit_results{1,model_idx}.exps.exp_data{1,exp_indexData})./(fit_results{1,model_idx}.exps.error_data{1,exp_indexData});
        chi2{iexp} = 0;
        for c=1:size(nR{iexp},2)
            chi2{iexp} =  chi2{iexp}+(nR{iexp}(:,c)'*nR{iexp}(:,c));
        end
    end

    AICc(model_idx) = 2*npar + sum([chi2{:}]) + 2*npar*(npar+1)/(numel([nR{:}])-npar-1);

end
end
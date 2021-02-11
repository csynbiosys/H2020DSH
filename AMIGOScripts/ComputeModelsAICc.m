function [AICc] = ComputeModelsAICc(models,model_idx,fit_res,exps_indexTraining)

    exps_indexTraining = models(model_idx).model.exp_training_idx;
    npar = fit_res.inputs.model.n_par; 
    
    for iexp=1:length(exps_indexTraining)
        exp_indexData = exps_indexTraining(iexp);
        nR{iexp} = (fit_res.best_sim{1,exp_indexData}.sim.states{1,1} - fit_res.exps.exp_data{1,exp_indexData})./(fit_res.exps.error_data{1,exp_indexData});
        chi2{iexp} = 0;
        for c=1:size(nR{iexp},2)
            chi2{iexp} =  chi2{iexp}+(nR{iexp}(:,c)'*nR{iexp}(:,c));
        end
    end

    AICc = 2*npar + sum([chi2{:}]) + 2*npar*(npar+1)/(numel([nR{:}])-npar-1);

end
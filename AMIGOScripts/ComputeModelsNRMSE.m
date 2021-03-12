function [nRMSE] = ComputeModelsnRMSE(models,fit_results)
    
for model_idx = 1:length(models)
    exps_indexTest = models(model_idx).model.exp_test_idx;
    
    for iexp=1:length(exps_indexTest)
        exp_indexData = exps_indexTest(iexp);
        % nR normalised residuals
        nR{iexp} = (fit_results{1,model_idx}.best_sim.sim.states{1,exp_indexData} - fit_results{1,model_idx}.exps.exp_data{1,exp_indexData})./(fit_results{1,model_idx}.exps.error_data{1,exp_indexData});
        chi2{iexp} = 0;
        for c=1:size(nR{iexp},2)
            chi2{iexp} =  chi2{iexp}+(nR{iexp}(:,c)'*nR{iexp}(:,c));
        end
    end

    nRMSE(model_idx) = sqrt(sum([chi2{:}])/numel([nR{:}]));
end
end
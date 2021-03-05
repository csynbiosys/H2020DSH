function [peRes] = mainRunPE(fit_res,tmpth,exps_indexTraining,model_id,nguess,label)

    fit_res.inputs.PEsol.global_theta_guess = tmpth;
    fit_res.inputs.model.par = tmpth;
    

    for iexp =1:fit_res.inputs.exps.n_exp
        fit_res.inputs.exps.exp_y0{iexp} = ModelComputeInitialCondition(fit_res.inputs,...
                                                                        fit_res.inputs.model.par,...
                                                                        iexp,...
                                                                        fit_res.inputs.exps.exp_data{iexp}(1,:),...
                                                                        fit_res.exps.exp_data{1,exps_indexTraining(iexp)});
   
    end
   
%     AMIGO_Prep(fit_res.inputs)

    peRes = AMIGO_PE(fit_res.inputs);

    save(strjoin([".\AMIGOScripts\Results\PE_",string(model_id),'_',label,"\Run_", nguess, ".mat"],""), "peRes")




end

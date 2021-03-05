function [simRes] = mainRunPEtestSet(fit_res_testSet,tmpth,exps_indexTest,model_id,nguess,label)

    fit_res_testSet.inputs.model.par = tmpth;
    %fit_res_testSet.inputs.plotd.plotlevel='full';

    for iexp =1:fit_res_testSet.inputs.exps.n_exp
        fit_res_testSet.inputs.exps.exp_y0{iexp} = ModelComputeInitialCondition(fit_res_testSet.inputs,...
                                                                        fit_res_testSet.inputs.model.par,...
                                                                        iexp,...
                                                                        fit_res_testSet.inputs.exps.exp_data{iexp}(1,:),...
                                                                        fit_res_testSet.exps.exp_data{1,exps_indexTest(iexp)});
   
    end
   
%     AMIGO_Prep(fit_res.inputs)

    simRes = AMIGO_SObs(fit_res_testSet.inputs);
    
    for iexp=1:fit_res_testSet.inputs.exps.n_exp
        simRes.SSE{iexp} = sum((simRes.sim.sim_data{1,iexp}-fit_res_testSet.exps.exp_data{1,exps_indexTest(iexp)}).^2,'All');
    end
    save(strjoin([".\AMIGOScripts\Results\PE_Test_",string(model_id),'_',label,"\Run_", nguess, ".mat"],""), "simRes")



end

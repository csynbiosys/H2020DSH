function [fit_res_testSet] = setAMIGOStructureTestSet(fit_res_testSet, model,experimental_data) 

    % SIMULATION
    fit_res_testSet.inputs.ivpsol.ivpsolver='cvodes';
    fit_res_testSet.inputs.ivpsol.senssolver='fdsens5';
    fit_res_testSet.inputs.ivpsol.rtol=1.0D-13;
    fit_res_testSet.inputs.ivpsol.atol=1.0D-13;
    fit_res_testSet.inputs.plotd.plotlevel='noplot';
        
    results_folder = strcat(model.model.name,'testSet',datestr(now,'yyyy-mm-dd'));
    short_name = strcat(model.model.name,'_inference_testSet');
    fit_res_testSet.inputs.pathd.results_folder = results_folder;                        
    fit_res_testSet.inputs.pathd.short_name     = short_name;
    fit_res_testSet.inputs.pathd.runident       = 'initial_setup';

    fit_res_testSet.inputs.model = ExtractModelToFit(model);
    
    AMIGO_Prep(fit_res_testSet.inputs)
    
    %% Experiment details for AMIGO
    % Prepare the inputs for simulation on the test set
    exps_indexTest = model.model.exp_test_idx;
    fit_res_testSet.inputs.exps.n_exp = length(exps_indexTest);
    
    for iexp = 1:fit_res_testSet.inputs.exps.n_exp
        exp_indexData = exps_indexTest(iexp);
        fit_res_testSet.inputs.exps.exp_type{iexp} = experimental_data.exps.exp_type{1,exp_indexData}; 
        fit_res_testSet.inputs.exps.n_obs{iexp} = experimental_data.exps.n_obs{1,exp_indexData}; 
        fit_res_testSet.inputs.exps.obs_names{iexp} = char(model.exp_info.obs_names);
        fit_res_testSet.inputs.exps.obs{iexp} = char(model.exp_info.obs);
        fit_res_testSet.inputs.exps.u_interp{iexp} = experimental_data.exps.u_interp{1,exp_indexData};
        fit_res_testSet.inputs.exps.t_f{iexp} = experimental_data.exps.t_f{1,exp_indexData}; 
        fit_res_testSet.inputs.exps.n_s{iexp} = experimental_data.exps.n_s{1,exp_indexData};
        fit_res_testSet.inputs.exps.t_s{iexp} = experimental_data.exps.t_s{1,exp_indexData}; 
        fit_res_testSet.inputs.exps.t_con{iexp} = experimental_data.exps.t_con{1,exp_indexData};
        fit_res_testSet.inputs.exps.n_steps{iexp} = experimental_data.exps.n_steps{1,exp_indexData};
        fit_res_testSet.inputs.exps.u{iexp} = experimental_data.exps.u{1,exp_indexData};
        fit_res_testSet.inputs.exps.exp_data{iexp} = experimental_data.exps.exp_data{1,exp_indexData};
        fit_res_testSet.inputs.exps.error_data{iexp} = experimental_data.exps.error_data{1,exp_indexData};
        fit_res_testSet.inputs.exps.exp_y0{iexp} = ModelComputeInitialCondition(fit_res_testSet.inputs,...
                                                                        fit_res_testSet.inputs.model.par,...
                                                                        iexp,...
                                                                        fit_res_testSet.inputs.exps.exp_data{iexp}(1,:),...
                                                                        experimental_data.exps.u_0{1,exp_indexData});
    end

    
    %fit_res_testSet.inputs.exps.data_type= experimental_data.exps.data_type;
    %fit_res_testSet.inputs.exps.noise_type= experimental_data.exps.noise_type;
 
end










function [fit_res] = setAMIGOStructureFit(fit_res, model,experimental_data) 


    fit_res.inputs.ivpsol.ivpsolver='cvodes';
    fit_res.inputs.ivpsol.senssolver='fdsens5';
    fit_res.inputs.ivpsol.rtol=1.0D-13;
    fit_res.inputs.ivpsol.atol=1.0D-13;
    fit_res.inputs.plotd.plotlevel='noplot';
    
    %COST FUNCTION RELATED DATA
%     fit_res.inputs.PEsol.PEcost_type='llk';                       % 'lsq' (weighted least squares default) | 'llk' (log likelihood) | 'user_PEcost'
%     fit_res.inputs.PEsol.llk_type='hetero';                      % [] To be defined for llk function, 'homo' | 'homo_var' | 'hetero'

    fit_res.inputs.PEsol.PEcost_type='lsq';                       % 'lsq' (weighted least squares default) | 'llk' (log likelihood) | 'user_PEcost'
    fit_res.inputs.PEsol.lsq_type='Q_expmax';   
    
    %OPTIMIZATION
    fit_res.inputs.nlpsol.nlpsolver='eSS';
    fit_res.inputs.nlpsol.eSS.maxeval = 200000;
    fit_res.inputs.nlpsol.eSS.maxtime = 50000000;
    fit_res.inputs.nlpsol.eSS.local.solver = 'lsqnonlin'; 
    fit_res.inputs.nlpsol.eSS.local.finish = 'lsqnonlin'; 
    
    results_folder = strcat(model.model.name,'_',datestr(now,'yyyy-mm-dd'));
    short_name = strcat(model.model.name,'_inference');
    fit_res.inputs.pathd.results_folder = results_folder;                        
    fit_res.inputs.pathd.short_name     = short_name;
    fit_res.inputs.pathd.runident       = 'initial_setup';

    fit_res.inputs.model = ExtractModelToFit(model);
    
    AMIGO_Prep(fit_res.inputs)
    
    %% Experiment details for AMIGO
    % Inference is run on the training set, the best parameter value
    % selected according to the performance on the test set
    exps_indexTraining = model.model.exp_training_idx;
    fit_res.inputs.exps.n_exp = length(exps_indexTraining);
    
    for iexp = 1:fit_res.inputs.exps.n_exp
        exp_indexData = exps_indexTraining(iexp);
        fit_res.inputs.exps.exp_type{iexp} = experimental_data.exps.exp_type{1,exp_indexData}; 
        fit_res.inputs.exps.n_obs{iexp} = experimental_data.exps.n_obs{1,exp_indexData}; 
        fit_res.inputs.exps.obs_names{iexp} = char(model.exp_info.obs_names);
        fit_res.inputs.exps.obs{iexp} = char(model.exp_info.obs);
        fit_res.inputs.exps.u_interp{iexp} = experimental_data.exps.u_interp{1,exp_indexData};
        fit_res.inputs.exps.t_f{iexp} = experimental_data.exps.t_f{1,exp_indexData}; 
        fit_res.inputs.exps.n_s{iexp} = experimental_data.exps.n_s{1,exp_indexData};
        fit_res.inputs.exps.t_s{iexp} = experimental_data.exps.t_s{1,exp_indexData}; 
        fit_res.inputs.exps.t_con{iexp} = experimental_data.exps.t_con{1,exp_indexData};
        fit_res.inputs.exps.n_steps{iexp} = experimental_data.exps.n_steps{1,exp_indexData};
        fit_res.inputs.exps.u{iexp} = experimental_data.exps.u{1,exp_indexData};
        fit_res.inputs.exps.exp_data{iexp} = experimental_data.exps.exp_data{1,exp_indexData};
        fit_res.inputs.exps.error_data{iexp} = experimental_data.exps.error_data{1,exp_indexData};
        fit_res.inputs.exps.exp_y0{iexp} = ModelComputeInitialCondition(fit_res.inputs,...
                                                                        fit_res.inputs.model.par,...
                                                                        iexp,...
                                                                        fit_res.inputs.exps.exp_data{iexp}(1,:),...
                                                                        experimental_data.exps.u_0{1,exp_indexData});
    end

    
    fit_res.inputs.exps.data_type= experimental_data.exps.data_type;
    fit_res.inputs.exps.noise_type= experimental_data.exps.noise_type;

    fit_res.inputs.PEsol.id_global_theta=fit_res.inputs.model.par_names;
    
    % GLOBAL UNKNOWNS for PE
    boundperIter = setGuessAndBounds(fit_res.inputs.model.par,model.model.name);
%     boundperIter_iter = boundperIter.(string(fieldnames(boundperIter)));
%     boundperIter_model = boundperIter_iter.(string(fieldnames(boundperIter_iter))); 
    
%     fit_res.global_theta_guess = boundperIter_model.guess;
%     fit_res.inputs.PEsol.global_theta_max = boundperIter_model.max;  % Maximum allowed values for the parameters
%     fit_res.inputs.PEsol.global_theta_min = boundperIter_model.min;  % Minimum allowed values for the parameters
   
    fit_res.global_theta_guess = boundperIter.guess;
    fit_res.inputs.PEsol.global_theta_max = boundperIter.max;  % Maximum allowed values for the parameters
    fit_res.inputs.PEsol.global_theta_min = boundperIter.min;  % Minimum allowed values for the parameters

 
    
    
end










function [ output_args ] = OED4SBL(model,inputs)

    % Add new experiment that is to be designed
    inputs.exps.n_exp = inputs.exps.n_exp + 1;               
    iexp = inputs.exps.n_exp;                                
    inputs.exps.exp_type{iexp}='od';                         
    inputs.exps.n_obs{iexp}=2;                               
    inputs.exps.obs_names{iexp}=inputs.exps.obs_names{iexp-1}
    inputs.exps.obs{iexp}=inputs.exps.obs{iexp-1};       
    

    %% Fixed parts of the experiment
    inputs.exps.exp_y0{iexp}=oid_y0;                                
    inputs.exps.t_f{iexp}=duration;                                 
    inputs.exps.n_s{iexp}=duration/5+1;                             
    
    %% OED of the input
    inputs.exps.u_type{iexp}='od';
    inputs.exps.u_interp{iexp}='stepf';                             
    inputs.exps.n_steps{iexp}=round(duration/stepDuration);         
    inputs.exps.t_con{iexp}=0:stepDuration:(duration);                
    inputs.exps.u_min{iexp}= [0*ones(1,inputs.exps.n_steps{iexp}); 0*ones(1,inputs.exps.n_steps{iexp})]+1e-7;
    inputs.exps.u_max{iexp}=[1*ones(1,inputs.exps.n_steps{iexp}); 100*ones(1,inputs.exps.n_steps{iexp})];
    
    
    
    inputs.PEsol.id_global_theta=model.par_names;
    inputs.PEsol.global_theta_guess=transpose(global_theta_guess);
    inputs.PEsol.global_theta_max=global_theta_max;  % Maximum allowed values for the parameters
    inputs.PEsol.global_theta_min=global_theta_min;  % Minimum allowed values for the parameters
    
    
    inputs.exps.noise_type='hetero_proportional';           % Experimental noise type: Homoscedastic: 'homo'|'homo_var'(default)
    inputs.exps.std_dev{1}=[0.05 0.05];
    inputs.OEDsol.OEDcost_type='Dopt';
    
    
 
    % OPTIMIZATION
    %oidDuration=600;
    inputs.nlpsol.nlpsolver='eSS';
    inputs.nlpsol.eSS.maxeval = 200000;
    inputs.nlpsol.eSS.maxtime = 5000;
    inputs.nlpsol.eSS.local.solver = 'fmincon'; 
    inputs.nlpsol.eSS.local.finish = 'fmincon';
    
    inputs.nlpsol.eSS.local.nl2sol.maxiter  =     500;     % max number of iteration
    inputs.nlpsol.eSS.local.nl2sol.maxfeval =     500;     % max number of function evaluation    
    inputs.pathd.results_folder = results_folder;
    inputs.pathd.short_name     = short_name;
    inputs.pathd.runident       = strcat('oed-',int2str(i));
        
    [inputs,privstruct]=AMIGO_Prep(inputs);
    
    results = AMIGO_OED(inputs);
    oed_results{i} = results;
    
    
    results.plotd.plotlevel = 'noplot';

end


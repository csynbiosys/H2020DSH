function [ output_args ] = OED4SBL(inputs,duration,stepDuration)

    % Add new experiment that is to be designed
    inputs.exps.n_exp = inputs.exps.n_exp + 1;               
    iexp = inputs.exps.n_exp;                                
    inputs.exps.exp_type{iexp}='od';                         
    inputs.exps.n_obs{iexp}=2;                               
    inputs.exps.obs_names{iexp}=inputs.exps.obs_names{iexp-1};
    inputs.exps.obs{iexp}=inputs.exps.obs{iexp-1};       
    

    %% Fixed parts of the experiment
    inputs.exps.exp_y0{iexp}=inputs.exps.exp_y0{1};                                
    inputs.exps.t_f{iexp}=duration;                                 
    inputs.exps.n_s{iexp}=duration/5+1;                             
    inputs.exps.t_s{iexp}=0:5:(duration);
    
    %% OED of the input
    inputs.exps.u_type{iexp}='od';
    inputs.exps.u_interp{iexp}='stepf';                             
    inputs.exps.n_steps{iexp}=round(duration/stepDuration);         
    inputs.exps.t_con{iexp}=0:stepDuration:(duration);                
    inputs.exps.u_min{iexp}= [0*ones(1,inputs.exps.n_steps{iexp}); 0*ones(1,inputs.exps.n_steps{iexp})]+1e-7;
    inputs.exps.u_max{iexp}=[1*ones(1,inputs.exps.n_steps{iexp}); 100*ones(1,inputs.exps.n_steps{iexp})];
    inputs.exps.u{iexp}=inputs.exps.u_min{iexp};
    inputs.exps.exp_data{iexp}=ones(inputs.exps.n_obs{iexp},inputs.exps.n_s{iexp});
    inputs.exps.error_data{iexp}=ones(inputs.exps.n_obs{iexp},inputs.exps.n_s{iexp});
    
    
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
    

    inputs.model.exe_type='standard';
    
    [inputs,privstruct]=AMIGO_Prep(inputs);
    
    results = AMIGO_OED(inputs);
    oed_results{i} = results;
    
    
    results.plotd.plotlevel = 'noplot';

end


function [inputs] = OED4SBL(MODELS,sbl_config,index)
    
    duration=sbl_config.OED4est.duration;
    stepDuration=sbl_config.OED4est.stepDuration;
    samplingTime=sbl_config.OED4est.samplingTime;

    inputs=MODELS{index}{1};
    
    %% Add new experiment, the one being desinged
    inputs.exps.n_exp = inputs.exps.n_exp + 1;               
    iexp = inputs.exps.n_exp;                                
    inputs.exps.exp_type{iexp}='od';                         
    inputs.exps.n_obs{iexp}=inputs.exps.n_obs{iexp-1};                               
    inputs.exps.obs_names{iexp}=inputs.exps.obs_names{iexp-1};
    inputs.exps.obs{iexp}=inputs.exps.obs{iexp-1};       

    %% Fixed parts of the experiment
    inputs.exps.exp_y0{iexp}=inputs.exps.exp_y0{1};                                
    inputs.exps.t_f{iexp}=duration;                                 
    inputs.exps.n_s{iexp}=floor(duration/samplingTime)+1;                             
    inputs.exps.t_s{iexp}=0:samplingTime:(duration);
    
    %% Define OED Problem
    inputs.exps.u_type{iexp}='od';
    inputs.exps.u_interp{iexp}='stepf';                             
    inputs.exps.n_steps{iexp}=round(duration/stepDuration);         
    inputs.exps.t_con{iexp}=0:stepDuration:(duration);                
    inputs.exps.u_min{iexp}= [0*ones(1,inputs.exps.n_steps{iexp}); 0*ones(1,inputs.exps.n_steps{iexp})]+1e-7;
    inputs.exps.u_max{iexp}=[1*ones(1,inputs.exps.n_steps{iexp}); 100*ones(1,inputs.exps.n_steps{iexp})];
    inputs.exps.u{iexp}=inputs.exps.u_min{iexp};
    inputs.exps.exp_data{iexp}=ones(inputs.exps.n_obs{iexp},inputs.exps.n_s{iexp});
    inputs.exps.error_data{iexp}=ones(inputs.exps.n_obs{iexp},inputs.exps.n_s{iexp});
    
    %% Assumed noise model for the data
    inputs.exps.noise_type='hetero_proportional';
    inputs.exps.std_dev{1}=[0.05 0.05];
    inputs.OEDsol.OEDcost_type='Dopt';
    
    %% OPTIMIZATION
    inputs.nlpsol.nlpsolver='eSS';
    inputs.nlpsol.eSS=sbl_config.OED4est.eSS;
    
    %% Costmex is not operational for OED, recompile in standard mode
    inputs.model.exe_type='standard';
    
    %% Dont plot
    [inputs,privstruct]=AMIGO_Prep(inputs);
    
    %% RUN OED
    results = AMIGO_OED(inputs);
    
    %% Put the results in the AMIGO format
    inputs.exps.u_interp{iexp}='step';
    inputs.exps.n_steps{iexp}=(duration)/stepDuration;
    inputs.exps.t_con{iexp}=0:stepDuration:(duration);
    inputs.exps.u{iexp}=[results.oed.u{results.oed.n_exp} results.oed.u{results.oed.n_exp}(:,end)];
    
end


function [newExps] = OED4SBL(inputs,duration,stepDuration,samplingTime)

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
    inputs.exps.n_s{iexp}=duration/samplingTime+1;                             
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
    
    %% Assumed noise model for the data
    inputs.exps.noise_type='hetero_proportional';
    inputs.exps.std_dev{1}=[0.05 0.05];
    inputs.OEDsol.OEDcost_type='Dopt';
    
    %% OPTIMIZATION
    inputs.nlpsol.nlpsolver='eSS';
    inputs.nlpsol.eSS.maxeval = 1000;
    inputs.nlpsol.eSS.local.solver = 'fmincon'; 
    inputs.nlpsol.eSS.local.finish = 0;
    inputs.nlpsol.eSS.dim_refset=20;
    inputs.nlpsol.eSS.ndiverse=60;
    inputs.nlpsol.eSS.local.n1=1;
    inputs.nlpsol.eSS.local.n2=1;
    inputs.nlpsol.eSS.maxtime=inf;
    
    %% Costmex is not operational for OED, recompile in standard mode
    inputs.model.exe_type='standard';
    inputs.plotd.plotlevel
    
    [inputs,privstruct]=AMIGO_Prep(inputs);
    
    %% RUN ODE
    results = AMIGO_OED(inputs);
    
    %% Put the results in the AMIGO format
    inputs.exps.u_interp{1}='step';
    inputs.exps.n_steps{1}=(duration)/stepDuration;
    inputs.exps.t_con{1}=0:stepDuration:(duration);
    inputs.exps.u{1}=[exps.u{1} results.oed.u{results.oed.n_exp}];
    
    
end


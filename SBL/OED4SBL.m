function [inputs] = OED4SBL(inputs,duration,stepDuration,samplingTime,model_name)

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
    inputs.nlpsol.eSS.maxeval = 10000;
    inputs.nlpsol.eSS.local.solver = 'fmincon'; 
    inputs.nlpsol.eSS.local.finish = 0;
    inputs.nlpsol.eSS.dim_refset=20;
    inputs.nlpsol.eSS.ndiverse=100;
    inputs.nlpsol.eSS.local.n1=5;
    inputs.nlpsol.eSS.local.n2=5;
    inputs.nlpsol.eSS.maxtime=inf;
    
    %% Costmex is not operational for OED, recompile in standard mode
    inputs.model.odes_file=['Models/AutoGeneratedC/' model_name '.c'];
    inputs.model.mexfile=['Models/AutoGeneratedC/' model_name 'standardMex'];
    inputs.model.exe_type='standard';
    
    %% Dont plot
    inputs.plotd.plotlevel='noplot';
    [inputs,privstruct]=AMIGO_Prep(inputs);
    
    %% RUN ODE
    results = AMIGO_OED(inputs);
    
    %% Put the results in the AMIGO format
    inputs.exps.u_interp{iexp}='step';
    inputs.exps.n_steps{iexp}=(duration)/stepDuration;
    inputs.exps.t_con{iexp}=0:stepDuration:(duration);
    inputs.exps.u{iexp}=[results.oed.u{results.oed.n_exp} results.oed.u{results.oed.n_exp}(:,end)];
    
    
end

function [inputs,privstruct] = generate_template4OED(inputs,duration,stepDuration,samplingTime)

%% Add new experiment, the one being desinged

inputs.exps.n_exp = inputs.exps.n_exp + 1;
iexp=inputs.exps.n_exp;

newexp.n_exp=1;
newexp.exp_type{1}='od';
newexp.n_obs{1}=inputs.exps.n_obs{iexp-1};
newexp.obs_names{1}=inputs.exps.obs_names{iexp-1};
newexp.obs{1}=inputs.exps.obs{iexp-1};

%% Fixed parts of the experiment
newexp.exp_y0{1}=inputs.exps.exp_y0{1};
newexp.t_f{1}=duration;
newexp.n_s{1}=duration/samplingTime+1;
newexp.t_s{1}=0:5:(duration);

%% Define OED Problem
newexp.u_type{1}='od';
newexp.u_interp{1}='stepf';
newexp.n_steps{1}=round(duration/stepDuration);
newexp.t_con{1}=0:stepDuration:(duration);
newexp.u_min{1}= [0*ones(1,newexp.n_steps{1}); 0*ones(1,newexp.n_steps{1})]+1e-7;
newexp.u_max{1}=[1*ones(1,newexp.n_steps{1}); 100*ones(1,newexp.n_steps{1})];
newexp.u{1}=newexp.u_min{1};
newexp.exp_data{1}=ones(newexp.n_obs{1},newexp.n_s{1});
newexp.error_data{1}=ones(newexp.n_obs{1},newexp.n_s{1});

%% Assumed noise model for the data
newexp.noise_type='hetero_proportional';
newexp.std_dev{1}=[0.05 0.05];
inputs.model.compile_model=0;
inputs.model.overwrite_model=0;
inputs.exps=newexp;

%% Dont plot
[inputs,privstruct]=AMIGO_Prep(inputs);


end


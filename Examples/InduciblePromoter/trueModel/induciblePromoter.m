load InduciblePromoter_Pulse-1;
inputs.plotd.plotlevel='full';

inputs.exps.exp_y0{1}=[inputs.exps.exp_y0{1} 0];
EXPS=inputs.exps;

load InduciblePromoter_Random-1;


iexp=2;
EXPS.n_obs{iexp}=exps.n_obs{1};
EXPS.obs_names{iexp}=exps.obs_names{1};
EXPS.obs{iexp}=exps.obs{1};
EXPS.exp_y0{iexp}=[exps.exp_y0{1} 0];
EXPS.t_f{iexp}=exps.t_f{1};
EXPS.n_s{iexp}=exps.n_s{1};
EXPS.t_s{iexp}=exps.t_s{1};
EXPS.u_interp{iexp}=exps.u_interp{1};
EXPS.n_steps{iexp}=exps.n_steps{1};
EXPS.t_con{iexp}=exps.t_con{1};
EXPS.u{iexp}=exps.u{1};
EXPS.exp_type{iexp}=exps.exp_type{1};
EXPS.exp_data{iexp}=exps.exp_data{1};
EXPS.error_data{iexp}=exps.error_data{1};
EXPS.data_type=exps.data_type;
EXPS.noise_type=exps.noise_type;

load InduciblePromoter_Step-1;
iexp=3;
EXPS.n_obs{iexp}=exps.n_obs{1};
EXPS.obs_names{iexp}=exps.obs_names{1};
EXPS.obs{iexp}=exps.obs{1};
EXPS.exp_y0{iexp}=[exps.exp_y0{1} 0];
EXPS.t_f{iexp}=exps.t_f{1};
EXPS.n_s{iexp}=exps.n_s{1};
EXPS.t_s{iexp}=exps.t_s{1};
EXPS.u_interp{iexp}=exps.u_interp{1};
EXPS.n_steps{iexp}=exps.n_steps{1};
EXPS.t_con{iexp}=exps.t_con{1};
EXPS.u{iexp}=exps.u{1};
EXPS.exp_type{iexp}=exps.exp_type{1};
EXPS.exp_data{iexp}=exps.exp_data{1};
EXPS.error_data{iexp}=exps.error_data{1};
EXPS.data_type=exps.data_type;
EXPS.noise_type=exps.noise_type;

inputs.plotd.plotlevel='full';


load InputComparison-OptstepseSS-1_loops-1;
iexp=4;

EXPS.n_obs{iexp}=exps.n_obs{1};
EXPS.obs_names{iexp}=exps.obs_names{1};
EXPS.obs{iexp}=exps.obs{1};
EXPS.exp_y0{iexp}=[exps.exp_y0{1} ];
EXPS.t_f{iexp}=exps.t_f{1};
EXPS.n_s{iexp}=exps.n_s{1};
EXPS.t_s{iexp}=exps.t_s{1};
EXPS.u_interp{iexp}=exps.u_interp{1};
EXPS.n_steps{iexp}=exps.n_steps{1};
EXPS.t_con{iexp}=exps.t_con{1};
EXPS.u{iexp}=exps.u{1};
EXPS.exp_type{iexp}=exps.exp_type{1};
EXPS.exp_data{iexp}=exps.exp_data{1};
EXPS.error_data{iexp}=exps.error_data{1};
EXPS.data_type=exps.data_type;
EXPS.noise_type=exps.noise_type;
inputs.exps=EXPS;

inputs.exps.n_exp=4;
inputs.plotd.plotlevel='full';
inputs.model.exe_type='costMex';

[inputs privstruct]=AMIGO_Prep(inputs);


function [resGS] = GSens4SBL(inputs)

inputsPre = inputs;
clear inputs;
inputs={};
results_folder = strcat('GlobalSensitivityAnalysis',datestr(now,'yyyy-mm-dd-HHMMSS'));
short_name     = strcat('GSens',inputsPre.model.matlabmodel_file);

pathd={};
pathd.results_folder = results_folder;                        
pathd.short_name     = short_name;
pathd.runident       = 'initial_setup';
inputs.pathd=pathd;

% Model
model = {};
model.input_model_type=inputsPre.model.input_model_type;
model.n_st=inputsPre.model.n_st;
model.n_par=inputsPre.model.n_par;
model.n_stimulus=inputsPre.model.n_stimulus;
model.st_names=inputsPre.model.st_names;
model.par_names=inputsPre.model.par_names;
model.stimulus_names=inputsPre.model.stimulus_names;
model.eqns=inputsPre.model.eqns;
model.par=inputsPre.model.par;

inputs.model=model;

exps = {};
exps.n_exp = inputsPre.exps.n_exp;
exps.exp_type = inputsPre.exps.exp_type; 
exps.n_obs = inputsPre.exps.n_obs; 
exps.obs_names = inputsPre.exps.obs_names;
exps.obs = inputsPre.exps.obs;
exps.u_interp = inputsPre.exps.u_interp;
exps.t_f = inputsPre.exps.t_f; 
exps.n_s = inputsPre.exps.n_s;
exps.t_s = inputsPre.exps.t_s;

exps.u = inputsPre.exps.u;

exps.t_con = inputsPre.exps.t_con;
exps.n_steps = inputsPre.exps.n_steps;

exps.data_type = inputsPre.exps.data_type; 
exps.noise_type = inputsPre.exps.noise_type;
exps.exp_data = inputsPre.exps.exp_data;
exps.error_data = inputsPre.exps.error_data;
exps.exp_y0 = inputsPre.exps.exp_y0;
inputs.exps=exps;



PEsol={};
PEsol.id_global_theta=inputsPre.PEsol.id_global_theta;
PEsol.global_theta_guess=inputsPre.PEsol.global_theta_guess;
PEsol.global_theta_max=inputsPre.PEsol.global_theta_max;  % Maximum allowed values for the parameters
PEsol.global_theta_min=inputsPre.PEsol.global_theta_min;  % Minimum allowed values for the parameters

inputs.PEsol=PEsol;

% inputs=rmfield(inputs, 'DOsol');
% inputs=rmfield(inputs, 'OEDsol');

% inputs.model = rmfield(inputs.model,'compile_model');
%==================================
% NUMERICAL METHDOS RELATED DATA
%==================================

% SIMULATION                                             % Default for charmodel C: CVODES
ivpsol={};
ivpsol.ivpsolver='cvodes';
ivpsol.senssolver='cvodes';
ivpsol.rtol=1.0D-6;
ivpsol.atol=1.0D-6;
inputs.ivpsol=ivpsol;

% COST FUNCTION RELATED DATA
inputs.PEsol.PEcost_type='lsq';                       % 'lsq' (weighted least squares default) | 'llk' (log likelihood) | 'user_PEcost'
inputs.PEsol.lsq_type='Q_expmax';

% OPTIMIZATION
nlpsol={};
nlpsol.nlpsolver='eSS';
nlpsol.eSS.maxeval = 10;
nlpsol.eSS.local.solver = 'lsqnonlin'; 
nlpsol.eSS.local.finish = 'lsqnonlin';
nlpsol.eSS.maxtime=10;
inputs.nlpsol = nlpsol;

inputs.plotd.plotlevel='noplot';

inputs.rank.gr_samples=10000; % Reduce?     

[inputs,privstruct] = AMIGO_Prep(inputs);
inputsGS=inputs;
resGS = AMIGO_GRank(inputs);

save(['GSens_',inputsPre.model.matlabmodel_file,'_',date,'.mat'], 'resGS', 'inputsGS')

end











































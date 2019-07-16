addpath('Models');

model1;

%% Load experimental data. This data are derived, using the script ExtractionAllExperimentalData/ExtractionStructure_AllData_final.m,
% starting from data used in the paper  Lugagne et al.
% The data derives from 26 experiments, 6 calibration and 20 control
load Data/AllDataLugagne_Final.mat;

%% Initial guesses for theta
global_theta_min = inputs.model.par.*0.2;
global_theta_max = inputs.model.par+ 5.*inputs.model.par;
global_theta_guess=inputs.model.par;
inputs.model.par = global_theta_guess;

%% Results folder stf
inputs.pathd.results_folder = model_name;
inputs.pathd.short_name     = model_name';
inputs.pathd.runident       = 'initial_setup';

%% Select experiments
exps_indexall =[1:21 25];
exps_indexTraining=exps_indexall;
Y0 = 1e-3.*ones(length(exps_indexTraining),model.n_st);

for iexp=1:length(exps_indexTraining)
    exp_indexData = exps_indexTraining(iexp);
end

exps.n_exp = length(exps_indexTraining);

for iexp=1:length(exps_indexTraining)
    
    exp_indexData = exps_indexTraining(iexp);
    exps.exp_type{iexp} = 'fixed';
    exps.n_obs{iexp} = 2;
    exps.obs_names{iexp} = char('RFP','GFP');
    exps.obs{iexp} = char('RFP = L_RFP','GFP = T_GFP');
    exps.t_f{iexp} = Data.t_con{1,exp_indexData}(1,end);
    exps.n_s{iexp} = Data.n_samples{1,exp_indexData}(1,1);
    exps.t_s{iexp} = Data.t_samples{1,exp_indexData}(1,:);
    exps.u_interp{iexp} = 'step';
    exps.t_con{iexp} = Data.t_con{1,exp_indexData}(1,:);
    exps.n_steps{iexp} = length(exps.t_con{iexp})-1;
    exps.u{iexp} = Data.input{1,exp_indexData};
    exps.data_type = 'real';
    exps.noise_type = 'homo';
    
    exps.exp_data{iexp} = Data.exp_data{1,exp_indexData}';
    exps.error_data{iexp} = Data.standard_dev{1,exp_indexData}';
    exps.exp_y0{iexp} = [Data.exp_data{iexp}(1:2,1)' Data.Initial_IPTG{iexp} Data.Initial_aTc{iexp}];
    
    exps.u{iexp}(exps.u{iexp}==0)=1e-3;
    exps.exp_y0{iexp}(exps.exp_y0{iexp}==0)=1e-3;
    
end

%% Select parameters to estimate
best_global_theta = global_theta_guess;
param_including_vector =1:length(best_global_theta);

inputs.model = model;
inputs.model.par = best_global_theta;
inputs.exps  = exps;

inputs.PEsol.id_global_theta=model.par_names(param_including_vector,:);
inputs.PEsol.global_theta_guess=best_global_theta(param_including_vector);
inputs.PEsol.global_theta_max=global_theta_max(param_including_vector);
inputs.PEsol.global_theta_min=global_theta_min(param_including_vector);

%% COST FUNCTION RELATED DATA
inputs.PEsol.PEcost_type='lsq';                     
inputs.PEsol.lsq_type='Q_expmax';
inputs.PEsol.llk_type='homo_var';                   

[inputs privstruct]=AMIGO_Prep(inputs);




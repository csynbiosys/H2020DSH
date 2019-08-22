
%% Load experimental data. This data are derived, using the script ExtractionAllExperimentalData/ExtractionStructure_AllData_final.m,
% starting from data used in the paper  Lugagne et al.
% The data derives from 26 experiments, 6 calibration and 20 control
SBL_workdir;
load(fullfile(SBL_work_dir,'Examples/ToggleSwitch/TrueModel/AllDataLugagne_Final.mat'));

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
exps_indexall =[1 2 3 4 5 6 12 13 19 20];
exps_indexall =[4 5 6 12 13 19 20];
exps_indexTraining=exps_indexall;
Y0 = 1e-3.*ones(length(exps_indexTraining),model.n_st);

exps.n_exp = length(exps_indexTraining);

ICs=importdata(fullfile(SBL_work_dir,'Examples/ToggleSwitch/TrueModel', ['ICs' model_name '.csv']));
INITIALU={};
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
    
    exps.exp_data{iexp} = Data.exp_data{exp_indexData}';
    exps.error_data{iexp} = Data.standard_dev{exp_indexData}';
    exps.u{iexp}(exps.u{iexp}==0)=1e-6;
    INITIALU{iexp}=[Data.Initial_IPTG{exp_indexData} Data.Initial_aTc{exp_indexData}];
    exps.exp_y0{iexp} = ICs(exp_indexData,:);
    exps.exp_y0{iexp}(3:4)=compute_steady_state(inputs.model.par,INITIALU{iexp}(1),INITIALU{iexp}(2)) ;
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
inputs.PEsol.PEcost_type='llk';                     
inputs.PEsol.llk_type='homo_var';                   
inputs.ivpsol.nthreads=8;           

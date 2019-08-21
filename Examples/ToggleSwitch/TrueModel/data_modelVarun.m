
%% Load experimental data. This data are derived, using the script ExtractionAllExperimentalData/ExtractionStructure_AllData_final.m,
% starting from data used in the paper  Lugagne et al.
% The data derives from 26 experiments, 6 calibration and 20 control
load Data/AllDataLugagne_Final.mat;

%% Initial guesses for theta
global_theta_min = PARS.data(:,2)';
global_theta_max = PARS.data(:,3)';
global_theta_guess=inputs.model.par;
inputs.model.par = global_theta_guess;
inputs.PEsol.global_theta_guess=global_theta_guess;
inputs.PEsol.global_theta_max=global_theta_max;
inputs.PEsol.global_theta_min=global_theta_min;


%% Results folder stf
inputs.pathd.results_folder = model_name;
inputs.pathd.short_name     = model_name';
inputs.pathd.runident       = 'initial_setup';

%% Select experiments
exps_indexall =1:length(Data.exp_data);
exps_indexTraining=exps_indexall;
Y0 = 1e-3.*ones(length(exps_indexTraining),model.n_st);

vecInput = [];
vecData  = [];

for iexp=exps_indexTraining
    
    vecInput=[vecInput;Data.input{iexp}'];
    vecData=[vecData;Data.exp_data{iexp}']; 
    
end

min_input=min(vecInput);
max_input=max(vecInput);
min_data=min(abs(vecData));
max_data=max(abs(vecData));
Data.initial={};

for iexp=exps_indexTraining
    
    for jobs=1:size(Data.exp_data{iexp},1)
         Data.exp_data{iexp}(jobs,:)=(Data.exp_data{iexp}(jobs,:)-min_data(jobs))./(max_data(jobs)-min_input(jobs));
    end

    for jinput=1:size(Data.input{iexp},1)
        Data.input{iexp}(jinput,:)=(Data.input{iexp}(jinput,:)-min_input(jinput))./(max_input(jinput)-min_input(jinput));
    end
    
    Data.initial{iexp}=[Data.Initial_IPTG{iexp} Data.Initial_aTc{iexp}]';
    
    for jinput=1:size(Data.input{iexp},1)
        Data.initial{iexp}(jinput,:)=(Data.initial{iexp}(jinput,:)-min_input(jinput))./(max_input(jinput)-min_input(jinput));
    end
    
end

%exps_indexall =[4 5 6 12 13 19 20];
exps_indexall =[1 2 3 4 5 6 7 8 9 12 13 19 20];
exps_indexTraining=exps_indexall;
exps.n_exp = length(exps_indexTraining);


ICs=importdata(['Data/ICs' model_name '.csv']);

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
    exps.u{iexp} = [Data.input{exp_indexData}(2,:);Data.input{exp_indexData}(1,:) ] ;
    exps.data_type = 'real';
    exps.noise_type = 'homo';
    
    exps.exp_data{iexp} = [Data.exp_data{exp_indexData}(1,:)' Data.exp_data{exp_indexData}(2,:)'];
    %exps.error_data{iexp} = [Data.exp_data{exp_indexData}(2,:)' Data.exp_data{exp_indexData}(1,:)';
    exps.exp_y0{iexp} = ICs(exp_indexData,:);
    exps.u{iexp}(exps.u{iexp}==0)=1e-6;
    
    
end

%% Select parameters to estimate
best_global_theta = global_theta_guess;
param_including_vector =1:length(best_global_theta);

inputs.model = model;
inputs.model.par = best_global_theta;
inputs.exps  = exps;



%% COST FUNCTION RELATED DATA
inputs.PEsol.PEcost_type='lsq';                     
inputs.PEsol.lsq_type='Q_expmax';
inputs.PEsol.llk_type='homo_var';                   
inputs.ivpsol.nthreads=8;
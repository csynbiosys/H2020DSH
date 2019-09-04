%% Optimal experimental design for model discrimination
% 

%% Load default setting and configure experimental data settings
%  
%

SBL_config_defaults;
sbl_config.data_dir_name = pwd;
sbl_config.data_file_name = 'toggleSwitch_1.csv';
sbl_config.exp_idx=1:5;

%% Generate multiple models by enforcing different sparsity coeficients.
% 
%

sbl_config.sparsity_vec = [0.15 0.2 0.25 0.3];
 
%% Generate and fit a family of models
%

MODELS=SBL_gen_model_family(sbl_config);

%% Compute AIC for all models in the family
%

[AIC,BIC,Chi2,NDATA,NPARS]=SBL_get_AIC_BIC(MODELS);

%% Execute OED for parameter estimation
% Optimal experimental design for paramter estimation. Chose model with
% lowest AIC
%

[~,index]=sort(AIC);
OED4SBL(MODELS,sbl_config,index(1));

%% Plot OED results
% Optimal experimental design for model discrimination seeks to find the
% experiment that maximizes the predicted different between the models.

SBL_plotDiscriminationResult(modelsAfterOED);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);

%% Generate new pseudo experimental data
%

SBL_workdir;
data_file2_original=fullfile(SBL_work_dir,'Data','toggleSwitch_1.csv');
data_file2_pseudo=fullfile(SBL_work_dir,'Data','toggleSwitch_1_OEDparEst.csv');
noise_pseudo_data=0.05;
add_pseudo_data(modelsAfterOED,noise_pseudo_data,data_file2_original,data_file2_pseudo,'model1');







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








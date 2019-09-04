%% Compute AIC and BIC
% 
%

%% Load default setting and configure experimental data
%  
%

SBL_config_defaults;
sbl_config.data_dir_name = pwd;
sbl_config.data_file_name = 'toggleSwitch_1.csv';
sbl_config.exp_idx=1:3;

%% Generate multiple models by enforcing different sparsity coeficients.
% 
%

sbl_config.sparsity_vec = [0.15 0.2 0.25 0.3];
MODELS=SBL_gen_model_family(sbl_config);

%% Compute AIC and RANK parameters according sensitivities
%

[AIC,BIC,Chi2,NDATA,NPARS]=SBL_get_AIC_BIC(MODELS);
[~,index]=sort(AIC);
LRANK4SBL(MODELS,sbl_config,index(1))

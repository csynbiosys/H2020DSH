%% Train a family of models
% 
%

%% Load default setting and configure experimental data settings
%  
%

SBL_config_defaults;
sbl_config.data_dir_name = pwd;
sbl_config.data_file_name = 'toggleSwitch_1.csv';
sbl_config.exp_idx=1:3;
sbl_config.sparsity_vec = [0.15 0.2 0.25 0.3];

%% Apply structural identifiability to each model found by SBL.
% 
%

res=SBL_structural_identifiability(sbl_config);

%% Print the result
% The vector res states which models are structuraly identifiable 0=not identificable
% and 1=identifiable. 

disp(res);
%% Train a family of models
% 
%

%% Load default setting and configure experimental data settings
%  
%

sbl_config.data_dir_name = pwd;
sbl_config.data_file_name = 'toggleSwitch_1.csv';
sbl_config.exp_idx=1:3;
sbl_config.dict_generator = str2func('build_toggle_switch_dict');
sbl_config.estimate_structure_only=0; 
sbl_config.sparsity_vec = [0.05 0.1 0.15 0.2 ];

%% Apply structural identifiability to each model found by SBL.
% 
%

res=SBL_structural_identifiability(sbl_config);

%% Print the result
% The vector res states which models are structuraly identifiable 0=not identificable
% and 1=identifiable. 

disp(res);
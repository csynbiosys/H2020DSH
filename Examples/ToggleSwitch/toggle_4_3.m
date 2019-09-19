%% Train a family of models
% 
%

clear variables;
clc;
close all;
noise_pseudo_data=0.05;

%% Load default setting
%  
%

SBL_config_defaults;

%% Configure experimental data
% 
% 

sbl_config.data_dir_name = pwd;
sbl_config.data_file_name = 'toggleSwitch_1.csv';
sbl_config.exp_idx=1:3;
sbl_config.dict_generator = str2func('build_toggle_switch_dict');
sbl_config.estimate_structure_only=1; 

%% Generate multiple models by enforcing different sparsity coeficients.
% 
%

sbl_config.sparsity_vec = [0.15 0.2 0.25 0.3];
 
%% Generate and fit a family of models
% We generate a family of models with SBL and fit with AMIGO+scatter search
%

MODELS=SBL_gen_model_family(sbl_config);

%% Plot the optimization results and trajectories from the generated model family 
% The convergence curves are given scatter search. Time courses for each
% modeled observable are also ploted along with the experimental
% data. 
%

SBL_plotFamilyFit(MODELS);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);

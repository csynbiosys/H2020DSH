

%% The toggle switch example
% This toggle switch example was generated will a Hill kinetics model
% trained to a subset of the data provided in Lugagne et al. 201x. The
% example is baised in pseudo experimental-data which means that all data
% is generated by the model we have previously trained. This is a standard
% procedure that serves as means of benchmarking the algorithm.
%

clear variables;
clc;
close all;
noise_pseudo_data=0.05;

%%
% A number of settings is defined in the default configuration file. The
% assertiveness of these settings is problem dependent. Settings such as
% the number optimzation solver settings, the experiments considered, or
% number of models (sparsity cases) have default values that should be
% tailored to the problem. 

SBL_config_defaults;

%%
% As example we modify sbl_config.exp_idx for considering only experiments 1
% and 2.

sbl_config.exp_idx=1:2;
 
%% Generate and fit a family of models

%%
% We generate a family of models with SBL and fit with AMIGO+scatter search
% The convergence curves are given scatter search. Time courses for each
% modeled observable are also ploted along with the pseudo experimental
% data. There is substantial progess made by the parameter estimation
% process. 

MODELS=SBL_gen_model_family(sbl_config);
SBL_plotFamilyFit(MODELS);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);

%% Execute OED for model discrimination

%% 
% Optimal experimental design for model discrimination seeks to find the
% experiment that maximizes the predicted different between the models.

modelsAfterOED=OED4SBLdiscrimination(MODELS,sbl_config);
SBL_plotDiscriminationResult(modelsAfterOED);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);

%% Generate new pseudo experimental data

data_file2=fullfile(pwd,'Data','experimental_data_2.csv');
gen_pseudo_data(modelsAfterOED{1}{1}.exps,noise_pseudo_data,data_file2,'model1');
sbl_config.data_dir_name = 'Data';
sbl_config.data_file_name = 'experimental_data_2.csv';


%% Second iteration: generate and fit a family of models
sbl_config.exp_idx=[1 2 8];
% %% Generate and fit a new family of models
MODELS=SBL_gen_model_family(sbl_config);
SBL_plotFamilyFit(MODELS);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);

%% Second interation of OED for model discrimination

%% 
% Optimal experimental design for model discrimination seeks to find the
% experiment that maximizes the predicted different between the models.

modelsAfterOED=OED4SBLdiscrimination(MODELS,sbl_config);
SBL_plotDiscriminationResult(modelsAfterOED);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);


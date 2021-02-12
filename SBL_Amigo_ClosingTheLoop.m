% Script to test merge between SBL and AMIGO
clc,clear all,close all;

%% add required folders to the path and startup AMIGO
initialise_path()

%% Extract models structure and data structure from SBLyaml 
%
network_name = "DataExpand_Network1";

models = SBLyaml_to_AMIGO_models(network_name);

% exps_indexes = union(models(1).model.exp_training_idx,models(1).model.exp_test_idx);
% experimental_data = SBLyaml_to_AMIGO_exps(network_name,exps_indexes);

%% Run Model inference on each of the identified structures
fit_results = {};
for model_idx=1%:2%length(models)
    disp(strcat(['Model being fitted: ',int2str(model_idx)]))
    exps_indexes = union(models(model_idx).model.exp_training_idx,models(model_idx).model.exp_test_idx);
    experimental_data = SBLyaml_to_AMIGO_exps(network_name,exps_indexes);
    fit_results{model_idx} = FitModels(models, experimental_data,model_idx);
end
save(strjoin([".\AMIGOScripts\Results\",network_name,"_",date(),"_","fit_results_all.mat"],""), "fit_results")
% Script to test merge between SBL and AMIGO
clc,clear all,close all;

%% add required folders to the path and startup AMIGO
initialise_path()

%% Extract models structure and data structure from SBLyaml 
%
network_name = "DataExpand_Network1";

models = SBLyaml_to_AMIGO_models(network_name);
%%
sim_results = {};
for model_idx=1:length(models)
    disp(strcat(['Model being tested: ',int2str(model_idx)]))
    exps_indexes = union(models(model_idx).model.exp_training_idx,models(model_idx).model.exp_test_idx);
    experimental_data = SBLyaml_to_AMIGO_exps(network_name,exps_indexes);
    %experimental_data_scaled = SBL_scaled_data(experimental_data,exps_indexes);
    %sim_results{model_idx} = SimModels(models, experimental_data_scaled,model_idx);
    sim_results{model_idx} = SimModels(models, experimental_data,model_idx);
end
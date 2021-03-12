% Script to compare the results of inference of the models with the
% experimental data

clc,clear all,close all;

%% add required folders to the path and startup AMIGO
initialise_path()

%% Extract models structure and data structure from SBLyaml 
%
network_name = "DataExpand_Network1";

models = SBLyaml_to_AMIGO_models(network_name);

if ~isfolder(".\AMIGOScripts\Results\ComparisonInference")
    mkdir(".\AMIGOScripts\Results\ComparisonInference")
end

exps_indexes = union(models(1).model.exp_training_idx,models(1).model.exp_test_idx);
load('D:\H2020_4_2\AMIGOScripts\Results\DataExpand_Network1_Run100_lsq_extFuncEval_12-Mar-2021_fit_results_all.mat')

for iexp =1:length(exps_indexes)
    h = figure(iexp); 
    subplot(2,2,1)
    shadedErrorBar(fit_results{1,1}.exps.t_s{1,iexp},fit_results{1,1}.exps.exp_data{1,iexp}(:,1),fit_results{1,1}.exps.error_data{1,iexp}(:,1),'lineprops','k'); hold on; 
    plot(fit_results{1,1}.exps.t_s{1,iexp},fit_results{1,1}.best_sim.sim.states{1,iexp}(:,1),'b-'); hold on; 
    plot(fit_results{1,1}.exps.t_s{1,iexp},fit_results{1,2}.best_sim.sim.states{1,iexp}(:,1),'r-');
    plot(fit_results{1,1}.exps.t_s{1,iexp},fit_results{1,3}.best_sim.sim.states{1,iexp}(:,1),'g-');
    
    xlabel('time (min)')
    ylabel('y_1 (A.U.)')
    title(strcat('Experiment: ',int2str(iexp)))
    subplot(2,2,2)
    shadedErrorBar(fit_results{1,1}.exps.t_s{1,iexp},fit_results{1,1}.exps.exp_data{1,iexp}(:,2),fit_results{1,1}.exps.error_data{1,iexp}(:,2),'lineprops','k'); hold on; 
    plot(fit_results{1,1}.exps.t_s{1,iexp},fit_results{1,1}.best_sim.sim.states{1,iexp}(:,2),'b-'); hold on; 
    plot(fit_results{1,1}.exps.t_s{1,iexp},fit_results{1,2}.best_sim.sim.states{1,iexp}(:,2),'r-'); hold on; 
    plot(fit_results{1,1}.exps.t_s{1,iexp},fit_results{1,3}.best_sim.sim.states{1,iexp}(:,2),'g-'); hold on; 
    xlabel('time (min)')
    ylabel('y_2 (A.U.)')  
    
    subplot(2,2,3)
    shadedErrorBar(fit_results{1,1}.exps.t_s{1,iexp},fit_results{1,1}.exps.exp_data{1,iexp}(:,3),fit_results{1,1}.exps.error_data{1,iexp}(:,3),'lineprops','k'); hold on; 
    plot(fit_results{1,1}.exps.t_s{1,iexp},fit_results{1,1}.best_sim.sim.states{1,iexp}(:,3),'b-'); hold on; 
    plot(fit_results{1,1}.exps.t_s{1,iexp},fit_results{1,2}.best_sim.sim.states{1,iexp}(:,3),'r-'); hold on; 
    plot(fit_results{1,1}.exps.t_s{1,iexp},fit_results{1,3}.best_sim.sim.states{1,iexp}(:,3),'g-'); hold on; 
    xlabel('time (min)')
    ylabel('y_3 (A.U.)')    
    
    subplot(2,2,4)
    shadedErrorBar(fit_results{1,1}.exps.t_s{1,iexp},fit_results{1,1}.exps.exp_data{1,iexp}(:,4),fit_results{1,1}.exps.error_data{1,iexp}(:,4),'lineprops','k'); hold on; 
    plot(fit_results{1,1}.exps.t_s{1,iexp},fit_results{1,1}.best_sim.sim.states{1,iexp}(:,4),'b-'); hold on; 
    plot(fit_results{1,1}.exps.t_s{1,iexp},fit_results{1,2}.best_sim.sim.states{1,iexp}(:,4),'r-'); hold on; 
    plot(fit_results{1,1}.exps.t_s{1,iexp},fit_results{1,3}.best_sim.sim.states{1,iexp}(:,4),'g-'); hold on; 
    xlabel('time (min)')
    ylabel('y_4 (A.U.)')
    hold off;
    saveas(h, strjoin([".\AMIGOScripts\Results\ComparisonInference\Experiment_",int2str(iexp),"_",date(),".png"],""))

end

 
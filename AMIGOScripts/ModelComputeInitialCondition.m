function [InitialConditions]= ModelComputeInitialCondition(inputs,params,indexExp,InitialExpData,Initial_u)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script to simulate the initial state of the network, assumed to be a
% steady state attained in the overnight incubation. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Inputs:
%       - Inputs: inputs matlab structure required by AMIGO (paths, plot
%       and model need to be defined)
%       - params: theta vector to be used for the simulation
%       - InitialExpData: Experimental values for the observables at the first
%       time point of the experiment
%       - Initial_u: value of the inputs used in the ON incubation


% Fixed parts of the experiment
duration = 24*60;     % Duration of the experiment in min

clear newExps;
newExps.n_exp = 1;
newExps.n_obs{1} = inputs.exps.n_obs{indexExp};                                  % Number of observables per experiment                         
newExps.obs_names{1} = inputs.exps.obs_names{indexExp};     
newExps.obs{1} = inputs.exps.obs{indexExp};                 % Name of the observables 
%newExps.exp_y0{1} = ModelAnalyticalSteadyState(inputs.model,params,Initial_u); Analytical alternative    
newExps.exp_y0{1} = InitialExpData; 
newExps.t_f{1}=duration;               % Experiment duration
    
newExps.u_interp{1}='sustained';
newExps.u{1}= Initial_u;
newExps.t_con{1}=[0,duration];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mock an experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

inputs.exps = newExps;
inputs.plotd.plotlevel='noplot';

% SIMULATION
inputs.ivpsol.ivpsolver='cvodes';
inputs.ivpsol.senssolver='cvodes';
inputs.ivpsol.rtol=1.0D-13;
inputs.ivpsol.atol=1.0D-13;
   
% AMIGO_Prep(inputs);
sim = AMIGO_SModel_NoVer(inputs);

InitialConditions = sim.sim.states{1,1}(end,:);

end
function [InitialConditions]= M1vsM2_Compute_SteadyState_OverNight_ModelSelection(inputs,InitialExpData,Initial_u)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script to simulate the initial state of the model after the
% ON inclubation. We assume that the system is at steady state
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      

% Inputs:
%       - inputs: inputs matlab structure required by AMIGO (paths, plot
%       and model need to be defined)
%       - params: theta vector to be used for the simulation
%       - InitialExpData: Experimental values for the observables at the first
%       time point of the experiment
%       - Initial_u: inducers values used during the ON incubation.


% Fixed parts of the experiment
duration = 24*60;     % Duration of the experiment in min

clear newExps;
newExps.n_exp = 1;
newExps.n_obs{1}=8;                                  % Number of observables per experiment                         
newExps.obs_names{1} = inputs.model.st_names;
newExps.obs{1} = strcat(inputs.model.st_names,' = ',inputs.model.st_names);% Name of the observables 
newExps.exp_y0{1}= InitialExpData;   

newExps.t_f{1}=duration;               % Experiment duration
    
newExps.u_interp{1}='sustained';
newExps.u{1}=[Initial_u(1); Initial_u(2)];
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
sim = AMIGO_SModel(inputs);

InitialConditions = sim.sim.states{1,1}(end,:);

end
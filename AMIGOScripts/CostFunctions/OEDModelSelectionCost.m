%% Cost function for Average Case
% This script computs the cost function as the product of euclidean distance
% between the RFP and GFP simulations of the 2 models. 

% Inputs: 
%       - od: Input profile to be tested
%       - inputs,results,privstruct: AMIGO structures

function [f,g,h] = OEDModelSelectionCost(od,inputs,results,privstruct)


% Set the experimental structure
   
    inputsSIM.model = inputs.model;
    inputsSIM.pathd.results_folder = inputs.pathd.results_folder;                        
    inputsSIM.pathd.short_name     = inputs.pathd.short_name;
    inputsSIM.pathd.runident       = inputs.pathd.runident;
    clear newExps;
    newExps.n_exp = 1;                                         % Number of experiments 
    newExps.n_obs{1}=4;                                        % Number of observables per experiment        
    newExps.obs_names{1} = char('x1_2','x2_2','x3_2','x4_2','x1_1','x2_1','x3_1','x4_1');
    newExps.obs{1} = char('x1_2 =x1_2','x2_2 =x2_2','x3_2 =x3_2','x4_2 =x4_2','x1_1 =x1_1','x2_1 =x2_1','x3_1 =x3_1','x4_1 =x4_1');% Name of the observables 
    newExps.exp_y0{1}=inputs.exps.exp_y0{1};                                      % Initial condition for the experiment    

    newExps.t_f{1}=inputs.exps.t_f{1}+180;                                   % Experiment duration
    newExps.n_s{1}=(180+inputs.exps.t_f{1})/5;                             % Number of sampling times
    newExps.t_s{1}=0:5:inputs.exps.t_f{1}+180-1 ;                              % Times of samples

    newExps.u_interp{1}='step';                                % Interpolating function for the input
    newExps.n_steps{1}=inputs.exps.n_steps{1}+1;                  % Number of steps in the input
    %newExps.u{1}= [[0, od(1:inputs.exps.n_steps{1})]; [100,od(inputs.exps.n_steps{1}+1:end)]]+1e-7;                                     % IPTG and aTc values for the input
    newExps.u{1}= [[1, od(1:inputs.exps.n_steps{1})]; [0,od(inputs.exps.n_steps{1}+1:end)]]+1e-7;                                     % IPTG and aTc values for the input
    
    newExps.t_con{1}=[inputs.exps.t_con{1}, inputs.exps.t_f{1}+180-5];                     % Switching times
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Mock the experiment
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    inputsSIM.exps = newExps;

    % SIMULATION
    inputsSIM.ivpsol.ivpsolver=inputs.ivpsol.ivpsolver;
    inputsSIM.ivpsol.senssolver=inputs.ivpsol.senssolver;
    inputsSIM.ivpsol.rtol=inputs.ivpsol.rtol;
    inputsSIM.ivpsol.atol=inputs.ivpsol.atol;

    inputsSIM.plotd.plotlevel='noplot';

    % Simulate the models 
    y = AMIGO_SModel_NoVer(inputsSIM);
    
    % Euclidean distance obs 1
    f1_Ed_1 = sqrt(sum((y.sim.states{1}(:,1)-y.sim.states{1}(:,5)).^2));
    f2_Ed_2 = sqrt(sum((y.sim.states{1}(:,2)-y.sim.states{1}(:,6)).^2));
    f3_Ed_3 = sqrt(sum((y.sim.states{1}(:,3)-y.sim.states{1}(:,7)).^2));
    f4_Ed_4 = sqrt(sum((y.sim.states{1}(:,4)-y.sim.states{1}(:,8)).^2));

    % Cost function
    f = -(f1_Ed_1*f2_Ed_2*f3_Ed_3*f4_Ed_4);
    %f = -(f3_Ed_3*f4_Ed_4);
	 h(1)=0;
	 g(1)=0;

return










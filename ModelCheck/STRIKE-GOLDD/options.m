function [modelname,paths,opts,submodels,prev_ident_pars] = options() 

modelname = 'SBL_diff_RFPdiff_GFP_1_strike_goldd'; 

paths.meigo     = 'D:/H2020DSH/ModelCheck/jrbanga_-meigo64-33e109c94b25/jrbanga_-meigo64-33e109c94b25/MEIGO'; 
paths.models    = strcat(pwd,filesep,'models'); 
paths.results   = strcat(pwd,filesep,'results'); 
paths.functions = strcat(pwd,filesep,'functions'); 

opts.numeric    = 0;       % calculate rank numerically (= 1) or symbolically (= 0)
opts.replaceICs = 0;       % replace states with known initial conditions (= 1) or use generic values (= 0) when calculating rank
opts.checkObser = 1;       % check observability of states / identifiability of initial conditions (1 = yes; 0 = no).
opts.findcombos = 0;       % try to find identifiable combinations? (1 = yes; 0 = no).
opts.unidentif  = 0;       % use method to try to establish unidentifiability instead of identifiability, when using decomposition. 
opts.forcedecomp= 0;       % always decompose model (1 = yes; 0 = no).
opts.decomp     = 0;       % decompose model if the whole model is too large (1 = yes; 0 = no: instead, calculate rank with few Lie derivatives).
opts.decomp_user= 0;       % when decomposing model, use submodels specified by the user (= 1) or found by optimization (= 0). 
opts.maxLietime = 300;      % max. time allowed for calculating 1 Lie derivative.
opts.maxOpttime = 30;     % max. time allowed for every optimization (if optimization-based decomposition is used).
opts.maxstates  = 2;       % max. number of states in the submodels (if optimization-based decomposition is used).
opts.nnzDerIn   = [10 10 ];    % number of nonzero derivatives of the inputs (specify them in one column per input).

submodels = []; 

prev_ident_pars = [];

end
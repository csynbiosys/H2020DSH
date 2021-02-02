
% First we need an empty structure with the 2 following fields
% (compulsory). 

%%
oed_dat = {};

oed_dat.system = "PL"; 
                      % String indicating PL (PLac) or TS (Toggle Switch)
                      % to know which system to use for the OED. 
oed_dat.iter = 1; % Which set of parameters do you want to use (from which iteration of the process). 
                  % This flag indicates from what fit iteration it is going to be the current oed (and hence
                  % it will use the theta guess from the previous
                  % iteration) so only 1, 2 and 3 are accetable values. 

oed_res = OptimiseModels(oed_dat, "test1");




%%
oed_dat = {};

oed_dat.system = "TS"; 
                      % String indicating PL (PLac) or TS (Toggle Switch)
                      % to know which system to use for the OED. 
oed_dat.iter = 1; % Which set of parameters do you want to use (from which iteration of the process). 
                  % This flag indicates from what fit iteration it is going to be the current oed (and hence
                  % it will use the theta guess from the previous
                  % iteration) so only 1, 2 and 3 are accetable values. 

oed_res = OptimiseModels(oed_dat, "test1");

























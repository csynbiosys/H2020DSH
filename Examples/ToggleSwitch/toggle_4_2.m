
%% Configuration and setup of the toolbox
% This script shows how install and access the default toolbox
% configuration. A number of settings are defined in the default configuration file. The
% assertiveness of these settings is problem dependent. Settings such as
% the number of experiments to consider, data file path, optimzation solver settings or
% number of models (sparsity cases) have default values that should can be
% found in this structure.
%

cd ../..;
SBL_init;
cd Examples/ToggleSwitch
SBL_config_defaults;
sbl_config

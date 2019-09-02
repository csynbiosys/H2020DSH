
%% Input data
% Point the location of the data and chose which experiments indices you
% want to consider. 
%

cd ../..;
SBL_init;
cd Examples/ToggleSwitch
SBL_config_defaults;

sbl_config.data_dir_name = pwd;
sbl_config.data_file_name = 'toggleSwitch_1.csv';
sbl_config.exp_idx=1:3;

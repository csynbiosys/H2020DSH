%% Compute AIC and BIC
% 
%

%% Load default setting and configure experimental data
%  
%

SBL_config_defaults;
sbl_config.data_dir_name = pwd;
sbl_config.data_file_name = 'toggleSwitch_1.csv';
sbl_config.exp_idx=1:3;

%% Generate multiple models by enforcing different sparsity coeficients.
% 
%

sbl_config.sparsity_vec = [0.15 0.2 0.25 0.3];
MODELS=SBL_gen_model_family(sbl_config);

%% Compute AIC and BIC
%

[AIC,BIC,Chi2,NDATA,NPARS]=SBL_get_AIC_BIC(MODELS);

%% Plot AIC and BIC
% Chi2 ((simulation-data)./error_data)'*((simulation-data)./error_data),
% where error data is the standard desviation/
% AIC=Chi2+2*npars;BIC=npars*log(ndata)+Chi2(i)
%

bar(AIC,'b');
ylabel('AIC');
xlabel('Models');
title('AIC');
figure;
bar(BIC,'r');
ylabel('BIC');
xlabel('Models');
title('BIC');

% run the SYSID loop
% ZAT, DSH @ ICL, UEDIN July 2019

%% clean up
clear variables
clc
close all

%%  loop config
loop_iter = 2;
fid = 1; % display on the screen

data_dir_name = 'Data';
% first data set
data_file_name = 'experimental_data_7exps_noise000.csv';

%% start computation
for loop = 1:loop_iter
    
%% Step 1: generate data for SBL
logger(fid,sprintf('loop iter: %d, generating SBL data',loop))

% select the experiments to be considered
exp_idx = [1];
% load data from a file
input_data = datareader_for_SBL(data_dir_name,data_file_name,exp_idx,fid);

%% Step 2: Run SBL 
logger(fid,sprintf('loop iter: %d, running SBL',loop))

%% Step 3: Build an Amigo model
logger(fid,sprintf('loop iter: %d, building an Amigo model',loop))

% RES={};
% clear mex;
% 
% for sparsity_case=1:size(sparsity_vec,2)
%  
%         SBLModel = SBLModel2AMIGOModel(fit_res_diff(:,sparsity_case),Phi,model,['SBL' num2str(sparsity_case)]);
%         
%         [inputs privstruct]=gen_AMIGOSetupFromSBL(SBLModel,'experimental_data_exp1to1_noise000.csv','SBLModel');
%         
% %         [inputs,privstruct,res_ssm]=fit_SBLModel(inputs,privstruct);
% %         RES={inputs,privstruct,res_ssm};
%             
% end

%% Step 4: Run parameter estimation in Amigo
logger(fid,sprintf('loop iter: %d, running parameter est in Amigo',loop))


%% Step 5: Run OED
logger(fid,sprintf('loop iter: %d, running the OED',loop))



%% Step 6: generate new set of data     
logger(fid,sprintf('loop iter: %d, generating new set of data',loop))

data_file_name = '';

logger(fid,sprintf('loop iter: %d is DONE',loop))    
end % end of loop for
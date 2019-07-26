% run the SYSID loop
% ZAT, DSH @ ICL, UEDIN July 2019

%% clean up
clear variables
clc
close all
noise=0;

%%  loop config
loop_iter = 2;
fid = 1; % display on the screen

%% SBL config
sbl_config.display_plots  = 0;
sbl_config.save_results_to_mat = 0;
% generating different model structures
sbl_config.sparsity_vec = [0.02 0.2 2];

%% first dataset
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
    
    [Phi,fit_res_diff,model]  = toggle_switch_SBL(input_data,sbl_config);
    
    %% Step 3: Build an Amigo model
    logger(fid,sprintf('loop iter: %d, building an Amigo model',loop))
    
    RES={};
    clear mex;
    
    
    imported_to_amigo = 0;
    for sparsity_case=3:size(sbl_config.sparsity_vec,2)
        
        if all([fit_res_diff(:,sparsity_case).valid_model] == true)
            SBLModel = SBLModel2AMIGOModel(fit_res_diff(:,sparsity_case),Phi,model,['SBL' num2str(sparsity_case)]);
            
            [inputs privstruct]=gen_AMIGOSetupFromSBL(SBLModel,'experimental_data_exp1to1_noise000.csv','SBLModel');
            imported_to_amigo = imported_to_amigo +1;
        end
        
        %% Step 4: Run parameter estimation in Amigo
        logger(fid,sprintf('loop iter: %d, running parameter est in Amigo',loop))
        [inputs,privstruct,res_ssm]=fit_SBLModel(inputs,privstruct);
        RES{sparsity_case}={inputs,privstruct,res_ssm};
        
        %% Step 5: Run OED
        logger(fid,sprintf('loop iter: %d, running the OED',loop))
        EXPOED=OED4SBL(RES{sparsity_case}{1},120,10,5);
        
        %% Step 6: generate new set of data
        logger(fid,sprintf('loop iter: %d, generating new set of data',loop))
        gen_pseudo_data(inputs.exps,2,noise,['experimental_data_loop_' num2str(loo) '.csv']);
        
    end
    
    if imported_to_amigo == 0
        logger(fid,sprintf('loop iter: %d, there is no valid model to work with, LOOP STOPS',loop))
        break
    end
    
    
    

  
    
    data_file_name = '';
    
    logger(fid,sprintf('loop iter: %d is DONE',loop))
    
end % end of loop for
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

do_struct_id_check = 1;

%% SBL config
sbl_config.display_plots  = 0;
sbl_config.save_results_to_mat = 0;
% generating different model structures
sbl_config.sparsity_vec = [0.2 2];

%% first dataset
data_dir_name = 'Data';

%% start computation

for loop = 1:loop_iter
    
    data_file_name = ['experimental_data_loop_' num2str(loop) '.csv'];
    
    %% Step 1: generate data for SBL
    logger(fid,sprintf('loop iter: %d, generating SBL data',loop))
    
    % select the experiments to be considered
    exp_idx = [1];
    % load data from a file
    input_data = datareader_for_SBL(data_dir_name,data_file_name,exp_idx,fid);
    
    %% Step 2: Run SBL
    logger(fid,sprintf('loop iter: %d, running SBL',loop))
    
    [Phi,fit_res_diff,model]  = toggle_switch_SBL(input_data,sbl_config);
    
    
    %% Step 3: Run Strike-goldd
    if do_struct_id_check
        logger(fid,sprintf('loop iter: %d, running Strike-goldd',loop))
        for sparsity_case=1:size(sbl_config.sparsity_vec,2)

            
            sbl_model_file_name = from_SBL_to_Strike_GOLDD(fit_res_diff(:,sparsity_case),model,Phi,input_data,sparsity_case,data_dir_name);
            
            valid_model = RunModelCheck_in_loop(sbl_model_file_name,fid);
            
            if ~valid_model
                for state=1:size(fit_res_diff,1)
                    fit_res_diff(state,sparsity_case).valid_model = false;
                end
            end
        end
    end
    %% Step 4: Build an Amigo model
    logger(fid,sprintf('loop iter: %d, building an Amigo model',loop))
    
    RES={};
    
    clear mex;
    
    imported_to_amigo = 0;
    for sparsity_case=size(sbl_config.sparsity_vec,2):size(sbl_config.sparsity_vec,2)
        
        % check model validity (valid model has a well defined ODE and struct ID)
        if all([fit_res_diff(:,sparsity_case).valid_model] == true)
            SBLModel = SBLModel2AMIGOModel(fit_res_diff(:,sparsity_case),Phi,model,['SBL' num2str(sparsity_case)]);
            
            [inputs privstruct]=gen_AMIGOSetupFromSBL(SBLModel,data_file_name,'SBLModel');
            imported_to_amigo = imported_to_amigo +1;
            
            %% Step 5: Run parameter estimation in Amigo
            logger(fid,sprintf('loop iter: %d, running parameter est in Amigo',loop))
            
            [inputs,privstruct,res_ssm]=fit_SBLModel(inputs,privstruct);
            RES{sparsity_case}={inputs,privstruct,res_ssm};
            
            %% Step 6: Run OED
            logger(fid,sprintf('loop iter: %d, running the OED',loop));
            
            EXPOED=OED4SBL(RES{sparsity_case}{1},120,10,5,['SBL' num2str(sparsity_case)]);
            
            %% Step 7: generate new set of data
            logger(fid,sprintf('loop iter: %d, generating new set of data',loop))
            
            data_file_name = ['experimental_data_loop_' num2str(loop+1) '.csv'];
            
            gen_pseudo_data(EXPOED.exps,1:length(EXPOED.exps.exp_y0),...
                noise,[data_dir_name filesep data_file_name]);
            
            
        end
    end
    
    if imported_to_amigo == 0
        logger(fid,sprintf('loop iter: %d, there is no valid model to work with, LOOP STOPS',loop))
        break
    end
    
    logger(fid,sprintf('loop iter: %d is DONE',loop))
    
end % end of loop for
% run the SYSID loop
% ZAT, DSH @ ICL, UEDIN July 2019

%% clean up
clear variables
clc
close all
noise=0.05;

%%  loop config fid=display on the screen
loop_iter = 2;
fid = 1;
do_struct_id_check = 0;

%% SBL config
sbl_config.display_plots  = 1;
sbl_config.save_results_to_mat = 0;

%% generating different model structures
sbl_config.sparsity_vec = [0.2 2];

%% first dataset
data_dir_name = 'Data';

%% start computation

for loop = 1:loop_iter
    
    data_file_name = ['experimental_data_loop_' num2str(loop) '.csv'];
    
    %% Step 1: generate data for SBL
    logger(fid,sprintf('loop iter: %d, generating SBL data',loop))
    
    %% load data from a file
    exp_idx = 1:1;
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
    logger(fid,sprintf('loop iter: %d, building an Amigo model',loop));
    clear mex;
    
    imported_to_amigo = 0;
    
    for sparsity_case=1:size(sbl_config.sparsity_vec,2)
        
        %% check model validity (valid model has a well defined ODE and struct ID)
        if all([fit_res_diff(:,sparsity_case).valid_model] == true)
            
            %% Generate model and experiments
            model_name=['SBL' num2str(sparsity_case)];
            SBLModel = SBLModel2AMIGOModel(fit_res_diff(:,sparsity_case),Phi,model,model_name);
            [inputs privstruct]=gen_AMIGOSetupFromSBL(SBLModel,data_file_name,'SBLModel');
            
            imported_to_amigo = imported_to_amigo +1;
            
            %% Global Sensitivity analysis using LHS only need it once
            if loop==1
                GRANK=GSens4SBL(inputs,model_name);
            else
                GRANK={};
            end
            
            %% Step 5: Run parameter estimation in AMIGO
            logger(fid,sprintf('loop iter: %d, running parameter est in Amigo',loop))
            [inputs,privstruct,res_ssm]=fit_SBLModel(inputs,privstruct);
            
            %% Robust identifiability analysis before OED
            logger(fid,sprintf('loop iter: %d, performing RIdent before OED',loop));
            resRIDENT1=RIdent4SBL(inputs,model_name);
            
            %% Step 6: Run OED
            logger(fid,sprintf('loop iter: %d, running the OED',loop));
            EXPOED=OED4SBL(inputs,120,10,5,['SBL' num2str(sparsity_case)]);
            
            %% Step 7: generate new set of data
            logger(fid,sprintf('loop iter: %d, generating new set of data',loop))
            
            switch sparsity_case
                %% Keep results
                case 1
                    [observables,error_data]=gen_pseudo_data(EXPOED.exps,1:length(EXPOED.exps.exp_y0),...
                        noise,[data_dir_name filesep 'experimental_data_loop_' num2str(loop+1) '.csv']);
                    EXPOED.exps.error_data{end}=error_data{end};
                    EXPOED.exps.exp_data{end}=observables{end}+error_data{end};
                    [observables,error_data]=gen_pseudo_data(EXPOED.exps,1:length(EXPOED.exps.exp_y0),...
                        noise,[data_dir_name filesep 'experimental_data_' num2str(sparsity_case) '_loop_' num2str(loop+1) '.csv']);
                    
                case 2
                    [observables,error_data]=gen_pseudo_data(EXPOED.exps,1:length(EXPOED.exps.exp_y0),...
                        noise,[data_dir_name filesep 'experimental_data_' num2str(sparsity_case) '_loop_' num2str(loop+1) '.csv']);
                    EXPOED.exps.error_data{end}=error_data{end};
                    EXPOED.exps.exp_data{end}=observables{end}+error_data{end};
            end
            
            %% Robust identifiability analysis after OED
            logger(fid,sprintf('loop iter: %d, performing RIdent after OED',loop));
            resRIDENT2=RIdent4SBL(EXPOED,model_name);
            
            RES{loop}{sparsity_case}={inputs,privstruct,res_ssm,GRANK,resRIDENT1,resRIDENT2};
            
        end
    end
    
    
    if imported_to_amigo == 0
        logger(fid,sprintf('loop iter: %d, there is no valid model to work with, LOOP STOPS',loop))
        break
    end
    
    logger(fid,sprintf('loop iter: %d is DONE',loop))
    
    save('results')
    
end
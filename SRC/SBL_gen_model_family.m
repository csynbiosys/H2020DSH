% run the SYSID loop
% ZAT, DSH @ ICL, UEDIN July 2019

function MODELS=SBL_gen_model_family(sbl_config)

%% start computation
loop=1;

%% Step 1: generate data for SBL
logger(sbl_config.fid,sprintf('loop iter: %d, generating SBL data',loop))

%% load data from a file
input_data = datareader_for_SBL(sbl_config.data_dir_name,sbl_config.data_file_name,sbl_config.exp_idx,sbl_config.fid);

%% Step 2: Run SBL
logger(sbl_config.fid,sprintf('loop iter: %d, running SBL',loop))
[Phi,fit_res_diff,model]  = model_est_w_SBL(input_data,sbl_config);


%% Step 4: Build an Amigo model
logger(sbl_config.fid,sprintf('loop iter: %d, building an Amigo model',loop));
clear mex;

MODELS={};

for sparsity_case=1:size(sbl_config.sparsity_vec,2)
    
    %% check model validity (valid model has a well defined ODE and struct ID)
    if all([fit_res_diff(:,sparsity_case).valid_model] == true)
        
        %% Generate model and experiments
        model_name=['SBL' num2str(sparsity_case)];
        
        SBLModel = SBLModel2AMIGOModel(fit_res_diff(:,sparsity_case),Phi,model,model_name);
        [inputs privstruct]=gen_AMIGOSetupFromSBL(SBLModel,sbl_config.data_file_name,'SBLModel',sbl_config.exp_idx);
        
        %% Step 5: Run parameter estimation in AMIGO
        logger(sbl_config.fid,sprintf('loop iter: %d, running parameter est in Amigo',loop))
        [inputs,privstruct,res_ssm]=SBL_fitModel(inputs,privstruct,sbl_config);
        MODELS{sparsity_case}={inputs,privstruct,res_ssm};
        
    else
         MODELS{sparsity_case}=[];
    end
    
end

end




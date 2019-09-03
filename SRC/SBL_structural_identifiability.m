function res=SBL_structural_identifiability(sbl_config)

%% start computation
loop=1;

%% load data from a file
input_data = datareader_for_SBL(sbl_config.data_dir_name,sbl_config.data_file_name,sbl_config.exp_idx,sbl_config.fid);

res=zeros(1,size(sbl_config.sparsity_vec,2));
label={};%% Step 3: Run Strike-goldd
if sbl_config.do_struct_id_check
    
    logger(sbl_config.fid,sprintf('loop iter: %d, running Strike-goldd',loop))
    
    %% Step 2: Run SBL
    logger(sbl_config.fid,sprintf('loop iter: %d, running SBL',loop))
    [Phi,fit_res_diff,model]  = toggle_switch_SBL(input_data,sbl_config);
    
    for sparsity_case=1:size(sbl_config.sparsity_vec,2)
        
        sbl_model_file_name = from_SBL_to_Strike_GOLDD(fit_res_diff(:,sparsity_case),model,Phi,input_data,sparsity_case,sbl_config.data_dir_name);
        
        valid_model = RunModelCheck_in_loop(sbl_model_file_name,sbl_config.fid);
        
        if ~valid_model
            label{sparsity_case}=['M' num2str(sparsity_case) ' Not ident'];
            for state=1:size(fit_res_diff,1)
                fit_res_diff(state,sparsity_case).valid_model = false;
            end
            
            res(sparsity_case)=0;
            
        else
            label{sparsity_case}=['M' num2str(sparsity_case) ' ident'];
            
            res(sparsity_case)=1;
            
        end
    end
    
%     figure
%     imagesc(res);
%     text(1:length(label),ones(1,length(label)),label);
%     title('Identifiability analysis');
%     xlabel('Models');
    
    
    
end




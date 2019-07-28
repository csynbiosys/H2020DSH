%% clean up
clear variables
clc
close all

%% config
% turn on/off plots
display_plots  = 0;
% save results to a mat file
save_results = 0;

export_to_amigo = 0;

%% read data for the model

dir_name  = 'Data';
file_name = 'experimental_data_7exps_noise000.csv';

exp_idx = [1];
fid =1;
input_data = datareader_for_SBL(dir_name,file_name,exp_idx,fid);

%% generating the dictionary functions
Phi = build_toggle_switch_dict();

state_num = input_data.state_num;
exp_num = numel(exp_idx);

model.experiment_num = numel(exp_idx);
model.state_names = input_data.state_names;
model.input_names = input_data.input_names;

sparsity_vec = [0.02 0.2 2];

%% for each sparsity
for sparsity_case=1:size(sparsity_vec,2)
    fprintf('runnging sparsity case: %d/%d\n',sparsity_case,size(sparsity_vec,2))
    %% for each dataset
    for l=1:exp_num
        if display_plots
            figure('name','datafit')
        end
        exp_id = exp_idx(l);
        % step differeniate the signal
        dydt =[];
        for k = 1:state_num
            y_tmp = input_data.states{exp_id}(:,k);
            f = fit(input_data.tspan{exp_id},y_tmp,'smoothingspline','SmoothingParam',0.00001);
            dydt(:,k) = differentiate(f,input_data.tspan{exp_id});
            if display_plots
                subplot(state_num,exp_num,sub2ind([state_num exp_num],k,l))
                plot(f,input_data.tspan{exp_id},input_data.states{exp_id}(:,k))
            end
        end
        
        model.dydt{l} = dydt;
        model.variance{l} = sparsity_vec(sparsity_case);
        model.tspan{l} = input_data.tspan{exp_id};
        
        model.input{l} = input_data.inputs{exp_id};
        
        %% evaluate dictionary
        
        x = [input_data.states{exp_id}  input_data.inputs{exp_id}];
        % extra (not estimated) parameters
        p = [];
        % the dicionaries is evaluated for all states and datasets
        Phi_val = cell(state_num,exp_num);
        
        
        for state = 1:state_num
            Phi_val{state,l} = cell2mat(cellfun(@(f) f(x,p),Phi{state},'UniformOutput',false));
        end
        
        %% build a linear regression struct, i.e. y = A*x for each states and data sets
        for k=1:state_num
            sbl_diff(k).name = sprintf('diff_%s',model.state_names{k});
            sbl_diff(k).A{l} = Phi_val{k,l};
            sbl_diff(k).y{l} = model.dydt{l}(:,k);
            sbl_diff(k).std{l} = model.variance{l};
        end
        
    end
    
    %% generate nonneg constraints
    for k=1:state_num
        constraint_idx= [];
        for z=2:size(Phi{k},2)
            if isempty(strfind(func2str(Phi{k}{z}),sprintf('x(:,%d)',k)))
                constraint_idx = [constraint_idx; z];
            end
        end
        sbl_config(k).nonneg{1} = constraint_idx;
        % estimate only the selected states
        sbl_config(k).selected_states = 1:size(model.dydt,2);
        
    end
    %% run SBL
    tic;
    for k=1:state_num
        fprintf('runnging SBL on state: %d/%d\n',k,state_num)
        sbl_config(k).max_iter = 10;
        sbl_config(k).mode = 'SMV';
        fit_res_diff(k,sparsity_case) = vec_sbl(sbl_diff(k),sbl_config(k),model);
    end
    toc;
    %% reporting
    for k=1:state_num
        % use manual tresholding
        zero_th = 1e-4;
        model_num = 1;
        % select non zero dictionaries
        fit_res_diff(k,sparsity_case) = calc_zero_th(fit_res_diff(k,sparsity_case),zero_th,display_plots,k,model_num);
        % report signal fit
        signal_fit_error_diff(k,sparsity_case) = fit_report(fit_res_diff(k,sparsity_case),display_plots);
    end
    %% simulate the reconstructed ODE
    
    % zero out the constant term
    for k=1:state_num
        fit_res_diff(k).w_est{1}(1) = 0;
        idx = find(fit_res_diff(k,sparsity_case).non_zero_dict{1} == 1);
        assert(numel(idx)<2)
        fit_res_diff(k,sparsity_case).non_zero_dict{1}(idx) = [];
    end
    
    simulateSBLresults(Phi,fit_res_diff(:,sparsity_case),model,display_plots);
    %% save results
    if save_results
        save([dir_name '/toggle_switch_sbl_output'],'Phi','fit_res_diff','model','input_data');
    end
    
end

%% export the model variants to Amigo format

if export_to_amigo
    RES={};
    clear mex;
    
    for sparsity_case=2:size(sparsity_vec,2)
        
        SBLModel = SBLModel2AMIGOModel(fit_res_diff(:,sparsity_case),Phi,model,['SBL' num2str(sparsity_case)]);
        
        [inputs privstruct]=gen_AMIGOSetupFromSBL(SBLModel,'experimental_data_exp1to1_noise000.csv','SBLModel');
        
        [inputs,privstruct,res_ssm]=fit_SBLModel(inputs,privstruct);
        
        RES={inputs,privstruct,res_ssm};
    end
   
end

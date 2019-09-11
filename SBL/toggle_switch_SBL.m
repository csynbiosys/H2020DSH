function [Phi,fit_res_diff,model,input_data] = toggle_switch_SBL(input_data,config)

% generating the dictionary functions
Phi = build_toggle_switch_dict();

state_num = input_data.state_num;
exp_num = size(input_data.tspan,2);

model.experiment_num = exp_num;
model.state_names = input_data.state_names;
model.input_names = input_data.input_names;

% check for sparsity cases
if isfield(config,'sparsity_vec')
    sparsity_vec = config.sparsity_vec;
else
    sparsity_vec = 0.2;
end

%% for each sparsity
for sparsity_case=1:size(sparsity_vec,2)
    fprintf('runnging sparsity case: %d/%d\n',sparsity_case,size(sparsity_vec,2))
    %% for each dataset
    for exp_idx=1:exp_num
        if config.display_plots
            figure('name','datafit')
        end
        % step differeniate the signal
        dydt =[];
        for state = 1:state_num
            y_tmp = input_data.states{exp_idx}(:,state);
            f = fit(input_data.tspan{exp_idx},y_tmp,'smoothingspline','SmoothingParam',0.00001);
            dydt(:,state) = differentiate(f,input_data.tspan{exp_idx});
            if config.display_plots
                subplot(state_num,exp_num,sub2ind([state_num exp_num],state,exp_idx))
                plot(f,input_data.tspan{exp_idx},input_data.states{exp_idx}(:,state))
            end
        end
        
        model.dydt{exp_idx} = dydt;
        model.variance{exp_idx} = sparsity_vec(sparsity_case);
        model.tspan{exp_idx} = input_data.tspan{exp_idx};
        
        model.input{exp_idx} = input_data.inputs{exp_idx};
        
        %% evaexp_idxuate dictionary
        
        x = [input_data.states{exp_idx}  input_data.inputs{exp_idx}];
        % extra (not estimated) parameters
        p = [];
        % the dicionaries is evaluated for all states and datasets
        Phi_val = cell(state_num,exp_num);
        
        
        for state = 1:state_num
            Phi_val{state,exp_idx} = cell2mat(cellfun(@(f) f(x,p),Phi{state},'UniformOutput',false));
        end
        
        %% buiexp_idxd a exp_idxinear regression struct, i.e. y = A*x for each states and data sets
        for state=1:state_num
            sbl_diff(state).name = sprintf('diff_%s',model.state_names{state});
            sbl_diff(state).A{exp_idx} = Phi_val{state,exp_idx};
            sbl_diff(state).y{exp_idx} = model.dydt{exp_idx}(:,state);
            sbl_diff(state).std{exp_idx} = model.variance{exp_idx};
        end
        
    end % for each dataset
    %% generate nonneg constraints
    for state=1:state_num
        constraint_idx = [setdiff(2:3,state+1) 4:size(Phi{state},2)];
        sbl_config(state).nonneg{1} = constraint_idx;
        % estimate only the selected states
        sbl_config(state).selected_states = 1:size(model.dydt,2);
        
    end
    %% run sbl
    tic;
    for state=1:state_num
        fprintf('runnging SBL on state: %d/%d\n',state,state_num)
        sbl_config(state).max_iter = 10;
        sbl_config(state).mode = 'SMV';
        fit_res_diff(state,sparsity_case) = vec_sbl(sbl_diff(state),sbl_config(state),model);
    end
    toc;
    %% reporting
    for state=1:state_num
        % use manual threshold
        zero_th = 1e-4;
        model_num = 1;
        % seexp_idxect non zero dictionaries
        fit_res_diff(state,sparsity_case) = calc_zero_th(fit_res_diff(state,sparsity_case),zero_th,config.display_plots,state,model_num);
        % report signal fit
        signal_fit_error_diff(state,sparsity_case) = fit_report(fit_res_diff(state,sparsity_case),config.display_plots);
    end
    %% simuexp_idxate the reconstructed ODE
    
    % zero out the constant term
    for state=1:state_num
        fit_res_diff(state).w_est{1}(1) = 0;
        idx = find(fit_res_diff(state,sparsity_case).non_zero_dict{1} == 1);
        assert(numel(idx)<2)
        fit_res_diff(state,sparsity_case).non_zero_dict{1}(idx) = [];
    end
    
    valid_model = simulateSBLresults(Phi,fit_res_diff(:,sparsity_case),model,config.display_plots);
    for state=1:state_num
        fit_res_diff(state,sparsity_case).valid_model = valid_model;
    end
    
end % for each sparsity case


%% save the resuexp_idxts to a mat fiexp_idxe
if config.save_results_to_mat
    save([dir_name '/toggle_switch_sbl_output'],'Phi','fit_res_diff','model','input_data')
end
%% clean up
clear variables
clc
close all
%% read data for the model

display_plots   = 0;
export_to_amigo = 1;

dir_name  = 'Data';
file_name = 'experimental_data_7exps_noise000.csv';

exp_idx = [1];
input_data = datareader_for_SBL(dir_name,file_name);

%%

% generating the dictionary functions
Phi = build_toggle_switch_dict();

state_num = input_data.state_num;
exp_num = numel(exp_idx);

model.experiment_num = numel(exp_idx);
model.state_names = input_data.state_names;
model.input_names = input_data.input_names;

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
    model.variance{l} = 0.2;
    model.tspan{l} = input_data.tspan{exp_id};
    
    model.input{l} = input_data.inputs{exp_id};
    
    %% evaluate dictionary
    
    x = [input_data.states{exp_id}  input_data.inputs{exp_id}];
    % extra (not estimated) parameters
    p = [];
    Phi_val = cell(state_num,1);
    
    
    for state = 1:state_num
        Phi_val{state,l} = cell2mat(cellfun(@(f) f(x,p),Phi{state},'UniformOutput',false));
    end
    
    
    
    %% build a linear regression struct, i.e. y = A*x
    for k=1:state_num
        sbl_diff(k).name = sprintf('diff_%s',model.state_names{k});
        sbl_diff(k).A{l} = Phi_val{k,l};
        sbl_diff(k).y{l} = model.dydt{l}(:,k);
        sbl_diff(k).std = model.variance{l};
    end
    
end

%% estimate only the selected states
sbl_config.selected_states = 1:size(model.dydt,2);

%% generate nonnegconstraints
% param_num = size(A,2);
for k=1:state_num
    constraint_idx= [];
    for z=2:size(Phi{k},2)
        if isempty(strfind(func2str(Phi{k}{z}),sprintf('x(:,%d)',k)))
            constraint_idx = [constraint_idx; z];
        end
    end
    sbl_config(k).nonneg{1} = constraint_idx;
end


%% run SBL
tic;
for k=1:state_num
    sbl_config(k).max_iter = 10;
    sbl_config(k).mode = 'SMV';
    fit_res_diff(k) = vec_sbl(sbl_diff(k),sbl_config(k),model);
end
toc;
%% reporting
% turn on/off plots


for k=1:state_num
    % use manual tresholding
    zero_th = 1e-6;
    % select non zero dictionaries
    fit_res_diff(k) = calc_zero_th(fit_res_diff(k),zero_th,display_plots);
    % report signal fit
    signal_fit_error_diff(k) = fit_report(fit_res_diff(k),display_plots);
end

%% Print out models
% green - correct dict found (OK)
% red   - missing dict
% black - false  dict
% printOutModel(fit_res_diff,Morig,Phi,[])

%% simulate the reconstructed ODE

% zero out the constant term
for k=1:state_num
    fit_res_diff(k).w_est{1}(1) = 0;
    idx = find(fit_res_diff(1).non_zero_dict{1} == 1);
    assert(numel(idx)<2)
    fit_res_diff(k).non_zero_dict{1}(idx) = [];
end
%%

%simulateSBLresults(Phi,fit_res_diff,model,display_plots)
%parpool(4);

MODELS={{fit_res_diff,Phi,model},{fit_res_diff,Phi,model},{fit_res_diff,Phi,model}};
RES={};

parfor i=1:length(MODELS)
    
    SBLModel=SBLModel2AMIGOModel(MODELS{i},'SBL');
    
    [inputs privstruct]=gen_AMIGOSetupFromSBL(SBLModel,'experimental_data_exp1to1_noise000.csv','SBLModel');
    
    [inputs,privstruct,res_ssm]=fit_SBLModel(inputs,privstruct);
    RES={inputs,privstruct,res_ssm};
    
end



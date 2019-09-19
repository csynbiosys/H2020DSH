function [valid_model] = simulateSBLresults(Phi,fit_results,model,display_plots)

state_num = size(model.state_names,2);
experiment_num = model.experiment_num;

x0_maxValue    = 50;
valid_model = true;

%% generate set of initial condition
if isfield(model,'output')
    for exp_idx = 1:experiment_num    
        x0_vec(exp_idx,:) = model.output{exp_idx}(1,:);
    end
else
    x0_vec = lhsu(zeros(state_num,1),repmat(x0_maxValue,state_num),experiment_num);
end

ode_solver_opts= [];

%% run ODE solver

% check the model validity
if any(cellfun(@(x) isempty(x{1}), {fit_results.non_zero_dict}) == true)
    valid_model = false;
    return
end

for exp_idx = 1:experiment_num
    try
        [~,x_sbl{exp_idx}]   = ode15s(@ode_rhs_from_phi,model.tspan{exp_idx},x0_vec(exp_idx,:),ode_solver_opts,Phi,fit_results,model);
        % changing warning to error
        [warnMsg, warnId] = lastwarn;
        if strcmp(warnId,'MATLAB:ode15s:IntegrationTolNotMet')
            error('integration error')
        end
        fprintf('ODE simulation OK\n')
        
    catch ME
        if strcmp(ME.message,'integration error')
        fprintf('reconstracted ODE integration failed\n');
        valid_model = false;
        else
            rethrow(ME)
        end
    end
end

%% generate report
if valid_model
    if display_plots
        figure('Name','reconstructed vs exp data')
        for exp_idx = 1:experiment_num
            for k = 1:state_num
                subplot(experiment_num,state_num,sub2ind([ state_num experiment_num],k,exp_idx))
                title(sprintf('state x%d: %s',k, model.state_names{k}))
                hold on
                plot(model.tspan{exp_idx},model.output{exp_idx}(:,k))
                plot(model.tspan{exp_idx},x_sbl{exp_idx}(:,k),'LineWidth',1.5)
                
                legend(sprintf('%s_{orig}',model.state_names{k}),sprintf('%s_{sbl}',model.state_names{k}),'Location','Best')
                xlabel('Time [min]')
            end
        end
    end
end




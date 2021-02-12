function [fit_res_bestSim] = PlotFunction(fit_res,model_id,models,model_idx,experimental_data)

    % Convergence curve
    cc = figure();
    hold on 
    for j=1:length(fit_res.results)
        try
            stairs(fit_res.results{1,j}.nlpsol.neval, fit_res.results{1,j}.nlpsol.f);
        catch
        end
    end
    xlabel("# fuinction evaluations");
    ylabel("cost function")
    title("Covergence curve")
    saveas(cc, strjoin([".\AMIGOScripts\Results\PE_",string(model_id),"_ConvergenceCurve_",date(),".png"],""))

%%
    inputs = {};
    inputs.model = fit_res.inputs.model;
    inputs.model.par = fit_res.results{1,fit_res.best_idx}.fit.thetabest'; 
    inputs.pathd = fit_res.inputs.pathd;
    inputs.exps.n_exp = fit_res.exps.n_exp;
    
    results_folder = strcat(model_id,convertStringsToChars('_simulation_'),datestr(now,'yyyy-mm-dd'));
    short_name = strcat(model_id,convertStringsToChars('_simulation_'));
    inputs.pathd.results_folder = results_folder;                        
    inputs.pathd.short_name     = short_name;
    inputs.pathd.runident       = 'initial_simulation';

    
    for iexp = 1:fit_res.exps.n_exp
        exp_indexData = iexp;
        inputs.exps.exp_type{iexp} = experimental_data.exps.exp_type{1,exp_indexData}; 
        inputs.exps.n_obs{iexp} = experimental_data.exps.n_obs{1,exp_indexData}; 
        inputs.exps.obs_names{iexp} = char(models(model_idx).exp_info.obs_names);
        inputs.exps.obs{iexp} = char(models(model_idx).exp_info.obs);
        inputs.exps.u_interp{iexp} = experimental_data.exps.u_interp{1,exp_indexData};
        inputs.exps.t_f{iexp} = experimental_data.exps.t_f{1,exp_indexData}; 
        inputs.exps.n_s{iexp} = experimental_data.exps.n_s{1,exp_indexData};
        inputs.exps.t_s{iexp} = experimental_data.exps.t_s{1,exp_indexData}; 
        inputs.exps.t_con{iexp} = experimental_data.exps.t_con{1,exp_indexData};
        inputs.exps.n_steps{iexp} = experimental_data.exps.n_steps{1,exp_indexData};
        inputs.exps.u{iexp} = experimental_data.exps.u{1,exp_indexData};
        inputs.exps.exp_data{iexp} = experimental_data.exps.exp_data{1,exp_indexData};
        inputs.exps.error_data{iexp} = experimental_data.exps.error_data{1,exp_indexData};
        inputs.exps.exp_y0{iexp} = zeros(1,fit_res.inputs.model.n_st);
        %ModelComputeInitialCondition(inputs,...
%                                                                         inputs.model.par,...
%                                                                         iexp,...
%                                                                         fit_res.inputs.exps.exp_data{iexp}(1,:),...
%                                                                         experimental_data.exps.u_0{1,exp_indexData});
    end
    
    inputs.ivpsol = fit_res.inputs.ivpsol;
    inputs.plotd = fit_res.inputs.plotd;
    
    fit_res.bestSimul = cell(1,inputs.exps.n_exp);
    
    AMIGO_Prep(inputs);
    
    for i=1:inputs.exps.n_exp
       inputs.exps.exp_y0{i} = ModelComputeInitialCondition(inputs,...
                                                            inputs.model.par,...
                                                            i,...
                                                            inputs.exps.exp_data{i}(1,:),...
                                                            fit_res.exps.u_0{1,i});
    end
    simRes = AMIGO_SModel_NoVer(inputs);
    fit_res.bestSimul = simRes;
    fit_res_bestSim = fit_res.bestSimul;
    % Best simulations against data
     for i = 1:fit_res.exps.n_exp
        obs_names = inputs.model.st_names;
        stim_names = inputs.model.stimulus_names;
        h = figure(i); 
        o_vect = 1:inputs.model.n_st; 
        for o=1:length(o_vect)
            subplot((inputs.model.n_st + inputs.model.n_stimulus),1,o)
            hold on
            % plot experimental data
            errorbar(fit_res.exps.t_s{1,i},fit_res.exps.exp_data{1,i}(:,o)',fit_res.exps.error_data{1,i}(:,o)');
            plot(fit_res.bestSimul{1,i}.sim.tsim{1,1},fit_res.bestSimul{1,i}.sim.states{1,1}(:,o),'LineWidth',2);
            xlabel('time [min]');
            ylabel(strcat(convertCharsToStrings(obs_names(o,:)),' (A.U.)'))
            if o==1
                title(strcat('Experiment: ',int2str(i)))
            end
        end
        o = o+1;
        subplot((inputs.model.n_st + inputs.model.n_stimulus),1,o)
            plot(inputs.exps.t_s{1,i},inputs.exps.u{1,1}(1,:));
            xlabel('time [min]');
            ylabel(strcat(convertCharsToStrings(stim_names(1,:))))
        o = o+1;
        subplot((inputs.model.n_st + inputs.model.n_stimulus),1,o)
            plot(inputs.exps.t_s{1,i},inputs.exps.u{1,1}(2,:));
            xlabel('time [min]');
            ylabel(strcat(convertCharsToStrings(stim_names(2,:))));
        
        saveas(h, strjoin([".\AMIGOScripts\Results\PE_BestFit_",string(model_id),"_Experiment_",int2str(i),"_",date(),".png"],""))

     end

end
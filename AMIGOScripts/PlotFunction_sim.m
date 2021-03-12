function [sim_res_bestSim] = PlotFunction_sim(sim_res,model_id,models,model_idx,experimental_data)

    inputs = {};
    inputs.model = sim_res.inputs.model;
    % load results lsq_small [1/100; 100]
    %load('DataExpand_Network1_Run100_lsq_02-Mar-2021_fit_results_all.mat');
    
    %inputs.model.par = fit_results{1,1}.results{1,12}.fit.thetabest';
    %
    inputs.model.par = sim_res.inputs.model.par; 
    inputs.exps.n_exp = sim_res.exps.n_exp;
    
    results_folder = strcat(model_id,convertStringsToChars('_simulation_'),datestr(now,'yyyy-mm-dd'));
    short_name = strcat(model_id,convertStringsToChars('_simulation_'));
    inputs.pathd.results_folder = results_folder;                        
    inputs.pathd.short_name     = short_name;
    inputs.pathd.runident       = 'initial_simulation';

    
    for iexp = 1:sim_res.exps.n_exp
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
        inputs.exps.exp_y0{iexp} = experimental_data.exps.exp_y0{1,exp_indexData};
    end
    
    inputs.ivpsol.ivpsolver='cvodes';
    inputs.ivpsol.senssolver='fdsens5';
    inputs.ivpsol.rtol=1.0D-13;
    inputs.ivpsol.atol=1.0D-13;
    inputs.plotd.plotlevel='noplot';
    

    
    
    AMIGO_Prep(inputs);
    
    for i=1:inputs.exps.n_exp
       inputs.exps.exp_y0{i} = ModelComputeInitialCondition(inputs,...
                                                            inputs.model.par,...
                                                            i,...
                                                            inputs.exps.exp_data{i}(1,:),...
                                                            experimental_data.exps.u_0{1,i});
    end
    

    simRes = AMIGO_SModel_NoVer(inputs);
    sim_res.bestSimul = simRes;
    
    sim_res_bestSim = sim_res.bestSimul;

    % Best simulations against data
     for i = 1:sim_res.exps.n_exp
        obs_names = inputs.model.st_names;
        stim_names = inputs.model.stimulus_names;
        h = figure(i); 
        o_vect = 1:inputs.model.n_st; 
        for o=1:length(o_vect)
            subplot((inputs.model.n_st + inputs.model.n_stimulus),1,o)
            hold on
            % plot experimental data
            errorbar(sim_res.exps.t_s{1,i},sim_res.exps.exp_data{1,i}(:,o)',sim_res.exps.error_data{1,i}(:,o)');
            plot(simRes.sim.tsim{1,i},simRes.sim.states{1,i}(:,o));
            xlabel('time [min]');
            ylabel(strcat(convertCharsToStrings(obs_names(o,:)),' (A.U.)'))
            if o==1
                title(strcat(string(model_id),'- Experiment: ',int2str(i)))
            end
        end
        o = o+1;
        subplot((inputs.model.n_st + inputs.model.n_stimulus),1,o)
            plot(inputs.exps.t_s{1,i},inputs.exps.u{1,i}(1,:));
            xlabel('time [min]');
            ylabel(strcat(convertCharsToStrings(stim_names(1,:))))
        o = o+1;
        subplot((inputs.model.n_st + inputs.model.n_stimulus),1,o)
            plot(inputs.exps.t_s{1,i},inputs.exps.u{1,i}(2,:));
            xlabel('time [min]');
            ylabel(strcat(convertCharsToStrings(stim_names(2,:))));
        
        saveas(h, strjoin([".\AMIGOScripts\Results\TestSim_",string(model_id),"\TestSim_",string(model_id),"_TestInference_",string(model_id),"_Experiment_",int2str(i),"_",date(),".png"],""))

     end

end
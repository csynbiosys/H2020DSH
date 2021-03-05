function [sim_res] = SimModels(models, experimental_data,model_idx)
    
    model_id = models(model_idx).model.name;

    if ~isfolder(".\AMIGOScripts\Results")
            mkdir(".\AMIGOScripts\Results")
    end
    
    sim_res = {};
    sim_res.exps = {}; % This will contain the details of the experiments 
    sim_res.inputs = {}; % This will contain the inputs structure for AMIGO
    sim_res.model_id = model_id;


    sim_res.exps = experimental_data.exps; 
    sim_res.inputs.model = ExtractModelToFit(models(model_idx));

    %% Plot generation
    if ~isfolder(strjoin([".\AMIGOScripts\Results\TestSim_Run100_lsq_",string(model_id)],''))
        mkdir(strjoin([".\AMIGOScripts\Results\TestSim_Run100_lsq_",string(model_id)],''))
    end
    
    sim_res.best_sim = PlotFunction_sim(sim_res,model_id,models,model_idx,experimental_data);
    save(strjoin([".\AMIGOScripts\Results\TestSim_Run100_lsq_",string(model_id),"\sim_result.mat"],""), "sim_res")

end
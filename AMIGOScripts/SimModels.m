function [sim_res] = SimModels(models, experimental_data_scaled,model_idx)
    
    model_id = models(model_idx).model.name;

    if ~isfolder(".\AMIGOScripts\Results")
            mkdir(".\AMIGOScripts\Results")
    end
    
    sim_res = {};
    sim_res.exps = {}; % This will contain the details of the experiments 
    sim_res.inputs = {}; % This will contain the inputs structure for AMIGO
    sim_res.model_id = model_id;


    sim_res.exps = experimental_data_scaled.exps; 
    sim_res.inputs.model = ExtractModelToFit(models(model_idx));

    %% Plot generation
    if ~isfolder(strjoin([".\AMIGOScripts\Results\TestSim",string(model_id)],''))
        mkdir(strjoin([".\AMIGOScripts\Results\TestSim",string(model_id)],''))
    end
    
    sim_res.best_sim = PlotFunction_sim(sim_res,model_id,models,model_idx,experimental_data_scaled);
    save(strjoin([".\AMIGOScripts\Results\TestSim",string(model_id),"\sim_result.mat"],""), "sim_res")

end
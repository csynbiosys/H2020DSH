function [fit_res] = FitModels(models, experimental_data)
    % test 
    model_idx = 1;
    model_id = models(model_idx).model.name;

    if ~isfolder(".\Results")
            mkdir(".\Results")
    end
    
    fit_res = {};
    fit_res.exps = {}; % This will contain the details of the experiments 
    fit_res.inputs = {}; % This will contain the inputs structure for AMIGO

    % Extract exps 
    fit_res = setAMIGOStructureFit(fit_res,models(model_idx),experimental_data);
    fit_res.exps = experimental_data.exps; 
    
    % Run PE in a parfor for each initial guess
    if ~isfolder(strjoin([".\Results\PE_", model_id]))
        mkdir(strjoin([".\Results\PE_", model_id]))
    end
    
    [k,~] = size(fit_res.global_theta_guess);
    tmpmat = fit_res.global_theta_guess;
    results = cell(1,30);
    
     fit_res.inputs.nlpsol.eSS.maxeval = 200;
     fit_res.inputs.nlpsol.eSS.maxtime = 100;
 
%     if isfile(strjoin([".\Results\PE_Results_",fit_res.system, "_Model", fit_dat.model, "_GenIter", fit_dat.iter,"_", date, "_", flag, ".mat"],""))
%         tmp1 = load(strjoin([".\Results\PE_Results_",fit_res.system, "_Model", fit_dat.model, "_GenIter", fit_dat.iter,"_", date, "_", flag, ".mat"],""));
%         results = tmp1.fit_res.results;
%     end


    AMIGO_Prep(fit_res.inputs);
    
    exps_indexTraining = models(model_idx).model.exp_training_idx;
    
    parfor j=1:2%k
%     for j=1:2    
        try
            if isempty(results{j})
                tmpth = tmpmat(j,:);
                peRes = mainRunPE(fit_res,tmpth, j);
                mainRunPE(fit_res,tmpth,exps_indexTraining,model_id,j)
                results{j} = peRes;
            end
        catch
        end
    end
    
    fit_res.results = results; 
    
    %% 
end
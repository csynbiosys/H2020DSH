function [fit_res] = FitModels(models, experimental_data, model_idx)

    model_id = models(model_idx).model.name;

    if ~isfolder(".\AMIGOScripts\Results")
            mkdir(".\AMIGOScripts\Results")
    end
    
    fit_res = {};
    fit_res.exps = {}; % This will contain the details of the experiments 
    fit_res.inputs = {}; % This will contain the inputs structure for AMIGO
    fit_res.testSet = {}; % This will contain the results on the test set 
    fit_res.model_id = model_id;

    % Extract exps 
    % training set 
    fit_res = setAMIGOStructureFit(fit_res,models(model_idx),experimental_data);
    % all
    fit_res.exps = experimental_data.exps; 
    
    % Run PE in a parfor for each initial guess
    
    if ~isfolder(strjoin([".\AMIGOScripts\Results\PE_",string(model_id)],''))
        mkdir(strjoin([".\AMIGOScripts\Results\PE_",string(model_id)],''))
    end
    
    [k,~] = size(fit_res.global_theta_guess);
    tmpmat = fit_res.global_theta_guess;
    results = cell(1,k);
    
    fit_res.inputs.nlpsol.eSS.maxeval = 200000;
    fit_res.inputs.nlpsol.eSS.maxtime = 5000;
     
 
%     if isfile(strjoin([".\Results\PE_Results_",fit_res.system, "_Model", fit_dat.model, "_GenIter", fit_dat.iter,"_", date, "_", flag, ".mat"],""))
%         tmp1 = load(strjoin([".\Results\PE_Results_",fit_res.system, "_Model", fit_dat.model, "_GenIter", fit_dat.iter,"_", date, "_", flag, ".mat"],""));
%         results = tmp1.fit_res.results;
%     end


    AMIGO_Prep(fit_res.inputs);
    
    exps_indexTraining = models(model_idx).model.exp_training_idx;

    parfor j=1:k 
        try
            if isempty(results{j})
                tmpth = tmpmat(j,:);
                peRes = mainRunPE(fit_res,tmpth,exps_indexTraining,model_id,j);
                results{j} = peRes;
            end
        catch
        end
    end
    
    fit_res.results = results; 
    
    %% Select best results according to the performance on the test set 
    
    exps_indexTest = models(model_idx).model.exp_test_idx;

    fit_res_test = {};
    fit_res.testSet = setAMIGOStructureTestSet(fit_res_test,models(model_idx),experimental_data);
    fit_res.testSet.exps = experimental_data.exps;
    
    if ~isfolder(strjoin([".\AMIGOScripts\Results\PE_Test_",string(model_id)],''))
        mkdir(strjoin([".\AMIGOScripts\Results\PE_Test_",string(model_id)],''))
    end
    
    AMIGO_Prep(fit_res.testSet.inputs);
    
    results = cell(1,k);
    for j=1:k  
        try
            if isempty(results{j})
                tmpth = fit_res.results{1,j}.fit.thetabest';
                simRes = mainRunPEtestSet(fit_res.testSet,tmpth,exps_indexTest,model_id,j);
                results{j} = simRes;
            end
        catch
        end
    end
    fit_res.testSet.results = results; 
    
    %% Extract best theta idx and add it to fit_res structure 
    %SSE_testSet_vect= zeros(1,length(fit_res.testSet.results));
    SSE_testSet_vect= zeros(1,k);
    for j=1:k
       SSE_testSet_vect(1,j) = fit_res.testSet.results{1,j}.SSE{:}; 
    end
    fit_res.testSet.SSE = SSE_testSet_vect;
    fit_res.best_idx = find(SSE_testSet_vect == min(SSE_testSet_vect));
    save(strjoin([".\AMIGOScripts\Results\PE_",string(model_id),"\fit_result_preSim.mat"],""), "fit_res")
    
    %% Plot generation
    fit_res.best_sim = PlotFunction(fit_res,model_id,models,model_idx,experimental_data);
    save(strjoin([".\AMIGOScripts\Results\PE_",string(model_id),"\fit_result.mat"],""), "fit_res")
end

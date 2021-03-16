function [oed_res] = OEDModelSelection(fit_results, idx_models,network_name, label)

    if ~isfolder(".\Results")
        mkdir(".\Results")
    end
%%    
    oed_res = {};
    oed_res.inputs = {}; % This will contain the inputs structure for AMIGO
    
    oed_res.inputs.model = ExtractModels(fit_results,idx_models);
    
    %% Generate the inputs structure for AMIGO
    oed_res = setAMIGOStructureOED(oed_res);
    
    %% Call AMIGO
    
    AMIGO_Prep(oed_res.inputs);
    

    oed_res.inputs.pathd.DO_function = 'OEDModelSelectionCost';
    oed_res.inputs.pathd.DO_constraints = 'OEDModelSelectionConst';

    model_id = fit_results{1,idx_models(1)}.model_id;
    compName = split(model_id,'_');
    niter = compName{end,:};
    
    % Run DO in a parfor for each initial guess
    if ~isfolder(strjoin([".\Results\OED_", network_name, "_Iter", niter, "_", label], ""))
        mkdir(strjoin([".\Results\OED_", network_name, "_Iter", niter, "_", label], ""))
    end
    

    [k,~] = size(oed_res.initGuess1);
    tmpmat1 = oed_res.initGuess1;
    tmpmat2 = oed_res.initGuess2;

    results = cell(1,k);
%     
%     oed_res.inputs.nlpsol.eSS.maxeval = 100;
%     oed_res.inputs.nlpsol.eSS.maxtime = 100;

    warning('off', 'MATLAB:MKDIR:DirectoryExists');
    oed_res.inputs.model.par = oed_res.inputs.model.par';
    parfor j=1:k
    %for j=1:2    
      tmpth = [tmpmat1(j,:); tmpmat2(j,:)];
      oedRes = mainRunOED(oed_res, label,network_name,tmpth, j,niter);
      results{j} = oedRes;
    end
    
    oed_res.results = results; 
    save(strjoin([".\Results\OED_",network_name,"_",label,"_",date(),"_","oed_results_all_obs.mat"],""), "oed_res")

    
    %% Select best run by comparing cost function values
    cfv = zeros(1,k)+1e200;
    for j=1:k
        try
            cfv(j) = oed_res.results{j}.nlpsol.fbest;     
        catch
        end
    end
    bcfv = min(cfv);
    bind = find(cfv==bcfv(1));
    
    oed_res.bestRun = oed_res.results{bind};
    oed_res.bestRunIndx = bind; 

    
    %% Plot Best results and convergence curve
    % Convergence Curve
    cc = figure();
    hold on 
    for j=1:k
        try
            stairs(oed_res.results{j}.nlpsol.conv_curve(:,1), oed_res.results{j}.nlpsol.conv_curve(:,2));
        catch
        end
    end
    xlabel("CPU Time");
    ylabel("f")
    title(strjoin(["Cost Function ", network_name, "Iter ",niter], ""))
    saveas(cc, strjoin([".\Results\OED_ConvergencePlot_", network_name, "_", date(), ...
                "_Iter", niter, "_", label,".png"], ""))
            
    % Results  
%     % It would be better if we would simulate the system first since there
%     % should be the first step at the concentration of the ON, but that is at steady state so it
%     % should be fine. 

    i = 1;
    h = figure(); 
    subplot(4,2,1)
    hold on
    plot(oed_res.bestRun.sim.tsim{i},oed_res.bestRun.sim.states{i}(:,1),'b');
    plot(oed_res.bestRun.sim.tsim{i},oed_res.bestRun.sim.states{i}(:,5),'r');
    legend(oed_res.inputs.model.st_names(1,:),oed_res.inputs.model.st_names(5,:))

    subplot(4,2,2)
    hold on
    plot(oed_res.bestRun.sim.tsim{i},oed_res.bestRun.sim.states{i}(:,2),'b');
    plot(oed_res.bestRun.sim.tsim{i},oed_res.bestRun.sim.states{i}(:,6),'r');
    legend(oed_res.inputs.model.st_names(2,:),oed_res.inputs.model.st_names(6,:))

    subplot(4,2,3)
    hold on
    plot(oed_res.bestRun.sim.tsim{i},oed_res.bestRun.sim.states{i}(:,3),'b');
    plot(oed_res.bestRun.sim.tsim{i},oed_res.bestRun.sim.states{i}(:,7),'r');
    legend(oed_res.inputs.model.st_names(3,:),oed_res.inputs.model.st_names(7,:))

    subplot(4,2,4)
    hold on
    plot(oed_res.bestRun.sim.tsim{i},oed_res.bestRun.sim.states{i}(:,4),'b');
    plot(oed_res.bestRun.sim.tsim{i},oed_res.bestRun.sim.states{i}(:,8),'r');
    legend(oed_res.inputs.model.st_names(4,:),oed_res.inputs.model.st_names(8,:))

    subplot(4,2,5:6)
    stairs(oed_res.bestRun.do.t_con, [oed_res.bestRun.do.u(1,:), oed_res.bestRun.do.u(1,end)], 'c')
    legend(oed_res.inputs.model.stimulus_names(1,:))


    subplot(4,2,7:8)
    stairs(oed_res.bestRun.do.t_con, [oed_res.bestRun.do.u(2,:), oed_res.bestRun.do.u(2,end)], 'c')
    legend(oed_res.inputs.model.stimulus_names(2,:))

    saveas(h, strjoin([".\Results\OED_BestPlot_",network_name, "_", date(), ...
                    "_Iter", niter, "_", label,".png"], ""))

    %% Extract input profile and generate text file for the platform. 

    oed_res.bestInput = [[1;1E-7], oed_res.bestRun.do.u];
    oed_res.tswitch = [oed_res.bestRun.do.t_con];
    
    tswitch = oed_res.tswitch';
    u1 = oed_res.bestInput(1,:)';
    u2 = oed_res.bestInput(2,:)';
    DataInput = table(tswitch,u1,u2);
    writetable(DataInput,".\Results\OED_input_dominant2_All_Iter0.csv")
    
    save(strjoin([".\Results\OED_",network_name,"_",label,"_",date(),"_","oed_results_fluo_obs_complete.mat"],""), "oed_res")



end


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
%     cc = figure();
%     hold on 
%     for j=1:k
%         try
%             stairs(oed_res.results{j}.nlpsol.conv_curve(:,1), oed_res.results{j}.nlpsol.conv_curve(:,2));
%         catch
%         end
%     end
%     xlabel("CPU Time");
%     ylabel("f")
%     title(strjoin(["Cost Function ", oed_dat.system, ", IterGen ", oed_dat.iter], ""))
%     saveas(cc, strjoin([".\Results\OED_ConvergencePlot_",oed_dat.system, "_", date(), ...
%                 "_Iter", num2str(oed_dat.iter), "_", flag,".png"], ""))
%             
%     % It would be better if we would simulate the system first since there
%     % should be the first step at 0, but that is at steady state so it
%     % shoulf be fine. 
%     i = 1;
%     switch oed_dat.system
%         case "PL"
%             h = figure();  
%             subplot(4,1,1:3)
%             hold on
%             plot(oed_res.bestRun.sim.tsim{i}, oed_res.bestRun.sim.states{i}(:,4), 'g')
%             plot(oed_res.bestRun.sim.tsim{i}, oed_res.bestRun.sim.states{i}(:,8), 'c')
%             title(strjoin(["PLac Best Theta Simulation ", ", iteration ", num2str(oed_dat.iter)], ""))
%             ylabel('Citrine (A.U.)')
%             legend('Model 1', 'Model 2')
% 
%             subplot(4,1,4)
%             hold on
%             stairs(oed_res.bestRun.do.t_con, [oed_res.bestRun.do.u, oed_res.bestRun.do.u(end)], 'b')
%             ylabel('IPTG (mM)')
%             xlabel('time(min)')
%             saveas(h, strjoin([".\Results\OED_BestPlot_PLacExp_", date(), ...
%                 "_Iter", num2str(oed_dat.iter), "_", flag,".png"], ""))
%         case "TS"
%             
%             %%%%%%%%%%%%%%%%%%%%%%%%% To Fill!!!
%     end
%     
    %% Extract input profile and generate text file for the platform. 
    
%     switch oed_dat.system
%         case "PL"
%             inps = [0, oed_res.bestRun.do.u];
%             oed_res.bestInp = inps;
%         case "TS"
%             %%%%%%%%%%%%%%%%%%%%%%%%% To Fill!!!
%     end
%     
%     save(strjoin([".\Results\OED_", oed_dat.system, "_GenIter", oed_dat.iter, "_", flag, ".mat"],""), "oed_res", "oed_dat")
%     
%     txtf = strcat(['   10800   0   ',num2str(inps(2)),'   ',num2str(inps(3)),'   ',num2str(inps(4)),...
%         '   ',num2str(inps(5)),'   ',num2str(inps(6)),'   ',num2str(inps(7)),'   ',num2str(inps(8)),'']);
%     
%     if ~isfolder(".\Results\InputFiles")
%         mkdir(".\Results\InputFiles")
%     end
%     
%     fid = fopen( strjoin(['.\Results\InputFiles\OEDInput_',oed_dat.system,'_Iter',num2str(oed_dat.iter),'.txt'], ""), 'wt' );
%     fprintf( fid, txtf);
%     fclose(fid);        
%     

end


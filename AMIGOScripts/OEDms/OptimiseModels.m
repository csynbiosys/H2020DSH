%% Fit Models

% This function quickly starts OED for model selection for a specified system,
% model iteration. 
%
% Inputs: 
%   - oed_dat: structure with 2 fields (system, iter).
%   See ExampleOEDms.m for more details. 
%   - flag: String containing some information about the fit (also
%   used to not overwrite saved result files). 
%
% Outputs: 
%   - oed_res: structure containing the results of the OED. As fiels you
%   should have 

%   - Plots with the simulations for each experiment will also be generated and
%   saved. 

function [oed_res] = OptimiseModels(oed_dat, flag)

    if ~isfolder(".\Results")
        mkdir(".\Results")
    end

    % Check that AMIGO is included in the path
    if exist('AMIGO_Prep', 'file') == 0
        disp("--------------------------------- WARNING ---------------------------------");
        disp(" ");
        disp("It seems that AMIGO is not in the working path! Please, include it before proceeding.");
        disp(" ");
        disp("---------------------------------------------------------------------------");
        return
    end

    % Check that all the elements in the fit_dat structure are ok
    if length(fields(oed_dat)) ~= 2
        disp("--------------------------------- WARNING ---------------------------------");
        disp(" ");
        disp("It seems that the oed_dat (function input) does not have all the fields.");
        disp("These have to be: system, iter. All of them must be present.");
        disp(" ");
        disp("---------------------------------------------------------------------------");
        return
    end
    fld = ["system", "iter"];
    for i = 1:2
        if ~isfield(oed_dat, fld(i))
            disp("--------------------------------- WARNING ---------------------------------");
            disp(" ");
            disp("It seems that the oed_dat (function input) does not have all the fields.");
            disp("These have to be: system, iter. All of them must be present.");
            disp(" ");
            disp("---------------------------------------------------------------------------");
            return
        end
    end

    % Check that the contents of the fields are ok. 
    if ~strcmp(oed_dat.system, 'PL') && ~strcmp(oed_dat.system, 'TS')
        disp("--------------------------------- WARNING ---------------------------------");
        disp(" ");
        disp("It seems that the contents of the field system are wrong.");
        disp("This has to be a string containing PL or TS. This means PLac or Toggle Switch respectively. ");
        disp(" ");
        disp("---------------------------------------------------------------------------");
        return
    end

    if ~isa(oed_dat.iter, 'double') || (oed_dat.iter~=1 && oed_dat.iter~=2 && oed_dat.iter~=3)
        disp("--------------------------------- WARNING ---------------------------------");
        disp(" ");
        disp("It seems that the contents of the field iter are wrong.");
        disp("This has to be 1, 2, 3");
        disp(" ");
        disp("---------------------------------------------------------------------------");
        return
    end


    %%
    % Check that the file with the model exists and if so, check that there 
    % are parameters for htat iteration and load it. 
    % OED for only one of the systems will be allowed. 
    
    oed_res = {};
    oed_res.inputs = {}; % This will contain the inputs structure for AMIGO
    
    switch oed_dat.system
        case "PL"
            switch oed_dat.iter
                case 1
                    if exist('M3DVSM3D_load_model_Iter1', 'file') == 0
                        disp("--------------------------------- WARNING ---------------------------------");
                        disp(" ");
                        disp("It seems that the file that contains both models for the OED is not in the path. ");
                        disp("Make sure you run the function StartUpModels.m")
                        disp(" ");
                        disp("---------------------------------------------------------------------------");
                        return
                    end
                    oed_res.inputs.model = M3DVSM3D_load_model_Iter1();
                    if length(oed_res.inputs.model.par) ~= oed_res.inputs.model.n_par
                        disp("--------------------------------- WARNING ---------------------------------");
                        disp(" ");
                        disp("It seems that one of the 2 models for the iteration that you have selected does not contain parameters. ");
                        disp("Have a look at it and come back :) ")
                        disp(" ");
                        disp("---------------------------------------------------------------------------");
                        return
                    end
                case 2
                    if exist('M3DVSM3D_load_model_Iter2', 'file') == 0
                        disp("--------------------------------- WARNING ---------------------------------");
                        disp(" ");
                        disp("It seems that the file that contains both models for the OED is not in the path. ");
                        disp("Make sure you run the function StartUpModels.m")
                        disp(" ");
                        disp("---------------------------------------------------------------------------");
                        return
                    end
                    oed_res.inputs.model = M3DVSM3D_load_model_Iter2();
                    if length(oed_res.inputs.model.par) ~= oed_res.inputs.model.n_par
                        disp("--------------------------------- WARNING ---------------------------------");
                        disp(" ");
                        disp("It seems that one of the 2 models for the iteration that you have selected does not contain parameters. ");
                        disp("Have a look at it and come back :) ")
                        disp(" ");
                        disp("---------------------------------------------------------------------------");
                        return
                    end
                case 3
                    if exist('M3DVSM3D_load_model_Iter3', 'file') == 0
                        disp("--------------------------------- WARNING ---------------------------------");
                        disp(" ");
                        disp("It seems that the file that contains both models for the OED is not in the path. ");
                        disp("Make sure you run the function StartUpModels.m")
                        disp(" ");
                        disp("---------------------------------------------------------------------------");
                        return
                    end
                    oed_res.inputs.model = M3DVSM3D_load_model_Iter3();
                    if length(oed_res.inputs.model.par) ~= oed_res.inputs.model.n_par
                        disp("--------------------------------- WARNING ---------------------------------");
                        disp(" ");
                        disp("It seems that one of the 2 models for the iteration that you have selected does not contain parameters. ");
                        disp("Have a look at it and come back :) ")
                        disp(" ");
                        disp("---------------------------------------------------------------------------");
                        return
                    end
            end
        case "TS"
            switch oed_dat.iter
                case 1
                    if exist('ToggleSwitch_load_model_M1vsM2_ModelSelection_Iter1', 'file') == 0
                        disp("--------------------------------- WARNING ---------------------------------");
                        disp(" ");
                        disp("It seems that the file that contains both models for the OED is not in the path. ");
                        disp("Make sure you run the function StartUpModels.m")
                        disp(" ");
                        disp("---------------------------------------------------------------------------");
                        return
                    end
                    oed_res.inputs.model = ToggleSwitch_load_model_M1vsM2_ModelSelection_Iter1();
                    if length(oed_res.inputs.model.par) ~= oed_res.inputs.model.n_par
                        disp("--------------------------------- WARNING ---------------------------------");
                        disp(" ");
                        disp("It seems that one of the 2 models for the iteration that you have selected does not contain parameters. ");
                        disp("Have a look at it and come back :) ")
                        disp(" ");
                        disp("---------------------------------------------------------------------------");
                        return
                    end
                case 2
                    if exist('ToggleSwitch_load_model_M1vsM2_ModelSelection_Iter2', 'file') == 0
                        disp("--------------------------------- WARNING ---------------------------------");
                        disp(" ");
                        disp("It seems that the file that contains both models for the OED is not in the path. ");
                        disp("Make sure you run the function StartUpModels.m")
                        disp(" ");
                        disp("---------------------------------------------------------------------------");
                        return
                    end
                    oed_res.inputs.model = ToggleSwitch_load_model_M1vsM2_ModelSelection_Iter2();
                    if length(oed_res.inputs.model.par) ~= oed_res.inputs.model.n_par
                        disp("--------------------------------- WARNING ---------------------------------");
                        disp(" ");
                        disp("It seems that one of the 2 models for the iteration that you have selected does not contain parameters. ");
                        disp("Have a look at it and come back :) ")
                        disp(" ");
                        disp("---------------------------------------------------------------------------");
                        return
                    end
                case 3
                    if exist('ToggleSwitch_load_model_M1vsM2_ModelSelection_Iter3', 'file') == 0
                        disp("--------------------------------- WARNING ---------------------------------");
                        disp(" ");
                        disp("It seems that the file that contains both models for the OED is not in the path. ");
                        disp("Make sure you run the function StartUpModels.m")
                        disp(" ");
                        disp("---------------------------------------------------------------------------");
                        return
                    end
                    oed_res.inputs.model = ToggleSwitch_load_model_M1vsM2_ModelSelection_Iter3();
                    if length(oed_res.inputs.model.par) ~= oed_res.inputs.model.n_par
                        disp("--------------------------------- WARNING ---------------------------------");
                        disp(" ");
                        disp("It seems that one of the 2 models for the iteration that you have selected does not contain parameters. ");
                        disp("Have a look at it and come back :) ")
                        disp(" ");
                        disp("---------------------------------------------------------------------------");
                        return
                    end
            end
    end
    
    %% Generate the inputs structure for AMIGO
    oed_res = setAMIGOStructureOED(oed_res, oed_dat);
    
    %% Call AMIGO
    
    AMIGO_Prep(oed_res.inputs);
    
    switch oed_dat.system
        case "PL"
            oed_res.inputs.pathd.DO_function = 'OEDModelSelectionCostPLac';
            oed_res.inputs.pathd.DO_constraints = 'OEDModelSelectionConstPLac';
        case "TS"
            oed_res.inputs.pathd.DO_function = 'OEDModelSelectionCostToggle';
            oed_res.inputs.pathd.DO_constraints = 'OEDModelSelectionConstToggle';
    end
    
    % Run DO in a parfor for each initial guess
    if ~isfolder(strjoin([".\Results\OED_", oed_dat.system, "_GenIter", oed_dat.iter, "_", flag], ""))
        mkdir(strjoin([".\Results\OED_", oed_dat.system, "_GenIter", oed_dat.iter, "_", flag], ""))
    end
    
    switch oed_dat.system
        case "PL"
            [k,~] = size(oed_res.initGuess);
            tmpmat = oed_res.initGuess;
            tmpmat1 = oed_res.initGuess;
            tmpmat2 = oed_res.initGuess;
        case "TS"
            [k,~] = size(oed_res.initGuess1);
            tmpmat1 = oed_res.initGuess1;
            tmpmat2 = oed_res.initGuess2;
            tmpmat = oed_res.initGuess1;
    end
            
    results = cell(1,k);
    
%     oed_res.inputs.nlpsol.eSS.maxeval = 100;
%     oed_res.inputs.nlpsol.eSS.maxtime = 100;
%     k = 2;
    warning('off', 'MATLAB:MKDIR:DirectoryExists');
    oed_res.inputs.model.par = oed_res.inputs.model.par';
    parfor j=1:k
%     for j=1:2    
        switch oed_dat.system
            case "PL"
                tmpth = tmpmat(j,:);
            case "TS"
                tmpth = [tmpmat1(j,:); tmpmat2(j,:)];
        end
        oedRes = mainRunOED(oed_res, oed_dat, flag, tmpth, j);
        results{j} = oedRes;
    end
    
    oed_res.results = results; 
    
    
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
    title(strjoin(["Cost Function ", oed_dat.system, ", IterGen ", oed_dat.iter], ""))
    saveas(cc, strjoin([".\Results\OED_ConvergencePlot_",oed_dat.system, "_", date(), ...
                "_Iter", num2str(oed_dat.iter), "_", flag,".png"], ""))
            
    % It would be better if we would simulate the system first since there
    % should be the first step at 0, but that is at steady state so it
    % shoulf be fine. 
    i = 1;
    switch oed_dat.system
        case "PL"
            h = figure();  
            subplot(4,1,1:3)
            hold on
            plot(oed_res.bestRun.sim.tsim{i}, oed_res.bestRun.sim.states{i}(:,4), 'g')
            plot(oed_res.bestRun.sim.tsim{i}, oed_res.bestRun.sim.states{i}(:,8), 'c')
            title(strjoin(["PLac Best Theta Simulation ", ", iteration ", num2str(oed_dat.iter)], ""))
            ylabel('Citrine (A.U.)')
            legend('Model 1', 'Model 2')

            subplot(4,1,4)
            hold on
            stairs(oed_res.bestRun.do.t_con, [oed_res.bestRun.do.u, oed_res.bestRun.do.u(end)], 'b')
            ylabel('IPTG (mM)')
            xlabel('time(min)')
            saveas(h, strjoin([".\Results\OED_BestPlot_PLacExp_", date(), ...
                "_Iter", num2str(oed_dat.iter), "_", flag,".png"], ""))
        case "TS"
            
            %%%%%%%%%%%%%%%%%%%%%%%%% To Fill!!!
    end
    
    %% Extract input profile and generate text file for the platform. 
    
    switch oed_dat.system
        case "PL"
            inps = [0, oed_res.bestRun.do.u];
            oed_res.bestInp = inps;
        case "TS"
            %%%%%%%%%%%%%%%%%%%%%%%%% To Fill!!!
    end
    
    save(strjoin([".\Results\OED_", oed_dat.system, "_GenIter", oed_dat.iter, "_", flag, ".mat"],""), "oed_res", "oed_dat")
    
    txtf = strcat(['   10800   0   ',num2str(inps(2)),'   ',num2str(inps(3)),'   ',num2str(inps(4)),...
        '   ',num2str(inps(5)),'   ',num2str(inps(6)),'   ',num2str(inps(7)),'   ',num2str(inps(8)),'']);
    
    if ~isfolder(".\Results\InputFiles")
        mkdir(".\Results\InputFiles")
    end
    
    fid = fopen( strjoin(['.\Results\InputFiles\OEDInput_',oed_dat.system,'_Iter',num2str(oed_dat.iter),'.txt'], ""), 'wt' );
    fprintf( fid, txtf);
    fclose(fid);        
    

end



























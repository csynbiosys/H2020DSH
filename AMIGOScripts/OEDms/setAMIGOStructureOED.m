function [oed_res] = setAMIGOStructureOED(oed_res)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 
   
    oed_res.inputs.ivpsol.ivpsolver='cvodes';
    oed_res.inputs.ivpsol.senssolver='fdsens5';
    oed_res.inputs.ivpsol.rtol=1.0D-13;
    oed_res.inputs.ivpsol.atol=1.0D-13;
    oed_res.inputs.plotd.plotlevel='noplot';


    %OPTIMIZATION
    oed_res.inputs.nlpsol.reopt='off'; 
    oed_res.inputs.nlpsol.nlpsolver='eSS';
    oed_res.inputs.nlpsol.eSS.maxeval = 20000; 
    oed_res.inputs.nlpsol.eSS.maxtime = 5000000;
    oed_res.inputs.nlpsol.eSS.local.solver = 'fmincon'; 
    oed_res.inputs.nlpsol.eSS.local.finish = 'fmincon'; 

    %COST FUNCTION
    oed_res.inputs.DOsol.DOcost_type='min';                        %Type of problem: max/min
    oed_res.inputs.DOsol.user_cost = 1;
    oed_res.inputs.DOsol.tf_type='fixed';                          %Process duration type: fixed or free
    oed_res.inputs.DOsol.tf_guess=24*60-180;                               %Process duration

    oed_res.inputs.DOsol.u_interp='stepf';                         %Control definition
                                                           %'sustained' |'stepf'|'step'|'linear'|
    oed_res.inputs.DOsol.n_steps=7;
    oed_res.inputs.DOsol.t_con=0:180:24*60-180;         % Input swithching times, including intial and
                                                               % final times


    % Specify folder name and short_name
    results_folder = strcat('MSoed',datestr(now,'yyyy-mm-dd'));
    short_name     = strcat('MSoed_modelsD');
    oed_res.inputs.pathd.results_folder = results_folder;                        
    oed_res.inputs.pathd.short_name     = short_name;
    oed_res.inputs.pathd.runident       = 'initial_setup';

    % To compute y0
    AMIGO_Prep(oed_res.inputs)
    y0 = zeros(1,oed_res.inputs.model.n_st);
%     y0(1,:) = M1vsM2_Compute_SteadyState_OverNight_ModelSelection(oed_res.inputs,...
%                 repmat([1.06E-07,42.181,2967.6,147.44],1,2),...
%                 [1e-7, 100]); % one dominant state
    y0(1,:) = M1vsM2_Compute_SteadyState_OverNight_ModelSelection(oed_res.inputs,...
            repmat([1.1397,3.83E-08,26.222,1489.2],1,2),...
            [1, 1e-7]); % other dominant state
        
    oed_res.inputs.DOsol.y0=y0;                               %Initial conditions

    oed_res.inputs.DOsol.N_DOcost = 1; % We could make it multi objsective selecting 2?

    %%%%%%%%%%%%%%%%%%%%%%%%%%%% THIS NEEDS TO BE CHANGED
    %%%%%%%%%%%%%%%%%%%%%%%%%%%% Our platform cannot do this
    oed_res.inputs.DOsol.u_min= [0*ones(1,oed_res.inputs.DOsol.n_steps); 0*ones(1,oed_res.inputs.DOsol.n_steps)]+1e-7;
    oed_res.inputs.DOsol.u_max=[1*ones(1,oed_res.inputs.DOsol.n_steps); 100*ones(1,oed_res.inputs.DOsol.n_steps)];% Minimum and maximum value for the input


    oed_res.initGuess1 = rand(30,7).*[1*ones(1,oed_res.inputs.DOsol.n_steps)]+1e-7;
    oed_res.initGuess2 = rand(30,7).*[100*ones(1,oed_res.inputs.DOsol.n_steps)]+1e-7;
    
end


























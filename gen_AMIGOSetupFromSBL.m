function [inputs,privstruct] = gen_AMIGOSetup(AMIGOModel,DataFile,model_name)

exps=load_data(DataFile);

inputs.model=AMIGOModel;

inputs.exps=exps;

%% PATHS RELATED DATA
name = sprintf(model_name);
inputs.pathd.results_folder = name; % Folder to keep results (in Results) for a given problem
inputs.pathd.short_name = name;     % To identify figures and reports for a given problem
inputs.pathd.runident='run_1';      % [] Identifier required in order not to overwrite previous results

inputs.PEsol=set_parameter_bounds(inputs.model.par);

inputs.ivpsol=get_solver_settings();

%% Compile
[inputs privstruct]=AMIGO_Prep(inputs);


end

function ivpsol= get_solver_settings()

%SIMULATION
ivpsol.ivpsolver='cvodes';
ivpsol.senssolver='cvodes';
ivpsol.rtol=1e-9;
ivpsol.atol=1e-9;
ivpsol.ivp_maxnumsteps=1e5;
ivpsol.nthreads=8;

end

function PESol=set_parameter_bounds(vguess)

problem.x_0=vguess;
PESol.global_theta_max=vguess;
PESol.global_theta_max(PESol.global_theta_max>0)=PESol.global_theta_max(PESol.global_theta_max>0).*100;
PESol.global_theta_max(PESol.global_theta_max<=0)=0;
PESol.global_theta_min=vguess;
PESol.global_theta_min(PESol.global_theta_min<0)=PESol.global_theta_min(PESol.global_theta_min<0).*100;
PESol.global_theta_min(PESol.global_theta_min>=0)=0;

global_theta_guess=vguess;

   
end




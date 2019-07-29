function [inputs,privstruct] = gen_AMIGOSetupFromSBL(AMIGOModel,DataFile,model_name)

%% Load the CSV data file and convert into AMIGO
exps=load_data(DataFile);
inputs.model=AMIGOModel;
inputs.exps=exps;

%% PATHS RELATED DATA
name = sprintf(model_name);
inputs.pathd.results_folder = name; 
inputs.pathd.short_name = name;     
inputs.pathd.runident='run_1';      

%% Setp parameter bounds
inputs.PEsol=set_parameter_bounds(inputs.model.par);

%% Set ODE solver settings
inputs.ivpsol=get_solver_settings();

%% Preprocess and compile
[inputs privstruct]=AMIGO_Prep(inputs);

end

function ivpsol= get_solver_settings()

ivpsol.ivpsolver='cvodes';
ivpsol.senssolver='cvodes';
ivpsol.rtol=1e-6;
ivpsol.atol=1e-6;
ivpsol.ivp_maxnumsteps=1e5;
ivpsol.nthreads=4;

end

function PESol=set_parameter_bounds(vguess)

PESol.global_theta_max=vguess;
PESol.global_theta_max(PESol.global_theta_max>0)=PESol.global_theta_max(PESol.global_theta_max>0).*10;
PESol.global_theta_max(PESol.global_theta_max<=0)=0;
PESol.global_theta_min=vguess;
PESol.global_theta_min(PESol.global_theta_min<0)=PESol.global_theta_min(PESol.global_theta_min<0).*10;
PESol.global_theta_min(PESol.global_theta_min>=0)=0;
   
end




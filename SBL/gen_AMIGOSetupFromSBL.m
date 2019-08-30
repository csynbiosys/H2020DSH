function [inputs,privstruct] = gen_AMIGOSetupFromSBL(AMIGOModel,DataFile,model_name,exp_idx)

%% Load the CSV data file and convert into AMIGO
exps=load_data(DataFile,exp_idx);
inputs.model=AMIGOModel;
inputs.exps=exps;

%% PATHS RELATED DATA
name = sprintf(model_name);
inputs.pathd.results_folder = name; 
inputs.pathd.short_name = name;     
inputs.pathd.runident='run_1';      

%% Set parameter bounds
inputs.PEsol=set_parameter_bounds(inputs.model.par);
if (isempty(inputs.model.par))
    inputs.PEsol.id_global_theta='none';
end
%% Set ODE solver settings
inputs.ivpsol=get_solver_settings();

%% Preprocess and compile
[inputs privstruct]=AMIGO_Prep(inputs);

end

function ivpsol= get_solver_settings()

ivpsol.ivpsolver='cvodes';
ivpsol.senssolver='cvodes';
ivpsol.rtol=1e-9;
ivpsol.atol=1e-9;
ivpsol.ivp_maxnumsteps=1e5;
ivpsol.nthreads=4;

end

function PESol=set_parameter_bounds(vguess)

index_1=vguess>0;
index_2=vguess<=0;

PESol.global_theta_max(index_1)=vguess(index_1).*10;
PESol.global_theta_max(index_2)=vguess(index_2)./10;
PESol.global_theta_min(index_2)=vguess(index_2).*10;
PESol.global_theta_min(index_1)=vguess(index_1)./10;

end




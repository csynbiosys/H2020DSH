function [inputs,privstruct] = gen_AMIGOSetupFromSBL(file)

AMIGOModel=SBLModel2AMIGOModel();



exps=load_data(file);

inputs.model=AMIGOModel;

inputs.exps=exps;


%% PATHS RELATED DATA
name = sprintf('SBLModel');
inputs.pathd.results_folder = name; % Folder to keep results (in Results) for a given problem
inputs.pathd.short_name = name;     % To identify figures and reports for a given problem
inputs.pathd.runident='run_1';      % [] Identifier required in order not to overwrite previous results


inputs.ivpsol=get_solver_settings();

%% Compile
AMIGO_Prep(inputs)


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


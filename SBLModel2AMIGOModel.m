function [AMIGOModel] = SBLModel2AMIGOModel( )

load('toggle_switch_sbl_output','input_data','fit_res_diff','Phi','model');
%load('amigo_inputs_toggle_switch,'
SBLModel=model;
fit_res = fit_res_diff;
%=======================
% MODEL RELATED DATA   %
%=======================
clear model;

% the model will be converted to a C file for faster simulations
AMIGOModel.input_model_type = 'charmodelM';
% allow custom state and parameter names
AMIGOModel.names_type = 'custom';
% number of states equals the number of measurement vectors (i.e. all states are measured)
AMIGOModel.n_st = size(SBLModel.state_names,2);
% total number of parameters is given by the non zero dictionaries
sum_par = 0;
for k=1:size(fit_res,2)
    sum_par = sum_par + size([fit_res(k).non_zero_dict{:}],2);
end
AMIGOModel.n_par = sum_par;
% TODO: compute it automatically
AMIGOModel.n_stimulus = size(SBLModel.input{1},2);

AMIGOModel.stimulus_names = char(SBLModel.input_names);
% how model names will be named
[model_char, st_names, param_vec, param_names, obs_names, obs] = generate_model_char(fit_res,Phi,SBLModel);

model_name='SBLModel';

AMIGOModel.eqns = model_char;
AMIGOModel.st_names = st_names;

AMIGOModel.par = param_vec;
AMIGOModel.par_names = param_names;

%% Model execution
AMIGOModel.names_type='custom';
AMIGOModel.AMIGOsensrhs=0;

AMIGOModel.odes_file=['Models/' model_name '.c'];
AMIGOModel.mexfile=['Models/' model_name 'CostMex'];
AMIGOModel.exe_type='costMex';
AMIGOModel.overwrite_model=1;
AMIGOModel.compile_model=1;

AMIGOModel.cvodes_include=[];
AMIGOModel.debugmode=0;
AMIGOModel.shownetwork=0;


end

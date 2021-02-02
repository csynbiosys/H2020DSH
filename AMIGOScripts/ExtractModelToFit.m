function [model_Amigo] = ExtractModelToFit(model)

model_Amigo.input_model_type = model.model.input_model_type;            % Model introduction: 'charmodelC'|'c_model'|'charmodelM'|'matlabmodel'|'sbmlmodel'|'blackboxmodel'|'blackboxcost                             
model_Amigo.n_st = model.model.n_st;                                    % Number of states      
model_Amigo.n_par = model.model.n_par;                                  % Number of model parameters 
model_Amigo.n_stimulus = model.model.n_stimulus;                        % Number of inputs, stimuli or control variables   
model_Amigo.stimulus_names = model.model.stimulus_names;                % Name of stimuli or control variables
model_Amigo.st_names = model.model.st_names;                            % Names of the states                                              
model_Amigo.par_names = model.model.par_names;                          % Names of the parameters    
                 
model_Amigo.eqns = model.model.eqns;                                    % Equations describing system dynamics. Time derivatives are regarded 'd'st_name''

model_Amigo.par = cell2mat(model.model.par);                            % Parameter values
 

end
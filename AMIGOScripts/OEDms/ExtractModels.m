function [model] = ExtractModels(fit_results,idx_models)
% This script generates a merged model structure for the models to be discriminated. 
                                                       
model.input_model_type = fit_results{1,idx_models(1)}.inputs.model.input_model_type;                                        % Model introduction: 'charmodelC'|'c_model'|'charmodelM'|'matlabmodel'|'sbmlmodel'|'blackboxmodel'|'blackboxcost                             
model.n_st = fit_results{1,idx_models(1)}.inputs.model.n_st + fit_results{1,idx_models(2)}.inputs.model.n_st;                                                               % Number of states      
model.n_par = fit_results{1,idx_models(1)}.inputs.model.n_par + fit_results{1,idx_models(2)}.inputs.model.n_par;                                                              % Number of model parameters 
% shared between competing models
model.n_stimulus = fit_results{1,idx_models(1)}.inputs.model.n_stimulus;                                                         % Number of inputs, stimuli or control variables   
model.stimulus_names = fit_results{1,idx_models(1)}.inputs.model.stimulus_names;                                % Name of stimuli or control variables
model.st_names = [strcat(fit_results{1,idx_models(1)}.inputs.model.st_names,'_',int2str(idx_models(1)));...
                  strcat(fit_results{1,idx_models(2)}.inputs.model.st_names,'_',int2str(idx_models(2)))];     % Names of the states    
                
model.par_names= [strcat(fit_results{1,idx_models(1)}.inputs.model.par_names,'_',int2str(idx_models(1)));...
                  strcat(fit_results{1,idx_models(2)}.inputs.model.par_names,'_',int2str(idx_models(2)))];     % Names of the states    

% Reconstructing equations for model idx_models(1)
str_old_st = fit_results{1,idx_models(1)}.inputs.model.st_names; 
str_new_st = strcat(fit_results{1,idx_models(1)}.inputs.model.st_names,'_',int2str(idx_models(1)));
str_old_par = fit_results{1,idx_models(1)}.inputs.model.par_names;
str_new_par = strcat(fit_results{1,idx_models(1)}.inputs.model.par_names,'_',int2str(idx_models(1)));
eqns_new_ch = '';
for n_eqns = 1:size(fit_results{1,idx_models(1)}.inputs.model.eqns,1)
     eqn = fit_results{1,idx_models(1)}.inputs.model.eqns(n_eqns,:);
     eqn_new = eqn;
     for i=1:length(str_old_par)
        eqn_new = regexprep(eqn_new,str_old_par(i,:),str_new_par(i,:));
     end
     for i=1:length(str_old_st)
        eqn_new = regexprep(eqn_new,str_old_st(i,:),str_new_st(i,:));
     end
     eqns_new_ch = char(eqns_new_ch,eqn_new);
end

eqns_new_idx1 = eqns_new_ch(2:end,:);
% 
% Reconstructing equations for model idx_models(2)
str_old_st = fit_results{1,idx_models(2)}.inputs.model.st_names; 
str_new_st = strcat(fit_results{1,idx_models(2)}.inputs.model.st_names,'_',int2str(idx_models(2)));
str_old_par = fit_results{1,idx_models(2)}.inputs.model.par_names;
str_new_par = strcat(fit_results{1,idx_models(2)}.inputs.model.par_names,'_',int2str(idx_models(2)));
eqns_new_ch = '';
for n_eqns = 1:size(fit_results{1,idx_models(2)}.inputs.model.eqns,1)
     eqn = fit_results{1,idx_models(2)}.inputs.model.eqns(n_eqns,:);
     eqn_new = eqn;
     for i=1:length(str_old_par)
        eqn_new = regexprep(eqn_new,str_old_par(i,:),str_new_par(i,:));
     end
     for i=1:length(str_old_st)
        eqn_new = regexprep(eqn_new,str_old_st(i,:),str_new_st(i,:));
     end
     eqns_new_ch = char(eqns_new_ch,eqn_new);
end
eqns_new_idx2 = eqns_new_ch(2:end,:);
% 

model.eqns = char(eqns_new_idx1,eqns_new_idx2);  

%==================
% PARAMETER VALUES
% =================

% Mean from PE in AMIGO lsq
model.par= [fit_results{1,idx_models(1)}.results{1,fit_results{1,idx_models(1)}.best_idx}.fit.thetabest',...
            fit_results{1,idx_models(2)}.results{1,fit_results{1,idx_models(2)}.best_idx}.fit.thetabest'];
end               



%% Toggle switch
model.AMIGOjac = 0;                                                         
model.input_model_type='charmodelC';                                        
model.n_st=2;                                                               
model.n_par=14;                                                            
model.n_stimulus=2;                                                                                          
model.stimulus_names=char('u_IPTG','u_aTc');                               
model.st_names=char('RFP_s','GFP_s');    


%% Parameters
PARS=importdata([model_name 'pars.csv']);
model.par_names=char(char(PARS.textdata));                                
model.par=PARS.data';
                 
%% Equations
model.eqns=...                                                
               char('dRFP_s = 1/0.1386 * (kL_p_m0 + (kL_p_m/(1+(GFP_s/theta_T*(1/(1+(u_aTc/theta_aTc)^n_aTc)))^n_T)))-0.0165*RFP_s',...
                    'dGFP_s = 1/0.1386 * (kT_p_m0 + (kT_p_m/(1+(RFP_s/theta_L*(1/(1+(u_IPTG/theta_IPTG)^n_IPTG)))^n_L)))-0.0165*GFP_s');


%% Model execution
model.names_type='custom';
model.AMIGOsensrhs=0;

model.odes_file=['Models/' model_name '.c'];
model.mexfile=['Models/' model_name 'CostMex'];
model.exe_type='costMex';
model.overwrite_model=1;
model.compile_model=1;

model.cvodes_include=[];
model.debugmode=0;
model.shownetwork=0;
inputs.model=model;

%SIMULATION
inputs.ivpsol.ivpsolver='cvodes';
inputs.ivpsol.senssolver='cvodes';
inputs.ivpsol.rtol=1e-9;
inputs.ivpsol.atol=1e-9;
inputs.ivpsol.ivp_maxnumsteps=1e5;
inputs.ivpsol.nthreads=8;




                   
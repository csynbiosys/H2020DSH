
model_name='model1';

%% Toggle switch
model.AMIGOjac = 0;                                                         
model.input_model_type='charmodelC';                                        
model.n_st=4;                                                               
model.n_par=14;                                                            
model.n_stimulus=2;                                                                                          
model.stimulus_names=char('u_IPTG','u_aTc');                               
model.st_names=char('L_RFP','T_GFP','IPTGi','aTci');    


%% Parameters
PARS=importdata([model_name 'pars.csv']);
model.par_names=char(char(PARS.textdata));                                
model.par=PARS.data';
                 
%% Equations
model.eqns=...                                                
               char('dL_RFP = 1/0.1386 * (kL_p_m0 + (kL_p_m/(1+(T_GFP/theta_T*(1/(1+(aTci/theta_aTc)^n_aTc)))^n_T)))-0.0165*L_RFP',...
                    'dT_GFP = 1/0.1386 * (kT_p_m0 + (kT_p_m/(1+(L_RFP/theta_L*(1/(1+(IPTGi/theta_IPTG)^n_IPTG)))^n_L)))-0.0165*T_GFP',...
                    'dIPTGi = k_iptg   * (u_IPTG-IPTGi) -0.0165*IPTGi',...
                    'daTci =  k_aTc    * (u_aTc-aTci)   -0.0165*aTci');


%% Model execution
model.names_type='custom';
model.AMIGOsensrhs=0;

SBL_workdir;
model.odes_file=[fullfile(SBL_work_dir,'Models/AutoGeneratedC/') model_name '.c'];
model.mexfile=[fullfile(SBL_work_dir,'Models/AutoGeneratedC/') model_name 'CostMex'];
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




                   
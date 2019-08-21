
model_name='modelVarun';
model.AMIGOjac = 0;                                                         
model.input_model_type='charmodelC';                                        
model.n_st=6;                                                               
                                                          
model.n_stimulus=2;                                                         
model.stimulus_names=char('u_IPTG','u_aTc');                                

model.st_names=char('L_RFP','T_GFP','IPTGi','aTci','mrnaRFP','mrnaGFP');     

model.par_names=char('g_m','kL_p_m0','kL_p_m','theta_T','theta_aTc','n_aTc','n_T','g_p',...
                     'kT_p_m0','kT_p_m','theta_L','theta_IPTG','n_IPTG','n_L',...
                     'sc_T_molec',...
                     'sc_L_molec',...
                     'k_iptg',...
                     'k_aTc');                                 
               
model.eqns=char('dL_RFP   = sc_L_molec * ( mrnaRFP^n_mrnaRFP/(mrnaRFP^n_mrnaRFP+k_mrnaRFP^n_mrnaRFP) -  L_RFP)',...
                'dT_GFP   = sc_T_molec * ( mrnaGFP^n_mrnaGFP/(mrnaGFP^n_mrnaGFP+k_mrnaGFP^n_mrnaGFP) -  T_GFP)',...
                'dIPTGi   = k_iptg * (u_IPTG-IPTGi)',...
                'daTci    = k_aTc  * (u_aTc-aTci)',...
                'dmrnaRFP = g_mR * (  (1/(1+(T_GFP/theta_T)^n_T)) * (1/(1+(aTci/theta_aTc)^n_aTc))    - mrnaRFP )', ...
                'dmrnaGFP = g_mG * (  (1/(1+(L_RFP/theta_L)^n_L)) * (1/(1+(IPTGi/theta_IPTG)^n_IPTG)) - mrnaGFP )');
            
% model.eqns=char('dL_RFP = sc_L_molec* mrnaRFP - g_pR * L_RFP',...
%                 'dT_GFP = sc_T_molec* mrnaGFP  - g_pG * T_GFP',...
%                 'dIPTGi = k_iptg*(u_IPTG-IPTGi)',...
%                 'daTci  = k_aTc*(u_aTc-aTci)',...
%                 'dmrnaRFP = kL_p_m0 + kL_p_m/  ( 1+( T_GFP/theta_T * (1+(aTci/theta_aTc  )^n_aTc))^n_T)   -g_mR*mrnaRFP',...
%                 'dmrnaGFP = kT_p_m0 + kT_p_m/  ( 1+( L_RFP/theta_L * (1+(IPTGi/theta_IPTG)^n_IPTG))^n_L)  -g_mG*mrnaGFP');
            
% model.eqns=char('dL_RFP = sc_L_molec* mrnaRFP - g_pR',...
%                 'dT_GFP = sc_T_molec* mrnaGFP  - g_pG',...
%                 'dIPTGi = k_iptg*(u_IPTG-IPTGi)',...
%                 'daTci  = k_aTc*(u_aTc-aTci)',...
%                 'dmrnaRFP = kL_p_m0 + (kL_p_m/(1+(T_GFP/theta_T*(1/(1+(aTci/theta_aTc)^n_aTc)))^n_T))-g_mR*L_RFP',...
%                 'dmrnaGFP = kT_p_m0 + (kT_p_m/(1+(L_RFP/theta_L*(1/(1+(IPTGi/theta_IPTG)^n_IPTG)))^n_L))-g_mG*T_GFP');

%% Parameters
PARS=importdata([model_name 'pars.csv']);
model.par_names=char(char(PARS.textdata));                                
model.par=PARS.data(:,1)';
model.n_par=length(model.par);   

%% Model execution
model.names_type='custom';
model.AMIGOsensrhs=0;

model.odes_file=['Models/' model_name '.c'];
model.mexfile=['Models/' model_name 'CostMex'];
model.exe_type='costMex';
model.overwrite_model=1;
model.compile_model=0;

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
inputs.ivpsol.max_step_size=1;


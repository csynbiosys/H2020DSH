
function [resPI] = LRANK4SBL(MODELS,sbl_config,index)

inputs=MODELS{index}{1};

%% Model execution Global and local rank dont work yet in costMex mode
inputs.model.exe_type='standard';

%% OPTIMIZATION
inputs.nlpsol.nlpsolver='eSS';
inputs.nlpsol.eSS=sbl_config.parEst.eSS;

%% COST FUNCTION RELATED DATA
inputs.PEsol.PEcost_type='llk';
inputs.PEsol.lsq_type='hetero';
inputs.plotd.plotlevel='full';

inputs.rid.conf_ntrials=sbl_config.conf_ntrials;

[inputs,privstruct] = AMIGO_Prep(inputs);

resPI = AMIGO_LRank(inputs);

end

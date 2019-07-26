
model = 'SBL_diff_RFPdiff_GFP_2_strike_goldd';

% Run Structural Identifiability 
% The current directory needs to be H2020DSH!!

SetUpStructuralIdent(model);
addpath([pwd,'/ModelCheck/STRIKE-GOLDD'])
% cd('..')
cd([pwd,'/ModelCheck/STRIKE-GOLDD']);
STRIKE_GOLDD
siRES = load(['results/id_results_',model,'_',date,'.mat']);
cd('..\..')

if ~isempty(siRES.nonidentif)
    disp('Model is NOT Structurably Identifiable!');
    return
end










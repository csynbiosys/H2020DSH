function valid_model = RunModelCheck_in_loop(model,fid)
% Run Structural Identifiability 
% The current directory needs to be H2020DSH!!
valid_model = true;

SetUpStructuralIdent(model);
addpath([pwd,'/ModelCheck/STRIKE-GOLDD'])
cd([pwd,'/ModelCheck/STRIKE-GOLDD']);
STRIKE_GOLDD
siRES = load(['results/id_results_',model,'_',date,'.mat']);
current_file_sep = filesep;
cd(['..' current_file_sep '..'])

if ~isempty(siRES.nonidentif)
    logger(fid,'Strike-goldd: Model is NOT Structurably Identifiable!')
    valid_model = false;
end










function valid_model = RunModelCheck_in_loop(model,fid)

% Run Structural Identifiability 
valid_model = true;

SBL_workdir;

SetUpStructuralIdent(model);
addpath([SBL_work_dir,'/ModelCheck/STRIKE-GOLDD'])
cd([SBL_work_dir,'/ModelCheck/STRIKE-GOLDD']);
STRIKE_GOLDD;
siRES = load(['results/id_results_',model,'_',date,'.mat']);
current_file_sep = filesep;
cd(['..' current_file_sep '..'])

if ~isempty(siRES.nonidentif)
    logger(fid,'Strike-goldd: Model is NOT Structurably Identifiable!')
    valid_model = false;
end

end









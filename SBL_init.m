addpath([pwd '/Data'])
addpath([pwd '/SBL'])
addpath([pwd '/AMIGO'])
addpath([pwd '/ModelCheck'])
addpath(fullfile(pwd,'ModelCheck','STRIKE-GOLDD','models'))
addpath(genpath([pwd '/Models']))
addpath(genpath([pwd '/SRC']))
addpath(genpath([pwd '/Examples']))
addpath(pwd);
fid=fopen('SBL_workdir.m','w');
fprintf(fid,'SBL_work_dir=''%s'';',pwd);
fclose(fid);
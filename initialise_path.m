
function [] = initialise_path()
    pwd = uigetdir('D:','Select the project folder'); % prevents modifying SBL_workdir
    AMIGO2Dir = uigetdir('D:','Select the AMIGO2 folder'); % running AMIGO2_R2019a

    % AMIGO startup
    cd (AMIGO2Dir);
    AMIGO_Startup();
    cd (pwd);

    % Add folders to path 
    addpath([pwd '/AMIGOScripts'])
    addpath(fullfile(pwd,'AMIGOScripts','OEDms'))
    addpath(fullfile(pwd,'AMIGOScripts','ParameterEstimation'))
    addpath(fullfile(pwd,'AMIGOScripts','Results'))
    addpath([pwd '/Data'])
    addpath(fullfile(pwd,'Data','NetworkData'))
    %addpath(genpath([pwd '/Examples']))
    %addpath([pwd '/ModelCheck'])
    %addpath(fullfile(pwd,'ModelCheck','STRIKE-GOLDD','models'))
    addpath([pwd '/SBL'])
    %addpath(genpath([pwd '/Models'])) % not in folder!
    addpath(genpath([pwd '/SRC']))

    addpath(pwd);
    fid=fopen('SBL_workdir.m','w');
    fprintf(fid,'SBL_work_dir=''%s'';',pwd);
    fclose(fid);
end
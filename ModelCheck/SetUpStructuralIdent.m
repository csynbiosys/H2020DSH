% The current directory needs to be H2020DSH!!

function [] = SetUpStructuralIdent(sgModel)

% Copy STRIKE-GOLDD model into the models directory
copyfile([pwd,'/Data/',sgModel,'*'],[pwd,'/ModelCheck/STRIKE-GOLDD/models'])
model = load(['ModelCheck/STRIKE-GOLDD/models/',sgModel,'.mat']);


% Generate a new options file with the model to be analised
fil = fopen([pwd,'/ModelCheck/STRIKE-GOLDD/models/options_for_SBL.m'], 'w');
fprintf(fil, 'function [modelname,paths,opts,submodels,prev_ident_pars] = options_for_SBL() \n');
fprintf(fil, '\n');
fprintf(fil, ['modelname = ''',sgModel,'''; \n']);
fprintf(fil, '\n');
g=pwd;
for i=1:length(g)
    if g(i)=='\'
        g(i)='/';
    end
end
fprintf(fil, ['paths.meigo     = ''' , g ,'/ModelCheck/jrbanga_-meigo64-33e109c94b25/jrbanga_-meigo64-33e109c94b25/MEIGO''; \n']);
fprintf(fil, 'paths.models    = strcat(pwd,filesep,''models''); \n');
fprintf(fil, 'paths.results   = strcat(pwd,filesep,''results''); \n');
fprintf(fil, 'paths.functions = strcat(pwd,filesep,''functions''); \n');
fprintf(fil, '\n');
if length(model.p) <= 10
    fprintf(fil, 'opts.numeric    = 0;       %% calculate rank numerically (= 1) or symbolically (= 0)\n');
else
    fprintf(fil, 'opts.numeric    = 1;       %% calculate rank numerically (= 1) or symbolically (= 0)\n');
end
fprintf(fil, 'opts.replaceICs = 0;       %% replace states with known initial conditions (= 1) or use generic values (= 0) when calculating rank\n');
fprintf(fil, 'opts.checkObser = 1;       %% check observability of states / identifiability of initial conditions (1 = yes; 0 = no).\n');
fprintf(fil, 'opts.findcombos = 0;       %% try to find identifiable combinations? (1 = yes; 0 = no).\n');
fprintf(fil, 'opts.unidentif  = 0;       %% use method to try to establish unidentifiability instead of identifiability, when using decomposition. \n');
fprintf(fil, 'opts.forcedecomp= 0;       %% always decompose model (1 = yes; 0 = no).\n');
if length(model.p) <= 10
    fprintf(fil, 'opts.decomp     = 0;       %% decompose model if the whole model is too large (1 = yes; 0 = no: instead, calculate rank with few Lie derivatives).\n');
else
    fprintf(fil, 'opts.decomp     = 1;       %% decompose model if the whole model is too large (1 = yes; 0 = no: instead, calculate rank with few Lie derivatives).\n');
end
fprintf(fil, 'opts.decomp_user= 0;       %% when decomposing model, use submodels specified by the user (= 1) or found by optimization (= 0). \n');
fprintf(fil, 'opts.maxLietime = 300;      %% max. time allowed for calculating 1 Lie derivative.\n');
fprintf(fil, 'opts.maxOpttime = 30;     %% max. time allowed for every optimization (if optimization-based decomposition is used).\n');
eq = length(model.f);
if eq > 4
    fprintf(fil, ['opts.maxstates  = ',num2str(round(eq*0.75)),';       %% max. number of states in the submodels (if optimization-based decomposition is used).\n']);
else 
    fprintf(fil, ['opts.maxstates  = ',num2str(eq),';       %% max. number of states in the submodels (if optimization-based decomposition is used).\n']);
end

fprintf(fil, 'opts.nnzDerIn   = [');
for i=1:length(model.u)
    fprintf(fil, '10 ');
end
fprintf(fil, '];    %% number of nonzero derivatives of the inputs (specify them in one column per input).\n');
fprintf(fil, '\n');
fprintf(fil, 'submodels = []; \n');
fprintf(fil, '\n');
fprintf(fil, 'prev_ident_pars = [];\n');
fprintf(fil, '\n');
fprintf(fil, 'end');

fclose(fil);

% Save model in correct structure
[a,b]=size(model.p);

if a<b
    x = model.x.';
    h = model.h.';
    u = model.u.';
    p = model.p.';
    f = model.f;
    ics = model.ics;
    known_ics = model.known_ics;
    cd([pwd,'/ModelCheck/STRIKE-GOLDD/models']);
    save(sgModel,'f','h','ics','known_ics','p','u','x')
    cd('../../..');
end

end

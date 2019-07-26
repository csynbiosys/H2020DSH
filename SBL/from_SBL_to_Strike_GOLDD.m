function fileName = from_SBL_to_Strike_GOLDD(fit_res,model,Phi,input_data,model_num,data_dir_name)
% SBL <-> Strike-Goldd interface
% ZAT ICL Jul 2019


%% state variables
state_num = size(model.state_names,2);
states_names = {};
param_str = 'p%d_%d';
param_names =  {};

rhs_states = {};
for k=1:state_num
    % converting dictionary function to model string
    dict_str  = cellfun(@(x) replace(func2str(x),{'@(x,p)ones(size(x,1),1)','@(x,u)ones(size(x,1),1)','@(x,u)','@(x,p)','@(x)'},{'1','1','','',''}),Phi{k},'UniformOutput',false)';
    dict_str  = cellfun(@(x) regexprep(x,{'x\(:,(\d)\)','u\(:,(\d)\)'},{'x$1','u$1'}),dict_str,'UniformOutput',false);
    % removing matlab operators
    dict_str  = regexprep(dict_str,{'.\^','.\*','./'},{'\^','\*','/'});
    
    % replace the variable names in the equations as well
    for z=1:state_num
        dict_str = strrep(dict_str,sprintf('x%d',z),model.state_names{z});
        dict_str = strrep(dict_str,sprintf('x%d',z+2),model.input_names{z});
    end
    
    state_names{k} = sprintf('%s',model.state_names{k});
    idx = fit_res(k).non_zero_dict{1};
    rhs_str = '';
    for z = idx
        param_names{end+1} = sprintf(param_str,k,z);
        rhs_str = [ rhs_str '+' sprintf([param_str '*%s'],k,z,dict_str{z})];
    end
    % collect RHS string in a cell array
    rhs_states{k} = rhs_str;
end

%states
x = cell2sym(state_names);
% RHS
f = cell2sym(rhs_states');



%% observables
% all states are measured
h = x;

%% inputs
if ~isempty(input_data.input_names)
    u = cell2sym(input_data.input_names);
else
    u = [];
end

%% parameters
p = cell2sym(param_names);

%% initial conditations
ics = [];
% false = unknown
known_ics = zeros(1,state_num);

%% save the model in a mat file
fileName = ['SBL_' fit_res.name '_' num2str(model_num) '_strike_goldd'];
save([data_dir_name '/' fileName '.mat'],'x','h','u','p','f','ics','known_ics');

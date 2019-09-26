function dict_str = dict_str_builder(Phi)

% converting dictionary function to model string
dict_str  = cellfun(@(x) replace(func2str(x),{'@(x,u,p)ones(size(x,1),1)','@(x,u,p)'},{'1',''}),Phi,'UniformOutput',false)';
dict_str  = cellfun(@(x) regexprep(x,{'x\(:,(\d)\)','u\(:,(\d)\)'},{'x$1','u$1'}),dict_str,'UniformOutput',false);
% removing matlab operators
dict_str  = regexprep(dict_str,{'.\^','.\*','./'},{'\^','\*','/'});


end
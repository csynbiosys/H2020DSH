function print_model(fit_res,Phi,model)


state_num = size(model.state_names,2);

for k=1:state_num
    
    % converting dictionary function to model string
    dict_str  = cellfun(@(x) replace(func2str(x),{'@(x,u,p)ones(size(x,1),1)','@(x,u,p)'},{'1',''}),Phi{k},'UniformOutput',false)';
    dict_str  = cellfun(@(x) regexprep(x,{'x\(:,(\d)\)','u\(:,(\d)\)'},{'x$1','u$1'}),dict_str,'UniformOutput',false);
    % removing matlab operators
    dict_str  = regexprep(dict_str,{'.\^','.\*','./'},{'\^','\*','/'});
    
    if isempty(model.state_names)
        state_names{k} = sprintf('x%d',k);
        obs_names{k} = sprintf('obs_x%d',k);
        obs{k} = sprintf('obs_x%d=x%d',k,k);
        rhs_str = sprintf('dx%d=',k);
    else
        state_names{k} = sprintf('%s',model.state_names{k});
        obs_names{k} = sprintf('obs_%s',model.state_names{k});
        obs{k} = sprintf('obs_%s=%s',model.state_names{k},model.state_names{k});
        
        rhs_str = sprintf('d%s=',model.state_names{k});
        % replace the variable names in the equations as well
%         for z=1:state_num
%             dict_str = strrep(dict_str,sprintf('x%d',z),model.state_names{z});
%         end
%         if ~isempty(model.input_names)
%             input_num = size(model.input_names,2);
%             for z=1:input_num
%                 dict_str = strrep(dict_str,sprintf('u%d',z),model.input_names{z});
%             end
%         end
        
    end
    nnz_idx = fit_res(k).non_zero_dict{1};
    merged = {};
    for z = 1:size(nnz_idx,2)
       merged{z,1} = fit_res(k).sbl_param{1}(nnz_idx(z));
       merged{z,2} = dict_str{nnz_idx(z)};
    end
    cell2table(merged,'VariableNames',{'w',sprintf('RHS_FCN_for_x%d',k)})
    
end

end
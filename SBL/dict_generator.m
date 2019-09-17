function [Phi,dict] = dict_generator(x,u,kinetics)

% number of different kinetics functions
kin_num = size(kinetics,2);
% placeholder for the return struct
dict = struct();
% plalceholder for the evaluated dictionary
Phi = [];
offset = 0;

for k=1:kin_num
    % get unique id for the formula
    formula_id = DataHash(func2str(kinetics(k).formula), struct('Format', 'HEX'));
    % parametrized dictionary function
    if isfield(kinetics(k),'p') && isstruct(kinetics(k).p)
        f_names = fieldnames(kinetics(k).p);
        p_num =size(f_names,1);
        
        for z=1:p_num
            p_values{z} = kinetics(k).p.(f_names{z});
        end
        
        column_num = prod(cellfun(@(x) size(x,2),p_values));
        p_dim = cellfun(@(x) size(x,2),p_values);
        
        
        for l=1:column_num
            idx_cell = cell(1,p_num);
            [idx_cell{:}] = ind2sub(p_dim,l);
            for z=1:p_num
                p.(f_names{z}) = p_values{z}(idx_cell{z});
            end
            idx = offset+l;
            Phi(:,idx) = kinetics(k).formula(x,u,p);
            dict(idx).formula = replace_parameters(f_names,kinetics(k).formula,p);
            dict(idx).p = p;
            dict(idx).formula_id = formula_id;
        end
    % non-parametrized dictionary function
    else
        idx = offset+1;
        dict(idx).formula = kinetics(k).formula;
        dict(idx).p = [];
        dict(idx).formula_id = formula_id;
        p = [];
        Phi(:,idx) = kinetics(k).formula(x,u,p);
    end
    % update offset
    offset = size(Phi,2);
end
% replace parameters names with they value in the kinetic formula,
% then it returns the updated formula as a anonymous function
    function new_formula = replace_parameters(f_names,formula,p)
        
        str_formula = func2str(formula);
        
        for n=1:size(f_names,1)
            str_formula = strrep(str_formula,['p.' f_names{n}],num2str(p.(f_names{n})));
        end
        new_formula = str2func(str_formula);
    end


end
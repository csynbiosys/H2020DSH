function [Phi,dict] = dict_generator(x,kinetics)

kin_num = size(kinetics,1);

for k=1:kin_num
    
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
        Phi(:,l) = kinetics(k).formula(x,p);
        dict(l).formula = replace_parameters(f_names,kinetics(k).formula,p);
        dict(l).p = p;
    end
    
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
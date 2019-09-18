function [merged_model,Phi] = merge_dict_fun(dict_data,fit_res_diff)

state_num = size(fit_res_diff,1);
for k=1:state_num
    % copy all fields
    merged_model(k) = fit_res_diff(k);
    % start overwriting
    nnz = fit_res_diff(k).non_zero_dict{1};
    non_zero_dict = {dict_data{k}(nnz).formula_id};
    [formula_ids,loc_idx] = unique(non_zero_dict);
    loc_idx = sort(loc_idx)';
    unique_formulas = size(formula_ids,2);
    % generate the merged model struct
    zero_out = setdiff(1:size(fit_res_diff(k).sbl_param{1},1),loc_idx);

    merged_model(k).sbl_param{1} = fit_res_diff(k).sbl_param{1};
    merged_model(k).sbl_param{1}(zero_out) = 0;
    merged_model(k).non_zero_dict{1} = loc_idx;
end


end
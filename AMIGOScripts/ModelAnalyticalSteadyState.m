function [y0] = ModelAnalyticalSteadyState(model,params,Initial_u)

    eqns = model.eqns;
    % convert equations from model to steady state equations 
    for indeqn=1:size(eqns,1)
        eqn_split = split(eqns(indeqn,:),'=');
        eqns_ss(indeqn,:) = strcat(eqn_split(2),'= 0')

    end


    % convert system of equations to symbolic
    eqns_ss_sym = str2sym(eqns_ss);

    % subsitute parameters and ON inputs values
    eqns_ss_sym = subs(eqns_ss_sym,str2sym(model.par_names),cell2mat(params)'); % substitute par
    eqns_ss_sym = subs(eqns_ss_sym,str2sym(model.stimulus_names),Initial_u); % substitute par


    x = sym('x',[1 size(eqns_ss_sym,1)]);
    x = vpasolve(eqns_ss_sym,str2sym(model.st_names),repmat([0,inf],4,1));

    % Extract values of the states
    fn = fieldnames(x); 
    y0 = zeros(1,numel(fn));
    for i=1:numel(fn)
        fni = string(fn(i));
        y0(1,i) = x.(fni);
    end

end

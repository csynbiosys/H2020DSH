function [Phi,Phi_val] = build_MIPr_dict(x,u)

%dictionary mtx
Phi{1}{1}  = @(x,p) ones(size(x,1),1);
Phi{1}{2}  = @(x,p) x(:,1);
%% state 1
kinetics.formula = @(x,u,p) 1./(1+(p.Km./u(:,1)).^p.n_iptg);
kinetics.name = 'hill_neg';
kinetics.p.Km=0.01:0.1:1;
kinetics.p.n_iptg = 1:2;

[Phi_val_1,Phi_1] = dict_generator(x,u,kinetics);



% evaluated dict matrix
Phi_val{1} = [ones(size(x,1),1)  x(:,1) Phi_val_1];
% dict function handlers
Phi1_fcns = {Phi_1.formula};

Phi{1} = {Phi{1}{:} Phi1_fcns{:}};

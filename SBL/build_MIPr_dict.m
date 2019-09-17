function [Phi,Phi_val,dict_data] = build_MIPr_dict(x,u)

%dictionary mtx
kinetics_state1(1).formula = @(x,u,p) ones(size(x,1),1);
kinetics_state1(1).name = 'constant';

kinetics_state1(2).formula = @(x,u,p) x(:,1);
kinetics_state1(2).name = 'state1';

%% state 1
kinetics_state1(3).formula = @(x,u,p) 1./(1+(p.Km./u(:,1)).^p.n_iptg);
kinetics_state1(3).name = 'hill_neg';
kinetics_state1(3).p.Km=0.01:0.1:1;
kinetics_state1(3).p.n_iptg = 1:2;

[Phi_val_1,Phi_1] = dict_generator(x,u,kinetics_state1);

% populate return data structures

% dict function handlers
Phi{1} = {Phi_1.formula};
% all data about dictionaries
dict_data{1} = Phi_1;
% evaluated dict matrix
Phi_val{1} = Phi_val_1;

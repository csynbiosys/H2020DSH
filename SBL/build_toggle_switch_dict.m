function [Phi,Phi_val] = build_toggle_switch_dict(x,u)
%dictionary mtx
Phi{1}{1}  = @(x,p) ones(size(x,1),1);
Phi{1}{2}  = @(x,p) x(:,1);
Phi{1}{3}  = @(x,p) x(:,2);


Phi(2) = Phi(1);

%% state 1
kinetics.formula = @(x,u,p) 1./(1+((x(:,2)./p.p_tetr).*(1./1+(u(:,2)./p.p_atc).^p.n_atc)).^p.n_tetr);
kinetics.name = 'hill(hill)';
kinetics.p.p_tetr = 1:1:20;
kinetics.p.p_atc = 0.1:1:10;
kinetics.p.n_atc = 1:2;
kinetics.p.n_tetr = 1:2;

[Phi_val_1,Phi_1] = dict_generator(x,u,kinetics);


kinetics.formula = @(x,u,p) 1./(1+((x(:,1)./p.p_tetr).*(1./1+(u(:,1)./p.p_atc).^p.n_atc)).^p.n_tetr);
kinetics.name = 'hill(hill)';
kinetics.p.p_tetr = 1:1:20;
kinetics.p.p_atc = 0.1:1:10;
kinetics.p.n_atc = 1:2;
kinetics.p.n_tetr = 1:2;

[Phi_val_2,Phi_2] = dict_generator(x,u,kinetics);


% evaluated dict matrix
Phi_val{1} = [ones(size(x,1),1)  x(:,1)  x(:,2) Phi_val_1 Phi_val_2];
% dict function handlers
Phi1_fcns = {Phi_1.formula};
Phi2_fcns = {Phi_2.formula};

Phi{1} = {Phi{1}{:} Phi1_fcns{:} Phi2_fcns{:}};

%% state 2

kinetics.formula = @(x,u,p) 1./(1+((x(:,2)./p.p_tetr).*(1./1+(u(:,2)./p.p_atc).^p.n_atc)).^p.n_tetr);
kinetics.name = 'hill(hill)';
kinetics.p.p_tetr = 1:10:100;
kinetics.p.p_atc = 0.1:1:10;
kinetics.p.n_atc = 1:2;
kinetics.p.n_tetr = 1:2;

[Phi_val_1,Phi_1] = dict_generator(x,u,kinetics);


kinetics.formula = @(x,u,p) 1./(1+((x(:,1)./p.p_tetr).*(1./1+(u(:,1)./p.p_atc).^p.n_atc)).^p.n_tetr);
kinetics.name = 'hill(hill)';
kinetics.p.p_tetr = 1:10:100;
kinetics.p.p_atc = 0.1:1:10;
kinetics.p.n_atc = 1:2;
kinetics.p.n_tetr = 1:2;

[Phi_val_2,Phi_2] = dict_generator(x,u,kinetics);


% evaluated dict matrix
Phi_val{2} = [ones(size(x,1),1)  x(:,1)  x(:,2) Phi_val_1 Phi_val_2];
% dict function handlers
Phi1_fcns = {Phi_1.formula};
Phi2_fcns = {Phi_2.formula};

Phi{2} = {Phi{2}{:} Phi1_fcns{:} Phi2_fcns{:}};

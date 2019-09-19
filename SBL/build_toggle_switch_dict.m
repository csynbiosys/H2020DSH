function [Phi,Phi_val,dict_data] = build_toggle_switch_dict(x,u)
%build dictionary mtx and evaluate it on the data for each state
%% state 1
kinetics_state1(1).formula = @(x,u,p) ones(size(x,1),1);
kinetics_state1(1).name = 'constant';

kinetics_state1(2).formula = @(x,u,p) x(:,1);
kinetics_state1(2).name = 'state1';

kinetics_state1(3).formula = @(x,u,p) x(:,2);
kinetics_state1(3).name = 'state2';

kinetics_state1(4).formula = @(x,u,p) 1./(1+((x(:,2)./p.p_tetr).*(1./1+(u(:,2)./p.p_atc).^p.n_atc)).^p.n_tetr);
kinetics_state1(4).name = 'hill(hill)';
kinetics_state1(4).p.p_tetr = 1:50:500;
kinetics_state1(4).p.p_atc = 0.1:50:500;
kinetics_state1(4).p.n_atc = 1:3;
kinetics_state1(4).p.n_tetr = 1:3;


kinetics_state1(5).formula = @(x,u,p) 1./(1+((x(:,1)./p.p_tetr).*(1./1+(u(:,1)./p.p_atc).^p.n_atc)).^p.n_tetr);
kinetics_state1(5).name = 'hill(hill)';
kinetics_state1(5).p.p_tetr = 1:50:500;
kinetics_state1(5).p.p_atc = 0.1:50:500;
kinetics_state1(5).p.n_atc = 1:3;
kinetics_state1(5).p.n_tetr = 1:3;



kinetics_state1(6).formula = @(x,u,p) 1./(1+((x(:,1)./p.p_tetr).*(1./1+(u(:,2)./p.p_atc).^p.n_atc)).^p.n_tetr);
kinetics_state1(6).name = 'hill(hill)';
kinetics_state1(6).p.p_tetr = 1:50:500;
kinetics_state1(6).p.p_atc = 0.1:50:500;
kinetics_state1(6).p.n_atc = 1:3;
kinetics_state1(6).p.n_tetr = 1:3;


kinetics_state1(7).formula = @(x,u,p) 1./(1+((x(:,2)./p.p_tetr).*(1./1+(u(:,1)./p.p_atc).^p.n_atc)).^p.n_tetr);
kinetics_state1(7).name = 'hill(hill)';
kinetics_state1(7).p.p_tetr = 1:50:500;
kinetics_state1(7).p.p_atc = 0.1:50:500;
kinetics_state1(7).p.n_atc = 1:3;
kinetics_state1(7).p.n_tetr = 1:3;

[Phi_val_1,Phi_1] = dict_generator(x,u,kinetics_state1);

% populate return data structures

% dict function handlers
Phi{1} = {Phi_1.formula};
% all data about dictionaries
dict_data{1} = Phi_1;
% evaluated dict matrix
Phi_val{1} = Phi_val_1;


%% state 2
kinetics_state2(1).formula = @(x,u,p) ones(size(x,1),1);
kinetics_state2(1).name = 'constant';

kinetics_state2(2).formula = @(x,u,p) x(:,1);
kinetics_state2(2).name = 'state1';

kinetics_state2(3).formula = @(x,u,p) x(:,2);
kinetics_state2(3).name = 'state2';

kinetics_state2(4).formula = @(x,u,p) 1./(1+((x(:,2)./p.p_tetr).*(1./1+(u(:,2)./p.p_atc).^p.n_atc)).^p.n_tetr);
kinetics_state2(4).name = 'hill(hill)';
kinetics_state2(4).p.p_tetr = 1:50:500;
kinetics_state2(4).p.p_atc = 0.1:50:500;
kinetics_state2(4).p.n_atc = 1:3;
kinetics_state2(4).p.n_tetr = 1:3;



kinetics_state2(5).formula = @(x,u,p) 1./(1+((x(:,1)./p.p_tetr).*(1./1+(u(:,1)./p.p_atc).^p.n_atc)).^p.n_tetr);
kinetics_state2(5).name = 'hill(hill)';
kinetics_state2(5).p.p_tetr = 1:50:500;
kinetics_state2(5).p.p_atc = 0.1:50:500;
kinetics_state2(5).p.n_atc = 1:3;
kinetics_state2(5).p.n_tetr = 1:3;


kinetics_state2(6).formula = @(x,u,p) 1./(1+((x(:,2)./p.p_tetr).*(1./1+(u(:,1)./p.p_atc).^p.n_atc)).^p.n_tetr);
kinetics_state2(6).name = 'hill(hill)';
kinetics_state2(6).p.p_tetr = 1:50:500;
kinetics_state2(6).p.p_atc = 0.1:50:500;
kinetics_state2(6).p.n_atc = 1:3;
kinetics_state2(6).p.n_tetr = 1:3;


kinetics_state2(7).formula = @(x,u,p) 1./(1+((x(:,1)./p.p_tetr).*(1./1+(u(:,2)./p.p_atc).^p.n_atc)).^p.n_tetr);
kinetics_state2(7).name = 'hill(hill)';
kinetics_state2(7).p.p_tetr = 1:50:500;
kinetics_state2(7).p.p_atc = 0.1:50:500;
kinetics_state2(7).p.n_atc = 1:3;
kinetics_state2(7).p.n_tetr = 1:3;

[Phi_val_2,Phi_2] = dict_generator(x,u,kinetics_state2);

% populate return data structures

% dict function handlers
Phi{2} = {Phi_2.formula};
% all data about dictionaries
dict_data{2} = Phi_2;
% evaluated dict matrix
Phi_val{2} = Phi_val_2;




kinetics.formula = @(x,u,p) p.a.*x(:,2).^p.d / p.c.*u(:,1).^p.b;
kinetics.name = 'my kinetic';
kinetics.p.a = 1:5;
kinetics.p.b = 2:0.1:4;
kinetics.p.d = 1:0.2:3;

kinetics.p.c = 2;

x = rand(10,2);
u = 2*rand(10,1);

[Phi_val,Phi] = dict_generator(x,u,kinetics);

assert(size(x,1) == size(Phi_val,1))

disp('test was successful')
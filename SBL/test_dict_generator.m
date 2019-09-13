kinetics.formula = @(x,p) p.a.*x(:,1).^p.d / p.c.*x(:,2).^p.b;
kinetics.name = 'my kinetic';
kinetics.p.a = 1:5;
kinetics.p.b = 2:0.1:4;
kinetics.p.d = 1:0.2:3;

kinetics.p.c = 2;

x = rand(10,2);

[Phi,dict] = dict_generator(x,kinetics);

assert(size(x,1) == size(Phi,1))

disp('test was successful')
function [inputs,privstruct,INITIALU] = compile(model_name)

INITIALU={};

addpath('Models');
addpath('Data');

eval(model_name)
eval(['data_' model_name]);


[inputs privstruct]=AMIGO_Prep(inputs);

end




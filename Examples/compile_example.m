function [inputs,privstruct,INITIALU] = compile(model_name)

INITIALU={};

eval(model_name);
eval(['data_' model_name]);

[inputs privstruct]=AMIGO_Prep(inputs);

end



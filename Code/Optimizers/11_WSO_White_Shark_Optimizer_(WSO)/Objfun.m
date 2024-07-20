%% White Shark Optimizer (WSO)
 
%

function [ fit ] = Objfun (y)
    fit = sum ( abs(y) ) + prod( abs(y) );
end
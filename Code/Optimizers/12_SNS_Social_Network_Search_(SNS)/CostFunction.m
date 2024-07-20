% ======================================================================= %
% Social Network Search (SNS) for solving costraint optimizaztion problems
% ----------------------------------------------------------------------- %
%  Programer: Hadi Bayzidi
%     E-mail: hadi.bayzidi@gmail.com
%   Homepage: https://www.researchgate.net/profile/Hadi-Bayzidi
% ----------------------------------------------------------------------- %
% Supervisor: Siamak Talatahari
%     E-mail: siamak.talat@gmail.com
%   Homepage: https://www.researchgate.net/profile/Siamak-Talatahari
% ----------------------------------------------------------------------- %
%  Co-author: Maysam saraee
%     E-mail: maysam.saraee@gmail.com
% ----------------------------------------------------------------------- %
%  Co-author: Charles-Philippe Lamarche
%     E-mail: charles-philippe.lamarche@usherbrooke.ca
%   Homepage: https://www.researchgate.net/profile/Charles-Philippe-Lamarche
% ----------------------------------------------------------------------- %
% Main papers:
%             (1) Talatahari, Siamak, Hadi Bayzidi, and Meysam Saraee.
%                 "Social Network Search for solving engineering problems." 
%                 Computational Intelligence and Neuroscience (2021).
%                 
%             (2) Talatahari, Siamak, Hadi Bayzidi, and Meysam Saraee.
%                 "Social Network Search for Global Optimization." 
%                 IEEE Access 9 (2021): 92815-92863.
%                 https://doi.org/10.1109/ACCESS.2021.3091495
% ======================================================================= %

function [z, Data] = CostFunction(x, VioFactor, Obj)
[f,g,h] = Obj(x);
v = sum(VioFactor.*max(0,[g h]));
z = f + v;

Data.z = z;
Data.f = f;
Data.g = [g h];
Data.v = v;
Data.x = x;
end
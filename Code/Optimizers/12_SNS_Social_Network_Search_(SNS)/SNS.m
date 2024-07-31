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

function BestData = SNS(fnum, run,nPop, MaxEval,lb,ub,nD,fobj,e2s,glomin,log_interval)

    curve = inf;
% run Information
global initial_flag;
initial_flag=0;
NumberEvalInLoop = 1;
ErrorToStop = e2s;
MaxIter = round(MaxEval/(nPop*NumberEvalInLoop));

% Problem Information
% [nD, LB, UB, VioFactor, GloMin, Obj] = ProbInfo(fnum);
LB = lb.*ones(1,nD);
UB = ub.*ones(1,nD);

% Cost Function
Cost = @(x) fobj(x);

% Initialization
x = nan(nPop,nD);
z = nan(nPop, 1);

emptyData.z = [];
emptyData.f = [];
emptyData.g = [];
emptyData.v = [];
emptyData.x = [];
Data = repmat(emptyData, nPop, 1);

% A memory for counting number of function evaluations
neval = 0;

for i = 1:nPop
    x(i,:) = LB + rand(1,nD).*(UB - LB);
    % [z(i), Data(i)] = Cost(x(i,:));
    z(i) = Cost(x(i,:));
end

% SNS Main Loop
for Iter = 1:MaxIter
    for i = 1:nPop
        % Select a Random Mood
        Mood = randi(4);
        
        % Select Random User or Sunject
        Id = [1:i-1 i+1:nPop];
        j = Id(randi(nPop-1));
        Id(Id == j) = [];
        
        % Follow The Presidure Of Selected Mood
        if Mood == 1
            r = x(j, :) - x(i, :);
            R = rand(1, nD).*r;
            nx = x(j, :) + (1-2*rand(1, nD)).*R;
        elseif Mood == 2
            k = Id(randi(nPop-2));
            D = sign(z(i) - z(j))*(x(j, :) - x(i, :));
            nx = x(k, :) + rand(1, nD).*D;
        elseif Mood == 3
            Group = randperm(nPop,randi(nPop));
            M = mean(x(Group, :), 1);
            nx = x(i, :) + rand(1, nD).*(M - randi(2)*x(i,:));
        else
            event = LB + rand(1, nD).*(UB - LB);
            select = randi(nD);
            nx = x(i, :);
            t = rand;
            nx(select) = t*event(select) + (1-t)*x(j, select);
        end
        
        % Clamp New Position
        nx = min(max(nx, LB), UB);
        
        % Evaluation
        % [nz, nData] = Cost(nx);
        nz = Cost(nx);
        neval = neval + 1;
        
        if nz < z(i)
            z(i) = nz;
            x(i,:) = nx;
            % Data(i) = nData;
        end
    end
    
    % Update Best Solution
    [zBest, BestIndex] = min(z);
    % BestData = Data(BestIndex);
    
    % Display Results
    % disp(['Iter: ' num2str(Iter) ' - fBest: ' num2str(zBest)])
    BestData.cost = zBest;
    
    % Stop Algorithm
    % if zBest <= GloMin + ErrorToStop
    if abs(zBest-glomin) <= ErrorToStop
        % zBest = GloMin;
        BestData.cost = zBest;
        break
    end

    if mod(Iter,log_interval)==0
        disp(['Func = ' num2str(fnum) ', run = ' num2str(run) ', Iter = ' num2str(Iter) ', Best Fitness = ' num2str(zBest)]);
        curve = [curve zBest];
    end

end
BestData.nfe = neval;
BestData.cost = zBest;
Bestdata.curve = curve;

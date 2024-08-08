
% =============================================================================================================================================================================
% Differentiated Creative Search (DCS)

% CITATION:
% Duankhan P., Sunat K., Chiewchanwattana S., and Nasa-ngium P. "The Differentiated Creative Search (DCS): Leveraging Differentiated Knowledge-acquisition and Creative Realism
% to Address Complex Optimization Problems". (Accepted for publication in Expert Systems with Applications)
% =============================================================================================================================================================================

function Bestdata = DCS(fnum,run,Npop,MaxEval,lb,ub,nD,fobj,e2s,glomin,log_interval)

    curve = inf;
    curve_it = 0;

    global initial_flag;
    initial_flag = 0;
    
    Maxiter = floor(MaxEval/Npop);


%disp('DCS is now tackling your problem');

rng(sum(100*clock));
%lb = repmat(lb,1,nD);
%ub = repmat(ub,1,nD);


% Parameters
NP = Npop;
D = nD;
% L = repmat(lb,1,nD);
% U = repmat(ub,1,nD);
L = lb; 
U = ub;
next_pos = zeros(NP,D);
new_pos = zeros(NP,D);
max_itr = round(MaxEval/NP);
convergence_curve = zeros(1,max_itr);
eta_qKR = zeros(1,NP);
new_fitness = zeros(NP,1);

% Evaluation settings
eval_setting.case = fobj;
eval_setting.lb = L;
eval_setting.ub = U;
eval_setting.nD = nD;
cul_solution = [];
cul_nfe = [];

% Golden ratio
golden_ratio = 2/(1 + sqrt(5));

% High-performing individuals
ngS = max(6,round(NP * (golden_ratio/3)));

% Initialize the population
pos = zeros(NP,D);
for i = 1:NP
    pos(i,:) = L + rand(1,D) .* (U - L);
end

% Initialize fitness values
fitness = zeros(NP,1);
for i = 1:NP
    feasible_sol = FeasibleFunction(pos(i,:),eval_setting);
    [fitness(i,1)] = feval(fobj,feasible_sol);
    pos(i,:) = feasible_sol;
end

% Generation
nfe = 0;
itr = 1;
pc = 0.5;

% Best solution
best_fitness = min(fitness);

% Ranking-based self-improvement
phi_qKR = 0.25 + 0.55 * ((0 + ((1:NP)/NP)) .^ 0.5);

while nfe < MaxEval

    % Sort population by fitness values
    [pos, fitness, ~] = PopSort(pos,fitness);

    % Reset
    bestInd = 1;

    % Compute social impact factor
    lamda_t = 0.1 + (0.518 * ((1-(nfe/MaxEval)^0.5)));

    for i = 1:NP

        % Compute differentiated knowledge-acquisition rate
        eta_qKR(i) = (round(rand * phi_qKR(i)) + (rand <= phi_qKR(i)))/2;
        jrand = floor(D * rand + 1);
        next_pos(i,:) = pos(i,:);

        if i == NP && rand < pc
            % Low-performing

            next_pos(i,:) = L + rand * (U - L);

        elseif i <= ngS
            % High-performing

            while true, r1 = round(NP * rand + 0.5); if r1 ~= i && r1 ~= bestInd, break, end, end

            for d = 1:D
                if rand <= eta_qKR(i) || d == jrand
                    next_pos(i,d) = pos(r1,d) + LnF3(golden_ratio,0.05,1,1);
                end
            end

        else
            % Average-performing

            while true, r1 = round(NP * rand + 0.5); if r1 ~= i && r1 ~= bestInd, break, end, end
            while true, r2 = ngS + round((NP - ngS) * rand + 0.5); if r2 ~= i && r2 ~= bestInd && r2 ~= r1, break, end, end

            % Compute learning ability
            omega_it = rand;

            for d = 1:D
                if rand <= eta_qKR(i) || d == jrand
                    next_pos(i,d) = pos(bestInd,d) + ((pos(r2,d) - pos(i,d)) * lamda_t) + ((pos(r1,d) - pos(i,d)) * omega_it);
                end
            end

        end

        % Boundary
        next_pos(i,:) = boundConstraint(next_pos(i,:),pos(i,:),[L; U]);

        feasible_sol = FeasibleFunction(next_pos(i,:),eval_setting);
        [new_fitness(i,1)] = feval(fobj,feasible_sol);
        new_pos(i,:) = feasible_sol;
        nfe = nfe + 1;

        if new_fitness(i,1) <= fitness(i,1)

            pos(i,:) = new_pos(i,:);
            fitness(i,1) = new_fitness(i,1);

            if new_fitness(i,1) < best_fitness
                best_fitness = new_fitness(i,1);
                bestInd = i;
            end
        end
    end

    best_x = pos(bestInd,:);
    best_cost = best_fitness;
    convergence_curve(itr) = best_fitness;
    itr = itr + 1;

    cul_solution = [cul_solution best_x];
    cul_nfe = [cul_nfe nfe];
    iter_t = nfe/Npop;
    if mod(iter_t,log_interval)==0
        disp(['Func = ' num2str(fnum) ', Run = ' num2str(run) ', Iter = ' num2str(iter_t) ', Best Fitness = ' num2str(best_fitness)]);
        curve = [curve best_fitness];
        curve_it = [curve_it iter_t];
    end

    if abs(best_fitness-glomin)<e2s 
        break;
    end

end
Bestdata.cost=best_fitness;
Bestdata.nfe = (itr*Npop)-Npop;
Bestdata.curve = curve;
Bestdata.curve_it = curve_it;




end

function [sorted_population, sorted_fitness, sorted_index] = PopSort(input_pop,input_fitness)
[sorted_fitness, sorted_index] = sort(input_fitness,1,'ascend');
sorted_population = input_pop(sorted_index,:);
end

function Y = LnF3(alpha, sigma, m, n)
Z = laplacernd(m, n);
Z = sign(rand(m,n)-0.5) .* Z;
U = rand(m, n);
R = sin(0.5*pi*alpha) .* tan(0.5*pi*(1-alpha*U)) - cos(0.5*pi*alpha);
Y = sigma * Z .* (R) .^ (1/alpha);
end

function x = laplacernd(m, n)
u1 = rand(m, n);
u2 = rand(m, n);
x = log(u1./u2);
end

function vi = boundConstraint(vi, pop, lu)

% if the boundary constraint is violated, set the value to be the middle
% of the previous value and the bound
%
% Version: 1.1   Date: 11/20/2007
% Written by Jingqiao Zhang, jingqiao@gmail.com

[NP, D] = size(pop);  % the population size and the problem's dimension

% check the lowluer bound
xl = repmat(lu(1, :), NP, 1);
pos = vi < xl;
vi(pos) = (pop(pos) + xl(pos)) / 2;

% check the upper bound
xu = repmat(lu(2, :), NP, 1);
pos = vi > xu;
vi(pos) = (pop(pos) + xu(pos)) / 2;
end

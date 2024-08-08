%___________________________________________________________________%
%  The Cheetah Optimizaer (CO) source codes version 1.0             %
%                                                                   %
%  Developed in MATLAB R2018b                                       %
%                                                                   %
%  Author and programmer: M. A. Akbari and M. Zare                  %
%                                                                   %
%                                                                   %
%  Homepages:https://www.optim-app.com    &                         %
%            https://seyedalimirjalili.com/co                       %
%  Authors: M. A. Akbari, M. Zare, R. Azizipanah-Abarghooei,        %
%              S. Mirjalili, M. Dericheh                            %
%  Title:   The Cheetah Optimizer: A Nature-Inspired Metaheuristic %
%  Algorithm for Large-Scale Optimization Problems                  %
%                                                                   %
%  Scientific Reports                                               %
%___________________________________________________________________%


function Bestdata = CO(fnum,run,nPop,MaxEval,lb,ub,nD,fobj,e2s,glomin,log_interval)

    curve = inf;
    curve_it = 0;

    global initial_flag;
    initial_flag = 0;
    
    Maxiter = floor(MaxEval/nPop);

    if length(lb) == 1 
        ub = ub.*ones(1,nD);   % Lower Bound of Decision Variables
        lb = lb.*ones(1,nD);   % Upper Bound of Decision Variables
    end
    m = 2;                    % Number of search agenets in a group
    
    %% Generate initial population of cheetahs (Algorithm 1, L#2)
    empty_individual.Position = [];
    empty_individual.Cost = [];
    BestSol.Cost = inf;
    pop = repmat(empty_individual,nPop,1);
    
    for i=1:nPop
        pop(i).Position = lb+rand(1,nD).*(ub-lb);
        pop(i).Cost = fobj(pop(i).Position);
        if pop(i).Cost < BestSol.Cost
            BestSol = pop(i); % Initial leader position
        end
    end
    
    %% Initialization (Algorithm 1, L#3)
    pop1 = pop;               % Population's initial home position
    BestCost = [];            % Leader fittnes value in a current hunting period
    X_best = BestSol;         % Prey solution sofar
    Globest = BestCost;       % Prey fittnes value sofar
    
    %% Initial parameters
    t = 0;                    % Hunting time counter (Algorithm 1, L#4)
    it = 1;                   % Iteration counter(Algorithm 1, L#5)
    T = ceil(nD/10)*60;        % Hunting time (Algorithm 1, L#7)
    FEs = 0;                  % Counter for function evaluations (FEs)
    %% CO Main Loop
    while FEs <= MaxEval % Algorithm 1, L#8
        %  m = 1+randi (ceil(nPop/2)); 
        i0 = randi(nPop,1,m);    % select a random member of cheetahs (Algorithm 1, L#9)
        for k = 1 : m % Algorithm 1, L#10
            i = i0(k);
            
            % neighbor agent selection (Algorithm 1, L#11)
            if k == length(i0)
                a = i0(k-1);
            else
                a = i0(k+1);
            end
            
            X = pop(i).Position;    % The current position of i-th cheetah
            X1 = pop(a).Position;   % The neighbor position
            Xb = BestSol.Position;  % The leader position
            Xbest = X_best.Position;% The pery position
                            
            kk=0;
            % Uncomment the follwing statements, it may improve the performance of CO
                            if i<=2 && t>2 && t>ceil(0.2*T+1) && abs(BestCost(t-2)-BestCost(t-ceil(0.2*T+1)))<=0.0001*Globest(t-1)
                                X = X_best.Position;
                                kk = 0;
                            elseif i == 3
                                X = BestSol.Position;
                                kk = -0.1*rand*t/T;
                            else
                                kk = 0.25;
                            end
                            
                            
                            Z = X;
            
            %% Algorithm 1, L#12
%                 for j = xd % select arbitrary set of arrangements
                %% Algorithm 1, L#13
                r_Hat = randn(1,nD);         % Randomization paameter, Equation (1)
                r1 = rand(1,nD);
                if k == 1              % The leader's step length (it is assumed that k==1 is associated to the leade number)
                    alpha = 0.0001*t/T.*(ub-lb); % Step length, Equation (1)%This can be updated by desired equation
                else                   % The members' step length
                    alpha = 0.0001*t/T*abs(Xb-X)+0.001.*round(double(rand(1,nD)>0.6));%member step length, Equation (1)%This can be updated by desired equation
%                         alpha = 0.0001*t/T*abs(Xb-X)+0.001.*round(double(rand>0.9));%member step length, Equation (1)%This can be updated by desired equation
                end
                
                r = randn(1,nD);
                r_Check = abs(r).^exp(r./2).*sin(2.*pi.*r); % Turning factor, Equation (3)%This can be updated by desired equation
                beta = X1-X;     % Interaction factor, Equation (3)
                
                h0 = exp(2-2*t/T);
                
                H = abs(2.*r1.*h0-h0);
                
                %% Algorithm 1, L#14
                
                r2 = rand(1,nD);
                r3 = kk+rand(1,nD);
                
                %% Strategy selection mechanism
                    
                    r4 = 3*rand(1,nD);      % Algorithm 1, L#16
                    f1=find( H > r4);        % Algorithm 1, L#17
                    Z(f1) = X(f1)+r_Hat(f1).^-1.*alpha(f1);    % Search, Equation(1) (Algorithm 1, L#18)
                    f1=find( H <= r4);
                    Z(f1) = Xbest(f1)+r_Check(f1).*beta(f1);    % Attack, Equation(3) (Algorithm 1, L#20)
                    
                    f1=find( r2 > r3); 
                    Z(f1) = X(f1);         % Sit&wait, Equation(2) (Algorithm 1, L#23)
                
            
            %% Update the solutions of member i (Algorithm 1, L#26)
            % Check the limits
            xx1=find(Z<lb);
            Z(xx1)=lb(xx1)+rand(1,numel(xx1)).*(ub(xx1)-lb(xx1));
            xx1=find(Z>ub);
            Z(xx1)=lb(xx1)+rand(1,numel(xx1)).*(ub(xx1)-lb(xx1));
            
            % Evaluate the new position
            NewSol.Position = Z;
            NewSol.Cost = fobj(NewSol.Position);
            if NewSol.Cost < pop(i).Cost
                pop(i) = NewSol;
                if pop(i).Cost < BestSol.Cost
                    BestSol = pop(i);
                end
            end
            FEs = FEs+1;
        end
        
        t = t+1; % (Algorithm 1, L#28)
        
        %% Leave the prey and go back home (Algorithm 1, L#29)
        if t>T && t-round(T)-1>=1 && t>2
            if  abs(BestCost(t-1)-BestCost(t-round(T)-1))<=abs(0.01*BestCost(t-1))
                
                % Change the leader position (Algorithm 1, L#30)
                best = X_best.Position;
                j0=randi(nD,1,ceil(nD/10*rand));
                best(j0) = lb(j0)+rand(1,length(j0)).*(ub(j0)-lb(j0));
                BestSol.Cost = fobj(best);
                BestSol.Position = best; % Leader's new position 
                FEs = FEs+1;
                
                i0 = randi(nPop,1,round(1*nPop));
                % Go back home, (Algorithm 1, L#30)
                pop(i0(nPop-m+1:nPop)) = pop1(i0(1:m)); % Some members back their initial positions 
                
                pop(i) = X_best; % Substitude the member i by the prey (Algorithm 1, L#31)
                
                t = 1; % Reset the hunting time (Algorithm 1, L#32)
            end
        end
        
        it = it +1; % Algorithm 1, L#34
        
        %% Update the prey (global best) position (Algorithm 1, L#35)
        if BestSol.Cost<X_best.Cost
            X_best=BestSol;
        end
        BestCost(t)=BestSol.Cost;
        Globest(1,t)=X_best.Cost;
       iter=FEs/nPop; 
        %% Display
        if mod(iter,log_interval)==0
            disp(['Func = ' num2str(fnum) ', Run = ' num2str(run) ', Iter = ' num2str(iter) ', Best Fitness = ' num2str(Globest(end))]);
            curve = [curve Globest(end)];
            curve_it = [curve_it iter];
        end

        if abs(Globest(end)-glomin)<e2s
            break;
        end
        
    end

Bestdata.cost=Globest(end);
Bestdata.nfe = FEs; 
Bestdata.curve = curve;
Bestdata.curve_it = curve_it;

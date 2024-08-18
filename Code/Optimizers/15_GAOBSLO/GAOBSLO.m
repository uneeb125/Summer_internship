



%%% Designed and Developed by Mohammad Dehghani %%%


function Bestdata=GAOBSLO(fnum,run,Npop,MaxEval,lb,ub,nD,fitness,e2s,glomin,log_interval)

    curve = inf;
    curve_it = 0;

global initial_flag;
initial_flag = 0;

Maxiter = floor(MaxEval/Npop);

t=0;m=0.8;a=0.97;b=0.001;t1=20;t2=20;

lb=ones(1,nD).*(lb);                              % Lower limit for variables
ub=ones(1,nD).*(ub);                              % Upper limit for variables

%% INITIALIZATION
for i=1:nD
    X(:,i) = lb(i)+rand(Npop,1).*(ub(i) - lb(i));                          % Initial population
end

for i =1:Npop
    L=X(i,:);
    fit(i)=fitness(L);
end
%%

for t=1:Maxiter  % algorithm iteration
    
    %%  update: BEST proposed solution
    [Fbest , blocation]=min(fit);
    
    if t==1
        xbest=X(blocation,:);                                           % Optimal location
        fbest=Fbest;                                           % The optimization objective function
    elseif Fbest<fbest
        fbest=Fbest;
        xbest=X(blocation,:);
    end
    %%
    if rand()<0.5
        s=8-1*(-(t/Maxiter)^2+1);
    else
        s=8-7*(-(t/Maxiter)^2+1);
    end 
    beta=-0.5*(t/Maxiter)^6+(t/Maxiter)^4+1.5;
    LV=0.5*levy(Npop,nD,beta);
    %% Generate random integers
    minValue = 1;  % minimum integer value
    maxValue = floor(Npop*(1+t/Maxiter)); % maximum integer value
    k2 = randi([minValue, maxValue], Npop, nD);
    k = randi([minValue, nD], Npop, nD);
    %%
    for i=1:Npop
        %%

        r1=2*rand()-1; % r1 is a random number in [0,1]
        r2=2*rand()-1;
        r3=2*rand()-1;           
        PD=s*(1-(t/Maxiter))*r1;
        %% Phase 1: Attack on termite mounds (exploration phase)
        TM_location=find(fit<fit(i));% based on Eq(4)
        if size (TM_location,2)==0
            STM=fbest;
        else
            K=randperm(  size (TM_location,2)  ,1);
            STM=X(K,:);
        end
        I=round(1+rand);
        X_new_P1=X( i,: ) + rand(1,1).* ( STM - I.*X( i,: ) ) ;%Eq(5)
        X_new_P1 = max(X_new_P1,lb);X_new_P1 = min(X_new_P1,ub);
        b = 0.001;
        % update position based on Eq (6)
        L=X_new_P1;
        fit_new_P1=fitness(L);
        if fit_new_P1<fit(i)
            X(i,:) = X_new_P1;
            fit(i) = fit_new_P1;
        end
        %% End Phase 1
            %% Phase 2: Digging in termite mounds (exploitation phase)
        for j = 1:nD
            if t>=0.4*Maxiter
                b=0.1;
            end
            W1=(1-t/Maxiter)*b*LV(i,j);
            L3=abs(xbest(j)-X(i,j))*PD*(1-r3*k2(i,j)/Npop);
            L4=abs(xbest(j)-X(i,k(i,j)))*PD*(1-r3*k2(i,j)/Npop);
            if rand()<a
                if abs(xbest(j))>abs(X(i,j))
                    % disp("1")
                    X(i,j)=xbest(j)+W1*xbest(j)-L3;
                else
                    % disp("2")
                    X(i,j)=xbest(j)+W1*xbest(j)+L3;
                end
            else
                 if abs(xbest(j))>abs(X(i,j))
                    % disp("3")
                    X(i,j)=xbest(j)+W1*xbest(j)-L4;
                else
                    % disp("4")
                    X(i,j)=xbest(j)+W1*xbest(j)+L4;
                end                   
            end
            %%
        end        
        %%
end  % for i=1:Npop
    %%
    
    best_so_far(t)=fbest;
    average(t) = mean (fit);
    
    if mod(t,log_interval)==0
        disp(['Func = ' num2str(fnum) ', Run = ' num2str(run) ', Iter = ' num2str(t) ', Best Fitness = ' num2str(fbest)]);
        curve = [curve fbest];
        curve_it = [curve_it t];
    end

    if abs(fbest-glomin)<e2s 
        break;
    end
end
Bestdata.cost=fbest;
Bestdata.nfe = (t*Npop);


Bestdata.curve = curve;
Bestdata.curve_it = curve_it;

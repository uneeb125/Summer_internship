



%%% Designed and Developed by Mohammad Dehghani %%%


function Bestdata=GAO(fnum,run,Npop,MaxEval,lb,ub,nD,fitness,e2s,glomin,log_interval)

    curve = inf;

global initial_flag;
initial_flag = 0;

Maxiter = MaxEval/Npop;


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
    %%
    for i=1:Npop
        %%

            %% Phase 1: Attack on termite mounds (exploration phase)
            TM_location=find(fit<fit(i));% based on Eq(4)
            if size (TM_location,2)==0
                STM=xbest;
            else
                K=randperm(  size (TM_location,2)  ,1);
                STM=X(K,:);
            end
            I=round(1+rand);
            X_new_P1=X( i,: ) + rand(1,1).* ( STM - I.*X( i,: ) ) ;%Eq(5)
            X_new_P1 = max(X_new_P1,lb);X_new_P1 = min(X_new_P1,ub);
            
            % update position based on Eq (6)
            L=X_new_P1;
            fit_new_P1=fitness(L);
            if fit_new_P1<fit(i)
                X(i,:) = X_new_P1;
                fit(i) = fit_new_P1;
            end
            %% End Phase 1

            %% Phase 2: Digging in termite mounds (exploitation phase)
            X_new_P2=X(i,:)+ (1-2*rand).*(ub-lb)./t; % Eq(7)
            X_new_P2= max(X_new_P2,lb/t);X_new_P2 = min(X_new_P2,ub/t);
            
            % Updating X_i using (8)
            L=X_new_P2;
            f_new = fitness(L);
            if f_new <= fit (i)
                X(i,:) = X_new_P2;
                fit (i)=f_new;
                if f_new<fbest
                    xbest=X_new_P2;
                    fbest=f_new;
                end
            end
            %%
        
        %%
        
    end % for i=1:Npop
    %%
    
    best_so_far(t)=fbest;
    average(t) = mean (fit);
    
    if mod(t,log_interval)==0
        disp(['Func = ' num2str(fnum) ', Run = ' num2str(run) ', Iter = ' num2str(t) ', Best Fitness = ' num2str(fbest)]);
        curve = [curve fbest];
    end

    if abs(fbest-glomin)<e2s 
        break;
    end
end
Bestdata.cost=fbest;
Bestdata.nfe = (t*Npop);


Bestdata.curve = curve;

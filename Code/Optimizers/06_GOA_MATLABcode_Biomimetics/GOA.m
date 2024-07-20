





function Bestdata=GOA(fnum,run,Npop,MaxEval,lb,ub,nD,fobj,e2s,glomin)

global initial_flag;
initial_flag = 0;

Maxiter = MaxEval/Npop;



lb=ones(1,nD).*(lb);                              % Lower limit for variables
ub=ones(1,nD).*(ub);                              % Upper limit for variables

%%
for i=1:nD
    X(:,i) = lb(i)+rand(Npop,1).*(ub(i) - lb(i));                          % Initial population
end

for i =1:Npop
    L=X(i,:);
    fit(i)=fobj(L);
end
%%

for t=1:Maxiter
    %% update the best member and worst member
    [best , blocation]=min(fit);
    if t==1
        Xbest=X(blocation,:);                                           % Optimal location
        fbest=best;                                           % The optimization objective function
    elseif best<fbest
        fbest=best;
        Xbest=X(blocation,:);
    end
    
    
    %% update GOA population
    
    for i=1:Npop
        
        %% Phase 1: Exploration
        if rand <0.5
            I=round(1+rand(1,1));
            RAND=rand(1,1);
        else
            I=round(1+rand(1,nD));
            RAND=rand(1,nD);
        end
        
        X_P1(i,:)=X(i,:)+RAND .* (Xbest-I.*X(i,:)); % Eq. (4)
        X_P1(i,:) = max(X_P1(i,:),lb);X_P1(i,:) = min(X_P1(i,:),ub);
        
        % update position based on Eq (5)
        L=X_P1(i,:);
        F_P1(i)=fobj(L);
        if F_P1(i)<fit(i)
            X(i,:) = X_P1(i,:);
            fit(i) = F_P1(i);
        end
        %
        %% END Phase 1: Exploration (global search)
        
    end% END for i=1:Npop
    
    %%
    %% Phase 2: exploitation (local search)
    for i=1:Npop
            X_P2(i,:)= X(i,:)+ (1-2*rand(1,1)) .* ( lb./t+rand(1,1).*(ub./t-lb./t));%Eq(6)
            X_P2(i,:) = max(X_P2(i,:),lb./t);X_P2(i,:) = min(X_P2(i,:),ub./t);
            X_P2(i,:) = max(X_P2(i,:),lb);X_P2(i,:) = min(X_P2(i,:),ub);  
        
        % update position based on Eq (7)
        L=X_P2(i,:);
        F_P2(i)=fobj(L);
        if F_P2(i)<fit(i)
            X(i,:) = X_P2(i,:);
            fit(i) = F_P2(i);
        end
        %
        
    end % END for i=1:Npop
    
    %% END Phase 2: exploitation (local search)
    if mod(t,1000)==0
        disp(['Func = ' num2str(fnum) ', Run = ' num2str(run) ', Iter = ' num2str(t) ', Best Fitness = ' num2str(fbest)]);
    end

    if abs(fbest-glomin)<e2s 
        break;
    end
   
end% END for t=1:Maxiter
Best_score=fbest;
Bestdata.cost=fbest;
Bestdata.nfe=t*(Npop);
Best_pos=Xbest;
GOA_curve(t)=fbest;
end








function Bestdata=GOABSLO(fnum,run,Npop,MaxEval,lb,ub,nD,fobj,e2s,glomin,log_interval)

    curve = inf;
    curve_it = 0;

global initial_flag;
initial_flag = 0;

Maxiter = floor(MaxEval/Npop);


t=0;m=0.8;a=0.97;b=0.001;t1=20;t2=20;

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
    %% update GOA population
    
    for i=1:Npop
        
        r1=2*rand()-1; % r1 is a random number in [0,1]
        r2=2*rand()-1;
        r3=2*rand()-1;           
        PD=s*(1-(t/Maxiter))*r1;
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
        for j = 1:nD
            if t>=0.4*Maxiter
                b=0.1;
            end
            W1=(1-t/Maxiter)*b*LV(i,j);
            L3=abs(Xbest(j)-X(i,j))*PD*(1-r3*k2(i,j)/Npop);
            L4=abs(Xbest(j)-X(i,k(i,j)))*PD*(1-r3*k2(i,j)/Npop);
            if rand()<a
                if abs(Xbest(j))>abs(X(i,j))
                    % disp("1")
                    X(i,j)=Xbest(j)+W1*Xbest(j)-L3;
                else
                    % disp("2")
                    X(i,j)=Xbest(j)+W1*Xbest(j)+L3;
                end
            else
                 if abs(Xbest(j))>abs(X(i,j))
                    % disp("3")
                    X(i,j)=Xbest(j)+W1*Xbest(j)-L4;
                else
                    % disp("4")
                    X(i,j)=Xbest(j)+W1*Xbest(j)+L4;
                end                   
            end
            %%
        end        
    
    %% END Phase 2: exploitation (local search)
    if mod(t,log_interval)==0
        disp(['Func = ' num2str(fnum) ', Run = ' num2str(run) ', Iter = ' num2str(t) ', Best Fitness = ' num2str(fbest)]);
        curve = [curve fbest];
        curve_it = [curve_it t];
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

Bestdata.curve = curve;
Bestdata.curve_it = curve_it;

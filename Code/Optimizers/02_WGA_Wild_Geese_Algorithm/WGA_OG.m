clc
clear

% M. Ghasemi, A. Rahimnejad, R. Hemmati, E. Akbari, and S. A. Gadsden,
% �Wild Geese Algorithm: A novel algorithm for large scale optimization
% based on the natural life and death of wild geese,� 
% Array, vol. 11, p. 100074, Sep. 2021, 
% doi: 10.1016/J.ARRAY.2021.100074.
% WebLink to Full Text Article: https://doi.org/10.1016/J.ARRAY.2021.100074


addpath(genpath(fullfile("..","..","..","Tests","CEC2010")));

CostFunction = @(x,fnm) cec10_benchmark_func(x,fnm);


disp('Wild Geese Algorithm');

nPop=120;
nVar=1000;
nPop_Initial=nPop;
nPop_Final=30;

MaxNFE=3e6;
MaxIter0=ceil(MaxNFE/((nPop_Initial+nPop_Final)/2));   % Approximate Maximum Iterations

Cr=0.5;

xmin=-600;
xmax=-xmin;

%%%%%%%%%%%

NFE=0;
Gbest.Position=[];
Gbest.Cost=inf;
BestCosts=nan(1,MaxIter0);
nfe=BestCosts;

for i=1:nPop
    Velocity(i,:)=zeros(1,nVar); %#ok<*SAGROW>
    Position(i,:)=xmin+(xmax-xmin)*rand(1,nVar);
    Cost(i)=CostFunction(Position(i,:),fnm);
    PbestPosition(i,:)=Position(i,:);
    PbestCost(i)=Cost(i);
    PbestVel(i,:)=Velocity(i,:);
    
    if PbestCost(i)<Gbest.Cost
        Gbest.Position=PbestPosition(i,:);
        Gbest.Cost=PbestCost(i);
        Gbest.Velocity= PbestVel(i,:);
    end
end
NFE=NFE+nPop;

iter=0;
while NFE<=MaxNFE
    iter=iter+1;
    
    [hh, gg]=sort(PbestCost);
    
    nPop=(nPop_Initial-1)-((nPop_Initial-nPop_Final)*(NFE/MaxNFE));
    nPop=round(nPop+1);
    nPop=max(nPop,nPop_Final);
    nPop=min(nPop_Initial,nPop);
    B6=nPop_Initial-nPop_Final;
    
    for eee=1:nPop
        
        if B6==0
            i=eee;
        else
            i=gg(eee);
        end
        [~, f2]=find(gg==i);
        
        %%% Worst
        if f2==nPop
            f2=0;
        end
        jj1=gg(1,f2+1);
        
        %%% BETTER
        [~, f2]=find(gg==i);
        tt=1;
        if f2==1
            f2=nPop+1;
            tt=-1;
        end
        
        jj2=gg(1,f2-1);
        if f2==2
            f2=nPop+2;
        end
        
        jj3=gg(1,f2-2);
        jjj=gg(1,1);
        ff1=gg(1,end);
        
        Velocity(i,:)= (rand(1,nVar).*Velocity(i,:)+rand(1,nVar).*(Velocity(jj2,:)-Velocity(jj1,:)))+rand(1,nVar).*(PbestPosition(i,:)-Position(jj1,:))+rand(1,nVar).*(PbestPosition(jj2,:)-Position(i,:))-rand(1,nVar).*(PbestPosition(jj1,:)-Position(jj3,:))+rand(1,nVar).*(PbestPosition(jj3,:)-Position(jj2,:));%%ORIGINAL
        
        BB=(PbestCost(jj2))/(PbestCost(i));
        GG=(PbestCost(jjj))/(PbestCost(i));
        
        Position(i,:)=PbestPosition(i,:)+rand(1,nVar).*rand(1,nVar).*(( PbestPosition(jj2,:)+Gbest.Position-2*PbestPosition(i,:))+(Velocity(i,:)));
        
        f1=(Gbest.Cost)/(PbestCost(i)+Gbest.Cost);
        f0=(PbestCost(jj2))/(PbestCost(jj2)+PbestCost(i));
        
        DE1=((PbestPosition(jj2,:)-PbestPosition(i,:)));
        
        for ww=1:nVar
            if rand<Cr
                Position(i,ww)=PbestPosition(i,ww)+rand*rand*(DE1(ww));
            end
        end
        
        Position(i,:)=min(max(Position(i,:),xmin),xmax);
        
        Cost(i)=CostFunction(Position(i,:),fnm);
        
        if Cost(i)<PbestCost(i)
            PbestPosition(i,:)=Position(i,:);
            PbestCost(i)=Cost(i);
            PbestVel(i,:)=Velocity(i,:);
            
            if PbestCost(i)<Gbest.Cost
                Gbest.Position=PbestPosition(i,:);
                Gbest.Cost=PbestCost(i);
                Gbest.Velocity= PbestVel(i,:);
            end
        end
    end
    
    NFE=NFE+nPop;
    nfe(iter)=NFE;
    BestCosts(iter)=Gbest.Cost;
    
    disp(['NFE ' num2str(NFE) ':   Best Cost = ' num2str(Gbest.Cost)]);

end
BestCosts(iter+1:end)=[];

plot(nfe,BestCosts, 'LineWidth',2)
xlabel('NFE')
ylabel('Objective Value')
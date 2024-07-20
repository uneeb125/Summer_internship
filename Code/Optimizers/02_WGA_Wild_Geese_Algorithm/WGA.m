

function Bestdata = WGA(Prob, Run, nPop, MaxNFE, lb,ub,nD, fobj, e2s,glomin)
    global initial_flag;
    initial_flag = 0;
    nPop_Initial=nPop;
    nPop_Final=30;
    fnm = Prob;
    MaxIter0=ceil(MaxNFE/((nPop_Initial+nPop_Final)/2));   % Approximate Maximum Iterations

    Cr=0.5;


    %%%%%%%%%%%

    NFE=0;
    Gbest.Position=[];
    Gbest.Cost=inf;
    BestCosts=nan(1,MaxIter0);
    nfe=BestCosts;
    for i=1:nPop
        Velocity(i,:)=zeros(1,nD); %#ok<*SAGROW>
        Position(i,:)=lb+(ub-lb).*rand(1,nD);
        Cost(i)=fobj(Position(i,:));
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
            
            Velocity(i,:)= (rand(1,nD).*Velocity(i,:)+rand(1,nD).*(Velocity(jj2,:)-Velocity(jj1,:)))+rand(1,nD).*(PbestPosition(i,:)-Position(jj1,:))+rand(1,nD).*(PbestPosition(jj2,:)-Position(i,:))-rand(1,nD).*(PbestPosition(jj1,:)-Position(jj3,:))+rand(1,nD).*(PbestPosition(jj3,:)-Position(jj2,:));%%ORIGINAL
            
            BB=(PbestCost(jj2))/(PbestCost(i));
            GG=(PbestCost(jjj))/(PbestCost(i));
            
            Position(i,:)=PbestPosition(i,:)+rand(1,nD).*rand(1,nD).*(( PbestPosition(jj2,:)+Gbest.Position-2*PbestPosition(i,:))+(Velocity(i,:)));
            
            f1=(Gbest.Cost)/(PbestCost(i)+Gbest.Cost);
            f0=(PbestCost(jj2))/(PbestCost(jj2)+PbestCost(i));
            
            DE1=((PbestPosition(jj2,:)-PbestPosition(i,:)));
            
            for ww=1:nD
                if rand<Cr
                    Position(i,ww)=PbestPosition(i,ww)+rand*rand*(DE1(ww));
                end
            end
            
            Position(i,:)=min(max(Position(i,:),lb),ub);
            
            Cost(i)=fobj(Position(i,:));
            
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

        if abs(Gbest.Cost-glomin) < e2s 
            break;
        end


        if (mod(NFE,50000)==0)
            disp(['Func = ' num2str(Prob) ', Run = ' num2str(Run) ', Iter = ' num2str(NFE) ', Best Fitness = ' num2str(Gbest.Cost)]);
        end

    end
    Bestdata.cost = Gbest.Cost;
    Bestdata.nfe = NFE-nPop;

end

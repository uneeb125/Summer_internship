
function Bestdata=AHA(fnum,run, Npop, MaxEval,lb,ub,Dim,fobj,e2s,glomin,log_interval)

    curve = inf;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fnum: The index of function.                    %
% MaxIt: The maximum number of iterations.            %
% Npop: The size of hummingbird population.           %
% PopPos: The position of population.                 %
% PopFit: The fitness of population.                  %
% Dim: The dimensionality of prloblem.                %
% BestX: The best solution found so far.              %
% BestF: The best fitness corresponding to BestX.     %
% HisBestFit: History best fitness over iterations.   %
% lb: The low boundary of search space               %
% ub: The up boundary of search space.                %
% VisitTable: The visit table.                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global initial_flag;
initial_flag = 0;

MaxIt = MaxEval/Npop;

    PopPos=zeros(Npop,Dim);
    PopFit=zeros(1,Npop);
    for i=1:Npop
        PopPos(i,:)=rand(1,Dim).*(ub-lb)+lb;
        PopFit(i)=fobj(PopPos(i,:));
    end

    BestF=inf;
    BestX=[];

    for i=1:Npop
        if PopFit(i)<=BestF
            BestF=PopFit(i);
            BestX=PopPos(i,:);
        end
    end

    % Initialize visit table
    HisBestFit=zeros(MaxIt,1);
    VisitTable=zeros(Npop) ;
    VisitTable(logical(eye(Npop)))=NaN;    
    
    for It=1:MaxIt
        DirectVector=zeros(Npop,Dim);% Direction vector/matrix

        for i=1:Npop
            r=rand;
            if r<1/3     % Diagonal flight
                RandDim=randperm(Dim);
                if Dim>=3
                    RandNum=ceil(rand*(Dim-2)+1);
                else
                    RandNum=ceil(rand*(Dim-1)+1);
                end
                DirectVector(i,RandDim(1:RandNum))=1;
            else
                if r>2/3  % Omnidirectional flight
                    DirectVector(i,:)=1;
                else  % Axial flight
                    RandNum=ceil(rand*Dim);
                    DirectVector(i,RandNum)=1;
                end
            end

            if rand<0.5   % Guided foraging
                [MaxUnvisitedTime,TargetFoodIndex]=max(VisitTable(i,:));
                MUT_Index=find(VisitTable(i,:)==MaxUnvisitedTime);
                if length(MUT_Index)>1
                    [~,Ind]= min(PopFit(MUT_Index));
                    TargetFoodIndex=MUT_Index(Ind);
                end

                newPopPos=PopPos(TargetFoodIndex,:)+randn*DirectVector(i,:).*...
                     (PopPos(i,:)-PopPos(TargetFoodIndex,:));
                newPopPos=SpaceBound(newPopPos,ub,lb);
                newPopFit=fobj(newPopPos);
                
                if newPopFit<PopFit(i)
                    PopFit(i)=newPopFit;
                    PopPos(i,:)=newPopPos;
                    VisitTable(i,:)=VisitTable(i,:)+1;
                    VisitTable(i,TargetFoodIndex)=0;
                    VisitTable(:,i)=max(VisitTable,[],2)+1;
                    VisitTable(i,i)=NaN;
                else
                    VisitTable(i,:)=VisitTable(i,:)+1;
                    VisitTable(i,TargetFoodIndex)=0;
                end
            else    % Territorial foraging
                newPopPos= PopPos(i,:)+randn*DirectVector(i,:).*PopPos(i,:);
                newPopPos=SpaceBound(newPopPos,ub,lb);
                newPopFit=fobj(newPopPos);
                if newPopFit<PopFit(i)
                    PopFit(i)=newPopFit;
                    PopPos(i,:)=newPopPos;
                    VisitTable(i,:)=VisitTable(i,:)+1;
                    VisitTable(:,i)=max(VisitTable,[],2)+1;
                    VisitTable(i,i)=NaN;
                else
                    VisitTable(i,:)=VisitTable(i,:)+1;
                end
            end
        end

        if mod(It,2*Npop)==0 % Migration foraging
            [~, MigrationIndex]=max(PopFit);
            PopPos(MigrationIndex,:) =rand(1,Dim).*(ub-lb)+lb;
            PopFit(MigrationIndex)=fobj(PopPos(MigrationIndex,:));
            VisitTable(MigrationIndex,:)=VisitTable(MigrationIndex,:)+1;
            VisitTable(:,MigrationIndex)=max(VisitTable,[],2)+1;
            VisitTable(MigrationIndex,MigrationIndex)=NaN;            
        end

        for i=1:Npop
            if PopFit(i)<BestF
                BestF=PopFit(i);
                BestX=PopPos(i,:);
            end
        end

        HisBestFit(It)=BestF;
        if mod(It,log_interval)==0
            disp(['Func = ' num2str(fnum) ', Run = ' num2str(run) ', Iter = ' num2str(It) ', Best Fitness = ' num2str(BestF)]);
            curve = [curve BestF];
        end
    
        if abs(BestF-glomin)<e2s 
            break;
        end
    end

Bestdata.cost=BestF;
Bestdata.nfe = (It*Npop);

Bestdata.curve = curve;

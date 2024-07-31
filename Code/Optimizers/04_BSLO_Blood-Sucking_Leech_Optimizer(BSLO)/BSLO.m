%_________________________________________________________________________________
%  Blood-Sucking Leech Optimizer                                                               
%                                                                                                     
%  Developed in MATLAB R2023b                                                                  
%                                                                                                     
%  programming: Jianfu Bai                                                          
%                                                                                                     
%  e-Mail: Jianfu.Bai@UGent.be, magd.abdelwahab@ugent.be                                                               
%  Soete Laboratory, Department of Electrical Energy, Metals, Mechanical Constructions, and Systems, 
%  Faculty of Engineering and Architecture, Ghent University, Belgium                                                           
%                                                                                                                                                                                                                                                              
%  paper: Jianfu Bai, H. Nguyen-Xuan, Elena Atroshchenko, Gregor Kosec, Lihua Wang, Magd Abdel Wahab, Blood-sucking leech optimizer[J]. Advances in Engineering Software, 2024, 195: 103696.
%  doi.org/10.1016/j.advengsoft.2024.103696 
%____________________________________________________________________________________
function Bestdata=BSLO(fnum,run,Npop,MaxEval,lb,ub,dim,fobj,e2s,glomin,log_interval)

    curve = inf;

global initial_flag;
initial_flag = 0;

Max_iter = MaxEval/Npop;

%% initialize best Leeches
Leeches_best_pos=zeros(1,dim);
Leeches_best_score=inf; 
%% Initialize the positions of search agents
Leeches_Positions=initialization(Npop,dim,ub,lb);
Convergence_curve=zeros(1,Max_iter);
Temp_best_fitness=zeros(1,Max_iter);
fitness=zeros(1,Npop);
%% Initialize parameters
t=0;m=0.8;a=0.97;b=0.001;t1=20;t2=20;
% Main loop
while t<Max_iter
    N1=floor((m+(1-m)*(t/Max_iter)^2)*Npop);
    %calculate fitness values
     for i=1:size(Leeches_Positions,1)  
         % boundary checking
         Flag4ub=Leeches_Positions(i,:)>ub;
         Flag4lb=Leeches_Positions(i,:)<lb;
         Leeches_Positions(i,:)=(Leeches_Positions(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;               
         % Calculate objective function for each search agent
         fitness(i)=fobj(Leeches_Positions(i,:));
         % Update best Leeches
         if fitness(i)<=Leeches_best_score 
             Leeches_best_score=fitness(i); 
             Leeches_best_pos=Leeches_Positions(i,:);
         end
     end
     Prey_Position=Leeches_best_pos;
     % Re-tracking strategy
     Temp_best_fitness(t+1)=Leeches_best_score;
     if t>t1
         if Temp_best_fitness(t+1)==Temp_best_fitness(t+1-t2)
             for i=1:size(Leeches_Positions,1) 
                 if fitness(i)==Leeches_best_score 
                    Leeches_Positions(i,:)=rand(1,dim).*(ub-lb)+lb;
                 end
             end
         end
     end    
    if rand()<0.5
        s=8-1*(-(t/Max_iter)^2+1);
    else
        s=8-7*(-(t/Max_iter)^2+1);
    end 
    beta=-0.5*(t/Max_iter)^6+(t/Max_iter)^4+1.5;
    LV=0.5*levy(Npop,dim,beta);
    %% Generate random integers
    minValue = 1;  % minimum integer value
    maxValue = floor(Npop*(1+t/Max_iter)); % maximum integer value
    k2 = randi([minValue, maxValue], Npop, dim);
    k = randi([minValue, dim], Npop, dim);
    for i=1:N1
        for j=1:size(Leeches_Positions,2) 
            r1=2*rand()-1; % r1 is a random number in [0,1]
            r2=2*rand()-1;
            r3=2*rand()-1;           
            PD=s*(1-(t/Max_iter))*r1;
            if abs(PD)>=1
                % Exploration of directional leeches
                b=0.001;
                W1=(1-t/Max_iter)*b*LV(i,j);
                L1=r2*abs(Prey_Position(j)-Leeches_Positions(i,j))*PD*(1-k2(i,j)/Npop);
                L2=abs(Prey_Position(j)-Leeches_Positions(i,k(i,j)))*PD*(1-(r2^2)*(k2(i,j)/Npop));
                if rand()<a
                if abs(Prey_Position(j))>abs(Leeches_Positions(i,j))
                Leeches_Positions(i,j)=Leeches_Positions(i,j)+W1*Leeches_Positions(i,j)-L1;
                else
                Leeches_Positions(i,j)=Leeches_Positions(i,j)+W1*Leeches_Positions(i,j)+L1;
                end
                else
                if abs(Prey_Position(j))>abs(Leeches_Positions(i,j))
                Leeches_Positions(i,j)=Leeches_Positions(i,j)+W1*Leeches_Positions(i,k(i,j))-L2;
                else
                Leeches_Positions(i,j)=Leeches_Positions(i,j)+W1*Leeches_Positions(i,k(i,j))+L2;
                end
                end                
            else
                % Exploitation of directional leeches
                if t>=0.1*Max_iter
                    b=0.00001;
                end
                W1=(1-t/Max_iter)*b*LV(i,j);
                L3=abs(Prey_Position(j)-Leeches_Positions(i,j))*PD*(1-r3*k2(i,j)/Npop);
                L4=abs(Prey_Position(j)-Leeches_Positions(i,k(i,j)))*PD*(1-r3*k2(i,j)/Npop);
                if rand()<a
                if abs(Prey_Position(j))>abs(Leeches_Positions(i,j))
                Leeches_Positions(i,j)=Prey_Position(j)+W1*Prey_Position(j)-L3;
                else
                Leeches_Positions(i,j)=Prey_Position(j)+W1*Prey_Position(j)+L3;
                end
                else
                 if abs(Prey_Position(j))>abs(Leeches_Positions(i,j))
                Leeches_Positions(i,j)=Prey_Position(j)+W1*Prey_Position(j)-L4;
                else
                Leeches_Positions(i,j)=Prey_Position(j)+W1*Prey_Position(j)+L4;
                end                   
                end
            end
        end
    end
    %Search strategy of directionless Leeches
    for i=(N1+1):size(Leeches_Positions,1)
        for j=1:size(Leeches_Positions,2)
            if min(lb)>=0
                LV(i,j)=abs(LV(i,j));
            end
            if rand()>0.5
            Leeches_Positions(i,j)=(t/Max_iter)*LV(i,j)*Leeches_Positions(i,j)*abs(Prey_Position(j)-Leeches_Positions(i,j));  
            else
            Leeches_Positions(i,j)=(t/Max_iter)*LV(i,j)*Prey_Position(j)*abs(Prey_Position(j)-Leeches_Positions(i,j));          
            end
        end
    end
    t=t+1;     
    Convergence_curve(t)=Leeches_best_score;  
    if mod(t,log_interval)==0
        disp(['Func = ' num2str(fnum) ', Run = ' num2str(run) ', Iter = ' num2str(t) ', Best Fitness = ' num2str(Leeches_best_score)]);
        curve = [curve Leeches_best_score];
    end

    if abs(Leeches_best_score-glomin)<e2s 
        break;
    end

end

Bestdata.cost = Leeches_best_score;
Bestdata.nfe = (t*Npop);
Bestdata.curve = curve;

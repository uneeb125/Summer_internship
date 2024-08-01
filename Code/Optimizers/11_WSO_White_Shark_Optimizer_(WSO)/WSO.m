
%% White Shark Optimizer (WSO) source codes version 1.0
%
%  Developed in MATLAB R2018a
%
%  Programmer: Malik Braik
%
%         e-Mail: mbraik@bau.edu.jo
%

%   Main paper:
%   Malik Braik, Abdelaziz Hammouri, Jaffar Atwan, Mohammed Azmi Al-Betar, Mohammed A.Awadallah

%   White Shark Optimizer: A novel bio-inspired meta-heuristic algorithm for global optimization problems
%   Knowledge-Based Systems
%   DOI: https://doi.org/10.1016/j.knosys.2022.108457

function Bestdata=WSO(fnum,run,nPop,MaxEval,lb,ub,nD,fobj,e2s,glomin,log_interval)

    curve = inf;
    curve_it = 0;

global initial_flag;
initial_flag = 0;

Maxiter = MaxEval/nPop;

%% Convergence curve
ccurve=zeros(1,Maxiter);

% %%% Show the convergence curve
%     figure (1);
%     set(gcf,'color','w');
%     hold on
%     xlabel('Iteration','interpreter','latex','FontName','Times','fontsize',10)
%     ylabel('fitness value','interpreter','latex','FontName','Times','fontsize',10);
%     grid;

%% Start the WSO  Algorithm
% Generation of initial solutions
WSO_Positions=initialization(nPop,nD,ub,lb);% Initial population

% initial velocity
v=0.0*WSO_Positions;

%% Evaluate the fitness of the initial population
fit=zeros(nPop,1);

for i=1:nPop
    fit(i,1)=fobj(WSO_Positions(i,:));
end

%% Initalize the parameters of WSO
fitness=fit; % Initial fitness of the random positions of the WSO

[fmin0,index]=min(fit);

wbest = WSO_Positions; % Best position initialization
gbest = WSO_Positions(index,:); % initial global position

%% WSO Parameters
fmax=0.75; %  Maximum frequency of the wavy motion
fmin=0.07; %  Minimum frequency of the wavy motion
tau=4.11;

mu=2/abs(2-tau-sqrt(tau^2-4*tau));

pmin=0.5;
pmax=1.5;
a0=6.250;
a1=100;
a2=0.0005;
%% Start the iterative process of WSO
for ite=1:Maxiter
    
    mv=1/(a0+exp((Maxiter/2.0-ite)/a1));
    s_s=abs((1-exp(-a2*ite/Maxiter))) ;
    
    p1=pmax+(pmax-pmin)*exp(-(4*ite/Maxiter)^2);
    p2=pmin+(pmax-pmin)*exp(-(4*ite/Maxiter)^2);
    
    %% Update the speed of the white sharks in water
    nu=floor((nPop).*rand(1,nPop))+1;
    
    for i=1:size(WSO_Positions,1)
        rmin=1; rmax=3.0;
        rr=rmin+rand()*(rmax-rmin);
        wr=abs(((2*rand()) - (1*rand()+rand()))/rr);
        v(i,:)=  mu*v(i,:) +  wr *(wbest(nu(i),:)-WSO_Positions(i,:));
        %% or
        
        %          v(i,:)=  mu*(v(i,:)+ p1*(gbest-WSO_Positions(i,:))*rand+....
        %                    + p2*(wbest(nu(i),:)-WSO_Positions(i,:))*rand);
    end
    
    %% Update the white shark position
    for i=1:size(WSO_Positions,1)
        
        f =fmin+(fmax-fmin)/(fmax+fmin);
        
        a=sign(WSO_Positions(i,:)-ub)>0;
        b=sign(WSO_Positions(i,:)-lb)<0;
        
        wo=xor(a,b);
        
        % locate the prey based on its sensing (sound, waves)
        if rand<mv
            WSO_Positions(i,:)=  WSO_Positions(i,:).*(~wo) + (ub.*a+lb.*b); % random allocation
        else
            WSO_Positions(i,:) = WSO_Positions(i,:)+ v(i,:)/f;  % based on the wavy motion
        end
    end
    
    %% Update the position of white sharks consides_sng fishing school
    for i=1:size(WSO_Positions,1)
        for j=1:size(WSO_Positions,2)
            if rand<s_s
                
                Dist=abs(rand*(gbest(j)-1*WSO_Positions(i,j)));
                
                if(i==1)
                    WSO_Positions(i,j)=gbest(j)+rand*Dist*sign(rand-0.5);
                else
                    WSO_Pos(i,j)= gbest(j)+rand*Dist*sign(rand-0.5);
                    WSO_Positions(i,j)=(WSO_Pos(i,j)+WSO_Positions(i-1,j))/2*rand;
                end
            end
            
        end
    end
    %
    
    %% Update global, best and new positions
    
    for i=1:nPop
        % Handling boundary violations
        if WSO_Positions(i,:)>=lb & WSO_Positions(i,:)<=ub%
            % Find the fitness
            fit(i)=fobj(WSO_Positions(i,:));
            
            % Evaluate the fitness
            if fit(i)<fitness(i)
                wbest(i,:) = WSO_Positions(i,:); % Update the best positions
                fitness(i)=fit(i);   % Update the fitness
            end
            
            %% Finding out the best positions
            if (fitness(i)<fmin0)
                fmin0=fitness(i);
                gbest = wbest(index,:); % Update the global best positions
            end
            
        end
    end
    
    %% Obtain the results
    if mod(ite,log_interval)==0
        disp(['Func = ' num2str(fnum) ', Run = ' num2str(run) ', Iter = ' num2str(ite) ', Best Fitness = ' num2str(fmin0)]);
        curve = [curve fmin0];
        curve_it = [curve_it ite];
    end
    
    if abs(fmin0-glomin)< e2s
        break;
    end
    
    
    ccurve(ite)=fmin0; % Best found value until iteration ite
    
    % if ite>2
    %        line([ite-1 ite], [ccurve(ite-1) ccurve(ite)],'Color','b');
    %        title({'Convergence characteristic curve'},'interpreter','latex','FontName','Times','fontsize',12);
    %        xlabel('Iteration');
    %        ylabel('Best score obtained so far');
    %        drawnow
    % end
    
end
Bestdata.cost=fmin0;
Bestdata.nfe = (ite*nPop);
Bestdata.curve = curve;
Bestdata.curve_it = curve_it;

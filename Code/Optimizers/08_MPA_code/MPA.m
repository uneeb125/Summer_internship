%_________________________________________________________________________
%  Marine Predators Algorithm source code (Developed in MATLAB R2015a)
%
%  programming: Afshin Faramarzi & Seyedali Mirjalili
%
% paper:
%  A. Faramarzi, M. Heidarinejad, S. Mirjalili, A.H. Gandomi, 
%  Marine Predators Algorithm: A Nature-inspired Metaheuristic
%  Expert Systems with Applications
%  DOI: doi.org/10.1016/j.eswa.2020.113377
%  
%  E-mails: afaramar@hawk.iit.edu            (Afshin Faramarzi)
%           muh182@iit.edu                   (Mohammad Heidarinejad)
%           ali.mirjalili@laureate.edu.au    (Seyedali Mirjalili) 
%           gandomi@uts.edu.au               (Amir H Gandomi)
%_________________________________________________________________________

function Bestdata=MPA(fnum,run,nPop,MaxEval,lb,ub,nD,fobj,e2s,glomin,log_interval)

    curve = inf;
    curve_it = 0;


   global initial_flag;
   initial_flag = 0;
   
   Maxiter = floor(MaxEval/nPop);


Top_predator_pos=zeros(1,nD);
Top_predator_fit=inf; 

Convergence_curve=zeros(1,Maxiter);
stepsize=zeros(nPop,nD);
fitness=inf(nPop,1);


Prey=initialization(nPop,nD,ub,lb);
  
Xmin=repmat(ones(1,nD).*lb,nPop,1);
Xmax=repmat(ones(1,nD).*ub,nPop,1);
         

Iter=0;
FADs=0.2;
P=0.5;

while Iter<Maxiter    
     %------------------- Detecting top predator -----------------    
 for i=1:size(Prey,1)  
        
    Flag4ub=Prey(i,:)>ub;
    Flag4lb=Prey(i,:)<lb;    
    Prey(i,:)=(Prey(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;                    
        
    fitness(i,1)=fobj(Prey(i,:));
                     
     if fitness(i,1)<Top_predator_fit 
       Top_predator_fit=fitness(i,1); 
       Top_predator_pos=Prey(i,:);
     end          
 end
     
     %------------------- Marine Memory saving ------------------- 
    
 if Iter==0
   fit_old=fitness;    Prey_old=Prey;
 end
     
  Inx=(fit_old<fitness);
  Indx=repmat(Inx,1,nD);
  Prey=Indx.*Prey_old+~Indx.*Prey;
  fitness=Inx.*fit_old+~Inx.*fitness;
        
  fit_old=fitness;    Prey_old=Prey;

     %------------------------------------------------------------   
     
 Elite=repmat(Top_predator_pos,nPop,1);  %(Eq. 10) 
 CF=(1-Iter/Maxiter)^(2*Iter/Maxiter);
                             
 RL=0.05*levy(nPop,nD,1.5);   %Levy random number vector
 RB=randn(nPop,nD);          %Brownian random number vector
           
  for i=1:size(Prey,1)
     for j=1:size(Prey,2)        
       R=rand();
          %------------------ Phase 1 (Eq.12) ------------------- 
       if Iter<Maxiter/3 
          stepsize(i,j)=RB(i,j)*(Elite(i,j)-RB(i,j)*Prey(i,j));                    
          Prey(i,j)=Prey(i,j)+P*R*stepsize(i,j); 
             
          %--------------- Phase 2 (Eqs. 13 & 14)----------------
       elseif Iter>Maxiter/3 && Iter<2*Maxiter/3 
          
         if i>size(Prey,1)/2
            stepsize(i,j)=RB(i,j)*(RB(i,j)*Elite(i,j)-Prey(i,j));
            Prey(i,j)=Elite(i,j)+P*CF*stepsize(i,j); 
         else
            stepsize(i,j)=RL(i,j)*(Elite(i,j)-RL(i,j)*Prey(i,j));                     
            Prey(i,j)=Prey(i,j)+P*R*stepsize(i,j);  
         end  
         
         %----------------- Phase 3 (Eq. 15)-------------------
       else 
           
           stepsize(i,j)=RL(i,j)*(RL(i,j)*Elite(i,j)-Prey(i,j)); 
           Prey(i,j)=Elite(i,j)+P*CF*stepsize(i,j);  
    
       end  
      end                                         
  end    
        
     %------------------ Detecting top predator ------------------        
  for i=1:size(Prey,1)  
        
    Flag4ub=Prey(i,:)>ub;  
    Flag4lb=Prey(i,:)<lb;  
    Prey(i,:)=(Prey(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
  
    fitness(i,1)=fobj(Prey(i,:));
        
      if fitness(i,1)<Top_predator_fit 
         Top_predator_fit=fitness(i,1);
         Top_predator_pos=Prey(i,:);
      end     
  end
        
     %---------------------- Marine Memory saving ----------------
    
 if Iter==0
    fit_old=fitness;    Prey_old=Prey;
 end
     
    Inx=(fit_old<fitness);
    Indx=repmat(Inx,1,nD);
    Prey=Indx.*Prey_old+~Indx.*Prey;
    fitness=Inx.*fit_old+~Inx.*fitness;
        
    fit_old=fitness;    Prey_old=Prey;

     %---------- Eddy formation and FADs� effect (Eq 16) ----------- 
                             
  if rand()<FADs
     U=rand(nPop,nD)<FADs;                                                                                              
     Prey=Prey+CF*((Xmin+rand(nPop,nD).*(Xmax-Xmin)).*U);

  else
     r=rand();  Rs=size(Prey,1);
     stepsize=(FADs*(1-r)+r)*(Prey(randperm(Rs),:)-Prey(randperm(Rs),:));
     Prey=Prey+stepsize;
  end
                                                        
  Iter=Iter+1;  
  Convergence_curve(Iter)=Top_predator_fit; 

    if mod(Iter,log_interval)==0
      disp(['Func = ' num2str(fnum) ', Run = ' num2str(run) ', Iter = ' num2str(Iter) ', Best Fitness = ' num2str(Top_predator_fit)]);
      curve = [curve Top_predator_fit];
      curve_it = [curve_it Iter];
   end
   
   if abs(Top_predator_fit-glomin)<e2s 
      break;
   end
end

Bestdata.cost=Top_predator_fit;
Bestdata.nfe = (Iter*nPop);

Bestdata.curve = curve;
Bestdata.curve_it = curve_it;

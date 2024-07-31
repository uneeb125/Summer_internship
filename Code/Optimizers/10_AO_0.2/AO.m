%_______________________________________________________________________________________%
%  Aquila Optimizer (AO) source codes (version 1.0)                                     %
%                                                                                       %
%  Developed in MATLAB R2015a (7.13)                                                    %
%  Author and programmer:                                                               %
%  Abualigah, L, Yousri, D, Abd Elaziz, M, Ewees, A, Al-qaness, M, Gandomi, A.          %
%         e-Mail: Aligah.2020@gmail.com      (Laith Abualigah)                          %
%       Homepage:                                                                       %
%         1- https://scholar.google.com/citations?user=39g8fyoAAAAJ&hl=en               %
%         2- https://www.researchgate.net/profile/Laith_Abualigah                       %
%                                                                                       %
%   Main paper:                                                                         %
%_____________Aquila Optimizer: A novel meta-heuristic optimization algorithm___________%
%_______________________________________________________________________________________%
% Abualigah, L, Yousri, D, Abd Elaziz, M, Ewees, A, Al-qaness, M, Gandomi, A. (2021).
% Aquila Optimizer: A novel meta-heuristic optimization algorithm.
% Computers & Industrial Engineering.
%_______________________________________________________________________________________%
function Bestdata=AO(fnum,run,nPop,MaxEval,lb,ub,nD,fobj,e2s,glomin,log_interval)

    curve = inf;


global initial_flag;
initial_flag = 0;

Maxiter = MaxEval/nPop;

Best_P=zeros(1,nD);
Best_FF=inf;


X=initialization(nPop,nD,ub,lb);
Xnew=X;
Ffun=zeros(1,size(X,1));
Ffun_new=zeros(1,size(Xnew,1));

t=1;


alpha=0.1;
delta=0.1;

while t<Maxiter+1
    for i=1:size(X,1)
        F_UB=X(i,:)>ub;
        F_LB=X(i,:)<lb;
        X(i,:)=(X(i,:).*(~(F_UB+F_LB)))+ub.*F_UB+lb.*F_LB;
        Ffun(1,i)=fobj(X(i,:));
        if Ffun(1,i)<Best_FF
            Best_FF=Ffun(1,i);
            Best_P=X(i,:);
        end
    end
    
    
    G2=2*rand()-1; % Eq. (16)
    G1=2*(1-(t/Maxiter));  % Eq. (17)
    to = 1:nD;
    u = .0265;
    r0 = 10;
    r = r0 +u*to;
    omega = .005;
    phi0 = 3*pi/2;
    phi = -omega*to+phi0;
    x = r .* sin(phi);  % Eq. (9)
    y = r .* cos(phi); % Eq. (10)
    QF=t^((2*rand()-1)/(1-Maxiter)^2); % Eq. (15)
    %-------------------------------------------------------------------------------------
    for i=1:size(X,1)
        %-------------------------------------------------------------------------------------
        if t<=(2/3)*Maxiter
            if rand <0.5
                Xnew(i,:)=Best_P(1,:)*(1-t/Maxiter)+(mean(X(i,:))-Best_P(1,:))*rand(); % Eq. (3) and Eq. (4)
                Ffun_new(1,i)=fobj(Xnew(i,:));
                if Ffun_new(1,i)<Ffun(1,i)
                    X(i,:)=Xnew(i,:);
                    Ffun(1,i)=Ffun_new(1,i);
                end
            else
                %-------------------------------------------------------------------------------------
                Xnew(i,:)=Best_P(1,:).*Levy(nD)+X((floor(nPop*rand()+1)),:)+(y-x)*rand;       % Eq. (5)
                Ffun_new(1,i)=fobj(Xnew(i,:));
                if Ffun_new(1,i)<Ffun(1,i)
                    X(i,:)=Xnew(i,:);
                    Ffun(1,i)=Ffun_new(1,i);
                end
            end
            %-------------------------------------------------------------------------------------
        else
            if rand<0.5
                Xnew(i,:)=(Best_P(1,:)-mean(X))*alpha-rand+((ub-lb)*rand+lb)*delta;   % Eq. (13)
                Ffun_new(1,i)=fobj(Xnew(i,:));
                if Ffun_new(1,i)<Ffun(1,i)
                    X(i,:)=Xnew(i,:);
                    Ffun(1,i)=Ffun_new(1,i);
                end
            else
                %-------------------------------------------------------------------------------------
                Xnew(i,:)=QF*Best_P(1,:)-(G2*X(i,:)*rand)-G1.*Levy(nD)+rand*G2; % Eq. (14)
                Ffun_new(1,i)=fobj(Xnew(i,:));
                if Ffun_new(1,i)<Ffun(1,i)
                    X(i,:)=Xnew(i,:);
                    Ffun(1,i)=Ffun_new(1,i);
                end
            end
        end
    end
    %-------------------------------------------------------------------------------------
    if mod(t,log_interval)==0
        disp(['Func = ' num2str(fnum) ', Run = ' num2str(run) ', Iter = ' num2str(t) ', Best Fitness = ' num2str(Best_FF)]);
        curve = [curve Best_FF];
    end
    conv(t)=Best_FF;
    t=t+1;

    if abs(Best_FF-glomin)< e2s 
        break;
    end

end
Bestdata.cost=Best_FF;
Bestdata.nfe = (t*nPop)-nPop;


end
function o=Levy(d)
beta=1.5;
sigma=(gamma(1+beta)*sin(pi*beta/2)/(gamma((1+beta)/2)*beta*2^((beta-1)/2)))^(1/beta);
u=randn(1,d)*sigma;v=randn(1,d);step=u./abs(v).^(1/beta);
o=step;
end


Bestdata.curve = curve;

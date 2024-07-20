
function [lb,ub,dim,fobj] = Get_Functions_details(F)


switch F
    case 'F1'
        fobj = @F1;
        lb=-100;
        ub=100;
        dim=30;
        
    case 'F2'
        fobj = @F2;
        lb=-10;
        ub=10;
        dim=30;
    
    case 'F3'
        fobj = @F3;
        lb = -1;
        ub = 1;
        dim = 30;    
        
    case 'F4'
        fobj = @F4;
        lb=-100;
        ub=100;
        dim=30;
        
    case 'F5'
        fobj = @F5;
        lb=-100;
        ub=100;
        dim=30;
        
    case 'F6'
        fobj = @F6;
        lb=-30;
        ub=30;
        dim=30;
        
    case 'F7'
        fobj = @F7;
        lb=-100;
        ub=100;
        dim=30;
        
    case 'F8'
        fobj = @F8;
        lb=-1.28;
        ub=1.28;
        dim=30;
        
    case 'F9' 
        fobj = @F9;
        lb=-5;
        ub=10;
        dim=30;
        
    case 'F10'
        fobj = @F10;
        lb=-500;
        ub=500;
        dim=30;
    
    case 'F11' 
        fobj = @F11;
        lb=-10;
        ub=10;
        dim=30;
        
    case 'F12'  
        fobj = @F12;
        lb=-5;
        ub=5;
        dim=30; 
        
    case 'F13'
        fobj = @F13;
        lb=-5.12;
        ub=5.12;
        dim=30;
        
    case 'F14'
        fobj = @F14;
        lb=-32;
        ub=32;
        dim=30;
        
    case 'F15'
        fobj = @F15;
        lb=-600;
        ub=600;
        dim=30;
        
    case 'F16'
        fobj = @F16;
        lb=-10;
        ub=10;
        dim=30;
        
    case 'F17'
        fobj = @F17;
        lb=-50;
        ub=50;
        dim=30;
        
    case 'F18'
        fobj = @F18;
        lb=-50;
        ub=50;
        dim=30;

    case 'F19'
        fobj = @F19;
        lb=-65;
        ub=65;
        dim=2;
        
    case 'F20'
        fobj = @F20;
        lb=-5;
        ub=5;
        dim=4;
        
    case 'F21'
        fobj = @F21;
        lb=-5;
        ub=5;
        dim=2;
        
    case 'F22'
        fobj = @F22;
        lb=0;
        ub=10;
        dim=4;    
        
    case 'F23'
        fobj = @F23;
        lb=0;
        ub=10;
        dim=4;    
        
    case 'F24'
        fobj = @F24;
        lb=0;
        ub=10;
        dim=4;

end

end

% F1

function o = F1(x)
o=sum(x.^2);
end

% F2

function o = F2(x)
o=sum(abs(x))+prod(abs(x));
end

% F3

function o = F3(x)
dim = size(x,2);
o=0;
for i=1:dim
    o=o+abs(x(i))^(i+1);
end
end

% F4

function o = F4(x)
dim=size(x,2);
o=0;
for i=1:dim
    o=o+sum(x(1:i))^2;
end
end

% F5

function o = F5(x)
o=max(abs(x));
end

% F6

function o = F6(x)
dim=size(x,2);
o=sum(100*(x(2:dim)-(x(1:dim-1).^2)).^2+(x(1:dim-1)-1).^2);
end

% F7

function o = F7(x)
o=sum(abs((x+.5)).^2);
end

% F8

function o = F8(x)
dim=size(x,2);
o=sum([1:dim].*(x.^4))+rand;
end

% F9

function o = F9(x)
dim = size(x,2);
o = sum(x.^2)+(sum(0.5*[1:dim].*x))^2+(sum(0.5*[1:dim].*x))^4;
end

% F10

function o = F10(x)
o=sum(-x.*sin(sqrt(abs(x))));
end

% F11

function o = F11(x)
dim = size(x,2);
o = 1+sum(sin(x(1:dim)).^2)-exp(-sum(x.^2));
end

% F12

function o = F12(x)
dim = size(x,2);
o = 0.5*sum(x(1:dim).^4-16*x(1:dim).^2+5*x(1:dim));
end

% F13

function o = F13(x)
dim=size(x,2);
o=sum(x.^2-10*cos(2*pi.*x))+10*dim;
end

% F14

function o = F14(x)
dim=size(x,2);
o=-20*exp(-.2*sqrt(sum(x.^2)/dim))-exp(sum(cos(2*pi.*x))/dim)+20+exp(1);
end

% F15

function o = F15(x)
dim=size(x,2);
o=sum(x.^2)/4000-prod(cos(x./sqrt([1:dim])))+1;
end

% F16

function o = F16(x)
dim = size(x,2);
o = (sum(sin(x(1:dim)).^2) - exp(-sum(x.^2)))*exp(-sum(sin(sqrt(abs(x(1:dim)))).^2));
end

% F17

function o = F17(x)
dim=size(x,2);
o=(pi/dim)*(10*((sin(pi*(1+(x(1)+1)/4)))^2)+sum((((x(1:dim-1)+1)./4).^2).*...
(1+10.*((sin(pi.*(1+(x(2:dim)+1)./4)))).^2))+((x(dim)+1)/4)^2)+sum(Ufun(x,10,100,4));
end

% F18

function o = F18(x)
dim=size(x,2);
o=.1*((sin(3*pi*x(1)))^2+sum((x(1:dim-1)-1).^2.*(1+(sin(3.*pi.*x(2:dim))).^2))+...
((x(dim)-1)^2)*(1+(sin(2*pi*x(dim)))^2))+sum(Ufun(x,5,100,4));
end

% F19

function o = F19(x)
aS=[-32 -16 0 16 32 -32 -16 0 16 32 -32 -16 0 16 32 -32 -16 0 16 32 -32 -16 0 16 32;,...
-32 -32 -32 -32 -32 -16 -16 -16 -16 -16 0 0 0 0 0 16 16 16 16 16 32 32 32 32 32];

for j=1:25
    bS(j)=sum((x'-aS(:,j)).^6);
end
o=(1/500+sum(1./([1:25]+bS))).^(-1);
end

% F20

function o = F20(x)
aK=[.1957 .1947 .1735 .16 .0844 .0627 .0456 .0342 .0323 .0235 .0246];
bK=[.25 .5 1 2 4 6 8 10 12 14 16];bK=1./bK;
o=sum((aK-((x(1).*(bK.^2+x(2).*bK))./(bK.^2+x(3).*bK+x(4)))).^2);
end

% F21

function o = F21(x)
o=4*(x(1)^2)-2.1*(x(1)^4)+(x(1)^6)/3+x(1)*x(2)-4*(x(2)^2)+4*(x(2)^4);
end

% F22

function o = F22(x)
aSH=[4 4 4 4;1 1 1 1;8 8 8 8;6 6 6 6;3 7 3 7;2 9 2 9;5 5 3 3;8 1 8 1;6 2 6 2;7 3.6 7 3.6];
cSH=[.1 .2 .2 .4 .4 .6 .3 .7 .5 .5];

o=0;
for i=1:5
    o=o-((x-aSH(i,:))*(x-aSH(i,:))'+cSH(i))^(-1);
end
end

% F23

function o = F23(x)
aSH=[4 4 4 4;1 1 1 1;8 8 8 8;6 6 6 6;3 7 3 7;2 9 2 9;5 5 3 3;8 1 8 1;6 2 6 2;7 3.6 7 3.6];
cSH=[.1 .2 .2 .4 .4 .6 .3 .7 .5 .5];

o=0;
for i=1:7
    o=o-((x-aSH(i,:))*(x-aSH(i,:))'+cSH(i))^(-1);
end
end

% F24

function o = F24(x)
aSH=[4 4 4 4;1 1 1 1;8 8 8 8;6 6 6 6;3 7 3 7;2 9 2 9;5 5 3 3;8 1 8 1;6 2 6 2;7 3.6 7 3.6];
cSH=[.1 .2 .2 .4 .4 .6 .3 .7 .5 .5];

o=0;
for i=1:10
    o=o-((x-aSH(i,:))*(x-aSH(i,:))'+cSH(i))^(-1);
end
end

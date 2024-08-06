function [lb,ub] = cec17_params(fnum)

if (fnum==4)|(fnum==5)|(fnum==9)
    lb = -10; ub=10;
elseif(fnum==6)
    lb = -20; ub=20;
elseif(fnum==7)|(fnum==19)|(fnum==28)
    lb = -50; ub=50;
else
    lb = -100; ub=100;
end


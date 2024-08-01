function [lb,ub,D] = cec13_params(fnum)

if (fnum==13)
    D=905;
else 
    D=1000;
end

if fnum<10
    params = sprintf('load datafiles/f0%d.mat',fnum);
else 
    params = sprintf('load datafiles/f%d.mat',fnum);
end
eval(params);

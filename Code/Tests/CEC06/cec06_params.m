function [lb, ub, nD, glomin] = cec06_params(fnum)
    global initial_flag;
    persistent params; 
    if initial_flag == 0
        load parameters.mat
    end
lb = params(fnum).lb;
ub = params(fnum).ub;
nD = params(fnum).nD;
glomin = params(fnum).glomin;

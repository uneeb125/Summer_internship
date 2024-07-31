clc
clear
close all
for Prob2Run = 1:1
    global initial_flag;
    initial_flag=0;

    addpath(genpath(fullfile("..","..","Tests","Eng")));
    cpwd = pwd;
    rg_algo = '.*[\/\\][^_]*_([^_]*)';
    algo = (regexp(cpwd,rg_algo,'tokens'));
    algo = algo{1}{1};
    probset = 'eng';

    nRun = 2;                      % Number of runs
    nPop = 30;                      % Population size
    e2s = 1e-5;                     % Erorr to stop
    MaxEval=6e2;        % Maximum NFEs for each problem
    log_interval = 10;
    fit = nan(nRun,size(Prob2Run,2));
    nfe = nan(nRun,size(Prob2Run,2));
    best_curve = nan(nRun,size(Prob2Run,2));

    resultsdir = fullfile("..","..","..","Inprocess/");
    fitsave = strcat(resultsdir,probset,'_',algo,'_','fit','_', num2str(Prob2Run), '.csv' );
    nfesave = strcat(resultsdir,probset,'_',algo,'_','nfe','_', num2str(Prob2Run), '.csv' );
    curvesave = 'curve.csv';
    initcsv = 0;
    % writematrix(initcsv,fitsave);
    % writematrix(initcsv,nfesave);


    for fnum= Prob2Run
        for run = 1:nRun
            [lb,ub,nD,vio,glomin,obj]= eng_params(fnum);
            fobj = @(x) eng_bench(x,vio,obj); 
            data(fnum,run)=CO(fnum,run,nPop,MaxEval,lb,ub,nD,fobj,e2s,glomin,log_interval);
            % disp(['Best Fitness = ' num2str(data(fnum,run).cost)]);
        end
        
        for run =1:nRun 
            fit(run,fnum) = data(fnum,run).cost;
            nfe(run,fnum) = data(fnum,run).nfe;
            curve(run,:)  = data(fnum,run).curve;
        end
        % writematrix(fit,fitsave);
        % writematrix(nfe,nfesave);
        [m,i] = min(curve(:,end));
        best_curve = curve(i,:);
        disp(['Prob# ' num2str(fnum) ' Mean = ' num2str(mean(fit(:,fnum))) ', STDev = ' num2str(std(fit(:,fnum)))]);
        
        initial_flag=0;
    end

    % plot(1:size(Curve,2),Curve);
end


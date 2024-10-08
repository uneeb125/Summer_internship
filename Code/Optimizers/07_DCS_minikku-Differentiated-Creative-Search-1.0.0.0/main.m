clc
clear
close all
for Prob2Run = 1
    global initial_flag;
    initial_flag=0;

    addpath(genpath(fullfile("..","..","Tests","CEC2013")));

    algo = 'DCS';
    probset = 'cec13';

    nRun = 1;                      % Number of runs
    nPop = 30;                      % Population size
    e2s = 1e-5;                     % Erorr to stop
    MaxEval=3e1;        % Maximum NFEs for each problem
    glomin = 0
    fit = nan(nRun,size(Prob2Run,2));
    nfe = nan(nRun,size(Prob2Run,2));

    resultsdir = fullfile("..","..","..","Inprocess/")
    fitsave = strcat(resultsdir,probset,'_',algo,'_','fit','_', num2str(Prob2Run), '.csv' );
    nfesave = strcat(resultsdir,probset,'_',algo,'_','nfe','_', num2str(Prob2Run), '.csv' );
    curvesave = 'curve.csv';
    initcsv = 0;
    writematrix(initcsv,fitsave);
    writematrix(initcsv,nfesave);


    for fnum= Prob2Run
        parfor run = 1:nRun
            [lb,ub,nD]=cec13_params(fnum);
            fobj = @(x) cec13_benchmark_func(x,fnum); 
            data(fnum,run)=DCS(fnum,run,nPop,MaxEval,lb,ub,nD,fobj,e2s,glomin);
            disp(['Best Fitness = ' num2str(data(fnum,run).cost)]);
        end
        
        for run =1:nRun 
            fit(run,fnum) = data(fnum,run).cost;
            nfe(run,fnum) = data(fnum,run).nfe;
        end
        writematrix(fit,fitsave);
        writematrix(nfe,nfesave);

        disp(['Mean = ' num2str(mean(fit(:,fnum))) ', STDev = ' num2str(std(fit(:,fnum)))]);
        
        initial_flag=0;
    end

    % plot(1:size(Curve,2),Curve);
end


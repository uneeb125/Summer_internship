clc
clear
close all
for Prob2Run = 1:13
    global initial_flag;
    initial_flag=0;

    addpath(genpath(fullfile("..","..","Tests","Engineering")));

    algo = 'CO';
    probset = 'eng';

    nRun = 30;                      % Number of runs
    nPop = 30;                      % Population size
    e2s = 1e-5;                     % Erorr to stop
    MaxEval=6e4;        % Maximum NFEs for each problem
    fit = nan(nRun,size(Prob2Run,2));
    nfe = nan(nRun,size(Prob2Run,2));

    resultsdir = fullfile("..","..","..","Inprocess/");
    fitsave = strcat(resultsdir,probset,'_',algo,'_','fit','_', num2str(Prob2Run), '.csv' );
    nfesave = strcat(resultsdir,probset,'_',algo,'_','nfe','_', num2str(Prob2Run), '.csv' );
    curvesave = 'curve.csv';
    initcsv = 0;
    % writematrix(initcsv,fitsave);
    % writematrix(initcsv,nfesave);


    for fnum= Prob2Run
        parfor run = 1:nRun
            [lb,ub,nD,vio,glomin,obj]= eng_params(fnum);
            fobj = @(x) eng_bench(x,vio,obj); 
            data(fnum,run)=CO(fnum,run,nPop,MaxEval,lb,ub,nD,fobj,e2s,glomin);
            % disp(['Best Fitness = ' num2str(data(fnum,run).cost)]);
        end
        
        for run =1:nRun 
            fit(run,fnum) = data(fnum,run).cost;
            nfe(run,fnum) = data(fnum,run).nfe;
        end
        % writematrix(fit,fitsave);
        % writematrix(nfe,nfesave);

        disp(['Prob# ' num2str(fnum) ' Mean = ' num2str(mean(fit(:,fnum))) ', STDev = ' num2str(std(fit(:,fnum)))]);
        
        initial_flag=0;
    end

    % plot(1:size(Curve,2),Curve);
end


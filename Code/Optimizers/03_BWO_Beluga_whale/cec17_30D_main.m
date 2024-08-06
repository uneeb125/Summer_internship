
clc
clear
close all
for fnum = 1:28
    global initial_flag;
    initial_flag=0;

    addpath(genpath(fullfile("..","..","Tests","CEC17")));
    cpwd = pwd;
    rg_algo = '.*[\/\\][^_]*_([^_]*)';
    algo = (regexp(cpwd,rg_algo,'tokens'));
    algo = algo{1}{1};
    probset = 'cec17_30D';

    nRun = 25;                      % Number of runs
    nPop = 30;                      % Population size
    nD = 30;
    e2s = 1e-5;                     % Erorr to stop
    MaxEval=(2e4)*nD;        % Maximum NFEs for each problem
    log_interval = 2e0;
    fit = nan(nRun,size(fnum,2));
    nfe = nan(nRun,size(fnum,2));

    resultsdir = fullfile("..","..","..","Inprocess/");
    fitsave = strcat(resultsdir,probset,'_',algo,'_','fit','_', num2str(fnum), '.csv' );
    nfesave = strcat(resultsdir,probset,'_',algo,'_','nfe','_', num2str(fnum), '.csv' );
    curvesave = strcat(resultsdir,probset,'_',algo,'_','curve','_', num2str(fnum), '.csv' );
    initcsv = [];
    writematrix(initcsv,fitsave);
    writematrix(initcsv,nfesave);
    writematrix(initcsv,curvesave);
    algorithm = str2func(algo);
    best_curve = inf;
    glomin = 0;
    viofactor = 100;
        parfor run = 1:nRun
            [lb,ub]=cec17_params(fnum);
            fobj = @(x) cec17_funcs(x,fnum);
            vobj = @(x) cec17_bench(x,viofactor,fobj); 
            data(fnum,run)=feval(algorithm,fnum,run,nPop,MaxEval,lb,ub,nD,vobj,e2s,glomin,log_interval);
            % disp(['Best Fitness = ' num2str(data(fnum,run).cost)]);
        end
        
        for run =1:nRun 
            fit(run,fnum) = data(fnum,run).cost;
            nfe(run,fnum) = data(fnum,run).nfe;
            if data(fnum,run).curve(end)<best_curve
                writematrix(initcsv,curvesave);
                dlmwrite(curvesave,data(fnum,run).curve,'delimiter',',','-append');
                dlmwrite(curvesave,data(fnum,run).curve_it,'delimiter',',','-append');
                best_curve = data(fnum,run).curve(end);
            end
        end
        writematrix(fit,fitsave);
        writematrix(nfe,nfesave);
        disp(['Prob# ' num2str(fnum) ' Mean = ' num2str(mean(fit(:,fnum))) ', STDev = ' num2str(std(fit(:,fnum)))]);
        
        initial_flag=0;

    plot(data(fnum,run).curve_it,data(fnum,run).curve);
end

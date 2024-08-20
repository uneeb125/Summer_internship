clc
clear
close all
for fnum = 1
    global initial_flag;
    initial_flag=0;

    addpath(genpath(fullfile("..","..","Tests","WSN")));
    cpwd = pwd;
    rg_algo = '.*[\/\\][^_]*_([^_]*)';
    algo = (regexp(cpwd,rg_algo,'tokens'));
    algo = algo{1}{1};
    probset = 'wsn';

    nRun = 30;                      % Number of runs
    nPop = 30;                      % Population size
    e2s = 1e-5;                     % Erorr to stop
    MaxEval=6e4;        % Maximum NFEs for each problem
    rSensors = 10;           % radius of each sensor layout
    xArea = 100;             % Length and width of world
    Area = xArea *xArea;     %Area of the world
    target = 32;
    nD = 50;
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

        parfor run = 1:nRun
            fobj = @(x) wsn_bench(x,rSensors,Area); 
            data(fnum,run)=feval(algorithm,fnum,run,nPop,MaxEval,1,xArea,nD,fobj,e2s,glomin,log_interval);
            % disp(['Best Fitness = ' num2str(data(fnum,run).cost)]);
        end
        
        for run =1:nRun 
            fit(run,fnum) = -(data(fnum,run).cost);
            nfe(run,fnum) = data(fnum,run).nfe;
            if data(fnum,run).curve(end)<best_curve
                writematrix(initcsv,curvesave);
                dlmwrite(curvesave,-(data(fnum,run).curve),'delimiter',',','-append');
                dlmwrite(curvesave,data(fnum,run).curve_it,'delimiter',',','-append');
                best_curve = data(fnum,run).curve(end);
            end
        end
        writematrix(fit,fitsave);
        writematrix(nfe,nfesave);
        disp(['Prob# ' num2str(fnum) ' Mean = ' num2str(mean(fit(:,fnum))) ', STDev = ' num2str(std(fit(:,fnum)))]);
        
        initial_flag=0;

    plot(data(fnum,run).curve_it,-(data(fnum,run).curve));
end




clc
clear
close all
for Prob2Run = 1:1
    global initial_flag;
    initial_flag=0;

    addpath(genpath(fullfile("..","..","Tests","WSN")));
    cpwd = pwd;
    rg_algo = '.*[\/\\][^_]*_([^_]*)';
    algo = regexp(cpwd,rg_algo,'tokens'){1}{1};
    algo = algo{1}{1};
    probset = 'wsn';

    nRun = 1;                      % Number of runs
    nPop = 30;                      % Population size
    e2s = 1e-5;                     % Erorr to stop
    MaxEval=6e3;        % Maximum NFEs for each problem
    nD = 50; 
    rSensors = 10;           % radius of each sensor layout
    xArea = 100;             % Length and width of world
    Area = xArea *xArea;     %Area of the world

    fit = nan(nRun,size(Prob2Run,2));
    nfe = nan(nRun,size(Prob2Run,2));

    resultsdir = fullfile("..","..","..","Inprocess/");
    fitsave = strcat(resultsdir,probset,'_',algo,'_','fit','_', num2str(Prob2Run), '.csv' );
    nfesave = strcat(resultsdir,probset,'_',algo,'_','nfe','_', num2str(Prob2Run), '.csv' );
    curvesave = 'curve.csv';
    initcsv = 0;
    csvwrite(fitsave,initcsv);
    csvwrite(nfesave,initcsv);
    algorithm = str2func(algo);

    for fnum= Prob2Run
        parfor run = 1:nRun
            fobj = @(x) wsn_bench(x,rSensors,Area); 
            data(fnum,run)=feval(algorithm, fnum,run,nPop,MaxEval,1,xArea,nD,fobj,e2s,0);
            % disp(['Best Fitness = ' num2str(data(fnum,run).cost)]);
            fit(run,fnum) = data(fnum,run).cost;
            nfe(run,fnum) = data(fnum,run).nfe;
        csvwrite(fitsave,fit);
        csvwrite(nfesave,nfe);
        end
        
        % writematrix(fit,fitsave);
        % writematrix(nfe,nfesave);

        disp(['Prob# ' num2str(fnum) ' Mean = ' num2str(mean(fit(:,fnum))) ', STDev = ' num2str(std(fit(:,fnum)))]);
        
        initial_flag=0;
    end

    % plot(1:size(Curve,2),Curve);
end


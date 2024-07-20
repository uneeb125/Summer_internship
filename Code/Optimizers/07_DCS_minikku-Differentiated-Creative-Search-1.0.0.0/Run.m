
% =============================================================================================================================================================================
% Differentiated Creative Search (DCS)

% CITATION:
% Duankhan P., Sunat K., Chiewchanwattana S., and Nasa-ngium P. "The Differentiated Creative Search (DCS): Leveraging Differentiated Knowledge-acquisition and Creative Realism
% to Address Complex Optimization Problems". (Accepted for publication in Expert Systems with Applications)
% =============================================================================================================================================================================

clc;
clearvars;

all_algo = {
    'DCS', ...      1. Differentiated Creative Search (DCS)
    'CMAES', ...    2. Competitor
    'GSK', ...      3. Competitor
    'GWO', ...      4. Competitor
    'MTDE', ...     5. Competitor
    'SDPSO', ...    6. Competitor
    };

run_test = 1; % Run test
scoring = 0; % Show scores

selected_test_algo = 1;

selected_problem = [1,3:30];
% selected_problem = [1,3,6,9,10,12,13,18,22,26,30];
% selected_problem = [1,3,6,12,18,30];

% Brenchmark
brenchmark_name = 'CEC2017';
all_dim_size = [10,30,50,100];
% pop_size = 30;
% max_nfes = 100000;

if run_test

    % for SearchAgents_no = pop_size % Population size
    %     for Max_iteration = max_nfes % fitness evaluation

    % Brenchmark
    all_func_no = selected_problem; % F1-30

    % Create output directories for the experimental.
    output_dir_name = strcat(brenchmark_name,'/test_');
    OutputDir = strcat('./results/',output_dir_name);

    if ~exist(OutputDir, 'dir')
        mkdir(OutputDir);
    end

    for algo_no = selected_test_algo

        % algorithm's name
        algo_name = string(all_algo(algo_no));

        % Create output directories for the experimental.
        algo_dir_name = strcat(OutputDir,'/',algo_name);

        if ~exist(algo_dir_name, 'dir')
            mkdir(algo_dir_name);
        end

        for dim_size = all_dim_size

            % Create output directories for the experimental.
            dim_dir_name = strcat(algo_dir_name,'/D',num2str(dim_size));

            if ~exist(dim_dir_name, 'dir')
                mkdir(dim_dir_name);
            end

            for func_no = all_func_no

                % Create output directories for the experimental.
                func_no_dir_name = strcat(dim_dir_name,'/F',num2str(func_no));

                if ~exist(func_no_dir_name, 'dir')
                    mkdir(func_no_dir_name);
                end

                % CEC17 F2 has been restored.
                Function_name = strcat('F',num2str(func_no));
                desired_dim = dim_size;

                % Load details of the selected benchmark function
                switch brenchmark_name
                    case 'CEC2005'
                        [lb,ub,dim,fobj]=Get_Functions_details(Function_name,desired_dim);
                    case 'CEC2013'
                        [lb,ub,dim,fobj]=CEC2013_Function(Function_name,desired_dim);
                    case 'CEC2014'
                        [lb,ub,dim,fobj]=CEC2014_Function(Function_name,desired_dim);
                    case 'CEC2017'
                        [lb,ub,dim,fobj]=CEC2017_Function(Function_name,desired_dim);
                end

                lb = lb .* ones(1,dim); % Lower bound
                ub = ub .* ones(1,dim); % Upper bound

                SearchAgents_no = 30;
                Max_iteration = 10000 * dim;

                % Cost Function
                funj = @(x) CostFunction(x, fobj);

                if desired_dim ~= dim
                    fprintf('The operating dimension is set to be %d\n',dim);
                end

                watchRunAll = tic; % Elapsed time for all run.

                parfor run = 1:52

                    watchRun = tic; % Elapsed time for each run.

                    try
                        [best_score(run,:),best_pos(run,:),cg_curve(run,:),~,~] = feval(algo_name,SearchAgents_no,Max_iteration,lb,ub,dim,funj);
                    catch
                        [best_score(run,:),best_pos(run,:),cg_curve(run,:)] = feval(algo_name,SearchAgents_no,Max_iteration,lb,ub,dim,funj);
                    end


                    elapsedRun = toc(watchRun);
                    elapsed_time_run(run,:) = elapsedRun; % Elapsed time for each run.
                end

                fprintf(strcat('✔\t',brenchmark_name,':\t',algo_name,' F',num2str(func_no),' D',num2str(dim_size),'\n'));
                fprintf('Average best score: %e \nMedian: %e \nStd: %e\n\n',mean(best_score(:,1)),median(best_score(:,1)),std(best_score(:,1)));

                elapsedRunAll = toc(watchRunAll); % Elapsed time for all run.

                % Save to file.
                filename = strcat(func_no_dir_name,'/collected_data.mat');
                save(filename,'best_score','best_pos','cg_curve');

                filename = strcat(func_no_dir_name,'/run_elapsed_time.mat');
                save(filename,'elapsed_time_run');

                filename = strcat(func_no_dir_name,'/overall_elapsed_time.mat');
                save(filename,'elapsedRunAll');

                filename = strcat(func_no_dir_name,'/experiment_settings.mat');
                save(filename,'SearchAgents_no','Max_iteration','brenchmark_name','dim_size','func_no','algo_name');

                filename = strcat(func_no_dir_name,'/integrity_identifiers.mat');
                save(filename,'func_no_dir_name');

                clear best_score best_pos cg_curve elapsed_time_run cul_solution cul_nfe record_data;
            end
        end

        fprintf(strcat('\n'));

    end

    %     end % max_itr loop
    % end %agent_no loop
end

selected_score_algo = [1,2,3,4,5,6];

primary_highlight_algo = [];
secondary_highlight_algo = [];

if scoring
    Scoring(all_algo,selected_score_algo,selected_problem,all_dim_size,brenchmark_name,primary_highlight_algo,secondary_highlight_algo);
end

disp('----- Done -----');

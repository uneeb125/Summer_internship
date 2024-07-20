
% =============================================================================================================================================================================
% Differentiated Creative Search (DCS)

% CITATION:
% Duankhan P., Sunat K., Chiewchanwattana S., and Nasa-ngium P. "The Differentiated Creative Search (DCS): Leveraging Differentiated Knowledge-acquisition and Creative Realism
% to Address Complex Optimization Problems". (Accepted for publication in Expert Systems with Applications)
% =============================================================================================================================================================================

function Scoring(all_algo,sel_algo,sel_prob,sel_dim,brenchmark_name,highlights_algo,highlights_algo2)

format shortE;

selected_algo = sel_algo;
all_func_no = sel_prob;
all_dim_size = sel_dim;

eval_trigger = [1]; % Option for analysis (Score)

selected_highlight = highlights_algo;
secondary_selected_highlight = highlights_algo2;

selectedExperiment = strcat('test_');

% ===================== Score Calculation ==============================

if(eval_trigger(1,1))

    f_star = [100:100:3000];

    fprintf(strcat('Experimental results:\n'));

    % --------------- Load experiment data ---------------
    for dim_size = all_dim_size  % Dimensions

        % Construct table and label
        table_header_desc_itr = 1;

        if dim_size == 10
            d10_score_data(1,table_header_desc_itr) = "algorithm_name";
        elseif dim_size == 30
            d30_score_data(1,table_header_desc_itr) = "algorithm_name";
        elseif dim_size == 50
            d50_score_data(1,table_header_desc_itr) = "algorithm_name";
        elseif dim_size == 100
            d100_score_data(1,table_header_desc_itr) = "algorithm_name";
        end

        for func_no = all_func_no % CEC Funtion No.

            fprintf(strcat('|'));

            % Construct table and label
            table_header_desc_itr = table_header_desc_itr + 1;

            if dim_size == 10
                d10_score_data(1,table_header_desc_itr) = strcat('F',num2str(func_no),'_D',num2str(dim_size));
            elseif dim_size == 30
                d30_score_data(1,table_header_desc_itr) = strcat('F',num2str(func_no),'_D',num2str(dim_size));
            elseif dim_size == 50
                d50_score_data(1,table_header_desc_itr) = strcat('F',num2str(func_no),'_D',num2str(dim_size));
            elseif dim_size == 100
                d100_score_data(1,table_header_desc_itr) = strcat('F',num2str(func_no),'_D',num2str(dim_size));
            end

            algo_desc_itr = 2;

            for algo_idx = selected_algo  % Algorithms

                algo_name = string(all_algo(algo_idx));

                % Load data from file.
                algo_dir_name = strcat('./results/',brenchmark_name,'/',selectedExperiment,'/',algo_name,'/D',num2str(dim_size),'/F',num2str(func_no),'/collected_data.mat');
                load(algo_dir_name,'best_score');

                fprintf(strcat('✔ ',brenchmark_name,': ',algo_name,' F',num2str(func_no),' D',num2str(dim_size),'\t'));
                fprintf('Average best score: %e | Median: %e | Std: %e\n',mean(best_score(:,1)),median(best_score(:,1)),std(best_score(:,1)));

                if dim_size == 10
                    d10_score_data(algo_desc_itr,1) = algo_name;
                    d10_score_data(algo_desc_itr,table_header_desc_itr) = mean(best_score(:,1) - f_star(func_no)); %mean(best_score(:,1));% - f_star(func_no);
                elseif dim_size == 30
                    d30_score_data(algo_desc_itr,1) = algo_name;
                    d30_score_data(algo_desc_itr,table_header_desc_itr) = mean(best_score(:,1) - f_star(func_no)); %mean(best_score(:,1));% - f_star(func_no);
                elseif dim_size == 50
                    d50_score_data(algo_desc_itr,1) = algo_name;
                    d50_score_data(algo_desc_itr,table_header_desc_itr) = mean(best_score(:,1) - f_star(func_no)); %mean(best_score(:,1));% - f_star(func_no);
                elseif dim_size == 100
                    d100_score_data(algo_desc_itr,1) = algo_name;
                    d100_score_data(algo_desc_itr,table_header_desc_itr) = mean(best_score(:,1) - f_star(func_no)); %mean(best_score(:,1));% - f_star(func_no);
                end

                algo_desc_itr = algo_desc_itr + 1;

                clear best_score;

            end

            
            %  Write to files (For analysis)
            if dim_size == 10
                algoname_tmp = d10_score_data(2:end,1);
                data_tmp = d10_score_data(2:end,table_header_desc_itr);
                [sortedResult,sortedIdx] = sort(str2double(data_tmp),'ascend');
                %writematrix([algoname_tmp(sortedIdx,1) sortedResult(:,1)],strcat('Analysis\D',num2str(dim_size),'_result.xlsx'),'Sheet',func_no)
            elseif dim_size == 30
                algoname_tmp = d30_score_data(2:end,1);
                data_tmp = d30_score_data(2:end,table_header_desc_itr);
                [sortedResult,sortedIdx] = sort(str2double(data_tmp),'ascend');
                %writematrix([algoname_tmp(sortedIdx,1) sortedResult(:,1)],strcat('Analysis\D',num2str(dim_size),'_result.xlsx'),'Sheet',func_no)
            elseif dim_size == 50
                algoname_tmp = d50_score_data(2:end,1);
                data_tmp = d50_score_data(2:end,table_header_desc_itr);
                [sortedResult,sortedIdx] = sort(str2double(data_tmp),'ascend');
                %writematrix([algoname_tmp(sortedIdx,1) sortedResult(:,1)],strcat('Analysis\D',num2str(dim_size),'_result.xlsx'),'Sheet',func_no)
            elseif dim_size == 100
                algoname_tmp = d100_score_data(2:end,1);
                data_tmp = d100_score_data(2:end,table_header_desc_itr);
                [sortedResult,sortedIdx] = sort(str2double(data_tmp),'ascend');
                %writematrix([algoname_tmp(sortedIdx,1) sortedResult(:,1)],strcat('Analysis\D',num2str(dim_size),'_result.xlsx'),'Sheet',func_no)
            end

        end

        fprintf('\n');

        fprintf('\t✔ Completed\n');
    end

    % //////////////////////// SCORE 1 //////////////////////////////////

    % --------------- Sum error for each dimension ---------------
    % Construct table and label
    table_header_desc_itr = 1;
    sum_score_data(1,table_header_desc_itr) = "algorithm_name";

    for dim_size = all_dim_size  % Dimensions

        % Construct table and label
        table_header_desc_itr = table_header_desc_itr + 1;
        sum_score_data(1,table_header_desc_itr) = strcat('SUM_D',num2str(dim_size));

        algo_desc_itr = 2;

        for algo_idx = selected_algo  % Algorithms

            algo_name = string(all_algo(algo_idx));

            sum_score_data(algo_desc_itr,1) = algo_name;

            if dim_size == 10
                sum_score_data(algo_desc_itr,table_header_desc_itr) = sum(str2double(d10_score_data(algo_desc_itr,2:end)));
            elseif dim_size == 30
                sum_score_data(algo_desc_itr,table_header_desc_itr) = sum(str2double(d30_score_data(algo_desc_itr,2:end)));
            elseif dim_size == 50
                sum_score_data(algo_desc_itr,table_header_desc_itr) = sum(str2double(d50_score_data(algo_desc_itr,2:end)));
            elseif dim_size == 100
                sum_score_data(algo_desc_itr,table_header_desc_itr) = sum(str2double(d100_score_data(algo_desc_itr,2:end)));
            end

            algo_desc_itr = algo_desc_itr + 1;

        end
    end

    % --------------- SE Calculation ---------------
    % Construct table and label
    table_header_desc_itr = 1;
    se_data(1,table_header_desc_itr) = "algorithm_name";

    % Construct table and label
    table_header_desc_itr = table_header_desc_itr + 1;
    se_data(1,table_header_desc_itr) = strcat('SE');

    algo_desc_itr = 2;

    for algo_idx = selected_algo  % Algorithms

        algo_name = string(all_algo(algo_idx));

        se_data(algo_desc_itr,1) = algo_name;

        if size(all_dim_size,2) == 4
            se_data(algo_desc_itr,2) = (0.1 * str2double(sum_score_data(algo_desc_itr,2)))...
                + (0.2 * str2double(sum_score_data(algo_desc_itr,3)))...
                + (0.3 * str2double(sum_score_data(algo_desc_itr,4)))...
                + (0.4 * str2double(sum_score_data(algo_desc_itr,5)));
        elseif size(all_dim_size,2) == 1
            se_data(algo_desc_itr,2) = (1 * str2double(sum_score_data(algo_desc_itr,2)));
        end


        algo_desc_itr = algo_desc_itr + 1;

    end

    % --------------- Score1 Calculation ---------------
    [SE_min,~] = min(str2double(se_data(2:end,2)));

    % Construct table and label
    table_header_desc_itr = 1;
    score1_data(1,table_header_desc_itr) = "algorithm_name";

    % Construct table and label
    table_header_desc_itr = table_header_desc_itr + 1;
    score1_data(1,table_header_desc_itr) = strcat('score1');

    algo_desc_itr = 2;

    for algo_idx = selected_algo  % Algorithms

        algo_name = string(all_algo(algo_idx));

        score1_data(algo_desc_itr,1) = algo_name;

        if str2double(se_data(algo_desc_itr,2)) > 0
            score1_data(algo_desc_itr,2) = (1.0 - ((str2double(se_data(algo_desc_itr,2)) - SE_min) / str2double(se_data(algo_desc_itr,2)))) * 50;
        else
            score1_data(algo_desc_itr,2) = (1.0 - 0) * 50; % Divide by zero avoidance
        end

        algo_desc_itr = algo_desc_itr + 1;

    end


    % //////////////////////// SCORE 2 //////////////////////////////////

    % --------------- Rank adjusted for ties ---------------
    for dim_size = all_dim_size  % Dimensions

        % Construct table and label
        table_header_desc_itr = 1;

        if dim_size == 10
            d10_rank_data(1,table_header_desc_itr) = "algorithm_name";
        elseif dim_size == 30
            d30_rank_data(1,table_header_desc_itr) = "algorithm_name";
        elseif dim_size == 50
            d50_rank_data(1,table_header_desc_itr) = "algorithm_name";
        elseif dim_size == 100
            d100_rank_data(1,table_header_desc_itr) = "algorithm_name";
        end

        for func_no = all_func_no % CEC Funtion No.

            % Assign algorithm's name
            algo_desc_itr = 2;

            for algo_idx = selected_algo  % Algorithms

                algo_name = string(all_algo(algo_idx));

                if dim_size == 10
                    d10_rank_data(algo_desc_itr,1) = algo_name;
                elseif dim_size == 30
                    d30_rank_data(algo_desc_itr,1) = algo_name;
                elseif dim_size == 50
                    d50_rank_data(algo_desc_itr,1) = algo_name;
                elseif dim_size == 100
                    d100_rank_data(algo_desc_itr,1) = algo_name;
                end

                algo_desc_itr = algo_desc_itr + 1;

            end

            % Assign rank
            table_header_desc_itr = table_header_desc_itr + 1;

            if dim_size == 10
                d10_rank_data(1,table_header_desc_itr) = strcat('F',num2str(func_no),'_D',num2str(dim_size));

                % Ranking
                ranking_x = tiedrank(str2double(d10_score_data(2:end,table_header_desc_itr)),1);
                d10_rank_data(2:end,table_header_desc_itr) = ranking_x(:,1);

            elseif dim_size == 30
                d30_rank_data(1,table_header_desc_itr) = strcat('F',num2str(func_no),'_D',num2str(dim_size));

                % Ranking
                ranking_x = tiedrank(str2double(d30_score_data(2:end,table_header_desc_itr)),1);
                d30_rank_data(2:end,table_header_desc_itr) = ranking_x(:,1);

            elseif dim_size == 50
                d50_rank_data(1,table_header_desc_itr) = strcat('F',num2str(func_no),'_D',num2str(dim_size));

                % Ranking
                ranking_x = tiedrank(str2double(d50_score_data(2:end,table_header_desc_itr)),1);
                d50_rank_data(2:end,table_header_desc_itr) = ranking_x(:,1);

            elseif dim_size == 100
                d100_rank_data(1,table_header_desc_itr) = strcat('F',num2str(func_no),'_D',num2str(dim_size));

                % Ranking
                ranking_x = tiedrank(str2double(d100_score_data(2:end,table_header_desc_itr)),1);
                d100_rank_data(2:end,table_header_desc_itr) = ranking_x(:,1);
            end

        end
    end

    % --------------- Sum rank for each dimension ---------------
    % Construct table and label
    table_header_desc_itr = 1;
    sum_rank_data(1,table_header_desc_itr) = "algorithm_name";

    for dim_size = all_dim_size  % Dimensions

        % Construct table and label
        table_header_desc_itr = table_header_desc_itr + 1;
        sum_rank_data(1,table_header_desc_itr) = strcat('SUM_D',num2str(dim_size));

        algo_desc_itr = 2;

        for algo_idx = selected_algo  % Algorithms

            algo_name = string(all_algo(algo_idx));

            sum_rank_data(algo_desc_itr,1) = algo_name;

            if dim_size == 10
                sum_rank_data(algo_desc_itr,table_header_desc_itr) = sum(str2double(d10_rank_data(algo_desc_itr,2:end)));
            elseif dim_size == 30
                sum_rank_data(algo_desc_itr,table_header_desc_itr) = sum(str2double(d30_rank_data(algo_desc_itr,2:end)));
            elseif dim_size == 50
                sum_rank_data(algo_desc_itr,table_header_desc_itr) = sum(str2double(d50_rank_data(algo_desc_itr,2:end)));
            elseif dim_size == 100
                sum_rank_data(algo_desc_itr,table_header_desc_itr) = sum(str2double(d100_rank_data(algo_desc_itr,2:end)));
            end

            algo_desc_itr = algo_desc_itr + 1;

        end
    end

    % --------------- SR Calculation ---------------
    % Construct table and label
    table_header_desc_itr = 1;
    sr_data(1,table_header_desc_itr) = "algorithm_name";

    % Construct table and label
    table_header_desc_itr = table_header_desc_itr + 1;
    sr_data(1,table_header_desc_itr) = strcat('SR');

    algo_desc_itr = 2;

    for algo_idx = selected_algo  % Algorithms

        algo_name = string(all_algo(algo_idx));

        sr_data(algo_desc_itr,1) = algo_name;

        if size(all_dim_size,2) == 4
            sr_data(algo_desc_itr,2) = (0.1 * str2double(sum_rank_data(algo_desc_itr,2)))...
                + (0.2 * str2double(sum_rank_data(algo_desc_itr,3)))...
                + (0.3 * str2double(sum_rank_data(algo_desc_itr,4)))...
                + (0.4 * str2double(sum_rank_data(algo_desc_itr,5)));
        elseif size(all_dim_size,2) == 1
            sr_data(algo_desc_itr,2) = (1 * str2double(sum_rank_data(algo_desc_itr,2)));
        end

        algo_desc_itr = algo_desc_itr + 1;

    end

    % --------------- Score2 Calculation ---------------
    [SR_min,~] = min(str2double(sr_data(2:end,2)));

    % Construct table and label
    table_header_desc_itr = 1;
    score2_data(1,table_header_desc_itr) = "algorithm_name";

    % Construct table and label
    table_header_desc_itr = table_header_desc_itr + 1;
    score2_data(1,table_header_desc_itr) = strcat('score2');

    algo_desc_itr = 2;

    for algo_idx = selected_algo  % Algorithms

        algo_name = string(all_algo(algo_idx));

        score2_data(algo_desc_itr,1) = algo_name;

        if str2double(sr_data(algo_desc_itr,2)) > 0
            score2_data(algo_desc_itr,2) = (1.0 - ((str2double(sr_data(algo_desc_itr,2)) - SR_min) / str2double(sr_data(algo_desc_itr,2)))) * 50;
        else
            score2_data(algo_desc_itr,2) = (1.0 - 0) * 50; % Divide by zero avoidance
        end

        algo_desc_itr = algo_desc_itr + 1;

    end

    % //////////////////////// DISPLAY //////////////////////////////////

    if exist('score1_data','var') && exist('score2_data','var')

        for i = 1:size(score2_data,1)-1
            score_eval_summary(i,1) = score2_data(i+1,1);
            score_eval_summary(i,2) = score1_data(i+1,2);
            score_eval_summary(i,3) = score2_data(i+1,2);
            score_eval_summary(i,4) = str2double(score1_data(i+1,2)) + str2double(score2_data(i+1,2));
        end

        [~,sorted_idx] = sort(str2double(score_eval_summary(:,4)),'descend');

        for i = 1:size(sorted_idx,1)
            final_score_eval_summary(i,:) = score_eval_summary(sorted_idx(i),:);
        end

        % Show the result
        fprintf(strcat('Score 1\t       | Score 2     | Overall score    | No | Algoithm\n'));
        fprintf(strcat('-----------------------------------------------------------------------\n'));

        report_data(1,1) = "Algorithms";
        report_data(1,2) = "Score1";
        report_data(1,3) = "Score2";
        report_data(1,4) = "Sum";

        for i = 1:size(final_score_eval_summary,1)

            fprintf('%.2f\t\t',final_score_eval_summary(i,2));
            fprintf('%.2f\t\t',final_score_eval_summary(i,3));
            fprintf('%.2f\t\t',final_score_eval_summary(i,4));
            fprintf('%d.\t%s\t\t',i,final_score_eval_summary(i,1));
            fprintf(strcat('\n'));

            report_data(i+1,1) = string(final_score_eval_summary(i,1));
            report_data(i+1,2) = sprintf('%.5f',final_score_eval_summary(i,2));
            report_data(i+1,3) = sprintf('%.5f',final_score_eval_summary(i,3));
            report_data(i+1,4) = sprintf('%.5f',final_score_eval_summary(i,4));

        end

        % writematrix(report_data,'score_summary.xlsx')

    else
        fprintf('Feasible solution not found!\n');
    end

    fprintf(strcat('-----------------------------------------------------------------------\n\n'));


end



end
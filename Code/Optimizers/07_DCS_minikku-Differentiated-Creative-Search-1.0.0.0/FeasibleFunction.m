
% =============================================================================================================================================================================
% Differentiated Creative Search (DCS)

% CITATION:
% Duankhan P., Sunat K., Chiewchanwattana S., and Nasa-ngium P. "The Differentiated Creative Search (DCS): Leveraging Differentiated Knowledge-acquisition and Creative Realism
% to Address Complex Optimization Problems". (Accepted for publication in Expert Systems with Applications)
% =============================================================================================================================================================================

function [feasible_solution] = FeasibleFunction(input_solution, problem_options)

row_dim = size(input_solution,1);
col_dim = size(input_solution,2);

% If the solution is column vector then convert it to row vector
if col_dim < row_dim
    x_input_solution = input_solution';
else
    x_input_solution = input_solution;
end

% Store the input solution
tmp_feasible_solution(1,:) = x_input_solution(1,:);

% Make sure the solution is an integer between the allowable values
for j = 1:problem_options.nD
    tmp_feasible_solution(1,j) = max(tmp_feasible_solution(1,j), problem_options.lb(j));
    tmp_feasible_solution(1,j) = min(tmp_feasible_solution(1,j), problem_options.ub(j));
end

% Return the feasible solution
feasible_solution = tmp_feasible_solution(1,1:problem_options.nD);

end

stat = ['bests'; 'worsts'; 'means'; 'stdevs'];


for i = 1:4
    inputfile = strcat(stat(i,:),'.csv');
    data = csvread(inputfile);

    % Perform the Friedman test
    [p, tbl, stats] = friedman(data',1,'off');

    rank = (tiedrank(stats.meanranks))';
    outputfile = strcat(stat(i,:),'_ranked.csv');
    csvwrite(outputfile,rank);
end
% % Display the p-value
% disp(['p-value: ', num2str(p)])
%
% % Post-hoc analysis (Nemenyi test for pairwise comparisons)
% c = multcompare(stats, 'CType', 'dunn-sidak');
% disp(c)

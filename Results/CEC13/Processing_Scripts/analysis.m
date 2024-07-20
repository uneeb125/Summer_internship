dataMatrix = csvread('../Processed/bests_t.csv');

[p, tbl, stats] = friedman(dataMatrix); 

disp(['p-value: ', num2str(p)])


if p < 0.05
    result = multcompare(stats, 'ctype', 'hsd'); 
    disp('Multiple Comparisons Result:');
    disp(result);

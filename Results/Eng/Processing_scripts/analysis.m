stat = ['bests'; 'worsts'; 'means'; 'stdevs'];

processed_basedir = fullfile('..','Processed');

for i = 1:4
    inputfile = strcat(stat(i,:),'.csv');
    inputpath = fullfile(processed_basedir,inputfile);
    data = csvread(inputpath);

    % Perform the Friedman test
    [p, tbl, stats] = friedman(data',1,'off');

    rank = (tiedrank(stats.meanranks))';
    outputfile = strcat(stat(i,:),'_ranked.csv');
    outputpath = fullfile(processed_basedir,outputfile);
    csvwrite(outputpath,rank);
end
% % Display the p-value
% disp(['p-value: ', num2str(p)])
%
% % Post-hoc analysis (Nemenyi test for pairwise comparisons)
% c = multcompare(stats, 'CType', 'dunn-sidak');
% disp(c)

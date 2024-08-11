clc;
clear;

runsnumber  = 25;
probsnumber = 24;

merged_basedir = fullfile('..','Merged');
processed_basedir = fullfile('..','Processed');

probset = 'cec06';

algo = ['CO'; 'WGA'; 'BWO'; 'BSLO'; 'GAO'; 'GOA'; 'DCS'; 'MPA'; 'AHA'; 'AO'; 'WSO'; 'SNS'];

typef = ['fit'; 'nfe'];

sep = '_';

finalfit = zeros(runsnumber,probsnumber);
finalnfe = zeros(runsnumber,probsnumber);

for algonum = 1:size(algo,1)
    importfile = strcat(probset,sep,algo(algonum,:),sep,typef(1,:),'.csv'); 
    importpath = fullfile(merged_basedir,importfile);
    temp = csvread(importpath);
    % data(:,:,algonum) = temp;
    % means(algonum,:) = mean(data(:,:,algonum))
    means(algonum,:) = real(mean(temp));
    stdevs(algonum,:) = real(std(temp));
    bests(algonum,:) = real(min(temp));
    worsts(algonum,:) = real(max(temp));
end

csvwrite(fullfile(processed_basedir,'means.csv'),means); 
csvwrite(fullfile(processed_basedir,'stdevs.csv'),stdevs); 
csvwrite(fullfile(processed_basedir,'bests.csv'),bests); 
csvwrite(fullfile(processed_basedir,'worsts.csv'),worsts); 


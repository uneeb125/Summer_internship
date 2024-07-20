clc;
clear;

runsnumber  = 30;
probsnumber = 15;

probset = 'cec13';

algo = ['CO'; 'WGA'; 'BWO'; 'BSLO'; 'GAO'; 'GOA'; 'DCS'; 'MPA'; 'AHA'; 'AO'; 'WSO'; 'SNS'];

typef = ['fit'; 'nfe'];

sep = '_';

finalfit = zeros(runsnumber,probsnumber);
finalnfe = zeros(runsnumber,probsnumber);

for algonum = 1:size(algo,1)
    importfile = strcat(probset,sep,algo(algonum,:),sep,typef(1,:),'.csv'); 
    temp = csvread(importfile);
    % data(:,:,algonum) = temp;
    % means(algonum,:) = mean(data(:,:,algonum))
    means(algonum,:) = mean(temp);
    stdevs(algonum,:) = std(temp);
    bests(algonum,:) = min(temp);
    worsts(algonum,:) = max(temp);
end

csvwrite('means.csv',means); 
csvwrite('stdevs.csv',stdevs); 
csvwrite('bests.csv',bests); 
csvwrite('worsts.csv',worsts); 


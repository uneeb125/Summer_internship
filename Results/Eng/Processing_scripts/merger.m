clc;
clear;

runsnumber  = 30;
probsnumber = 13;

raw_basedir = fullfile('..','Raw_data');
merged_basedir = fullfile('..','Merged');

probset = 'eng';

% algo = ['CO'; 'WGA'; 'BWO'; 'BSLO'; 'GAO'; 'GOA'; 'DCS'; 'MPA'; 'AHA'; 'AO'; 'WSO'; 'SNS'];
algo = ['CO'; 'WGA'; 'BWO'; 'BSLO'; 'GAO'; 'GOA'; 'DCS'; 'MPA'; 'AHA'; 'WSO'; 'SNS'];


typef = ['fit'; 'nfe'];

sep = '_';

finalfit = zeros(runsnumber,probsnumber);
finalnfe = zeros(runsnumber,probsnumber);

for algonum = 1:size(algo,1)
    for prob = 1:probsnumber
        csvname = strcat(raw_basedir,probset,sep,algo(algonum,:),sep,typef(1,:),sep,num2str(prob),'.csv'); 
        csvpath = fullfile(raw_basedir,csvname);
        temp = csvread(csvpath);
        finalfit(:,prob) = temp(:,prob);
        csvname = strcat(raw_basedir,probset,sep,algo(algonum,:),sep,typef(2,:),sep,num2str(prob),'.csv'); 
        csvpath = fullfile(raw_basedir,csvname);
        temp = csvread(csvpath);
        finalnfe(:,prob) = temp(:,prob);
    end
finalfitname = strcat(merged_basedir,probset,sep,algo(algonum,:),sep,typef(1,:),'.csv'); 
csvwrite(fullfile(merged_basedir,finalfitname),finalfit);
finalnfename = strcat(merged_basedir,probset,sep,algo(algonum,:),sep,typef(2,:),'.csv'); 
csvwrite(fullfile(merged_basedir,finalnfename),finalnfe);
end


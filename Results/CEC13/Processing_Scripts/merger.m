runsnumber  = 25;
probsnumber = 15;

probset = 'cec13';

algo = ['CO'; 'WGA'; 'BWO'; 'BSLO'; 'GAO'; 'GOA'; 'DCS'; 'MPA'; 'AHA'; 'AO'; 'WSO'; 'SNS'];
% algo = ['CO'; 'WGA'; 'BWO'; 'BSLO'; 'GAO'; 'GOA'; 'DCS'; 'MPA'; 'AHA'; 'WSO'; 'SNS'];

typef = ['fit'; 'nfe'];

sep = '_';

finalfit = zeros(runsnumber,probsnumber);
finalnfe = zeros(runsnumber,probsnumber);

for algonum = 1:size(algo,1)
    for prob = 1:probsnumber
        csvname = strcat(probset,sep,algo(algonum,:),sep,typef(1,:),sep,num2str(prob),'.csv'); 
        temp = csvread(csvname);
        finalfit(:,prob) = temp(:,prob);
        csvname = strcat(probset,sep,algo(algonum,:),sep,typef(2,:),sep,num2str(prob),'.csv'); 
        temp = csvread(csvname);
        finalnfe(:,prob) = temp(:,prob);
    end
finalfitname = strcat('./merged/',probset,sep,algo(algonum,:),sep,typef(1,:),'.csv'); 
csvwrite(finalfitname,finalfit);
finalnfename = strcat('./merged/',probset,sep,algo(algonum,:),sep,typef(2,:),'.csv'); 
csvwrite(finalnfename,finalnfe);
end


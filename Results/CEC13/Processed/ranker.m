input = csvread('means_t.csv');


for prob = 1:size(input,1)
    ranked(prob,:) = tiedrank(input(prob,:));
end

csvwrite('means_r.csv',ranked);

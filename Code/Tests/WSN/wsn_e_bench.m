function Cost = wsn_e_bench(nodes,Rsensor,Area,vio)
% AUB = A+B - intesect(A,B)
xIndex = 1:2:length(nodes);
yIndex = 2:2:length(nodes);

sumCircles = my_union(nodes, Rsensor);

Coverage = (sumCircles/Area);
Energy = minEnergyNetwork(nodes);

if Coverage<1
    CoveragePenalty = vio;
else
    CoveragePenalty = 0;
end

Cost = Energy + CoveragePenalty;

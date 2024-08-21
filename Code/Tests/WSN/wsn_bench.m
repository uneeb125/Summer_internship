function Coverage = wsn_bench( nodes, Rsensor, Area )

% AUB = A+B - intesect(A,B)

xIndex = 1:2:length(nodes);
yIndex = 2:2:length(nodes);

sumCircles = my_union(nodes, Rsensor);

Coverage = -(sumCircles/Area);




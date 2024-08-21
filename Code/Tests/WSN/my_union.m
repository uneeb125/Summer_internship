function coveredarea = my_area(nodes,Rsensors)
nNodes = length(nodes)/2;
x = 1:2:nNodes*2;
y = x+1;
for i=1:nNodes 
    SensorArray(i) = nsidedpoly(1000,'Center',[nodes(x(i)) nodes(y(i))], 'Radius', Rsensors);
end

coveredarea = area(union(SensorArray));

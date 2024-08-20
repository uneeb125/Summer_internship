x = -1:1;
y = -1:1;
z = [x' y'];
global initial_flag;
initial_flag = 0;
for i=size(x)
    for j = size(y)
        [f(i,j)] = minEnergyRouting(2,[x(i) y(j)]);
    end
end
surf(x,y,f');
% surfc(x,y,g');
% surfc(x,y,h');

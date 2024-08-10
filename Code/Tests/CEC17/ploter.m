x = -1000:1000;
y = -1000:1000;
z = [x' y'];
global initial_flag;
initial_flag = 0;
for i=size(x)
    for j = size(y)
        [f(i,j) g(i,j) h(i,j)] = cec17_funcs([x(i) y(j)],1);
    end
end
surf(x,y,f');
% surfc(x,y,g');
% surfc(x,y,h');

for x = 1:20
    if (x<13)
        cec13_benchmark_func(rand([1 1000]),x);
    else 
        cec13_benchmark_func(rand([1 905]),x);
    end
end

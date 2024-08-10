function [lb, ub, nD] = cec06_params(fnum)

switch fnum

    case 1
        nD = 13;
        lb = zeros(1, nD);
        ub = zeros(1, nD);
        for i = 1:nD
            if i <= 9
                lb(i) = 0; ub(i) = 1;
            elseif i <= 12
                lb(i) = 0; ub(i) = 100;
            else
                lb(i) = 0; ub(i) = 1;
            end
        end

    case 2
        nD = 20;
        lb = zeros(1, nD);
        ub = zeros(1, nD);
        for i = 1:nD
                lb(i) = 0; ub(i) = 10;
        end

    case 3
        nD = 10;
        lb = zeros(1, nD);
        ub = zeros(1, nD);
        for i = 1:nD
            lb(i) = 0; ub(i) = 1;
        end

    case 4
        nD = 5;
        lb = zeros(1, nD);
        ub = zeros(1, nD);
        for i = 1:nD
            if i == 1
                lb(i) = 78; ub(i) = 102;
            elseif i == 2
                lb(i) = 33; ub(i) = 45;
            else
                lb(i) = 27; ub(i) = 45;
            end
        end

    case 5
        nD = 4;
        lb = zeros(1, nD);
        ub = zeros(1, nD);
        for i = 1:nD
            if i == 1 || i == 2
                lb(i) = 0; ub(i) = 1200;
            elseif i == 3 || i == 4
                lb(i) = -0.55; ub(i) = 0.55;
            end
        end

    case 6
        nD = 2;
        lb = zeros(1, nD);
        ub = zeros(1, nD);
        for i = 1:nD
            if i == 1
                lb(i) = 13; ub(i) = 100;
            else
                lb(i) = 0; ub(i) = 100;
            end
        end

    case 7
        nD = 10;
        lb = -10 * ones(1, nD);
        ub = 10 * ones(1, nD);

    case 8
        nD = 2;
        lb = -10 * ones(1, nD);
        ub = 10 * ones(1, nD);

    case 9
        nD = 7;
        lb = -10 * ones(1, nD);
        ub = 10 * ones(1, nD);

    case 10
        nD = 8;
        lb = zeros(1, nD);
        ub = zeros(1, nD);
        for i = 1:nD
            if i == 1
                lb(i) = 100; ub(i) = 10000;
            elseif i <= 3
                lb(i) = 1000; ub(i) = 10000;
            else
                lb(i) = 10; ub(i) = 1000;
            end
        end

    case 11
        nD = 2;
        lb = -1 * ones(1, nD);
        ub = 1 * ones(1, nD);

    case 12
        nD = 3;
        lb = zeros(1, nD);
        ub = 10 * ones(1, nD);

    case 13
        nD = 5;
        lb = zeros(1, nD);
        ub = zeros(1, nD);
        for i = 1:nD
            if i <= 2
                lb(i) = -2.3; ub(i) = 2.3;
            else
                lb(i) = -3.2; ub(i) = 3.2;
            end
        end

    case 14
        nD = 10;
        lb = zeros(1, nD);
        ub = 10 * ones(1, nD);

    case 15
        nD = 3;
        lb = zeros(1, nD);
        ub = 10 * ones(1, nD);

    case 16
        nD = 5;
        lb = zeros(1, nD);
        ub = zeros(1, nD);
        for i = 1:nD
            if i == 1
                lb(i) = 704.4148; ub(i) = 906.3855;
            elseif i == 2
                lb(i) = 68.6; ub(i) = 288.88;
            elseif i == 3
                lb(i) = 0; ub(i) = 134.75;
            elseif i == 4
                lb(i) = 193; ub(i) = 287.0966;
            elseif i == 5
                lb(i) = 25; ub(i) = 84.1988;
            end
        end

    case 17
        nD = 6;
        lb = zeros(1, nD);
        ub = zeros(1, nD);
        for i = 1:nD
            if i == 1
                lb(i) = 0; ub(i) = 400;
            elseif i == 2
                lb(i) = 0; ub(i) = 1000;
            elseif i == 3 || i == 4
                lb(i) = 340; ub(i) = 420;
            elseif i == 5
                lb(i) = -1000; ub(i) = 1000;
            elseif i == 6
                lb(i) = 0; ub(i) = 0.5236;
            end
        end

    case 18
        nD = 9;
        lb = zeros(1, nD);
        ub = zeros(1, nD);
        for i = 1:nD
            if i <= 8
                lb(i) = -10; ub(i) = 10;
            else
                lb(i) = 0; ub(i) = 20;
            end
        end

    case 19
        nD = 15;
        lb = zeros(1, nD);
        ub = 10 * ones(1, nD);

    case 20
        nD = 24;
        lb = zeros(1, nD);
        ub = 10 * ones(1, nD);

    case 21
        nD = 7;
        lb = zeros(1, nD);
        ub = zeros(1, nD);
        for i = 1:nD
            if i == 1
                lb(i) = 0; ub(i) = 1000;
            elseif i <= 3
                lb(i) = 0; ub(i) = 40;
            elseif i == 4
                lb(i) = 100; ub(i) = 300;
            elseif i == 5
                lb(i) = 6.3; ub(i) = 6.7;
            elseif i == 6
                lb(i) = 5.9; ub(i) = 6.4;
            elseif i == 7
                lb(i) = 4.5; ub(i) = 6.25;
            end
        end

    case 22
        nD = 22;
        lb = zeros(1, nD);
        ub = zeros(1, nD);
        for i = 1:nD
            if i == 1
                lb(i) = 0; ub(i) = 20000;
            elseif i <= 4
                lb(i) = 0; ub(i) = 1e6;
            elseif i <= 7
                lb(i) = 0; ub(i) = 4e7;
            elseif i == 8
                lb(i) = 100; ub(i) = 299.99;
            elseif i == 9
                lb(i) = 100; ub(i) = 399.99;
            elseif i == 10
                lb(i) = 100.01; ub(i) = 300;
            elseif i == 11
                lb(i) = 100; ub(i) = 400;
            elseif i == 12
                lb(i) = 100; ub(i) = 600;
            elseif i <= 15
                lb(i) = 0; ub(i) = 500;
            elseif i == 16
                lb(i) = 0.01; ub(i) = 300;
            elseif i == 17
                lb(i) = 0.01; ub(i) = 400;
            else
                lb(i) = -4.7; ub(i) = 6.25;
            end
        end

    case 23
        nD = 9;
        lb = zeros(1, nD);
        ub = zeros(1, nD);
        for i = 1:nD
            if i <= 2
                lb(i) = 0; ub(i) = 300;
            elseif i == 3
                lb(i) = 0; ub(i) = 100;
            elseif i == 4
                lb(i) = 0; ub(i) = 200;
            elseif i == 5
                lb(i) = 0; ub(i) = 100;
            elseif i == 6
                lb(i) = 0; ub(i) = 300;
            elseif i == 7
                lb(i) = 0; ub(i) = 100;
            elseif i == 8
                lb(i) = 0; ub(i) = 200;
            else
                lb(i) = 0.01; ub(i) = 0.03;
            end
        end

    case 24
        nD = 2;
        lb = zeros(1, nD);
        ub = zeros(1, nD);
        for i = 1:nD
            if i == 1
                lb(i) = 0; ub(i) = 3;
            else
                lb(i) = 0; ub(i) = 4;
            end
        end

end


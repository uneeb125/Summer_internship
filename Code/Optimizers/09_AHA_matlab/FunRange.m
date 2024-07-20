
function [down,up,dim]=FunRange(FunIndex)


    dim=30;

    switch FunIndex

        %Stepint
        case  1
            down=-5.12;up=5.12;dim=5;


            %Step
        case  2
            down=-100;up=100;


            %Sphere;
        case  3
            down=-100;up=100;


            %SumSquares
        case  4
            down=-10;up=10;


            %Quartic
        case  5
            down=-1.28;up=1.28;


            %QBeale
        case  6
            down=-4.5;up=4.5;dim=5;


            %Easom
        case  7
            down=-100;up=100;dim=2;


            %Matyas
        case  8
            down=-10;up=10;dim=2;


            %Colville
        case  9
            down=-10;up=10;dim=4;


            %Trid6
        case  10
            down=-6^2;up=6^2;dim=6;


            %Trid11
        case  11
            down=-10^2;up=10^2;dim=10;


            %Zakharov
        case  12
            down=-5;up=10;dim=10;


            %Powell
        case  13
            down=-4;up=5;dim=24;


            %Schwefel 2.22
        case  14
            down=-10;up=10;


            %Schwefel 1.2
        case  15
            down=-100;up=100;


            %Rosenbrock
        case  16
            down=-30;up=30;


            %Dixon-Price
        case  17
            down=-10;up=10;


            %Foxholes
        case  18
            down=-65.536;up=65.536;dim=2;


            %Branin minmum=0.397887
        case  19
            down=[-5 0];up=[10 15];dim=2;


            %Bohachevsky1
        case  20
            down=-100;up=100;dim=2;


            %Booth
        case  21
            down=-10;up=10;dim=2;


            %Rastrigin
        case  22
            down=-5.12;up=5.12;


            %Schwefel
        case  23
            down=-500;up=500;


            %Schwefel
        case  23
            down=-500;up=500;


            %Michalewicz2
        case  24
            down=0;up=pi;dim=2;


            %Michalewicz5
        case  25
            down=0;up=pi;dim=5;


            %Michalewicz10
        case  26
            down=0;up=pi;dim=10;


            %Schaffer
        case  27
            down=-100;up=100;dim=2;


            %Six Hump Camel
        case  28
            down=-5;up=5;dim=2;


            %Bohachevsky2
        case  29
            down=-100;up=100;dim=2;


            %Bohachevsky3
        case  30
            down=-100;up=100;dim=2;


            %Shubert
        case  31
            down=-10;up=10;dim=2;


            %GoldStein-Price
        case  32
            down=-2;up=2;dim=2;


            %Kowalik
        case  33
            down=-5;up=5;dim=4;


            %Shekel5
        case  34
            down=0;up=10;dim=4;


            %Shekel7
        case  35
            down=0;up=10;dim=4;


            %Shekel10
        case  36
            down=0;up=10;dim=4;


            %Perm
        case  37
            down=-4;up=4;dim=4;


            %PowerSum,
        case  38
            down=0;up=4;dim=4;


            %Hartman3,
        case  39
            down=0;up=1;dim=3;


            %Hartman6,
        case  40
            down=0;up=1;dim=6;


            %Griewank
        case  41
            down=-600;up=600;


            %Ackley
        case  42
            down=-32;up=32;


            %Penalized,,minmum=0;
        case  43
            down=-50;up=50;


            %Penalized2,minmum=0;
        case  44
            down=-50;up=50;


            %Langerman2
        case  45
            down=0;up=10;dim=2;


            %Langerman5
        case  46
            down=0;up=10;dim=5;


            %Langerman10
        case  47
            down=0;up=10;dim=10;


            %FletcherPowell2
        case  48
            down=-pi;up=pi;dim=2;


            %FletcherPowell5
        case  49
            down=-pi;up=pi;dim=5;


            %FletcherPowell10
        otherwise
            down=-pi;up=pi;dim=10;
    end
 


 
 
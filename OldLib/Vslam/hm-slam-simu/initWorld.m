% INITWORLD  Initialize world
switch world
    case 'planes01'

        [y,z] = meshgrid(-12:4:12,-12:4:12);
        x01 = ones(size(y));
        x03 = 03*x01;
        x10 = 10*x01;
        x50 = 50*x01;

        World = [x(:) y(:) z(:)]';

    case 'sparse01'
%         
        World = [
            1   2  3  4  5  6  8 10 12 15 18 20 25 30 35 40 50
            .2 .2  1  3 -1 -2  1  3  7 -5 -7  5 -1 11 -7 -5 0
            0  .1 -2  1 -4  3 -5  1  1 -3  3  8 -6  1 -2  6 0];
        
    case 'sparse02'

        World = [10 10 20;2 -3 6;2 1 6];
        
    case 'random'
        
        N = 40;
        
        World = 100+[...
            50*rand(1,N)
            -20+40*rand(1,N)
            -20+40*rand(1,N)];
         
end

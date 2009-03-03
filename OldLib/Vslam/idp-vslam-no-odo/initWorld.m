% INITWORLD  Initialize world
switch experim
    case 'planes01'

        [y,z] = meshgrid(-12:4:12,-12:4:12);
        x01 = ones(size(y));
        x03 = 03*x01;
        x10 = 10*x01;
        x50 = 50*x01;

        World = [x(:) y(:) z(:)]';

    case 'sparse01'
        
        World = [
             1  2  3  4  5  6  8 10 12 14 16 20 25 30 35 40 50
            .2 .2  1  2 -1 -2  1  2  6 -4 -8  6 -1 12 -7 -4 1
             0 .1 -2 -1  4 -3 -5 -1  1  3 -3 -6  0  1 -2  6 1];
         
end

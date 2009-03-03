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
            1   2  3  4  5  6  8 10 12 15 18 20 25 30 35 40 50
            .2 .2  1  3 -1 -2  1  3  7 -5 -7  5 -1 11 -7 -5 0
            0  .1 -2  1 -4  3 -5  1  1 -3  3  8 -6  1 -2  6 0];

%         World = World(:,end:-1:1);
         
end

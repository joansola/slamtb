function blockRange(r,mr)

global Map

switch Map.type
    case 'ekf'
        Map.used(r) = true;
    case 'graph'
        Map.used.x(r) = true;
        Map.used.m(mr) = true;
    otherwise
        error('Unknown Map type ''%s''.',Map.type)
end

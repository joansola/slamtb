function id = newId(idreset)

% NEWID  Id factory.
%   NEWID returns an increasing ID each time it is called. The first
%   created ID is 1.
%
%   NEWID(ID) resets the counter to the given ID and returns it. For
%   negative ID inputs, the counter is set to zero, and zero is returned.
%
%   Copyright 2015 Joan Sola @ IRI-CSIC-UPC

persistent ids;

if nargin == 1
    
    if idreset < 0
        ids = 0;
    else
        ids = idreset;
    end
    
else
    
    if isempty(ids)
        ids = 0;
    end
    
    ids = ids + 1;
    
end

id = ids;


function MapFig = updateMapFig(MapFig, Lmk)
    % MapFig is the figure of the map
    % Lmk is the array of landmark (it is a 1 dimension array)

    % for each landmark:
    for lmk = 1:numel(Lmk)
       switch (Lmk(lmk).type)
        
        % landmark types
        % --------------
        case {'idpPnt'}
           % TODO : print the landmark 
%            fprintf('[updateMapFig.m] Error, landmark type idpPnt not implemented \n') ;
        case {'eucPnt'}
           % TODO : print the landmark 
%            fprintf('[updateMapFig.m] Error, landmark type eucPnt not implemented \n') ;
        otherwise
            % TODO : print an error and go out
            error(['The landmark type is unknown, cannot display the landmark in map figure ( type: ',Lmk(lmkIndex).type,' unknown) !\n']);
       end
    end

    
    

end
 
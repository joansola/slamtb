
function MapFig = drawMapFig(MapFig, Lmk, Rob, Sen)
    % MapFig is the figure of the map
    % Lmk is the array of landmark (it is a 1 dimension array)

    % for each robot:
    for rob = 1:numel(Rob)
        
%         % Simulated - green
%         MapFig.simRob(rob) = patch(...
%             'parent',       MapFig.axes,...
%             'vertices',     Rob(rob).graphics.vert,...
%             'faces',        Rob(rob).graphics.faces,...
%             'facecolor',    'g',...
%             'visible',      'on');

        MapFig.simRob(rob) = drawObject(MapFig.simRob(rob),Rob(rob));

%         % Estimated - blue
%         MapFig.estRob(rob) = patch(...
%             'parent',       MapFig.axes,...
%             'vertices',     Rob(rob).graphics.vert,...
%             'faces',        Rob(rob).graphics.faces,...
%             'facecolor',    'b',...
%             'visible',      'on');

        MapFig.estRob(rob) = drawObject(MapFig.estRob(rob),Rob(rob));
    end
    
    % for each sensor
    for sen = 1:numel(Sen)
        % Simulated - green
%         MapFig.simSen(sen) = patch(...
%             'parent',       MapFig.axes,...
%             'vertices',     Sen(sen).graphics.vert,...
%             'faces',        Sen(sen).graphics.faces,...
%             'facecolor',    'g',...
%             'visible',      'on');

        R = Rob(Sen(sen).robot);
        F = composeFrames(R.frame,Sen(sen).frame);
        MapFig.simSen(sen) = drawObject(MapFig.simSen(sen),Sen(sen),F);

        % Estimated - blue
%         MapFig.estSen(sen) = patch(...
%             'parent',       MapFig.axes,...
%             'vertices',     Sen(sen).graphics.vert,...
%             'faces',        Sen(sen).graphics.faces,...
%             'facecolor',    'b',...
%             'visible',      'on');

        R = Rob(Sen(sen).robot);
        F = composeFrames(R.frame,Sen(sen).frame);
        MapFig.estSen(sen) = drawObject(MapFig.estSen(sen),Sen(sen),F);

    end
   
    
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
 
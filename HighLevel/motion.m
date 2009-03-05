


function Rob_i = motion(Rob_i, Control_i, dt)
   
    %% motion of the real robot:
    switch Rob_i.motion
        
        % const velocity
        case  {'constVel'}
            Rob_i.frame.x = Rob_i.frame.x+[dt*Control_i.v(1:3)', 0,0,0,0]' ;
       
            Rob_i.frame = updateFrame(Rob_i.frame);
            
         % other motion type:
%         case  {'constVel'}
%             Rob_i.frame.x = Rob_i.frame.x+[1,0.2,0, 0,0,0,0]' ;
        
        
        otherwise
            % TODO : print an error and go out
            error(['The robot motion type is unknown, cannot move the robot ',Rob_i.name,' with motion type:',Rob_i.motion,'!\n']);
    end
end



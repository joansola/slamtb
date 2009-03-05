


function Rob = motion(Rob, Con, dt)
   
    %% motion of the real robot:
    switch Rob.motion
        
        % const velocity
        case  {'constVel'}
            Rob.state.x = constVel(Rob.state.x,Con.u,dt);
       
            Rob.frame.x = Rob.state.x(1:7);
            Rob.vel.x   = Rob.state.x(8:13);
            Rob.frame   = updateFrame(Rob.frame);
            
         % other motion type:
%         case  {'constVel'}
%             Rob_i.frame.x = Rob_i.frame.x+[1,0.2,0, 0,0,0,0]' ;
        
        
        otherwise
            % TODO : print an error and go out
            error(['The robot motion type is unknown, cannot move the robot ',Rob_i.name,' with motion type:',Rob_i.motion,'!\n']);
    end
end



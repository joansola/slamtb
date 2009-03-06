function Rob = motion(Rob, Con, dt)



% motion model of the  robot:
switch Rob.motion

    % const velocity
    case  {'constVel'}
        Rob.state.x = constVel(Rob.state.x,Con.u,dt);

        Rob.frame.x = Rob.state.x(1:7);
        Rob.vel.x   = Rob.state.x(8:13);
        Rob.frame   = updateFrame(Rob.frame);

        % other motion type:
    case  {'odometry'}
        Rob.frame   = odo3(Rob.frame,Con.u);
        Rob.frame   = updateFrame(Rob.frame);


    otherwise
        % TODO : print an error and go out
        error(['The robot motion model is unknown, cannot move the robot ',Rob_i.name,' with motion type:',Rob_i.motion,'!']);
end




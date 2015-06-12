function Trj = createTrajectory(Rob, Opt)


% Trajectories, one per robot
for rob = [Rob.rob]
    
    Trj(rob).rob = rob;
    Trj(rob).head = 0;
    Trj(rob).tail = 1;
    Trj(rob).length = 0;
    Trj(rob).maxLength = Opt.map.numFrames;
    Trj(rob).frmIds = [];

end



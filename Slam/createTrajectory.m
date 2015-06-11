function Trj = createTrajectory(Rob, Opt)


% Trajectories, one per robot
for rob = [Rob.rob]
    
    Trj(rob).rob = rob;
    Trj(rob).head = 1;
    Trj(rob).tail = 1;
    Trj(rob).length = 0;
    Trj(rob).maxLangth = Opt.map.numFrames;
    Trj(rob).frmIds = [];

end



% Simultaneous localization and mapping.
%
% Map management
%   addToMap         - Add Gaussian to Map.
%   newRange         - New map range.
%   blockRange       - Block positions in Map.
%   usedRange        - Used map range.
%   freeSpace        - Check for free space in Map.
%   ranges           - Get ranges from structure array.
%   newLmk           - Get a new landmark.
%   smartDeleteLmk   - Smart deletion of landmarks.
%
% Time management
%   samplePeriod     - Sample period.
%
% Graph operations
%   addFrmToTrj      - Add frame to trajectory
%   addToGraph       - 
%   computeError     - Compute factor error.
%   createTrajectory - Trajectories, one per robot
%
% Other
%   fixNegIdp        - Fix negative inverse/depth parameter.
%   newId            - Id factory.

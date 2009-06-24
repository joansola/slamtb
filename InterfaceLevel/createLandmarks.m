function Lmk = createLandmarks(Opt)

% CREATELANDMARKS  Create Lmk structure array.
%   Lmk = CREATELANDMARKS(Landmark) creates the structure array Lmk() to be
%   used as SLAM data. The input Landmark{}  is a cell array of structures
%   as specified by the user in userData.m. There must be one Landmark{}
%   per each landmark type considered. See userData.m for details.

for lmk = 1:Opt.map.numLmks

    Lmk(lmk).lmk  = lmk;
    Lmk(lmk).id   = [];
    Lmk(lmk).type = '';
    Lmk(lmk).used = false;

    %         Lmk(lmk).state.size = [];
    Lmk(lmk).state.r = [];

    % Landmark descriptor or signature
    Lmk(lmk).sig = [];

    % other parameters out of the SLAM map
    Lmk(lmk).par = [];

    % Lmk management counters
    Lmk(lmk).nSearch = 0;  % number of times searched
    Lmk(lmk).nMatch  = 0;  % number of times matched
    Lmk(lmk).nInlier = 0;  % number of times declared inlier

end


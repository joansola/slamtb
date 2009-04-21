function Lmk = createLandmarks(EstOpt)

% CREATELANDMARKS  Create Lmk structure array.
%   Lmk = CREATELANDMARKS(Landmark) creates the structure array Lmk() to be
%   used as SLAM data. The input Landmark{}  is a cell array of structures
%   as specified by the user in userData.m. There must be one Landmark{}
%   per each landmark type considered. See userData.m for details.

for lmk = 1:EstOpt.map.num3dLmks

    Lmk(lmk).lmk  = lmk;
    Lmk(lmk).id   = [];
    Lmk(lmk).type = '';
    Lmk(lmk).used = false;

    %         Lmk(lmk).state.size = [];
    Lmk(lmk).state.r = [];

    %         % Non observable priors
    %         if isfield(Li,'nonObsMean')
    %             Lmk(lmk).nom.n = Li.nonObsMean;
    %             Lmk(lmk).nom.N = diag(Li.nonObsStd.^2);
    %         else
    %             Lmk(lmk).nom.n = [];
    %             Lmk(lmk).nom.N = [];
    %         end

    % other parameters
    Lmk(lmk).par = [];

    Lmk(lmk).sig = [];

    Lmk(lmk).nSearch = 0;
    Lmk(lmk).nMatch  = 0;
    Lmk(lmk).nInlier = 0;

end


function Ray = summarizeRay(Ray)

% SUMMARIZERAY  Summarize ray's projections results
%   RAY = SUMMARIZERAY(RAY) updates the fields in RAY that are a
%   combination of the same fields in RAY.Prj.
%   Use TYPE SUMMARIZERAY to get more details on which fields are
%   updated and how.
%
%   See also PROJECTRAY, SUMMARIZEPNT

Ray.vis0    = any ( [Ray.Prj.vis0   ] );
Ray.dUmax   = max ( [Ray.Prj.dUmax  ] );
% Ray.matched = any ( [Ray.Prj.matched] );
% Ray.updated = any ( [Ray.Prj.updated] );

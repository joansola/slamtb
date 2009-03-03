function Pnt = summarizePnt(Pnt)

% SUMMARIZEPNT  Summarize ray's projections results
%   PNT = SUMMARIZEPNT(PNT) updates the fields in PNT that are a
%   combination of the same fields in PNT.Prj.
%   Use TYPE SUMMARIZEPNT to get more details.
%
%   See also PROJECTPNT, SUMMARIZERAY

Pnt.vis0    = any ( [Pnt.Prj.vis] );
Pnt.dUmax   = max ( [Pnt.Prj.dU ] );
Pnt.s       = mean( [Pnt.Prj.s  ] );


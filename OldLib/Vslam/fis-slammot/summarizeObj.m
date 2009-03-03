function Obj = summarizeObj(Obj)

% SUMMARIZEOBJ  Summarize object's projections results
%   OBJ = SUMMARIZEOBJ(OBJ) updates the fields in OBJ that are a
%   combination of the same fields in OBJ.Prj.
%   Use TYPE SUMMARIZEOBJ to get more details.
%
%   See also PROJECTOBJ, SUMMARIZERAY

Obj.vis0    = any ( [Obj.Prj.vis] );
Obj.dUmax   = max ( [Obj.Prj.dU ] );
Obj.s       = mean( [Obj.Prj.s  ] );


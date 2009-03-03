function Idp = summarizeIdp(Idp)

% SUMMARIZEIDP  Summarize idp's projections results
%   IDP = SUMMARIZEIDP(IDP) updates the fields in IDP that are a
%   combination of the same fields in IDP.Prj.
%   Use TYPE SUMMARIZEIDP to get more details on which fields are
%   updated and how.
%
%   See also PROJECTIDP, SUMMARIZEPNT

Idp.vis0   = any ( [Idp.Prj.vis] );
Idp.dUmax  = max ( [Idp.Prj.dU] );
% Idp.matched = any ( [Idp.Prj.matched] );
% Idp.updated = any ( [Idp.Prj.updated] );

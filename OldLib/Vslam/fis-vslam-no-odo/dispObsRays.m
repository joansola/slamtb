


% observations
% obsRays = [Lmk.Ray(visRays).y];
matchedRays = find([Lmk.Ray.matched]);
obsRays = [Lmk.Ray(matchedRays).y];
if isempty(obsRays)
    obsRays = zeros(2,0);
end
set(dispObsRay,'xdata',obsRays(1,:),'ydata',obsRays(2,:));

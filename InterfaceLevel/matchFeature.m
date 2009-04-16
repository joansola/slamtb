function Obs = matchFeature(Raw,Obs)

% TODO: all the function and help.

% this is only a stupid function to produce true or false matches randomly
if randn < .5
    Obs.matched = false;
else
    Obs.matched = true;
end

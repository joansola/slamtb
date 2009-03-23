function Tim = createTime(Time)

% CREATETIME  Create Tim structure.
%   CREATETIME(Time) returns a structure with the fields
%       .dt             sampling time
%       .firstFrame     first frame to be processed
%       .lastFrame      last frame to be processed
%   from the fields in input structure Time.
%

Tim = Time;


function Tim = createTime(Time)

% CREATETIME  Create Tim structure.
%   CREATETIME returns a structure with the fields
%       .dt             sampling time
%       .firstFrame     first frame to be processed
%       .lastFrame      last frame ...
%   from the fields in input structure Time.
%

Tim = Time;

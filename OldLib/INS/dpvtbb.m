function [dp,dv,dt,dba,dbg] = dpvtbb(x)


dp  = x(1:3);
dv  = x(4:6);
dt  = x(7:9);
dba = x(10:12);
dbg = x(13:15);


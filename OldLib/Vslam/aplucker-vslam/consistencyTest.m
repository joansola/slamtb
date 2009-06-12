Ntest = 50;
nLog = zeros(Ntest,140);

for ntest = 1:Ntest
    
    save neesfile ntest nLog Ntest
    pluckerSlam;
    load neesfile ntest nLog Ntest
    nLog(ntest,:) = Log.nees;
    
end

sLog = sum(nLog,1)/Ntest;
save neesfile ntest nLog Ntest sLog
figure(4)
plot(sLog)

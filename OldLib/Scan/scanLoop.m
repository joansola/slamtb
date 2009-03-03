mxSc = 1;
n = 1;
N = 50;
T = zeros(1,N);
S = zeros(1,N);

figure(1)
while n <= N && mxSc > -1
    scanTest3
    %     pause(.8)
    T(n) = 1000*tocS;
    S(n) = 10*mxSc;
    n = n+1;
    drawnow
end

Tm  = mean(T);
Ts  = std(T);
Tmx = max(T);
Tmn = min(T);
fprintf('Scan time mean:  %4.1f ms\n',Tm);
fprintf('Scan time sigma: %4.1f ms\n',Ts);
fprintf('Scan time max:   %4.1f ms\n',Tmx);
fprintf('Scan time min:   %4.1f ms\n',Tmn);

figure(2)
N = 1:N;
plot(N,S,N,T)
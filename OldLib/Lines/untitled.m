%%
x0 = 1;
sigmax = 5;
sigmadx = .01;
y = 1;
R = 1;

N  = 1000;
G1 = zeros(1,N);
G2 = zeros(1,N);

for i = 1:N
    
    x = x0 + sigmax*randn(size(x0));
    dx = sigmadx*randn(size(x0));
    
    G1(i) = gainRatio(x,dx,@h1,y,R,1);    
    G2(i) = gainRatio(x,dx,@h2,y,R,1);
    
end

figure(1)
clf
subplot(2,2,1)
hist(G1,50)
set(gca,'ygrid','on')
subplot(2,2,3)
hist(G2,50)
set(gca,'ygrid','on')
subplot(2,2,[2 4])
plot(G1,G2,'.')
grid
line([0 1],[0 1],'color','r')


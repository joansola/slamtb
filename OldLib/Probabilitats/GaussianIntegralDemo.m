%%
M=100;% on fera M tests
N=100; % de longueur N chacun
d = zeros(M,N);
for j = 1:M 
    for i = 2:N
        n = randn; % c'est un bruit d-ecart type 1
        d(j,i) = d(j,i-1) + n; % on integre a chaque Te
    end
end
plot(d')         % Ce sont toutes les M trajectoires de longueur N simulees
m = std(d);      % on prends l'ecart-type
line(1:N,m,'linewidth',6)                     % C'est l-ecart-type de sortie
line(1:N,sqrt(0:N-1),'color','r','linewidth',3) % C'est une courbe suivant sqrt(t)

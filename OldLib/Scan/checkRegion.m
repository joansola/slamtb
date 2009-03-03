
ns  = 1;
% Please run a part of fisslamReal, with only one ray better.
Ray = projectRay(Rob,Cam,Ray);
region = ray2par(Ray,ns);
figure(3)
clf
axis equal
grid 
for i=1:Ray.n
    [elx,ely]=cov2elli(Ray.u(:,i),Ray.U(:,:,i),ns);
    el(i)=line(elx,ely,'color','c');
end

ax = line('xdata',Ray.u(1,:),'ydata',Ray.u(2,:),'color','m');

c = line(par.x0(1),par.x0(2),'color','r','marker','+');

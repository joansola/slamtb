% ORBITVIDEO  Make AVI movie while orbiting the figure

figure(fig1)

videoPosMapOrb  = videoPosMap;
seqFileMapOrb = [expdir 'sequences/idp-' expType '/' experim '-map-orb-%04d.png'];
set(fig1,'pos',videoPosMapOrb);

disp('About to create orbit sequence of the map.')
disp('Set perspective projection. then...')
disp('...rotate map to the initial position and press any key')
drawnow
pause
fprintf('Orbiting camera...')
figure(fig1)

imgFrame(fig1,sprintf(seqFileMapOrb,0));

for a=1:180
    camorbit(-2,0)
    imgFrame(fig1,sprintf(seqFileMapOrb,a));
end

fprintf(' OK\n')

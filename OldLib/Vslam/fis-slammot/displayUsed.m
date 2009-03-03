function usedLm = displayUsed(usedLm);

global Map

usedY = (Map.used~=0);
set(usedLm,...
    'ydata',usedY);

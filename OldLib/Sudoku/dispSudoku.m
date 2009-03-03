function dispSudoku(sure,T)

% DISPSUDOKU  Display Sudoku
%   DISPSUDOKU(S,T) pretty prints the Sudoku table given in 
%   the 9x9 array S and waits for T seconds after continuing.

% copyright 2005 Joan Sola

% convert to string
str = num2str(sure);

% subsititute zeros
str(str=='0') = '.';

% add row spaces
rblank(1:size(str,2))=' ';
rsep(1:size(str,2))='-';
str = [str(1,:)
       rblank
       str(2,:)
       rblank
       str(3,:)
       rsep
       str(4,:)
       rblank
       str(5,:)
       rblank
       str(6,:)
       rsep
       str(7,:)
       rblank
       str(8,:)
       rblank
       str(9,:)];

% add column spaces
csep(1:size(str,1))='|';
csep = csep';
% csep([6 12])='+';
cblank(1:size(str,1))=' ';
cblank = cblank';
ccblank = repmat(cblank,1,4);
str = [ccblank str(:,1:8) csep str(:,9:17) csep str(:,18:end)];

% display
disp('')
disp('          \ S U D O K U /        ')
disp('  ===============================')
disp(str)
disp('  ===============================')
while toc<T, end
tic

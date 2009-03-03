function aviobj = closeVideo(aviobj)

% CLOSEVIDEO  Close AVI video file.
%   FID = CLOSEVIDEO(FID) closes the AVI video identified by FID.

fprintf('Closing AVI file << %s >>\n',aviobj.Filename)
disp('It may take several minutes. Please wait...')
aviobj = close(aviobj);
disp('OK, it''s finished!')

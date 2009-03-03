function chi2 = chi2(p,n)

% CHI2  Chi square distribution
%   TH = CHI2(P,N) gives the critical values of the N-dimensional
%   Chi-squared distribuiton funciton for a right-tail area P

if (n == floor(n)) && (n>=1) && (n<=7)
    
    Chi2Tab = [ 0.00004   0.00016  0.00098   0.00393   0.01579   0.10153   0.45494   1.32330   2.70554   3.84146   5.02389   6.63490   7.87944
        0.01003   0.02010  0.05064   0.10259   0.21072   0.57536   1.38629   2.77259   4.60517   5.99146   7.37776   9.21034   10.59663
        0.07172   0.11483  0.21580   0.35185   0.58437   1.21253   2.36597   4.10834   6.25139   7.81473   9.34840   11.34487   12.83816
        0.20699   0.2971   0.48442   0.71072   1.06362   1.92256   3.35669   5.38527   7.77944   9.48773   11.14329   13.27670   14.86026
        0.41174   0.55430  0.83121   1.14548   1.61031   2.67460   4.35146  6.62568   9.23636   11.07050   12.83250   15.08627   16.74960 
        0.67573   0.87209  1.23734   1.63538   2.20413   3.45460   5.34812  7.84080   10.64464   12.59159   14.44938   16.81189   18.54758
        0.98926   1.23904  1.68987   2.16735   2.83311   4.25485   6.34581  9.03715   12.01704   14.06714   16.01276   18.47531   20.27774];
    
    if  (p > .005) && (p < .995)
        
        pTab = [.995 .99 .975 .95 .9 .75 .5 .25 .1 .05 .025 .01 .005];
        
        iInf = find(pTab<p, 1 );
        iSup = find(pTab>=p, 1, 'last' );
        
        pInf = pTab(iInf);
        pSup = pTab(iSup);
        
        chiInf = Chi2Tab(n,iInf);
        chiSup = Chi2Tab(n,iSup);
        
        chi2 = chiInf + (chiSup-chiInf) * (p-pInf) / (pSup-pInf);
        
    elseif p <= .005
        warning('Too small probability. Assuming 0.005')
        chi2 = Chi2Tab(n,end);
    else
        warning('Too big probability. Assuming 0.995')
        chi2 = Chi2Tab(n,1);
    end
    
else
    error('Dimension must be a positive integer value in [1 7]')
end

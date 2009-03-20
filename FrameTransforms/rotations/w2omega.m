function Omega=w2omega(w)

% W2OMEGA  Skew symetric matrix OMEGA from angular rates vector W.
%   OMEGA = W2OMEGA(W) builds OMEGA as
%
%      Omega=[  0   -W(1) -W(2) -W(3)
%              W(1)   0    W(3) -W(2)
%              W(2) -W(3)   0    W(1)
%              W(3)  W(2) -W(1)   0  ];
%
% See also Q2PI, ODO3.

%   (c) 2009 Joan Sola @ LAAS-CNRS.

 

if (size(w) == [3 1])
%     Omega=[  0   -w(1) -w(2) -w(3)
%             w(1)   0   -w(3)  w(2)
%             w(2)  w(3)   0   -w(1)
%             w(3) -w(2)  w(1)   0  ];
    Omega=[  0   -w(1) -w(2) -w(3)
            w(1)   0    w(3) -w(2)
            w(2) -w(3)   0    w(1)
            w(3)  w(2) -w(1)   0  ];
else
    error('Input dimensions don''t agree. Enter 3x1 column vector')
end

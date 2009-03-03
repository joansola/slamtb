syms a b c d at bt ct dt real

q  = [a b c d]';
qt = [at bt ct dt]';

qc = q2qc(q)

w  = 2*qProd(qt,qc)

wc = q2qc(w)

r  = qProd(w,wc)
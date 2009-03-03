syms a b c d r p y real

% q2e
q = [a b c d]';
e = q2e(q);

Eqm = simple(jacobian(e,q));

Eqf = q2eJac(q);

Err = simple(Eqm-Eqf)

% e2q
e = [r p y]';
q = e2q(e);

Qem = simple(jacobian(q,e));

Qef = e2qJac(e);

Err = simple(Qem-Qef)

% combinacio error en rob frame -> en sensor frame
q_cs = R2q(flu2rdf);
e_rc = e;               % errors en rob frame
q_rs = qProd(e2q(e_rc),q_cs);
JeQm = simple(jacobian(q_rs,e_rc));
JeQf = e2qrdfJac(e_rc);

Err = simple(JeQm-JeQf)

% combinacio error en sensor frame -> en robot frame
q    = [a b c d]';
q_rs = q; % errors en rob frame
e_rc = q2e(qProd(q_rs,q2qc(q_cs)));
JqEm = simple(jacobian(e_rc,q_rs));
JqEf = q2erdfJac(q_rs);

Err = simple(JqEm-JqEf)

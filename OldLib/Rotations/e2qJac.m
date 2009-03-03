function JeQ = e2qJac(e)

r = e(1);
p = e(2);
y = e(3);

sr2 = sin(1/2*r);
cr2 = cos(1/2*r);
sp2 = sin(1/2*p);
cp2 = cos(1/2*p);
sy2 = sin(1/2*y);
cy2 = cos(1/2*y);

JeQ = [[ -cy2*cp2*sr2+sy2*sp2*cr2, -cy2*sp2*cr2+sy2*cp2*sr2, -sy2*cp2*cr2+cy2*sp2*sr2]
[  cy2*cp2*cr2+sy2*sp2*sr2, -cy2*sp2*sr2-sy2*cp2*cr2, -sy2*cp2*sr2-cy2*sp2*cr2]
[ -cy2*sp2*sr2+sy2*cp2*cr2,  cy2*cp2*cr2-sy2*sp2*sr2, -sy2*sp2*cr2+cy2*cp2*sr2]
[ -sy2*cp2*sr2-cy2*sp2*cr2, -cy2*cp2*sr2-sy2*sp2*cr2,  cy2*cp2*cr2+sy2*sp2*sr2]
]/2;
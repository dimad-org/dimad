UTRANSPORT
D1:      DRIFT,         L=1.0
Qfone:   QUADRUPOLE,    L=1.0, K1=0.15
QD1:     QUADRUPOLE,    L=2.0, K1=-0.15
HBEND:   SBEND,         L=2.5, ANGLE=1.2, E1=0.6, FINT=0.0, E2=0.6
ksyn: gkick,t=-10
BL:      LINE=(ksyn,QFONE, D1, HBEND, D1, QD1, D1, HBEND,D1, QFONE)
USE, BL
DIMAT
matrix
1 -1,
print
name
ksyn
99
end,
output
4,
tracking
-2 1 1 30
0 0 0 0 0 0.002
1,
modify
1
ksyn t -15,
tracking
-2 1 0 30
1;
stop
adiabtic variation of the t parameter of ksyn
ksyn t 1 15 50 -10 -15
99,
tracking
-2 1 1 70
0 0 0 0 0 0.002
1;
stop

utransport
d1:      drift,         l=1.0
qfone:   quadrupole,    l=1.0, k1=0.15
qftwo:   quadrupole,    l=1.0, k1=0.15
qd1:     quadrupole,    l=2.0, k1=-0.15
m1:marker;m2:marker
hbend:   sbend,         l=2.5, angle=1.2, e1=0.6, fint=0.0, e2=0.6
cell:   line= (qftwo, d1, hbend, d1,m1, qd1, d1,m2, hbend,d1, qfone, &
          qftwo, d1, hbend, d1, qd1, d1, hbend,d1, qfone)
use,cell
dimat
matrix computation
1 -1,
* The following is to illustrate the use of the PRINT
* operation
print
interval
m1 m2
99,
name
qf*
99,
type
bend
99,
end
machine : inthis case the print request of -1 supersedes the
* request found in the previous print command (the same would
* be true if if the request were 0 : print everywhere)
1 1.1 0.1 0 0.025 1 1
0 0 0 0
0 0 0 0
-1,
machine: in this case the printing occurs as requested by the
* previous print command
1 1.1 0.1 0 0.025 1 1
0 0 0 0
0 0 0 0
1,
* The following is to illustrate the use of rmat and geometric
* aberrations in conjunction with movement analysis
movement analysis
1 1 1 -3 1 0 0.00001
0 0 0 0 0 0.002
0,
geometric aberration
0 0 0 0
0 0 0 0 0
1 100 1
1 -2
10 10,
print
interval
m1 m2
99,
end,
rmat
0 0 0 0 0 0
1.0e-6 1.0e-6 1.0e-6 1.0e-6 1.0e-6 1.0e-6
1 1,
rmat
0 0 0 0 0 1
1.0e-6 1.0e-6 1.0e-6 1.0e-6 1.0e-6 1.0e-6
1 1;
stop
stop

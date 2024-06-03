ustandard
title
test of symplectic ray trace
! basic parameters
!   6 GeV electron beam
brho = 20.013846
!   ring geometry
pi    =   3.1415926536
ltot  =  96.
nbend =  48
lb    = ltot/nbend
lbh   = lb/2.
rho   = ltot/(2.*pi)
b0    = brho/rho
bangle= lb/rho
bhalf = bangle/2.
ld    = .5
 
!   focussing structure
kref  = .25
 
kf    =  kref
kd    = -kref
 
ksf   =  0.
ksd   =  0.
 
! element list
!   drift
d1: drift, l=ld
 
!   combined function bends
bfl: sbend, l=lbh, angle=bhalf, e1=0., e2=bhalf, k1=kf, k2=ksf
bfr: sbend, l=lbh, angle=bhalf, e1=bhalf, e2=0., k1=kf, k2=ksf
bdl: sbend, l=lbh, angle=bhalf, e1=0., e2=bhalf, k1=kd, k2=ksd
bdr: sbend, l=lbh, angle=bhalf, e1=bhalf, e2=0., k1=kd, k2=ksd
 
! twiss matrix for tuning
bx0 = 7.7
by0 = 1.6
ax0 = 0.
ay0 = 0.
mx  = (73*pi/180)
my  = (77*pi/180)
 
slip: mtwiss, l=0., mux=mx, betax=bx0, alphax=ax0, &
                    muy=my, betay=by0, alphay=ay0
 
! lattice structure
cell: line=(bfl, d1, bdr, bdl, d1, bfr)
ring: line=(slip, 24*(cell))
 
use, cell
 
dimat
matrix for unfitted cell
2 -1,
*machine and beam parameters for unfitted cell
*1 2 1 0 .001 1 1
*0 0 0 0
*0 0 0 0 0,
simple fit to achieve single cell phase
2 2 2
bfl k1 .0001
bdl k1 .0001
 2 .25
12 .25
2
bfl k1 1
bfr k1 1. 0.
bdl k1 1
bdr k1 1. 0.,
simple fit to achieve chromatic correction
2 2 2
bfl k2 .0001
bdl k2 .0001
 8  0.
18  0.
2
bfl k2 1
bfr k2 1. 0.
bdl k2 1
bdr k2 1. 0.,
matrix for fitted cell
2 -1,
machine and beam parameters for fitted cell
1 2 1 0 .001 1 1
0 0 0 0
0 0 0 0 0;
 
! use fitted cell in ring; test ray tracing
 
use, ring
 
! use newbeam to transfer fitted values to dimat module
 
newbeam
matrix for ring
2 -1,
*machine and beam parameters for fitted ring
*1 2 1 0 .001 1 1
*0 0 0 0
*0 0 0 0 0,
movement analysis
1 1 1 -3 7 5 1.0e-05
0 0 0 0 0
0.0 -0.003 -0.001 -0.0003 0.0003 0.001 0.003
0,
tracking in ring with non symplectic ray trace and lagrangian variables
1 -1 1 10000
.015 .0 .0 .0 .0 .0
0
14
-.02 .02 -.003 .003
-.02 .02 -.003 .003
101 51,
*
*  WARNING: ONLY 1 "SET SYMPLECTIC OPTION" CALL MAY BE MADE PER
*           CALL TO THE DIMAT MODULE - WHEN THIS OPERATION IS
*           UTILISED, THE MATRICES STORED IN THE AMAT ARRAY ARE
*           WIPED OUT.  SUBSEQUENT CALLS FOR DIFFERENT SYMPLECTIC
*           TRACING OPTIONS MUST BE MADE AFTER SEPARATE INVOCATIONS
*           OF THE DIMAT MODULE.  THIS DEMO THEREFORE (BECAUSE FITTED
*           VALUES MUST BE PASSED VIA THE "NEWBEAM" COMMAND)
*           CANNOT SUPPORT MORE THAN 1 SYMPLECTIC RAY TRACE EXAMPLE
*           PER JOB.  IN THIS CASE, ISYOPT = 1 IS ILLUSTRATED; OTHER
*           EXAMPLES MAY BE RUN BY REMOVING COMMENT SYMBOL "*" FROM
*           THE INPUT DATA FOR EACH ISYOPT.  REMEMBER - ONLY 1 CASE
*           AT A TIME THOUGH!!!
*
*  TYPICAL EXECUTION TIMES ON VAX 11/785
*     standard mode -  5 min for 2500 turns
*     isyopt = 0 mode  6        "
*              1      12        "
*              2      11        "
*              3      32        "
*              4      31        "
*
*set symplectic option: non symplectic ray trace with hamiltonian variables
*0 6.,
*matrix in can. var.-the "error" in chrom. is due to the element "slip"
*2 -1,
*tracking in ring with non symplectic ray trace and hamiltonian variables
*1 -1 1 4000
*.015 .0 .0 .0 .0 .0
*0
*14
*-.02 .02 -.003 .003
*-.02 .02 -.003 .003
*101 51;
set symplectic option: lagrangian variables, fast ray trace
1 6.,
matrix in canonical variables
2 -1,
movement analysis using symplectic tracking and print in x x',y y'
1 1 1 -3 7 5 1.0e-05
0 0 0 0 0
0.0 -0.003 -0.001 -0.0003 0.0003 0.001 0.003
0,
tracking in ring with fast symplectic ray trace
1 -1 1 10000
.015 .0 .0 .0 .0 .0
0
14
-.02 .02 -.003 .003
-.02 .02 -.003 .003
101 51;
 
stop
 
*set symplectic option: hamiltonian variables, fast ray trace
*2 6.,
*matrix in canonical variables
*2 -1,
*tracking in ring with fast symplectic ray trace, canonical variables
*1 -1 1 4000
*.015 .0 .0 .0 .0 .0
*0
*14
*-.02 .02 -.003 .003
*-.02 .02 -.003 .003
*101 51;
*set symplectic option: lagrangian variables, slow ray trace
*3 6.,
*matrix in canonical variables
*2 -1,
*tracking in ring with slow symplectic ray trace in lagrangian variables
*1 -1 1 4000
*.015 .0 .0 .0 .0 .0
*0
*14
*-.02 .02 -.003 .003
*-.02 .02 -.003 .003
*101 51;
*set symplectic option: hamiltonian variables, slow ray trace
*4 6.,
*matrix in canonical variables
*2 -1,
*tracking in ring with slow symplectic ray trace in hamiltonian variables
*1 -1 1 4000
*.015 .0 .0 .0 .0 .0
*0
*14
*-.02 .02 -.003 .003
*-.02 .02 -.003 .003
*101 51;
 
stop
 
 
 
 
 
 
 
 
 
 
 
 
 
 

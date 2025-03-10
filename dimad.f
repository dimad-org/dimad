C*******************************************************
C      Implementation suggestions.
C*******************************************************
C  in the routine cinitig
C  when operation on an IBM activate the call errset statements
C  deactivate those statements for other systems
C*******************************************************
C  in function clock1
C  follow instructions about which function to use
c  this function must provide the time in seconds or mseconds
c  from the beginning of the day )or some other reference point)
c  to produce an integer to serve as a seed to the random
c  generators. See SEED subroutine
C*******************************************************
c  in madin use appropriate set of statements giving date and time
c  in datimh comment out the statements containing call date and call
c  time when using a computer other than a VAX
C*******************************************************
c  in the function urand
c  follow instructions about which function to use for different
c  systems. Urand is a uniform random generator between 0 and 1
C*******************************************************
c  Function dpmpar
c  adopt the adequate constants for your system and fortran compiler.
c  If you must determine yourself follow the explanations in the
c  common block at the beginning of the function. If need be write
c  a short program to determine these constants
C*******************************************************
c   in setup comment out statements not required for your choice
c  of command or exec files.
C*******************************************************
      SUBROUTINE ADICHK
C     *****************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXADIV = 15)
      PARAMETER    (MXADIP = 100)
      COMMON/ADIA/VPARM(mxadiv,2*mxadip),IADFLG,IADCAV,NADVAR,
     >ivid(mxadiv),IVPAR(mxadiv),IVOPT(mxadiv)
      PARAMETER    (MXELMD = 3000)
      PARAMETER  (MAXDAT=16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
c      DO 1 IV=1,NADVAR
c      N0=VPARM(IV,1)
c      N1=VPARM(IV,2)
C      IF(KODE(IVID(IV)).NE.7)GOTO 2
C      GOTO 1
C      if((kode(ivid(iv)).eq.7).and.(ivpar(iv).eq.4))goto 1
c      idel=ivid(iv)
c      kiv=kode(idel)
c      IF((NCTURN.LT.N0).OR.(NCTURN.GT.N1))return
c      IOPT=IVOPT(IV)
c      IAD=IADR(Idel)-1
c      GOTO(100,200),IOPT
c      WRITE(IOUT,10000)
c10000 FORMAT(' ERROR IN OPTION NUMBER FOR ADIABATIC CHANGE ')
c      CALL HALT(200)
c      return
c  100 P0=VPARM(IV,3)
c      P1=VPARM(IV,4)
c      P=P0+(NCTURN-N0)*(P1-P0)/(N1-N0)
c      ELDAT(IAD+IVPAR(IV))=P
c      GOTO 2
c  200 P0=VPARM(IV,3)
c      P1=VPARM(IV,4)
c      PER=VPARM(IV,5)
c      APHI=VPARM(IV,6)
c      P=P0+P1*DSIN((TWOPI*NCTURN/PER)+APHI)
c      ELDAT(IAD+IVPAR(IV))=P
c      GOTO 2
c    2 continue
C      write(iout,2000)
C     >  ncturn,idel,kiv,iad,ivpar(iv),p
C 2000 format('  in adichk ncturn,ivid,kode,iad,ivpar and p are :',/,
C     > 5i5,e13.4)
      do 1 iv=1,nadvar
      idel=ivid(iv)
      iad=iadr(idel)-1
      iadiop=ivopt(iv)
      goto(100,200,300),iadiop
      WRITE(IOUT,10000)
10000 FORMAT(' ERROR IN OPTION NUMBER FOR ADIABATIC CHANGE ')
      CALL HALT(200)
      return
  100 nad0=vparm(iv,1)
      nad1=vparm(iv,2)
      if((ncturn.lt.nad0).or.(ncturn.gt.nad1)) return
      p0=vparm(iv,3)
      p1=vparm(iv,4)
      P=P0+(NCTURN-nad0)*(P1-P0)/(nad1-nad0)
      ELDAT(IAD+IVPAR(IV))=P
      goto 2
  200 nad0=vparm(iv,1)
      nad1=vparm(iv,2)
      if((ncturn.lt.nad0).or.(ncturn.gt.nad1)) return
      p0=vparm(iv,3)
      p1=vparm(iv,4)
      PER=VPARM(IV,5)
      APHI=VPARM(IV,6)
      P=P0+P1*DSIN((TWOPI*NCTURN/PER)+APHI)
      ELDAT(IAD+IVPAR(IV))=P
      GOTO 2
  300 nadpar=vparm(iv,1)
      nad0=vparm(iv,2)
      nadlst=vparm(iv,2*nadpar)
      if((ncturn.lt.nad0).or.(ncturn.gt.nadlst)) return
      do 301 iadpar=2,nadpar
      nad0t=vparm(iv,2*iadpar-2)
      nad1t=vparm(iv,2*iadpar)
      if((ncturn.ge.nad0t).and.(ncturn.le.nad1t))goto 302
  301 continue
      goto 2
  302 p0=vparm(iv,2*iadpar-1)
      p1=vparm(iv,2*iadpar+1)
      p=p0+(ncturn-nad0t)*(p1-p0)/(nad1t-nad0t)
      eldat(iad+ivpar(iv))=p
      goto 2
    2 call matgen(idel)
    1 continue
      RETURN
      END
      SUBROUTINE ALIGN(IEND)
C     *************************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      COMMON/DETL/DENER(15),NH,NV,NVH,NHVP(105),MDPRT,NDENER,
     >NUXS(45),NUX(45),NUYS(45),NUY(45),NCO,NHNVHV,MULPRT,NSIG
      COMMON/BETAL/BETA0X,ALPH0X,ETA0X,ETAP0X,
     >BETA0Y,ALPH0Y,ETA0Y,ETAP0Y,X0,XP0,Y0,YP0,DLEN0
     >,DX0,DXP0,DY0,DYP0,DEL0,XS(15),XPS(15),YS(15),YPS(15),DLENS(15)
      PARAMETER  (mxlcnd = 200)
      PARAMETER  (mxlvar = 100)
      COMMON/MONIT/VALMON(MXLCND,4,3)
      COMMON/MONFIT/VALFA(MXLCND),WGHTA(MXLCND),ERRA(MXLCND),
     >AMULTA(MXLVAR,6),ADDA(MXLVAR,6),DELA(MXLVAR)
     >,NPARA(MXLVAR,6),NELFA(MXLVAR,6),
     >NPVARA(MXLVAR),INDA(MXLVAR,6),VALR(MXLCND),RMOSIG,
     >NMONA(MXLCND),NVALA(MXLCND),NVARA,NCONDA
     >,IALFLG,MONFLG,MONLST,NOPTER,
     >IAFRST,IMOOPT,IMSBEG,NALPRT
      COMMON/CSEEDS/ISEED,IXG,IXS,IXMSTP,IMSD,IMOSTP,ISYNSD,ISYSTP,
     >ISDBEG,IBGSTP,IXES,IXESTP,IESBEG,IESTBG,isdcol
      COMMON/CFALC/IMSDSV,IMSVTP
      COMMON/LMWORK/FVEC(MXLCND),
     >DIAG(MXLVAR),FJAC(MXLCND,MXLVAR),QTF(MXLVAR),WA1(MXLVAR),
     >WA2(MXLVAR),WA3(MXLVAR),WA4(MXLCND),IPVT(MXLVAR)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      PARAMETER  (MAXDAT=16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      PARAMETER     (MAXCOR = 600)
      COMMON/CORR/CORVAL(MAXCOR,4),ICRID(MAXCOR),
     >ICRPOS(MAXCOR),ICRSET(MAXCOR),
     >ICROPT(MAXCOR),NCORR,NCURCR,ICRFLG,ICRCHK,ALMNEL,ICRPTR,NPARC
      COMMON/CORSET/DCX1,DCX2,DCXR1,DCXR2,DCY1,DCY2,DCYR1,DCYR2,
     >DCXP,DCYP,DCDEL
      common/cinter/inumel,niplot,intflg,iprpl,jherr,itrap,
     > numel(20),iscx(20),iscy(20),
     > iscsx(20),iscsy(20),avx(11,101),avy(11,101),axis(101)
      character*1 avx,avy,axis
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
      PARAMETER        (MXCRMN = 100)
      DIMENSION NCROPT(MXCRMN),NCRID(MXCRMN),NCRPAR(MXCRMN)
      DIMENSION NMNID(MXCRMN),NMNVAL(MXCRMN)
      DIMENSION VALMN(MXCRMN),WGMN(MXCRMN),ERRMN(MXCRMN)
      DIMENSION VALMAT(144),XA(MXLVAR),EA(MXLVAR)
      DIMENSION VAL0(MXLCND),DVAL(MXLCND),QVAL(MXLCND)
      DIMENSION LV(MXLVAR),MV(MXLVAR)
      CHARACTER*1 IBLANK,ICHP,ITCORR(4),IDIGIT(10)
      EXTERNAL FALCT
      DATA IBLANK/' '/,ICHP/'P'/
      DATA IDIGIT/'0','1','2','3','4','5','6','7','8','9'/
      DATA ITCORR/'C','O','R','R'/
C INITIALIZE ARRAYS
      IAFRST=100000
      DO 100 IAL=1,MXLCND
      VALFA(IAL)=0.0D0
      WGHTA(IAL)=0.0D0
      NVALA(IAL)=0
  100 CONTINUE
      DO 106 IAL=1,MXLVAR
      DELA(IAL)=0.0D0
      NPVARA(IAL)=1
      DO 106 JAL=1,6
      AMULTA(IAL,JAL)=0.0D0
      ADDA(IAL,JAL)=0.0D0
      NELFA(IAL,JAL)=0
      NPARA(IAL,JAL)=0
      IF(JAL.EQ.1)AMULTA(IAL,JAL)=1.0D0
  106 CONTINUE
C  COLLECT INPUT DATA TO OPERATION
      IALFLG=1
      LOCCFL=0
      NDIM=mxinp
      NCHAR=0
      NDATA=23
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NDATA,NALPRT)
      if((itrap.eq.1).and.(jherr.ne.0)) return
      NSTEP=DABS(data(1))
      NFLPRT=-1
      IF(data(1).LT.0.0D0)NALPRT=-1
      IF(data(1).GT.0.0D0)NFLPRT=1
      NIT=data(2)
      NVARA=data(3)
      NPARC=NVARA
      NCONDA=data(4)
      IF((NCONDA.GT.MXLCND).OR.(NVARA.GT.MXLVAR)) THEN
         WRITE(IOUT,99109)NCONDA,NVARA,MXLCND,MXLVAR
99109 FORMAT('  # OF CONDITIONS',I4,' OR # OF VARIABLES',I4,' EXCEEDS',
     >/,' MAX # OF CONDITIONS',I4,' MAX # OF VARIABLES',I4,/,
     >' CHANGE PARAMETERS MXLCND OR MXLVAR ACCORDINGLY ')
         CALL HALT(0)
         return
      ENDIF
      NFIT=data(5)
      NOPTER=data(6)
      BETA0X=data(7)
      ALPH0X=data(8)
      ETA0X =data(9)
      ETAP0X=data(10)
      BETA0Y=data(11)
      ALPH0Y=data(12)
      ETA0Y =data(13)
      ETAP0Y=data(14)
      X0=data(15)
      XP0=data(16)
      Y0=data(17)
      YP0=data(18)
      DX0=data(19)
      DXP0=data(20)
      DY0=data(21)
      DYP0=data(22)
      DEL0=0.0D0
      NH=0
      NV=0
      NVH=0
      NSIG=0
      NDENER=data(23)
      NDATA=NDENER
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NDATA,NALPRT)
      if((itrap.eq.1).and.(jherr.ne.0)) return
      DO 1 IAL=1,NDENER
      DENER(IAL)=data(IAL)
      XS(IAL)=0.0D0+ETA0X*DENER(IAL)
      XPS(IAL)=0.0D0+ETAP0X*DENER(IAL)
      YS(IAL)=0.0D0+ETA0Y*DENER(IAL)
      YPS(IAL)=0.0D0+ETAP0Y*DENER(IAL)
    1 CONTINUE
      INITPS=0
      NDATA=0
      NCHAR=8
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NDATA,NALPRT)
      if((itrap.eq.1).and.(jherr.ne.0)) return
      CALL ELPOS(ICHAR,NELPOS)
      if((itrap.eq.1).and.(jherr.ne.0)) return
      INITPS=NELPOS
      DO 2 IVAR=1,NVARA
      NDATA=0
      NCHAR=8
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NDATA,NALPRT)
      if((itrap.eq.1).and.(jherr.ne.0)) return
      IF((LOCCFL.EQ.1).AND.(NFIT.NE.3))GOTO 22
      IF((LOCCFL.EQ.1).AND.(NFIT.EQ.3))GOTO 300
      DO 20 ICH=1,4
      IF(ICHAR(ICH).NE.ITCORR(ICH))GOTO 21
   20 CONTINUE
      NPARC=IVAR-1
      LOCCFL=1
      ICRFLG=1
  300 IF(NFIT.EQ.3) THEN
        JVAR=IVAR
        NCHAR=0
        NDATA=1
        CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NDATA,NALPRT)
      if((itrap.eq.1).and.(jherr.ne.0)) return
        NC=data(1)
        NCHAR=8
        NDATA=2
        DO 301 NCI=1,NC
        CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NDATA,NALPRT)
      if((itrap.eq.1).and.(jherr.ne.0)) return
        CALL ELID(ICHAR,NELID)
      if((itrap.eq.1).and.(jherr.ne.0)) return
        NCRID(NCI)=NELID
        NCROPT(NCI)=data(1)
        NCRPAR(NCI)=data(2)
  301   CONTINUE
        IEC=INITPS-1
        ICRN=1
        NCRN=0
  303   IEC=IEC+1
        IF(IEC.GT.NELM) THEN
           WRITE(IOUT,11001)
           IF(ISO.NE.0)WRITE(ISOUT,11001)
11001 FORMAT(' NOT ENOUGH CORRECTORS IN BEAMLINE ')
           CALL HALT(206)
           return
        ENDIF
  302   IF(ICRPOS(ICRN).LT.IEC) THEN
           ICRN=ICRN+1
           IF(ICRN.GT.NCORR)THEN
           WRITE(IOUT,11002)
           IF(ISO.NE.0)WRITE(ISOUT,11002)
11002 FORMAT(' NOT ENOUGH CORRECTORS WERE DEFINED ')
           CALL HALT(206)
           return
           ENDIF
           GO TO 302
        ENDIF
        IF(ICRPOS(ICRN).GT.IEC) GOTO 303
        DO 304 ITC=1,NC
        IF(ICRID(ICRN).EQ.NCRID(ITC))GOTO 305
  304   CONTINUE
        GOTO 303
  305   ICRSET(ICRN)=1
        ICROPT(ICRN)=NCROPT(ITC)
        NELFA(JVAR,1)=ICRN
        NPARA(JVAR,1)=NCRPAR(ITC)
        DELA(JVAR)=0.0001
        ICPOS=ICRPOS(ICRN)
        IF(IAFRST.GT.ICPOS)IAFRST=ICPOS
        IF(JVAR.LT.NVARA) THEN
           JVAR=JVAR+1
           GOTO 303
        ENDIF
        GOTO 306
      ENDIF
      NPARC=IVAR-1
      LOCCFL=1
      ICRFLG=1
      NCHAR=8
      NDATA=0
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NDATA,NALPRT)
      if((itrap.eq.1).and.(jherr.ne.0)) return
   22 NCHAR=0
      NDATA=4
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NDATA,NALPRT)
      if((itrap.eq.1).and.(jherr.ne.0)) return
      CALL ELID(ICHAR,NELID)
      if((itrap.eq.1).and.(jherr.ne.0)) return
      ICPOS=data(1)+INITPS
      IF(IAFRST.GT.ICPOS)IAFRST=ICPOS
      DO 23 ICORR=1,NCORR
      IF(ICPOS.LT.ICRPOS(ICORR))GOTO 24
      IF((NELID.EQ.ICRID(ICORR)).AND.(ICPOS.EQ.ICRPOS(ICORR)))GOTO 25
   23 CONTINUE
   24 WRITE(IOUT,10001)ICHAR,ICPOS
10001 FORMAT(/,' ',8A1,I6,/,'  NO MATCH WAS FOUND ',
     >'FOR CORRECTOR ID AND POSITION',
     >' IN THE CORRECTOR LIST',/,' DEFINED IN THE CORRECTOR DEFINITION',
     >' OPERATION . RUN IS STOPPED',/)
      CALL HALT(201)
      return
   25 ICRSET(ICORR)=1
      ICROPT(ICORR)=data(2)
      NELFA(IVAR,1)=ICORR
      NPARA(IVAR,1)=data(3)
      DELA(IVAR)=data(4)
      GOTO 2
   21 CALL ELID(ICHAR,NELID)
      if((itrap.eq.1).and.(jherr.ne.0)) return
C CHECK FOR LOCATION OF VARIED ELEMENT
      CALL POSCHK(NELID,IPOSCH)
      if((itrap.eq.1).and.(jherr.ne.0)) return
C SET FIRST FLAG
      IF(IAFRST.GT.IPOSCH)IAFRST=IPOSCH
      NELFA(IVAR,1)=NELID
      NDATA=1
      NCHAR=8
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NDATA,NALPRT)
      if((itrap.eq.1).and.(jherr.ne.0)) return
      CALL DIMPAR(NELID,ICHAR,IDICT)
      if((itrap.eq.1).and.(jherr.ne.0)) return
      NPARA(IVAR,1)=IDICT
      DELA(IVAR)=data(1)
    2 CONTINUE
  306 CONTINUE
      IF(NFIT.EQ.3) THEN
        NCHAR=0
        NDATA=2
        CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NDATA,NALPRT)
      if((itrap.eq.1).and.(jherr.ne.0)) return
        NMN=data(1)
        NDROP=data(2)
        NCHAR=8
        NDATA=4
        DO 308 NMNI=1,NMN
        CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NDATA,NALPRT)
      if((itrap.eq.1).and.(jherr.ne.0)) return
        CALL ELID(ICHAR,NELID)
      if((itrap.eq.1).and.(jherr.ne.0)) return
        NMNID(NMNI)=NELID
        NMNVAL(NMNI)=data(1)
        ITEST=NMNVAL(NMNI)-1
        IF(MOD(ITEST,4).GE.2)NSIG=1
        VALMN (NMNI)=data(2)
        WGMN  (NMNI)=data(3)
        ERRMN (NMNI)=data(4)
  308   CONTINUE
        IEM=INITPS-1
        IMON=1
        NMON=0
  309   IEM=IEM+1
        IED=NORLST(IEM)
        KIED=KODE(IED)
        IF(KIED.NE.13)THEN
          IF(IEM.GT.NELM) THEN
            imonm1=imon-1
            WRITE(IOUT,10301)imonm1
10301 FORMAT(' OUT OF MONITORS TO MANY REQUIRED RUN STOPPED ',/,
     >     i6,' MONITORS FOUND')
            CALL HALT(202)
            return
          ENDIF
          GOTO 309
        ENDIF
        DO 310 NMNC=1,NMN
        IF(IED.EQ.NMNID(NMNC)) THEN
          IF(NDROP.EQ.0) THEN
            NMONA(IMON)=IEM
            NVALA(IMON)=NMNVAL(NMNC)
            VALFA(IMON)=VALMN(NMNC)
            WGHTA(IMON)=WGMN(NMNC)
            ERRA(IMON)=ERRMN(NMNC)
            IF(IMON.EQ.NCONDA) GOTO 307
            IMON=IMON+1
                          ELSE
            NDROP=NDROP-1
            GOTO 309
          ENDIF
        ENDIF
  310   CONTINUE
        GOTO 309
      ENDIF
      NCHAR=8
      NDATA=5
      DO 3 ICOND=1,NCONDA
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NDATA,NALPRT)
      if((itrap.eq.1).and.(jherr.ne.0)) return
      IPOS=data(1)+INITPS
      DO 133 ICH=1,8
      IF(ICHAR(ICH).NE.NAME(ICH,NORLST(IPOS))) THEN
                    WRITE(IOUT,99133)ICHAR,IPOS
99133 FORMAT('  MONITOR ',8A1,' IS NOT AT POSITION ',I6,' RUN STOPPED ')
                    CALL HALT(203)
                    return
      ENDIF
  133 CONTINUE
      IF(KODE(NORLST(IPOS)).NE.13) THEN
           WRITE(IOUT,99134)ICHAR,IPOS
99134 FORMAT(' ELEMENT ',8A1,' AT ',I6,' IS NOT A MONITOR, ',
     >'RUN IS STOPPED ')
           CALL HALT(203)
           return
      ENDIF
C  PLACE THE MONITORS IN INCREASING ORDER OF POSITION
      IPL=ICOND
      IF(ICOND.EQ.1)GOTO 32
      ICM1=ICOND-1
      DO 31 ICC=1,ICM1
      IF(IPOS.LT.NMONA(ICC))GOTO 33
   31 CONTINUE
      GOTO 32
C MOVE REST OF LIST TO INSERT NEW MONITOR
   33 ISC=ICOND-ICC
      DO 34 ICSC=1,ISC
      IND=ICOND-ICSC
      INDP1=IND+1
      NMONA(INDP1)=NMONA(IND)
      NVALA(INDP1)=NVALA(IND)
      VALFA(INDP1)=VALFA(IND)
      WGHTA(INDP1)=WGHTA(IND)
   34 ERRA(INDP1)=ERRA(IND)
      IPL=ICC
C PLACE NEW MONITOR
   32 NMONA(IPL)=IPOS
      NVALA(IPL)=data(2)
      ITEST=NVALA(IPL)-1
      IF(MOD(ITEST,4).GE.2)NSIG=1
      VALFA(IPL)=data(3)
      WGHTA(IPL)=data(4)
      ERRA(IPL)=data(5)
    3 CONTINUE
  307 IF(IMOSTP.EQ.-1)THEN
           IF(NOPTER.GT.10) THEN
                IMSVTP=1
                IMSDSV=1
                nopter=nopter-10
                         ELSE
                IMSVTP=0
                IMSDSV=ISEED
           ENDIF
      ENDIF
      IF(IMOSTP.EQ.0)THEN
           IF(NOPTER.GT.10) THEN
                IMSVTP=1
                IMSDSV=1
                nopter=nopter-10
                         ELSE
           ENDIF
      ENDIF
      IF(IMOSTP.GT.0)THEN
           IF(NOPTER.GT.10) THEN
                nopter=nopter-10
                         ELSE
                IMSVTP=0
                IMSDSV=ISEED
           ENDIF
      ENDIF
      IMOOPT=NOPTER
      IF(NOPTER.EQ.0)GOTO 333
      RMOSIG=2.0D0
      IF((NOPTER.LT.0).OR.(NOPTER.GT.4)) THEN
                WRITE(IOUT,55555)
55555 FORMAT(/,' ERROR IN MONITOR ERROR OPTION NUMBER ')
      CALL HALT(204)
      return
      ENDIF
      IF(NOPTER.EQ.4) THEN
           RMOSIG=6.0D0
           IMOOPT=3
      ENDIF
  333 MONLST=NMONA(NCONDA)
COLLECT INFORMATION ABOUT ASSOCIATED PARAMETERS
      NCHAR=0
      NDATA=1
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NDATA,NALPRT)
      if((itrap.eq.1).and.(jherr.ne.0)) return
      NASP=data(1)
      IF(NASP.EQ.0)GOTO 50
      DO 4 IASP=1,NASP
      NDATA=0
      NCHAR=8
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NDATA,NALPRT)
      if((itrap.eq.1).and.(jherr.ne.0)) return
      CALL ELID(ICHAR,NELID)
      if((itrap.eq.1).and.(jherr.ne.0)) return
      NDATA=1
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NDATA,NALPRT)
      if((itrap.eq.1).and.(jherr.ne.0)) return
      CALL DIMPAR(NELID,ICHAR,IDICT)
      if((itrap.eq.1).and.(jherr.ne.0)) return
      IPAR=IDICT
CHECK IF NAME IS IN BASE LIST OF VARIED ELEMENTS
      DO 41 IEL=1,NVARA
      IF((NELID.EQ.NELFA(IEL,1)).AND.(IPAR.EQ.NPARA(IEL,1)))GO TO 42
   41 CONTINUE
      WRITE(IOUT,99990)ICHAR,NELID,IPAR,(NELFA(IN,1),IN=1,NVARA),
     >(NPARA(IN,1),IN=1,NVARA)
99990 FORMAT(/,' ELEMENT NAME AND PARAMETER # IS NOT IN BASE LIST',
     >' OF VARIED ELEMENTS',/,' ',8A1,26I6)
      CALL HALT(205)
      return
   42 JPAS=IEL
      NPAS=data(1)+1
      NPVARA(JPAS)=NPAS
      DO 5 KPAS=2,NPAS
      NCHAR=8
      NDATA=0
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NDATA,NALPRT)
      if((itrap.eq.1).and.(jherr.ne.0)) return
      CALL ELID(ICHAR,NELID)
      if((itrap.eq.1).and.(jherr.ne.0)) return
C CHECK FOR LOCATION OF VARIED ELEMENT
      CALL POSCHK(NELID,IPOSCH)
      if((itrap.eq.1).and.(jherr.ne.0)) return
C SET FIRST FLAG
      IF(IAFRST.GT.IPOSCH)IAFRST=IPOSCH
      NELFA(JPAS,KPAS)=NELID
      NCHAR=8
      NDATA=2
      IF((IASP.EQ.NASP).AND.(KPAS.EQ.NPAS))NDATA=-1
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NDATA,NALPRT)
      if((itrap.eq.1).and.(jherr.ne.0)) return
      CALL DIMPAR(NELID,ICHAR,IDICT)
      if((itrap.eq.1).and.(jherr.ne.0)) return
      NPARA(JPAS,KPAS)=IDICT
      AMULTA(JPAS,KPAS)=data(1)
      ADDA(JPAS,KPAS)=data(2)
    5 CONTINUE
    4 CONTINUE
   50 CONTINUE
      IF((NALPRT.EQ.1).AND.(NOUT.GE.3).AND.(NFIT.EQ.3))
     > WRITE(IOUT,88886)(NMONA(IAA),IAA=1,NCONDA)
88886 FORMAT(/,' MONITOR POSITIONS ARE : ',//,10(2X,10I7,/))
C SET UP INITIAL VALUES OF PARAMETERS AND COMPUTE ADDRESSES
      IF(NPARC.EQ.0)GOTO 80
      DO 6 IFLA=1,NPARC
      JFF=NPVARA(IFLA)
      DO 6 JFLA=1,JFF
      NELV=NELFA(IFLA,JFLA)
      INDA(IFLA,JFLA)=IADR(NELV)+NPARA(IFLA,JFLA)-1
    6 CONTINUE
      DO 200 IAA=1,NPARC
      VAL=ELDAT(INDA(IAA,1))
      JF=NPVARA(IAA)
      DO 210 JAA=1,JF
      ELDAT(INDA(IAA,JAA))=VAL*AMULTA(IAA,JAA)+ADDA(IAA,JAA)
      CALL MATGEN(NELFA(IAA,JAA))
  210 CONTINUE
  200 CONTINUE
   80 IF((NALPRT.EQ.1).AND.(NOUT.GE.3))
     <WRITE(IOUT,88884)(VALFA(IAA),IAA=1,NCONDA)
88884 FORMAT(/,'  THE REQUESTED VALUES ARE :',//,15(2X,4E16.7,/))
C COMPUTE INITIAL VALUES OF MONITOR READOUTS AND PLACE IN VAL0
      IF(NSIG.EQ.0)GOTO 81
      NH=1
      NV=1
      NVH=1
   81 IALFLG=1
      if((itrap.eq.1).and.(jherr.ne.0)) return
      CALL DETAIL(IEND)
      IALFLG=2
      IMOSTP=IMSVTP
      IMSD=IMSDSV
      CALL DETAIL(IEND)
      DO 40 IAA=1,NCONDA
      JV=(NVALA(IAA)-1)/4 + 1
      IV=NVALA(IAA)-(JV-1)*4
   40 VAL0(IAA)=VALMON(IAA,IV,JV)
      IF((NALPRT.EQ.1).AND.(NOUT.GE.3))
     >WRITE(IOUT,88882)(VAL0(IAA),IAA=1,NCONDA)
88882 FORMAT(/,'  THE INITIAL VALUES ARE :',//,15(2X,4E16.7,/))
      NITT=NSTEP+NIT
      WVA=0.0D0
      DO 17 IC=1,NCONDA
   17 WVA=WVA+WGHTA(IC)**2
      WVA=DSQRT(WVA)
      DO 9 IS=1,NITT
      NDIV=NSTEP-IS+1
      IF(NDIV.LT.1)NDIV=1
      DO 10 I =1,NCONDA
   10 VALR(I)=VAL0(I)-(VAL0(I)-VALFA(I))/NDIV
      IF(NFIT.EQ.1) GOTO 15
      INFO=200
      NFEV=-10
      LDFJAC=NCONDA
      FTOL=TOLLSQ
      MODE=1
      FACTOR=100.0D0
      NMPRNT=100
      GOTO 16
   15 IF(IS.LE.NSTEP)GOTO 14
      DO 12 I=1,NVARA
   12 DELA(I)=DELA(I)/5
   14 CONTINUE
      IF(NFIT.EQ.1)GOTO 90
   16 IPRINT=0
      DO 110 IFL=1,NVARA
      EA(IFL)=DELA(IFL)
      IF(IFL.LE.NPARC)GOTO 101
      XA(IFL)=CORVAL(NELFA(IFL,1),NPARA(IFL,1))
      GOTO 110
  101 XA(IFL)=ELDAT(INDA(IFL,1))
  110 CONTINUE
 1001 FTOL=FTOL/30.0D0
      XTOL=FTOL
      GTOL=FTOL
      EPSFCN=FTOL
      MAXFEV=NVARA*IS*NIT*MAXFAC
      CALL LMDIF(FALCT,NCONDA,NVARA,XA,FVEC,FTOL,XTOL,GTOL,MAXFEV,
     >EPSFCN,DIAG,MODE,FACTOR,NMPRNT,INFO,NFEV,FJAC,LDFJAC,
     >IPVT,QTF,WA1,WA2,WA3,WA4)
      CALL LMDMES(INFO,NFEV)
      F=0.0D0
      DO 3010 IC=1,NCONDA
 3010 F=F+(FVEC(IC))**2
      F=DSQRT(F)
      F=F/WVA
      IF((NALPRT.EQ.1).AND.(NOUT.GE.1))
     >WRITE(IOUT,98899)IS,F
      IF((NALPRT.EQ.1).AND.(NOUT.GE.1).AND.(ISO.NE.0))
     >WRITE(ISOUT,98899)IS,F
98899 FORMAT(' AFTER STEP ',I4,' THE FIT FUNCTION VALUE IS ',E14.6)
      DO 102 IFL=1,NVARA
      IF(IFL.LE.NPARC)GOTO 103
      CORVAL(NELFA(IFL,1),NPARA(IFL,1))=XA(IFL)
      GOTO 102
  103 ELDAT(INDA(IFL,1))=XA(IFL)
      JFL=NPVARA(IFL)
      DO 105 JAA=1,JFL
      ELDAT(INDA(IFL,JAA))=XA(IFL)*AMULTA(IFL,JAA)+ADDA(IFL,JAA)
  105 CALL MATGEN(NELFA(IFL,JAA))
  102 CONTINUE
      GOTO 77
   90 DO 74 I=1,NVARA
      IF(I.LE.NPARC)GOTO 27
      CORVAL(NELFA(I,1),NPARA(I,1))=CORVAL(NELFA(I,1),NPARA(I,1))+
     >DELA(I)
      GOTO 28
   27 VAL=ELDAT(INDA(I,1))+DELA(I)
      JF=NPVARA(I)
      DO 220 JAA=1,JF
      ELDAT(INDA(I,JAA))=VAL*AMULTA(I,JAA)+ADDA(I,JAA)
      CALL MATGEN(NELFA(I,JAA))
  220 CONTINUE
   28 IMOSTP=IMSVTP
      IMSD=IMSDSV
      CALL DETAIL(IEND)
      DO 75 IV=1,NCONDA
      JVV=(NVALA(IV)-1)/4 + 1
      IVV=NVALA(IV)-(JVV-1)*4
   75 VALMAT((IV-1)*NCONDA+I)=(VALMON(IV,IVV,JVV)-VAL0(IV))
     >/DELA(I)
      IF(I.LE.NPARC)GOTO 29
      CORVAL(NELFA(I,1),NPARA(I,1))=CORVAL(NELFA(I,1),NPARA(I,1))-
     >DELA(I)
      GOTO 74
   29 VAL=ELDAT(INDA(I,1))-DELA(I)
      JF=NPVARA(I)
      DO 230 JAA=1,JF
      ELDAT(INDA(I,JAA))=VAL*AMULTA(I,JAA)+ADDA(I,JAA)
      CALL MATGEN(NELFA(I,JAA))
  230 CONTINUE
   74 CONTINUE
      CALL DMINV(VALMAT,NVARA,D,LV,MV)
      DO 26 I=1,NVARA
   26 DVAL(I)=VALR(I)-VAL0(I)
      DO 7 I=1,NVARA
      QVAL(I)=0.0D0
      DO 8 J=1,NVARA
    8 QVAL(I)=QVAL(I)+VALMAT((I-1)*NVARA+J)*DVAL(J)
      IF(I.LE.NPARC)GOTO 70
      CORVAL(NELFA(I,1),NPARA(I,1))=CORVAL(NELFA(I,1),NPARA(I,1))+
     >QVAL(I)
      GOTO 7
   70 VAL = ELDAT(INDA(I,1))+QVAL(I)
      JF=NPVARA(I)
      DO 240 JAA=1,JF
      ELDAT(INDA(I,JAA))=VAL*AMULTA(I,JAA)+ADDA(I,JAA)
      CALL MATGEN(NELFA(I,JAA))
  240 CONTINUE
    7 CONTINUE
   77 IMOSTP=IMSVTP
      IMSD=IMSDSV
      CALL DETAIL(IEND)
      DO 11 I=1,NCONDA
      JAA=(NVALA(I)-1)/4 + 1
      IAA=NVALA(I)-(JAA-1)*4
   11 VAL0(I)=VALMON(I,IAA,JAA)
      IMSVTP=IMOSTP
      IMSDSV=IMSD
    9 CONTINUE
      IF((NALPRT.EQ.1).AND.(NOUT.GE.3))
     >WRITE(IOUT,88885)(VAL0(IAA),IAA=1,NCONDA)
88885 FORMAT(/,'  THE ACHIEVED VALUES ARE :',//,15(2X,4E16.7,/))
      IF((NALPRT.EQ.1).AND.(NOUT.GE.1))
     >WRITE(IOUT,10011)
10011 FORMAT(//,' THE FITTED PARAMETERS ARE : ')
      DO 60 IP=1,NVARA
      IF(IP.LE.NPARC)GOTO 71
      IF((IP.EQ.(NPARC+1)).AND.(NALPRT.EQ.1).AND.(NOUT.GE.1))
     >WRITE(IOUT,10012)
10012 FORMAT(/,'  CORRECTOR SETTINGS ',/)
      NCCOR=NELFA(IP,1)
      IF((NALPRT.EQ.1).AND.(NOUT.GE.1))
     >WRITE(IOUT,10013)NPARA(IP,1),(NAME(IN,ICRID(NCCOR)),IN=1,8),
     >NCCOR,ICRPOS(NCCOR),CORVAL(NCCOR,
     >NPARA(IP,1))
10013 FORMAT(' PARM',I5,' OF ',8A1,' CORR',I5,' AT POS :'
     <,I5,' IS:',E22.14)
      GOTO 60
   71 IAPF=NPVARA(IP)
      DO 61 IAP=1,IAPF
      NELV=NELFA(IP,IAP)
      IF((NALPRT.EQ.1).AND.(NOUT.GE.1))
     >WRITE(IOUT,10010)NPARA(IP,IAP)
     >,(NAME(J,NELV),J=1,8)
     >,ELDAT(INDA(IP,IAP))
10010 FORMAT('  PARAMETER # ',I3,' OF ',8A1,' = ',E22.14)
   61 CONTINUE
   60 CONTINUE
      IALFLG=0
      MONFLG=0
      IF(NFLPRT.EQ.1)NALPRT=NFLPRT
      RETURN
      END
      SUBROUTINE ANAL
C     *************************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      COMMON/ANALC/COMPF,RNU0X,CETAX,CETAPX,CALPHX,CBETAX,
     1RMU1X,CHROMX,ALPH1X,BETA1X,
     1RMU0Y,RNU0Y,CETAY,CETAPY,CALPHY,CBETAY,
     1RMU1Y,CHROMY,ALPH1Y,BETA1Y,RMU0X,CDETAX,CDETPX,CDETAY,CDETPY,
     >COSX,ALX1,ALX2,VX1,VXP1,VX2,VXP2,
     >COSY,ALY1,ALY2,VY1,VYP1,VY2,VYP2,NSTABX,NSTABY,NSTAB,NWRNCP
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      COMMON/LNGTH/TLENG,ALENG(MXELMD),ACLENG(MAXPOS)
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      DIMENSION C(16),ETA(4),ETA1(4)
      NSTABX=0
      NSTABY=0
      NSTAB=0
      NWRNCP=0
c      DET1=DABS(TEMP(1,3)*TEMP(2,4)-TEMP(1,4)*TEMP(2,3))
c      DET2=DABS(TEMP(3,1)*TEMP(4,2)-TEMP(3,2)*TEMP(4,1))
c      EPS=DET1+DET2
      eps=dabs(temp(1,3))+dabs(temp(1,4))
     >   +dabs(temp(2,3))+dabs(temp(2,4))
      IF(EPS.GT.1.0D-04)NWRNCP=1
      DO 561 IM=1,4
      ETA(IM)=-TEMP(IM,6)
      DO 561 JM=1,4
      IC=(IM-1)*4 +JM
      C(IC)=TEMP(JM,IM)
  561 IF(IM.EQ.JM)C(IC)=C(IC)-1.0D0
      CALL DSIMQ (C,ETA,4,KS)
      IF(KS.NE.1) GO TO 562
      WRITE(IOUT,563)
      IF(ISO.NE.0)WRITE(ISOUT,563)
563   FORMAT(/,' SINGULAR SET OF EQUATIONS SENT TO DSIMQ',/)
      NSTAB=1
C      CALL HALT(320)
      RETURN
  562 IF(NORDER.EQ.1) GO TO 564
      A110=2.0D0*TEMP(1,7)*ETA(1)+TEMP(1,8)*ETA(2)+TEMP(1,9)*ETA(3)
     >+TEMP(1,10)*ETA(4) +TEMP(1,12)
      A214=TEMP(2,8)*ETA(1)+2.0D0*TEMP(2,13)*ETA(2)+TEMP(2,14)*ETA(3)
     >+TEMP(2,15)*ETA(4)+TEMP(2,17)
      A317=TEMP(3,9)*ETA(1)+TEMP(3,14)*ETA(2)+2.0D0*TEMP(3,18)*ETA(3)
     >+TEMP(3,19)*ETA(4) +TEMP(3,21)
      A419=TEMP(4,10)*ETA(1)+TEMP(4,15)*ETA(2)+TEMP(4,19)*ETA(3)
     >+2.0D0*TEMP(4,22)*ETA(4)+TEMP(4,24)
      A114=TEMP(1,8)*ETA(1)+2.0D0*TEMP(1,13)*ETA(2)+TEMP(1,14)*ETA(3)
     >+TEMP(1,15)*ETA(4)+TEMP(1,17)
      A319=TEMP(3,10)*ETA(1)+TEMP(3,15)*ETA(2)+TEMP(3,19)*ETA(3)
     >+2.0D0*TEMP(3,22)*ETA(4)+TEMP(3,24)
      DO 565 IET=1,4
      ETA1(IET)=-TEMP(IET,7)*ETA(1)*ETA(1)-TEMP(IET,8)*ETA(1)*ETA(2)
     >       -TEMP(IET,9)*ETA(1)*ETA(3)-TEMP(IET,10)*ETA(1)*ETA(4)
     >       -TEMP(IET,12)*ETA(1)
     >       -TEMP(IET,13)*ETA(2)*ETA(2)-TEMP(IET,14)*ETA(2)*ETA(3)
     >       -TEMP(IET,15)*ETA(2)*ETA(4)-TEMP(IET,17)*ETA(2)
     >       -TEMP(IET,18)*ETA(3)*ETA(3)-TEMP(IET,19)*ETA(3)*ETA(4)
     >       -TEMP(IET,21)*ETA(3)
     >       -TEMP(IET,22)*ETA(4)*ETA(4)-TEMP(IET,24)*ETA(4)
     >       -TEMP(IET,27)
      DO 565 JM=1,4
      IC=(IET-1)*4 +JM
      C(IC)=TEMP(JM,IET)
  565 IF(IET.EQ.JM)C(IC)=C(IC)-1.0D0
      CALL DSIMQ (C,ETA1,4,KS)
  564 COSX=.5D0*(TEMP(1,1)+TEMP(2,2))
      CETAX=ETA(1)
      CETAPX=ETA(2)
      CETAY=ETA(3)
      CETAPY=ETA(4)
      CDETAX=ETA1(1)
      CDETPX=ETA1(2)
      CDETAY=ETA1(3)
      CDETPY=ETA1(4)
      IF (TLENG.EQ.0.0D0)GOTO 10
      COMPF=(TEMP(5,1)*CETAX+TEMP(5,2)*CETAPX+TEMP(5,6))/TLENG
      GOTO 11
   10 WRITE(IOUT,99999)
99999 FORMAT(/,' LENGTH IS ZERO: COMPACTION FACTOR CANNOT BE COMPUTED',
     >/)
      COMPF=0.0D0
   11 IF(DABS( COSX).GE.1.0D0)GOTO 1
      SIN=DSQRT(1- COSX* COSX)
      SIN=DSIGN(SIN,TEMP(1,2))
      RMU0X=DATAN2(SIN, COSX)
      IF(RMU0X.LT.0.0D0)RMU0X=TWOPI+RMU0X
      CBETAX=TEMP(1,2)/SIN
      CALPHX=.5D0*(TEMP(1,1)-TEMP(2,2))/SIN
      RNU0X=RMU0X/TWOPI
      IF (NORDER.EQ.1) GO TO 2
      RMU1X=-.5D0*(A110+A214)/SIN
      CHROMX=RMU1X/TWOPI
      BETA1X=(A114-CBETAX* COSX*RMU1X)/SIN
      ALPH1X=(.5D0*(A110-A214)-RMU1X*CALPHX* COSX)/SIN
    2 COSY=.5D0*(TEMP(3,3)+TEMP(4,4))
      IF(DABS(COSY).GE.1.0D0)GOTO 3
      SIN=DSQRT(1-COSY*COSY)
      SIN=DSIGN(SIN,TEMP(3,4))
      RMU0Y=DATAN2(SIN,COSY)
      IF(RMU0Y.LT.0.0D0)RMU0Y=TWOPI+RMU0Y
      CBETAY=TEMP(3,4)/SIN
      CALPHY=.5D0*(TEMP(3,3)-TEMP(4,4))/SIN
      RNU0Y=RMU0Y/TWOPI
      IF (NORDER.EQ.1) GO TO 4
      RMU1Y=-.5D0*(A317+A419)/SIN
      CHROMY=RMU1Y/TWOPI
      BETA1Y=(A319-CBETAY*COSY*RMU1Y)/SIN
      ALPH1Y=(.5D0*(A317-A419)-RMU1Y*CALPHY*COSY)/SIN
    4 RETURN
    1 NSTABX=1
      IF(COSX.EQ.1) GOTO 5
      ALX1 = COSX + DSQRT(COSX*COSX-1)
      ALX2 = COSX - DSQRT(COSX*COSX-1)
      A12=TEMP(1,2)
      A11=TEMP(1,1)
      VXP1=A11-ALX1
      DENOM=DSQRT(A12*A12+VXP1*VXP1)
      VX1=-A12/DENOM
      VXP1=VXP1/DENOM
      VXP2=A11-ALX2
      DENOM=DSQRT(A12*A12+VXP2*VXP2)
      VX2=-A12/DENOM
      VXP2=VXP2/DENOM
      GOTO 2
    5 NSTABX = 2
      GOTO 2
    3 NSTABY=1
      IF(COSY.EQ.1) GOTO 6
      ALY1 = COSY + DSQRT(COSY*COSY-1)
      ALY2 = COSY - DSQRT(COSY*COSY-1)
      A34=TEMP(3,4)
      A33=TEMP(3,3)
      VYP1=A33-ALY1
      DENOM=DSQRT(A34*A34+VYP1*VYP1)
      VY1=-A34/DENOM
      VYP1=VYP1/DENOM
      VYP2=A33-ALY2
      DENOM=DSQRT(A34*A34+VYP2*VYP2)
      VY2=-A34/DENOM
      VYP2=VYP2/DENOM
      GOTO 4
    6 NSTABY = 2
      GOTO 4
      END
      SUBROUTINE ARBIT(IAD,NEL)
C     *************************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/ARB/PARA(20),NarT(MXPART),NARBP
      NarbP=IADR(NEL+1)-IAD-1
      IF(NarbP.GT.20)WRITE(IOUT,10000)
      IF(NarbP.GT.20)NarbP=20
      DO 1 IP=1,NarbP
    1 PARA(IP)=ELDAT(IAD+IP)
      RETURN
10000 FORMAT(/,'  NUMBER OF PARAMETERS IN ARBITRARY ELEMENT GREATER',
     >' THAN 20',/,'   ONLY THE FIRST 20 ARE KEPT, JOB PROCEEDS', /)
      END
      SUBROUTINE BANDR(NM,N,MB,A,D,E,E2,MATZ,Z)
C*************************************************
      INTEGER J,K,L,N,R,I1,I2,J1,J2,KR,MB,MR,M1,NM,N2,R1,UGL,MAXL,MAXR
      REAL*8 A(NM,MB),D(N),E(N),E2(N),Z(NM,N)
      REAL*8 G,U,B1,B2,C2,F1,F2,S2,DMIN,DMINRT
      REAL*8 DSQRT
      INTEGER MAX0,MIN0,MOD
      LOGICAL MATZ
C
C     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE BANDRD,
C     NUM. MATH. 12, 231-241(1968) BY SCHWARZ.
C     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 273-283(1971).
C
C     THIS SUBROUTINE REDUCES A REAL SYMMETRIC BAND MATRIX
C     TO A SYMMETRIC TRIDIAGONAL MATRIX USING AND OPTIONALLY
C     ACCUMULATING ORTHOGONAL SIMILARITY TRANSFORMATIONS.
C
C     ON INPUT:
C
C        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
C          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
C          DIMENSION STATEMENT;
C
C        N IS THE ORDER OF THE MATRIX;
C
C        MB IS THE (HALF) BAND WIDTH OF THE MATRIX, DEFINED AS THE
C          NUMBER OF ADJACENT DIAGONALS, INCLUDING THE PRINCIPAL
C          DIAGONAL, REQUIRED TO SPECIFY THE NON-ZERO PORTION OF THE
C          LOWER TRIANGLE OF THE MATRIX;
C
C        A CONTAINS THE LOWER TRIANGLE OF THE SYMMETRIC BAND INPUT
C          MATRIX STORED AS AN N BY MB ARRAY.  ITS LOWEST SUBDIAGONAL
C          IS STORED IN THE LAST N+1-MB POSITIONS OF THE FIRST COLUMN,
C          ITS NEXT SUBDIAGONAL IN THE LAST N+2-MB POSITIONS OF THE
C          SECOND COLUMN, FURTHER SUBDIAGONALS SIMILARLY, AND FINALLY
C          ITS PRINCIPAL DIAGONAL IN THE N POSITIONS OF THE LAST COLUMN.
C          CONTENTS OF STORAGES NOT PART OF THE MATRIX ARE ARBITRARY;
C
C        MATZ SHOULD BE SET TO .TRUE. IF THE TRANSFORMATION MATRIX IS
C          TO BE ACCUMULATED, AND TO .FALSE. OTHERWISE.
C
C     ON OUTPUT:
C
C        A HAS BEEN DESTROYED, EXCEPT FOR ITS LAST TWO COLUMNS WHICH
C          CONTAIN A COPY OF THE TRIDIAGONAL MATRIX;
C
C        D CONTAINS THE DIAGONAL ELEMENTS OF THE TRIDIAGONAL MATRIX;
C
C        E CONTAINS THE SUBDIAGONAL ELEMENTS OF THE TRIDIAGONAL
C          MATRIX IN ITS LAST N-1 POSITIONS.  E(1) IS SET TO ZERO;
C
C        E2 CONTAINS THE SQUARES OF THE CORRESPONDING ELEMENTS OF E.
C          E2 MAY COINCIDE WITH E IF THE SQUARES ARE NOT NEEDED;
C
C        Z CONTAINS THE ORTHOGONAL TRANSFORMATION MATRIX PRODUCED IN
C          THE REDUCTION IF MATZ HAS BEEN SET TO .TRUE.  OTHERWISE, Z
C          IS NOT REFERENCED.
C
C     QUESTIONS AND COMMENTS SHOULD BE DIRECTED TO B. S. GARBOW,
C     APPLIED MATHEMATICS DIVISION, ARGONNE NATIONAL LABORATORY
C
C     ------------------------------------------------------------------
C
      DMIN = 2.0D0**(-64)
      DMINRT = 2.0D0**(-32)
C     :::::::::: INITIALIZE DIAGONAL SCALING MATRIX ::::::::::
      DO 30 J = 1, N
   30 D(J) = 1.0D0
C
      IF (.NOT. MATZ) GO TO 60
C
      DO 50 J = 1, N
C
         DO 40 K = 1, N
   40    Z(J,K) = 0.0D0
C
         Z(J,J) = 1.0D0
   50 CONTINUE
C
   60 M1 = MB - 1
      IF (M1 - 1) 900, 800, 70
   70 N2 = N - 2
C
      DO 700 K = 1, N2
         MAXR = MIN0(M1,N-K)
C     :::::::::: FOR R=MAXR STEP -1 UNTIL 2 DO -- ::::::::::
         DO 600 R1 = 2, MAXR
            R = MAXR + 2 - R1
            KR = K + R
            MR = MB - R
            G = A(KR,MR)
            A(KR-1,1) = A(KR-1,MR+1)
            UGL = K
C
            DO 500 J = KR, N, M1
               J1 = J - 1
               J2 = J1 - 1
               IF (G .EQ. 0.0D0) GO TO 600
               B1 = A(J1,1) / G
               B2 = B1 * D(J1) / D(J)
               S2 = 1.0D0 / (1.0D0 + B1 * B2)
               IF (S2 .GE. 0.5D0 ) GO TO 450
               B1 = G / A(J1,1)
               B2 = B1 * D(J) / D(J1)
               C2 = 1.0D0 - S2
               D(J1) = C2 * D(J1)
               D(J) = C2 * D(J)
               F1 = 2.0D0 * A(J,M1)
               F2 = B1 * A(J1,MB)
               A(J,M1) = -B2 * (B1 * A(J,M1) - A(J,MB)) - F2 + A(J,M1)
               A(J1,MB) = B2 * (B2 * A(J,MB) + F1) + A(J1,MB)
               A(J,MB) = B1 * (F2 - F1) + A(J,MB)
C
               DO 200 L = UGL, J2
                  I2 = MB - J + L
                  U = A(J1,I2+1) + B2 * A(J,I2)
                  A(J,I2) = -B1 * A(J1,I2+1) + A(J,I2)
                  A(J1,I2+1) = U
  200          CONTINUE
C
               UGL = J
               A(J1,1) = A(J1,1) + B2 * G
               IF (J .EQ. N) GO TO 350
               MAXL = MIN0(M1,N-J1)
C
               DO 300 L = 2, MAXL
                  I1 = J1 + L
                  I2 = MB - L
                  U = A(I1,I2) + B2 * A(I1,I2+1)
                  A(I1,I2+1) = -B1 * A(I1,I2) + A(I1,I2+1)
                  A(I1,I2) = U
  300          CONTINUE
C
               I1 = J + M1
               IF (I1 .GT. N) GO TO 350
               G = B2 * A(I1,1)
  350          IF (.NOT. MATZ) GO TO 500
C
               DO 400 L = 1, N
                  U = Z(L,J1) + B2 * Z(L,J)
                  Z(L,J) = -B1 * Z(L,J1) + Z(L,J)
                  Z(L,J1) = U
  400          CONTINUE
C
               GO TO 500
C
  450          U = D(J1)
               D(J1) = S2 * D(J)
               D(J) = S2 * U
               F1 = 2.0D0 * A(J,M1)
               F2 = B1 * A(J,MB)
               U = B1 * (F2 - F1) + A(J1,MB)
               A(J,M1) = B2 * (B1 * A(J,M1) - A(J1,MB)) + F2 - A(J,M1)
               A(J1,MB) = B2 * (B2 * A(J1,MB) + F1) + A(J,MB)
               A(J,MB) = U
C
               DO 460 L = UGL, J2
                  I2 = MB - J + L
                  U = B2 * A(J1,I2+1) + A(J,I2)
                  A(J,I2) = -A(J1,I2+1) + B1 * A(J,I2)
                  A(J1,I2+1) = U
  460          CONTINUE
C
               UGL = J
               A(J1,1) = B2 * A(J1,1) + G
               IF (J .EQ. N) GO TO 480
               MAXL = MIN0(M1,N-J1)
C
               DO 470 L = 2, MAXL
                  I1 = J1 + L
                  I2 = MB - L
                  U = B2 * A(I1,I2) + A(I1,I2+1)
                  A(I1,I2+1) = -A(I1,I2) + B1 * A(I1,I2+1)
                  A(I1,I2) = U
  470          CONTINUE
C
               I1 = J + M1
               IF (I1 .GT. N) GO TO 480
               G = A(I1,1)
               A(I1,1) = B1 * A(I1,1)
  480          IF (.NOT. MATZ) GO TO 500
C
               DO 490 L = 1, N
                  U = B2 * Z(L,J1) + Z(L,J)
                  Z(L,J) = -Z(L,J1) + B1 * Z(L,J)
                  Z(L,J1) = U
  490          CONTINUE
C
  500       CONTINUE
C
  600    CONTINUE
C
         IF (MOD(K,64) .NE. 0) GO TO 700
C     :::::::::: RESCALE TO AVOID UNDERFLOW OR OVERFLOW ::::::::::
         DO 650 J = K, N
            IF (D(J) .GE. DMIN) GO TO 650
            MAXL = MAX0(1,MB+1-J)
C
            DO 610 L = MAXL, M1
  610       A(J,L) = DMINRT * A(J,L)
C
            IF (J .EQ. N) GO TO 630
            MAXL = MIN0(M1,N-J)
C
            DO 620 L = 1, MAXL
               I1 = J + L
               I2 = MB - L
               A(I1,I2) = DMINRT * A(I1,I2)
  620       CONTINUE
C
  630       IF (.NOT. MATZ) GO TO 645
C
            DO 640 L = 1, N
  640       Z(L,J) = DMINRT * Z(L,J)
C
  645       A(J,MB) = DMIN * A(J,MB)
            D(J) = D(J) / DMIN
  650    CONTINUE
C
  700 CONTINUE
C     :::::::::: FORM SQUARE ROOT OF SCALING MATRIX ::::::::::
  800 DO 810 J = 2, N
  810 E(J) = DSQRT(D(J))
C
      IF (.NOT. MATZ) GO TO 840
C
      DO 830 J = 1, N
C
         DO 820 K = 2, N
  820    Z(J,K) = E(K) * Z(J,K)
C
  830 CONTINUE
C
  840 U = 1.0D0
C
      DO 850 J = 2, N
         A(J,M1) = U * E(J) * A(J,M1)
         U = E(J)
         E2(J) = A(J,M1) ** 2
         A(J,MB) = D(J) * A(J,MB)
         D(J) = A(J,MB)
         E(J) = A(J,M1)
  850 CONTINUE
C
      D(1) = A(1,MB)
      E(1) = 0.0D0
      E2(1) = 0.0D0
      GO TO 1001
C
  900 DO 950 J = 1, N
         D(J) = A(J,MB)
         E(J) = 0.0D0
         E2(J) = 0.0D0
  950 CONTINUE
C
 1001 RETURN
C     :::::::::: LAST CARD OF BANDR ::::::::::
      END
       FUNCTION BANG(I)
C      ****************
       IMPLICIT REAL*8(A-H,O-Z)
       BANG = 1.
       IF(I.EQ.0)RETURN
       DO 1 J=1,I
       BANG = BANG*J
1      CONTINUE
       RETURN
       END
      SUBROUTINE BASE(IEND)
C     *************************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/LNGTH/TLENG,ALENG(MXELMD),ACLENG(MAXPOS)
      PARAMETER  (mxmis = 1000)
      COMMON/MIS/RMISA(8,MXMIS),MISELE(MXMIS),NMIS,NOPT,
     >NMISE,MISSEL(MXMIS),NMRNGE(MXMIS),
     >MSRNGE(2,10,MXMIS),MISFLG,MCHFLG
      COMMON/CSEEDS/ISEED,IXG,IXS,IXMSTP,IMSD,IMOSTP,ISYNSD,ISYSTP,
     >ISDBEG,IBGSTP,IXES,IXESTP,IESBEG,IESTBG,isdcol
      parameter  (MAXBAS = 10)
      parameter  (MXSBAS = 40)
      common /cbase/albas(maxbas),alsbas(mxsbas),
     >npbas(maxbas),nelb(maxbas),npsbas(mxsbas),nelsb(mxsbas),
     >npen,nsub
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
      DIMENSION XBAS(10),YBAS(10),ZBAS(10)
      NCHAR=0
      NDIM=mxinp
      NDATA=1
      NIPR=1
      CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NIPR)
      NPEN=DATA(1)
      NCHAR=8
      NDATA=0
      DO 1 ICH=1,NPEN
      CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NIPR)
      CALL ELID(ICHAR,NELID)
      CALL ELPOS(ichar,NELPOS)
      NELB(ICH)=NELID
      NPBAS(ICH)=NELPOS
      ALBAS(ICH)=ACLENG(NELPOS)
    1 CONTINUE
      NCHAR=0
      NDIM=2
      NDATA=2
      CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NIPR)
      NSUB=DATA(1)
      SIG=DATA(2)
      NCHAR=8
      NDATA=0
      DO 2 ICH=1,NSUB
      CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NIPR)
      CALL ELID(ICHAR,NELID)
      CALL ELPOS(ichar,NELPOS)
      NELSB(ICH)=NELID
      NPSBAS(ICH)=NELPOS
      ALSBAS(ICH)=ACLENG(NELPOS)
    2 CONTINUE
      NCHAR=0
      NDATA=2
      CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NIPR)
      SIG1=DATA(1)
      SIG2=DATA(2)
      IXB=ISEED
      IF(NOUT.GE.3)
     >WRITE(IOUT,66666)(NELB(IW),NPBAS(IW),ALBAS(IW),IW=1,NPEN)
66666 FORMAT(' NELB,NPBAS,ALBAS,ARE',10(/,2I5,E12.3))
      IF(NOUT.GE.3)
     >WRITE(IOUT,55555)(NELSB(IW),NPSBAS(IW),ALSBAS(IW),IW=1,NSUB)
55555 FORMAT(' NELBS,NPSBAS,ALSBAS, ARE',15(/,2I5,E12.3))
      IF(ALBAS(1).EQ.0.0D0)GOTO 3
      WRITE(IOUT,10001)
10001 FORMAT(/,'  YOUR FORGOT TO USE A KICK AT THE BEGINNING',
     >' OF THE MACHINE',/)
      CALL HALT(210)
      return
    3 IF(ALBAS(NPEN).EQ.TLENG)GOTO 9
      WRITE(IOUT,10002)
10002 FORMAT(/,'  YOUR FORGOT TO USE A KICK AT THE END',
     >' OF THE MACHINE',/)
      CALL HALT(211)
      return
    9 XBAS(10)=0.0D0
      YBAS(10)=0.0D0
      ZBAS(10)=0.0D0
      DO 4 ICO=2,NPEN
    5 FACT = GAUSS(IXB)
      IF(DABS(FACT).GT.2.0D0)GOTO 5
      XBAS(ICO)=FACT*SIG
    6 FACT = GAUSS(IXB)
      IF(DABS(FACT).GT.2.0D0)GOTO 6
      YBAS(ICO)=FACT*SIG
    7 FACT = GAUSS(IXB)
      IF(DABS(FACT).GT.2.0D0)GOTO 7
      ZBAS(ICO)=FACT*SIG
      IF(NOUT.GE.3)
     >WRITE(IOUT,88888)ICO,NPBAS(ICO),NELB(ICO),XBAS(ICO)
     >,YBAS(ICO),ZBAS(ICO)
88888 FORMAT(3I7,3E14.5)
    4 CONTINUE
      PHI0=0.0D0
      IAF=NPEN-1
      DO 8 IA=1,IAF
C     WRITE(IOUT,88887)IA,XBAS(IA),ALBAS(IA)
88887 FORMAT(' IA XBAS ALBAS ARE :',I5,2E12.3)
      PHI1=DATAN2((XBAS(IA+1)-XBAS(IA)),(ALBAS(IA+1)-ALBAS(IA)))
      DPHI=PHI1-PHI0
      IF(NOUT.GE.3)
     >WRITE(IOUT,77777)PHI0,PHI1,DPHI
77777 FORMAT(3E14.5)
      IAD=IADR(NELB(IA))
      ELDAT(IAD+2)=DPHI
      PHI0=PHI1
    8 CONTINUE
      PHI0=0.0D0
      IAF=NPEN-1
      DO 10 IA=1,IAF
      PHI1=DATAN2((YBAS(IA+1)-YBAS(IA)),(ALBAS(IA+1)-ALBAS(IA)))
      DPHI=PHI1-PHI0
      IF(NOUT.GE.3)
     >WRITE(IOUT,77777)PHI0,PHI1,DPHI
      IAD=IADR(NELB(IA))
      ELDAT(IAD+4)=DPHI
      PHI0=PHI1
   10 CONTINUE
      X0=0.0D0
      PHI0=0.0D0
      IS=1
      IPF=NPEN-1
      DO 11 IP=1,IPF
      IFL=1
      N0=NPBAS(IP)
      NF=NPBAS(IP+1)
      AL0=ACLENG(N0)
      ALF=ACLENG(NF)
   12 FACT=GAUSS(IXB)
      IF(DABS(FACT).GT.2.0D0)GOTO 12
      ANG1=SIG1*FACT
   13 CONTINUE
      IF(IS.GT.NSUB)GOTO 14
      IF(NPSBAS(IS).GT.NF) GOTO 18
      N1=NPSBAS(IS)
      AL1=ACLENG(N1)
   15 FACT=GAUSS(IXB)
      IF(DABS(FACT).GT.2.0D0)GOTO 15
      ANG2=SIG2*FACT
      PHIB=-DATAN2(X0,ALF-AL0)
      PHI1=PHIB+ANG1+ANG2
      X1=X0+(AL1-AL0)*DTAN(PHI1)
      DPHI=PHI1-PHI0
      IF(NOUT.GE.3)
     >WRITE(IOUT,99999)IP,IS,AL0,AL1,ALF,ANG1,ANG2,
     >X0,X1,PHI0,PHI1,PHIB
99999 FORMAT(/,' IN BASE IP,IS,AL0,AL1,ALF,ANG1,ANG2,'
     >,'X0,X1,PHI0,PHI1,PHIB ARE',
     >//,2I4,2(/,5E14.5),/)
      IF(IFL.EQ.1)GOTO 16
      IAD=IADR(NELSB(IS-1))
      ELDAT(IAD+2)=DPHI
C     WRITE(IOUT,68888)IAD,ELDAT(IAD+2)
68888 FORMAT(' IAD,ELDAT ARE ',I6,E12.4)
      GOTO 17
   18 N1=NF
      AL1=ACLENG(N1)
   19 FACT=GAUSS(IXB)
      IF(DABS(FACT).GT.2.0D0)GOTO 19
      ANG2=SIG2*FACT
      PHIB=-DATAN2(X0,ALF-AL0)
      PHI1=PHIB+ANG1+ANG2
      X1=X0+(AL1-AL0)*DTAN(PHI1)
      DPHI=PHI1-PHI0
      IF(NOUT.GE.3)
     >WRITE(IOUT,99999)IP,IS,AL0,AL1,ALF,ANG1,ANG2,
     >X0,X1,PHI0,PHI1,PHIB
      IAD=IADR(NELSB(IS-1))
      ELDAT(IAD+2)=DPHI
C     WRITE(IOUT,68888)IAD,ELDAT(IAD+2)
      X0=X1
      PHI0=PHI1
      AL0=AL1
      GOTO 11
   16 IAD=IADR(NELB(IP))
      ELDAT(IAD+2)=ELDAT(IAD+2)+DPHI
C     WRITE(IOUT,68888)IAD,ELDAT(IAD+2)
      IFL=0
   17 X0=X1
      PHI0=PHI1
      AL0=AL1
      IS=IS+1
      GOTO 13
   11 CONTINUE
   14 N1=NF
      AL1=ACLENG(N1)
      PHIB=-DATAN2(X0,ALF-AL0)
      PHI1=PHIB
      ANG1=0.0D0
      ANG2=0.0D0
      X1=X0+(AL1-AL0)*DTAN(PHI1)
      DPHI=PHI1-PHI0
      IADS=IADR(NELSB(IS-1))
      ELDAT(IADS+2)=DPHI
      IF(NOUT.GE.3)
     >WRITE(IOUT,99999)IP,IS,AL0,AL1,ALF,ANG1,ANG2,
     >X0,X1,PHI0,PHI1,PHIB
C     WRITE(IOUT,68888)IADS,ELDAT(IADS+2)
      IAD=IADR(NELB(IP+1))
      ELDAT(IAD+2)=ELDAT(IAD+2)-PHIB
C     WRITE(IOUT,68888)IAD,ELDAT(IAD+2)
      Y0=0.0D0
      PHI0=0.0D0
      IS=1
      IPF=NPEN-1
      DO 21 IP=1,IPF
      IFL=1
      N0=NPBAS(IP)
      NF=NPBAS(IP+1)
      AL0=ACLENG(N0)
      ALF=ACLENG(NF)
   22 FACT=GAUSS(IXB)
      IF(DABS(FACT).GT.2.0D0)GOTO 22
      ANG1=SIG1*FACT
   23 CONTINUE
      IF(IS.GT.NSUB)GOTO 24
      IF(NPSBAS(IS).GT.NF) GOTO 28
      N1=NPSBAS(IS)
      AL1=ACLENG(N1)
   25 FACT=GAUSS(IXB)
      IF(DABS(FACT).GT.2.0D0)GOTO 25
      ANG2=SIG2*FACT
      PHIB=-DATAN2(Y0,ALF-AL0)
      PHI1=PHIB+ANG1+ANG2
      Y1=Y0+(AL1-AL0)*DTAN(PHI1)
      DPHI=PHI1-PHI0
      IF(NOUT.GE.3)
     >WRITE(IOUT,99998)IP,IS,AL0,AL1,ALF,ANG1,ANG2,
     >Y0,Y1,PHI0,PHI1,PHIB
99998 FORMAT(/,' IN BASE IP,IS,AL0,AL1,ALF,ANG1,ANG2,'
     >,'Y0,Y1,PHI0,PHI1,PHIB ARE',
     >//,2I4,2(/,5E14.5),/)
      IF(IFL.EQ.1)GOTO 26
      IAD=IADR(NELSB(IS-1))
      ELDAT(IAD+4)=DPHI
      GOTO 27
   28 N1=NF
      AL1=ACLENG(N1)
   29 FACT=GAUSS(IXB)
      IF(DABS(FACT).GT.2.0D0)GOTO 29
      ANG2=SIG2*FACT
      PHIB=-DATAN2(Y0,ALF-AL0)
      PHI1=PHIB+ANG1+ANG2
      Y1=Y0+(AL1-AL0)*DTAN(PHI1)
      DPHI=PHI1-PHI0
      WRITE(IOUT,99998)IP,IS,AL0,AL1,ALF,ANG1,ANG2,
     >Y0,Y1,PHI0,PHI1,PHIB
      IAD=IADR(NELSB(IS-1))
      ELDAT(IAD+4)=DPHI
      Y0=Y1
      PHI0=PHI1
      AL0=AL1
      GOTO 21
   26 IAD=IADR(NELB(IP))
      ELDAT(IAD+4)=ELDAT(IAD+4)+DPHI
      IFL=0
   27 Y0=Y1
      PHI0=PHI1
      AL0=AL1
      IS=IS+1
      GOTO 23
   21 CONTINUE
   24 N1=NF
      AL1=ACLENG(N1)
      PHIB=-DATAN2(Y0,ALF-AL0)
      PHI1=PHIB
      ANG1=0.0D0
      ANG2=0.0D0
      Y1=Y0+(AL1-AL0)*DTAN(PHI1)
      DPHI=PHI1-PHI0
      IF(NOUT.GE.3)
     >WRITE(IOUT,99998)IP,IS,AL0,AL1,ALF,ANG1,ANG2,
     >Y0,Y1,PHI0,PHI1,PHIB
      IADS=IADR(NELSB(IS-1))
      ELDAT(IADS+4)=DPHI
      IAD=IADR(NELB(IP+1))
      ELDAT(IAD+4)=ELDAT(IAD+4)-PHIB
      XC=0.0D0
      YC=0.0D0
      AL0=0.0D0
      PHIX=0.0D0
      PHIY=0.0D0
      IN=1
      IS=1
      NP=NPBAS(IN)
      IAD=IADR(NELB(IN))
      PHIX=PHIX+ELDAT(IAD+2)
C     WRITE(IOUT,68888)IAD,ELDAT(IAD+2)
      PHIY=PHIY+ELDAT(IAD+4)
   31 IF(NOUT.GE.1)
     >WRITE(IOUT,13001)NP,IN,IS,PHIX,XC,PHIY,YC
   32 IF(IS.GT.NSUB)GOTO 33
      NPS=NPSBAS(IS)
      NPN=NPBAS(IN+1)
      IADS=IADR(NELSB(IS))
      IF(NPS.GT.NPN)GOTO 33
      AL1=ACLENG(NPS)
      XC=XC+(AL1-AL0)*DTAN(PHIX)
      YC=YC+(AL1-AL0)*DTAN(PHIY)
      PHIX=PHIX+ELDAT(IADS+2)
C     WRITE(IOUT,68888)IADS,ELDAT(IADS+2)
      PHIY=PHIY+ELDAT(IADS+4)
      IF(NOUT.GE.1)
     >WRITE(IOUT,13001)NPS,IN,IS,PHIX,XC,PHIY,YC
13001 FORMAT(' POS,IN,IS,PHIX,X,PHIY,Y ARE',3I5,4E14.5)
      AL0=AL1
      IS=IS+1
      GOTO 32
   33 IN=IN+1
      IF(IN.GT.NPEN)GOTO 34
      NP=NPBAS(IN)
      IAD=IADR(NELB(IN))
      AL1=ACLENG(NP)
      XC=XC+(AL1-AL0)*DTAN(PHIX)
      YC=YC+(AL1-AL0)*DTAN(PHIY)
      PHIX=PHIX+ELDAT(IAD+2)
C     WRITE(IOUT,68888)IAD,ELDAT(IAD+1)
      PHIY=PHIY+ELDAT(IAD+4)
      AL0=AL1
      GOTO 31
   34 RETURN
      END
      SUBROUTINE BEAM
C     ***********************
      IMPLICIT REAL*8 (A-H,O-Z)
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      COMMON/CBEAM/BSIG(6,6),BSIGF(6,6),MBPRT,IBMFLG,MENV
      DO 1 I=1,6
      DO 1 J=I,6
      BSIGF(I,J)=0.0D0
      DO 1 K=1,6
      SL=0.0D0
      DO 2 L=1,6
    2 SL=SL+BSIG(K,L)*TEMP(J,L)
    1 BSIGF(I,J)=BSIGF(I,J)+TEMP(I,K)*SL
      DO 3 I=1,6
    3 BSIGF(I,I)=DSQRT(BSIGF(I,I))
      DO 4 I=1,5
      JB=I+1
      DO 4 J=JB,6
      BSIGF(I,J)=BSIGF(I,J)/(BSIGF(I,I)*BSIGF(J,J))
    4 BSIGF(J,I)=BSIGF(I,J)
      RETURN
      END

      SUBROUTINE BEND(IELM,MATADR)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      PARAMETER    (mxpart = 128000)
      COMMON /INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/PRODCT/KODEPR,NEL,NOF
      COMMON/BND/IAD
      DIMENSION PARM(20)
C
C     SET UP THE PARAMETERS FOR ENTEX (ENTRANCE)
C
      IF(KUNITS.EQ.2) THEN
        H=(ELDAT(IAD+1)*CRDEG)/ELDAT(IAD)
        PARM(1) = H
        PARM(2) = ELDAT(IAD+2)
        PARM(3) = ELDAT(IAD+4)
        PARM(4) = 1.0D0
        PARM(5) = ELDAT(IAD+5)
        PARM(6) = ELDAT(IAD+6)
        PARM(7) = ELDAT(IAD+7)
      ENDIF
      IF(KUNITS.EQ.1) THEN
        H=ELDAT(IAD+1)/ELDAT(IAD)
        PARM(1) = H
        PARM(2) = ELDAT(IAD+2)/H**2
        PARM(3) = ELDAT(IAD+4)/CRDEG
        PARM(4) = 1.0D0
        PARM(5) = ELDAT(IAD+5)
        PARM(6) = ELDAT(IAD+6)
        PARM(7) = ELDAT(IAD+7)
      ENDIF
      IF(KUNITS.EQ.0) THEN
        H=ELDAT(IAD+1)/ELDAT(IAD)
        PARM(1) = H
        PARM(2) = -ELDAT(IAD+2)/H**2
        PARM(3) = ELDAT(IAD+4)/CRDEG
        PARM(4) = 1.0D0
        PARM(5) = ELDAT(IAD+5)
        PARM(6) = ELDAT(IAD+6)
        PARM(7) = ELDAT(IAD+7)
      ENDIF
C
C     CALL ENTEX (ENTRANCE)
C
      KODEPR = 11
      CALL ENTEX(PARM,MATADR)
      CALL PROMAT(IELM,MATADR)
C
C     GET THE PARAMETERS FOR MAGT2
C
      IF(KUNITS.EQ.2) THEN
        PARM(1) = ELDAT(IAD+1)
        PARM(2) = ELDAT(IAD)
        PARM(3) = ELDAT(IAD+2)
        PARM(4) = ELDAT(IAD+3)
      ENDIF
      IF(KUNITS.EQ.1) THEN
        PARM(1) = ELDAT(IAD+1)/CRDEG
        PARM(2) = ELDAT(IAD)
        PARM(3) = ELDAT(IAD+2)/(H*H)
        PARM(4) = -ELDAT(IAD+3)/(2.0D0*H*H*H)
      ENDIF
      IF(KUNITS.EQ.0) THEN
        PARM(1) = ELDAT(IAD+1)/CRDEG
        PARM(2) = ELDAT(IAD)
        PARM(3) = -ELDAT(IAD+2)/(H*H)
        PARM(4) = ELDAT(IAD+3)/(2.0D0*H*H*H)
      ENDIF
C
C     CALL MAGT2
C
      KODEPR = 1
      CALL MAGT2(PARM,MATADR)
      CALL PROMAT(IELM,MATADR)
C
C     GET THE PARAMETERS FOR ENTEX (EXIT)
C
      IF(KUNITS.EQ.2) THEN
        PARM(1) = H
        PARM(2) = ELDAT(IAD+2)
        PARM(3) = ELDAT(IAD+8)
        PARM(4) = -1.0D0
        PARM(5) = ELDAT(IAD+9)
        PARM(6) = ELDAT(IAD+10)
        PARM(7) = ELDAT(IAD+11)
      ENDIF
      IF(KUNITS.EQ.1) THEN
        PARM(1) = H
        PARM(2) = ELDAT(IAD+2)/H**2
        PARM(3) = ELDAT(IAD+8)/CRDEG
        PARM(4) = -1.0D0
        PARM(5) = ELDAT(IAD+9)
        PARM(6) = ELDAT(IAD+10)
        PARM(7) = ELDAT(IAD+11)
      ENDIF
      IF(KUNITS.EQ.0) THEN
        PARM(1) = H
        PARM(2) = -ELDAT(IAD+2)/H**2
        PARM(3) = ELDAT(IAD+8)/CRDEG
        PARM(4) = -1.0D0
        PARM(5) = ELDAT(IAD+9)
        PARM(6) = ELDAT(IAD+10)
        PARM(7) = ELDAT(IAD+11)
      ENDIF
C
C     CALL ENTEX (EXIT)
C
      KODEPR = 11
      CALL ENTEX(PARM,MATADR)
      CALL PROMAT(IELM,MATADR)
      RETURN
      END
      SUBROUTINE BLin
C     *************************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/LNGTH/TLENG,ALENG(MXELMD),ACLENG(MAXPOS)
      COMMON/CSEEDS/ISEED,IXG,IXS,IXMSTP,IMSD,IMOSTP,ISYNSD,ISYSTP,
     >ISDBEG,IBGSTP,IXES,IXESTP,IESBEG,IESTBG,isdcol
C CINTAK : COMMON CONTAINING ARRAYS NEEDED FOR INPUT
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR,NINE
      parameter    (MXBLOC = 100)
      common/cblock/
     >bx(mxbloc),bxp(mxbloc),by(mxbloc),byp(mxbloc),
     >bz(mxbloc),bzr(mxbloc),bdel(mxbloc),
     >sx(mxbloc),sxp(mxbloc),sy(mxbloc),syp(mxbloc),
     >sz(mxbloc),szr(mxbloc),sdel(mxbloc),sal(mxbloc),
     >dblx,dblxp,dbly,dblyp,dblz,dblzr,dbldel,dblal,
     >iebl(mxbloc),nel1(mxbloc),nel2(mxbloc),
     >ibt,ixbls,ixblstp,iblflg,iblchk,iblopt,iblsopt
      do 1 icpart=1,npart
      if(.not.logpar(icpart))goto 1
      x=part(icpart,1)
      xp=part(icpart,2)
      y=part(icpart,3)
      yp=part(icpart,4)
      al=part(icpart,5)
      pdel=part(icpart,6)
      x=x-dblx
      xp=xp-dblxp
      y=y-dbly
      yp=yp-dblyp
      pdel=pdel-dbldel
      x=x+dblz*xp
      y=y+dblz*yp
      s=x*dcos(dblzr)-y*dsin(dblzr)
      y=x*dsin(dblzr)+y*dcos(dblzr)
      x=s
      s=xp*dcos(dblzr)-yp*dsin(dblzr)
      yp=xp*dsin(dblzr)+yp*dcos(dblzr)
      xp=s
      part(icpart,1)=x
      part(icpart,2)=xp
      part(icpart,3)=y
      part(icpart,4)=yp
      part(icpart,5)=al
      part(icpart,6)=pdel
    1 continue
      RETURN
      END
      SUBROUTINE BLOCK(IEND)
C     *************************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/LNGTH/TLENG,ALENG(MXELMD),ACLENG(MAXPOS)
      COMMON/CSEEDS/ISEED,IXG,IXS,IXMSTP,IMSD,IMOSTP,ISYNSD,ISYSTP,
     >ISDBEG,IBGSTP,IXES,IXESTP,IESBEG,IESTBG,isdcol
C CINTAK : COMMON CONTAINING ARRAYS NEEDED FOR INPUT
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR,NINE
      parameter    (MXBLOC = 100)
      common/cblock/
     >bx(mxbloc),bxp(mxbloc),by(mxbloc),byp(mxbloc),
     >bz(mxbloc),bzr(mxbloc),bdel(mxbloc),
     >sx(mxbloc),sxp(mxbloc),sy(mxbloc),syp(mxbloc),
     >sz(mxbloc),szr(mxbloc),sdel(mxbloc),sal(mxbloc),
     >dblx,dblxp,dbly,dblyp,dblz,dblzr,dbldel,dblal,
     >iebl(mxbloc),nel1(mxbloc),nel2(mxbloc),
     >ibt,ixbls,ixblstp,iblflg,iblchk,iblopt,iblsopt
      DATA NINE/'9'/
      IXBLs=ISEED
      ixblstp=0
      ib=0
      nipr=1
      nchar=0
      ndata=2
      CALL INPUT(ICHAR,NCHAR,DATA,MXINP,IEND,NDATA,NIPR)
      iblopt=data(1)
      iblsopt=data(2)
   30 NCHAR=8
      NDATA=0
      NIPR=1
      CALL INPUT(ICHAR,NCHAR,DATA,MXINP,IEND,NDATA,NIPR)
      IF((ICHAR(1).EQ.NINE).AND.(ICHAR(2).EQ.NINE)) GOTO 1
      ib=ib+1
      CALL ELID(ICHAR,NELID1)
      nel1(ib)=nelid1
      CALL INPUT(ICHAR,NCHAR,DATA,MXINP,IEND,NDATA,NIPR)
      CALL ELID(ICHAR,NELID2)
      nel2(ib)=nelid2
      NCHAR=0
      NDATA=7
      CALL INPUT(ICHAR,NCHAR,DATA,MXINP,IEND,NDATA,NIPR)
      bx(ib)=data(1)
      bxp(ib)=data(2)
      by(ib)=data(3)
      byp(ib)=data(4)
      bz(ib)=data(5)
      bzr(ib)=data(6)
      bdel(ib)=data(7)
      GOTO 30
    1 continue
      ibt=ib
      iblflg=1
      if(iblsopt.ge.10)then
       iblsopt=iblsopt-10
       ixbls=1
       ixblstp=1
                       else
       ixbls=iseed
       ixblstp=0
      endif
      RETURN
      END
      SUBROUTINE BLOCKchk(ie,nel)
C     *************************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/LNGTH/TLENG,ALENG(MXELMD),ACLENG(MAXPOS)
      COMMON/CSEEDS/ISEED,IXG,IXS,IXMSTP,IMSD,IMOSTP,ISYNSD,ISYSTP,
     >ISDBEG,IBGSTP,IXES,IXESTP,IESBEG,IESTBG,isdcol
C CINTAK : COMMON CONTAINING ARRAYS NEEDED FOR INPUT
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR,NINE
      parameter    (MXBLOC = 100)
      common/cblock/
     >bx(mxbloc),bxp(mxbloc),by(mxbloc),byp(mxbloc),
     >bz(mxbloc),bzr(mxbloc),bdel(mxbloc),
     >sx(mxbloc),sxp(mxbloc),sy(mxbloc),syp(mxbloc),
     >sz(mxbloc),szr(mxbloc),sdel(mxbloc),sal(mxbloc),
     >dblx,dblxp,dbly,dblyp,dblz,dblzr,dbldel,dblal,
     >iebl(mxbloc),nel1(mxbloc),nel2(mxbloc),
     >ibt,ixbls,ixblstp,iblflg,iblchk,iblopt,iblsopt
c  check if element is an extremity of a block
      iblbeg=0
      iblend=0
      do 1 ib=1,ibt
      if(nel1(ib).eq.nel) then
         iblbeg=ib
      endif
      if(nel2(ib).eq.nel) then
         iblend=ib
      endif
      if(iblbeg.ne.0)goto 2
      if(iblend.ne.0)goto 3
    1 continue
      iblchk=0
      goto 999
C tackling begin of a block
    2 continue
      if(iebl(ib).ne.-1) then
       write(iout,10001)(name(in,nel),in=1,8)
10001 format(' a block starting with the name : ',8a1,' has already',/,
     >' been opened and is not closed. Run is stopped ')
       stop
      endif
      iebl(ib)=0
C  check if a block is open and set descendance value
      do 21 ibb=1,ibt
      if(ibb.eq.ib)goto 21
      if(iebl(ibb).eq.0) then
       iebl(ibb)=ib
       goto 22
      endif
   21 continue
c   set up the kick for the entrance of the block
   22 continue
      iopt=iblsopt
      sig=2.0d0
      if(iopt.eq.0) then
       sx(ib)=bx(ib)
       sxp(ib)=bxp(ib)
       sy(ib)=by(ib)
       syp(ib)=byp(ib)
       sz(ib)=bz(ib)
       szr(ib)=bzr(ib)
       sdel(ib)=bdel(ib)
                  else
       sx(ib)=bx(ib)*rannum(ixbls,iopt,sig,ixblstp)
       sxp(ib)=bxp(ib)*rannum(ixbls,iopt,sig,ixblstp)
       sy(ib)=by(ib)*rannum(ixbls,iopt,sig,ixblstp)
       syp(ib)=byp(ib)*rannum(ixbls,iopt,sig,ixblstp)
       sz(ib)=bz(ib)*rannum(ixbls,iopt,sig,ixblstp)
       szr(ib)=bzr(ib)*rannum(ixbls,iopt,sig,ixblstp)
       sdel(ib)=bdel(ib)*rannum(ixbls,iopt,sig,ixblstp)
      endif
      dblx=sx(ib)
      dblxp=sxp(ib)
      dbly=sy(ib)
      dblyp=syp(ib)
      dblz=sz(ib)
      dblzr=szr(ib)
      dbldel=sdel(ib)
      if(ie.eq.1) then
       sal(ib)=0.0d0
                  else
       sal(ib)=acleng(ie-1)
      endif
      iblchk=1
      goto 999
C tackling end of a block
    3 continue
      if(iebl(ib).ne.0) then
       write(iout,10002)(name(in,nel),in=1,8)
10002 format(' the block ending with name :',8a1,' may not be closed ',/,
     >' because another open block is nested . Run is stopped')
       stop
      endif
C  set up kick for exit of ablock
   23 continue
      alb=acleng(ie)-sal(ib)
      dblx=-sx(ib)-alb*sxp(ib)
      dblxp=-sxp(ib)
      dbly=-sy(ib)-alb*syp(ib)
      dblyp=-syp(ib)
      dblz=-sz(ib)
      dblzr=-szr(ib)
      dbldel=-sdel(ib)
      dblal=0.5d0*alb*(dblxp*dblxp+dblyp*dblyp)
      iblchk=2
      iebl(ib)=-1
      do 33 ibb=1,ibt
      if(iebl(ibb).eq.ib) then
       iebl(ibb)=0
       return
      endif
   33 continue
  999 continue
      RETURN
      END
      SUBROUTINE BLout
C     *************************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/LNGTH/TLENG,ALENG(MXELMD),ACLENG(MAXPOS)
      COMMON/CSEEDS/ISEED,IXG,IXS,IXMSTP,IMSD,IMOSTP,ISYNSD,ISYSTP,
     >ISDBEG,IBGSTP,IXES,IXESTP,IESBEG,IESTBG,isdcol
C CINTAK : COMMON CONTAINING ARRAYS NEEDED FOR INPUT
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR,NINE
      parameter    (MXBLOC = 100)
      common/cblock/
     >bx(mxbloc),bxp(mxbloc),by(mxbloc),byp(mxbloc),
     >bz(mxbloc),bzr(mxbloc),bdel(mxbloc),
     >sx(mxbloc),sxp(mxbloc),sy(mxbloc),syp(mxbloc),
     >sz(mxbloc),szr(mxbloc),sdel(mxbloc),sal(mxbloc),
     >dblx,dblxp,dbly,dblyp,dblz,dblzr,dbldel,dblal,
     >iebl(mxbloc),nel1(mxbloc),nel2(mxbloc),
     >ibt,ixbls,ixblstp,iblflg,iblchk,iblopt,iblsopt
      do 1 icpart=1,npart
      if(.not.logpar(icpart))goto1
      x=part(icpart,1)
      xp=part(icpart,2)
      y=part(icpart,3)
      yp=part(icpart,4)
      al=part(icpart,5)
      pdel=part(icpart,6)
      s=x*dcos(dblzr)-y*dsin(dblzr)
      y=x*dsin(dblzr)+y*dcos(dblzr)
      x=s
      s=xp*dcos(dblzr)-yp*dsin(dblzr)
      yp=xp*dsin(dblzr)+yp*dcos(dblzr)
      xp=s
      x=x+dblz*xp
      y=y+dblz*yp
      x=x-dblx
      xp=xp-dblxp
      y=y-dbly
      yp=yp-dblyp
      pdel=pdel-dbldel
      al=al-dblal
      part(icpart,1)=x
      part(icpart,2)=xp
      part(icpart,3)=y
      part(icpart,4)=yp
      part(icpart,5)=al
      part(icpart,6)=pdel
    1 continue
      RETURN
      END
      FUNCTION CAVFUN(T,T0,T1,F0,F1,PER,PHI,IOPT)
C     *******************************************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      COMMON /INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      cavfun=0.0d0
      IF(IOPT.EQ.2)GOTO 2
      IF(T.GT.T0)GOTO 10
      CAVFUN=F0*T
      RETURN
   10 IF(T.GT.T1)GOTO 11
      CAVFUN=F0*T+0.5D0*(F1-F0)*(T-T0)*(T-T0)/(T1-T0)
      RETURN
   11 CAVFUN=0.5D0*(F0-F1)*(T0+T1)+F1*T
      RETURN
    2 CONTINUE
      RETURN
      END
      SUBROUTINE CAVITY(X1,X2,X3,X4,X5,X6,Y1,Y2,Y3,Y4,Y5,Y6,IPART,NTURN)
C     ******************************************************************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      PARAMETER    (mxpart = 128000)
      COMMON /INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/CAV/FREQ,ALC,AML,CAVPHI,DEOVE,CPHI(MXPART),
     >PINGAM,PBETA,PCLENG,DTN,DAML,DTNA(MXPART),
     >CTF,CLP,DPHI,F0CAV,F1CAV,PERCAV,APHIAD,ICOPT,IAML,
     >N0CAV,N1CAV,INCAV
      PARAMETER    (MXADIV = 15)
      PARAMETER    (MXADIP = 100)
      COMMON/ADIA/VPARM(mxadiv,2*mxadip),IADFLG,IADCAV,NADVAR,
     >ivid(mxadiv),IVPAR(mxadiv),IVOPT(mxadiv)
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      Y1=X1+ALC*X2
      Y2=X2
      Y3=X3+ALC*X4
      Y4=X4
ccc      IF(INCAV.EQ.1) THEN
ccc       CPHI(IPART)=TWOPI*FREQ*(X5-DAML*PINGAM*PINGAM*X6)/
ccc     >                  (PBETA*CLIGHT)+dphi
ccc                     else
CCCC      CPHI(IPART)= CPHI(IPART) + DPHI
      dx5=x5-dtna(ipart)
      CPHI(IPART)= CPHI(IPART) + DPHI+ctf*dx5-clp*x6
ccc      ENDIF
      PHI=CPHI(IPART)+CAVPHI
C      TN=(NTURN*AML+X5)/(PBETA*CLIGHT)
C      DTN=-DAML*X6*PINGAM*PINGAM/(PBETA*CLIGHT)
C      DTNA(IPART)=DTNA(IPART)+DTN
C      TN=TN+DTNA(IPART)
C      IF(IADCAV.NE.0)GOTO 1
C      PHI=TWOPI*(FREQ*TN)-TWOPI*IAML*NTURN
C      GOTO 2
C    1 T0=N0CAV*AML/(PBETA*CLIGHT)
C      T1=N1CAV*AML/(PBETA*CLIGHT)
C      CF=CAVFUN(TN,T0,T1,F0CAV,F1CAV,PERCAV,APHIAD,ICOPT)
C      PHI=TWOPI*(CF-IAML*NTURN)
C    2 CPHI(IPART)=PHI
      Y6=X6+DEOVE*DSIN(PHI)
      Y5=X5+0.5D0*ALC*(X2*X2+X4*X4)
      dtna(ipart)=x5
      RETURN
      END
      SUBROUTINE CAVMAT(IELM,MATADR)
C     ************************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/PRODCT/KODEPR,NEL,NOF
      IAD=IADR(IELM)
      AL=ELDAT(IAD)
      DO 100 I=1,6
      DO 100 J=1,NOF
      AMAT(J,I,MATADR)=0.0D0
      IF(I.EQ.J) AMAT(J,I,MATADR)=1.0D0
  100 CONTINUE
      AMAT(2,1,MATADR)=AL
      AMAT(4,3,MATADR)=AL
      IF(NORDER.EQ.1)RETURN
      AMAT(13,5,MATADR)=AL/2.0D0
      AMAT(22,5,MATADR)=AL/2.0D0
      RETURN
      END
      SUBROUTINE CAVPRE(IAD,NEL,NTURN,IE)
C     **************************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      PARAMETER    (mxpart = 128000)
      COMMON /INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/CAV/FREQ,ALC,AML,CAVPHI,DEOVE,CPHI(MXPART),
     >PINGAM,PBETA,PCLENG,DTN,DAML,DTNA(MXPART),
     >CTF,CLP,DPHI,F0CAV,F1CAV,PERCAV,APHIAD,ICOPT,IAML,
     >N0CAV,N1CAV,INCAV
      PARAMETER    (MXADIV = 15)
      PARAMETER    (MXADIP = 100)
      COMMON/ADIA/VPARM(mxadiv,2*mxadip),IADFLG,IADCAV,NADVAR,
     >ivid(mxadiv),IVPAR(mxadiv),IVOPT(mxadiv)
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      COMMON/LNGTH/TLENG,ALENG(MXELMD),ACLENG(MAXPOS)
      DATA EREST/0.000511006/,PREST/0.938256/,IW/0/,mesflg/0/
ccc      IF(INCAV.EQ.0) THEN
ccc       IF((NTURN.EQ.1).AND.(IE.NE.1).and.(mesflg.eq.0)) THEN
ccc         WRITE(IOUT,10002)
ccc10002 FORMAT('   THE LATTICE DID NOT START WITH A CAVITY.',/,
ccc     >'  THERE COULD BE A PHASE ERROR ',/)
ccc         IF(ISO.NE.0) WRITE(ISOUT,10002)
ccc         mesflg=1
ccc       ENDIF
ccc       INCAV=1
ccc      ENDIF
      PENER=ELDAT(IAD+1)
      IF(IPTYP.EQ.0)THEN
       PENER=PENER+EREST
       PINGAM=EREST/PENER
      ENDIF
      IF(IPTYP.EQ.1)THEN
       PENER=PENER+PREST
       PINGAM=PREST/PENER
      ENDIF
      PBETA=DSQRT(1.0D0-(PINGAM)**2)
      PV=PBETA*CLIGHT
      CCLENG=ACLENG(IE)
      IF((CCLENG.Gt.PCLENG).or.(nturn.eq.1)) THEN
        DAML=CCLENG-PCLENG
                           ELSE
        DAML=CCLENG-PCLENG+TLENG
      ENDIF
      PCLENG=CCLENG
      AML=TLENG
      IHCAV=ELDAT(IAD+3)
      FREQ=PBETA*CLIGHT*ELDAT(IAD+3)/AML
      IF(IW.EQ.0)THEN
        WRITE(IOUT,11111)FREQ
        IW=1
      ENDIF
11111 FORMAT(/,'  FREQUENCY IS : ',E20.12)
CC      FREQ=ELDAT(IAD+3)
CC     IF(KUNITS.NE.2) FREQ = FREQ*10**6
      ALC=ELDAT(IAD)
      ALMBDA=PBETA*CLIGHT/FREQ
      CTF=TWOPI*FREQ/PV
CCCC      CLP=CTF*ALENG(NEL)*PINGAM*PINGAM
      CLP=CTF*daml*PINGAM*PINGAM
      DPHI=TWOPI*DAML*((FREQ/PV)-(IHCAV/AML))
      IAML=0.5D0+(AML/ALMBDA)
      CAVPHI=ELDAT(IAD+4)
      IF(KUNITS.eq.2) CAVPHI = CAVPHI*CRDEG
      DEOVE=ELDAT(IAD+2)*1.0D-06/(PENER*PBETA*PBETA)
      IF(KUNITS.NE.2) DEOVE = DEOVE*10**3
      IF(IADCAV.EQ.0)RETURN
      DO 10 ICV=1,NADVAR
      IF(NEL.EQ.IVID(ICV))GOTO 11
   10 CONTINUE
      WRITE(IOUT,10001)
10001 FORMAT(' NO MATCH WAS FOUND FOR CAVITY ID IN CAVPRE ')
      CALL HALT(215)
   11 N0CAV=VPARM(ICV,1)
      N1CAV=VPARM(ICV,2)
      F0CAV=VPARM(ICV,3)
      F1CAV=VPARM(ICV,4)
      IF(IVOPT(ICV).EQ.1)RETURN
      ICOPT=2
      PERCAV=VPARM(ICV,5)
      APHIAD=VPARM(ICV,6)
      RETURN
      END
      SUBROUTINE CHGCOR(IEND)
C     **************************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      COMMON /INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER     (MAXCOR = 600)
      COMMON/CORR/CORVAL(MAXCOR,4),ICRID(MAXCOR),
     >ICRPOS(MAXCOR),ICRSET(MAXCOR),
     >ICROPT(MAXCOR),NCORR,NCURCR,ICRFLG,ICRCHK,ALMNEL,ICRPTR,NPARC
      DIMENSION DATA(4)
      CHARACTER*1 ICHAR(8)
      NCHAR=0
      NDIM=4
      NDATA=1
      NIPR=1
      CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NIPR)
      NCHG=DATA(1)
      DO 100 NI=1,NCHG
      NCHAR=8
      NDATA=2
      CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NIPR)
      CALL ELPOS(ICHAR,NELPOS)
      INITPS=NELPOS
      VALUE=DATA(1)
      MCOR=DATA(2)
      DO 200 MCI=1,MCOR
      NDATA=4
      CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NIPR)
      CALL ELID(ICHAR,NELID)
      ICPOS=DATA(1)+INITPS
      DO 23 ICORR=1,NCORR
      IF(ICPOS.LT.ICRPOS(ICORR))GOTO 24
      IF((NELID.EQ.ICRID(ICORR)).AND.(ICPOS.EQ.ICRPOS(ICORR)))GOTO 25
   23 CONTINUE
   24 WRITE(IOUT,10001)ICHAR,ICPOS
10001 FORMAT(/,' ',8A1,I6,/,'  NO MATCH WAS FOUND ',
     >'FOR CORRECTOR ID AND POSITION',
     >' IN THE CORRECTOR LIST',/,' DEFINED IN THE CORRECTOR DEFINITION',
     >' OPERATION . RUN IS STOPPED',/)
      CALL HALT(220)
   25 IF(ICRSET(ICORR).EQ.0) THEN
           WRITE(IOUT,10000)ICHAR,ICPOS
10000 FORMAT('  CORRECTOR  ',8A1,' AT POSITION :',I6,' IS NOT SET',/,
     >'   RUN IS STOPPED ')
           CALL HALT(221)
      ENDIF
      IPAR=DATA(2)
      AMULT=DATA(3)
      ADD=DATA(4)
      CORVAL(ICORR,IPAR)=AMULT*VALUE+ADD+CORVAL(ICORR,IPAR)
  200 CONTINUE
  100 CONTINUE
      RETURN
      END
      SUBROUTINE CINITG
C     **************************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      logical lcvfst
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      PARAMETER    (mxpart = 128000)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      PARAMETER  (MXGACA = 15)
      PARAMETER  (MXGATR = 1030)
      COMMON/GEOM/XCO,XPCO,YCO,YPCO,NCASE,NJOB,
     <    EPSX(MXGACA),EPSY(MXGACA),XI(MXGACA),YI(MXGACA),
     <    XG(MXGATR,MXGACA),
     <    XPG(MXGATR,MXGACA),YG(MXGATR,MXGACA),YPG(MXGATR,MXGACA),
     <    LCASE(MXGACA)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CONDEF/REFEN
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      parameter   (mxerr = 25)
      parameter   (MXEREL = 500)
      parameter   (MXERRG = 6)
      COMMON/cERR/ERRVAL(mxerr,mxerel),erv(mxerr,mxerel),NERELE(mxerel),
     > NERPAR(mxerr,mxerel),NERR,NEROPT,NERRE,MERSEL(mxerel),
     > NERNGE(mxerel),MERNGE(2,mxerrg,mxerel),MERFLG
      COMMON/CBEAM/BSIG(6,6),BSIGF(6,6),MBPRT,IBMFLG,MENV
      COMMON/CRDMON/MONAME(8),MOBEG,MOEND,MRDFLG
     >,MRDCHK
      CHARACTER*1 MONAME
      PARAMETER  (mxmis = 1000)
      COMMON/MIS/RMISA(8,MXMIS),MISELE(MXMIS),NMIS,NOPT,
     >NMISE,MISSEL(MXMIS),NMRNGE(MXMIS),
     >MSRNGE(2,10,MXMIS),MISFLG,MCHFLG
      PARAMETER     (MAXCOR = 600)
      COMMON/CORR/CORVAL(MAXCOR,4),ICRID(MAXCOR),
     >ICRPOS(MAXCOR),ICRSET(MAXCOR),
     >ICROPT(MAXCOR),NCORR,NCURCR,ICRFLG,ICRCHK,ALMNEL,ICRPTR,NPARC
      PARAMETER    (MXADIV = 15)
      PARAMETER    (MXADIP = 100)
      COMMON/ADIA/VPARM(mxadiv,2*mxadip),IADFLG,IADCAV,NADVAR,
     >ivid(mxadiv),IVPAR(mxadiv),IVOPT(mxadiv)
      PARAMETER  (mxlcnd = 200)
      PARAMETER  (mxlvar = 100)
      COMMON/MONFIT/VALFA(MXLCND),WGHTA(MXLCND),ERRA(MXLCND),
     >AMULTA(MXLVAR,6),ADDA(MXLVAR,6),DELA(MXLVAR)
     >,NPARA(MXLVAR,6),NELFA(MXLVAR,6),
     >NPVARA(MXLVAR),INDA(MXLVAR,6),VALR(MXLCND),RMOSIG,
     >NMONA(MXLCND),NVALA(MXLCND),NVARA,NCONDA
     >,IALFLG,MONFLG,MONLST,NOPTER,
     >IAFRST,IMOOPT,IMSBEG,NALPRT
      COMMON/LIMIT/VLO(MXLVAR),VUP(MXLVAR),WLIM(MXLVAR),
     >  DIS(MXLVAR),NELLIM(MXLVAR),
     >  WGHLIM(MXLVAR),VLOLIM(MXLVAR),VUPLIM(MXLVAR),
     >  DISLIM(MXLVAR),NPRLIM(MXLVAR),IFLCST,LIMFLG,NLIM,NEXP
      COMMON/SYM/ENERLI,GAMMLI,BETALI,bili,b2li,b2ili,
     >ISYOPT,ISYFLG,MATTOT,KANVAR
      COMMON/CSEIS/XLAMBS,AXSEIS,PHIXS,YLAMBS,
     >AYSEIS,PHIYS,XSEIS,YSEIS,ISEIFL,IBEGSE,IENDSE
      COMMON/HPDAT/
     &                 QFOCAL,XPRE,YPRE,ZPRE,THETAPRE,PHIPRE,PSIPRE,
     &                        XNOW,YNOW,ZNOW,THETANOW,PHINOW,PSINOW,
     &                        KADOUT,IHPXY,
     &                        IEHP
      COMMON/CSEEDS/ISEED,IXG,IXS,IXMSTP,IMSD,IMOSTP,ISYNSD,ISYSTP,
     >ISDBEG,IBGSTP,IXES,IXESTP,IESBEG,IESTBG,isdcol
      COMMON/PRODCT/KODEPR,NEL,NOF
      PARAMETER    (MXMTR = 5000)
      COMMON/MISTRK/AKMIS(15,MXMTR),KMPOS(MXMTR),IMEXP,NMTOT,MISPTR
      COMMON/CFFT/fbetax,falphx,fbetay,falphy,fnux,fnuy,ifftan,nprplt
      common/cspch/delspx(mxpart),delspy(mxpart),
     >dpmax,dkxmax,dkymax,ispopt,ispchf
      common/cinter/inumel,niplot,intflg,iprpl,jherr,itrap,
     > numel(20),iscx(20),iscy(20),
     > iscsx(20),iscsy(20),avx(11,101),avy(11,101),axis(101)
      character*1 avx,avy,axis
      parameter    (MXBLOC = 100)
      common/cblock/
     >bx(mxbloc),bxp(mxbloc),by(mxbloc),byp(mxbloc),
     >bz(mxbloc),bzr(mxbloc),bdel(mxbloc),
     >sx(mxbloc),sxp(mxbloc),sy(mxbloc),syp(mxbloc),
     >sz(mxbloc),szr(mxbloc),sdel(mxbloc),sal(mxbloc),
     >dblx,dblxp,dbly,dblyp,dblz,dblzr,dbldel,dblal,
     >iebl(mxbloc),nel1(mxbloc),nel2(mxbloc),
     >ibt,ixbls,ixblstp,iblflg,iblchk,iblopt,iblsopt
      parameter    (MXCEB = 2000)
      common/cebcav/cebmat(6,6,mxceb),estart,ecav(mxceb),
     >ipos(mxceb),icavtot,icebflg,iestflg,icurcav
      common /cmc/ez(1401),dezdz(1401),lcvfst
C**********************************************************************
C*****THE FOLLOWING STATEMENT IS SPECIFIC TO THE IBM FORTVS COMPILER***
C*****IT SHOULD BE REMOVED FOR ALL OTHER USAGES.                    ***
C**********************************************************************
c     CALL ERRSET(207,300,1,1,1,0)
c     CALL ERRSET(208,300,1,1,1,0)
      IMEXP=0
      jherr=0
      itrap=0
      IFFTAN=0
      KADOUT=0
      IHPXY=0
      ISYOPT=0
      ISYFLG=0
      IFLCST=0
      IXMSTP=0
      EXPEL2=1.0D0
      NJOB=0
      N=1
      NOUT=3
      NORDER=2
      NOF=27
      KCOUNT=0
      PI=3.1415926535897932D0
      REFEN=0.005
      TWOPI= PI * 2.0D0
      CRDEG = PI/180.0D0
      CMAGEN = 10.0D0/.299792458D0
      CLIGHT = 2.997924580D+08
C     ELECTRON MASS GIVEN IN GEV !!!
c     EMASS = 0.5110041D-03
      EMASS = 0.51099906D-03
      ERAD = 2.8179380D-15
      ECHG = 1.6021892D-19
      TOLLSQ=1.0D-07
      MAXFAC=10
      sigfac=1.0d0
      etafac=1.0d0
      IPTYP=0
      NPART=0
      NTURN=0
      MERFLG=0
      MRDFLG=0
      ISYNFL=0
      isynqd=0
      ispchf=0
      MISFLG=0
      IBMFLG=0
      ICRFLG=0
      MCHFLG=0
      IADFLG=0
      IADCAV=0
      NALPRT=1
      ISYOPT=0
      ISYFLG=0
      KANVAR=0
      IXMSTP=0
      IXESTP=0
      IMOSTP=0
      ISYSTP=0
      IBGSTP=0
      ISEIFL=0
      IFITE(1)=0
      IFITE(2)=0
      IFLMAT=0
      iblflg=0
      lcvfst=.true.
      do 133 iibl=1,mxbloc
  133 iebl(iibl)=-1
      iestflg=0
      icebflg=0
      DO 132 ICCOR=1,4
      DO 132 INCOR=1,600
  132 CORVAL(INCOR,ICCOR)=0.0D0
      DO 131 JB=1,6
  131 BSIG(JB,JB)=1.0D0
      DO 776 I=1,MXPART
776   LOGPAR(I)=.TRUE.
      RETURN
      END
      SUBROUTINE CLEAR
C---- CLEAR DATA STRUCTURE
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
C-----------------------------------------------------------------------
C---- MACHINE STRUCTURE FLAGS
      COMMON /FLAGS/    INVAL,NEWCON,NEWPAR,PERI,STABX,STABZ,SYMM
      LOGICAL           INVAL,NEWCON,NEWPAR,PERI,STABX,STABZ,SYMM
C---- ELEMENT TABLE
      PARAMETER         (MAXELM = 5000)
      COMMON /ELMDAT/   IELEM1,IELEM2,IETYP(MAXELM),IEDAT(MAXELM,3),
     +                  IELIN(MAXELM)
C---- LINK TABLE
      PARAMETER         (MAXLST = 14000)
      COMMON /LPDATA/   IUSED,ILDAT(MAXLST,6)
C---- PARAMETER TABLE
      PARAMETER         (MAXPAR = 19000)
      COMMON /PARDAT/   IPARM1,IPARM2,IPTYP(MAXPAR),IPDAT(MAXPAR,2),
     +                  IPLIN(MAXPAR)
      COMMON /PARLST/   IPLIST,IPNEXT(MAXPAR)
C---- DATA FOR PARTICLE BEHAVIOUR
      COMMON /PRTCLS/   AMASS,CHARGE,PC,ENERGY,BETAI,GAMMAI,
     +                  PC0,E0,BI,GI,BI2,GI2,BI2GI2,FACMUL(0:5)
C-----------------------------------------------------------------------
      INVAL  = .FALSE.
      NEWCON = .FALSE.
      NEWPAR = .FALSE.
      PERI   = .FALSE.
      STABX  = .FALSE.
      STABZ  = .FALSE.
      SYMM   = .FALSE.
C
      IELEM1 = 0
      IELEM2 = MAXELM + 1
C
      IUSED  = 0
C
      IPARM1 = 0
      IPARM2 = MAXPAR + 1
      IPLIST = 0
C
      AMASS  = 0.0
      CHARGE = 1.0
      PC     = 1.0
      ENERGY = 1.0
      BETAI  = 1.0
      GAMMAI = 0.0
      PC0    = 1.0
      E0     = 1.0
      BI     = 1.0
      GI     = 0.0
      BI2    = 1.0
      GI2    = 0.0
      BI2GI2 = 0.0
C---- SET UP FOR "MAD" CONVENTIONS
      FACMUL(0) = 1.0
      FACMUL(1) = 1.0
      FACMUL(2) = 1.0
      FACMUL(3) = 1.0
      FACMUL(4) = 1.0
      FACMUL(5) = 1.0
C
      RETURN
C-----------------------------------------------------------------------
      END
C     **************************
C         THE FOLLOWING ROUTINE IS TO BE INTRODUCED WHEN THE COMPUTER
C         IS A VAX
C     ******************
c      FUNCTION CLOCK1(I)
C     ******************
c      INTEGER CLOCK1
c      Y=SECNDS(0.0)
c      Y=Y*200.0
c      CLOCK1=ABS(INT(Y))
c      RETURN
c      END
C     **************************
C         THE FOLLOWING ROUTINE IS TO BE INTRODUCED WHEN THE COMPUTER
C         IS An IBM
C     ******************
c     FUNCTION CLOCK1(I)
C     ******************
c     INTEGER CLOCK1
c     dimension now(8)
c     call datim(now)
c     CLOCK1=now(1)
c     RETURN
c     END
C     **************************
C         THE FOLLOWING ROUTINE IS TO BE INTRODUCED WHEN THE COMPUTER
C         IS A SUN
C     ******************
       FUNCTION CLOCK1(I)
C     ******************
       INTEGER CLOCK1
       INTEGER TIME
       IT=TIME()
       CLOCK1=IT
       RETURN
       END
C     ******************
C         THE FOLLOWING ROUTINE IS TO BE INTRODUCED WHEN THE COMPUTER
C         IS A VAX  RUNNING WITH UNIX
c       FUNCTION CLOCK1(I)
cC     ******************
c       IMPLICIT INTEGER (T)
c       EXTERNAL TIME
c       INTEGER CLOCK1
c       CLOCK1=TIME()
c       RETURN
c       END
C     ******************
C         THE FOLLOWING ROUTINE IS TO BE INTRODUCED WHEN THE COMPUTER
C         IS A HP  RUNNING WITH UNIX
c      FUNCTION CLOCK1(I)
cC     ******************
c      integer clock1
c      integer*4 ia(3)
c      jf=ftime(ia)
c      CLOCK1=ia(1)
c      RETURN
c      END
c
C***********************************************
      SUBROUTINE CMAP(A,B,BMAT,CMAT,GAMMA,BETA,index,itflg)
C
C***********************************************************************
C
C  NEW VERSION (4/22/85) TO SWAP TO VARIABLES (X,PX,Y,PY,-T,E)
C     ( ZC(5) IS DEFINED TO BE MINUS THE PATH LENGTH DEVIATION AND
C       ZC(6) IS THE ENERGY DEVIATION DIVIDED BY PO*C)
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON /INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/SYM/ENERLI,GAMMLI,BETALI,bili,b2li,b2ili,
     >ISYOPT,ISYFLG,MATTOT,KANVAR
      DIMENSION A(6,27),B(6,27),CMAT(6,27)
      DIMENSION BMAT(6,6),BINV(6,6),RI(6,6),RJ(6,6),CTEMP(6,6),TEST(6,6)
      DATA
     &     RJ/0.D0,1.D0,4*0.D0,-1.D0,8*0.D0,1.D0,4*0.D0,-1.D0,8*0.D0,
     &        1.D0,4*0.D0,-1.D0,0.D0/,
     &     RI/1.D0,6*0.D0,1.D0,6*0.D0,1.D0,6*0.D0,1.D0,6*0.D0,
     &        1.D0,6*0.D0,1.D0/
c      itflg=1
C     WRITE(6,11111)GAMMA,BETA
C1111 FORMAT('  IN CMAP GAMMA,BETA ARE:',2E12.4,/)
C     WRITE(6,22222)((A(IW,JW),JW=1,27),IW=1,6)
C2222 FORMAT(' IN CMAP A IS:',/,6(5(' ',5E12.4,/),' ',2E12.4,/))
c      DO 20 J=1,6
c      DO 10 K=1,27
c      CMAT(J,K)=0.D0
c      B(J,K)=A(J,K)
c   10 CONTINUE
c      cmat(j,j)=1.0d0
c   20 CONTINUE
C
C  NOW TOUCH UP B TO GET MATRIX IN CANONICAL FORM IN VARIABLES
C  (X,PX,Y,PY,-T,E)
C
      DO 30 J=1,5,2
c      B(J,5) =-1.D0*A(J,5)
c      B(J,6) =      A(J,6) /BETA
c      B(J,11)=-1.D0*A(J,11)
c      B(J,12)=      A(J,12)/BETA
c      B(J,16)=-1.D0*A(J,16)
c      B(J,17)=     (A(J,17)-A(J,2))/BETA
c      B(J,20)=-1.D0*A(J,20)
c      B(J,21)=      A(J,21)/BETA
c      B(J,23)=-1.D0*A(J,23)
c      B(J,24)=     (A(J,24)-A(J,4))/BETA
c      B(J,26)=-1.D0*A(J,26)/BETA
c      B(J,27)= (A(J,27)-(A(J,6)*(1.D0-(BETA**2))/2.D0))/(BETA**2)
      b(j,1)=a(j,1)
      b(j,2)=a(j,2)
      b(j,3)=a(j,3)
      b(j,4)=a(j,4)
      B(J,5) =-A(J,5)
      B(J,6) =      A(J,6) *bili
      b(j,7)=a(j,7)
      b(j,8)=a(j,8)
      b(j,9)=a(j,9)
      b(j,10)=a(j,10)
      B(J,11)=-A(J,11)
      B(J,12)=      A(J,12)*bili
      b(j,13)=a(j,13)
      b(j,14)=a(j,14)
      b(j,15)=a(j,15)
      B(J,16)=-A(J,16)
      B(J,17)=     (A(J,17)-A(J,2))*bili
      b(j,18)=a(j,18)
      b(j,19)=a(j,19)
      B(J,20)=-A(J,20)
      B(J,21)=      A(J,21)*bili
      b(j,22)=a(j,22)
      B(J,23)=-A(J,23)
      B(J,24)=     (A(J,24)-A(J,4))*bili
      b(j,25)=a(j,25)
      B(J,26)=-A(J,26)*bili
      B(J,27)= (A(J,27)-(A(J,6)*(1.D0-(b2li))*0.5d0))*b2ili
   30 CONTINUE
C
      DO 35 J=1,27
c   35 B(5,J)=-1.D0*B(5,J)
      b(6,j)=a(6,j)
   35 B(5,J)=-b(5,J)
C                              (FLIP SIGN OF -T TRANSFORMATION)
      DO 40 J=2,4,2
c      B(J,5) =-1.D0*A(J,5)
c      B(J,6) =      A(J,6) /BETA
c      B(J,11)=-1.D0*A(J,11)
c      B(J,12)=     (A(J,12)+A(J,1))/BETA
c      B(J,16)=-1.D0*A(J,16)
c      B(J,17)=      A(J,17)/BETA
c      B(J,20)=-1.D0*A(J,20)
c      B(J,21)=     (A(J,21)+A(J,3))/BETA
c      B(J,23)=-1.D0*A(J,23)
c      B(J,24)=      A(J,24)/BETA
c      B(J,26)=-1.D0*(A(J,26)+A(J,5))/BETA
c      B(J,27)= (A(J,27)+A(J,6)*(1.D0-((1.D0-BETA**2)/2.D0)))
c     &            /(BETA**2)
      b(j,1)=a(j,1)
      b(j,2)=a(j,2)
      b(j,3)=a(j,3)
      b(j,4)=a(j,4)
      B(J,5) =-A(J,5)
      B(J,6) =      A(J,6) *bili
      b(j,7)=a(j,7)
      b(j,8)=a(j,8)
      b(j,9)=a(j,9)
      b(j,10)=a(j,10)
      B(J,11)=-A(J,11)
      B(J,12)=     (A(J,12)+A(J,1))*bili
      b(j,13)=a(j,13)
      b(j,14)=a(j,14)
      b(j,15)=a(j,15)
      B(J,16)=-A(J,16)
      B(J,17)=      A(J,17)*bili
      b(j,18)=a(j,18)
      b(j,19)=a(j,19)
      B(J,20)=-A(J,20)
      B(J,21)=     (A(J,21)+A(J,3))*bili
      b(j,22)=a(j,22)
      B(J,23)=-A(J,23)
      B(J,24)=      A(J,24)*bili
      b(j,25)=a(j,25)
      B(J,26)=-(A(J,26)+A(J,5))*bili
c      B(J,27)= (A(J,27)+A(J,6)*(1.D0-((1.D0-BETA**2)/2.D0)))
c     &            /(BETA**2)
      B(J,27)= (A(J,27)+A(J,6)*(0.5d0*(1.0d0+b2li)))*b2ili
   40 CONTINUE
C
C  WE HAVE ASSUMED A(6,J)=0 SAVE FOR A(6,6) = 1, WHICH GIVES B(6,J)=0
C  SAVE FOR B(6,6)=1
C
      DO 60 J=1,6
      DO 50 K=1,6
      BMAT(J,K)=B(J,K)
c      CTEMP(J,K)=0.D0
c      TEST(J,K)=0.D0
c      BINV(J,K)=0.D0
   50 CONTINUE
   60 CONTINUE
C
C  CHECK #1 - IS BMAT A SYMPLECTIC MATRIX?
C                BMAT*RJ*BMAT(TRANSPOSED)=RJ ?
C  (MAY BY-PASS AFTER DEBUGGING)
C
          if(itflg.ne.0) then
      DO 90 J  =1,6
      DO 80 K  =1,6
      ctemp(j,k)=0.0d0
      DO 70 LYN=1,6
      CTEMP(J,K)=CTEMP(J,K)+RJ(J,LYN)*BMAT(K,LYN)
   70 CONTINUE
   80 CONTINUE
   90 CONTINUE
      DO 120 J  =1,6
      DO 110 K  =1,6
      test(j,k)=0.0d0
      DO 100 LYN=1,6
      TEST(J,K)=TEST(J,K)+BMAT(J,LYN)*CTEMP(LYN,K)
  100 CONTINUE
  110 CONTINUE
  120 CONTINUE
C
C  CHECK FOR SYMPLECTICITY
C
      ERROR=0.D0
      DO 140 J=1,6
      DO 130 K=1,6
      ERROR=ERROR+DABS(TEST(J,K)-RJ(J,K))/36.0d0
c      TEST(J,K)=0.D0
c      CTEMP(J,K)=0.D0
  130 CONTINUE
  140 CONTINUE
      IF (ERROR.GT.1.D-10) then
       do 141 ima=1,mattot
       if(madr(ima).eq.index) goto 142
  141  continue
  142  WRITE(iout,1400)(name(inm,ima),inm=1,8),error
       If(iso.ne.0)WRITE(isout,1400)(name(inm,ima),inm=1,8),error
 1400 FORMAT(' ***BMAT for element : ',8a1,
     >' FAILS TO BE SYMPLECTIC, ERROR =',E14.6)
      endif
         endif
C
C  NOW INVERT BMAT TO GET BINV = -RJ*BMAT(TRANSPOSED)*RJ
C
c      DO 170 J  =1,6
c      DO 160 K  =1,6
c      ctemp(j,k)=0.0d0
c      DO 150 LYN=1,6
c      CTEMP(J,K)=CTEMP(J,K)+BMAT(LYN,J)*RJ(LYN,K)
c  150 CONTINUE
c  160 CONTINUE
c  170 CONTINUE
c      DO 200 J  =1,6
c      DO 190 K  =1,6
c      DO 180 LYN=1,6
c      BINV(J,K)=BINV(J,K)-RJ(J,LYN)*CTEMP(LYN,K)
c  180 CONTINUE
c  190 CONTINUE
c  200 CONTINUE
      do 170 j=1,5,2
      do 160 k=1,5,2
      binv(j,k)=bmat(k+1,j+1)
      binv(j+1,k+1)=bmat(k,j)
      binv(j,k+1)=-bmat(k,j+1)
      binv(j+1,k)=-bmat(k+1,j)
  160 continue
  170 continue
C
C  CHECK #2 - IS BINV A VALID INVERSE OF BMAT?
C
C               BINV*BMAT = RI ?
C
C  (MAY BYPASS AFTER DEBUGGING)
C
          if(itflg.ne.0) then
      DO 230 J  =1,6
      DO 220 K  =1,6
      test(j,k)=0.0d0
      DO 210 LYN=1,6
      TEST(J,K)=TEST(J,K)+BINV(J,LYN)*BMAT(LYN,K)
  210 CONTINUE
  220 CONTINUE
  230 CONTINUE
      ERROR=0.D0
      DO 250 J=1,6
      DO 240 K=1,6
      ERROR=ERROR+DABS(TEST(J,K)-RI(J,K))/36.0d0
c      TEST(J,K)=0.D0
c      CTEMP(J,K)=0.D0
  240 CONTINUE
  250 CONTINUE
      IF (ERROR.GT.1.D-06) then
       do 251 ima=1,mattot
       if(madr(ima).eq.index) goto 252
  251  continue
  252  WRITE(iout,2500) (name(inm,ima),inm=1,8),error
       if(iso.ne.0)WRITE(isout,2500) (name(inm,ima),inm=1,8),error
 2500 FORMAT(' ***BMAT for element : ',8a1,
     >' FAILS inversion , ERROR =',E14.6)
      endif
          endif
C      IF (ERROR.GT.1.D-03) WRITE(6,2500) ERROR
C 2500 FORMAT(38H ***BINV FAILS TO INVERT BMAT, ERROR =,E14.6)
C
C  FINALLY, SET UP CMAT, THE NONLINEAR TRANSFORMATION CLOSE TO THE
C  IDENTITY
C
      DO 280 J  =1,6
      DO 270 K  =1,27
c      cmat(j,k)=0.0d0
c      DO 260 LYN=1,6
c      CMAT(J,K)=CMAT(J,K)+BINV(J,LYN)*B(LYN,K)
c  260 CONTINUE
      sum=0.0d0
      DO 260 LYN=1,6
      blynk=B(lyn,k)
      if(blynk.ne.0.0d0) then
        sum=sum+BINV(J,LYN)*BLYNK
      endif
  260 CONTINUE
      cmat(j,k)=sum
  270 CONTINUE
  280 CONTINUE
C
C  CHECK #3 - IS 6X6 PART OF CMAT EQUAL TO THE IDENTITY RI?
C
C  (CAN BYPASS AFTER DEBUGGING)
C
         if(itflg.ne.0) then
      ERROR=0.D0
      DO 300 J=1,6
      DO 290 K=1,6
      ERROR=ERROR+DABS(RI(J,K)-CMAT(J,K))/36.0d0
  290 CONTINUE
  300 CONTINUE
      IF (ERROR.GT.1.D-06) then
       do 301 ima=1,mattot
       if(madr(ima).eq.index) goto 302
  301  continue
  302  WRITE(iout,3000)(name(inm,ima),inm=1,8),error
       if(iso.ne.0)WRITE(isout,3000)(name(inm,ima),inm=1,8),error
 3000 FORMAT(' *** for element : ',8a1,
     >' linear part of cmat misses identity, ERROR =',E14.6)
      endif
C      IF (ERROR.GT.1.D-03) WRITE(6,3000) ERROR
C 3000 FORMAT(48H ***LINEAR PART OF CMAT MISSES IDENTITY, ERROR =,E14.6)
C     WRITE(6,33333)((CMAT(IW,JW),JW=1,27),IW=1,6)
C3333 FORMAT(' IN CMAP CMAT IS:',/,6(5(' ',5E12.4,/),' ',2E12.4,/))
C     WRITE(6,44444)((BMAT(IW,JW),JW=1,6),IW=1,6)
C4444 FORMAT(' IN CMAP BMAT IS:',/,6(' ',6E12.4,/))
          endif
      RETURN
      END
      SUBROUTINE CNTROL
C---- CONTROL ROUTINE FOR "MAD" PROGRAM
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
C-----------------------------------------------------------------------
C---- ELEMENT TABLE
      PARAMETER         (MAXELM = 5000)
      COMMON /ELMNAM/   KELEM(MAXELM),KETYP(MAXELM),KELABL(MAXELM)
      CHARACTER*8       KELEM,KELABL*14
      CHARACTER*4       KETYP
      COMMON /ELMDAT/   IELEM1,IELEM2,IETYP(MAXELM),IEDAT(MAXELM,3),
     +                  IELIN(MAXELM)
      COMMON /ELMCNT/   IECNT(MAXELM)
C---- MACHINE STRUCTURE FLAGS
      COMMON /FLAGS/    INVAL,NEWCON,NEWPAR,PERI,STABX,STABZ,SYMM
      LOGICAL           INVAL,NEWCON,NEWPAR,PERI,STABX,STABZ,SYMM
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- FLAGS FOR I/O
      COMMON /IOFLAG/   SCAN,ERROR,SKIP,ENDFIL,INTER
      LOGICAL           SCAN,ERROR,SKIP,ENDFIL,INTER
C---- LINK TABLE
      PARAMETER         (MAXLST = 14000)
      COMMON /LPDATA/   IUSED,ILDAT(MAXLST,6)
C---- PAGE HEADER
      COMMON /PAGTIT/   KTIT,KVERS,KDATE,KTIME
      CHARACTER*8       KTIT*80,KVERS,KDATE,KTIME
C---- PARAMETER TABLE
      PARAMETER         (MAXPAR = 19000)
      COMMON /PARNAM/   KPARM(MAXPAR)
      CHARACTER*8       KPARM
      COMMON /PARDAT/   IPARM1,IPARM2,IPTYP(MAXPAR),IPDAT(MAXPAR,2),
     +                  IPLIN(MAXPAR)
      COMMON /PARVAL/   PDATA(MAXPAR)
      COMMON /PARLST/   IPLIST,IPNEXT(MAXPAR)
C---- MACHINE PERIOD DEFINITION
      COMMON /PERIOD/   IPERI,IACT,NSUP,NELM,NFREE,NPOS1,NPOS2
C---- INPUT BUFFER
      COMMON /RDBUFF/   KLINE(81)
      CHARACTER*1       KLINE
      CHARACTER*80      KTEXT
      EQUIVALENCE       (KTEXT,KLINE(1))
C---- SEQUENCE TABLE
      PARAMETER         (MAXPOS = 10000)
      COMMON /SEQNUM/   ITEM(MAXPOS)
      COMMON /SEQFLG/   PRTFLG(MAXPOS)
      LOGICAL           PRTFLG
C-----------------------------------------------------------------------
      COMMON /UNITS/    KFLAGU
      COMMON /NEWBM/    NEWBMO
      COMMON /NOECHO/   NOECHO
      COMMON/CUPLO/LOTOUP,UPTOLO(26)
      DIMENSION UPLO(26)
      CHARACTER*26      LOTOUP
      CHARACTER*1       UPTOLO,UPLO
C-----------------------------------------------------------------------
      PARAMETER         (NCOMM = 19)
      CHARACTER*8       KCOMM(NCOMM),KKEYW,KNAME
      LOGICAL           INTRAC
      LOGICAL           PFLAG
C-----------------------------------------------------------------------
      DATA UPLO       /'A','B','C','D','E','F','G','H','I','J',
     +                   'K','L','M','N','O','P','Q','R','S','T',
     +                   'U','V','W','X','Y','Z'/
      DATA KCOMM
     +    /'DUMP    ','RETURN  ','LINE    ','PARAMETE',
     +     'CALL    ','STOP    ','TITLE   ',
     +     'USE     ','OPEN    ','CLOSE   ','DIMAT   ',
     +     'UTRANSPO','UMAD    ','USTANDAR','EXPLODE ',
     +     'NEWBEAMO','NOECHO  ','ECHO    ','COSY    '/
C-----------------------------------------------------------------------
      LOTOUP='abcdefghijklmnopqrstuvwxyz'
      DO 11 ICH=1,26
   11 UPTOLO(ICH)=UPLO(ICH)
      NEWBMO = 0
      NOECHO = 0
      SCAN  = .FALSE.
      INTER = INTRAC()
C---- COMMAND LOOP -----------------------------------------------------
  100 CONTINUE
      PFLAG = .TRUE.
C---- SKIP SEPARATORS
        ERROR = .FALSE.
        SKIP  = .FALSE.
        CALL RDSKIP(';')
C---- END OF FILE READ?
        IF (ENDFIL) THEN
          IF (IDATA .EQ. 5) THEN
            KTEXT = 'STOP!'
          ELSE
            KTEXT = 'RETURN!'
          ENDIF
          ENDFIL = .FALSE.
        ENDIF
        ILCOM = ILINE
C---- LABEL OR KEYWORD
        CALL RDWORD(KNAME,LNAME)
        IF (LNAME .EQ. 0) THEN
          CALL RDFAIL
          WRITE (IECHO,910)
          ERROR = .TRUE.
          GO TO 800
        ENDIF
C---- IF NAME IS LABEL, READ KEYWORD
        IF (KLINE(ICOL) .EQ. ':') THEN
          CALL RDNEXT
            if(kline(icol).eq.'=') then
              KKEYW = 'PARAMETE'
              LKEYW = 8
              PFLAG = .FALSE.
                                   else
          CALL RDWORD(KKEYW,LKEYW)
          IF (LKEYW .EQ. 0) THEN
            CALL RDFAIL
            WRITE (IECHO,920)
            ERROR = .TRUE.
            GO TO 800
          ENDIF
            endif
C---- PARAMETER
        ELSE IF(KLINE(ICOL).EQ.'=') THEN
          KKEYW = 'PARAMETE'
          LKEYW = 8
          PFLAG = .FALSE.
C---- BEAMLINE WITH FORMAL ARGUMENT LIST
        ELSE IF(KLINE(ICOL).EQ.'(') THEN
          KKEYW = 'LINE'
          LKEYW = 4
C---- NAME WAS KEYWORD
        ELSE
          KKEYW = KNAME
          LKEYW = LNAME
          KNAME = '        '
          LNAME = 0
        ENDIF
C---- KNOWN COMMAND KEYWORD?
        CALL RDLOOK(KKEYW,LKEYW,KCOMM,1,NCOMM,ICOMM)
        IF (ICOMM .NE. 0) THEN
          GO TO (110,120,130,140,150,160,170,180,190,200,
     +           210,220,230,240,250,260,270,280,290), ICOMM
C---- "DUMP" --- DUMP DATA STRUCTURE
  110       CALL DUMP
          GO TO 500
C---- "RETURN" --- REVERT TO NORMAL INPUT FILE
  120       CALL XRETRN
          GO TO 500
C---- "LINE" --- DEFINE BEAM LINE
  130       CALL LINE(KNAME,LNAME)
          GO TO 500
C---- "PARAMETER" --- DEFINE PARAMETER
  140       CALL PARAM(KNAME,LNAME,PFLAG)
          GO TO 500
C---- "CALL" --- INPUT FROM ALTERNATE FILE
  150       CALL XCALL
          GO TO 500
C---- "STOP" --- END OF RUN
  160     RETURN
C---- "TITLE" --- DEFINE PAGE TITLE
  170       CALL TITLE
          GO TO 500
C---- "USE" --- DEFINE SUPERPERIOD
  180       CALL USE
          GO TO 500
C---- "OPEN" --- OPEN A FILE
  190       CALL XOPEN
          GO TO 500
C---- "CLOSE" --- CLOSE A FILE
  200       CALL XCLOSE
          GO TO 500
C---- "DIMAT" --- DIMAT COMMANDS
  210       IF(SCAN)CALL RDEND(103)
            CALL DIMATD
            CALL DIMAIN
          GO TO 500
C---- "UTRANSPORT", TRANSPORT UNITS
  220       KFLAGU=2
          GO TO 500
C---- "UMAD", MAD UNITS
  230       KFLAGU=1
          GO TO 500
C---- "USTANDARD", STANDARD UNITS
  240       KFLAGU=0
          GO TO 500
  250       CALL XPLODE
          GO TO 500
C---- 'NEWBEAMO' CALL DIMAT WITH NEW BEAMLINE ONLY
  260       NEWBMO = 1
            IF(SCAN)CALL RDEND(103)
            CALL DIMATD
            CALL DIMAIN
          GO TO 500
  270       NOECHO = 1
          GOTO 500
  280       NOECHO=0
          goto 500
  290     call cosy
          goto 500
  500     CONTINUE
C---- UNKNOWN COMMAND, MUST BE ELEMENT KEYWORD
        ELSE
          CALL ELMDEF(KKEYW,LKEYW,KNAME,LNAME)
        ENDIF
C---- IF ERROR, FIND END OF COMMAND AND ENTER SCAN MODE
  800   IF (ERROR) THEN
          IF (INTER) THEN
            WRITE (IECHO,930)
          ELSE IF (.NOT. SCAN) THEN
            WRITE (IECHO,940)
            SCAN = .TRUE.
          ENDIF
          CALL RDFIND(';')
        ENDIF
      GO TO 100
C-----------------------------------------------------------------------
  910 FORMAT(' *** ERROR *** COMMAND KEYWORD OR LABEL EXPECTED'/' ')
  920 FORMAT(' *** ERROR *** COMMAND KEYWORD EXPECTED'/' ')
  930 FORMAT(' ***** RETYPE COMMAND *****')
  940 FORMAT('0... ENTER SCANNING MODE'/' ')
C-----------------------------------------------------------------------
      END
c
c2345678901234567890123456789012345678901234567890123456789012345678901234567890
c------------------------------------------------------------------DONE
c                                                                     |
c rewritten 08.04.2015 to update cavity model                         V
c
C   ************************************
      subroutine cmcomp(ielm,iep,icav)
C   ************************************
c
c
c input data 
c  lcavity - used to determine rf wavelength
c             rflambda=2*lcavity/rncell
c  omega   - called "convert" here; set by rf wavelength 
c             omega=2*pi*clight/rflambda
c  deltae  - maximum gain of cavity
c  phi0    - phase at which cavity is run,
c            relative to phase giving maximum
c            energy gain deltae
c  e0      - injection kinetic energy into cavity (total energy is e0+rm0)
c
      implicit double precision (a-h,o-z)
      logical lcvfst
      PARAMETER    (MXELMD = 3000)
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      parameter    (MXCEB = 2000)
      common/cebcav/cebmat(6,6,mxceb),estart,ecav(mxceb),
     >ipos(mxceb),icavtot,icebflg,iestflg,icurcav
      common /cmc/ez(1401),dezdz(1401),lcvfst
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      dimension gjp(1402),gj(1402),bj(1402),tj(1402),pj(1402)
c
c
      rm0=1.d3*emass
      rrm0=1.d0/rm0
      rclight=1.d0/clight
c
c     inputs
c
      iad=iadr(ielm)
      rlength=eldat(iad)
c
c     injection energy - only 1st cavity reads from eldat(iad+1) and that is
c                        done at code initialization to set estart; 
c                        other cavities get injection energy from 
c                        previous cavities
c
      if(icav.eq.1) then
        e0=estart
                    else
        e0=ecav(icav-1)
      endif
      deltae=eldat(iad+2)
c
c kluge up trap for zero gradient (9/16/1994)
c
      if (deltae.eq.0.d0) then
         ecav(icav)=e0    
         do 1509 j=1,6 
         do 1509 i=1,6 
           if(i.eq.j) then
                      cebmat(i,j,icav)=1.d0 
                      else
                      cebmat(i,j,icav)=0.d0  
           endif
 1509    continue
         cebmat(2,1,icav)=rlength
         cebmat(4,3,icav)=rlength
         return
      endif
      phi0=eldat(iad+3)*pi/180.d0
      rncell=eldat(iad+4)
      rflambda=2.d0*rlength/rncell
      rffreq=clight/rflambda
      rkwave=TWOPI/rflambda
      omega=TWOPI*rffreq
      rnstep=eldat(iad+5)
      nstep=nint(rnstep)
c
      call findphisf(deltae,e0,sf,phiref,rflambda,rncell,rnstep)
c
                write(40,*) ' ' 
                write(40,*) ' e0=      ' ,e0
                write(40,*) ' deltae=  ' ,deltae
                write(40,*) ' phi0=    ' ,phi0*180/pi
                write(40,*) ' ' 
                write(40,*) 'sf, phiref are',sf,(phiref*180/pi)
                write(40,*) ' ' 
c
c things agree with VB model to here: same sf, phiref to precision of Newton search-------------------
c
      phitot=phi0+phiref
c
c loop to generate and save matrix
c
C      deltaz=rflambda/(2.d0*rncell) DDDDUUUUUUUHHHHHH!!!!
      deltaz=rflambda/(2.d0*rnstep)
c fixed 08.06.2015
      tk=0.d0
c fixed 08.06.2015
      zk=0.d0
      ek=e0+rm0
      pk=dsqrt(ek*ek-rm0*rm0)
      betak=pk/ek
c
c     initialise matrix for DIMAD variable change - all non-stated elements are zero
c     
      a11=1.d0
      a12=0.d0
      a21=0.d0
      a22=pk
      a33=1.d0/(betak*clight)
      a34=0.d0
      a43=0.d0
c fixed 08.06.2015
c fixed again... :(
      a44=pk*pk/ek
c
c initial integration step for matrix: drift to half step length
c
c   update centroid time and position
c
      tk=tk+(deltaz/2.d0)/(betak*clight)
      zk=zk+(deltaz/2.d0)
      b11=1.d0
      b12=(deltaz/2.d0)/pk
      b21=0.d0
      b22=1.d0
      b33=1.d0
      b34=-1.d0*(deltaz/2.d0)*(rm0*rm0)/(clight*pk*pk*pk)
      b43=0.d0
      b44=1.d0
c multiply matrices and store result in c - zero elements are eliminated
      c11 = b11*a11 + b12*a21
      c12 = b11*a12 + b12*a22
      c21 = b21*a11 + b22*a21 
      c22 = b21*a12 + b22*a22
      c33 = b33*a33 + b34*a43
      c34 = b33*a34 + b34*a44
      c43 = b43*a33 + b44*a43
      c44 = b43*a34 + b44*a44
ccc
ccc diagnostic printing
ccc
cc      write(41,*) ' '
cc      write(41,*) ' before looping '
cc      write(41,*) c11, c12
cc      write(41,*) c21, c22
cc      write(41,*) c33, c34
cc      write(41,*) c43, c44
c
c loop over rest of cavity: accelerate, drift
c
      kount2=0
      do while (zk.lt.rlength)
      kount2=kount2+1
c        update centroid energy, momentum, and velocity
         ek=ek-deltaz*fz(zk,tk,rflambda,sf,phitot)
         pk=dsqrt(ek*ek-rm0*rm0)
         betak=pk/ek
c
c   accelerating kick - all none-stated elements are zero
c
      b11=1.d0
      b12=0.d0
c23456789012345678901234567890123456789012345678901234567890123456789012
      b21= -0.5d0*((omega*betak/clight) 
     &          *sf*dsin(rkwave*zk)*dsin((omega*tk)+phitot)
     &   -rkwave*sf*dcos(rkwave*zk)
     &             *dcos((omega*tk)+phitot))*(deltaz/betak)
      b22=1.d0
      b33=1.d0
      b34=0.d0
      b43=(sf*dsin(rkwave*zk))*omega*dsin((omega*tk)+phitot)*deltaz
      b44=1.d0
c   fold into matrix
      a11 = b11*c11 + b12*c21
      a12 = b11*c12 + b12*c22
      a21 = b21*c11 + b22*c21
      a22 = b21*c12 + b22*c22
      a33 = b33*c33 + b34*c43
      a34 = b33*c34 + b34*c44
      a43 = b43*c33 + b44*c43
      a44 = b43*c34 + b44*c44
cc      write(41,*) ' '
cc      write(41,*) ' for loop number', kount2
cc      write(41,*) ' after acceleration kick ', zk, tk, ek, pk, betak
cc      write(41,*) a11,a12
cc      write(41,*) a21,a22
cc      write(41,*) a33,a34
cc      write(41,*) a43,a44
c    update time and position
      tk=tk+deltaz/(betak*clight)
      zk=zk+deltaz
c
c    set drift matrix
c
      b11=1.d0
      b12=deltaz/pk
      b21=0.d0
      b22=1.d0
      b33=1.d0
c fixed 08.06.2015
      b34=(-1.d0*deltaz*rm0*rm0)/(clight*pk*pk*pk)
c fixed 08.06.2015 in rev-4
      b43=0.d0
      b44=1.d0
c multiply matrices and store result in c - zero elements are eliminated
      c11 = b11*a11 + b12*a21
      c12 = b11*a12 + b12*a22
      c21 = b21*a11 + b22*a21 
      c22 = b21*a12 + b22*a22
      c33 = b33*a33 + b34*a43
      c34 = b33*a34 + b34*a44
      c43 = b43*a33 + b44*a43
      c44 = b43*a34 + b44*a44
cc      write(41,*) ' '
cc      write(41,*) ' for loop number', kount2
cc      write(41,*) ' after drift ', zk, tk, ek, pk, betak
cc      write(41,*) c11,c12
cc      write(41,*) c21,c22
cc      write(41,*) c33,c34
cc      write(41,*) c43,c44
      end do
c
c final drift was a full step - so drift back a half step
c
      tk=tk-(deltaz/2)/(betak*clight)
      zk=zk-(deltaz/2)
c
      b11=1.d0
      b12=(-0.5d0*deltaz)/pk
      b21=0.d0
      b22=1.d0
      b33=1.d0
      b34=(0.5d0*deltaz)*(rm0*rm0)/(clight*pk*pk*pk)
c fixed 08.06.2015
      b43=0.d0
      b44=1.d0
c
      a11 = b11*c11 + b12*c21
      a12 = b11*c12 + b12*c22
      a21 = b21*c11 + b22*c21
      a22 = b21*c12 + b22*c22
      a33 = b33*c33 + b34*c43
      a34 = b33*c34 + b34*c44
      a43 = b43*c33 + b44*c43
      a44 = b43*c34 + b44*c44
c
c back to DIMAD variables
c
      b11=1.d0
      b12=0.d0
      b21=0.d0
      b22=1.d0/pk
      b33=betak*clight
      b34=0.d0
      b43=0.d0
      b44=ek/(pk*pk)
c
c generate final product; result is in c_jk
c
      c11 = b11*a11 + b12*a21
      c12 = b11*a12 + b12*a22
      c21 = b21*a11 + b22*a21 
      c22 = b21*a12 + b22*a22
      c33 = b33*a33 + b34*a43
      c34 = b33*a34 + b34*a44
      c43 = b43*a33 + b44*a43
      c44 = b43*a34 + b44*a44
      ecav(icav)=ek-rm0
      do 19999 i=1,6
      do 19998 j=1,6
      cebmat(i,j,icav)=0.d0   
19998 continue
19999 continue
      cebmat(1,1,icav)=c11
      cebmat(1,2,icav)=c21
      cebmat(2,1,icav)=c12
      cebmat(2,2,icav)=c22
      cebmat(3,3,icav)=c11
      cebmat(3,4,icav)=c21
      cebmat(4,3,icav)=c12
      cebmat(4,4,icav)=c22
      cebmat(5,5,icav)=c33
      cebmat(5,6,icav)=c43
      cebmat(6,5,icav)=c34
      cebmat(6,6,icav)=c44
c
      write(40,*) ' '
      write(40,*) ' '
      write(40,*) 'final energy',ek
      write(40,*) ' '
      write(40,*) ' '
      write(40,9999) c11,c12,c13,c14
      write(40,9999) c21,c22,c23,c24
      write(40,9999) c31,c32,c33,c34
      write(40,9999) c41,c42,c43,c44
 9999 format(1h ,6(e21.14,x))
      write(40,*) ' '
      write(40,*) ' '
      write(40,*) ' det Mx = ',c11*c22-c21*c12
      write(40,*) ' det Ml = ',c33*c44-c34*c43
      write(40,*) ' '
      write(40,*) ' '
      write(40,*) ' momentum ratio pin/pout ',
     & dsqrt(((e0+rm0)**2-rm0**2)/((ek)**2-rm0**2))
      write(40,*) ' '
      write(40,*) ' '
      return
      end
c
c2345678901234567890123456789012345678901234567890123456789012345678901234567890
c------------------------------------------------------------------DONE
c                                                                     |
c rewritten 08.04.2015 to update cavity model                         V
c
c
      subroutine findphisf(egainneed,e0,sf,phiref,
     &                                     rflambda,rncell,rnstep)
c
c reads required maximum energy gain, injection energy for cavity
c and returns scale factor for SUPERFISH data sf and
c reference phase phiref, at which energy gain is the maximum
c value egainneed
c
      implicit double precision (a-h,o-z)
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
c
      rm0=1.d3*emass
c
c initial guess based on scaling superfish data
c
      egainfish=rflambda*rncell/4
      gammatarget=(egainneed+e0+rm0)/rm0        
      sf=egainneed/egainfish
c
c approximate reference phase from running earlier versions of code
c
c      phiref=1.5d0*pi*dexp(-0.25d0/(e0/rm0))
       phiref=PI/2
c
c
c newton search for required amplitude and reference phase
c
c   tolerances
c
      tol   =1.d-9
      epssf =0.001
      epsphi=0.001
c   initialise variables
      do 1000 k=1,50
       sftest=sf
       phitest=phiref
       gamma0=(e0+rm0)/rm0
c      tk=0.d0
       gamma1  =gamma0
       sftest1 =sftest
       phitest1=phitest
       gamma2  =gamma0
       sftest2 =sftest+epssf
       phitest2=phitest
       gamma3  =gamma0
       sftest3 =sftest-epssf
       phitest3=phitest
       gamma4  =gamma0
       sftest4 =sftest
       phitest4=phitest+epsphi
       gamma5  =gamma0
       sftest5 =sftest
       phitest5=phitest-epsphi
c 
c SYNTAX:      call getgamma(sftest1,phitest1,gamma1,rflambda,rncell,rnstep)
c 
       call getgamma(sftest1,phitest1,gamma1,rflambda,rncell,rnstep)
       call getgamma(sftest2,phitest2,gamma2,rflambda,rncell,rnstep)
       call getgamma(sftest3,phitest3,gamma3,rflambda,rncell,rnstep)
       call getgamma(sftest4,phitest4,gamma4,rflambda,rncell,rnstep)
       call getgamma(sftest5,phitest5,gamma5,rflambda,rncell,rnstep)
c
       rdgds   = 0.002d0/(gamma2-gamma3)
       dgdp    = 500.d0*(gamma4-gamma5)
       rd2gdp2 = 1.d-6/(gamma4-(2*gamma1)+gamma5)
       sf    =  sftest  -  (gamma1-gammatarget)*rdgds
       phiref=  phitest 
     &                  - rd2gdp2*dgdp
      if((dabs(sf-sftest)+dabs(phiref-phitest)).lt.tol) goto 2000
 1000 continue
      write(40,*) ' '
      write(40,*) ' nonconvergent newton search '
 2000 continue
      return
      end
c
c------------------------------------------------------------------DONE
c                                                                     |
c rewritten 08.04.2015 to update cavity model                         V
c
c
      subroutine getgamma(sf, phi, gamma,rflambda,rncell,rnstep)
      implicit double precision (a-h,o-z)
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      rm0=1.d3*emass
      rrm0=1.d0/rm0   
      rclight=1.d0/clight
      tk=0.d0
      zk=0.d0
      rlcavity=rncell*rflambda/2.d0
      deltaz=rflambda/(2.d0*rnstep)
c
c first integration (half) step
c
      tk=tk+(deltaz/2.d0)*rclight*gamma/dsqrt(gamma*gamma-1.d0)
      zk=zk+(deltaz/2.d0)
       do while (zk.lt.rlcavity)
        gamma=gamma-deltaz*rrm0*fz(zk,tk,rflambda,sf,phi)
        tk=tk+deltaz*rclight*gamma/dsqrt(gamma*gamma-1.d0)
        zk=zk+deltaz
       end do
      end 
c-------------------------------------------------------------------DONE
c                                                                      |
c rewritten 08.04.2015 for new cavity model                            V
c
      double precision function fz(z,t,rflambda,sf,phi)
      implicit double precision (a-h,o-z)
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      fz=sf*dsin(twopi*z/rflambda)*dcos((twopi*clight*t/rflambda)+phi)
      return
      end
c
c-------------------------------------------------------------------DONE
c                                                                      |
c rewritten 08.04.2015 for new cavity model                            V
c
c
      double precision function dfzdz(z,t,rflambda,sf,phi)
      implicit double precision (a-h,o-z)
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      dfzdz=(twopi*sf/rflambda)*dcos(twopi*z/rflambda)
     &              *dcos((twopi*clight*t/rflambda)+phi)
      return
      end
C   ************************************
      SUBROUTINE COLPRE(IAD)
C     ***********************
        IMPLICIT REAL*8 (A-H,O-Z)
      PARAMETER    (MXELMD = 3000)
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/COLL/COLENG, XSIZE, YSIZE, ISHAPE
C
      COLENG = ELDAT(IAD)
      XSIZE = ELDAT(IAD+1)
      YSIZE = ELDAT(IAD+2)
      ISHAPE = ELDAT(IAD+3)
      RETURN
      END
      SUBROUTINE COMMAD
C---- DUMMY ROUTINE: COMMON VARIABLES FOR MAD DATA STRUCTURE
C-----------------------------------------------------------------------
C---- BLOCK /ELMENT/ -- CURRENT ELEMENT
C     EL                CURRENT ELEMENT LENGTH
C     EK(6)             KICK DUE TO ELEMENT
C     RE(6,6)           FIRST ORDER TRANSFER MATRIX
C     REP(6,6)          D(RE) / D(DELTA)
C     TE(6,6,6)         SECOND ORDER TRANSFER MATRIX
C     ORBIT(6)          ORBIT VECTOR IN CURRENT ELEMENT
C---- BLOCK /ELMNAM/ -- ELEMENT TABLE (1)
C     KELEM(IELEM)      NAME OF ELEMENT 'IELEM'
C     KETYP(IELEM)      ELEMENT TYPE IDENTIFIER
C---- BLOCK /ELMDAT/ -- ELEMENT TABLE (2)
C     IELEM1            END OF ELEMENT NAME LIST
C     IELEM2            BEGIN OF FORMAL ARGUMENT LISTS
C     IETYP(IELEM)      TYPE OF ELEMENT 'IELEM'
C     IEDAT(IELEM,*)    DATA POINTERS FOR ELEMENT 'IELEM'
C     IELIN(IELEM)      DEFINITION LINE FOR ELEMENT 'IELEM'
C---- BLOCK /ELMCNT/ -- ELEMENT TABLE (3)
C     IECNT(IELEM)      OCCURRENCE COUNT FOR ELEMENT 'IELEM'
C---- BLOCK /FLAGS/ --- MACHINE STRUCTURE FLAGS
C     INVAL             TRUE, IF INITIAL VALUES ARE SET
C     NEWCON            TRUE, IF NEW CONSTRAINT ENTERED
C     NEWPAR            TRUE, IF NEW PARAMETER ENTERED
C     PERI              TRUE, IF PERIOD IS DEFINED
C     STABX             TRUE, IF HORIZONTAL MOTION IS STABLE
C     STABZ             TRUE, IF VERTICAL MOTION IS STABLE
C     SYMM              TRUE, IF CURRENT BEAM LINE IS SYMMETRIC
C---- BLOCK /IODATA/ -- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
C     IDATA             CURRENT LOGICAL INPUT UNIT
C     IPRNT             LOGICAL OUTPUT UNIT
C     IECHO             CURRENT LOGICAL UNIT FOR INPUT ECHO
C     ILINE             CURRENT INPUT LINE NUMBER
C     ILCOM             FIRST INPUT LINE OF CURRENT COMMAND
C     ICOL              CURRENT INPUT CHARACTER POSITION
C     IMARK             POSITION WHERE COMMENTS BEGIN ON CURRENT LINE
C     NWARN             NUMBER OF WARNING MESSAGES
C     NFAIL             NUMBER OF ERROR MESSAGES
C---- BLOCK /IOFLAG/ -- FLAGS FOR I/O
C     SCAN              TRUE, IF PROGRAM WORKS IN SCANNING MODE
C     ERROR             TRUE, IF FATAL ERROR IN CURRENT COMMAND
C     SKIP              TRUE, IF CURRENT COMMAND IS TO BE SKIPPED
C     ENDFIL            TRUE, IF END OF FILE WAS READ
C     INTER             TRUE, IF PROGRAM RUNS INTERACTIVELY
C---- BLOCK /LPDATA/ -- LINK TABLE
C     IUSED             NUMBER OF ALLOCATED CELLS
C     ILDAT(ICELL,*)    LIST CELL STORAGE
C---- BLOCK /OUTPNT/ -- OUTPUT BUFFER (1)
C     ISAVE             LOGICAL UNIT FOR "SAVE" COMMAND
C     LBUF              CURRENT OUTPUT COLUMN POSITION
C---- BLOCK /OUTBUF/ -- OUTPUT BUFFER (2)
C     KBUF              CURRENT OUTPUT LINE FOR "SAVE" COMMAND
C---- BLOCK /PAGTIT/ -- PAGE HEADER
C     KTIT              PAGE TITLE
C     KVERS             PROGRAM VERSION
C     KDATE             DATE
C     KTIME             TIME OF DAY
C---- BLOCK /PARNAM/ -- PARAMETER TABLE (1)
C     KPARM(IPARM)      NAME OF PARAMETER 'IPARM'
C---- BLOCK /PARDAT/ -- PARAMETER TABLE (2)
C     IPARM1            END OF PARAMETER NAME LIST
C     IPARM2            BEGIN OF ELEMENT PARAMETER LISTS
C     IPTYP(IPARM)      TYPE OF PARAMETER 'IPARM'
C     IPDAT(IPARM,*)    DATA POINTERS FOR PARAMETER 'IPARM'
C     IPLIN(IPARM)      DEFINITION LINE FOR PARAMETER 'IPARM'
C---- BLOCK /PARVAL/ -- PARAMETER TABLE (3)
C     PDATA(IPARM)      VALUE OF PARAMETER 'IPARM'
C---- BLOCK /PARLST/ -- PARAMETER TABLE (4)
C     IPLIST            POINTER TO EVALUATION LIST
C     IPNEXT(IPARM)     LINK FIELD FOR EVALUATION LIST
C---- BLOCK /PERIOD/ -- MACHINE PERIOD DEFINITION
C     IPERI             BEAM LINE INDEX FOR SUPERPERIOD
C     IACT              POINTER TO ACTUAL ARGUMENT LIST
C     NSUP              NUMBER OF SUPERPERIODS
C     NELM              NUMBER OF PHYSICAL ELEMENTS IN SUPERPERIOD
C     NFREE             FREE ADDRESS IN SEQUENCE TABLE
C     NPOS1,NPOS2       RANGE FOR MAIN BEAM LINE
C---- INITIAL DATA:
C     AMASS             PARTICLE MASS
C     CHARGE            PARTICLE CHARGE (MULTIPLE OF ELECTRON CHARGE)
C     PC                MOMENTUM TIMES C IN GEV
C     ENERGY            TOTAL ENERGY IN GEV
C     BETAI             1 / BETA = C / VELOCITY
C     GAMMAI            1 / GAMMA = MASS / ENERGY
C---- DATA FOR REFERENCE PARTICLE:
C     PC0               MOMENTUM TIMES C IN GEV
C     E0                ENERGY IN GEV
C     BI                1 / BETA = C / VELOCITY
C     GI                1 / GAMMA = MASS / ENERGY
C     BI2               1 / BETA**2
C     GI2               1 / GAMMA**2
C     BI2GI2            1 / (BETA**2*GAMMA**2)
C     FACMUL(0:5)       MULTIPOLE FACTORS (+-1/N!) OR 1
C---- BLOCK /RDBUFF/ -- INPUT BUFFER
C     KLINE(81)=KTEXT   CURRENT INPUT LINE
C---- BLOCK /SEQNUM/ -- SEQUENCE TABLE (1)
C     ITEM(IPOS)        ELEMENT INDEX FOR POSITION 'IPOS'
C---- BLOCK /SEQFLG/ -- SEQUENCE TABLE (2)
C     PRTFLG(IPOS)      TRUE, IF PRINT DESIRED IN POSITION IPOS
C---- BLOCK /STACK/ --- STACK FOR EXPRESSION ENCODING AND DECODING
C     LEV               CURRENT STACKING LEVEL
C     IOP(50)           STACKED OPERATION CODES
C     IVAL(50)          STACKED OPERANDS
C-----------------------------------------------------------------------
      END
      SUBROUTINE COMPL
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      COMMON/V/AL,ALO2,VV(27),X1,X2,X3,X4,X5,X6,Y1,Y2,Y3,Y4,Y5,Y6
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      IF(DABS(X1).LT.1.0D-30)X1=0.0D0
      IF(DABS(X2).LT.1.0D-30)X2=0.0D0
      IF(DABS(X3).LT.1.0D-30)X3=0.0D0
      IF(DABS(X4).LT.1.0D-30)X4=0.0D0
      IF(DABS(X5).LT.1.0D-30)X5=0.0D0
      IF(DABS(X6).LT.1.0D-30)X6=0.0D0
      VV(1)=X1
      VV(2)=X2
      VV(3)=X3
      VV(4)=X4
      VV(5)=X5
      VV(6)=X6
      VV(7)=X1*X1
      VV(8)=X1*X2
      VV(9)=X1*X3
      VV(10)=X1*X4
      VV(11)=X1*X5
      VV(12)=X1*X6
      VV(13)=X2*X2
      VV(14)=X2*X3
      VV(15)=X2*X4
      VV(16)=X2*X5
      VV(17)=X2*X6
      VV(18)=X3*X3
      VV(19)=X3*X4
      VV(20)=X3*X5
      VV(21)=X3*X6
      VV(22)=X4*X4
      VV(23)=X4*X5
      VV(24)=X4*X6
      VV(25)=X5*X5
      VV(26)=X5*X6
      VV(27)=X6*X6
      RETURN
      END
      SUBROUTINE CONDF(IEND)
C     *********************
      IMPLICIT REAL*8 (A-H,O-Z)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/CONDEF/REFEN
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
      NCHAR=0
      NDIM=mxinp
      NDATA=-1
      NIPR=1
      CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NIPR)
      DO 1 IC=1,NDATA,2
      NGT=DATA(IC)
      GOTO(10,20,30,40,50,60,70,80,90,100,110,120),NGT
      WRITE(IOUT,10001)NGT
10001 FORMAT(//,'  ERROR IN THE CONSTANT ORDER NUMBER ',I6,/)
      CALL HALT(230)
   10 PI=DATA(IC+1)
      TWOPI=2.0D0*PI
      CRDEG=PI/180.0D0
      GOTO 1
   20 CLIGHT=DATA(IC+1)
      CMAGEN=10.0D10/CLIGHT
      GOTO 1
   30 EMASS=DATA(IC+1)
      GOTO 1
   40 ERAD=DATA(IC+1)
      GOTO 1
   50 ECHG=DATA(IC+1)
      GOTO 1
   60 REFEN=DATA(IC+1)
      GOTO 1
   70 TOLLSQ=DATA(IC+1)
      GOTO 1
   80 MAXFAC=DATA(IC+1)
      GOTO 1
   90 EXPEL2=DATA(IC+1)
      GOTO 1
  100 ETAFAC=DATA(IC+1)
      GOTO 1
  110 SIGFAC=DATA(IC+1)
      GOTO 1
  120 IPTYP=DATA(IC+1)
      GOTO 1
    1 CONTINUE
      WRITE(IOUT,10002)
10002 FORMAT(//,'     THE NEW CONSTANT VALUES ARE ',//)
      CALL SHOCON(IEND)
      RETURN
      END
      SUBROUTINE CORCHK(IE)
C     *********************
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER     (MAXCOR = 600)
      COMMON/CORR/CORVAL(MAXCOR,4),ICRID(MAXCOR),
     >ICRPOS(MAXCOR),ICRSET(MAXCOR),
     >ICROPT(MAXCOR),NCORR,NCURCR,ICRFLG,ICRCHK,ALMNEL,ICRPTR,NPARC
      COMMON/CORSET/DCX1,DCX2,DCXR1,DCXR2,DCY1,DCY2,DCYR1,DCYR2,
     >DCXP,DCYP,DCDEL
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      COMMON/LNGTH/TLENG,ALENG(MXELMD),ACLENG(MAXPOS)
      COMMON/MISSET/DX1,DX2,DXP1,DXP2,DY1,DY2,DYP1,DYP2,
     >DZ1,DZ2,DZC1,DZS1,DZC2,DZS2,DDEL,I,IEP,MNEL
      DCX1=0.0D0
      DCX2=0.0D0
      DCXR1=0.0D0
      DCXR2=0.0D0
      DCY1=0.0D0
      DCY2=0.0D0
      DCYR1=0.0D0
      DCYR2=0.0D0
      DCXP=0.0D0
      DCYP=0.0D0
      DCDEL=0.0D0
      ALMNEL=ALENG(MNEL)
C     DO 1 ICR=1,NCORR
C     IF((ICRPOS(ICR).EQ.IE).AND.(ICRSET(ICR).EQ.1))GOTO 2
C   1 CONTINUE
C     RETURN
    1 IF(ICRPTR.GT.NCORR)RETURN
      IF(ICRPOS(ICRPTR).LT.IE)THEN
        ICRPTR=ICRPTR+1
        GOTO 1
      ENDIF
      IF(ICRPOS(ICRPTR).GT.IE)RETURN
      IF(ICRSET(ICRPTR).NE.1)RETURN
      ICR=ICRPTR
      NCURCR=ICR
      ICRCHK=1
      IOPT=ICROPT(ICR)
      IF(IOPT.GT.2)GOTO 30
      DCYP=CORVAL(NCURCR,3)
      DCDEL=CORVAL(NCURCR,4)
      IF(IOPT.EQ.2)GOTO 20
      IF(IOPT.EQ.1)GOTO 10
      DCX1=CORVAL(NCURCR,1)
      DCX2=-DCX1
      DCY1=CORVAL(NCURCR,2)
      DCY2=-DCY1
      GO TO 100
   10 DCX1=CORVAL(NCURCR,1)
      DCX2=0.0D0
      DCYR1=-DCX1/(ALMNEL)
      DCYR2=-DCYR1
      DCY1=CORVAL(NCURCR,2)
      DCY2=0.0D0
      DCXR1=-DCY1/(ALMNEL)
      DCXR2=-DCXR1
      GOTO 100
   20 DCX1=0.0D0
      DCX2=CORVAL(NCURCR,1)
      DCYR1=DCX2/(ALMNEL)
      DCYR2=-DCYR1
      DCY1=0.0D0
      DCY2=CORVAL(NCURCR,2)
      DCXR1=DCY2/(ALMNEL)
      DCXR2=-DCXR1
      GOTO 100
   30 CONTINUE
      ICRCHK=2
      DCXP=CORVAL(NCURCR,1)
      DCYP=CORVAL(NCURCR,2)
      GOTO 100
  100 RETURN
      END
C-----------------------------------------------------------------------
      SUBROUTINE cosy
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER(I-N)
C---- PARAMETER TABLE
      PARAMETER         (MAXPAR = 19000)
      COMMON /PARNAM/   KPARM(MAXPAR)
      CHARACTER*8       KPARM
      COMMON /PARDAT/   IPARM1,IPARM2,IPTYP(MAXPAR),IPDAT(MAXPAR,2),
     +                  IPLIN(MAXPAR)
      COMMON /PARVAL/   PDATA(MAXPAR)
      COMMON /PARLST/   IPLIST,IPNEXT(MAXPAR)
C---- SEQUENCE TABLE
      PARAMETER         (MAXPOS = 10000)
      COMMON /SEQNUM/   ITEM(MAXPOS)
      COMMON /SEQFLG/   PRTFLG(MAXPOS)
      LOGICAL           PRTFLG
C---- MACHINE PERIOD DEFINITION
      COMMON /PERIOD/   IPERI,IACT,NSUP,NELM,NFREE,NPOS1,NPOS2
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- UNITS
      COMMON /UNITS/    KFLAGU
      COMMON /NEWBM/    NEWBMO
C---- DIMAT COMMON BLOCKS
      PARAMETER         (MAXELM = 5000)
      PARAMETER         (MXELMD = 3000)
      PARAMETER         (MAXMAT = 500)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXLIST = 40)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(MXELMD),LABEL(MXELMD)
      CHARACTER*8 NAME
      CHARACTER*14 LABEL
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELMD,NOP,
     <NLIST(2*MXLIST)
      COMMON/LNGTH/TLENG,ALENG(MXELMD),ACLENG(MAXPOS)
      PARAMETER  (mxlcnd = 200)
      COMMON/MONIT/VALMON(MXLCND,4,3)
C---- ELEMENT TABLE
      COMMON /ELMNAM/   KELEM(MAXELM),KETYP(MAXELM),KELABL(MAXELM)
      CHARACTER*8       KELEM,KELABL*14
      CHARACTER*4       KETYP
      COMMON /ELMDAT/   IELEM1,IELEM2,IETYP(MAXELM),IEDAT(MAXELM,3),
     +                  IELIN(MAXELM)
C---- FLAGS FOR I/O
      COMMON /IOFLAG/   SCAN,ERROR,SKIP,ENDFIL,INTER
      LOGICAL           SCAN,ERROR,SKIP,ENDFIL,INTER
C-----------------------------------------------------------------------
      DIMENSION IMADDI(MAXELM)
      DIMENSION ITRANS(162)
      DATA ITRANS/
     +     110,120,130,140,150,160,111,112,
     + 113,114,115,116,122,123,124,125,126,
     + 133,134,135,136,144,145,146,155,156,
     + 166,210,220,230,240,250,260,211,212,
     + 213,214,215,216,222,223,224,225,226,
     + 233,234,235,236,244,245,246,255,256,
     + 266,310,320,330,340,350,360,311,312,
     + 313,314,315,316,322,323,324,325,326,
     + 333,334,335,336,
     + 344,345,346,355,356,366,410,420,430,
     + 440,450,460,411,412,413,414,415,416,
     + 422,423,424,425,426,433,434,435,436,
     + 444,445,446,455,456,466,510,520,530,
     + 540,550,560,511,512,513,514,515,516,
     + 522,523,524,525,526,533,534,535,536,
     + 544,545,546,555,556,566,610,620,630,
     + 640,650,660,611,612,613,614,615,616,
     + 622,623,624,625,626,633,634,635,636,
     + 644,645,646,655,656,666 /
      crdeg=3.141592653589793d0/180d0
      NFREE = 0
      NELMD = NELM
C
      I = 0
      DO 1001 IND=1,IELEM1
        IF(IETYP(IND).LE.0) GO TO 1001
        I = I + 1
        IMADDI(IND) = I
 1001 CONTINUE
C     WRITE (IPRNT,970) (ITEM(I), I=NPOS1,NPOS2-1)
C     WRITE (IPRNT,960) (KELEM(ITEM(I)), I=NPOS1,NPOS2-1)
      CALL PARORD(ERROR)
      IF(ERROR) THEN
        WRITE(IPRNT, 998)
        RETURN
      ENDIF
      CALL PAREVL
C---- GLOBAL PARAMETERS
C      IF (IPARM1 .GT. 0) THEN
C        WRITE (IPRNT,940)
C        WRITE (IPRNT,950) (I,KPARM(I),IPTYP(I),
C     +     IPDAT(I,1),IPDAT(I,2),IPLIN(I),PDATA(I),I=1,IPARM1)
C      ENDIF
C---- ELEMENT PARAMETERS
C      IF (IPARM2 .LE. MAXPAR) THEN
C        WRITE (IPRNT,990)
C        WRITE (IPRNT,980) (I,KPARM(I),IPTYP(I),
C     +     IPDAT(I,1),IPDAT(I,2),IPLIN(I),PDATA(I),I=IPARM2,MAXPAR)
C      ENDIF
C
C--- SET UNIT FLAG
      KUNITS = KFLAGU
C
      IF (NEWBMO.EQ.1) RETURN
C
      NA = 0
      NPAR = 1
      NMON = 0
      I = 0
      DO 1000 IND=1,IELEM1
        IF(IETYP(IND).LE.0) GO TO 1000
        I = I+1
        IF(NA.GT.MXELMD) THEN
          WRITE(IPRNT,930)
          CALL HALT(7)
        ENDIF
        NAME(I) = KELEM(IND)
        LABEL(I) = KELABL(IND)
        IADR(I) = NPAR
        INMAD = IEDAT(IND,1)
        NA = NA +1
        IF(NPAR.GT.MAXDAT) THEN
          WRITE(IPRNT,931)
          CALL HALT(6)
          RETURN
        ENDIF
        GO TO (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,
     +         16,17,18,19,20,21,22,23,24,25,26,27,
     +         28,29,30) IETYP(IND)
C---DRIFT
    1   write(iprnt,10010)name(i),pdata(inmad)
10010 format(' procedure  ',a8,' ; dl ',
     >   e24.16,' ; endprocedure ;')
        GO TO 1000
C---RBEND
    2   al= PDATA(INMAD)
        ang= PDATA(INMAD+1)
        ak1= PDATA(INMAD+2)
        ak2= PDATA(INMAD+6)
        e1= PDATA(INMAD+1)/2.0D0
        r1= PDATA(INMAD+7)
        gap= PDATA(INMAD+9)
        fint= PDATA(INMAD+10)
        e2= PDATA(INMAD+1)/2.0D0
        r2= PDATA(INMAD+8)
        gapx = PDATA(INMAD+11)
        fintx = PDATA(INMAD+12)
        tang = PDATA(INMAD+5)
        GO TO 33
C       WRITE(IPRNT,995)
C---SBEND
    3   al= PDATA(INMAD)
        ang= PDATA(INMAD+1)
        ak1= PDATA(INMAD+2)
        ak2= PDATA(INMAD+6)
        e1= PDATA(INMAD+3)
        r1= PDATA(INMAD+7)
        gap= PDATA(INMAD+9)
        fint= PDATA(INMAD+10)
        e2= PDATA(INMAD+4)
        r2= PDATA(INMAD+8)
        gapx = PDATA(INMAD+11)
        fintx = PDATA(INMAD+12)
        tang = PDATA(INMAD+5)
   33   continue
        if (kflagu.ne.2)then
        tang=tang/crdeg
        ang=ang/crdeg
        e1=e1/crdeg
        e2=e2/crdeg
        endif
        h=crdeg*ang/al
        rho=1.0d0/h
        if(kflagu.eq.0) then
        ak1=ak1
        ak2=ak2/2.0d0
        endif
        if(kflagu.eq.1) then
        tang=-tang
        ak1=-ak1
        ak2=ak2/2.0d0
        endif
        if(kflagu.eq.2) then
        ak1=-ak1*h*h
        ak2=ak2*h*h*h
        endif
        if(gap.eq.0.0d0) then
        gap=0.05
        write(iprnt,10042)
10042 format(' {**********************}',/,
     >'{WARNING : gap was zero, it is set to 0.05 ',/,
     > 'to avoid errors in COSY . WARNING}',/,
     >'{**********************}')
        endif
        s11=dtan(e1*crdeg)
        s21=dtan(e2*crdeg)
        s12=r1*dsqrt((1.0d0+s11*s11)**3)
        s22=r2*dsqrt((1.0d0+s21*s21)**3)
        nt=2
        write(iprnt,*)' { '
        write(iprnt,10040)name(i),ak1,ak2,s11,s12,s21,s22
10040 format(' procedure ',a8,' ; ',/,
     > 2x,'variable nt 1 ; variable kn 1 2 ; variable s1 1 2 ;',/,
     > 2x,'variable s2 1 2 ; ',/,
     > 2x,'nt:=2 ; kn(1):=',e24.16,' ; kn(2):=',e24.16,' ;',/,
     > 2x,' s1(1):=',e24.16,' ; s1(2):=',e24.16,' ; ',/,
     > 2x,' s2(1):=',e24.16,' ; s2(2):=',e24.16,' ;')
        write(iprnt,10041)al,ang,gap
10041 format(2x,' dip ',2e24.16,/,e24.16,' kn s1 s2 nt ; '
     > ,'endprocedure ;')
        write(iprnt,*)' } '
        write(iprnt,10043)name(i),rho,ang,gap,e1,r1,e2,r2
10043 format(' procedure ',a8,' ;  di ',1e24.16,/,
     > 3e24.16,/,3e24.16,' ; ',/,' endprocedure ;')
*        endif
        GO TO 1000
C---WIGGLER (UNIMPLEMENTED)
    4   goto 1
*        WRITE(IPRNT,996) PDATA(INMAD)
*        ELDAT(NPAR) = PDATA(INMAD)
*        ALENG(I) = PDATA(INMAD)
*        KODE(I) = 0
*        NPAR = NPAR + 1
*        GO TO 1000
C---QUADRUPOLE
    5   al=pdata(inmad)
        ak=pdata(inmad+1)
        if(kflagu.eq.1)ak=-ak
        aper=pdata(inmad+3)
        tang=pdata(inmad+2)
        if(kflagu.ne.2)tang=tang/crdeg
        if(kflagu.eq.1)tang=-tang
        tangm=-tang
        if(dabs(tang).lt.1.0d-6) then
          write(iprnt,10050)name(i),al,ak,aper
10050 format(' procedure  ',a8,' ; quad ',1e24.16,
     >  /,2e24.16,' ;',' endprocedure ;')
                                 else
        write(iprnt,10051)name(i),tangm,al,ak,aper,tang
10051 format(' procedure  ',a8,' ; ra ',e15.8,' ;',/,
     > 5x,'quad ',e24.16,/,2e24.16,' ;',/,
     > 5x,' ra ',e15.8,' ; endprocedure ;')
        endif
        GO TO 1000
C---SEXTUPOLE
    6   al=pdata(inmad)
        ak=pdata(inmad+1)
        if(kflagu.eq.0)ak=ak/2.0d0
        if(kflagu.eq.1)ak=-ak/2.0d0
        aper=pdata(inmad+3)
        tang=pdata(inmad+2)
        if(kflagu.ne.2)tang=tang/crdeg
        if(kflagu.eq.1)tang=-tang
        tangm=-tang
        if(dabs(tang).lt.1.0d-6) then
          write(iprnt,10060)name(i),al,ak,aper
10060 format(' procedure  ',a8,' ; sext ',1e24.16,
     >  /,2e24.16,' ;',' endprocedure ;')
                                 else
        write(iprnt,10061)name(i),tangm,al,ak,aper,tang
10061 format(' procedure  ',a8,' ; ra ',e15.8,' ;',/,
     > 5x,'sext ',1e24.16,/,2e24.16,' ;',/,
     > 5x,' ra ',e15.8,' ; endprocedure ;')
        endif
        GO TO 1000
C---OCTUPOLE 
    7   al=pdata(inmad)
        ak=pdata(inmad+1)
        if(kflagu.eq.0)ak=ak/6.0d0
        if(kflagu.eq.1)ak=-ak
        aper=pdata(inmad+3)
        tang=pdata(inmad+2)
        if(kflagu.ne.2)tang=tang/crdeg
        if(kflagu.eq.1)tang=-tang
        tangm=-tang
        if(dabs(tang).lt.1.0d-6) then
          write(iprnt,10070)name(i),al,ak,aper
10070 format(' procedure  ',a8,' ; octu ',3e16.8,
     >  ' ;',/,20x,' endprocedure ;')
                                 else
        write(iprnt,10071)name(i),tangm,al,ak,aper,tang
10071 format(' procedure  ',a8,' ; ra ',e15.8,' ;',/,
     > 5x,'octu ',3e16.8,' ;',/,
     > 5x,' ra ',e15.8,' ; endprocedure ;')
        endif
        GO TO 1000
C---MULTIPOLE
    8   al=pdata(inmad)
        factm=1.0
        if(al.eq.0.0d0)then
         factm=1.0e06
         al=1.0d0/factm
        endif
        sc=pdata(inmad+43)
        aper=pdata(inmad+44)
        tang=pdata(inmad+45)
        IO = 0
        DO 81 IM = 1,41,2
          IF(IPTYP(INMAD+IM).EQ.-1) GO TO 82
          iomax=io
   82     IO = IO + 1
   81   CONTINUE
        write(iprnt,10080)name(i),iomax,iomax,iomax
10080 format(' procedure ',a8,' ; ',/,
     > 5x,' variable na 1 ; variable i 1 ; ',/,
     > 5x,' variable ka 1 ',i3,' ; variable ta 1 ',i3,' ; ',/,
     > 5x,' na := ',i3,' ;',/,
     > 5x,' loop i 1 na ; ka(i) := 0 ; ta(i) := 0 ; endloop ;')
        IO = 0
        DO 83 IM = 1,41,2
          IF(IPTYP(INMAD+IM).EQ.-1) GO TO 84
          bat = PDATA(INMAD+IM)*factm
          tat = PDATA(INMAD+IM+1)
          tat=tat+tang
        if(kflagu.ne.2)tat=tat/crdeg
        if(kflagu.eq.1)tat=-tat
        if(kflagu.ne.2) bat=bat/bang(io)
        write(iprnt,10081)io,bat,io,tat
10081 format(5x,'ka(',i2,'):=',e14.6,' ; ta(',i2,'):=',e14.6,' ;')
   84     IO = IO + 1
   83   CONTINUE
        write(iprnt,10082)al,aper
10082 format(5x,' gmult ',e14.6,' ka ta na ',e14.6,' ;',/,
     > 20x,' endprocedure ;')
        GO TO 1000
C---SOLENOID (CAN HAVE QUADRUPOLE COMPONENT)
    9   goto1
*        ELDAT(NPAR) = PDATA(INMAD)
*        ELDAT(NPAR+1) = PDATA(INMAD+2)
*        ELDAT(NPAR+2) = PDATA(INMAD+1)
*        ELDAT(NPAR+3) = PDATA(INMAD+4)
*        ELDAT(NPAR+4) = PDATA(INMAD+3)
*        ALENG(I) = PDATA(INMAD)
*        KODE(I) = 15
*        NPAR = NPAR + 5
*        GO TO 1000
C---CAVITY
   10   goto1
*        ELDAT(NPAR) = PDATA(INMAD)
*        ELDAT(NPAR+1) = PDATA(INMAD+4)
*        ELDAT(NPAR+2) = PDATA(INMAD+1)
*        ELDAT(NPAR+3) = PDATA(INMAD+3)
*        ELDAT(NPAR+4) = PDATA(INMAD+2)
*        ALENG(I) = PDATA(INMAD)
*        KODE(I) = 7
*        NPAR = NPAR + 5
*        GO TO 1000
C---SEPARATOR (UNIMPLEMENTED)
   11   goto1
*        CONTINUE
*        WRITE(IPRNT,997) PDATA(INMAD)
*        ELDAT(NPAR) = PDATA(INMAD)
*        ALENG(I) = PDATA(INMAD)
*        KODE(I) = 0
*        NPAR = NPAR + 1
*        GO TO 1000
C----ROLL, GKICK IN DIMAT
   12   continue
        al = 0.
        dx = 0.
        dpx = 0.
        dy = 0.
        dpy = 0.
        dl = 0.
        dp = 0.
        angle = PDATA(INMAD)
        dz = 0.
        ient = 1.
        idep = 0.
        GO TO 2300
C---ZROT, GKICK IN DIMAT
   13   continue
        al = 0.
        dx = 0.
        dpx = PDATA(INMAD)
        dy = 0.
        dpy = 0.
        dl = 0.
        dp = 0.
        angle = 0.
        dz = 0.
        ient = 1.
        idep = 0.
        GO TO 2300
C---HKICK
   14   continue
        al = PDATA(INMAD)
        dx = 0.
        dpx = PDATA(INMAD+1)*DCOS(PDATA(INMAD+2))
        dy = 0.
        dpy = PDATA(INMAD+1)*DSIN(PDATA(INMAD+2))
        dl = 0.
        dp = 0.
        angle = 0.
        dz = 0.
        ient = 1.
        idep = 0.
        GO TO 2300
C---VKICK
   15   continue
        al = PDATA(INMAD)
        dx = 0.
        dpx = -PDATA(INMAD+1)*DSIN(PDATA(INMAD+2))
        dy = 0.
        dpy = PDATA(INMAD+1)*DCOS(PDATA(INMAD+2))
        dl = 0.
        dp = 0.
        angle = 0.
        dz = 0.
        ient = 1.
        idep = 0.
        GO TO 2300
C---HMONITOR, VMONITOR, MONITOR
   16   goto1
*   *     CONTINUE
   17   goto1
*   *     CONTINUE
   18   goto1
*   *     CONTINUE
*   *     DO 161 IE = 1,5
*          ELDAT(NPAR+IE-1) = PDATA(INMAD+IE-1)
*  161   CONTINUE
*        ELDAT(NPAR+5) = IETYP(IND) - 15
*        ALENG(I) = PDATA(INMAD)
*        KODE(I) = 13
*        NPAR = NPAR + 6
*        GO TO 1000
C---MARKER (DRIFT OF LENGTH 0 FOR NOW)
   19   continue
        al=0.0d0
        write(iprnt,10190)name(i),al
10190 format(' procedure  ',a8,' ; drift ',
     >   e24.16,' ; endprocedure ;')
        goto 1000
C--- ECOLLIMATOR, RCOLLIMATOR
   20   goto1
*        CONTINUE
   21   goto1
*        ELDAT(NPAR) = PDATA(INMAD)
*        ELDAT(NPAR+1) = PDATA(INMAD+1)
*        ELDAT(NPAR+2) = PDATA(INMAD+2)
*        IF (IETYP(IND).EQ.20) THEN
*          ELDAT(NPAR+3) = 2
*        ELSE
*          ELDAT(NPAR+3) = 1
*        ENDIF
*        ALENG(I) = PDATA(INMAD)
*        KODE(I) = 6
*        NPAR = NPAR + 4
*        GO TO 1000
C---QUADRUPOLE-SEXTUPOLE
   22   continue
        al = PDATA(INMAD)
        ak1 = PDATA(INMAD+1)
        ak2 = PDATA(INMAD+2)
        tang = PDATA(INMAD+3)
        aper = PDATA(INMAD+4)
        if(kflagu.eq.1) then
          ak1=-ak1
          ak2=-ak2/2.0d0
          tang=-tang
        endif
        if (kflagu.eq.0) ak2=ak2/2.0d0
        if(kflagu.ne.2) tang=tang/crdeg
        write(iprnt,10220)name(i)
10220 format(' procedure ',a8,' ; ',/,
     > 2x,' variable na 1 ; variable i 1 ; ',/,
     > 2x,' variable ka 1 2 ; variable ta 1 2 ; ',/,
     > 2x,' na := 2 ;',/,
     > 2x,' loop i 1 na ; ka(i) := 0 ; ta(i) := 0 ; endloop ;')
       write(iprnt,10221)ak1,tang,ak2,tang
10221 format(2x,'ka(1):=',e24.16,' ; ta(1):=',e24.16,' ; ',/,
     > 2x,'ka(2):=',e24.16,' ; ta(2):=',e24.16,' ; ')
        write(iprnt,10222)al,aper
10222 format(2x,' gmult ',e24.16,' ka ta na ',e24.16,' ;',/,
     > 20x,' endprocedure ;')
         goto1000
C---GENERAL KICK
   23   continue
        al = pdata(inmad)
        dx = pdata(inmad+1)
        dpx = pdata(inmad+2)
        dy = pdata(inmad+3)
        dpy = pdata(inmad+4)
        dl = pdata(inmad+5)
        dp = pdata(inmad+6)
        angle = pdata(inmad+7)
        dz = pdata(inmad+8)
        ient = pdata(inmad+9)
        idep = pdata(inmad+10)
*        CONTINUE
*        DO 231 IE=1,11
*        ELDAT(NPAR+IE-1) = PDATA(INMAD+IE-1)
*  231   CONTINUE
*        IF(ELDAT(NPAR+9).EQ.0) ELDAT(NPAR+9) = 1
*        ALENG(I) = PDATA(INMAD)
*        KODE(I) = 8
*        NPAR = NPAR + 11
 2300   continue
        if(kflagu.eq.2)angle=angle*crdeg
        if(kflagu.eq.1)angle=-angle
        write(iprnt,10230)name(i)
10230 format(' procedure ',a8,' ; ')
        alo2=al/2.0d0
        if(alo2.ne.0.0d0)write(iprnt,10231)alo2
10231 format(' dl',e14.6,' ;',$)
        if(ient.eq.1) then
         write(iprnt,10232)dx,dpx,dy,dpy,dl,angle,dp
10232 format(' gkin',4e14.6,/,' ',3e14.6,' ;',$)
        endif
        if(ient.eq.-1) then
         write(iprnt,10233)dx,dpx,dy,dpy,dl,angle,dp
10233 format(' gkout',4e14.6,/,' ',3e14.6,' ;',$)
        endif
        if(alo2.ne.0.0d0)write(iprnt,10231)alo2
        write(iprnt,10234)
10234 format(' endprocedure ;')
        GO TO 1000
C---ARBITRARY ELEMENT
  24    goto1
*        CONTINUE
*        DO 241 IE=1,21
*          ELDAT(NPAR+IE-1) = PDATA(INMAD+IE-1)
* 241    CONTINUE
*        ALENG(I) = PDATA(INMAD)
*        KODE(I) = 12
*        NPAR = NPAR + 21
*        GO TO 1000
C---TWISS ELEMENT
  25    goto1
*        CONTINUE
*        DO 251 IE = 1,7
*          ELDAT(NPAR+IE-1) = PDATA(INMAD+IE-1)
* 251    CONTINUE
*        ALENG(I) = PDATA(INMAD)
*        KODE(I) = 9
*        NPAR = NPAR + 7
*        GO TO 1000
C---GENERAL MATRIX ELEMENT
  26    goto1
*        CONTINUE
*        ELDAT(NPAR) = PDATA(INMAD)
*        ID = 1
*        DO 261 IE=1,162
*        IF(PDATA(INMAD+IE).EQ.0.0) GO TO 261
*        ELDAT(NPAR+ID) = ITRANS(IE)
*        ID = ID+1
*        ELDAT(NPAR+ID) = PDATA(INMAD+IE)
*        ID = ID+1
* 261    CONTINUE
*        ALENG(I) = PDATA(INMAD)
*        KODE(I) = 10
*        NPAR = NPAR + ID
*        GO TO 1000
C---LINAC CAVITY
   27   goto1
*        CONTINUE
*        ELDAT(NPAR) = PDATA(INMAD)
*        ELDAT(NPAR+1) = PDATA(INMAD+1)
*        ELDAT(NPAR+2) = PDATA(INMAD+2)
*        ELDAT(NPAR+3) = PDATA(INMAD+3)
*        ELDAT(NPAR+4) = PDATA(INMAD+4)
*        ELDAT(NPAR+5) = PDATA(INMAD+5)
*        ELDAT(NPAR+6) = PDATA(INMAD+6)
*        ALENG(I) = PDATA(INMAD)
*        KODE(I) = 17
*        NPAR = NPAR + 7
*        GO TO 1000
C---HV collimators (absorbers)
   28   goto1
*        CONTINUE
*        ELDAT(NPAR) = PDATA(INMAD)
*        ELDAT(NPAR+1) = PDATA(INMAD+1)
*        ELDAT(NPAR+2) = PDATA(INMAD+2)
*        ELDAT(NPAR+4) = PDATA(INMAD+3)
*        ELDAT(NPAR+4) = PDATA(INMAD+4)
*        ELDAT(NPAR+5) = PDATA(INMAD+5)
*        ELDAT(NPAR+6) = PDATA(INMAD+6)
*        ELDAT(NPAR+7) = PDATA(INMAD+7)
*        ELDAT(NPAR+8) = PDATA(INMAD+8)
*        ELDAT(NPAR+9) = PDATA(INMAD+9)
*        ELDAT(NPAR+10) = PDATA(INMAD+10)
*        ELDAT(NPAR+11) = PDATA(INMAD+11)
*        ELDAT(NPAR+12) = PDATA(INMAD+12)
*        ELDAT(NPAR+13) = PDATA(INMAD+13)
*        ELDAT(NPAR+14) = PDATA(INMAD+14)
*        ALENG(I) = PDATA(INMAD)
*        KODE(I) = 18
*        NPAR = NPAR + 15
*        GO TO 1000
C---quadac element : quadrupole imbedded in a linac cavity
   29   goto1
*        CONTINUE
*        ELDAT(NPAR) = PDATA(INMAD)
*        ELDAT(NPAR+1) = PDATA(INMAD+1)
*        ELDAT(NPAR+2) = PDATA(INMAD+2)
*        ELDAT(NPAR+3) = PDATA(INMAD+3)
*        ELDAT(NPAR+4) = PDATA(INMAD+4)
*        ELDAT(NPAR+5) = PDATA(INMAD+5)
*        ELDAT(NPAR+6) = PDATA(INMAD+7)
*        ELDAT(NPAR+7) = PDATA(INMAD+6)
*        ALENG(I) = PDATA(INMAD)
*        KODE(I) = 19
*        NPAR = NPAR + 8
*        GO TO 1000
C---cebcav element : cebaf cavity
   30  goto1
 1000 CONTINUE
        IF(NPAR.GT.MAXDAT) THEN
          WRITE(IPRNT,931)
          CALL HALT(6)
        ENDIF
      IADR(NA+1) = NPAR
C
C---FILL NORLST FROM ITEM
      write(iprnt,10090)
10090 format(' procedure mach ; ')
      IJ = 1
      II = 1
      DO 200 I=NPOS1,NPOS2-1
        IF(ITEM(I).GT.MAXELM) GO TO 200
        NORLST(IJ) = IMADDI(ITEM(I))
        II = II + 1
        IF(II.GE.MAXPOS) GO TO 200
        IJ = IJ + 1
 200  CONTINUE
      IF (II.GT.IJ) THEN
          WRITE(IPRNT,920) II
          CALL HALT(4)
      ENDIF
      ii=1
 500  itest=nelmd-ii+1
      if(itest.gt.7) then
      write(iprnt,10091)(name(norlst(ii+jj-1)),jj=1,7)
10091 format(' ',7(a8,' ; '))
      ii=ii+7
                      else
      write(iprnt,10091)(name(norlst(ii+jj-1)),jj=1,itest)
      write(iprnt,10092)
10092 format(' endprocedure ;')
      endif
      if(itest.gt.7)goto 500
C
C-----------------------------------------------------------------------
  900 FORMAT(' '/'1LIST OF ELEMENTS IN THE MACHINE AND KODE')
  901 FORMAT(' ',10F7.3,/' ',1X,10F7.3,/' ',1X,10F7.3,
     +           /' ',1X,10F7.3,/' ',1X,10F7.3,/' ',1X,10F7.3,
     +           /' ',1X,10F7.3,/' ',1X,10F7.3,/' ',1X,10F7.3,
     +           /' ',1X,10F7.3,/' ',1X,10F7.3,/' ',1X,10F7.3,
     +           /' ',1X,10F7.3,/' ',1X,10F7.3,/' ',1X,10F7.3,
     +           /' ',1X,10F7.3,/' ',1X,10F7.3,/' ',1X,10F7.3,
     +           /' ',1X,10F7.3,/' ',1X,10F7.3,/' ',1X,10F7.3,
     +           /' ',1X,10F7.3,/' ',1X,10F7.3,/' ',1X,10F7.3,
     +           /' ',1X,10F7.3,/' ',1X,10F7.3,/' ',1X,10F7.3,
     +           /' ',1X,10F7.3,/' ',1X,10F7.3,/' ',1X,10F7.3,
     +           /' ',1X,10F7.3,/' ',1X,10F7.3,/' ',1X,10F7.3)
  902 FORMAT(' ',I6,4X,A8,I8)
  910 FORMAT(' '/' LIST OF DEFINED ELEMENT TYPES  NAME, KODE, IADR',
     +            ' AND PARAMETERS')
  911 FORMAT(' ', A8, I8, I8)
  912 FORMAT(' '/' LIST OF MONITORS AND POSITIONS')
  913 FORMAT(' ', A8, I8)
  920 FORMAT(' ',I5,' ELEMENTS, TOO MANY FOR DIMAT (>MAXPOS),QUIT')
  930 FORMAT(' TOO MANY DISTINCT ELEMENT TYPES FOR DIMAT,>MXELMD QUIT')
  931 FORMAT(' NOT ENOUGH PARAMETER SPACE FOR DIMAT,>MAXDAT QUIT')
  940 FORMAT('1DUMP OF PARAMETER TABLE (1)')
  950 FORMAT(' ',I10,5X,A8,4I8,F15.6)
  960 FORMAT(' ',8A8)
  970 FORMAT(' ',8I8)
  980 FORMAT(' ',I10,5X,A8,4I8,F15.6)
  990 FORMAT('1DUMP OF PARAMETER TABLE (2)')
  995 FORMAT(' NO RBEND IN DIMAT, TREATED AS AN SBEND')
  996 FORMAT(' NO WIGGLER IN DIMAT, TREATED LIKE A DRIFT OF LENGTH ',
     +        F10.4)
  997 FORMAT(' NO SEPARATOR IN DIMAT, TREATED LIKE A DRIFT OF LENGTH ',
     +        F10.4)
  998 FORMAT(' ERROR FROM PARORD, RETURNING FROM DIMATD')
      RETURN
      END

      SUBROUTINE CORDAT(IEND)
C     ***********************
      IMPLICIT REAL*8 (A-H,O-Z)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER     (MAXCOR = 600)
      COMMON/CORR/CORVAL(MAXCOR,4),ICRID(MAXCOR),
     >ICRPOS(MAXCOR),ICRSET(MAXCOR),
     >ICROPT(MAXCOR),NCORR,NCURCR,ICRFLG,ICRCHK,ALMNEL,ICRPTR,NPARC
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
      CHARACTER*1 NINE
      DATA NINE/'9'/
      NCORR=0
    1 NOP = 0
      NCHAR=8
      INPRT=1
      NDIM=mxinp
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NOP,INPRT)
      IF((ICHAR(1).EQ.NINE).AND.(ICHAR(2).EQ.NINE))GO TO 99
      CALL ELID(ICHAR,NELID)
      NOP = -1
      NCHAR=0
      INPRT=1
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NOP,INPRT)
      IF((2*(NOP/2)).EQ.NOP)GOTO 2
      WRITE(IOUT,10001)
10001 FORMAT('  EVEN NUMBER OF DATA NEEDED : RUN STOPPED ')
      CALL HALT(222)
    2 IRNGE=NOP/2
      DO 3 JRNGE=1,IRNGE
      IRBEG=data(2*JRNGE-1)-1
      IREND=data(2*JRNGE)
      ICRT=IREND-IRBEG
      DO 4 JCRT=1,ICRT
      IF(NORLST(IRBEG+JCRT).NE.NELID)GOTO 4
      NCORR=NCORR+1
      IF(NCORR.GT.MAXCOR) THEN
            WRITE(IOUT,10003)MAXCOR
10003 FORMAT('  THE NUMBER OF CORRECTORS DEFINED IS GREATER THAN THE',
     >' MAXIMUM ALLOWED :',I5,/,'  CHANGE PARAMETER MAXCOR')
            CALL HALT(1)
      ENDIF
      ICRID(NCORR)=NELID
      ICRPOS(NCORR)=IRBEG+JCRT
    4 CONTINUE
    3 CONTINUE
      GOTO 1
   99 WRITE(IOUT,10002)NCORR,MAXCOR
10002 FORMAT(/,' TOTAL NUMBER OF CORRECTORS DEFINED :',I5,/,
     >' MAXIMUM ALLOWED IS PARAMETER MAXCOR :',I5,/)
      IF(NCORR.EQ.1)GOTO 8
      NCUR=0
    7 NCUR=NCUR+1
      DO 5 IC=1,NCUR
      IF(ICRPOS(NCUR+1).LT.ICRPOS(IC))GOTO 6
    5 CONTINUE
    9 IF((NCUR+1).EQ.NCORR)GOTO 8
      GOTO 7
    6 IPOSAV=ICRPOS(NCUR+1)
      IDSAV=ICRID(NCUR+1)
      NDIS=NCUR-IC+1
      DO 10 ICC=1,NDIS
      ICRPOS(NCUR+2-ICC)=ICRPOS(NCUR+1-ICC)
      ICRID(NCUR+2-ICC)=ICRID(NCUR+1-ICC)
   10 CONTINUE
      ICRPOS(IC)=IPOSAV
      ICRID(IC)=IDSAV
      GOTO 9
    8 CONTINUE
      DO 12 INC=1,NCORR
      DO 12 JNC=1,4
      CORVAL(INC,JNC)=0.0D0
   12 CONTINUE
      RETURN
      END
      SUBROUTINE CRESET
C     *****************
      IMPLICIT REAL*8 (A-H,O-Z)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER     (MAXCOR = 600)
      COMMON/CORR/CORVAL(MAXCOR,4),ICRID(MAXCOR),
     >ICRPOS(MAXCOR),ICRSET(MAXCOR),
     >ICROPT(MAXCOR),NCORR,NCURCR,ICRFLG,ICRCHK,ALMNEL,ICRPTR,NPARC
      COMMON/CORSET/DCX1,DCX2,DCXR1,DCXR2,DCY1,DCY2,DCYR1,DCYR2,
     >DCXP,DCYP,DCDEL
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      COMMON/MISSET/DX1,DX2,DXP1,DXP2,DY1,DY2,DYP1,DYP2,
     >DZ1,DZ2,DZC1,DZS1,DZC2,DZS2,DDEL,I,IEP,MNEL
       COMMON/V/AL,ALO2,VV(27),X1,X2,X3,X4,X5,X6,Y1,Y2,Y3,Y4,Y5,Y6
      Y6=Y6-DCDEL
      Y1=Y1+DCX2
      Y2=Y2+DCYR2
      Y3=Y3+DCY2
      Y4=Y4+DCXR2+(DCYP/(1.0D0+Y6))
      RETURN
      END
      SUBROUTINE CSET
C     ***************
      IMPLICIT REAL*8 (A-H,O-Z)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER     (MAXCOR = 600)
      COMMON/CORR/CORVAL(MAXCOR,4),ICRID(MAXCOR),
     >ICRPOS(MAXCOR),ICRSET(MAXCOR),
     >ICROPT(MAXCOR),NCORR,NCURCR,ICRFLG,ICRCHK,ALMNEL,ICRPTR,NPARC
      COMMON/CORSET/DCX1,DCX2,DCXR1,DCXR2,DCY1,DCY2,DCYR1,DCYR2,
     >DCXP,DCYP,DCDEL
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      COMMON/MISSET/DX1,DX2,DXP1,DXP2,DY1,DY2,DYP1,DYP2,
     >DZ1,DZ2,DZC1,DZS1,DZC2,DZS2,DDEL,I,IEP,MNEL
       COMMON/V/AL,ALO2,VV(27),X1,X2,X3,X4,X5,X6,Y1,Y2,Y3,Y4,Y5,Y6
      X1=X1+DCX1
      X2=X2+DCYR1+(DCXP/(1.0D0+X6))
      X3=X3+DCY1
      X4=X4+DCXR1+(DCYP/(1.0D0+X6))
      X6=X6+DCDEL
      RETURN
      END
      SUBROUTINE CURMV(IL,IC)
C     ***************
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/CTERM/IMACH,idt,IDIGIT(10),ESC
      CHARACTER*23 CMV
      CHARACTER*13 FMT2
      CHARACTER*9 FMT1
      CHARACTER*80 POS
      CHARACTER*40 POS1,POS2
      CHARACTER*1 CCUR(8),CBMV(23),IPOS(80),IDIGIT,ESC
      EQUIVALENCE (CMV,CBMV(1)),(CBMV(16),CCUR(1)),(POS,IPOS(1))
      EQUIVALENCE(IPOS(1),POS1),(IPOS(41),POS2)
      DIMENSION NCHAR(2)
      DATA NCHAR/4,8/
      DATA CMV /'WRTASCI(TR STR         '/
c      DATA POS1 /' !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFG'/
      DATA POS2 /'HIJKLMNOPQRSTUVWXYZ[\]^_`ABCDEFGHIJKLMNO'/
      DATA FMT2 /'(1H ,$,8A1,$)'/
      DATA FMT1 /'(1H ,8A1)'/
      GOTO(100,200),IDT
      WRITE(ISOUT,10001)IDT
10001 FORMAT(' ERROR ON TERMINAL ID IN CURMV : ',I3)
      CALL HALT(235)
  100 CONTINUE
C     QVT102
      CCUR(1)=ESC
      CCUR(2)='='
      CCUR(3)=IPOS(IL)
      CCUR(4)=IPOS(IC)
      GOTO 1000
  200 CONTINUE
C     VT100
      IL1=IL/10
      IL2=IL-IL1*10
      IC1=IC/10
      IC2=IC-IC1*10
      CCUR(1)=ESC
      CCUR(2)='['
      CCUR(3)=IDIGIT(IL1+1)
      CCUR(4)=IDIGIT(IL2+1)
      CCUR(5)=';'
      CCUR(6)=IDIGIT(IC1+1)
      CCUR(7)=IDIGIT(IC2+1)
      CCUR(8)='H'
      GOTO 1000
 1000 CONTINUE
      IW=NCHAR(IDT)
      IF(IMACH.EQ.2)WRITE(ISOUT,FMT2)(CCUR(JW),JW=1,IW)
      IF(IMACH.EQ.1)IK=KMAND(CMV,23)
      RETURN
      END
C***********************************************************************
      SUBROUTINE CVAR(ZNC,ZC,GAMMA,BETA)
C***********************************************************************
C
C  NEW VERSION TO CONVERT (X,X',Y,Y',L,DEL) TO (X,PX,Y,PY,-T,E)
C     ( ZC(5) IS DEFINED TO BE MINUS THE PATH LENGTH DEVIATION AND
C       ZC(6) IS THE ENERGY DEVIATION DIVIDED BY P0*C)
C                                                          (4/22/85)
      IMPLICIT REAL*8 (A-H,O-Z)
      DIMENSION ZNC(6),ZC(6)
      ZC(1)= ZNC(1)
      ZC(3)= ZNC(3)
      ZC(5)=-ZNC(5)
      FAC=(1.D0+ZNC(6))/DSQRT(1.D0+ZNC(2)**2+ZNC(4)**2)
      ZC(2)=FAC*ZNC(2)
      ZC(4)=FAC*ZNC(4)
      ZC(6)= (-1.D0/BETA)
     &      +DSQRT((1.D0+ZNC(6))**2+((1.D0-BETA**2)/(BETA**2)))
      RETURN
      END
C***********************************************************************
      SUBROUTINE dcosy(iend)
C***********************************************************************
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER         (MAXELM = 5000)
      PARAMETER         (MXELMD = 3000)
      PARAMETER         (MAXMAT = 500)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXLIST = 40)
      PARAMETER    (MAXPOS = 10000)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(MXELMD),LABEL(MXELMD)
      CHARACTER*8 NAME
      CHARACTER*14 LABEL
      COMMON/LNGTH/TLENG,ALENG(MXELMD),ACLENG(MAXPOS)
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      PARAMETER    (MXMTR = 5000)
      COMMON/MISTRK/AKMIS(15,MXMTR),KMPOS(MXMTR),IMEXP,NMTOT,MISPTR
      PARAMETER  (mxmis = 1000)
      COMMON/MIS/RMISA(8,MXMIS),MISELE(MXMIS),NMIS,NOPT,
     >NMISE,MISSEL(MXMIS),NMRNGE(MXMIS),
     >MSRNGE(2,10,MXMIS),MISFLG,MCHFLG
      COMMON/MISSET/DX1,DX2,DXP1,DXP2,DY1,DY2,DYP1,DYP2,
     >DZ1,DZ2,DZC1,DZS1,DZC2,DZS2,DDEL,I,IEP,MNEL
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      COMMON/CSEEDS/ISEED,IXG,IXS,IXMSTP,IMSD,IMOSTP,ISYNSD,ISYSTP,
     >ISDBEG,IBGSTP,IXES,IXESTP,IESBEG,IESTBG,isdcol
      parameter   (mxerr = 25)
      parameter   (MXEREL = 500)
      parameter   (MXERRG = 6)
      COMMON/cERR/ERRVAL(mxerr,mxerel),erv(mxerr,mxerel),NERELE(mxerel),
     > NERPAR(mxerr,mxerel),NERR,NEROPT,NERRE,MERSEL(mxerel),
     > NERNGE(mxerel),MERNGE(2,mxerrg,mxerel),MERFLG
      COMMON/ERSAV/SAV(mxerr),SAVMAT(6,27),IERSET,IER,IDE,IEMSAV
      PARAMETER  (MAXERR = 100)
      COMMON /ERRSRT/ ERRSRT(MAXERR),NERSRT,IERSRT,IERBEG
      PARAMETER  (mxlcnd = 200)
      PARAMETER  (mxlvar = 100)
      COMMON/MONIT/VALMON(MXLCND,4,3)
      COMMON/MONFIT/VALFA(MXLCND),WGHTA(MXLCND),ERRA(MXLCND),
     >AMULTA(MXLVAR,6),ADDA(MXLVAR,6),DELA(MXLVAR)
     >,NPARA(MXLVAR,6),NELFA(MXLVAR,6),
     >NPVARA(MXLVAR),INDA(MXLVAR,6),VALR(MXLCND),RMOSIG,
     >NMONA(MXLCND),NVALA(MXLCND),NVARA,NCONDA
     >,IALFLG,MONFLG,MONLST,NOPTER,
     >IAFRST,IMOOPT,IMSBEG,NALPRT
      PARAMETER     (MAXCOR = 600)
      COMMON/CORR/CORVAL(MAXCOR,4),ICRID(MAXCOR),
     >ICRPOS(MAXCOR),ICRSET(MAXCOR),
     >ICROPT(MAXCOR),NCORR,NCURCR,ICRFLG,ICRCHK,ALMNEL,ICRPTR,NPARC
      COMMON/CORSET/DCX1,DCX2,DCXR1,DCXR2,DCY1,DCY2,DCYR1,DCYR2,
     >DCXP,DCYP,DCDEL
      parameter    (MXBLOC = 100)
      common/cblock/
     >bx(mxbloc),bxp(mxbloc),by(mxbloc),byp(mxbloc),
     >bz(mxbloc),bzr(mxbloc),bdel(mxbloc),
     >sx(mxbloc),sxp(mxbloc),sy(mxbloc),syp(mxbloc),
     >sz(mxbloc),szr(mxbloc),sdel(mxbloc),sal(mxbloc),
     >dblx,dblxp,dbly,dblyp,dblz,dblzr,dbldel,dblal,
     >iebl(mxbloc),nel1(mxbloc),nel2(mxbloc),
     >ibt,ixbls,ixblstp,iblflg,iblchk,iblopt,iblsopt
      crdeg=3.141592653589793d0/180d0
      write(iout,10001)
10001 format(' ',
     >'procedure mach ; '
     >/,' ','variable erv 1 30 ; '
     >/,' ','procedure zeroerr ;'
     >/,' ','variable i 1 ; loop i 1 20 ; erv(i):=0 ; endloop ;'
     >/,' ','endprocedure ; '
     >/)
      DO 1000  nel=1,na
        iad=iadr(nel)
        kodep1=kode(nel)+1
        GO TO (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,
     +         16,17,18,19,20,21)kodep1
C---DRIFT
    1   continue
        al=eldat(iad)
        if (al.ne.0.0d0) then
        write(iout,10010)name(nel),al
10010 format(' procedure  ',a8,' ; dl ',
     >   e24.16,' ; endprocedure ;')
                         else
        write(iout,10011)name(nel)
10011 format(' procedure ',a8,' ; no:=no ; endprocedure ;')
        endif
        GO TO 1000
C---BEND
    2   al= eldat(iad)
        ang= eldat(iad+1)
        ak1= eldat(iad+2)
        ak2= eldat(iad+3)
        e1= eldat(iad+4)
        r1= eldat(iad+5)
        gap= eldat(iad+6)
        fint= eldat(iad+7)
        e2= eldat(iad+8)
        r2= eldat(iad+9)
        gapx = eldat(iad+10)
        fintx = eldat(iad+11)
        tang = eldat(iad+12)
        if(kunits.ne.2) then
        ang=ang/crdeg
        e1=e1/crdeg
        e2=e2/crdeg
        tang=tang/crdeg
        endif
        h=crdeg*ang/al
        if(kunits.ne.2) then
         ak1=ak1*h**2
         ak2=ak2*h**3
        endif
        if(kunits.eq.1) then
         tang=-tang
         ak1=-ak1
         ak2=ak2/2.0d0
        endif
        if(kunits.eq.0) then
         ak2=ak2/2.0d0
        endif
        if(gap.eq.0.0)then
        gap=0.05
        write(iout,10042)
10042 format(' {**********************}',/,
     >'{WARNING : gap was zero, it is set to 0.05 ',/,
     > 'to avoid errors in COSY . WARNING}',/,
     >'{**********************}')
        endif
        s11=dtan(e1*crdeg)
        s21=dtan(e2*crdeg)
        s12=r1*dsqrt((1.0d0+s11*s11)**3)
        s22=r2*dsqrt((1.0d0+s21*s21)**3)
        nt=2
        write(iout,10040)name(nel),ak1,ak2,s11,s12,s21,s22
10040 format(' procedure ',a8,' ; ',/,
     > 2x,'variable nt 1 ; variable kn 1 2 ; variable s1 1 2 ;',/,
     > 2x,'variable s2 1 2 ; ',/,
     > 2x,'nt:=2 ; ',/,'kn(1):=',e23.16,'+erv(1) ; kn(2):='
     >,e23.16,'+erv(2) ;',/,
     > 's1(1):=',e23.16,'+erv(3) ; s1(2):=',e23.16,'+erv(4) ; ',/,
     > 's2(1):=',e23.16,'+erv(5) ; s2(2):=',e23.16,'+erv(6) ;')
        write(iout,10041)al,ang,gap
10041 format(2x,' dip ',2e24.16,/,e24.16,' kn s1 s2 nt ; '
     > ,'endprocedure ;')
*        endif
        GO TO 1000
C---QUADRUPOLE
    3   al=eldat(iad)
        ak=eldat(iad+1)
        if(kunits.eq.1)ak=-ak
        aper=eldat(iad+2)
        tang=eldat(iad+3)
        if(kunits.ne.2)tang=tang/crdeg
        if(kunits.eq.1)tang=-tang
        tangm=-tang
        if(dabs(tang).lt.1.0d-6) then
          write(iout,10050)name(nel),al,ak,aper
10050 format(' procedure  ',a8,' ; quad ',1e24.16,
     >  /,e24.16,'+erv(1) ',e24.16,' ;',' endprocedure ;')
                                 else
        write(iout,10051)name(nel),tangm,al,ak,aper,tang
10051 format(' procedure  ',a8,' ; ra ',e15.8,' ;',/,
     > 5x,'quad ',e24.16,/,e24.16,'+erv(1) ',e24.16,' ;',/,
     > 5x,' ra ',e15.8,' ; endprocedure ;')
        endif
        GO TO 1000
C---SEXTUPOLE
    4   al=eldat(iad)
        ak=eldat(iad+1)
        if(kunits.eq.0)ak=ak/2.0d0
        if(kunits.eq.1)ak=-ak/2.0d0
        aper=eldat(iad+2)
        tang=eldat(iad+3)
        if(kunits.ne.2)tang=tang/crdeg
        if(kunits.eq.1)tang=-tang
        tangm=-tang
        if(dabs(tang).lt.1.0d-6) then
          write(iout,10060)name(nel),al,ak,aper
10060 format(' procedure  ',a8,' ; sext ',1e24.16,
     >  /,e24.16,'+erv(1) ',e24.16,' ;',' endprocedure ;')
                                 else
        write(iout,10061)name(nel),tangm,al,ak,aper,tang
10061 format(' procedure  ',a8,' ; ra ',e15.8,' ;',/,
     > 5x,'sext ',1e24.16,/,e24.16,'+erv(1) ',e24.16,' ;',/,
     > 5x,' ra ',e15.8,' ; endprocedure ;')
        endif
        GO TO 1000
C---MULTIPOLE
    6   al=eldat(iad)
        factm=1.0d0
        if(al.eq.0.0d0) then
         factm=1.0e06
         al=1.0d0/factm
        endif
        sc=eldat(iad+1)
        iadn=iadr(nel+1)
        tang=eldat(iadn-1)
        aper=eldat(iadn-2)
        np=eldat(iad+2)
        iomax=0
        do 81 npp=1,np
        io=eldat(iad+3+(npp-1)*3)-1
        if(io.gt.iomax)iomax=io
   81   CONTINUE
        write(iout,10080)name(nel),iomax,iomax,iomax
10080 format(' procedure ',a8,' ; ',/,
     > 5x,' variable na 1 ; variable i 1 ; ',/,
     > 5x,' variable ka 1 ',i3,' ; variable ta 1 ',i3,' ; ',/,
     > 5x,' na := ',i3,' ;',/,
     > 5x,' loop i 1 na ; ka(i) := 0 ; ta(i) := 0 ; endloop ;')
        do 84 npp=1,np
        io=eldat(iad+3+(npp-1)*3)-1
        do 83 ipp=1,iomax
        if(io.ne.ipp)goto 83
        bat=eldat(iad+3+(npp-1)*3+1)*sc*factm
        tat=eldat(iad+3+(npp-1)*3+2)
        tat=tat+tang
        if(kunits.ne.2) then
         tat=tat/crdeg
         bat=bat/bang(io)
        endif
        if(kunits.eq.1)tat=-tat
        iok=2*io-1
        iot=2*io
        write(iout,10081)io,bat,iok,io,tat,iot
10081 format(5x,'ka(',i2,'):=',e14.6,'+erv(',i2,') ; ta('
     >  ,i2,'):=',e14.6,'+erv(',i2,') ;')
   83   CONTINUE
   84   CONTINUE
        write(iout,10082)al,aper
10082 format(5x,' gmult ',e14.6,' ka ta na ',e14.6,' ;',/,
     > 20x,' endprocedure ;')
        GO TO 1000
C---SOLENOID (CAN HAVE QUADRUPOLE COMPONENT)
   16   write(iout,10101)
10101 format('{ solenoid',
     >' not translated in COSY input, replaced by drift}')
        goto1
C---CAVITY
    8   write(iout,10102)
10102 format('{ cavity',
     >' not translated in COSY input, replaced by drift}')
        goto1
C*******internally reserved code not operational here
   12   goto 1000
c******** no element defined with this code
   15   goto 1000
c******** no element defined with this code
   17   goto 1000
C---HMONITOR, VMONITOR, MONITOR
   14   write(iout,10103)
10103 format('{ monitors',
     >' not translated in COSY input, replaced by drift}')
        goto1
C--- ECOLLIMATOR, RCOLLIMATOR
    7   write(iout,10104)
10104 format('{ collimators',
     >' not translated in COSY input, replaced by drift}')
        goto1
C---QUADRUPOLE-SEXTUPOLE
    5   continue
        al = eldat(iad)
        ak1 = eldat(iad+1)
        ak2 = eldat(iad+2)
        tang = eldat(iad+4)
        aper = eldat(iad+3)
        if(kunits.eq.1) then
         ak1=-ak1
         ak2=-ak2/2.0d0
         tang=-tang
        endif
        if(kunits.eq.0) ak2=ak2/2.0d0
        if(kunits.ne.2) tang=tang/crdeg
        write(iout,10220)name(nel)
10220 format(' procedure ',a8,' ; ',/,
     > 2x,' variable na 1 ; variable i 1 ; ',/,
     > 2x,' variable ka 1 2 ; variable ta 1 2 ; ',/,
     > 2x,' na := 2 ;',/,
     > 2x,' loop i 1 na ; ka(i) := 0 ; ta(i) := 0 ; endloop ;')
       write(iout,10221)ak1,tang,ak2,tang
10221 format(
     > 2x,'ka(1):=',e24.16,'+erv(1) ; ta(1):=',e24.16,' ; ',/,
     > 2x,'ka(2):=',e24.16,'+erv(2) ; ta(2):=',e24.16,' ; ')
        write(iout,10222)al,aper
10222 format(2x,' gmult ',e24.16,' ka ta na ',e24.16,' ;',/,
     > 20x,' endprocedure ;')
         goto1000
C---GENERAL KICK
    9   continue
        al = eldat(iad)
        dx = eldat(iad+1)
        dpx = eldat(iad+2)
        dy = eldat(iad+3)
        dpy = eldat(iad+4)
        dl = eldat(iad+5)
        dp = eldat(iad+6)
        angle = eldat(iad+7)
        dz = eldat(iad+8)
        ient = eldat(iad+9)
        idep = eldat(iad+10)
        if(kunits.eq.2)angle=angle*crdeg
        if(kunits.eq.1)angle=-angle
        write(iout,10901)name(nel)
10901 format(' procedure ',a8,' ; ')
        alo2=al/2.0d0
        if(alo2.ne.0.0d0)write(iout,10902)alo2
10902 format(' dl',e14.6,' ;',$)
        if(ient.eq.1) then
         write(iout,10903)dx,dpx,dy,dpy,dl,angle,dp
10903 format(' gkin',4e14.6,/,' ',3e14.6,' ;',$)
        endif
        if(ient.eq.-1) then
         write(iout,10904)dx,dpx,dy,dpy,dl,angle,dp
10904 format(' gkout',4e14.6,/,' ',3e14.6,' ;',$)
        endif
        if(alo2.ne.0.0d0)write(iout,10902)alo2
        write(iout,10905)
10905 format(' endprocedure ; ')
        GO TO 1000
C---ARBITRARY ELEMENT
  13    write(iout,10106)
10106 format('{ abitrary element',
     >' not translated in COSY input, replaced by drift}')
        goto1
C---TWISS ELEMENT
  10    write(iout,10107)
10107 format('{ twiss element',
     >' not translated in COSY input, replaced by drift}')
        goto1
C---GENERAL MATRIX ELEMENT
  11    write(iout,10108)
10108 format('{ matrix',
     >' not translated in COSY input, replaced by drift}')
        goto1
C---LINAC CAVITY
   18   write(iout,10109)
10109 format('{ linac cavity',
     >' not translated in COSY input, replaced by drift}')
        goto1
C---HV collimators (absorbers)
   19   write(iout,10110)
10110 format('{ HV collimators',
     >' not translated in COSY input, replaced by drift}')
        goto1
C---quadac element : quadrupole imbedded in a linac cavity
   20   write(iout,10111)
10111 format('{ quadac',
     >' not translated in COSY input, replaced by drift}')
        goto1
C---cebcav element : cebaf cavity
   21   write(iout,10112)
10112 format('{ cebcav',
     >' not translated in COSY input, replaced by drift}')
        goto1
 1000 CONTINUE
      ntbeg=1
      iwn=0
      zero=0.0d0
  601 ITRBEG=1
      ITREND=NELM
      IF(IXMSTP.NE.0) THEN
           IXS=1
           IXMSTP=1
                      ELSE
           IXS=ISEED
      ENDIF
      IF(IXESTP.NE.0) THEN
           IXES=1
           IXESTP=1
                      ELSE
           IXES=ISEED
      ENDIF
      if(ixblstp.ne.0)then
       ixbls=1
       ixblstp=1
                      else
       ixbls=iseed
      endif
      IERSRT = 1
  603 ILIST=1
      MISPTR = 1
      ICRPTR = 1
      write(iout,99999)
99999 format(' zeroerr ; ')
      DO 110 IE=ITRBEG,ITREND
       IEP=IE
      NEL=NORLST(IE)
      MNEL=NEL
      IAD=IADR(NEL)
      MATADR=MADR(NEL)
      NT=KODE(NEL)
      if(iblflg.eq.1)call blockchk(ie,nel)
      if(iblchk.eq.1) then
C  set up block entry
       write(iout,11001)-dblx,-dblxp,-dbly,-dblyp,
     >     -dblz,-dblzr,-dbldel
      endif
      NTP1=NT+1
      GOTO(10000,1100,2000,3000,4000,5000,10000,10000,8000,
     >9000,9000,20000,12000,13000,20000,9000,110,9500,
     >18000,9000),NTP1
C
C (SKIP OVER ELEMENT IF KODE=16 - NO CODE 16 ELEMENTS)
C
C
C    TREATING DRIFTS : CODE 0 , NO ERRORS ,ALIGNMENTS, PARTICLE CHECK
C
10000 continue
      if(iwn.eq.5) then
       write(iout,20001)name(nel)
       iwn=0
20001 format(' ',a8,' ; ')
                   else
       write(iout,20002)name(nel)
20002 format(' ',a8,' ; ',$)
       iwn=iwn+1
      endif
      GOTO 99888
C
C  TREATING BENDS : CODE 1 ,ERRORS,MISALIGNEMENTS,PARTICLE CHECK
C       CORRECTOR ELEMENTS  AND SYNCHROTON RADIATION
C
 1100 MCHFLG=0
      ICRCHK=0
      ierset=0
      IF(ISYNFL.NE.0) CALL SYNPRE(IAD,NEL)
      IF(ICRFLG.EQ.1) CALL CORCHK(IE)
      IF(MISFLG.EQ.1) CALL MISCHK
      IF((MERFLG.EQ.1).OR.(ICRCHK.EQ.2)) CALL ESET(NEL,MATADR)
      if((icrchk.ne.0.or.mchflg.ne.0).and.iwn.gt.1)write(iout,88888)
88888 format(' ')
      if(icrchk.eq.1) then
CC  setup gkin
       write(iout,11001)dcx1,dcyr1,dcy1,dcxr1,zero,zero,ddel
      iwn=0
      endif
      if(icrchk.eq.2) then
CC  setup ckin
       write(iout,11002)zero,dcxp,zero,dcyp,zero,zero,zero
11002 format(' ckin ',4e14.6,/,' ',3e14.6,' ; ')
      iwn=0
      endif
      if(mchflg.eq.1) then
CC   setup gkin
       dzr=datan2(dzs1,dzc1)
       write(iout,11001)-dx1,-dxp1,-dy1,-dyp1,-dz1,-dzr,-ddel
11001 format(' gkin ',4e14.6,/,' ',3e14.6,' ; ')
       iwn=0
      endif
      if(iwn.eq.5) then
       write(iout,20001)name(nel)
       iwn=0
                   else
       write(iout,20002)name(nel)
       iwn=iwn+1
      endif
      if(mchflg.eq.1) then
cc  set up gkout
       dzr=datan2(dzs2,dzc2)
       write(iout,11003)-dx2,-dxp2,-dy2,-dyp2,-dz2,-dzr,ddel
11003 format(' gkout ',4e14.6,/,' ',3e14.6,' ; ')
       iwn=0
      endif
      if(icrchk.eq.2) then
cc  set up ckout
       write(iout,11004)zero,zero,zero,dcyp,zero,zero,zero
11004 format(' ckout ',4e14.6,/,' ',3e14.6,' ; ')
      iwn=0
      endif 
      if(icrchk.eq.1) then
cc  set up gkout
       write(iout,11003)dcx2,dcyr2,dcy2,dcxr2,zero,zero,-ddel
      iwn=0
      endif 
      GOTO 99888
C
C  TREATING quadS : CODE 2 ,ERRORS,MISALIGNEMENTS,PARTICLE CHECK
C       CORRECTOR ELEMENTS  AND SYNCHROTON RADIATION
C
 2000 MCHFLG=0
      ICRCHK=0
      ierset=0
      IF(ISYNFL.NE.0) CALL SYNPRE(IAD,NEL)
      IF(ICRFLG.EQ.1) CALL CORCHK(IE)
      IF(MISFLG.EQ.1) CALL MISCHK
      IF((MERFLG.EQ.1).OR.(ICRCHK.EQ.2)) CALL ESET(NEL,MATADR)
      if((icrchk.ne.0.or.mchflg.ne.0).and.iwn.gt.1)write(iout,88888)
      if(icrchk.eq.1) then
CC  setup gkin
       write(iout,11001)dcx1,dcyr1,dcy1,dcxr1,zero,zero,ddel
      iwn=0
      endif
      if(icrchk.eq.2) then
CC  setup ckin
       write(iout,11002)zero,dcxp,zero,dcyp,zero,zero,zero
      iwn=0
      endif
      if(mchflg.eq.1) then
CC   setup gkin
       dzr=datan2(dzs1,dzc1)
       write(iout,11001)-dx1,-dxp1,-dy1,-dyp1,-dz1,-dzr,-ddel
       iwn=0
      endif
      if(ierset.eq.1) then
       if(iwn.ge.3) then
        write(iout,88888)
        iwn=0
       endif
       do 2001 npp=1,mxerr
       npar=nerpar(npp,ide)-1
       if(npar.eq.-1)goto 2002
       ervl=erv(npp,ide)
       write(iout,11005)npar,ervl
11005 format(' erv(',i1,'):= ',e14.6,' ; ')
 2001 continue
 2002 continue
      endif
      if(iwn.eq.5) then
       write(iout,20001)name(nel)
       iwn=0
                   else
       write(iout,20002)name(nel)
       iwn=iwn+1
      endif
      if(ierset.eq.1) write(iout,2003)
 2003 format(' zeroerr ; ')
      if(mchflg.eq.1) then
cc  set up gkout
       dzr=datan2(dzs2,dzc2)
       write(iout,11003)-dx2,-dxp2,-dy2,-dyp2,-dz2,-dzr,ddel
       iwn=0
      endif
      if(icrchk.eq.2) then
cc  set up ckout
       write(iout,11004)zero,zero,zero,dcyp,zero,zero,zero
      iwn=0
      endif 
      if(icrchk.eq.1) then
cc  set up gkout
       write(iout,11003)dcx2,dcyr2,dcy2,dcxr2,zero,zero,-ddel
      iwn=0
      endif 
      GOTO 99888
C
C  TREATING sextS : CODE 3 ,ERRORS,MISALIGNEMENTS,PARTICLE CHECK
C       CORRECTOR ELEMENTS  AND SYNCHROTON RADIATION
C
 3000 MCHFLG=0
      ICRCHK=0
      ierset=0
      IF(ISYNFL.NE.0) CALL SYNPRE(IAD,NEL)
      IF(ICRFLG.EQ.1) CALL CORCHK(IE)
      IF(MISFLG.EQ.1) CALL MISCHK
      IF((MERFLG.EQ.1).OR.(ICRCHK.EQ.2)) CALL ESET(NEL,MATADR)
      if((icrchk.ne.0.or.mchflg.ne.0).and.iwn.gt.1)write(iout,88888)
      if(icrchk.eq.1) then
CC  setup gkin
       write(iout,11001)dcx1,dcyr1,dcy1,dcxr1,zero,zero,ddel
      iwn=0
      endif
      if(icrchk.eq.2) then
CC  setup ckin
       write(iout,11002)zero,dcxp,zero,dcyp,zero,zero,zero
      iwn=0
      endif
      if(mchflg.eq.1) then
CC   setup gkin
       dzr=datan2(dzs1,dzc1)
       write(iout,11001)-dx1,-dxp1,-dy1,-dyp1,-dz1,-dzr,-ddel
       iwn=0
      endif
      if(ierset.eq.1) then
       if(iwn.ge.3) then
        write(iout,88888)
        iwn=0
       endif
       do 3001 npp=1,mxerr
       npar=nerpar(npp,ide)-1
       if(npar.eq.-1)goto 3002
       ervl=erv(npp,ide)
       write(iout,11005)npar,ervl
 3001 continue
 3002 continue
      endif
      if(iwn.eq.5) then
       write(iout,20001)name(nel)
       iwn=0
                   else
       write(iout,20002)name(nel)
       iwn=iwn+1
      endif
      if(ierset.eq.1) write(iout,2003)
      if(mchflg.eq.1) then
cc  set up gkout
       dzr=datan2(dzs2,dzc2)
       write(iout,11003)-dx2,-dxp2,-dy2,-dyp2,-dz2,-dzr,ddel
       iwn=0
      endif
      if(icrchk.eq.2) then
cc  set up ckout
       write(iout,11004)zero,zero,zero,dcyp,zero,zero,zero
      iwn=0
      endif 
      if(icrchk.eq.1) then
cc  set up gkout
       write(iout,11003)dcx2,dcyr2,dcy2,dcxr2,zero,zero,-ddel
      iwn=0
      endif 
      GOTO 99888
C
C  TREATING quadsextS : CODE 4 ,ERRORS,MISALIGNEMENTS,PARTICLE CHECK
C       CORRECTOR ELEMENTS  AND SYNCHROTON RADIATION
C
 4000 MCHFLG=0
      ICRCHK=0
      ierset=0
      IF(ISYNFL.NE.0) CALL SYNPRE(IAD,NEL)
      IF(ICRFLG.EQ.1) CALL CORCHK(IE)
      IF(MISFLG.EQ.1) CALL MISCHK
      IF((MERFLG.EQ.1).OR.(ICRCHK.EQ.2)) CALL ESET(NEL,MATADR)
      if((icrchk.ne.0.or.mchflg.ne.0).and.iwn.gt.1)write(iout,88888)
      if(icrchk.eq.1) then
CC  setup gkin
       write(iout,11001)dcx1,dcyr1,dcy1,dcxr1,zero,zero,ddel
      iwn=0
      endif
      if(icrchk.eq.2) then
CC  setup ckin
       write(iout,11002)zero,dcxp,zero,dcyp,zero,zero,zero
      iwn=0
      endif
      if(mchflg.eq.1) then
CC   setup gkin
       dzr=datan2(dzs1,dzc1)
       write(iout,11001)-dx1,-dxp1,-dy1,-dyp1,-dz1,-dzr,-ddel
       iwn=0
      endif
      if(ierset.eq.1) then
       if(iwn.ge.3) then
        write(iout,88888)
        iwn=0
       endif
       do 4001 npp=1,mxerr
       npar=nerpar(npp,ide)-1
       if(npar.eq.-1)goto 4002
       ervl=erv(npp,ide)
       write(iout,11005)npar,ervl
 4001 continue
 4002 continue
      endif
      if(iwn.eq.5) then
       write(iout,20001)name(nel)
       iwn=0
                   else
       write(iout,20002)name(nel)
       iwn=iwn+1
      endif
      if(ierset.eq.1) write(iout,2003)
      if(mchflg.eq.1) then
cc  set up gkout
       dzr=datan2(dzs2,dzc2)
       write(iout,11003)-dx2,-dxp2,-dy2,-dyp2,-dz2,-dzr,ddel
       iwn=0
      endif
      if(icrchk.eq.2) then
cc  set up ckout
       write(iout,11004)zero,zero,zero,dcyp,zero,zero,zero
      iwn=0
      endif 
      if(icrchk.eq.1) then
cc  set up gkout
       write(iout,11003)dcx2,dcyr2,dcy2,dcxr2,zero,zero,-ddel
      iwn=0
      endif 
      GOTO 99888
C
C  TREAT MULTIPOLES : CODE 5 . MISALIGNMENTS AND ERRORS
C
 5000 continue
      MCHFLG=0
      ierset=0
      IF(MISFLG.EQ.1)CALL MISCHK
      IF(MERFLG.EQ.1)CALL ESET(NEL,MATADR)
      if((icrchk.ne.0.or.mchflg.ne.0).and.iwn.gt.1)write(iout,88888)
      if(mchflg.eq.1) then
CC   setup gkin
       dzr=datan2(dzs1,dzc1)
       write(iout,11001)-dx1,-dxp1,-dy1,-dyp1,-dz1,-dzr,-ddel
       iwn=0
      endif
      if(ierset.eq.1) then
       if(iwn.ge.3) then
        write(iout,88888)
        iwn=0
       endif
       do 5001 npp=1,mxerr
       npar=nerpar(npp,ide)-1
       if(npar.eq.-1)goto 5002
       ipar=npar/3
       ipar=ipar*3
       io=eldat(iad+ipar)-1
       write(iout,5003)io,erv(npp,ide)
 5003 format(' erv(',i2,'):=',e14.6,' ; ')
 5001 continue
 5002 continue
      endif
      if(iwn.eq.5) then
       write(iout,20001)name(nel)
       iwn=0
                   else
       write(iout,20002)name(nel)
       iwn=iwn+1
      endif
      if(ierset.eq.1)write(iout,5004)
 5004 format(' zeroerr ; ')
      if(mchflg.eq.1) then
cc  set up gkout
       dzr=datan2(dzs2,dzc2)
       write(iout,11003)-dx2,-dxp2,-dy2,-dyp2,-dz2,-dzr,ddel
       iwn=0
      endif
      GOTO 99888
C
C
C  TREAT KICKS : CODE 8 . NO MISALIGNMENT , ERRORS (FOR POSSIBLE ROLL
C  STUDY), CORRECTORS OPTION 3 ONLY.
C
 8000 continue
      ICRCHK=0
      ierset=0
      IF(ICRFLG.EQ.1) CALL CORCHK(IE)
      IF(MERFLG.EQ.1)CALL ESET(NEL,MATADR)
      if((icrchk.ne.0.or.mchflg.ne.0).and.iwn.ne.0)write(iout,88888)
      if(icrchk.eq.2) then
CC  setup ckin
       write(iout,11002)zero,dcxp,zero,dcyp,zero,zero,zero
      iwn=0
      endif
      if(iwn.eq.5) then
       write(iout,20001)name(nel)
       iwn=0
                   else
       write(iout,20002)name(nel)
       iwn=iwn+1
      endif
      GOTO 99888
C
C  TREATING
C   TWISS : CODE 9,GENERAL MATRIX : CODE 10, SOLQUA : CODE 15
C   quadac : code 19
C        ERRORS,MISALIGNEMENTS,PARTICLE CHECK
C       CORRECTOR ELEMENTS
C
 9000 MCHFLG=0
      ICRCHK=0
      ierset=0
      IF(ICRFLG.EQ.1) CALL CORCHK(IE)
      IF(MISFLG.EQ.1) CALL MISCHK
      IF((MERFLG.EQ.1).OR.(ICRCHK.EQ.2)) CALL ESET(NEL,MATADR)
      GOTO 10000
C-----------------------------------------------------------------------
C
C   TREAT LINAC CAVITY: CODE 17
C        ERRORS,MISALIGNEMENTS,PARTICLE CHECK
C       CORRECTOR ELEMENTS
C
 9500 MCHFLG=0
      ICRCHK=0
      IF(ICRFLG.EQ.1) CALL CORCHK(IE)
      IF(MISFLG.EQ.1) CALL MISCHK
      IF((MERFLG.EQ.1).OR.(ICRCHK.EQ.2)) CALL ESET(NEL,MATADR)
      GOTO 10000
C-----------------------------------------------------------------------
C TREAT ARBITRARY ELEMENT : CODE 12 MISALIGNEMENT ERRORS CORRECTORS
C
C                IF (ISYOPT.NE.0) IE IF SYMPLECTIC TRACING IS DONE
C                SEE COMMENTS IN SUBROUTINE TRAFCT HEADING
C                REGARDING CHOICE OF VARIABLES
C
12000 MCHFLG = 0
      ICRCHK = 0
      IERSET = 0
      al=aleng(nel)
      IF (ICRCHK.EQ.1) CALL CORCHK(IE)
      IF (MISFLG.EQ.1) CALL MISCHK
      IF ( (MERFLG.EQ.1).OR.(ICRCHK.EQ.2) ) CALL ESET(NEL,MATADR)
      GOTO 10000
C
C TREAT MONITORS : THEY CAN BE MISALIGNED BUT HAVE NO ERRORS
C
13000 MCHFLG=0
      IF(MISFLG.EQ.1)CALL MISCHK
      GOTO 10000
18000 continue
C
C     HVcollimator not implemented as such yet
C
      goto 99888
20000 CONTINUE
99888 continue
      if(iblchk.eq.2) then
C   set up block exit
       write(iout,11001)-dblx,-dblxp,-dbly,-dblyp,
     >     -dblz,-dblzr,-dbldel
      endif
110   continue
      write(iout,99998)
99998 format(' endprocedure ; ')
      IF(IERSET.EQ.1)CALL ERESET(NEL,MATADR)
      stop
C      RETURN
      END
C***********************************************************************
      SUBROUTINE DATIMH(KDATE,KTIME)
C***********************************************************************
C---- RETURN DATE AND TIME
C-----------------------------------------------------------------------
      CHARACTER*8       KDATE,KTIME
CCC---- RETURN DATE AND TIME
CCC---------------------------------------------------------------------
c       CHARACTER*8       DATE,TIME
      CHARACTER*9 VAXDATE
c      CALL DATE(VAXDATE)
      KDATE(1:2)=VAXDATE(1:2)
      KDATE(3:5)=VAXDATE(4:6)
      KDATE(6:7)=VAXDATE(8:9)
c      CALL TIME(KTIME)
c       DATE = '00/00/00'
c       TIME = '00:00:00'
C============================================================
      RETURN
C-----------------------------------------------------------------------
      END
      SUBROUTINE DECEXP(IPARM,ERROR)
C---- DECODE A PARAMETER EXPRESSION
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
      LOGICAL           ERROR
C-----------------------------------------------------------------------
C---- ELEMENT TABLE
      PARAMETER         (MAXELM = 5000)
      COMMON /ELMNAM/   KELEM(MAXELM),KETYP(MAXELM),KELABL(MAXELM)
      CHARACTER*8       KELEM,KELABL*14
      CHARACTER*4       KETYP
      COMMON /ELMDAT/   IELEM1,IELEM2,IETYP(MAXELM),IEDAT(MAXELM,3),
     +                  IELIN(MAXELM)
C---- MACHINE STRUCTURE FLAGS
      COMMON /FLAGS/    INVAL,NEWCON,NEWPAR,PERI,STABX,STABZ,SYMM
      LOGICAL           INVAL,NEWCON,NEWPAR,PERI,STABX,STABZ,SYMM
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- PARAMETER TABLE
      PARAMETER         (MAXPAR = 19000)
      COMMON /PARNAM/   KPARM(MAXPAR)
      CHARACTER*8       KPARM
      COMMON /PARDAT/   IPARM1,IPARM2,IPTYP(MAXPAR),IPDAT(MAXPAR,2),
     +                  IPLIN(MAXPAR)
      COMMON /PARVAL/   PDATA(MAXPAR)
C---- INPUT BUFFER
      COMMON /RDBUFF/   KLINE(81)
      CHARACTER*1       KLINE
      CHARACTER*80      KTEXT
      EQUIVALENCE       (KTEXT,KLINE(1))
C---- STACK FOR EXPRESSION ENCODING AND DECODING
      COMMON /STACK/    LEV,IOP(50),IVAL(50)
C-----------------------------------------------------------------------
      PARAMETER         (NFUN = 6)
C-----------------------------------------------------------------------
      LOGICAL           FLAG
      CHARACTER*8       KFUN(NFUN),KNAME,KPARA
C-----------------------------------------------------------------------
      DATA KFUN(1)      / 'NEG     ' /
      DATA KFUN(2)      / 'SQRT    ' /
      DATA KFUN(3)      / 'LOG     ' /
      DATA KFUN(4)      / 'EXP     ' /
      DATA KFUN(5)      / 'SIN     ' /
      DATA KFUN(6)      / 'COS     ' /
C-----------------------------------------------------------------------
      ERROR = .FALSE.
C---- CLEAR STACK
      LEV = 1
      IOP(1) = 0
C---- EXPRESSION -------------------------------------------------------
C---- LEFT PARENTHESIS?
      IF (KLINE(ICOL) .EQ. '(') THEN
        CALL RDNEXT
        LEV = LEV + 1
        IOP(LEV) = 10
      ENDIF
C---- UNARY "+" OR "-"?
  100 IF (KLINE(ICOL) .EQ. '+') THEN
        CALL RDNEXT
      ELSE IF (KLINE(ICOL) .EQ. '-') THEN
        CALL RDNEXT
        LEV = LEV + 1
        IOP(LEV) = 12
      ENDIF
C---- FACTOR OR TERM ---------------------------------------------------
C---- EXPRESSION IN BRACKETS?
  200 IF (KLINE(ICOL) .EQ. '(') THEN
        CALL RDNEXT
        LEV = LEV + 1
        IOP(LEV) = 10
        GO TO 100
C---- FUNCTION OR PARAMETER NAME?
      ELSE IF (INDEX('ABCDEFGHIJKLMNOPQRSTUVWXYZ',
     +               KLINE(ICOL)) .NE. 0) THEN
        CALL RDWORD(KNAME,LNAME)
C---- FUNCTION?
        IF (KLINE(ICOL) .EQ. '(') THEN
          CALL RDLOOK(KNAME,LNAME,KFUN,1,NFUN,IFUN)
          IF (IFUN .EQ. 0) THEN
            CALL RDFAIL
            WRITE (IECHO,910) KNAME(1:LNAME)
            GO TO 800
          ENDIF
          CALL RDNEXT
          LEV = LEV + 1
          IOP(LEV) = IFUN + 11
          LEV = LEV + 1
          IOP(LEV) = 10
          GO TO 100
C---- ELEMENT PARAMETER?
        ELSE IF (KLINE(ICOL) .EQ. '[') THEN
          CALL RDLOOK(KNAME,8,KELEM,1,IELEM1,IELEM)
          IF (IELEM .NE. 0) THEN
            IF (IETYP(IELEM) .LE. 0) IELEM = 0
          ENDIF
          IF (IELEM .EQ. 0) THEN
            CALL RDFAIL
            WRITE (IECHO,920) KNAME(1:LNAME)
            GO TO 800
          ENDIF
          CALL RDNEXT
          CALL RDWORD(KPARA,LPARA)
          IF (LPARA .EQ. 0) THEN
            CALL RDFAIL
            WRITE (IECHO,930)
            GO TO 800
          ENDIF
          CALL RDTEST(']',FLAG)
          IF (FLAG) GO TO 800
          IEP1 = IEDAT(IELEM,1)
          IEP2 = IEDAT(IELEM,2)
          CALL RDLOOK(KPARA,LPARA,KPARM,IEP1,IEP2,IEP)
          IF (IEP .EQ. 0) THEN
            CALL RDFAIL
            WRITE (IECHO,940) KNAME(1:LNAME),KPARA(1:LPARA)
            GO TO 800
          ENDIF
          IVAL(LEV) = IEP
          CALL RDNEXT
C---- GLOBAL PARAMETER
        ELSE
          CALL FNDPAR(ILCOM,KNAME,IVAL(LEV))
        ENDIF
C---- NUMERIC VALUE?
      ELSE IF (INDEX('0123456789.',KLINE(ICOL)) .NE. 0) THEN
        CALL RDNUMB(VALUE,FLAG)
        IF (FLAG) GO TO 800
        IF (IOP(LEV) .EQ. 12) THEN
          VALUE = -VALUE
          LEV = LEV - 1
        ENDIF
        CALL PARCON(ILCOM,IVAL(LEV),VALUE)
C---- ANYTHING ELSE
      ELSE
        CALL RDFAIL
        WRITE (IECHO,950)
        GO TO 800
      ENDIF
C---- UNSTACK UNARY OPERATORS
  300 IF (IOP(LEV) .GT. 10) CALL OPDEF(ILCOM)
C---- UNSTACK MULTIPLY OPERATORS
      IF (IOP(LEV) .EQ. 3 .OR. IOP(LEV) .EQ. 4) CALL OPDEF(ILCOM)
C---- TEST FOR MULTIPLY OPERATORS
      IF (KLINE(ICOL) .EQ. '*') THEN
        CALL RDNEXT
        LEV = LEV + 1
        IOP(LEV) = 3
        GO TO 200
      ELSE IF (KLINE(ICOL) .EQ. '/') THEN
        CALL RDNEXT
        LEV = LEV + 1
        IOP(LEV) = 4
        GO TO 200
      ENDIF
C---- UNSTACK ADDING OPERATORS
      IF (IOP(LEV) .EQ. 1 .OR. IOP(LEV) .EQ. 2) CALL OPDEF(ILCOM)
C---- TEST FOR ADDING OPERATORS
      IF (KLINE(ICOL) .EQ. '+') THEN
        CALL RDNEXT
        LEV = LEV + 1
        IOP(LEV) = 1
        GO TO 200
      ELSE IF (KLINE(ICOL) .EQ. '-') THEN
        CALL RDNEXT
        LEV = LEV + 1
        IOP(LEV) = 2
        GO TO 200
      ENDIF
C---- UNSTACK PARENTHESES
      IF (LEV .NE. 1) THEN
        IF (KLINE(ICOL) .EQ. ')') THEN
          CALL RDNEXT
          LEV = LEV - 1
          IVAL(LEV) = IVAL(LEV+1)
          GO TO 300
        ELSE
          CALL RDFAIL
          WRITE (IECHO,960)
          GO TO 800
        ENDIF
      ELSE IF (KLINE(ICOL) .EQ. ')') THEN
        CALL RDFAIL
        WRITE (IECHO,970)
        GO TO 800
      ENDIF
C---- DISCARD UNNEEDED TEMPORARY
      IF (IVAL(1) .EQ. IPARM2 .AND. KPARM(IPARM2)(1:1) .EQ. '*') THEN
        IPTYP(IPARM) = IPTYP(IPARM2)
        IPDAT(IPARM,1) = IPDAT(IPARM2,1)
        IPDAT(IPARM,2) = IPDAT(IPARM2,2)
        PDATA(IPARM) = PDATA(IPARM2)
        IPARM2 = IPARM2 + 1
      ELSE
        IPTYP(IPARM) = 11
        IPDAT(IPARM,1) = 0
        IPDAT(IPARM,2) = IVAL(1)
        PDATA(IPARM) = 0.0
      ENDIF
      IF (IPTYP(IPARM) .GT. 0) NEWPAR = .TRUE.
      IPLIN(IPARM) = ILCOM
      RETURN
C---- ERROR EXIT --- LEAVE PARAMETER UNDEFINED
  800 IPTYP(IPARM) = -1
      IPDAT(IPARM,1) = 0
      IPDAT(IPARM,2) = 0
      PDATA(IPARM) = 0.0
      IPLIN(IPARM) = ILCOM
      ERROR = .TRUE.
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT(' *** ERROR *** UNKNOWN FUNCTION "',A,'"'/' ')
  920 FORMAT(' *** ERROR *** UNKNOWN BEAM ELEMENT "',A,'"'/' ')
  930 FORMAT(' *** ERROR *** PARAMETER KEYWORD EXPECTED'/' ')
  940 FORMAT(' *** ERROR *** UNKNOWN ELEMENT PARAMETER "',A,'[',A,']"'/
     +       ' ')
  950 FORMAT(' *** ERROR *** OPERAND MUST BE NUMBER, PARAMETER NAME,',
     +       ' FUNCTION CALL, OR EXPRESSION IN "()"'/' ')
  960 FORMAT(' *** ERROR *** RIGHT PARENTHESIS MISSING'/' ')
  970 FORMAT(' *** ERROR *** UNBALANCED RIGHT PARENTHESIS'/' ')
C-----------------------------------------------------------------------
      END
      SUBROUTINE DECFRM(IFORM1,IFORM2,ERROR)
C---- DECODE FORMAL ARGUMENT LIST
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
      LOGICAL           ERROR
C-----------------------------------------------------------------------
C---- ELEMENT TABLE
      PARAMETER         (MAXELM = 5000)
      COMMON /ELMNAM/   KELEM(MAXELM),KETYP(MAXELM),KELABL(MAXELM)
      CHARACTER*8       KELEM,KELABL*14
      CHARACTER*4       KETYP
      COMMON /ELMDAT/   IELEM1,IELEM2,IETYP(MAXELM),IEDAT(MAXELM,3),
     +                  IELIN(MAXELM)
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- INPUT BUFFER
      COMMON /RDBUFF/   KLINE(81)
      CHARACTER*1       KLINE
      CHARACTER*80      KTEXT
      EQUIVALENCE       (KTEXT,KLINE(1))
C-----------------------------------------------------------------------
      CHARACTER*8       KNAME
      LOGICAL           FLAG
C-----------------------------------------------------------------------
      ERROR = .FALSE.
C---- ANY ARGUMENT LIST?
      IF (KLINE(ICOL) .EQ. '(') THEN
        IFORM1 = IELEM2
        IFORM2 = IELEM2 - 1
C---- ARGUMENT NAME
  100   CONTINUE
          CALL RDNEXT
          CALL RDWORD(KNAME,LNAME)
          IF (LNAME .EQ. 0) THEN
            CALL RDFAIL
            WRITE (IECHO,910)
            GO TO 200
          ENDIF
          CALL RDLOOK(KNAME,8,KELEM,IFORM1,IFORM2,IFORM)
          IF (IFORM .NE. 0) THEN
            CALL RDFAIL
            WRITE (IECHO,920) KNAME(1:LNAME)
            GO TO 200
          ENDIF
C---- SEPARATOR?
          CALL RDTEST(',)',FLAG)
          IF (FLAG) GO TO 200
C---- ALLOCATE CELL TO ARGUMENT
          IFORM1 = IELEM2 - 1
          IF (IELEM1 .GE. IFORM1) CALL OVFLOW(1,MAXELM)
          IELEM2 = IFORM1
C---- SET UP FORMAL BEAM LINE
          CALL NEWLST(IHEAD)
          CALL NEWRGT(IHEAD,ICELL)
          KELEM(IFORM1) = KNAME
          KETYP(IFORM1) = '    '
          IETYP(IFORM1) = 0
          IEDAT(IFORM1,1) = 0
          IEDAT(IFORM1,2) = 0
          IEDAT(IFORM1,3) = IHEAD
          IELIN(IFORM1) = ILCOM
          GO TO 300
C---- ERROR RECOVERY
  200     CALL RDFIND(',);')
          ERROR = .TRUE.
  300   IF (KLINE(ICOL) .EQ. ',') GO TO 100
        IF (KLINE(ICOL) .EQ. ')') CALL RDNEXT
C---- NO ARGUMENT LIST
      ELSE
        IFORM1 = 0
        IFORM2 = 0
      ENDIF
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT(' *** ERROR *** FORMAL ARGUMENT NAME EXPECTED'/' ')
  920 FORMAT(' *** ERROR *** DUPLICATE FORMAL ARGUMENT "',A,'"'/' ')
C-----------------------------------------------------------------------
      END
      SUBROUTINE DECLST(IBEAM,IFORM1,IFORM2,ERROR)
C---- DECODE A BEAM LIST
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
      LOGICAL           ERROR
C-----------------------------------------------------------------------
C---- ELEMENT TABLE
      PARAMETER         (MAXELM = 5000)
      COMMON /ELMNAM/   KELEM(MAXELM),KETYP(MAXELM),KELABL(MAXELM)
      CHARACTER*8       KELEM,KELABL*14
      CHARACTER*4       KETYP
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- LINK TABLE
      PARAMETER         (MAXLST = 14000)
      COMMON /LPDATA/   IUSED,ILDAT(MAXLST,6)
C---- INPUT BUFFER
      COMMON /RDBUFF/   KLINE(81)
      CHARACTER*1       KLINE
      CHARACTER*80      KTEXT
      EQUIVALENCE       (KTEXT,KLINE(1))
C-----------------------------------------------------------------------
      LOGICAL           FLAG
      CHARACTER*8       KNAME
C-----------------------------------------------------------------------
      ERROR = .FALSE.
C---- INITIALIZE
      ICELL = 0
      ICALL = 1
C---- OPENING PARENTHESIS
      CALL RDTEST('(',ERROR)
      IF (ERROR) GO TO 800
      CALL RDNEXT
C---- PROCEDURE "DECODE LIST" ------------------------------------------
  100 CALL NEWLST(IHEAD)
      ILDAT(IHEAD,4) = ICELL
      ILDAT(IHEAD,5) = ICALL
      ICELL = IHEAD
C---- APPEND A NEW CALL CELL
  200 CALL NEWRGT(ICELL,ICELL)
C---- REFLEXION?
      IF (KLINE(ICOL) .EQ. '-') THEN
        CALL RDNEXT
        IDIREP = -1
      ELSE
        IDIREP = 1
      ENDIF
C---- REPETITION?
      IF (INDEX('0123456789',KLINE(ICOL)) .NE. 0) THEN
        CALL RDINT(IREP,FLAG)
        IF (FLAG) GO TO 600
        CALL RDTEST('*',FLAG)
        IF (FLAG) GO TO 600
        CALL RDNEXT
        IDIREP = IDIREP * IREP
      ENDIF
      ILDAT(ICELL,4) = IDIREP
C---- SUBLIST?
      IF (KLINE(ICOL) .NE. '(') GO TO 300
        CALL RDNEXT
        ICALL = 2
        GO TO 100
  250   ILDAT(ICELL,1) = 2
        ILDAT(ICELL,5) = IHEAD
      GO TO 500
C---- DECODE IDENTIFIER
  300   CALL RDWORD(KNAME,LNAME)
        IF (LNAME .EQ. 0) THEN
          CALL RDFAIL
          WRITE (IECHO,910)
          GO TO 600
        ELSE
          CALL RDLOOK(KNAME,8,KELEM,IFORM1,IFORM2,INAME)
          IF (INAME .EQ. 0) CALL FNDELM(ILCOM,KNAME,INAME)
        ENDIF
        ILDAT(ICELL,1) = 3
        ILDAT(ICELL,5) = INAME
C---- ACTUAL ARGUMENT LIST?
        IF (KLINE(ICOL) .NE. '(') GO TO 400
          CALL RDNEXT
          ICALL = 3
          GO TO 100
  350     ILDAT(ICELL,6) = IHEAD
  400   CONTINUE
C---- COMMA OR RIGHT PARENTHESIS?
  500 CALL RDTEST(',)',FLAG)
      IF (.NOT. FLAG) GO TO 700
C---- ERROR RECOVERY
  600 CALL RDFIND('(),;')
      ERROR = .TRUE.
C---- ANOTHER MEMBER?
  700 IF (KLINE(ICOL) .EQ. ',') THEN
        CALL RDNEXT
        GO TO 200
      ENDIF
C---- END OF LIST?
      IF (KLINE(ICOL) .EQ. ')') THEN
        CALL RDNEXT
        IHEAD = ILDAT(ICELL,3)
        ICELL = ILDAT(IHEAD,4)
        ICALL = ILDAT(IHEAD,5)
        ILDAT(IHEAD,4) = 0
        ILDAT(IHEAD,5) = 0
        ILDAT(IHEAD,6) = 0
        GO TO (800,250,350,500), ICALL
      ENDIF
C---- ANOTHER LIST WITHOUT A COMMA?
      IF (KLINE(ICOL) .EQ. '(') THEN
        CALL RDNEXT
        ICALL = 4
        GO TO 100
      ENDIF
C---- END OF BEAM LINE LIST
  800 IF (ERROR) THEN
        IBEAM = 0
      ELSE
        IBEAM = IHEAD
      ENDIF
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT(' *** ERROR *** BEAM LINE MEMBER MUST BE BEAM ELEMENT',
     +       ' NAME, BEAM LINE NAME, OR LIST IN "()"'/' ')
C-----------------------------------------------------------------------
      END

      SUBROUTINE DECOBS(IELEM,IR1,IR2,ERROR)
C---- DECODE OBSERVATION POINT(S) OR RANGE
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
      LOGICAL           ERROR
C-----------------------------------------------------------------------
C---- ELEMENT TABLE
      PARAMETER         (MAXELM = 5000)
      COMMON /ELMNAM/   KELEM(MAXELM),KETYP(MAXELM),KELABL(MAXELM)
      CHARACTER*8       KELEM,KELABL*14
      CHARACTER*4       KETYP
      COMMON /ELMDAT/   IELEM1,IELEM2,IETYP(MAXELM),IEDAT(MAXELM,3),
     +                  IELIN(MAXELM)
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- MACHINE PERIOD DEFINITION
      COMMON /PERIOD/   IPERI,IACT,NSUP,NELM,NFREE,NPOS1,NPOS2
C---- INPUT BUFFER
      COMMON /RDBUFF/   KLINE(81)
      CHARACTER*1       KLINE
      CHARACTER*80      KTEXT
      EQUIVALENCE       (KTEXT,KLINE(1))
C-----------------------------------------------------------------------
      CHARACTER*8       KNAME
      LOGICAL           FLAG
C-----------------------------------------------------------------------
      ERROR = .FALSE.
C---- NUMBERED POINT(S)
      IF (KLINE(ICOL) .EQ. '#') THEN
        CALL RDNEXT
        IELEM = 0
        IF (KLINE(ICOL) .EQ. 'S') THEN
          CALL RDNEXT
          IR1 = 0
        ELSE IF (KLINE(ICOL) .EQ. 'E') THEN
          CALL RDNEXT
          IR1 = NELM
        ELSE
          CALL RDINT(IR1,FLAG)
          IF (FLAG) GO TO 800
        ENDIF
        IR2 = IR1
        IF (KLINE(ICOL) .EQ. '/') THEN
          CALL RDNEXT
          IF (KLINE(ICOL) .EQ. 'S') THEN
            CALL RDNEXT
            IR2 = 0
          ELSE IF (KLINE(ICOL) .EQ. 'E') THEN
            CALL RDNEXT
            IR2 = NELM
          ELSE
            CALL RDINT(IR2,FLAG)
            IF (FLAG) GO TO 800
          ENDIF
        ENDIF
C---- NAMED POINT(S) OR RANGE
      ELSE
        CALL RDWORD(KNAME,LNAME)
        IF (LNAME .EQ. 0) THEN
          CALL RDFAIL
          WRITE (IECHO,910)
          GO TO 800
        ENDIF
        CALL RDLOOK(KNAME,8,KELEM,1,IELEM1,IELEM)
        IF (IELEM .EQ. 0) THEN
          CALL RDFAIL
          WRITE (IECHO,920) KNAME(1:LNAME)
          GO TO 800
        ENDIF
        IR1 = 1
        IR2 = NELM
        IF (KLINE(ICOL) .EQ. '[') THEN
          CALL RDNEXT
          CALL RDINT(IR1,FLAG)
          IF (FLAG) GO TO 800
          IR2 = IR1
          IF (KLINE(ICOL) .EQ. '/') THEN
            CALL RDNEXT
            CALL RDINT(IR2,FLAG)
            IF (FLAG) GO TO 800
          ENDIF
          CALL RDTEST(']',FLAG)
          IF (FLAG) GO TO 800
          CALL RDNEXT
        ENDIF
      ENDIF
C---- CHECK ORDER OF INDICES
      IF (IR1 .GT. IR2) THEN
        CALL RDFAIL
        WRITE (IECHO,930)
        GO TO 800
      ENDIF
      RETURN
C---- ERROR EXIT --- RANGE UNDEFINED
  800 ERROR = .TRUE.
      IELEM = 0
      IR1 = 0
      IR2 = 0
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT(' *** ERROR *** "#" OR NAME EXPECTED'/' ')
  920 FORMAT(' *** ERROR *** UNKNOWN BEAM LINE OR ELEMENT "',A,'"'/' ')
  930 FORMAT(' *** ERROR *** BAD INDEX ORDER'/' ')
C-----------------------------------------------------------------------
      END
      SUBROUTINE DECPAR(IEP1,IEP2,KTYPE,KLABL,ERROR)
C---- DECODE PARAMETER LIST
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
      CHARACTER*8       KTYPE
      CHARACTER*14      KLABL
      LOGICAL           ERROR
C-----------------------------------------------------------------------
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- PARAMETER TABLE
      PARAMETER         (MAXPAR = 19000)
      COMMON /PARNAM/   KPARM(MAXPAR)
      CHARACTER*8       KPARM
      COMMON /PARDAT/   IPARM1,IPARM2,IPTYP(MAXPAR),IPDAT(MAXPAR,2),
     +                  IPLIN(MAXPAR)
      COMMON /PARVAL/   PDATA(MAXPAR)
C---- INPUT BUFFER
      COMMON /RDBUFF/   KLINE(81)
      CHARACTER*1       KLINE
      CHARACTER*80      KTEXT
      EQUIVALENCE       (KTEXT,KLINE(1))
C-----------------------------------------------------------------------
      CHARACTER*8       KNAME
      LOGICAL           FLAG
C-----------------------------------------------------------------------
      ERROR = .FALSE.
      KTYPE = '        '
      KLABL = '              '
C---- ANOTHER PARAMETER?
  100 IF (KLINE(ICOL) .EQ. ',') THEN
        CALL RDNEXT
C---- PARAMETER KEYWORD
        CALL RDWORD(KNAME,LNAME)
        IF (LNAME .EQ. 0) THEN
          CALL RDFAIL
          WRITE (IECHO,910)
          GO TO 200
        ENDIF
C---- TEST FOR "TYPE" KEYWORD
        IF (KNAME .EQ. 'TYPE') THEN
          CALL RDTEST('=',FLAG)
          IF (FLAG) GO TO 200
          CALL RDNEXT
          CALL RDWORD(KTYPE,LTYPE)
          IF (LTYPE .EQ. 0) THEN
            CALL RDFAIL
            WRITE (IECHO,920)
            GOTO 200
          ENDIF
C---- TEST FOR "LABEL" KEYWORD
        ELSE IF(KNAME .EQ. 'LABEL') THEN
          CALL RDTEST('=',FLAG)
          IF (FLAG) GO TO 200
          CALL RDNEXT
          CALL RDLABL(KLABL,LABEL)
          IF (LABEL .EQ. 0) THEN
            CALL RDFAIL
            WRITE (IECHO,925)
            GOTO 200
          ENDIF
C---- KEYWORD MUST DESIGNATE NUMERIC PARAMETER
        ELSE
          CALL RDLOOK(KNAME,LNAME,KPARM,IEP1,IEP2,IEP)
          IF (IEP .EQ. 0) THEN
            CALL RDWARN
            WRITE (Iprnt,930) KNAME(1:LNAME)
            CALL RDFIND(',;')
          ELSE IF (IPTYP(IEP) .GE. 0) THEN
            CALL RDWARN
            WRITE (Iprnt,940) KNAME(1:LNAME)
            CALL RDFIND(',;')
          ELSE
C---- EQUALS SIGN?
            CALL RDTEST('=,;',FLAG)
            IF (FLAG) GO TO 200
            IF (KLINE(ICOL) .EQ. '=') THEN
              CALL RDNEXT
              CALL DECEXP(IEP,FLAG)
              IF (FLAG) GO TO 200
            ELSE IF (IPTYP(IEP) .EQ. -2) THEN
              IPTYP(IEP) = 0
            ELSE
              CALL RDWARN
              WRITE (Iprnt,950)
            ENDIF
          ENDIF
        ENDIF
        GO TO 100
C---- ERROR RECOVERY
  200   CALL RDFIND(',;')
        ERROR = .TRUE.
        GO TO 100
      ENDIF
C---- FINAL CHECK
      CALL RDTEST(',;',FLAG)
      IF (FLAG .OR. ERROR) THEN
        ERROR = .TRUE.
        IEP1 = 0
        IEP2 = 0
      ELSE IF (IEP1 .NE. 0) THEN
        DO 290 IEP = IEP1, IEP2
          IF (IPTYP(IEP) .LT. -1) THEN
            IPTYP(IEP) = -1
            PDATA(IEP) = 0.0
          ENDIF
  290   CONTINUE
      ENDIF
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT(' *** ERROR *** PARAMETER KEYWORD EXPECTED'/' ')
  920 FORMAT(' *** ERROR *** TYPE IDENTIFIER EXPECTED'/' ')
  925 FORMAT(' *** ERROR *** LABEL IDENTIFIER EXPECTED'/' ')
  930 FORMAT(' ** WARNING ** UNKNOWN PARAMETER KEYWORD "',A,
     +       '" --- PARAMETER IGNORED'/' ')
  940 FORMAT(' ** WARNING ** MULTIPLE DEFINITION OF PARAMETER "',A,
     +       '" --- PREVIOUS VALUE USED'/' ')
  950 FORMAT(' ** WARNING ** "=" EXPECTED --- DEFAULT VALUE USED'/' ')
C-----------------------------------------------------------------------
      END
      SUBROUTINE DECPNT(IELEM,IR,IPOS,SCAN,ERROR)
C---- DECODE SINGLE OBSERVATION POINT
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
      LOGICAL           SCAN,ERROR
C-----------------------------------------------------------------------
C---- ELEMENT TABLE
      PARAMETER         (MAXELM = 5000)
      COMMON /ELMNAM/   KELEM(MAXELM),KETYP(MAXELM),KELABL(MAXELM)
      CHARACTER*8       KELEM,KELABL*14
      CHARACTER*4       KETYP
      COMMON /ELMDAT/   IELEM1,IELEM2,IETYP(MAXELM),IEDAT(MAXELM,3),
     +                  IELIN(MAXELM)
C---- MACHINE STRUCTURE FLAGS
      COMMON /FLAGS/    INVAL,NEWCON,NEWPAR,PERI,STABX,STABZ,SYMM
      LOGICAL           INVAL,NEWCON,NEWPAR,PERI,STABX,STABZ,SYMM
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- MACHINE PERIOD DEFINITION
      COMMON /PERIOD/   IPERI,IACT,NSUP,NELM,NFREE,NPOS1,NPOS2
C---- INPUT BUFFER
      COMMON /RDBUFF/   KLINE(81)
      CHARACTER*1       KLINE
      CHARACTER*80      KTEXT
      EQUIVALENCE       (KTEXT,KLINE(1))
C---- SEQUENCE TABLE
      PARAMETER         (MAXPOS = 10000)
      COMMON /SEQNUM/   ITEM(MAXPOS)
C-----------------------------------------------------------------------
      CHARACTER*8       KNAME
      LOGICAL           FLAG
C-----------------------------------------------------------------------
      ERROR = .FALSE.
C---- NUMBERED POINT
      IF (KLINE(ICOL) .EQ. '#') THEN
        CALL RDNEXT
        IELEM = 0
        IF (KLINE(ICOL) .EQ. 'S') THEN
          CALL RDNEXT
          IR = 0
        ELSE IF (KLINE(ICOL) .EQ. 'E') THEN
          CALL RDNEXT
          IR = NELM
        ELSE
          CALL RDINT(IR,FLAG)
          IF (FLAG) GO TO 800
        ENDIF
C---- NAMED POINT
      ELSE
        CALL RDWORD(KNAME,LNAME)
        IF (LNAME .EQ. 0) THEN
          CALL RDFAIL
          WRITE (IECHO,910)
          GO TO 800
        ENDIF
        CALL RDLOOK(KNAME,8,KELEM,1,IELEM1,IELEM)
        IF (IELEM .EQ. 0) THEN
          CALL RDFAIL
          WRITE (IECHO,920) KNAME(1:LNAME)
          GO TO 800
        ENDIF
        IF (IETYP(IELEM) .LE. 0) THEN
          CALL RDFAIL
          WRITE (IECHO,930) KNAME(1:LNAME)
          GO TO 800
        ENDIF
        IR = 1
        IF (KLINE(ICOL) .EQ. '[') THEN
          CALL RDNEXT
          CALL RDINT(IR,FLAG)
          IF (FLAG) GO TO 800
          CALL RDTEST(']',FLAG)
          IF (FLAG) GO TO 800
          CALL RDNEXT
        ENDIF
      ENDIF
C---- FIND ACTUAL POSITION
      IF (SCAN .OR. ERROR .OR. (.NOT. PERI)) RETURN
      IF (IELEM .NE. 0) THEN
        IEPOS = 0
        DO 10 JPOS = NPOS1, NPOS2
          IF (ITEM(JPOS) .EQ. IELEM) THEN
            IEPOS = IEPOS + 1
            IF (IEPOS .EQ. IR) THEN
              IPOS = JPOS
              RETURN
            ENDIF
          ENDIF
   10   CONTINUE
      ELSE IF (IR .EQ. 0) THEN
        DO 20 JPOS = NPOS1, NPOS2
          IF (ITEM(JPOS) .LE. MAXELM) THEN
            IPOS = JPOS - 1
            RETURN
          ENDIF
   20   CONTINUE
      ELSE
        IEPOS = 0
        DO 30 JPOS = NPOS1, NPOS2
          IF (ITEM(JPOS) .LE. MAXELM) THEN
            IEPOS = IEPOS + 1
            IF (IEPOS .EQ. IR) THEN
              IPOS = JPOS
              RETURN
            ENDIF
          ENDIF
   30   CONTINUE
      ENDIF
      CALL RDFAIL
      WRITE (IECHO,940)
C---- ERROR EXIT --- POSITION UNDEFINED
  800 ERROR = .TRUE.
      IPOS = 0
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT(' *** ERROR *** "#" OR BEAM ELEMENT NAME EXPECTED'/' ')
  920 FORMAT(' *** ERROR *** UNKNOWN BEAM ELEMENT "',A,'"'/' ')
  930 FORMAT(' *** ERROR *** "',A,'" IS NOT A BEAM ELEMENT'/' ')
  940 FORMAT(' *** ERROR *** POSITION NOT FOUND'/' ')
C-----------------------------------------------------------------------
      END
      SUBROUTINE DECUSE(INAME,IACT,ERROR)
C---- DECODE REFERENCE TO BEAM LINE
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
      LOGICAL           ERROR
C-----------------------------------------------------------------------
C---- ELEMENT TABLE
      PARAMETER         (MAXELM = 5000)
      COMMON /ELMNAM/   KELEM(MAXELM),KETYP(MAXELM),KELABL(MAXELM)
      CHARACTER*8       KELEM,KELABL*14
      CHARACTER*4       KETYP
      COMMON /ELMDAT/   IELEM1,IELEM2,IETYP(MAXELM),IEDAT(MAXELM,3),
     +                  IELIN(MAXELM)
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- INPUT BUFFER
      COMMON /RDBUFF/   KLINE(81)
      CHARACTER*1       KLINE
      CHARACTER*80      KTEXT
      EQUIVALENCE       (KTEXT,KLINE(1))
C-----------------------------------------------------------------------
      CHARACTER*8       KNAME
C-----------------------------------------------------------------------
      ERROR = .FALSE.
C---- BEAM LINE NAME
      CALL RDWORD(KNAME,LNAME)
      IF (LNAME .EQ. 0) THEN
        CALL RDFAIL
        WRITE (IECHO,910)
        ERROR = .TRUE.
        RETURN
      ENDIF
      CALL RDLOOK(KNAME,8,KELEM,1,IELEM1,INAME)
      IF (INAME .EQ. 0) THEN
        CALL RDFAIL
        WRITE (IECHO,920) KNAME(1:LNAME)
        ERROR = .TRUE.
        RETURN
      ENDIF
      IF (IETYP(INAME) .NE. 0) THEN
        CALL RDFAIL
        WRITE (IECHO,930) KNAME(1:LNAME)
        ERROR = .TRUE.
        RETURN
      ENDIF
C---- ACTUAL PARAMETER LIST
      IF (KLINE(ICOL) .EQ. '(') THEN
        CALL DECLST(IACT,0,0,ERROR)
        IF (ERROR) RETURN
      ELSE
        IACT = 0
      ENDIF
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT(' *** ERROR *** BEAM LINE NAME EXPECTED'/' ')
  920 FORMAT(' *** ERROR *** UNKNOWN BEAM LINE NAME "',A,'"'/' ')
  930 FORMAT(' *** ERROR *** "',A,'" IS NOT A BEAM LINE'/' ')
C-----------------------------------------------------------------------
      END
      SUBROUTINE DEFPAR(NDICT,DICT,IEP1,IEP2,ILCOM)
C---- ALLOCATE PARAMETER SPACE
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
      CHARACTER*8       DICT(NDICT)
C-----------------------------------------------------------------------
C---- PARAMETER TABLE
      PARAMETER         (MAXPAR = 19000)
      COMMON /PARNAM/   KPARM(MAXPAR)
      CHARACTER*8       KPARM
      COMMON /PARDAT/   IPARM1,IPARM2,IPTYP(MAXPAR),IPDAT(MAXPAR,2),
     +                  IPLIN(MAXPAR)
      COMMON /PARVAL/   PDATA(MAXPAR)
C-----------------------------------------------------------------------
      IEP1 = IPARM2 - NDICT
      IEP2 = IPARM2 - 1
      IF (IPARM1 .GE. IEP1) CALL OVFLOW(2,MAXPAR)
      IPARM2 = IEP1
      IDICT = 0
      DO 10 IEP = IEP1, IEP2
        IDICT = IDICT + 1
        KPARM(IEP) = DICT(IDICT)
        IPTYP(IEP) = -1
        IPDAT(IEP,1) = 0
        IPDAT(IEP,2) = 0
        PDATA(IEP) = 0.0
        IPLIN(IEP) = ILCOM
   10 CONTINUE
      RETURN
C-----------------------------------------------------------------------
      END
      SUBROUTINE DETAIL(IEND)
C     ***********************
      IMPLICIT REAL*8 (A-H,O-Z)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/PLT/
     1XMIN,XMAX,YMIN,YMAX,XPMIN,XPMAX,YPMIN,YPMAX,ALMIN,ALMAX,
     >DELMIN,DELMAX,DNUMIN,DNUMAX,DBMIN,DBMAX,
     2MALL,NPLOT,NCCUM,NGRAPH,NCOL,NLINE
      COMMON/CHPLT/MXXPR,MYYPR,MXY,MALE
      PARAMETER  (MAXDAT=16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      CHARACTER*1 MALE(101,51),MXXPR(101,51),MYYPR(101,51),MXY(101,51)
      COMMON/DETL/DENER(15),NH,NV,NVH,NHVP(105),MDPRT,NDENER,
     >NUXS(45),NUX(45),NUYS(45),NUY(45),NCO,NHNVHV,MULPRT,NSIG
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      COMMON/BETAL/BETA0X,ALPH0X,ETA0X,ETAP0X,
     >BETA0Y,ALPH0Y,ETA0Y,ETAP0Y,X0,XP0,Y0,YP0,DLEN0
     >,DX0,DXP0,DY0,DYP0,DEL0,XS(15),XPS(15),YS(15),YPS(15),DLENS(15)
      COMMON/CBEAM/BSIG(6,6),BSIGF(6,6),MBPRT,IBMFLG,MENV
      PARAMETER  (mxlcnd = 200)
      PARAMETER  (mxlvar = 100)
      COMMON/FITL/COEF(MXLVAR,6),VALF(MXLCND),
     >  WGHT(MXLCND),RVAL(MXLCND),XM(MXLVAR)
     >  ,EM(MXLVAR),WV,NELF(MXLVAR,6),NPAR(MXLVAR,6),
     >  IND(MXLVAR,6),NPVAR(MXLVAR),NVAL(MXLCND)
     >  ,NSTEP,NVAR,NCOND,ISTART,NDIV,IFITM,IFITD,IFITBM
      COMMON/MONFIT/VALFA(MXLCND),WGHTA(MXLCND),ERRA(MXLCND),
     >AMULTA(MXLVAR,6),ADDA(MXLVAR,6),DELA(MXLVAR)
     >,NPARA(MXLVAR,6),NELFA(MXLVAR,6),
     >NPVARA(MXLVAR),INDA(MXLVAR,6),VALR(MXLCND),RMOSIG,
     >NMONA(MXLCND),NVALA(MXLCND),NVARA,NCONDA
     >,IALFLG,MONFLG,MONLST,NOPTER,
     >IAFRST,IMOOPT,IMSBEG,NALPRT
      COMMON/CSEEDS/ISEED,IXG,IXS,IXMSTP,IMSD,IMOSTP,ISYNSD,ISYSTP,
     >ISDBEG,IBGSTP,IXES,IXESTP,IESBEG,IESTBG,isdcol
      common/cprt/prnam(8,10),kodprt(2),
     >   iprtfl,intfl,itypfl,namfl,inam,itkod
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
      character*1 prnam
      DO 11 IL=1,MXPART
   11 LOGPAR(IL)=.TRUE.
      DO  10 IN=1,45
      NUXS(IN)=0
      NUX(IN)=0
      NUYS(IN)=0
   10 NUY(IN)=0
      IF(IFITD.EQ.1)GOTO 3
      IF(IALFLG.NE.0)GOTO3
      NOP = -1
      NCHAR=0
      INPRT=1
      NDIM=mxinp
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NOP,INPRT)
      NH = data(1)
      NV = data(2)
      NVH = data(3)
      X0 = data(4)
      XP0 = data(5)
      Y0 = data(6)
      YP0 = data(7)
      DX0 = data(8)
      DXP0 = data(9)
      DY0 = data(10)
      DYP0 = data(11)
      BETA0X = data(12)
      ALPH0X = data(13)
      ETA0X  = data(14)
      ETAP0X = data(15)
      BETA0Y = data(16)
      ALPH0Y = data(17)
      ETA0Y  = data(18)
      ETAP0Y = data(19)
      NDENER = data(20)
      NCO=data(21)
      IF(NCO.GT.6)NCO=6
      IF(NCO.GT.NDENER)NCO=NDENER
      DEL0=0.0D0
      DO 1 INE = 1, NDENER
      DENER(INE) = data(INE + 21)
      XS(INE)=0.0D0+ETA0X*DENER(INE)
      XPS(INE)=0.0D0+ETAP0X*DENER(INE)
      YS(INE)=0.0D0+ETA0Y*DENER(INE)
      YPS(INE)=0.0D0+ETAP0Y*DENER(INE)
      DLENS(INE)=0.0D0
    1 CONTINUE
      MDPRT = data(NDENER + 22)
      if(iprtfl.eq.1) goto 3
      IF(MDPRT .LE. 0) GO TO 3
      MLOCAT = MDPRT
                 IF(MLOCAT.GT.MXLIST) THEN
                       WRITE(IOUT,30301)MLOCAT
30301 FORMAT(' **** TOO MANY INTERVALS ',I4,/,
     >'  CHANGE MXLIST PARAMETERS TO ',
     >' TWICE THE INTERVAL NUMBER NEEDED .')
                       CALL HALT(2)
                 ENDIF
      DO 2 IMD = 1, MDPRT
      INDD = 2*IMD-1
      INDOP = INDD + NDENER + 22
      NLIST(INDD) = data(INDOP)
    2 NLIST(INDD+1) = data(INDOP + 1)
    3 NPLOT = -1
      NPRINT = -2
      NTURN = 1
      NCTURN=0
      MULPRT=5
      NHNVHV=0
      IF((NH.EQ.0).AND.(NV.EQ.0).AND.(NVH.EQ.0))NHNVHV=1
      IF(NHNVHV.EQ.1)MULPRT=1
      NPART = NDENER*MULPRT
      NCPART=NPART
      DO 4 IEN = 1,NDENER
      INDP=(IEN-1)*MULPRT+1
      PART(INDP,1)=X0+XS(IEN)
      PART(INDP,2)=XP0+XPS(IEN)
      PART(INDP,3)=Y0+YS(IEN)
      PART(INDP,4)=YP0+YPS(IEN)
      PART(INDP,5)=DLENS(IEN)
      PART(INDP,6)=DENER(IEN)+DEL0
      IF(NHNVHV.EQ.1)GOTO4
      INDP=INDP+1
      PART(INDP,1)=X0+XS(IEN)+DX0
      PART(INDP,2)=XP0+XPS(IEN)
      PART(INDP,3)=Y0+YS(IEN)
      PART(INDP,4)=YP0+YPS(IEN)
      PART(INDP,5)=DLENS(IEN)
      PART(INDP,6)=DENER(IEN)+DEL0
      INDP=INDP+1
      PART(INDP,1)=X0+XS(IEN)
      PART(INDP,2)=XP0+XPS(IEN)+DXP0
      PART(INDP,3)=Y0+YS(IEN)
      PART(INDP,4)=YP0+YPS(IEN)
      PART(INDP,5)=DLENS(IEN)
      PART(INDP,6)=DENER(IEN)+DEL0
      INDP=INDP+1
      PART(INDP,1)=X0+XS(IEN)
      PART(INDP,2)=XP0+XPS(IEN)
      PART(INDP,3)=Y0+YS(IEN)+DY0
      PART(INDP,4)=YP0+YPS(IEN)
      PART(INDP,5)=DLENS(IEN)
      PART(INDP,6)=DENER(IEN)+DEL0
      INDP=INDP+1
      PART(INDP,1)=X0+XS(IEN)
      PART(INDP,2)=XP0+XPS(IEN)
      PART(INDP,3)=Y0+YS(IEN)
      PART(INDP,4)=YP0+YPS(IEN)+DYP0
      PART(INDP,5)=DLENS(IEN)
      PART(INDP,6)=DENER(IEN)+DEL0
    4 CONTINUE
      IF((MDPRT.GT.-2).AND.(IALFLG.EQ.0)) THEN
        IF(NVH.EQ.2) THEN
         WRITE(IOUT,10001)
10001 FORMAT(/,'  NAME       X           XP          Y      ',
     >'     YP        BETAX       ALPHAX      BETAY       ALPHAY   ',
     >'    NUX         NUY     ')
        ENDIF
        IF(NVH.EQ.3) THEN
         WRITE(IOUT,10002)
10002 FORMAT(/,'  NAME      BETAX       ALPHAX      BETAY    ',
     >'   ALPHAY       ETAX       ETAPX        ETAY       ETAPY    ',
     >'    NUX         NUY     ')
        ENDIF
        IF(NVH.EQ.4) THEN
         WRITE(IOUT,10003)
10003 FORMAT(/,'  NAME        SIGX        SIGXP     RXXP     EPSX   ',
     >'      SIGY       SIGYP      RYYP      EPSY      RXY      RXYP',
     >'   RXPY    RXPYP')
        ENDIF
        IF(NVH.EQ.6) THEN
         WRITE(IOUT,10004)
10004 FORMAT(/,'  NAME      BETAX       ALPHAX     BETAY   ',
     >'   ALPHAY  COUP     ETAX      ETAPX       ETAY       ETAPY ')
        ENDIF
      ENDIF
      CALL TRACKT
      IF(NCPART.EQ.0)GOTO6
      RETURN
    6 WRITE(IOUT,99999)
99999 FORMAT(/,'  ALL PARTICLE WERE LOST SO JOB IS ABORTED',/)
      CALL HALT(300)
      END

      SUBROUTINE DETLPR(IE, ILIST)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER    (mxpart = 128000)
      DIMENSION BETAX(15),ALPHAX(15),BETAY(15),ALPHAY(15),ANUX(15),
     <ANUY(15),R(6,6,15),BSIGL(4,4,15),XO(15),XPO(15),YO(15),YPO(15),
     >XCOEF(6),XPCOEF(6),YCOEF(6),YPCOEF(6),DLENO(15),
     >PHIX(15),PHIY(15),BSIGS(4,4,15)
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      COMMON/LNGTH/TLENG,ALENG(MXELMD),ACLENG(MAXPOS)
      LOGICAL LOGPAR
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      COMMON/DETL/DENER(15),NH,NV,NVH,NHVP(105),MDPRT,NDENER,
     1NUXS(45),NUX(45),NUYS(45),NUY(45),NCO,NHNVHV,MULPRT,NSIG
      COMMON/BETAL/BETA0X,ALPH0X,ETA0X,ETAP0X,
     >BETA0Y,ALPH0Y,ETA0Y,ETAP0Y,X0,XP0,Y0,YP0,DLEN0
     >,DX0,DXP0,DY0,DYP0,DEL0,XS(15),XPS(15),YS(15),YPS(15),DLENS(15)
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      COMMON/CBEAM/BSIG(6,6),BSIGF(6,6),MBPRT,IBMFLG,MENV
      PARAMETER  (mxlcnd = 200)
      PARAMETER  (mxlvar = 100)
      COMMON/FITL/COEF(MXLVAR,6),VALF(MXLCND),
     >  WGHT(MXLCND),RVAL(MXLCND),XM(MXLVAR)
     >  ,EM(MXLVAR),WV,NELF(MXLVAR,6),NPAR(MXLVAR,6),
     >  IND(MXLVAR,6),NPVAR(MXLVAR),NVAL(MXLCND)
     >  ,NSTEP,NVAR,NCOND,ISTART,NDIV,IFITM,IFITD,IFITBM
      COMMON/FITD/AVEBX,AVEAX,AVEBY,AVEAY,AVENUX,AVENUY,
     >AVER11,AVER12,AVER21,AVER22,AVER33,AVER34,AVER43,AVER44
      COMMON/MONIT/VALMON(MXLCND,4,3)
      COMMON/MONFIT/VALFA(MXLCND),WGHTA(MXLCND),ERRA(MXLCND),
     >AMULTA(MXLVAR,6),ADDA(MXLVAR,6),DELA(MXLVAR)
     >,NPARA(MXLVAR,6),NELFA(MXLVAR,6),
     >NPVARA(MXLVAR),INDA(MXLVAR,6),VALR(MXLCND),RMOSIG,
     >NMONA(MXLCND),NVALA(MXLCND),NVARA,NCONDA
     >,IALFLG,MONFLG,MONLST,NOPTER,
     >IAFRST,IMOOPT,IMSBEG,NALPRT
      COMMON/CSEEDS/ISEED,IXG,IXS,IXMSTP,IMSD,IMOSTP,ISYNSD,ISYSTP,
     >ISDBEG,IBGSTP,IXES,IXESTP,IESBEG,IESTBG,isdcol
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/CONDEF/REFEN
      character*3 cstr
      NEL=NORLST(IE)
      avebx=0.0d0
      aveax=0.0d0
      avenux=0.0d0
      aveby=0.0d0
      aveay=0.0d0
      avenuy=0.0d0
      aver11=0.0d0
      aver12=0.0d0
      aver21=0.0d0
      aver22=0.0d0
      aver33=0.0d0
      aver34=0.0d0
      aver43=0.0d0
      aver44=0.0d0
      IF((MDPRT.NE.-2).AND.(IALFLG.EQ.0)
     >.AND.(NOUT.GE.1).AND.(NVH.LT.2))
     >WRITE(IOUT,10042)IE,(NAME(IN,NEL),IN=1,8)
10042 FORMAT(/,'   AFTER ELEMENT ',2X,I4,'(',8A1,')',/)
      IF((BETA0X.EQ.0.0D0).OR.(BETA0Y.EQ.0.0D0))GOTO 101
      GAMM0X=(1.0D0+ALPH0X*ALPH0X)/BETA0X
      GAMM0Y=(1.0D0+ALPH0Y*ALPH0Y)/BETA0Y
  101 DO 1 IEN = 1, NDENER
      INDEN=(IEN-1)*MULPRT+1
      XO(IEN)=PART(INDEN,1)
      XPO(IEN)=PART(INDEN,2)
      YO(IEN)=PART(INDEN,3)
      YPO(IEN)=PART(INDEN,4)
      DLENO(IEN)=PART(INDEN,4)
      IF(NHNVHV.EQ.1)GOTO100
      INDEN=INDEN+1
      R(1,1,IEN)=(PART(INDEN,1)-XO(IEN))/DX0
      R(2,1,IEN)=(PART(INDEN,2)-XPO(IEN))/DX0
      R(3,1,IEN)=(PART(INDEN,3)-YO(IEN))/DX0
      R(4,1,IEN)=(PART(INDEN,4)-YPO(IEN))/DX0
      INDEN=INDEN+1
      R(1,2,IEN)=(PART(INDEN,1)-XO(IEN))/DXP0
      R(2,2,IEN)=(PART(INDEN,2)-XPO(IEN))/DXP0
      R(3,2,IEN)=(PART(INDEN,3)-YO(IEN))/DXP0
      R(4,2,IEN)=(PART(INDEN,4)-YPO(IEN))/DXP0
      INDEN=INDEN+1
      R(1,3,IEN)=(PART(INDEN,1)-XO(IEN))/DY0
      R(2,3,IEN)=(PART(INDEN,2)-XPO(IEN))/DY0
      R(3,3,IEN)=(PART(INDEN,3)-YO(IEN))/DY0
      R(4,3,IEN)=(PART(INDEN,4)-YPO(IEN))/DY0
      INDEN=INDEN+1
      R(1,4,IEN)=(PART(INDEN,1)-XO(IEN))/DYP0
      R(2,4,IEN)=(PART(INDEN,2)-XPO(IEN))/DYP0
      R(3,4,IEN)=(PART(INDEN,3)-YO(IEN))/DYP0
      R(4,4,IEN)=(PART(INDEN,4)-YPO(IEN))/DYP0
  100 IF(NH.EQ.0)GOTO 2
      CX=R(1,1,IEN)
      SX=R(1,2,IEN)
      CPX=R(2,1,IEN)
      SPX=R(2,2,IEN)
      BETAX(IEN)=CX*CX*BETA0X-2.0D0*CX*SX*ALPH0X+SX*SX*GAMM0X
      ALPHAX(IEN)=-CPX*CX*BETA0X+(1.0D0+2.0D0*SX*CPX)*
     >ALPH0X-SX*SPX*GAMM0X
      AMU=DATAN2(SX,(CX*BETA0X-SX*ALPH0X))
      ANUX(IEN)=AMU/TWOPI
      IF(ANUX(IEN).LT.0.0D0)GOTO 10
      NUXS(IEN)=0
   11 ANUX(IEN)=ANUX(IEN)+NUX(IEN)
      INUX0=ANUX(1)+0.5D0
      INUX1=ANUX(IEN)+0.5D0
      ANUX(IEN)=ANUX(IEN)+INUX0-INUX1
      PHIX(IEN)=ANUX(IEN)*360.0D0
      GOTO 2
   10 IF(NUXS(IEN).NE.0)GOTO 11
      NUX(IEN)=NUX(IEN)+1
      NUXS(IEN)=1
      GOTO 11
    2 IF(NV.EQ.0)GOTO 3
      CY=R(3,3,IEN)
      SY=R(3,4,IEN)
      CPY=R(4,3,IEN)
      SPY=R(4,4,IEN)
      BETAY(IEN)=CY*CY*BETA0Y-2.0D0*CY*SY*ALPH0Y+SY*SY*GAMM0Y
      ALPHAY(IEN)=-CPY*CY*BETA0Y+(1.0D0+2.0D0*SY*CPY)*
     >ALPH0Y-SY*SPY*GAMM0Y
      AMU=DATAN2(SY,(CY*BETA0Y-SY*ALPH0Y))
      ANUY(IEN)=AMU/TWOPI
      IF(ANUY(IEN).LT.0.0D0)GOTO 20
      NUYS(IEN)=0
   21 ANUY(IEN)=ANUY(IEN)+NUY(IEN)
      INUY0=ANUY(1)+0.5D0
      INUY1=ANUY(IEN)+0.5D0
      ANUY(IEN)=ANUY(IEN)+INUY0-INUY1
      PHIY(IEN)=ANUY(IEN)*360.0D0
      GOTO 3
   20 IF(NUYS(IEN).NE.0)GOTO 21
      NUY(IEN)=NUY(IEN)+1
      NUYS(IEN)=1
      GOTO 21
    3 IF(NVH.EQ.0)GOTO 35
      IF(IBMFLG.NE.0)GOTO 351
      WRITE(IOUT,88888)
      IF(ISO.NE.0)WRITE(ISOUT,88888)
88888 FORMAT(//,'    A BEAM MATRIX WAS NOT DEFINED RUN IS STOPPED  ')
      CALL HALT(301)
      STOP
  351 IF(IALFLG.GT.1)GOTO 61
      IF((IALFLG.EQ.1).AND.(NSIG.EQ.0))GOTO 35
      DO 62 IBS=1,4
      DO 62 JBS=1,4
   62 BSIGS(IBS,JBS,IEN)=BSIG(IBS,JBS)
   61 DO 31 IB=1,4
      DO 31 JB=1,4
      BSIGL(IB,JB,IEN)=0.0D0
      DO 31 KB=1,4
      SL=0.0D0
      DO 32 LB=1,4
   32 SL=SL+BSIGS(KB,LB,IEN)*R(JB,LB,IEN)
   31 BSIGL(IB,JB,IEN)=BSIGL(IB,JB,IEN)+R(IB,KB,IEN)*SL
      IF(IALFLG.NE.1)GOTO 64
      DO 65 IBS=1,4
      DO 65 JBS=1,4
   65 BSIGS(IBS,JBS,IEN)=BSIGL(IBS,JBS,IEN)
   64 DO 33 IB=1,4
   33 BSIGL(IB,IB,IEN)=DSQRT(BSIGL(IB,IB,IEN))
      DO 34 IB=1,3
      JB=IB+1
      DO 34 JBB=JB,4
      BSIGL(IB,JBB,IEN)=BSIGL(IB,JBB,IEN)/(BSIGL(IB,IB,IEN)*
     >BSIGL(JBB,JBB,IEN))
   34 BSIGL(JBB,IB,IEN)=BSIGL(IB,JBB,IEN)
   35 IF(IALFLG.EQ.0) GOTO 137
      DO 36 IM=1,NCONDA
      IF(IE.NE.NMONA(IM))GOTO 36
           VALMON(IM,1,IEN)=XO(IEN)
           VALMON(IM,2,IEN)=YO(IEN)
           VALMON(IM,3,IEN)=BSIGL(1,1,IEN)
           VALMON(IM,4,IEN)=BSIGL(3,3,IEN)
      IF(IMOOPT.EQ.0)GOTO 36
      DO 136 IIMO=1,4
      VALMON(IM,IIMO,IEN)=VALMON(IM,IIMO,IEN)+
     >            RANNUM(IMSD,IMOOPT,RMOSIG,IMOSTP)*ERRA(IM)
  136 CONTINUE
   36 CONTINUE
  137 avebx=avebx+(betax(ien)-betax(1))**2/ndener
      aveax=aveax+(alphax(ien)-alphax(1))**2/ndener
      avenux=avenux+(anux(ien)-anux(1))**2/ndener
      aveby=aveby+(betay(ien)-betay(1))**2/ndener
      aveay=aveay+(alphay(ien)-alphay(1))**2/ndener
      avenuy=avenuy+(anuy(ien)-anuy(1))**2/ndener
      aver11=aver11+(r(1,1,ien)-r(1,1,1))**2/ndener
      aver12=aver12+(r(1,2,ien)-r(1,2,1))**2/ndener
      aver21=aver21+(r(2,1,ien)-r(2,1,1))**2/ndener
      aver22=aver22+(r(2,2,ien)-r(2,2,1))**2/ndener
      aver33=aver33+(r(3,3,ien)-r(3,3,1))**2/ndener
      aver34=aver34+(r(3,4,ien)-r(3,4,1))**2/ndener
      aver43=aver43+(r(4,3,ien)-r(4,3,1))**2/ndener
      aver44=aver44+(r(4,4,ien)-r(4,4,1))**2/ndener
    1 CONTINUE
      IF((NVH.EQ.3).or.(nvh.eq.6))  THEN
        DENOM=(DENER(2)-DENER(3))
        ETAX=(PART(6,1)-PART(11,1))/DENOM
        ETAPX=(PART(6,2)-PART(11,2))/DENOM
        ETAY=(PART(6,3)-PART(11,3))/DENOM
        ETAPY=(PART(6,4)-PART(11,4))/DENOM
        EX=ETAX*ETAFAC
        EPX=ETAPX*ETAFAC
        EY=ETAY*ETAFAC
        EPY=ETAPY*ETAFAC
      ENDIF
      IF(IALFLG.NE.1)GOTO200
      DO 1000 ISD=1,NDENER
      XS(ISD)=XO(ISD)
      XPS(ISD)=XPO(ISD)
      YS(ISD)=YO(ISD)
      YPS(ISD)=YPO(ISD)
      DLENS(ISD)=DLENO(ISD)
 1000 CONTINUE
      DEL0=PART(1,6)-DENER(1)
      X0=0.0d0
      XP0=0.0d0
      Y0=0.0d0
      YP0=0.0d0
      BETA0X=BETAX(1)
      ALPH0X=ALPHAX(1)
      BETA0Y=BETAY(1)
      ALPH0Y=ALPHAY(1)
  200 IF(MDPRT.EQ.-2)GOTO 40
      IF(IALFLG.NE.0)GOTO 40
      IF(NVH.EQ.2)GOTO 50
      IF(NVH.EQ.3)GOTO 60
      IF(NVH.EQ.4)GOTO 70
      IF(NVH.EQ.5)GOTO 80
      if(nvh.eq.6)goto 90
      IF(NOUT.GE.1)
     >WRITE(IOUT,20000)
20000 FORMAT(//,' CENTROID COORDINATES',/)
      IF(NOUT.GE.1)
     >WRITE(IOUT,20020)
20020 FORMAT(/,2X,'ENERGY(DP/P)',5X,'X(M)',8X,'XP(RAD)',9X,'Y(M)',
     >8X,'YP(RAD)',/)
      IF(NOUT.GE.1)
     >WRITE(IOUT,20001)(DENER(IEN),XO(IEN),XPO(IEN),YO(IEN),
     >YPO(IEN),IEN=1,NDENER)
20001 FORMAT(/,(2X,5(E13.5)))
      IF(NCO.EQ.0)GOTO 301
      CALL POLLSQ(DENER,XO,NDENER,NCO,XCOEF,REFEN)
      CALL POLLSQ(DENER,XPO,NDENER,NCO,XPCOEF,REFEN)
      CALL POLLSQ(DENER,YO,NDENER,NCO,YCOEF,REFEN)
      CALL POLLSQ(DENER,YPO,NDENER,NCO,YPCOEF,REFEN)
      IF(NOUT.GE.1)
     >WRITE(IOUT,30001)REFEN
30001 FORMAT(/,' TAYLOR EXPANSION COEFFICIENTS FOR REFERENCE ',
     >'MOMENTUM:',E10.3,//,
     >'   #         X             XP             Y             YP',//)
      DO 300 ICO=1,NCO
      ICOM1=ICO-1
  300 IF(NOUT.GE.1)
     >WRITE(IOUT,30002)ICOM1,XCOEF(ICO),XPCOEF(ICO),YCOEF(ICO),
     >YPCOEF(ICO)
30002 FORMAT(I4,4E14.5)
  301 IF((NH.EQ.0).AND.(NV.EQ.0).AND.(NVH.EQ.0))GOTO 40
      IF(NOUT.GE.3)
     >WRITE(IOUT,20010)
20010 FORMAT(//,' TRANSFER MATRICES ELEMENTS ',/)
      IF(NOUT.GE.3)
     >WRITE(IOUT,20021)
20021 FORMAT(/,2X,'ENERGY(DP/P)',5X,'R11',10X,'R12',10X,'R13',10X,
     >'R14',/)
      IF(NOUT.GE.3)
     >WRITE(IOUT,20011)(DENER(IEN),(R(1,JM,IEN),JM=1,4),IEN=1,NDENER)
20011 FORMAT(/,(2X,5(E13.5)))
      IF(NOUT.GE.3)
     >WRITE(IOUT,20022)
20022 FORMAT(/,2X,'ENERGY(DP/P)',5X,'R21',10X,'R22',10X,'R23',10X,
     >'R24',/)
      IF(NOUT.GE.3)
     >WRITE(IOUT,20011)(DENER(IEN),(R(2,JM,IEN),JM=1,4),IEN=1,NDENER)
      IF(NOUT.GE.3)
     >WRITE(IOUT,20023)
20023 FORMAT(/,2X,'ENERGY(DP/P)',5X,'R31',10X,'R32',10X,'R33',10X,
     >'R34',/)
      IF(NOUT.GE.3)
     >WRITE(IOUT,20011)(DENER(IEN),(R(3,JM,IEN),JM=1,4),IEN=1,NDENER)
      IF(NOUT.GE.3)
     >WRITE(IOUT,20024)
20024 FORMAT(/,2X,'ENERGY(DP/P)',5X,'R41',10X,'R42',10X,'R43',10X,
     >'R44',/)
      IF(NOUT.GE.3)
     >WRITE(IOUT,20011)(DENER(IEN),(R(4,JM,IEN),JM=1,4),IEN=1,NDENER)
      IF(NH.EQ.0)GOTO 41
      IF(NOUT.GE.3)
     >WRITE(IOUT,20002)
20002 FORMAT(//,' HORIZONTAL FUNCTION VALUES',/)
      IF(NOUT.GE.3)
     >WRITE(IOUT,20025)
20025 FORMAT(/,2X,'ENERGY(DP/P)',4X,'BETAX',7X,'ALPHAX',9X,'NUX',
     >8X,'PHIX',/)
      IF(NOUT.GE.3)
     >WRITE(IOUT,20003)(DENER(IEN),BETAX(IEN),ALPHAX(IEN),
     >ANUX(IEN),PHIX(IEN),IEN=1,NDENER)
20003 FORMAT(/,(2X,5(E13.5)))
   41 IF(NV.EQ.0)GOTO 42
      IF(NOUT.GE.3)
     >WRITE(IOUT,20004)
20004 FORMAT(//,' VERTICAL FUNCTION VALUES',/)
      IF(NOUT.GE.3)
     >WRITE(IOUT,20026)
20026 FORMAT(/,2X,'ENERGY(DP/P)',4X,'BETAY',7X,'ALPHAY',9X,'NUY',
     >8X,'PHIY',/)
      IF(NOUT.GE.3)
     >WRITE(IOUT,20003)(DENER(IEN),BETAY(IEN),ALPHAY(IEN),
     >ANUY(IEN),PHIY(IEN),IEN=1,NDENER)
   42 IF(NVH.EQ.0)GOTO 40
      IF(NOUT.GE.1)
     >WRITE(IOUT,20005)
20005 FORMAT(//,' BEAM MATRIX VALUES ',/)
      IF(NOUT.GE.1)
     >WRITE(IOUT,20027)
20027 FORMAT(/,2X,'ENERGY(DP/P)',4X,'SIGX',8X,'SIGXP',9X,'R12',
     >9X,'SIGY',8X,'SIGYP',9X,'R34',/)
      IF(NOUT.GE.1)
     >WRITE(IOUT,20006)(DENER(IEN),BSIGL(1,1,IEN),BSIGL(2,2,IEN),
     >BSIGL(1,2,IEN),BSIGL(3,3,IEN),BSIGL(4,4,IEN),BSIGL(3,4,IEN),
     >IEN=1,NDENER)
20006 FORMAT(/,(2X,7(E13.5)))
      IF(NOUT.GE.3)
     >WRITE(IOUT,20028)
20028 FORMAT(/,2X,'ENERGY(DP/P)',5X,'R13',10X,'R14',10X,'R23',
     >10X,'R24',/)
      IF(NOUT.GE.3)
     >WRITE(IOUT,20007)(DENER(IEN),BSIGL(1,3,IEN),BSIGL(1,4,IEN),
     >BSIGL(2,3,IEN),BSIGL(2,4,IEN),IEN=1,NDENER)
20007 FORMAT(/,(2X,5(E13.5)))
   40 RETURN
   50 DO 51 IEN=1,NDENER
      IF (IEN.EQ.1)  THEN
        IF(NDENER.GT.1) THEN
      WRITE(IOUT,10051)(NAME(IN,NEL),IN=1,8),XO(IEN),XPO(IEN),YO(IEN),
     >YPO(IEN),BETAX(IEN),ALPHAX(IEN),BETAY(IEN),ALPHAY(IEN),
     >ANUX(IEN),ANUY(IEN)
10051 FORMAT(/,' ',8A1,10(E12.4))
                        ELSE
      WRITE(IOUT,10053)(NAME(IN,NEL),IN=1,8),XO(IEN),XPO(IEN),YO(IEN),
     >YPO(IEN),BETAX(IEN),ALPHAX(IEN),BETAY(IEN),ALPHAY(IEN),
     >ANUX(IEN),ANUY(IEN)
10053 FORMAT(' ',8A1,10(E12.4))
        ENDIF
                     ELSE
      WRITE(IOUT,10052)XO(IEN),XPO(IEN),YO(IEN),
     >YPO(IEN),BETAX(IEN),ALPHAX(IEN),BETAY(IEN),ALPHAY(IEN),
     >ANUX(IEN),ANUY(IEN)
10052 FORMAT(' ',8X,10(E12.4))
      ENDIF
   51 CONTINUE
      RETURN
   60 CONTINUE
      WRITE(IOUT,10061)(NAME(IN,NEL),IN=1,8),BETAX(1),ALPHAX(1),
     >BETAY(1),ALPHAY(1),EX,EPX,EY,EPY,ANUX(1),ANUY(1)
10061 FORMAT(' ',8A1,10(E12.4))
      RETURN
   70 CONTINUE
      DO 71 IEN=1,NDENER
      SX=BSIGL(1,1,IEN)*SIGFAC
      SXP=BSIGL(2,2,IEN)*SIGFAC
      SY=BSIGL(3,3,IEN)*SIGFAC
      SYP=BSIGL(4,4,IEN)*SIGFAC
      rxxp=bsigl(1,2,ien)
      rxxp2=rxxp*rxxp
      if(rxxp2.lt.1.0d0)then
        prepsx=sx*sxp*dsqrt(1.0d0-rxxp2)
                      else
        prepsx=0.0d0
      endif
      ryyp=bsigl(3,4,ien)
      ryyp2=ryyp*ryyp
      if(ryyp2.lt.1.0d0)then
        prepsy=sy*syp*dsqrt(1.0d0-ryyp2)
                      else
        prepsy=0.0d0
      endif
      IF (IEN.EQ.1)  THEN
        IF(NDENER.GT.1) THEN
      WRITE(IOUT,10071)(NAME(IN,NEL),IN=1,8),SX,
     >SXP
     >,rxxp,prepsx,SY,
     >SYP,ryyp,prepsy,
     > BSIGL(1,3,IEN),BSIGL(1,4,IEN),
     >BSIGL(2,3,IEN),BSIGL(2,4,IEN)
10071 FORMAT(/,' ',8A1,2e12.4,f8.4,3e12.4,f8.4,e12.4,4f8.4)
                        ELSE
      WRITE(IOUT,10073)(NAME(IN,NEL),IN=1,8),SX,
     >SXP
     >,rxxp,prepsx,SY,
     >SYP,ryyp,prepsy,
     > BSIGL(1,3,IEN),BSIGL(1,4,IEN),
     >BSIGL(2,3,IEN),BSIGL(2,4,IEN)
10073 FORMAT(' ',8A1,2e12.4,f8.4,3e12.4,f8.4,e12.4,4f8.4)
        ENDIF
                     ELSE
      WRITE(IOUT,10072)SX,
     >SXP
     >,rxxp,prepsx,SY,
     >SYP,ryyp,prepsy,
     > BSIGL(1,3,IEN),BSIGL(1,4,IEN),
     >BSIGL(2,3,IEN),BSIGL(2,4,IEN)
10072 FORMAT(' ',8X,2e12.4,f8.4,3e12.4,f8.4,e12.4,4f8.4)
      ENDIF
   71 CONTINUE
      RETURN
   80 CONTINUE
      WRITE(IOUT,10081)KODE(NEL),ACLENG(IE),BETAX(1),ALPHAX(1),
     >BETAY(1),ALPHAY(1),ETAX,ETAPX,ETAY,ETAPY,ANUX(1),ANUY(1)
10081 FORMAT(' ',I3,11(E11.3))
      RETURN
   90 continue
      sc=1.0e03
      bx=bsigl(1,1,1)*sc
      cx=bsigl(2,2,1)*sc
      ax=-bsigl(1,2,1)*bx*cx
      bx=bx*bx
      cx=cx*cx
      by=bsigl(3,3,1)*sc
      cy=bsigl(4,4,1)*sc
      ay=-bsigl(3,4,1)*by*cy
      by=by*by
      cy=cy*cy
      ctst=dabs(bsigl(1,3,1))+dabs(bsigl(1,4,1))
     >   +dabs(bsigl(2,3,1))+dabs(bsigl(2,4,1))
      cstr='no '
      if(ctst.gt.1.0e-03) cstr='yes'
      write(iout,10091)(name(in,nel),in=1,8),
     >                         bx,ax,by,ay,cstr,ex,epx,ey,epy
10091 format(' ',8a1,4e11.3,' ',a3,' ',4e11.3)
      return
      END
C**********************************************************************
      SUBROUTINE DIMAIN
C**********************************************************************
      IMPLICIT REAL*8 (A-H,O-Z)
C
C**********************************************************************
C
C   IMPLEMENTATION NOTES:
C
C   - THE PRESENT CODE IS SET UP FOR AN IBM ENVIRONMENT AND FORTRAN 77
C   - IF THE FUNCTIONS SINH COSH AND TAN DO NOT EXIST IN THE COMPILER
C     ACTIVATE THESE FUNCTIONS AT THE END OF THE PROGRAM.
C   - FOR A VAX MACHINE THE FIRST EXECUTABLE STATEMENT IN THE PROGRAM
C     MAIN MUST BE REMOVED
C   - THE FUNCTION CLOCK1 MUST BE ACTIVATED BY REMOVING THE C'S IN
C     COLUMN ONE
C   - THE ROUTINE SETUP HAS TO BE MODIFIED AS INDICATED, IF NEEDED
C   - THE FUNCTION URAND IS A PORTABLE RANDOM GENERATOR OF AVERAGE
C     QUALITY AND IF IN DOUBT MAY BE REPLACED AS INDICATED
C   - ALL ROUTINES AND FUNCTIONS ARE IN ALPHABETICAL ORDER
C   - THE STATEMENTS CORRESPONDING TO THE COMPUTER USED HAVE TO
C     BE ACTIVATED IN THE FUNCTION DPMPAR. DO NOT FORGET TO DEACTIVATE
C     THOSE CORRESPONDING TO THE IBM ENVIRONMENT
C
C**********************************************************************
C
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      PARAMETER    (mxpart = 128000)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON /PAGTIT/   KTIT,KVERS,KDATE,KTIME
      CHARACTER*8       KTIT*80,KVERS,KDATE,KTIME
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      COMMON/FUNC/BETAX,ALPHAX,ETAX,ETAPX,BETAY,ALPHAY,ETAY,ETAPY,
     <  STARTE,ENDE,DELTAE,DNU,MFPRNT,KOD,NLUM,NINT,NBUNCH
      COMMON/SYM/ENERLI,GAMMLI,BETALI,bili,b2li,b2ili,
     >ISYOPT,ISYFLG,MATTOT,KANVAR
      COMMON/LNGTH/TLENG,ALENG(MXELMD),ACLENG(MAXPOS)
      COMMON/LINCAV/LCAVIN,NUMCAV,ENJECT,IECAV(MAXMAT),
     &              EIDEAL(MAXPOS),EREAL(MAXPOS)
      parameter    (MXCEB = 2000)
      common/cebcav/cebmat(6,6,mxceb),estart,ecav(mxceb),
     >ipos(mxceb),icavtot,icebflg,iestflg,icurcav
      LOGICAL LCAVIN
      common/newbm/newbmo
      character*1 ititop(80)
C
C   OPEN THE INPUT AND OUTPUT FILES
C
      CALL SETUP
C
      IF(NEWBMO.EQ.1) GOTO 99131
      CALL CINITG
C
      WRITE(IOUT,99997)
99997 FORMAT('1',//////////,18X
     >,'******************************************************',//,18X
     >,'* DIMAD PROGRAM : LAST MODIFIED ON MAY      20, 1991 *',//,18X
     >,'******************************************************',///)
      WRITE(IOUT,19998)KTIT
19998 FORMAT(/////,30X,A80,/)
C      WRITE(IOUT,19999)KTIT
C19999 FORMAT(/,10X,A80,//)
99131  CALL LENG
      IF(NOUT.GE.2)WRITE(IOUT,10111)TLENG
10111 FORMAT(//,' TOTAL LENGTH OF MACHINE IS:',F10.3,' METERS',/)
C
C INITIALISE CAVITY ARRAYS
C
C    SCAN NORLST FOR CAVITIES
      LCAVIN=.FALSE.
      DO 1985 KEVIN=1,MAXMAT
 1985 IECAV(KEVIN)=0
      NUMCAV=0
       iw=0
      DO 1986 KEVIN=1,NELM
      if(kode(norlst(kevin)).eq.20) then
       if(iw.eq.0) then
         write(iout,19899)
19899 format(' request a matrix for a cebaf cavity ')
         icebflg=1
         iw=1
       endif
CC       call setceb(kevin)
      endif
      IF(KODE(NORLST(KEVIN)).EQ.17) THEN
        NUMCAV = NUMCAV + 1
        IECAV(NUMCAV) = KEVIN
      END IF
 1986 CONTINUE
      IF(IECAV(1).NE.0) LCAVIN=.TRUE.
C
C    LOAD UP ENERGY ARRAYS WITH INITIAL VALUES
C
C       INJECTION ENERGY OFFSET - DEFAULT TO 1 GEV
C
      DO 1987 KEVIN=1,NELM
      IF(LCAVIN) THEN
        EIDEAL(KEVIN)=ELDAT(IADR(NORLST(IECAV(1)))+1)
      ELSE
        EIDEAL(KEVIN)=1.D0
      END IF
        EREAL(KEVIN)=EIDEAL(KEVIN)
 1987 CONTINUE
      ENJECT=EIDEAL(1)
C
C     GENERATE EIDEAL ARRAY AND INITIALISE EREAL TO EIDEAL
C
      IF(LCAVIN) THEN
          DO 1989 KEVIN=1,NUMCAV
             DO 1988 LYN=IECAV(KEVIN),NELM
                EIDEAL(LYN) = EIDEAL(LYN)
     &                      + ELDAT(IADR(NORLST(IECAV(KEVIN)))+2)
                EREAL(LYN)=EIDEAL(LYN)
 1988        CONTINUE
 1989     CONTINUE
      END IF
C
C  ENERGY ARRAYS ARE NOW LOADED AND CAVITY INFORMATION SAVED
C     CALL THE RELEVENT ROUTINE TO CREATE THE MATRIX
C     AMAT(27,6,N) ACCORDING TO THE CODE "KODE"
C
      IMAD=1
      DO 120 IELM=1,NA
      KOD=KODE(IELM)
      IF ((KOD.NE.0).AND.(KOD.NE.6).AND.(KOD.NE.12).AND.
     >(KOD.NE.13).AND.(KOD.NE.8).and.(kod.ne.18).and.
     >(kod.ne.20)) THEN
       MADR(IELM)=IMAD
       CALL MATGEN(IELM)
       IMAD=IMAD+1
       IF(IMAD.GT.MAXMAT) THEN
        WRITE(IOUT,77774)MAXMAT
77774 FORMAT('  TOO MANY MATRICES : MAXIMUM IS :',I4,/,
     >'  INCREASE VALUE OF PARAMETER MAXMAT ')
        CALL HALT(3)
       ENDIF
                                                     ELSE
       MADR(IELM)=0
      ENDIF
120   CONTINUE
      MATTOT=IMAD-1
      MAXADR=IADR(NA+1)
      WRITE(IOUT,77773)NA,MXELMD,NELM,MAXPOS,
     >MATTOT,MAXMAT,MAXADR,MAXDAT
77773 FORMAT(' IN THIS RUN THERE ARE :',
     >/,'  ',I5,' DISTINCT ELEMENTS.  MAX IS MXELMD :',I5,
     >/,'  ',I5,' ELEMENTS IN MACHINE.MAX IS MAXPOS :',I5,
     >/,'  ',I5,' MATRICES DEFINED.   MAX IS MAXMAT :',I5,
     >/,'  ',I5,' VALUES IN ELDAT.    MAX IS MAXDAT :',I5,/)
      nwpg=0
      IF(KCOUNT.EQ.0) GO TO 130
      IF(NOUT.GE.1)WRITE(IOUT,140)KCOUNT
140   FORMAT(//' WARNING ',I4,' MATRICES COMPUTED FOR REAL KICKS'//)
130   CONTINUE
C  get operation name and code
      call getop(kod,ikod,ititop,nwpg)
      iend=0
      GO TO (1000,2000,3000,4000,5000,6000,7000,8000
     >,9000,10000,11000,12000,13000,14000,15000,16000,17000
     >,18000,19000,20000,21000,22000,23000,24000,25000,26000
     >,27000,28000,29000,30000,31000,32000,33000,34000,35000
     >,36000,37000,38000,39000,40000,41000,42000,43000,44000
     >,45000,46000
     >),IKOD
      WRITE(IOUT,10010)
10010 FORMAT(24H ERROR IN OPERATION CODE)
      NOP=-1
      NCHAR=0
      NIPR=1
      CALL INPUT(ICHAR,NCHAR,DATA,MXINP,IEND,NOP,NIPR)
      GO TO 99000
 1000 IF(KOD.EQ.100)CALL FITMAT(IEND)
      IF(KOD.EQ.110)CALL FITLSQ(IEND)
      nwpg=1
      GO TO 99000
 2000 call twan(kod,ikod,iend)
      nwpg=1
      goto 99000
 3000 call trapre(iend)
      nwpg=1
      goto 99000
 4000 call modpre(iend)
      nwpg=0
      goto 99000
 5000 call matpre(kod,iend)
      nwpg=1
      GO TO 99000
6000  CALL DETAIL(IEND)
      nwpg=1
      GO TO 99000
7000  CALL GEABER(IEND)
      nwpg=1
      GO TO 99000
8000  CALL LINABE(IEND)
      nwpg=1
      GOTO 99000
9000  CALL MISDAT(IEND)
      nwpg=0
      GOTO 99000
10000 CALL ERRDAT(IEND)
      nwpg=0
      GOTO 99000
11000 CALL SETMIS(IEND)
      nwpg=0
      GOTO 99000
12000 CALL SETERR(IEND)
      nwpg=0
      GOTO 99000
13000 CALL SEED(IEND)
      nwpg=0
      GOTO 99000
14000 CALL ALIGN(IEND)
      nwpg=1
      GOTO 99000
15000 CALL REFORB(IEND)
      nwpg=1
      GOTO 99000
16000 CALL CORDAT(IEND)
      nwpg=0
      GOTO 99000
17000 CALL SETCOR(IEND)
      nwpg=0
      GOTO 99000
18000 CALL SETSYN(IEND)
      nwpg=0
      GOTO 99000
19000 CALL SHOCOR(IEND)
      nwpg=0
      GOTO 99000
20000 CALL GENER(IEND)
      nwpg=0
      GOTO 99000
21000 CALL BASE(IEND)
      nwpg=1
      GOTO 99000
22000 CALL PARTAN(IEND)
      nwpg=0
      GOTO 99000
23000 CALL CONDF(IEND)
      nwpg=0
      GOTO 99000
24000 CALL SHOERR(IEND)
      nwpg=0
      GOTO 99000
25000 CALL SHOMIS(IEND)
      nwpg=0
      GOTO 99000
26000 CALL OUTCON(IEND)
      nwpg=0
      GOTO 99000
27000 CALL SETADI(IEND)
      nwpg=0
      GOTO 99000
28000 CALL SETSYM(IEND)
      nwpg=0
      GOTO 99000
29000 CALL SHOCON(IEND)
      nwpg=0
      GOTO 99000
30000 call filpre(iend)
      nwpg=0
      goto 99000
31000 CALL FITPT(IEND)
      nwpg=0
      GOTO 99000
32000 CALL CHGCOR(IEND)
      nwpg=0
      GOTO 99000
33000 CALL RDMON(IEND)
      nwpg=0
      GOTO 99000
34000 KADOUT=0
      IHPXY=0
      CALL HPON
      nwpg=0
      GO TO 99000
35000 CALL RMPRE(IEND)
      nwpg=1
      GOTO 99000
36000 CALL INTER(IEND)
      nwpg=1
      GOTO 99000
37000 CALL SEISM(IEND)
      nwpg=0
      GOTO 99000
38000 CALL BLOCK(IEND)
      nwpg=0
      GOTO 99000
39000 CALL TUNE(IEND)
      nwpg=0
      GOTO 99000
40000 CALL SLCOUT(IEND)
      nwpg=0
      GOTO 99000
41000 CALL LIMITS(IEND)
      nwpg=0
      GOTO 99000
42000 CALL PRTDEF(IEND)
      nwpg=0
      GOTO 99000
43000 CALL SPCHG(IEND)
      nwpg=0
      GOTO 99000
44000 CALL LAY(IEND)
      nwpg=1
      GOTO 99000
45000 CALL dcosy(IEND)
      nwpg=1
      GOTO 99000
46000 CALL setcav(IEND)
      nwpg=0
      GOTO 99000
99000 NORDER=2
      NOF=27
      IF(IEND.NE.1) GO TO 130
      RETURN
      END

      SUBROUTINE DIMATD
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER(I-N)
C---- PARAMETER TABLE
      PARAMETER         (MAXPAR = 19000)
      COMMON /PARNAM/   KPARM(MAXPAR)
      CHARACTER*8       KPARM
      COMMON /PARDAT/   IPARM1,IPARM2,IPTYP(MAXPAR),IPDAT(MAXPAR,2),
     +                  IPLIN(MAXPAR)
      COMMON /PARVAL/   PDATA(MAXPAR)
      COMMON /PARLST/   IPLIST,IPNEXT(MAXPAR)
C---- SEQUENCE TABLE
      PARAMETER         (MAXPOS = 10000)
      COMMON /SEQNUM/   ITEM(MAXPOS)
      COMMON /SEQFLG/   PRTFLG(MAXPOS)
      LOGICAL           PRTFLG
C---- MACHINE PERIOD DEFINITION
      COMMON /PERIOD/   IPERI,IACT,NSUP,NELM,NFREE,NPOS1,NPOS2
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- UNITS
      COMMON /UNITS/    KFLAGU
      COMMON /NEWBM/    NEWBMO
C---- DIMAT COMMON BLOCKS
      PARAMETER         (MAXELM = 5000)
      PARAMETER         (MXELMD = 3000)
      PARAMETER         (MAXMAT = 500)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXLIST = 40)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(MXELMD),LABEL(MXELMD)
      CHARACTER*8 NAME
      CHARACTER*14 LABEL
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELMD,NOP,
     <NLIST(2*MXLIST)
      COMMON/LNGTH/TLENG,ALENG(MXELMD),ACLENG(MAXPOS)
      PARAMETER  (mxlcnd = 200)
      COMMON/MONIT/VALMON(MXLCND,4,3)
C---- ELEMENT TABLE
      COMMON /ELMNAM/   KELEM(MAXELM),KETYP(MAXELM),KELABL(MAXELM)
      CHARACTER*8       KELEM,KELABL*14
      CHARACTER*4       KETYP
      COMMON /ELMDAT/   IELEM1,IELEM2,IETYP(MAXELM),IEDAT(MAXELM,3),
     +                  IELIN(MAXELM)
C---- FLAGS FOR I/O
      COMMON /IOFLAG/   SCAN,ERROR,SKIP,ENDFIL,INTER
      LOGICAL           SCAN,ERROR,SKIP,ENDFIL,INTER
C-----------------------------------------------------------------------
      DIMENSION IMADDI(MAXELM)
      DIMENSION ITRANS(162)
      DATA ITRANS/
     +     110,120,130,140,150,160,111,112,
     + 113,114,115,116,122,123,124,125,126,
     + 133,134,135,136,144,145,146,155,156,
     + 166,210,220,230,240,250,260,211,212,
     + 213,214,215,216,222,223,224,225,226,
     + 233,234,235,236,244,245,246,255,256,
     + 266,310,320,330,340,350,360,311,312,
     + 313,314,315,316,322,323,324,325,326,
     + 333,334,335,336,
     + 344,345,346,355,356,366,410,420,430,
     + 440,450,460,411,412,413,414,415,416,
     + 422,423,424,425,426,433,434,435,436,
     + 444,445,446,455,456,466,510,520,530,
     + 540,550,560,511,512,513,514,515,516,
     + 522,523,524,525,526,533,534,535,536,
     + 544,545,546,555,556,566,610,620,630,
     + 640,650,660,611,612,613,614,615,616,
     + 622,623,624,625,626,633,634,635,636,
     + 644,645,646,655,656,666 /
      NFREE = 0
      NELMD = NELM
C
      I = 0
      DO 1001 IND=1,IELEM1
        IF(IETYP(IND).LE.0) GO TO 1001
        I = I + 1
        IMADDI(IND) = I
 1001 CONTINUE
C
C---FILL NORLST FROM ITEM
      IJ = 1
      II = 1
      DO 200 I=NPOS1,NPOS2-1
        IF(ITEM(I).GT.MAXELM) GO TO 200
        NORLST(IJ) = IMADDI(ITEM(I))
        II = II + 1
        IF(II.GE.MAXPOS) GO TO 200
        IJ = IJ + 1
 200  CONTINUE
      IF (II.GT.IJ) THEN
          WRITE(IPRNT,920) II
          CALL HALT(4)
      ENDIF
C
C     WRITE (IPRNT,970) (ITEM(I), I=NPOS1,NPOS2-1)
C     WRITE (IPRNT,960) (KELEM(ITEM(I)), I=NPOS1,NPOS2-1)
      CALL PARORD(ERROR)
      IF(ERROR) THEN
        WRITE(IPRNT, 998)
        RETURN
      ENDIF
      CALL PAREVL
C---- GLOBAL PARAMETERS
C      IF (IPARM1 .GT. 0) THEN
C        WRITE (IPRNT,940)
C        WRITE (IPRNT,950) (I,KPARM(I),IPTYP(I),
C     +     IPDAT(I,1),IPDAT(I,2),IPLIN(I),PDATA(I),I=1,IPARM1)
C      ENDIF
C---- ELEMENT PARAMETERS
C      IF (IPARM2 .LE. MAXPAR) THEN
C        WRITE (IPRNT,990)
C        WRITE (IPRNT,980) (I,KPARM(I),IPTYP(I),
C     +     IPDAT(I,1),IPDAT(I,2),IPLIN(I),PDATA(I),I=IPARM2,MAXPAR)
C      ENDIF
C
C--- SET UNIT FLAG
      KUNITS = KFLAGU
C
      IF (NEWBMO.EQ.1) RETURN
C
      NA = 0
      NPAR = 1
      NMON = 0
      I = 0
      DO 1000 IND=1,IELEM1
        IF(IETYP(IND).LE.0) GO TO 1000
        I = I+1
        IF(NA.GT.MXELMD) THEN
          WRITE(IPRNT,930)
          CALL HALT(7)
        ENDIF
        NAME(I) = KELEM(IND)
        LABEL(I) = KELABL(IND)
        IADR(I) = NPAR
        INMAD = IEDAT(IND,1)
        NA = NA +1
        IF(NPAR.GT.MAXDAT) THEN
          WRITE(IPRNT,931)
          CALL HALT(6)
          RETURN
        ENDIF
        GO TO (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,
     +         16,17,18,19,20,21,22,23,24,25,26,27,
     +         28,29,30) IETYP(IND)
C---DRIFT
    1   ELDAT(NPAR) = PDATA(INMAD)
        ALENG(I) = PDATA(INMAD)
        KODE(I) = 0
        NPAR = NPAR + 1
        GO TO 1000
C---RBEND
    2   CONTINUE
        ELDAT(NPAR) = PDATA(INMAD)
        ELDAT(NPAR+1) = PDATA(INMAD+1)
        ELDAT(NPAR+2) = PDATA(INMAD+2)
        ELDAT(NPAR+3) = PDATA(INMAD+6)
        ELDAT(NPAR+4) = PDATA(INMAD+1)/2.0D0
        ELDAT(NPAR+5) = PDATA(INMAD+7)
        ELDAT(NPAR+6) = PDATA(INMAD+9)
        ELDAT(NPAR+7) = PDATA(INMAD+10)
        ELDAT(NPAR+8) = PDATA(INMAD+1)/2.0D0
        ELDAT(NPAR+9) = PDATA(INMAD+8)
        ELDAT(NPAR+10) = PDATA(INMAD+11)
        ELDAT(NPAR+11) = PDATA(INMAD+12)
        ELDAT(NPAR+12) = PDATA(INMAD+5)
        ALENG(I) = PDATA(INMAD)
        KODE(I) = 1
        NPAR = NPAR + 13
        GO TO 1000
C       WRITE(IPRNT,995)
C---SBEND
    3   ELDAT(NPAR) = PDATA(INMAD)
        ELDAT(NPAR+1) = PDATA(INMAD+1)
        ELDAT(NPAR+2) = PDATA(INMAD+2)
        ELDAT(NPAR+3) = PDATA(INMAD+6)
        ELDAT(NPAR+4) = PDATA(INMAD+3)
        ELDAT(NPAR+5) = PDATA(INMAD+7)
        ELDAT(NPAR+6) = PDATA(INMAD+9)
        ELDAT(NPAR+7) = PDATA(INMAD+10)
        ELDAT(NPAR+8) = PDATA(INMAD+4)
        ELDAT(NPAR+9) = PDATA(INMAD+8)
        ELDAT(NPAR+10) = PDATA(INMAD+11)
        ELDAT(NPAR+11) = PDATA(INMAD+12)
        ELDAT(NPAR+12) = PDATA(INMAD+5)
        ALENG(I) = PDATA(INMAD)
        KODE(I) = 1
        NPAR = NPAR + 13
        GO TO 1000
C---WIGGLER (UNIMPLEMENTED)
    4   CONTINUE
        WRITE(IPRNT,996) PDATA(INMAD)
        ELDAT(NPAR) = PDATA(INMAD)
        ALENG(I) = PDATA(INMAD)
        KODE(I) = 0
        NPAR = NPAR + 1
        GO TO 1000
C---QUADRUPOLE
    5   ELDAT(NPAR) = PDATA(INMAD)
        ELDAT(NPAR+1) = PDATA(INMAD+1)
        ELDAT(NPAR+2) = PDATA(INMAD+3)
        ELDAT(NPAR+3) = PDATA(INMAD+2)
        ALENG(I) = PDATA(INMAD)
        KODE(I) = 2
        NPAR = NPAR + 4
        GO TO 1000
C---SEXTUPOLE
    6   ELDAT(NPAR) = PDATA(INMAD)
        ELDAT(NPAR+1) = PDATA(INMAD+1)
        ELDAT(NPAR+2) = PDATA(INMAD+3)
        ELDAT(NPAR+3) = PDATA(INMAD+2)
        ALENG(I) = PDATA(INMAD)
        KODE(I) = 3
        NPAR = NPAR + 4
        GO TO 1000
C---OCTUPOLE (MAKE IT A MULTIPOLE)
    7   ELDAT(NPAR) = PDATA(INMAD)
        ELDAT(NPAR+1) = 1.
        ELDAT(NPAR+2) = 1.
        ELDAT(NPAR+3) = 4.
        ELDAT(NPAR+4) = PDATA(INMAD+1)
        ELDAT(NPAR+5) = 0.
        ELDAT(NPAR+6) = PDATA(INMAD+3)
        ELDAT(NPAR+7) = PDATA(INMAD+2)
        ALENG(I) = PDATA(INMAD)
        KODE(I) = 5
        NPAR = NPAR + 8
        GO TO 1000
C---MULTIPOLE
    8   ELDAT(NPAR) = PDATA(INMAD)
        ELDAT(NPAR+1) = PDATA(INMAD+43)
        ID = 2
        IO = 1
        NUMOR = 0
        DO 81 IM = 1,41,2
          IF(IPTYP(INMAD+IM).EQ.-1) GO TO 82
          NUMOR = NUMOR + 1
          ELDAT(NPAR+ID+1) = IO
          ELDAT(NPAR+ID+2) = PDATA(INMAD+IM)
          ELDAT(NPAR+ID+3) = PDATA(INMAD+IM+1)
          ID = ID + 3
   82     IO = IO + 1
   81   CONTINUE
        ELDAT(NPAR+2) = NUMOR
        ELDAT(NPAR+ID+1) = PDATA(INMAD+44)
        ELDAT(NPAR+ID+2) = PDATA(INMAD+45)
        ALENG(I) = PDATA(INMAD)
        KODE(I) = 5
        NPAR = NPAR + ID + 3
        GO TO 1000
C---SOLENOID (CAN HAVE QUADRUPOLE COMPONENT)
    9   ELDAT(NPAR) = PDATA(INMAD)
        ELDAT(NPAR+1) = PDATA(INMAD+2)
        ELDAT(NPAR+2) = PDATA(INMAD+1)
        ELDAT(NPAR+3) = PDATA(INMAD+4)
        ELDAT(NPAR+4) = PDATA(INMAD+3)
        ALENG(I) = PDATA(INMAD)
        KODE(I) = 15
        NPAR = NPAR + 5
        GO TO 1000
C---CAVITY
   10   ELDAT(NPAR) = PDATA(INMAD)
        ELDAT(NPAR+1) = PDATA(INMAD+4)
        ELDAT(NPAR+2) = PDATA(INMAD+1)
        ELDAT(NPAR+3) = PDATA(INMAD+3)
        ELDAT(NPAR+4) = PDATA(INMAD+2)
        ALENG(I) = PDATA(INMAD)
        KODE(I) = 7
        NPAR = NPAR + 5
        GO TO 1000
C---SEPARATOR (UNIMPLEMENTED)
   11   CONTINUE
        WRITE(IPRNT,997) PDATA(INMAD)
        ELDAT(NPAR) = PDATA(INMAD)
        ALENG(I) = PDATA(INMAD)
        KODE(I) = 0
        NPAR = NPAR + 1
        GO TO 1000
C----ROLL, GKICK IN DIMAT
   12   ELDAT(NPAR) = 0.
        ELDAT(NPAR+1) = 0.
        ELDAT(NPAR+2) = 0.
        ELDAT(NPAR+3) = 0.
        ELDAT(NPAR+4) = 0.
        ELDAT(NPAR+5) = 0.
        ELDAT(NPAR+6) = 0.
        ELDAT(NPAR+7) = PDATA(INMAD)
        ELDAT(NPAR+8) = 0.
        ELDAT(NPAR+9) = 1.
        ELDAT(NPAR+10) = 0.
        ALENG(I) = 0.
        KODE(I) = 8
        NPAR = NPAR + 11
        GO TO 1000
C---ZROT, GKICK IN DIMAT
   13   ELDAT(NPAR) = 0.
        ELDAT(NPAR+1) = 0.
        ELDAT(NPAR+2) = PDATA(INMAD)
        ELDAT(NPAR+3) = 0.
        ELDAT(NPAR+4) = 0.
        ELDAT(NPAR+5) = 0.
        ELDAT(NPAR+6) = 0.
        ELDAT(NPAR+7) = 0.
        ELDAT(NPAR+8) = 0.
        ELDAT(NPAR+9) = 1.
        ELDAT(NPAR+10) = 0.
        ALENG(I) = 0.
        KODE(I) = 8
        NPAR = NPAR + 11
        GO TO 1000
C---HKICK
   14   ELDAT(NPAR) = PDATA(INMAD)
        ELDAT(NPAR+1) = 0.
        ELDAT(NPAR+2) = PDATA(INMAD+1)*DCOS(PDATA(INMAD+2))
        ELDAT(NPAR+3) = 0.
        ELDAT(NPAR+4) = PDATA(INMAD+1)*DSIN(PDATA(INMAD+2))
        ELDAT(NPAR+5) = 0.
        ELDAT(NPAR+6) = 0.
        ELDAT(NPAR+7) = 0.
        ELDAT(NPAR+8) = 0.
        ELDAT(NPAR+9) = 1.
        ELDAT(NPAR+10) = 0.
        ALENG(I) = PDATA(INMAD)
        KODE(I) = 8
        NPAR = NPAR + 11
        GO TO 1000
C---VKICK
   15   ELDAT(NPAR) = PDATA(INMAD)
        ELDAT(NPAR+1) = 0.
        ELDAT(NPAR+2) = -PDATA(INMAD+1)*DSIN(PDATA(INMAD+2))
        ELDAT(NPAR+3) = 0.
        ELDAT(NPAR+4) = PDATA(INMAD+1)*DCOS(PDATA(INMAD+2))
        ELDAT(NPAR+5) = 0.
        ELDAT(NPAR+6) = 0.
        ELDAT(NPAR+7) = 0.
        ELDAT(NPAR+8) = 0.
        ELDAT(NPAR+9) = 1.
        ELDAT(NPAR+10) = 0.
        ALENG(I) = PDATA(INMAD)
        KODE(I) = 8
        NPAR = NPAR + 11
        GO TO 1000
C---HMONITOR, VMONITOR, MONITOR
   16   CONTINUE
   17   CONTINUE
   18   CONTINUE
        DO 161 IE = 1,5
          ELDAT(NPAR+IE-1) = PDATA(INMAD+IE-1)
  161   CONTINUE
        ELDAT(NPAR+5) = IETYP(IND) - 15
        ALENG(I) = PDATA(INMAD)
        KODE(I) = 13
        NPAR = NPAR + 6
        GO TO 1000
C---MARKER (DRIFT OF LENGTH 0 FOR NOW)
   19   ELDAT(NPAR) = 0.
        ALENG(I) = 0.
        KODE(I) = 0
        NPAR=NPAR+1
        GO TO 1000
C--- ECOLLIMATOR, RCOLLIMATOR
   20   CONTINUE
   21   ELDAT(NPAR) = PDATA(INMAD)
        ELDAT(NPAR+1) = PDATA(INMAD+1)
        ELDAT(NPAR+2) = PDATA(INMAD+2)
        IF (IETYP(IND).EQ.20) THEN
          ELDAT(NPAR+3) = 2
        ELSE
          ELDAT(NPAR+3) = 1
        ENDIF
        ALENG(I) = PDATA(INMAD)
        KODE(I) = 6
        NPAR = NPAR + 4
        GO TO 1000
C---QUADRUPOLE-SEXTUPOLE
   22   ELDAT(NPAR) = PDATA(INMAD)
        ELDAT(NPAR+1) = PDATA(INMAD+1)
        ELDAT(NPAR+2) = PDATA(INMAD+2)
        ELDAT(NPAR+3) = PDATA(INMAD+4)
        ELDAT(NPAR+4) = PDATA(INMAD+3)
        ALENG(I) = PDATA(INMAD)
        KODE(I) = 4
        NPAR = NPAR + 5
        GO TO 1000
C---GENERAL KICK
   23   CONTINUE
        DO 231 IE=1,11
        ELDAT(NPAR+IE-1) = PDATA(INMAD+IE-1)
  231   CONTINUE
        IF(ELDAT(NPAR+9).EQ.0) ELDAT(NPAR+9) = 1
        ALENG(I) = PDATA(INMAD)
        KODE(I) = 8
        NPAR = NPAR + 11
        GO TO 1000
C---ARBITRARY ELEMENT
  24    CONTINUE
        DO 241 IE=1,21
          ELDAT(NPAR+IE-1) = PDATA(INMAD+IE-1)
 241    CONTINUE
        ALENG(I) = PDATA(INMAD)
        KODE(I) = 12
        NPAR = NPAR + 21
        GO TO 1000
C---TWISS ELEMENT
  25    CONTINUE
        DO 251 IE = 1,7
          ELDAT(NPAR+IE-1) = PDATA(INMAD+IE-1)
 251    CONTINUE
        ALENG(I) = PDATA(INMAD)
        KODE(I) = 9
        NPAR = NPAR + 7
        GO TO 1000
C---GENERAL MATRIX ELEMENT
  26    CONTINUE
        ELDAT(NPAR) = PDATA(INMAD)
        ID = 1
        DO 261 IE=1,162
        IF(PDATA(INMAD+IE).EQ.0.0) GO TO 261
        ELDAT(NPAR+ID) = ITRANS(IE)
        ID = ID+1
        ELDAT(NPAR+ID) = PDATA(INMAD+IE)
        ID = ID+1
 261    CONTINUE
        ALENG(I) = PDATA(INMAD)
        KODE(I) = 10
        NPAR = NPAR + ID
        GO TO 1000
C---LINAC CAVITY
   27   CONTINUE
        ELDAT(NPAR) = PDATA(INMAD)
        ELDAT(NPAR+1) = PDATA(INMAD+1)
        ELDAT(NPAR+2) = PDATA(INMAD+2)
        ELDAT(NPAR+3) = PDATA(INMAD+3)
        ELDAT(NPAR+4) = PDATA(INMAD+4)
        ELDAT(NPAR+5) = PDATA(INMAD+5)
        ELDAT(NPAR+6) = PDATA(INMAD+6)
        ALENG(I) = PDATA(INMAD)
        KODE(I) = 17
        NPAR = NPAR + 7
        GO TO 1000
C---HV collimators (absorbers)
   28   CONTINUE
        ELDAT(NPAR) = PDATA(INMAD)
        ELDAT(NPAR+1) = PDATA(INMAD+1)
        ELDAT(NPAR+2) = PDATA(INMAD+2)
        ELDAT(NPAR+4) = PDATA(INMAD+3)
        ELDAT(NPAR+4) = PDATA(INMAD+4)
        ELDAT(NPAR+5) = PDATA(INMAD+5)
        ELDAT(NPAR+6) = PDATA(INMAD+6)
        ELDAT(NPAR+7) = PDATA(INMAD+7)
        ELDAT(NPAR+8) = PDATA(INMAD+8)
        ELDAT(NPAR+9) = PDATA(INMAD+9)
        ELDAT(NPAR+10) = PDATA(INMAD+10)
        ELDAT(NPAR+11) = PDATA(INMAD+11)
        ELDAT(NPAR+12) = PDATA(INMAD+12)
        ELDAT(NPAR+13) = PDATA(INMAD+13)
        ELDAT(NPAR+14) = PDATA(INMAD+14)
        ALENG(I) = PDATA(INMAD)
        KODE(I) = 18
        NPAR = NPAR + 15
        GO TO 1000
C---quadac element : quadrupole imbedded in a linac cavity
   29   CONTINUE
        ELDAT(NPAR) = PDATA(INMAD)
        ELDAT(NPAR+1) = PDATA(INMAD+1)
        ELDAT(NPAR+2) = PDATA(INMAD+2)
        ELDAT(NPAR+3) = PDATA(INMAD+3)
        ELDAT(NPAR+4) = PDATA(INMAD+4)
        ELDAT(NPAR+5) = PDATA(INMAD+5)
        ELDAT(NPAR+6) = PDATA(INMAD+7)
        ELDAT(NPAR+7) = PDATA(INMAD+6)
        ALENG(I) = PDATA(INMAD)
        KODE(I) = 19
        NPAR = NPAR + 8
        GO TO 1000
C---cebcav element : cebaf cavities as requested by D.Douglas
   30   CONTINUE
        ELDAT(NPAR) = PDATA(INMAD)
        ELDAT(NPAR+1) = PDATA(INMAD+1)
        ELDAT(NPAR+2) = PDATA(INMAD+2)
        ELDAT(NPAR+3) = PDATA(INMAD+3)
c
c modified 08.04.2015 to change cavity model
c
        eldat(npar+4) = pdata(inmad+4)
        eldat(npar+5) = pdata(inmad+5)
c
        ALENG(I) = PDATA(INMAD)
        KODE(I) = 20
c
c modified 08.08.2014 to capture changes to cavity model from 08.04.2015
c
c        NPAR = NPAR + 4
        NPAR = NPAR + 6
 1000 CONTINUE
        IF(NPAR.GT.MAXDAT) THEN
          WRITE(IPRNT,931)
          CALL HALT(6)
        ENDIF
      IADR(NA+1) = NPAR
C-----------------------------------------------------------------------
  900 FORMAT(' '/'1LIST OF ELEMENTS IN THE MACHINE AND KODE')
  901 FORMAT(' ',10F7.3,/' ',1X,10F7.3,/' ',1X,10F7.3,
     +           /' ',1X,10F7.3,/' ',1X,10F7.3,/' ',1X,10F7.3,
     +           /' ',1X,10F7.3,/' ',1X,10F7.3,/' ',1X,10F7.3,
     +           /' ',1X,10F7.3,/' ',1X,10F7.3,/' ',1X,10F7.3,
     +           /' ',1X,10F7.3,/' ',1X,10F7.3,/' ',1X,10F7.3,
     +           /' ',1X,10F7.3,/' ',1X,10F7.3,/' ',1X,10F7.3,
     +           /' ',1X,10F7.3,/' ',1X,10F7.3,/' ',1X,10F7.3,
     +           /' ',1X,10F7.3,/' ',1X,10F7.3,/' ',1X,10F7.3,
     +           /' ',1X,10F7.3,/' ',1X,10F7.3,/' ',1X,10F7.3,
     +           /' ',1X,10F7.3,/' ',1X,10F7.3,/' ',1X,10F7.3,
     +           /' ',1X,10F7.3,/' ',1X,10F7.3,/' ',1X,10F7.3)
  902 FORMAT(' ',I6,4X,A8,I8)
  910 FORMAT(' '/' LIST OF DEFINED ELEMENT TYPES  NAME, KODE, IADR',
     +            ' AND PARAMETERS')
  911 FORMAT(' ', A8, I8, I8)
  912 FORMAT(' '/' LIST OF MONITORS AND POSITIONS')
  913 FORMAT(' ', A8, I8)
  920 FORMAT(' ',I5,' ELEMENTS, TOO MANY FOR DIMAT (>MAXPOS),QUIT')
  930 FORMAT(' TOO MANY DISTINCT ELEMENT TYPES FOR DIMAT,>MXELMD QUIT')
  931 FORMAT(' NOT ENOUGH PARAMETER SPACE FOR DIMAT,>MAXDAT QUIT')
  940 FORMAT('1DUMP OF PARAMETER TABLE (1)')
  950 FORMAT(' ',I10,5X,A8,4I8,F15.6)
  960 FORMAT(' ',8A8)
  970 FORMAT(' ',8I8)
  980 FORMAT(' ',I10,5X,A8,4I8,F15.6)
  990 FORMAT('1DUMP OF PARAMETER TABLE (2)')
  995 FORMAT(' NO RBEND IN DIMAT, TREATED AS AN SBEND')
  996 FORMAT(' NO WIGGLER IN DIMAT, TREATED LIKE A DRIFT OF LENGTH ',
     +        F10.4)
  997 FORMAT(' NO SEPARATOR IN DIMAT, TREATED LIKE A DRIFT OF LENGTH ',
     +        F10.4)
  998 FORMAT(' ERROR FROM PARORD, RETURNING FROM DIMATD')
      RETURN
      END
      SUBROUTINE DIMPAR(NELID, ICHAR, IDICT)
C---- GET PARAMETER NUMBER FROM NAME AND KODE FOR DIMAT
C------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
      CHARACTER*8       ICHAR
      PARAMETER         (MXELMD = 3000)
      PARAMETER         (MAXELM = 5000)
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(MXELMD),LABEL(MXELMD)
      CHARACTER*8 NAME
      CHARACTER*14 LABEL
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- ELEMENT TABLE
      COMMON /ELMNAM/   KELEM(MAXELM),KETYP(MAXELM),KELABL(MAXELM)
      CHARACTER*8       KELEM,KELABL*14
      CHARACTER*4       KETYP
      COMMON /ELMDAT/   IELEM1,IELEM2,IETYP(MAXELM),IEDAT(MAXELM,3),
     +                  IELIN(MAXELM)
C-----------------------------------------------------------------
      PARAMETER         (NKEYW = 30)
      PARAMETER         (NDRFT =  1)
      PARAMETER         (NBEND = 13)
      PARAMETER         (NQUAD =  4)
      PARAMETER         (NSEXT =  4)
      PARAMETER         (NOCT  =  4)
      PARAMETER         (NMULT = 46)
      PARAMETER         (NSOLO =  5)
      PARAMETER         (NCVTY =  5)
      PARAMETER         (NLCAV =  7)
      PARAMETER         (NROTA =  1)
      PARAMETER         (NKICK =  3)
      PARAMETER         (NMON  =  5)
      PARAMETER         (NCOLL =  3)
      PARAMETER         (NQUSE =  5)
      PARAMETER         (NGKIK = 11)
      PARAMETER         (NARBI = 21)
      PARAMETER         (NTWIS =  7)
      PARAMETER         (NMATR =163)
      PARAMETER         (Nhcol = 15)
      PARAMETER         (Nquadac =  8)
c  modified 08.04.2015 to update cavity model
c      PARAMETER         (Ncebcav =  4)
c
      PARAMETER         (Ncebcav =  6)
c
      PARAMETER         (PI = 3.1415926535898D0)
C-----------------------------------------------------------------------
      CHARACTER*8       DDRFT(NDRFT)
      CHARACTER*8       DBEND(NBEND)
      CHARACTER*8       DQUAD(NQUAD)
      CHARACTER*8       DSEXT(NSEXT)
      CHARACTER*8       DOCT (NOCT )
      CHARACTER*8       DMULT(NMULT)
      CHARACTER*8       DSOLO(NSOLO)
      CHARACTER*8       DCVTY(NCVTY)
      CHARACTER*8       DLCAV(NLCAV)
      CHARACTER*8       DROTA(NROTA)
      CHARACTER*8       DKICK(NKICK)
      CHARACTER*8       DMON (NMON)
      CHARACTER*8       DCOLL(NCOLL)
      CHARACTER*8       DQUSE(NQUSE)
      CHARACTER*8       DGKIK(NGKIK)
      CHARACTER*8       DARBI(NARBI)
      CHARACTER*8       DTWIS(NTWIS)
      CHARACTER*8       DMATR(NMATR)
      CHARACTER*8       Dhcol(nhcol)
      CHARACTER*8       Dquadac(nquadac)
      CHARACTER*8       Dcebcav(ncebcav)
C-----------------------------------------------------------------------
      DATA DDRFT( 1)
     +   / 'L       ' /
      DATA DBEND
     +   / 'L       ','ANGLE   ','K1      ','K2      ','E1      ',
     +     'H1      ','HGAP    ','FINT    ','E2      ','H2      ',
     +     'HGAPX   ','FINTX   ','TILT    '/
      DATA DQUAD
     +   / 'L       ','K1      ','APERTURE','TILT    '/
      DATA DSEXT
     +   / 'L       ','K2      ','APERTURE','TILT    '/
      DATA DOCT
     +   / 'L       ','K3      ','APERTURE','TILT    '/
      DATA DMULT
     +   / 'L       ','K0      ','T0      ','K1      ','T1      ',
     +     'K2      ','T2      ','K3      ','T3      ','K4      ',
     +     'T4      ','K5      ','T5      ','K6      ','T6      ',
     +     'K7      ','T7      ','K8      ','T8      ','K9      ',
     +     'T9      ','K10     ','T10     ','K11     ','T11     ',
     +     'K12     ','T12     ','K13     ','T13     ','K14     ',
     +     'T14     ','K15     ','T15     ','K16     ','T16     ',
     +     'K17     ','T17     ','K18     ','T18     ','K19     ',
     +     'T19     ','K20     ','T20     ','SCALEFAC','APERTURE',
     +     'TILT    ' /
      DATA DSOLO
     +   / 'L       ','K1      ','KS      ','APERTURE','TILT    '/
      DATA DROTA
     +   / 'ANGLE   ' /
      DATA DKICK
     +   / 'L       ','KICK    ','TILT    ' /
      DATA DCVTY
     +   / 'L       ','ENERGY  ','VOLT    ','FREQ    ','LAG    ' /
      DATA DLCAV
     +   / 'L       ','E0      ','DELTAE  ','PHI0    ','FREQ   ',
     +     'KICKCOEF','T       ' /
      DATA DMON
     +   / 'L       ','XSERR   ','YSERR   ','XRERR   ','YRERR  '/
      DATA DCOLL
     +   / 'L       ','XSIZE   ','ZSIZE   ' /
      DATA DQUSE
     +   / 'L       ','K1      ','K2      ','APERTURE','TILT    '/
      DATA DGKIK
     +   / 'L       ','DX      ','DXP     ','DY      ','DYP     ',
     +     'DL      ','DP      ','ANGLE   ','DZ      ','V       ',
     +     'T       ' /
      DATA DARBI
     +   / 'L       ','P1      ','P2      ','P3      ','P4      ',
     +     'P5      ','P6      ','P7      ','P8      ','P9      ',
     +     'P10     ','P11     ','P12     ','P13     ','P14     ',
     +     'P15     ','P16     ','P17     ','P18     ','P19     ',
     +     'P20     ' /
      DATA DTWIS
     +   / 'L       ','MUX     ','BETAX   ','ALPHAX  ','MUY     ',
     +     'BETAY   ','ALPHAY  ' /
      DATA DMATR /
     +'L   ','R11','R12','R13','R14','R15','R16','T111','T112',
     +'T113','T114','T115','T116','T122','T123','T124','T125','T126',
     +'T133','T134','T135','T136','T144','T145','T146','T155','T156',
     +'T166','R21','R22','R23','R24','R25','R26','T211','T212',
     +'T213','T214','T215','T216','T222','T223','T224','T225','T226',
     +'T233','T234','T235','T236','T244','T245','T246','T255','T256',
     +'T266','R31','R32','R33','R34','R35','R36','T311','T312',
     +'T313','T314','T315','T316','T322','T323','T324','T325','T326',
     +'T333','T334','T335','T336',
     +'T344','T345','T346','T355','T356','T366','R41','R42','R43',
     +'R44','R45','R46','T411','T412','T413','T414','T415','T416',
     +'T422','T423','T424','T425','T426','T433','T434','T435','T436',
     +'T444','T445','T446','T455','T456','T466','R51','R52','R53',
     +'R54','R55','R56','T511','T512','T513','T514','T515','T516',
     +'T522','T523','T524','T525','T526','T533','T534','T535','T536',
     +'T544','T545','T546','T555','T556','T566','R61','R62','R63',
     +'R64','R65','R66','T611','T612','T613','T614','T615','T616',
     +'T622','T623','T624','T625','T626','T633','T634','T635','T636',
     +'T644','T645','T646','T655','T656','T666' /
      DATA Dhcol
     +   / 'L       ','LCOORD  ','RCOORD  ','LSLOPE  ','RSLOPE  ',
     +     'XMAX    ','A       ','Z       ','DENSITY ','IONIZATI',
     +     'ENERGY  ','DENERGY ','MU      ','DISTRIBU','INELASTI' /
      DATA Dquadac
     +   / 'L       ','K1      ','DELTAE  ','PHI0    ','FREQ    ',
     +     'E0      ','TILT    ','APERTURE'/
c      DATA Dcebcav
c     +   / 'L       ','EN0     ','DELTAE  ','PHI0    '/
c
c modified for (2n+1)*pi/2 mode linear model 08.04.2015
c   L is #cells NCELL*RFLAMBDA/2, so NCELL defines RFLAMBDA
c   this version of code reads in NCELL and NSTEP (number of integration
c      steps
c
      DATA Dcebcav
     +   / 'L       ','EN0     ','DELTAE  ','PHI0    ','NCELL   ',
     +     'NSTEP   '/
c
c
      IKODE = KODE(NELID)
      GO TO (10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130,
     +       140, 150, 160,170,180,190,200,210) IKODE+1
C     DRIFT
 10   CONTINUE
      CALL RDLOOK(ICHAR, 4, DDRFT, 1, NDRFT, IDICT)
      IF (IDICT.EQ.0) GO TO 999
      RETURN
C     BEND
 20   CONTINUE
      CALL RDLOOK(ICHAR, 8, DBEND, 1, NBEND, IDICT)
      IF (IDICT.EQ.0) GO TO 999
      IF (IDICT.EQ.7 .OR. IDICT.EQ.8) THEN
        WRITE(IPRNT, 997)
      ENDIF
      RETURN
C     QUAD
 30   CONTINUE
      CALL RDLOOK(ICHAR, 8, DQUAD, 1, NQUAD, IDICT)
      IF (IDICT.EQ.0) GO TO 999
      RETURN
C     SEXTUPOLE
 40   CALL RDLOOK(ICHAR, 8, DSEXT, 1, NQUAD, IDICT)
      IF (IDICT.EQ.0) GO TO 999
      RETURN
C     QUADRUPOLE/SEXTUPOLE
 50   CALL RDLOOK(ICHAR, 8, DQUSE, 1, NQUSE, IDICT)
      IF (IDICT.EQ.0) GO TO 999
      RETURN
C     MULTIPOLE
 60   CONTINUE
C      LOOK AT ORIGINAL MAD DATA STRUCTURES TO FIND ELEMENT TYPE
      CALL RDLOOK(NAME(NELID), 8, KELEM, 1, MAXELM, IDELM)
      IF (IDELM.EQ.0) THEN
        WRITE(IPRNT,888) NELID, NAME(NELID)
        GO TO 999
      ENDIF
      IDENT = IETYP(IDELM)
      IF (IDENT.EQ.8) THEN
        CALL RDLOOK(ICHAR, 8, DMULT, 1, NMULT, ID)
        IF (ID.EQ.0) GO TO 999
        IF (ID.EQ.1) IDICT = 1
        IF (ID.EQ.44) IDICT = 2
        IF (ID.GE.2 .AND. ID.LE.43) THEN
          INDEX = IADR(NELID)
          NP = ELDAT(INDEX + 2)
          DO 111 NUM = 1,NP
            NPOL = ELDAT(INDEX + NUM*3)
            IF(ID.EQ.NPOL*2)  IDICT = NUM*3 + 2
            IF(ID.EQ.NPOL*2+1) IDICT = NUM*3 + 3
 111      CONTINUE
        ENDIF
C---- APERTURE
        IF(ID.EQ.45) THEN
          INDEX = IADR(NELID)
          NP = ELDAT(INDEX + 2)
          IDICT = 3*NP + 4
        ENDIF
C---- TILT
        IF(ID.EQ.46) THEN
          INDEX = IADR(NELID)
          NP = ELDAT(INDEX+2)
          IDICT = 3*NP + 5
        ENDIF
      ELSE IF (IDENT.EQ.7) THEN
        CALL RDLOOK(ICHAR, 8, DOCT, 1, NOCT, ID)
        IF (ID.EQ.0) GO TO 999
        IF (ID.EQ.1) IDICT = 1
        IF (ID.EQ.2) IDICT = 5
        IF (ID.EQ.3) IDICT = 7
        IF (ID.EQ.4) IDICT = 6
      ENDIF
      RETURN
C     COLLIMATOR
 70   CONTINUE
      CALL RDLOOK(ICHAR, 8, DCOLL, 1, NCOLL, IDICT)
      IF (IDICT.EQ.0) GO TO 999
      RETURN
C     RFCAVITY
 80   CONTINUE
      CALL RDLOOK(ICHAR, 8, DCVTY, 1, NCVTY, IDICT)
      IF (IDICT.EQ.0) GO TO 999
      RETURN
C     KICK
 90   CONTINUE
C      LOOK AT ORIGINAL MAD DATA STRUCTURES TO FIND ELEMENT TYPE
      CALL RDLOOK(NAME(NELID), 8, KELEM, 1, MAXELM, IDELM)
      IF (IDELM.EQ.0) THEN
        WRITE(IPRNT,888) NELID, NAME(NELID)
        GO TO 999
      ENDIF
      IDENT = IETYP(IDELM)
      IF (IDENT.EQ.12) THEN
        CALL RDLOOK(ICHAR, 8, DROTA, 1, NROTA, ID)
        IF (ID.EQ.0) GO TO 999
        IDICT = 8
      ELSE IF (IDENT.EQ.13) THEN
        CALL RDLOOK(ICHAR, 8, DROTA, 1, NROTA, ID)
        IF (ID.EQ.0) GO TO 999
        IDICT = 3
      ELSE IF (IDENT.EQ.14 .OR. IDENT.EQ.15) THEN
        CALL RDLOOK(ICHAR, 8, DKICK, 1, NKICK, IDICT)
        IF (IDICT.EQ.0) THEN
          WRITE(IPRNT,9)ICHAR
          WRITE(IPRNT, 998)
          CALL HALT(241)
          return
        ENDIF
        IF (IDICT.EQ.2) THEN
          WRITE(IPRNT, 998)
          CALL HALT(241)
          return
        ENDIF
        RETURN
      ELSE IF (IDENT.EQ.23) THEN
         CALL RDLOOK(ICHAR, 8, DGKIK, 1, NGKIK, IDICT)
         IF (IDICT.EQ.0) GO TO 999
      ENDIF
      RETURN
C     TWISS
100   CONTINUE
      CALL RDLOOK(ICHAR, 8, DTWIS, 1, NTWIS, IDICT)
      IF (IDICT.EQ.0) GO TO 999
      RETURN
C     GENERAL MATRIX
110   CONTINUE
      CALL RDLOOK(ICHAR, 4, DMATR, 1, NMATR, ID)
      IF (ID.EQ.0) GO TO 999
      INDEX = IADR(NELID)
      IENDEX = IADR(NELID+1)
      IF(ID.EQ.1) THEN
        IDICT = 1
        RETURN
      ELSE IF ((ID.GE.2  .AND. ID.LE.7 )
     +    .OR. (ID.GE.29 .AND. ID.LE.34)
     +    .OR. (ID.GE.56 .AND. ID.LE.61)
     +    .OR. (ID.GE.83 .AND. ID.LE.88)
     +    .OR. (ID.GE.110.AND. ID.LE.115)
     +    .OR. (ID.GE.137.AND. ID.LE.142)) THEN
        DO 112 IN = INDEX+1, IENDEX-1, 2
          IVAL = ELDAT(IN)
          IF(MOD(IVAL,10).NE.0) GO TO 112
          NVAL = ID - 17*(IVAL/100) + 26
          NVAL = NVAL*10
          IF(IVAL.EQ.NVAL) THEN
            IDICT = IN - INDEX + 2
            RETURN
          ENDIF
112     CONTINUE
      ELSE
        DO 113 IN = INDEX+1, IENDEX-1, 2
          IVAL = ELDAT(IN)
          IF(MOD(IVAL,10).EQ.0) GO TO 113
          NVAL = ID + 73*(IVAL/100) + 30
          IF(MOD(IVAL,100).GT.20) NVAL = NVAL + 5
          IF(MOD(IVAL,100).GT.30) NVAL = NVAL + 6
          IF(MOD(IVAL,100).GT.40) NVAL = NVAL + 7
          IF(MOD(IVAL,100).GT.50) NVAL = NVAL + 8
          IF(MOD(IVAL,100).GT.60) NVAL = NVAL + 9
          IF(IVAL.EQ.NVAL) THEN
            IDICT = IN - INDEX + 2
            RETURN
          ENDIF
113     CONTINUE
      ENDIF
      GO TO 999
C     NO CODE 11
120   CONTINUE
      WRITE(IPRNT,99) IKODE
      RETURN
C     ARBITRARY ELEMENT
130   CONTINUE
      CALL RDLOOK(ICHAR, 8, DARBI, 1, NARBI, IDICT)
      IF (IDICT.EQ.0) GO TO 999
      RETURN
C     MONITOR
140   CONTINUE
      CALL RDLOOK(ICHAR, 8, DMON, 1, NMON, IDICT)
      IF (IDICT.EQ.0) GO TO 999
      RETURN
C     NO CODE 14
150   CONTINUE
      WRITE(IPRNT,99) IKODE
      RETURN
C     SOLENOID
160   CONTINUE
      CALL RDLOOK(ICHAR, 8, DSOLO, 1, NSOLO, IDICT)
      IF(IDICT.EQ.0) GO TO 999
      RETURN
C     NO CODE 16
170   CONTINUE
      WRITE(IPRNT,99) IKODE
      GO TO 999
C     LINAC CAVITY
180   CONTINUE
      CALL RDLOOK(ICHAR,8,DLCAV,1,NLCAV,IDICT)
      IF(IDICT.EQ.0) GO TO 999
      RETURN
C     hvcollimator : absorbers
190   CONTINUE
      CALL RDLOOK(ICHAR,8,Dhcol,1,Nhcol,IDICT)
      IF(IDICT.EQ.0) GO TO 999
      RETURN
C     quadac element
200   continue
      CALL RDLOOK(ICHAR,8,Dquadac,1,Nquadac,IDICT)
      IF(IDICT.EQ.0) GO TO 999
      RETURN
C     quadac element
210   continue
      CALL RDLOOK(ICHAR,8,Dcebcav,1,Ncebcav,IDICT)
      IF(IDICT.EQ.0) GO TO 999
      RETURN
C     ERROR
999   CONTINUE
      WRITE(IPRNT,9) ICHAR
1000  CONTINUE
      CALL HALT(240)
      return
9     FORMAT(' NO SUCH PARAMETER NAME, ', A8,/)
99    FORMAT(' NO ELEMENT WITH KODE = ',I4,' IN DIMAT',/)
998   FORMAT(' CANT VARY KICK PARAMETER, USE A GKICK',/)
997   FORMAT(' MAKE SURE YOU ALSO VARY HGAPX OR FINTX!'/)
888   FORMAT(' COULDNT FIND ELEMENT IN MAD DATA STRUCTURE', I5, A8,/)
      END
      SUBROUTINE DMINV(A,N,D,L,M)
C     ***********************
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      DIMENSION A(N*N),L(N),M(N)
      DOUBLE PRECISION A,D,BIGA,HOLD
      D=1.0D0
      NK=-N
      DO80 K=1,N
      NK=NK+N
      L(K)=K
      M(K)=K
      KK=NK+K
      BIGA=A(KK)
      DO20 J=K,N
      IZ=N*(J-1)
      DO 20 I=K,N
      IJ=IZ+I
   10 IF(DABS(BIGA)-DABS(A(IJ))) 15,20,20
   15 BIGA=A(IJ)
      L(K)=I
      M(K)=J
   20 CONTINUE
      J=L(K)
      IF(J-K) 35,35,25
   25 KI=K-N
      DO 30 I=1,N
      KI=KI+N
      HOLD=-A(KI)
      JI=KI-K+J
      A(KI)=A(JI)
   30 A(JI) =HOLD
   35 I=M(K)
      IF(I-K) 45,45,38
   38 JP=N*(I-1)
      DO40 J=1,N
      JK=NK+J
      JI=JP+J
      HOLD=-A(JK)
      A(JK)=A(JI)
   40 A(JI) =HOLD
   45 IF(BIGA) 48,46,48
   46 D=0.0D0
      RETURN
   48 DO55 I=1,N
      IF(I-K) 50,55,50
   50 IK=NK+I
      A(IK)=A(IK)/(-BIGA)
   55 CONTINUE
      DO 65 I=1,N
      IK=NK+I
      HOLD=A(IK)
      IJ=I-N
      DO 65 J=1,N
      IJ=IJ+N
      IF(I-K) 60,65,60
   60 IF(J-K) 62,65,62
   62 KJ=IJ-I+K
      A(IJ)=HOLD*A(KJ)+A(IJ)
   65 CONTINUE
      KJ=K-N
      DO 75 J=1,N
      KJ=KJ+N
      IF(J-K) 70,75,70
   70 A(KJ)=A(KJ)/BIGA
   75 CONTINUE
      D=D*BIGA
      A(KK)=1.0D0/BIGA
   80 CONTINUE
      K=N
  100 K=(K-1)
      IF(K) 150,150,105
  105 I=L(K)
      IF(I-K) 120,120,108
  108 JQ=N*(K-1)
      JR=N*(I-1)
      DO 110 J=1,N
      JK=JQ+J
      HOLD=A(JK)
      JI=JR+J
      A(JK)=-A(JI)
  110 A(JI) =HOLD
  120 J=M(K)
      IF(J-K) 100,100,125
  125 KI=K-N
      DO 130 I=1,N
      KI=KI+N
      HOLD=A(KI)
      JI=KI-K+J
      A(KI)=-A(JI)
  130 A(JI) =HOLD
      GO TO 100
  150 RETURN
      END
      SUBROUTINE DRIFT(ielm,matadr)
C     ************************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/PRODCT/KODEPR,NEL,NOF
      IAD=IADR(ielm)
      AL=ELDAT(IAD)
      DO 100 I=1,6
      DO 100 J=1,27
      AMAT(J,I,matadr)=0.0D0
      IF(I.EQ.J) AMAT(J,I,matadr)=1.0D0
  100 CONTINUE
      AMAT(2,1,matadr)=AL
      AMAT(4,3,matadr)=AL
      AMAT(13,5,matadr)=AL/2.0D0
      AMAT(22,5,matadr)=AL/2.0D0
      RETURN
      END
      SUBROUTINE DSIMQ(A,B,N,KS)
C     ***********************
      IMPLICIT REAL*8 (A-H,O-Z)
      DIMENSION A(N*N),B(N)
C
C        FORWARD SOLUTION
C
      TOL=0.0
      KS=0
      JJ=-N
      DO 65 J=1,N
      JY=J+1
      JJ=JJ+N+1
      BIGA=0
      IT=JJ-J
      DO 30 I=J,N
C
C        SEARCH FOR MAXIMUM COEFFICIENT IN COLUMN
C
      IJ=IT+I
      IF(DABS(BIGA)-DABS(A(IJ))) 20,30,30
   20 BIGA=A(IJ)
      IMAX=I
   30 CONTINUE
C
C        TEST FOR PIVOT LESS THAN TOLERANCE (SINGULAR MATRIX)
C
      IF(DABS(BIGA)-TOL) 35,35,40
   35 KS=1
      RETURN
C
C        INTERCHANGE ROWS IF NECESSARY
C
   40 I1=J+N*(J-2)
      IT=IMAX-J
      DO 50 K=J,N
      I1=I1+N
      I2=I1+IT
      SAVE=A(I1)
      A(I1)=A(I2)
      A(I2)=SAVE
C
C        DIVIDE EQUATION BY LEADING COEFFICIENT
C
   50 A(I1)=A(I1)/BIGA
      SAVE=B(IMAX)
      B(IMAX)=B(J)
      B(J)=SAVE/BIGA
C
C        ELIMINATE NEXT VARIABLE
C
      IF(J-N) 55,70,55
   55 IQS=N*(J-1)
      DO 65 IX=JY,N
      IXJ=IQS+IX
      IT=J-IX
      DO 60 JX=JY,N
      IXJX=N*(JX-1)+IX
      JJX=IXJX+IT
   60 A(IXJX)=A(IXJX)-(A(IXJ)*A(JJX))
   65 B(IX)=B(IX)-(B(J)*A(IXJ))
C
C        BACK SOLUTION
C
   70 NY=N-1
      IT=N*N
      DO 80 J=1,NY
      IA=IT-J
      IB=N-J
      IC=N
      DO 80 K=1,J
      B(IB)=B(IB)-A(IA)*B(IC)
      IA=IA-N
   80 IC=IC-1
      RETURN
      END
      SUBROUTINE DUMP
C---- DECODE "DUMP" COMMAND
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
C-----------------------------------------------------------------------
      CALL RDFIND(';')
      CALL DUMPEX
      RETURN
C-----------------------------------------------------------------------
      END
      SUBROUTINE DUMPEX
C---- EXECUTE "DUMP" COMMAND
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
C-----------------------------------------------------------------------
C---- ELEMENT TABLE
      PARAMETER         (MAXELM = 5000)
      COMMON /ELMNAM/   KELEM(MAXELM),KETYP(MAXELM),KELABL(MAXELM)
      CHARACTER*8       KELEM,KELABL*14
      CHARACTER*4       KETYP
      COMMON /ELMDAT/   IELEM1,IELEM2,IETYP(MAXELM),IEDAT(MAXELM,3),
     +                  IELIN(MAXELM)
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- LINK TABLE
      PARAMETER         (MAXLST = 14000)
      COMMON /LPDATA/   IUSED,ILDAT(MAXLST,6)
C---- PARAMETER TABLE
      PARAMETER         (MAXPAR = 19000)
      COMMON /PARNAM/   KPARM(MAXPAR)
      CHARACTER*8       KPARM
      COMMON /PARDAT/   IPARM1,IPARM2,IPTYP(MAXPAR),IPDAT(MAXPAR,2),
     +                  IPLIN(MAXPAR)
      COMMON /PARVAL/   PDATA(MAXPAR)
C-----------------------------------------------------------------------
C---- BEAM ELEMENTS AND BEAM LINES
      IF (IELEM1 .GT. 0) THEN
        WRITE (IPRNT,910)
        WRITE (IPRNT,920) (I,KELEM(I),KETYP(I),IETYP(I),
     +    IEDAT(I,1),IEDAT(I,2),IEDAT(I,3),IELIN(I),I=1,IELEM1)
      ENDIF
C---- FORMAL ARGUMENTS
      IF (IELEM2 .LE. MAXELM) THEN
        WRITE (IPRNT,930)
        WRITE (IPRNT,920) (I,KELEM(I),KETYP(I),IETYP(I),
     +     IEDAT(I,1),IEDAT(I,2),IEDAT(I,3),IELIN(I),I=IELEM2,MAXELM)
      ENDIF
C---- GLOBAL PARAMETERS
      IF (IPARM1 .GT. 0) THEN
        WRITE (IPRNT,940)
        WRITE (IPRNT,950) (I,KPARM(I),IPTYP(I),
     +     IPDAT(I,1),IPDAT(I,2),IPLIN(I),PDATA(I),I=1,IPARM1)
      ENDIF
C---- ELEMENT PARAMETERS
      IF (IPARM2 .LE. MAXPAR) THEN
        WRITE (IPRNT,960)
        WRITE (IPRNT,950) (I,KPARM(I),IPTYP(I),
     +     IPDAT(I,1),IPDAT(I,2),IPLIN(I),PDATA(I),I=IPARM2,MAXPAR)
      ENDIF
C---- LINK TABLE
      IF (IUSED .GT. 0) THEN
        WRITE (IPRNT,970)
        WRITE (IPRNT,980) (I,(ILDAT(I,J),J=1,6),I=1,IUSED)
      ENDIF
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT('1DUMP OF ELEMENT TABLE (1)')
  920 FORMAT(' ',I10,5X,A8,5X,A4,5I8)
  930 FORMAT('1DUMP OF ELEMENT TABLE (2)')
  940 FORMAT('1DUMP OF PARAMETER TABLE (1)')
  950 FORMAT(' ',I10,5X,A8,4I8,F15.6)
  960 FORMAT('1DUMP OF PARAMETER TABLE (2)')
  970 FORMAT('1DUMP OF LINK TABLE')
  980 FORMAT(' ',I10,6I8)
C-----------------------------------------------------------------------
      END
      SUBROUTINE ELID(ICHAR,NELID)
C     *******************
      IMPLICIT REAL*8 (A-H,O-Z)
      PARAMETER    (MXELMD = 3000)
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      CHARACTER*1 ICHAR(8)
      I=0
    1 I=I+1
      IF(I.GT.NA)GOTO 2
      IF(ICHAR(1).NE.NAME(1,I))GOTO 1
      IF(ICHAR(2).NE.NAME(2,I))GOTO 1
      IF(ICHAR(3).NE.NAME(3,I))GOTO 1
      IF(ICHAR(4).NE.NAME(4,I))GOTO 1
      IF(ICHAR(5).NE.NAME(5,I))GOTO 1
      IF(ICHAR(6).NE.NAME(6,I))GOTO 1
      IF(ICHAR(7).NE.NAME(7,I))GOTO 1
      IF(ICHAR(8).NE.NAME(8,I))GOTO 1
      NELID = I
      RETURN
    2 WRITE(IOUT,10000)ICHAR
      IF (ISO.NE.0)WRITE(ISOUT,10000) ICHAR
10000 FORMAT(/,' ELEMENT NAME DID NOT MATCH MACHINE ELEMENT LIST',/,
     >' ',8A1)
      CALL HALT(245)
      return
      END

      SUBROUTINE ELMDEF(KKEYW,LKEYW,KNAME,LNAME)
C---- DECODE ELEMENT DEFINITION
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
      CHARACTER*8       KKEYW,KNAME
C-----------------------------------------------------------------------
C---- ELEMENT TABLE
      PARAMETER         (MAXELM = 5000)
      COMMON /ELMNAM/   KELEM(MAXELM),KETYP(MAXELM),KELABL(MAXELM)
      CHARACTER*8       KELEM,KELABL*14
      CHARACTER*4       KETYP
      COMMON /ELMDAT/   IELEM1,IELEM2,IETYP(MAXELM),IEDAT(MAXELM,3),
     +                  IELIN(MAXELM)
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- FLAGS FOR I/O
      COMMON /IOFLAG/   SCAN,ERROR,SKIP,ENDFIL,INTER
      LOGICAL           SCAN,ERROR,SKIP,ENDFIL,INTER
C---- PARAMETER TABLE
      PARAMETER         (MAXPAR = 19000)
      COMMON /PARNAM/   KPARM(MAXPAR)
      CHARACTER*8       KPARM
      COMMON /PARDAT/   IPARM1,IPARM2,IPTYP(MAXPAR),IPDAT(MAXPAR,2),
     +                  IPLIN(MAXPAR)
      COMMON /PARVAL/   PDATA(MAXPAR)
C----------------------------------------------------------------------
      COMMON /UNITS/    KFLAGU
C-----------------------------------------------------------------------
      PARAMETER         (NKEYW = 30)
      PARAMETER         (NDRFT =  1)
      PARAMETER         (NBEND = 13)
      PARAMETER         (NQUAD =  4)
      PARAMETER         (NSEXT =  4)
      PARAMETER         (NOCT  =  4)
      PARAMETER         (NMULT = 46)
      PARAMETER         (NSOLO =  5)
      PARAMETER         (NCVTY =  5)
      PARAMETER         (NLCAV =  7)
      PARAMETER         (NSEPA =  3)
      PARAMETER         (NROTA =  1)
      PARAMETER         (NKICK =  3)
      PARAMETER         (NMON  =  5)
      PARAMETER         (NCOLL =  3)
      PARAMETER         (NQUSE =  5)
      PARAMETER         (NGKIK = 11)
      PARAMETER         (NARBI = 21)
      PARAMETER         (NTWIS =  7)
      PARAMETER         (NMATR =163)
      PARAMETER         (NHCOL = 15)
      PARAMETER         (NQUADAC = 8)
c
c modified 08.04.2015 to update cavity model
c
c      PARAMETER         (Ncebcav = 4)
c
      PARAMETER         (Ncebcav = 6)
c
      PARAMETER         (PI = 3.1415926535898D0)
C-----------------------------------------------------------------------
      CHARACTER*8       DKEYW(NKEYW)
      CHARACTER*8       DDRFT(NDRFT)
      CHARACTER*8       DBEND(NBEND)
      CHARACTER*8       DQUAD(NQUAD)
      CHARACTER*8       DSEXT(NSEXT)
      CHARACTER*8       DOCT (NOCT )
      CHARACTER*8       DMULT(NMULT)
      CHARACTER*8       DSOLO(NSOLO)
      CHARACTER*8       DCVTY(NCVTY)
      CHARACTER*8       DLCAV(NLCAV)
      CHARACTER*8       DSEPA(NSEPA)
      CHARACTER*8       DROTA(NROTA)
      CHARACTER*8       DKICK(NKICK)
      CHARACTER*8       DMON (NMON)
      CHARACTER*8       DCOLL(NCOLL)
      CHARACTER*8       DQUSE(NQUSE)
      CHARACTER*8       DGKIK(NGKIK)
      CHARACTER*8       DARBI(NARBI)
      CHARACTER*8       DTWIS(NTWIS)
      CHARACTER*8       DMATR(NMATR)
      CHARACTER*8       Dhcol(nhcol)
      CHARACTER*8       Dquadac(nquadac)
      CHARACTER*8       Dcebcav(ncebcav)
      CHARACTER*8       KTYPE
      CHARACTER*14      KLABL
C-----------------------------------------------------------------------
      DATA DKEYW
     +   / 'DRIFT   ','RBEND   ','SBEND   ','WIGGLER ','QUADRUPO',
     +     'SEXTUPOL','OCTUPOLE','MULTIPOL','SOLENOID','RFCAVITY',
     +     'SEPARATO','ROLL    ','ZROT    ','HKICK   ','VKICK   ',
     +     'HMONITOR','VMONITOR','MONITOR ','MARKER  ','ECOLLIMA',
     +     'RCOLLIMA','QUADSEXT','GKICK   ','ARBITELM','MTWISS  ',
     +     'MATRIX  ','LCAVITY ','HCOLLIMA','QUADAC  ','CEBCAV  ' /
C-----------------------------------------------------------------------
      DATA DDRFT( 1)
     +   / 'L       ' /
      DATA DBEND
     +   / 'L       ','ANGLE   ','K1      ','E1      ','E2      ',
     +     'TILT    ','K2      ','H1      ','H2      ','HGAP    ',
     +     'FINT    ','HGAPX   ','FINTX   '/
      DATA DQUAD
     +   / 'L       ','K1      ','TILT    ','APERTURE' /
      DATA DSEXT
     +   / 'L       ','K2      ','TILT    ','APERTURE' /
      DATA DOCT
     +   / 'L       ','K3      ','TILT    ','APERTURE' /
      DATA DMULT
     +   / 'L       ','K0      ','T0      ','K1      ','T1      ',
     +     'K2      ','T2      ','K3      ','T3      ','K4      ',
     +     'T4      ','K5      ','T5      ','K6      ','T6      ',
     +     'K7      ','T7      ','K8      ','T8      ','K9      ',
     +     'T9      ','K10     ','T10     ','K11     ','T11     ',
     +     'K12     ','T12     ','K13     ','T13     ','K14     ',
     +     'T14     ','K15     ','T15     ','K16     ','T16     ',
     +     'K17     ','T17     ','K18     ','T18     ','K19     ',
     +     'T19     ','K20     ','T20     ','SCALEFAC','APERTURE',
     +     'TILT    ' /
      DATA DSOLO
     +   / 'L       ','KS      ','K1      ','TILT    ','APERTURE' /
      DATA DCVTY
     +   / 'L       ','VOLT    ','LAG     ','FREQ    ','ENERGY  ' /
      DATA DLCAV
     +   / 'L       ','E0      ','DELTAE  ','PHI0    ','FREQ    ',
     +     'KICKCOEF','T       ' /
      DATA DSEPA
     +   / 'L       ','E       ','TILT    ' /
      DATA DROTA
     +   / 'ANGLE   ' /
      DATA DKICK
     +   / 'L       ','KICK    ','TILT    ' /
      DATA DMON
     +   / 'L       ','XSERR   ','YSERR   ','XRERR   ','YRERR   ' /
      DATA DCOLL
     +   / 'L       ','XSIZE   ','YSIZE   ' /
      DATA DQUSE
     +   / 'L       ','K1      ','K2      ','TILT    ','APERTURE' /
      DATA DGKIK
     +   / 'L       ','DX      ','DXP     ','DY      ','DYP     ',
     +     'DL      ','DP      ','ANGLE   ','DZ      ','V       ',
     +     'T       ' /
      DATA DARBI
     +   / 'L       ','P1      ','P2      ','P3      ','P4      ',
     +     'P5      ','P6      ','P7      ','P8      ','P9      ',
     +     'P10     ','P11     ','P12     ','P13     ','P14     ',
     +     'P15     ','P16     ','P17     ','P18     ','P19     ',
     +     'P20     ' /
      DATA DTWIS
     +   / 'L       ','MUX     ','BETAX   ','ALPHAX  ','MUY     ',
     +     'BETAY   ','ALPHAY  ' /
      DATA DMATR /
     +'L   ','R11     ','R12 ','R13 ','R14','R15','R16','T111','T112',
     +'T113','T114','T115','T116','T122','T123','T124','T125','T126',
     +'T133','T134','T135','T136','T144','T145','T146','T155','T156',
     +'T166','R21','R22','R23','R24','R25','R26','T211','T212',
     +'T213','T214','T215','T216','T222','T223','T224','T225','T226',
     +'T233','T234','T235','T236','T244','T245','T246','T255','T256',
     +'T266','R31','R32','R33','R34','R35','R36','T311','T312',
     +'T313','T314','T315','T316','T322','T323','T324','T325','T326',
     +'T333','T334','T335','T336',
     +'T344','T345','T346','T355','T356','T366','R41','R42','R43',
     +'R44','R45','R46','T411','T412','T413','T414','T415','T416',
     +'T422','T423','T424','T425','T426','T433','T434','T435','T436',
     +'T444','T445','T446','T455','T456','T466','R51','R52','R53',
     +'R54','R55','R56','T511','T512','T513','T514','T515','T516',
     +'T522','T523','T524','T525','T526','T533','T534','T535','T536',
     +'T544','T545','T546','T555','T556','T566','R61','R62','R63',
     +'R64','R65','R66','T611','T612','T613','T614','T615','T616',
     +'T622','T623','T624','T625','T626','T633','T634','T635','T636',
     +'T644','T645','T646','T655','T656','T666' /
      DATA Dhcol
     +   / 'L       ','LCOORD  ','RCOORD  ','LSLOPE  ','RSLOPE  ',
     +     'XMAX    ','A       ','Z       ','DENSITY ','IONIZATI',
     +     'ENERGY  ','DENERGY ','MU      ','DISTRIBU','INELASTI' /
      DATA Dquadac
     +   / 'L       ','K1      ','DELTAE  ','PHI0    ','FREQ    ',
     +     'E0      ','TILT    ','APERTURE'/
c      DATA Dcebcav
c     +   / 'L       ','EN0     ','DELTAE  ','PHI0    '/
c
c modified for (2n+1)*pi/2 mode linear model 08.04.2015
c   L is #cells NCELL*RFLAMBDA/2, so NCELL defines RFLAMBDA
c   this version of code reads in NCELL and NSTEP (number of integration
c      steps
c
      DATA Dcebcav
     +   / 'L       ','EN0     ','DELTAE  ','PHI0    ','NCELL   ',
     +     'NSTEP   '/
c
c
C-----------------------------------------------------------------------
C---- IF OLD FORMAT, READ ELEMENT NAME
      IF (LNAME .EQ. 0) THEN
        CALL RDTEST(',',ERROR)
        IF (ERROR) RETURN
        CALL RDNEXT
        CALL RDWORD(KNAME,LNAME)
        IF (LNAME .EQ. 0) THEN
          CALL RDFAIL
          WRITE (IECHO,910)
          ERROR = .TRUE.
          RETURN
        ENDIF
      ENDIF
C---- LOOK UP ELEMENT KEYWORD
      CALL RDLOOK(KKEYW,LKEYW,DKEYW,1,NKEYW,IKEYW)
      IF (IKEYW .EQ. 0) THEN
        CALL RDWARN
        WRITE (IECHO,920) KKEYW(1:LKEYW)
        IKEYW = 1
      ENDIF
C---- ALLOCATE ELEMENT CELL AND TEST FOR REDEFINITION
      CALL FNDELM(ILCOM,KNAME,IELEM)
      IF (IETYP(IELEM) .GE. 0) THEN
        CALL RDWARN
        WRITE (IECHO,930) IELIN(IELEM)
        IETYP(IELEM) = -1
      ENDIF
C---- DEFINE ELEMENT PARAMETER LIST
      GO TO ( 10, 20, 30, 40, 50, 60, 70, 80, 90,100,
     +       110,120,130,140,150,160,170,180,190,200,
     +       210,220,230,240,250,260,270,280,290,300) IKEYW
C---- "DRIFT" --- DRIFT SPACE
   10 CONTINUE
        CALL DEFPAR(NDRFT,DDRFT,IEP1,IEP2,ILCOM)
      GO TO 500
C---- "RBEND" --- RECTANGULAR BENDING MAGNET
   20 CONTINUE
C---- "SBEND" --- SECTOR BENDING MAGNET
   30 CONTINUE
        CALL DEFPAR(NBEND,DBEND,IEP1,IEP2,ILCOM)
        IPTYP(IEP1+5) = -2
        PDATA(IEP1+5) = PI / 2.0
        IF(KFLAGU.EQ.2) PDATA(IEP1+5) = 90.
        PDATA(IEP1+10) = 0.5
      GO TO 500
C---- "WIGGLER" --- WIGGLER MAGNET
   40 CONTINUE
      GO TO 30
C---- "QUADRUPO" --- QUADRUPOLE
   50 CONTINUE
        CALL DEFPAR(NQUAD,DQUAD,IEP1,IEP2,ILCOM)
        IPTYP(IEP1+2) = -2
        PDATA(IEP1+2) = PI / 4.0
        IF(KFLAGU.EQ.2) PDATA(IEP1+2) = 45.
        PDATA(IEP1+3) = 1.0
      GO TO 500
C---- "SEXTUPOL" --- SEXTUPOLE
   60 CONTINUE
        CALL DEFPAR(NSEXT,DSEXT,IEP1,IEP2,ILCOM)
        IPTYP(IEP1+2) = -2
        PDATA(IEP1+2) = PI / 6.0
        IF(KFLAGU.EQ.2) PDATA(IEP1+2) = 30.
        PDATA(IEP1+3) = 1.0
      GO TO 500
C---- "OCTUPOLE" --- OCTUPOLE
   70 CONTINUE
        CALL DEFPAR(NOCT,DOCT,IEP1,IEP2,ILCOM)
        IPTYP(IEP1+2) = -2
        PDATA(IEP1+2) = PI / 8.0
        IF(KFLAGU.EQ.2) PDATA(IEP1+2) = 22.5
        PDATA(IEP1+3) = 1.0
      GO TO 500
C---- "MULTIPOL" --- GENERAL MULTIPOLE
   80 CONTINUE
        CALL DEFPAR(NMULT,DMULT,IEP1,IEP2,ILCOM)
        DO 85 IP = 2, 42, 2
          IPTYP(IEP1+IP) = -2
          PDATA(IEP1+IP) = PI / FLOAT(IP)
          IF(KFLAGU.EQ.2) PDATA(IEP1+IP) = 180./FLOAT(IP)
   85   CONTINUE
        PDATA(IEP1+43) = 1.0
        PDATA(IEP1+44) = 1.0
      GO TO 500
C---- "SOLENOID" --- SOLENOID
   90 CONTINUE
        CALL DEFPAR(NSOLO,DSOLO,IEP1,IEP2,ILCOM)
        IPTYP(IEP1+3) = -2
        PDATA(IEP1+3) = PI / 4.0
        IF(KFLAGU.EQ.2) PDATA(IEP1+3) = 45.
        PDATA(IEP1+4) = 1.0
      GO TO 500
C---- "RF" --- RF CAVITY
  100 CONTINUE
        CALL DEFPAR(NCVTY,DCVTY,IEP1,IEP2,ILCOM)
      GO TO 500
C---- "SEPARATOR" --- ELECTROSTATIC SEPARATOR
  110 CONTINUE
        CALL DEFPAR(NSEPA,DSEPA,IEP1,IEP2,ILCOM)
      GO TO 500
C---- "ROLL" --- ROTATE AROUND LONGITUDINAL AXIS
C---- "ZROT" --- ROTATE AROUND VERTICAL AXIS
  120 CONTINUE
  130 CONTINUE
        CALL DEFPAR(NROTA,DROTA,IEP1,IEP2,ILCOM)
      GO TO 500
C---- "HKICK" --- HORIZONTAL ORBIT CORRECTOR
C---- "VKICK" --- VERTICAL ORBIT CORRECTOR
  140 CONTINUE
  150 CONTINUE
        CALL DEFPAR(NKICK,DKICK,IEP1,IEP2,ILCOM)
      GO TO 500
C--- "HMON, VMON, MON" -- MONITORS
  160 CONTINUE
  170 CONTINUE
  180 CONTINUE
        CALL DEFPAR(NMON,DMON,IEP1,IEP2,ILCOM)
      GO TO 500
C---- "ECOLLIMA" --- ELLIPTIC COLLIMATOR
C---- "RCOLLIMA" --- RECTANGULAR COLLIMATOR
  200 CONTINUE
  210 CONTINUE
        CALL DEFPAR(NCOLL,DCOLL,IEP1,IEP2,ILCOM)
        PDATA(IEP1+1) = 1.0
        PDATA(IEP1+2) = 1.0
      GO TO 500
C---- "MARKER" --- MARKER ELEMENT
  190 CONTINUE
        IEP1 = 0
        IEP2 = 0
      GO TO 500
C---- "QUADSEXT"--- QUADRUPOLE-SEXTUPOLE COMBINATION
  220 CONTINUE
        CALL DEFPAR(NQUSE,DQUSE,IEP1,IEP2,ILCOM)
        IPTYP(IEP1+3) = -2
        PDATA(IEP1+3) = PI / 4.0
        IF(KFLAGU.EQ.2) PDATA(IEP1+3) = 45.
        PDATA(IEP1+4) = 1.0
      GO TO 500
C---- "GKICK" --- GENERAL KICK A LA DIMAT
  230 CONTINUE
        CALL DEFPAR(NGKIK,DGKIK,IEP1,IEP2,ILCOM)
        PDATA(IEP1+9) = 1.0
      GO TO 500
C--- ARBITRARY ELEMENT
  240 CONTINUE
        CALL DEFPAR(NARBI,DARBI,IEP1,IEP2,ILCOM)
      GO TO 500
C--- TWISS MATRIX
  250 CONTINUE
        CALL DEFPAR(NTWIS,DTWIS,IEP1,IEP2,ILCOM)
        PDATA(IEP1+2) = 1.0
        PDATA(IEP1+5) = 1.0
      GO TO 500
C--- GENERAL MATRIX
  260 CONTINUE
        CALL DEFPAR(NMATR,DMATR,IEP1,IEP2,ILCOM)
C        PDATA(IEP1+1) = 1.0
C        PDATA(IEP1+29) = 1.0
C        PDATA(IEP1+57) = 1.0
C        PDATA(IEP1+85) = 1.0
C        PDATA(IEP1+113) = 1.0
C        PDATA(IEP1+141) = 1.0
      goto 500
C---- "RF" --- RF LINAC CAVITY
  270 CONTINUE
        CALL DEFPAR(NLCAV,DLCAV,IEP1,IEP2,ILCOM)
      GO TO 500
C---- "HCollimators" Background collimators
  280 CONTINUE
        CALL DEFPAR(Nhcol,Dhcol,IEP1,IEP2,ILCOM)
        pdata(iep1+12)=1.4
        pdata(iep1+14)=2
      GO TO 500
C---- "QUADACs" Quadrupoles imbedded in a linac cavity
  290 CONTINUE
        CALL DEFPAR(Nquadac,Dquadac,IEP1,IEP2,ILCOM)
        iptyp(iep1+6)=-2
        pdata(iep1+6)=pi/4.0
        IF(KFLAGU.EQ.2) PDATA(IEP1+6) = 45.
        pdata(iep1+7)=1.0
      GO TO 500
C---- "Cebaf cavities as requested by D.Douglas and following his
C---- computation for the first order matrix
  300 CONTINUE
        CALL DEFPAR(Ncebcav,Dcebcav,IEP1,IEP2,ILCOM)
      GO TO 500
  500 CONTINUE
C---- DECODE PARAMETER LIST, IF ANY
      CALL DECPAR(IEP1,IEP2,KTYPE,KLABL,ERROR)
C---- CHECK ON HGAPX AND FINTX FOR BEND
      IF (IKEYW.EQ.2 .OR. IKEYW.EQ.3 .OR. IKEYW.EQ.4) THEN
        IF(IPTYP(IEP1+11).EQ.-1) PDATA(IEP1+11) = PDATA(IEP1+9)
        IF(IPTYP(IEP1+12).EQ.-1) PDATA(IEP1+12) = PDATA(IEP1+10)
      ENDIF
      IF (ERROR) RETURN
      KETYP(IELEM) = KTYPE
      KELABL(IELEM) = KLABL
      IETYP(IELEM) = IKEYW
      IEDAT(IELEM,1) = IEP1
      IEDAT(IELEM,2) = IEP2
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT(' *** ERROR *** ELEMENT NAME EXPECTED'/' ')
  920 FORMAT(' ** WARNING ** UNKNOWN ELEMENT KEYWORD "',A,
     +       '" --- "DRIFT" ASSUMED'/' ')
  930 FORMAT(' ** WARNING ** THE ABOVE NAME WAS DEFINED IN LINE ',I5,
     +       ', IT WILL BE REDEFINED'/' ')
C-----------------------------------------------------------------------
      END
      SUBROUTINE ELPOS(ICHAR,NELPOS)
C     ********************************
      IMPLICIT REAL*8 (A-H,O-Z)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      CHARACTER*1 ICHAR(8)
      CALL ELID(ICHAR,NELID)
      DO 1 IEL=1,NELM
      IF(NELID.EQ.NORLST(IEL))GOTO 2
    1 CONTINUE
      WRITE(IOUT,10000)NELID,(NAME(IN,NELID),IN=1,8)
10000 FORMAT(/,'  ELEMENT #',I5,' NAME ',8A1,' IS NOT IN MACHINE LIST')
      CALL HALT(246)
      return
    2 NELPOS=IEL
      RETURN
      END
C     *******************
      SUBROUTINE ENANAL
C     *******************
      IMPLICIT REAL*8 (A-H,O-Z)
      PARAMETER    (mxpart = 128000)
      DIMENSION L(5),M1(5),L4(4),M14(4)
      REAL*8 M(5,5)
      DIMENSION A(25),B(16),F(4),X(4),V(5,4),Q(4,4),SAVEU(75,4)
      DIMENSION DAT(4,5)
      EQUIVALENCE (M(1,1),A(1)), (Q(1,1),B(1))
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      COMMON/TRI/WCO(15,6),GEN(5,4),PGEN(75,6),DIST,
     <A1(15),B1(15),A2(15),B2(15),XCOR(3,15),XPCOR(3,15),
     1AL1(15),AL2(15),MESH,NIT,NENER,NITX,NITS,NITM1,NANAL,NOPRT
      COMMON /MVT/ U(5,4)
      COMMON /CTUNE/DNU0X,DNU0Y,DBETX,DBETY,DALPHX,DALPHY,
     >DXCO,DXPCO,DYCO,DYPCO,DDELCO
      COMMON/CLSQ/ALSQ(15,2,4),IXY,NCOEF,NAPLT,JENER,LENER(15)
      LOGICAL LENER
      DATA DAT/ 1.0D0, 0.0D0, 1.0D0, 0.0D0, 0.309017D0, 0.951057D0,
     1 0.309017D0, 0.951057D0, -0.809017D0, 0.587785D0, -0.809016D0,
     2 -0.587785D0, -0.809017D0, -0.587785D0, 0.309017D0, -0.951056D0,
     3 0.309017D0, -0.951056D0, -0.809017D0, 0.587785D0/
C TO SET UP GEN
  200 DO 201 I=1,5
      DO 202 J=1,4
  202 GEN(I,J)=DIST*DAT(J,I)
  201 CONTINUE
C TO GENERATE PARTICLES.
      DO 203 I=1,5
      DO 204 N=1,NENER
      IND=I+N+N+N+N+N-5
      DO 205 J=1,4
  205 PGEN(IND,J)=WCO(N,J)+GEN(I,J)
      PGEN(IND,6)=WCO(N,6)
  204 PGEN(IND,5)=WCO(N,5)
  203 CONTINUE
C TO PREPARE FOR TRACKING PARTICLES.
      NPART=5*NENER
      NCPART = NPART
      DO 206 I = 1, NPART
      DO 207 J=1,6
  207 PART(I,J)=PGEN(I,J)
      del(i)=part(i,6)
  206 CONTINUE
       IF (NITS.LT.0) GO TO 209
      IF(NOUT.GE.3)
     >WRITE (IOUT,210)
  210 FORMAT ('-', 'INITIAL POSITIONS OF PARTICLES ', /)
      DO 211 I=1,NPART
  211 IF(NOUT.GE.3)
     >WRITE (IOUT,212) I, (PART(I,K),K=1,6)
  212 FORMAT(I4,6(E14.5))
  209 NCTURN=0
  215 CALL TRACKT
      DO 216 IP=1,NENER
      DO 216 IL=1,5
      ILP=(IP-1)*5+IL
      IF(.NOT.LOGPAR(ILP))LENER(IP)=.FALSE.
  216 IF(.NOT.LENER(IP))LOGPAR(ILP)=.FALSE.
      DO 218 IL=1,NENER
      IF(LENER(IL))GO TO 220
  218 CONTINUE
      WRITE(IOUT,48)
   48 FORMAT(' OPERATION STOPPED DUE TO LOSS OF PARTICLES ')
      CALL HALT(304)
  220 CONTINUE
C TO FIND THE CLOSED ORBIT.
  260 DO 270 J=1,NENER
      IF(.NOT.LENER(J))GO TO 270
      IND5=J+J+J+J+J
      IND4=IND5-1
      IND3=IND4-1
      IND2=IND3-1
      IND1=IND2-1
      DO 271 I=1,4
      IND=I+1
      M(1,IND)=PGEN(IND1,I)
      M(2,IND)=PGEN(IND2,I)
      M(3,IND)=PGEN(IND3,I)
      M(4,IND)=PGEN(IND4,I)
      M(5,IND)=PGEN(IND5,I)
      V(1,I)=PART(IND1,I)
      V(2,I)=PART(IND2,I)
      V(3,I)=PART(IND3,I)
      V(4,I)=PART(IND4,I)
  271 V(5,I)=PART(IND5,I)
      DO 275 I=1,5
  275 M(I,1)=1
      CALL DMINV(A,5,D,L,M1)
      DO 277 I=1,5
      DO 278 N=1,4
      U(I,N)=0.0D0
      DO 279 K=1,5
  279 U(I,N)=U(I,N)+M(I,K)*V(K,N)
  278 CONTINUE
  277 CONTINUE
      IF(NITX.LT.NIT) GO TO 265
  268 IF(NOUT.GE.1)
     >WRITE (IOUT,276) PGEN(IND1,6)
  276 FORMAT(//,10X,33H-----     THE ANALYSIS FOR ENERGY,E17.5,
     *10H     -----,/)
      IF(NOUT.GE.3)
     >WRITE (IOUT,281)
  281 FORMAT('-', 'THE TRANSFER MATRIX IS ')
      DO 283 I=1,4
      IF(NOUT.GE.3)
     >WRITE (IOUT,282) (U(N,I),N=2,5)
  282 FORMAT ('-',4(E15.5))
  283 CONTINUE
C TO FIND THE DETERMINANT.
      DET=((U(4,3)*U(5,4)-U(5,3)*U(4,4))*(U(2,1)*U(3,2)-U(2,2)*U(3,1)))
     1+ ((U(4,2)*U(5,4)-U(5,2)*U(4,4)) * (U(2,3)*U(3,1)-U(2,1)*U(3,3)))
     1+ ((U(4,2)*U(5,3)-U(5,2)*U(4,3)) * (U(2,1)*U(3,4)-U(2,4)*U(3,1)))
     1+ ((U(4,1)*U(5,4)-U(5,1)*U(4,4)) * (U(2,2)*U(3,3)-U(2,3)*U(3,2)))
     1+ ((U(4,1)*U(5,3)-U(5,1)*U(4,3)) * (U(2,4)*U(3,2)-U(2,2)*U(3,4)))
     1+ ((U(4,1)*U(5,2)-U(5,1)*U(4,2)) * (U(2,3)*U(3,4)-U(2,4)*U(3,3)))
      IF(NOUT.GE.1)
     >WRITE(IOUT,284) DET
      IF(DABS((DET)-1.0D0).GT.0.5D0)CALL HALT(305)
  284 FORMAT ('-','THE DETERMINANT IS: ',E20.10)
  262 DO 285 I=1,4
      DO 286 K=1,4
  286 Q(I,K)=-(U(K+1,I))
      Q(I,I)=1.D0+Q(I,I)
  285 X(I)=U(1,I)
      CALL DMINV(B,4,D,L4,M14)
      DO 289 I=1,4
      F(I)=0.0D0
      DO 287 K=1,4
  287 F(I)=F(I)+Q(I,K)*X(K)
  289 WCO(J,I)=F(I)
      GO TO 261
C THE ROUTINE TO SAVE THE MATRIX U.
  265 DO 266 I=1,5
      IND=I+IND1-1
      DO 267 K=1,4
  267 SAVEU(IND,K)=U(I,K)
  266 CONTINUE
      IF(NITS.LT.0.AND.NITX.LT.NITM1) GO TO 262
      GO TO 268
  261 CONTINUE
      IF (NITS.LT.0.AND.NITX.LT.NITM1) GO TO 270
      IF(NOUT.GE.1)
     >WRITE (IOUT,288) (F(I),I=1,4)
  288 FORMAT ('-','THE CLOSED ORBIT IS',/,20X,'XCO=',E15.5,8X,'X"CO=',
     1E15.5,/,20X, 'ZCO=',E15.5,8X,'Z"CO=',E15.5)
 270  CONTINUE
      NITX=NITX+1
      IF(NITX.LT.NIT) GO TO 251
      IF(NOPRT.NE.NTURN) GO TO 350
C THE MOVEMENT ANALYSIS OF THE DATA.
  351 IF (NANAL.EQ.0) RETURN
      IF(NOUT.GE.1)
     >WRITE(IOUT,20001)
20001 FORMAT(///,30(1H ),27(1H*),/,30(1H ),
     127H*    MOVEMENT ANALYSIS    *,/,30(1H ),27(1H*),/)
  230 DO 231 J=1,NENER
      JENER=J
      IF(.NOT.LENER(J))GO TO 231
      DO 232 K=1,5
      IND=K+J+J+J+J+J-5
      DO 233 I=1,4
  233 U(K,I)=SAVEU(IND,I)
  232 CONTINUE
      ALSQ(J,1,3)=WCO(J,1)
      ALSQ(J,1,4)=WCO(J,2)
      ALSQ(J,2,3)=WCO(J,3)
      ALSQ(J,2,4)=WCO(J,4)
      IF(J.EQ.1) THEN
        DXCO=WCO(J,1)
        DXPCO=WCO(J,2)
        DYCO=WCO(J,3)
        DYPCO=WCO(J,4)
        DDELCO=WCO(J,6)
      ENDIF
      IF(NOUT.GE.1)
     >WRITE(IOUT,239) WCO(J,6)
  239 FORMAT(/(10X,16H-----     ENERGY  ,E17.5,10H     -----,/))
C TO FIND THE HORIZONTAL MOVEMENT.
      IF(NOUT.GE.1)
     >WRITE (IOUT,234)
  234 FORMAT('-',30X,'HORIZONTAL MOVEMENT')
      IXY=1
      CALL MOVMT
C TO FIND THE VERTICAL MOVEMENT.
      IF(NOUT.GE.1)
     >WRITE(IOUT,235)
  235 FORMAT('-',31X,'VERTICAL MOVEMENT')
      DO 236 I=2,3
      IND=I+2
      DO 237 K=1,2
  237 U(I,K)=U(IND,K+2)
  236 CONTINUE
      IXY=2
      CALL MOVMT
  231 CONTINUE
      IF(NANAL.GT.1)CALL RES
      CALL LSQ
      IF(NAPLT.EQ.1) CALL PLOTEN
      RETURN
  251 DIST=DIST*0.3D0
      GO TO 200
  296 DO 297 JICO=1,6
  297 PART(ICO,JICO)=0.0D0
      GO TO 298
  350 DO 290 ICO=1,NENER
      IF(.NOT.LENER(ICO)) GO TO 296
      DO 290 J=1,6
  290 PART(ICO,J) = WCO(ICO,J)
  298 CONTINUE
      NPRINT =NOPRT
      NPART=NENER
      NCPART = NPART
      IF(NOUT.GE.3)
     >WRITE(IOUT,213)
 213  FORMAT(//,30(1H ),36(1H*),/,30(1H ),
     >36H*    DETAILED CLOSED ORBIT DATA    *,/,30(1H )
     >,36(1H*),/)
      NCTURN=0
      CALL TRACKT
      GO TO 351
      END
      SUBROUTINE ENTEX(PARM,MATADR)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      PARAMETER    (mxpart = 128000)
      COMMON /INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      COMMON/PRODCT/KODEPR,NEL,NOF
      DIMENSION PARM(20)
C
C     CLEAR AMAT(27,6,MATADR)
C
      DO 100 I=1,6
      DO 100 J=1,NOF
      AMAT(J,I,MATADR)=0.0D0
100   CONTINUE
      PARM(3)=PARM(3)*CRDEG
      EXTAN=DTAN(PARM(3))
      EXTAN2=EXTAN*EXTAN
      EXSEC=1.0D0/DCOS(PARM(3))
      AN=PARM(2)
      H=PARM(1)
      S=PARM(4)
      EXSIN=DSIN(PARM(3))
      EXSIN2=EXSIN*EXSIN
      CFOCL=2.0D0*PARM(7)*H*PARM(6)*EXSEC*(1.0D0+EXSIN2)
      AMAT(1,1,MATADR) = 1.0D0
      AMAT(1,2,MATADR) = H*EXTAN
      AMAT(2,2,MATADR) = 1.0D0
      AMAT(3,3,MATADR) = 1.0D0
      AMAT(3,4,MATADR)=-H*DTAN(PARM(3)-CFOCL)
      AMAT(4,4,MATADR) = 1.0D0
      AMAT(5,5,MATADR) = 1.0D0
      AMAT(6,6,MATADR)=1.0D0
      IF(NORDER.EQ.1)RETURN
      EXSEC2=EXSEC*EXSEC
      EXSEC3=EXSEC2*EXSEC
      H2=H*H
      HO2=H/2.0D0
      ENTC=(H*PARM(5)*EXSEC3)/2.0D0
      AMAT(7,1,MATADR) = -S*HO2*EXTAN2
      AMAT(18,1,MATADR) = S*HO2*EXSEC2
      AMAT(7,2,MATADR)=ENTC-H2*(AN-(S-1)*EXTAN2/4)*EXTAN
      AMAT(8,2,MATADR) = S*EXTAN2*H
      AMAT(12,2,MATADR) = -H*EXTAN
      AMAT(18,2,MATADR)=H2*(AN+(S+1)*(EXTAN2+1)/4
     >+ S*EXTAN2/2) *EXTAN - ENTC
      AMAT(19,2,MATADR) = -S*H*EXTAN2
      AMAT(9,3,MATADR) = S*EXTAN2*H
      AMAT(9,4,MATADR)=-2.0D0*ENTC+H2*(2*AN-(S-1)*EXSEC2/2)*EXTAN
      AMAT(10,4,MATADR) = -S*EXTAN2*H
      AMAT(14,4,MATADR) = -S*H*EXSEC2
      AMAT(21,4,MATADR) = H*EXTAN-h*cfocl/(dcos(parm(3)-cfocl)**2)
      RETURN
      END
      SUBROUTINE ERESET(IELM,MATADR)
C     *******************************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      parameter   (mxerr = 25)
      parameter   (MXEREL = 500)
      parameter   (MXERRG = 6)
      COMMON/cERR/ERRVAL(mxerr,mxerel),erv(mxerr,mxerel),NERELE(mxerel),
     > NERPAR(mxerr,mxerel),NERR,NEROPT,NERRE,MERSEL(mxerel),
     > NERNGE(mxerel),MERNGE(2,mxerrg,mxerel),MERFLG
      COMMON/ERSAV/SAV(mxerr),SAVMAT(6,27),IERSET,IER,IDE,IEMSAV
      COMMON/MISSET/DX1,DX2,DXP1,DXP2,DY1,DY2,DYP1,DYP2,
     >DZ1,DZ2,DZC1,DZS1,DZC2,DZS2,DDEL,I,IEP,MNEL
      COMMON/LINCAV/LCAVIN,NUMCAV,ENJECT,IECAV(MAXMAT),
     &              EIDEAL(MAXPOS),EREAL(MAXPOS)
      LOGICAL LCAVIN
      COMMON/QPSAVE/QUAD,QUADER
      LOGICAL QUAD,QUADER
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      IF(IERSET.EQ.0)RETURN
C
C  PATCH UP STRENGTH IF A QUAD HAS BEEN SHIFTED BY RATIO OF CENTRAL
C  ENERGIES
C
      IF(QUAD) THEN
        CPIDEAL=DSQRT(EIDEAL(IEP)**2-EMASS**2)
        CPREAL =DSQRT(EREAL(IEP)**2-EMASS**2)
        ELDAT(IADR(IELM)+1)=(CPREAL/CPIDEAL)*ELDAT(IADR(IELM)+1)
        QUAD=.FALSE.
          IF(.NOT.QUADER) THEN
             IERSET=0
             GO TO 1776
                          ELSE
             QUADER=.FALSE.
          END IF
      END IF
      NPAR89=0
      IAD=IADR(IELM)
      DO 1 ID=1,7
      NPAR=NERPAR(ID,IDE)
      IF(NPAR.EQ.0)GOTO 2
      IF ((NPAR.EQ.8) .OR. (NPAR.EQ.9)) NPAR89=1
      ELDAT(IAD+NPAR-1)=SAV(ID)
    1 CONTINUE
    2 CONTINUE
      IERSET=0
      IF(IEMSAV.EQ.0) RETURN
C      KO = KODE(IELM)
C      IF ((KO.EQ.5) .OR. (KO.EQ.6) .OR. (KO.EQ.7) .OR. (KO.EQ.12))
C     +                                              RETURN
C      IF ((KO.EQ.8) .AND. (NPAR89.EQ.0)) RETURN
 1776 CONTINUE
      DO 3 IMAT=1,6
      DO 3 JMAT=1,27
      AMAT(JMAT,IMAT,MATADR)=SAVMAT(IMAT,JMAT)
    3 CONTINUE
      RETURN
      END
      SUBROUTINE ERRDAT(IEND)
C     ********************************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      parameter   (mxerr = 25)
      parameter   (MXEREL = 500)
      parameter   (MXERRG = 6)
      COMMON/cERR/ERRVAL(mxerr,mxerel),erv(mxerr,mxerel),NERELE(mxerel),
     > NERPAR(mxerr,mxerel),NERR,NEROPT,NERRE,MERSEL(mxerel),
     > NERNGE(mxerel),MERNGE(2,mxerrg,mxerel),MERFLG
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
      CHARACTER*1 NINE
      DATA NINE/'9'/
C INITIALIZE TO 0 ALL ARRAYS DEFINED IN THIS ROUTINE
      DO 3 INER=1,mxerel
      NERELE(INER)=0
      DO 3 JNER=1,7
      NERPAR(JNER,INER)=0
    3 ERRVAL(JNER,INER)=0.0D0
      NPRINT=1
      NERR=0
    2 NCHAR=8
      IEND=0
      NDATA=0
      NDIM=mxinp
      CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NPRINT)
      IF((ICHAR(1).EQ.NINE).AND.(ICHAR(2).EQ.NINE))GOTO 99
      CALL ELID(ICHAR,NELID)
      NERR=NERR+1
      IF(NERR.GT.mxerel) THEN
             WRITE(IOUT,100)mxerel
             NERR=NERR-1
             GOTO 99
      ENDIF
  100 FORMAT(/,'  **************************************** ',/,
     >'  TOO MANY ELEMENTS WITH ERROR, FIRST ',i3,' ONLY KEPT ',/,
     >'  **************************************************** ',/)
      NERELE(NERR)=NELID
      NERD=0
      NCHAR=8
      NDATA=1
    5 CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NPRINT)
      NERD=NERD+1
      IF (NERD.gt.mxerr)THEN
      WRITE(IOUT,*)' TOO MANY ERROR VALUES '
      GOTO 2
      ENDIF
      CALL DIMPAR(NELID,ICHAR,IDICT)
      NERPAR(NERD,NERR)=IDICT
      ERRVAL(NERD,NERR)=DATA(1)
      IF(IEND.NE.0)GOTO 2
      GOTO 5
   99 RETURN
      END
      SUBROUTINE ESET(IELM,MATADR)
C     ***************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      parameter   (mxerr = 25)
      parameter   (MXEREL = 500)
      parameter   (MXERRG = 6)
      COMMON/cERR/ERRVAL(mxerr,mxerel),erv(mxerr,mxerel),NERELE(mxerel),
     > NERPAR(mxerr,mxerel),NERR,NEROPT,NERRE,MERSEL(mxerel),
     > NERNGE(mxerel),MERNGE(2,mxerrg,mxerel),MERFLG
      COMMON/ERSAV/SAV(mxerr),SAVMAT(6,27),IERSET,IER,IDE,IEMSAV
      COMMON/MISSET/DX1,DX2,DXP1,DXP2,DY1,DY2,DYP1,DYP2,
     >DZ1,DZ2,DZC1,DZS1,DZC2,DZS2,DDEL,I,IEP,MNEL
      PARAMETER  (mxmis = 1000)
      COMMON/MIS/RMISA(8,MXMIS),MISELE(MXMIS),NMIS,NOPT,
     >NMISE,MISSEL(MXMIS),NMRNGE(MXMIS),
     >MSRNGE(2,10,MXMIS),MISFLG,MCHFLG
      COMMON/CSEEDS/ISEED,IXG,IXS,IXMSTP,IMSD,IMOSTP,ISYNSD,ISYSTP,
     >ISDBEG,IBGSTP,IXES,IXESTP,IESBEG,IESTBG,isdcol
      PARAMETER  (MAXERR = 100)
      COMMON /ERRSRT/ ERRSRT(MAXERR),NERSRT,IERSRT,IERBEG
      COMMON/LINCAV/LCAVIN,NUMCAV,ENJECT,IECAV(MAXMAT),
     &              EIDEAL(MAXPOS),EREAL(MAXPOS)
      LOGICAL LCAVIN
      COMMON/QPSAVE/QUAD,QUADER
      LOGICAL QUAD,QUADER
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      IEMSAV=0
      QUAD=.FALSE.
      QUADER=.FALSE.
      NPAR89=0
      DO 1 IER=1,NERRE
      IDE=MERSEL(IER)
      IF(IELM.EQ.NERELE(IDE))GOTO 2
    1 CONTINUE
      IF((LCAVIN).AND.(KODE(IELM).EQ.2)) THEN
         QUAD=.TRUE.
         GO TO 1776
      END IF
      RETURN
    2 NFRNGE=NERNGE(IER)
      IF(NFRNGE.EQ.0)GOTO 4
      IF(NFRNGE.LT.0)RETURN
      DO 3 IERN=1,NFRNGE
      IF((IEP.GE.MERNGE(1,IERN,IER)).AND.(IEP.LE.MERNGE(2,IERN,IER)))
     > GOTO 4
    3 CONTINUE
      IF((LCAVIN).AND.(KODE(IELM).EQ.2)) THEN
         QUAD=.TRUE.
         GO TO 1776
      END IF
      RETURN
    4 IERSET=1
      IF((LCAVIN).AND.(KODE(IELM).EQ.2)) THEN
         QUAD=.TRUE.
         QUADER=.TRUE.
      END IF
      IAD=IADR(IELM)
      DO 7 ID=1,mxerr
      NPAR=NERPAR(ID,IDE)
      IF(NPAR.EQ.0)GOTO 8
      IF ((NPAR.EQ.8) .OR. (NPAR.EQ.9)) NPAR89=1
      SAV(ID)=ELDAT(IAD+NPAR-1)
      IF(NEROPT.EQ.0)GOTO 100
      IF((NEROPT.LT.0).OR.(NEROPT.GT.5))GOTO 110
      IOPT=NEROPT
      IF (NEROPT.NE.5) THEN
        ERSIG=2.0D0
        IF(NEROPT.NE.4)GOTO 210
        IOPT=3
        ERSIG=6.0D0
  210   FACT=RANNUM(IXES,IOPT,ERSIG,IXESTP)
      ELSE
        IF (IERSRT.LE.NERSRT) THEN
          FACT = ERRSRT(IERSRT)
          IERSRT = IERSRT + 1
        ELSE
          WRITE(IOUT,9977) NERSRT
 9977     FORMAT(' MORE THAN NERSRT =',I7,' ERROR VALUES REQUESTED,',
     +                          ' QUITTING')
          CALL HALT(251)
        ENDIF
      ENDIF
      GOTO 200
  110 WRITE(IOUT,99998)
99998 FORMAT(/,'  ERROR IN OPTION NUMBER FOR RANDOM GENERATION',/)
      CALL HALT(250)
  100 FACT=1.0D0
  200 continue
      erv(id,ide)=fact*errval(id,ide)
      ELDAT(IAD+NPAR-1)=ELDAT(IAD+NPAR-1)+FACT*ERRVAL(ID,IDE)
    7 CONTINUE
    8 KO = KODE(IELM)
      IF  ((KO.EQ.6) .OR. (KO.EQ.7) .OR. (KO.EQ.12))
     +                                                RETURN
      IF ((KO.EQ.8) .AND. (NPAR89.EQ.0)) RETURN
      IF(KO.EQ.5) THEN
       IRET=1
       NP=ELDAT(IAD+2)
       DO 111 IM=1,NP
       NOR=ELDAT(IAD+3+(IM-1)*3)
       VAL=ELDAT(IAD+4+(IM-1)*3)
       IF(((NOR.EQ.2).OR.(NOR.EQ.3)).AND.(VAL.NE.0.0D0))IRET=0
  111  CONTINUE
       IF (IRET.EQ.1) RETURN
      ENDIF
 1776 CONTINUE
      IF (QUAD) THEN
      CPIDEAL=DSQRT(EIDEAL(IEP)**2-EMASS**2)
      CPREAL =DSQRT(EREAL(IEP)**2-EMASS**2)
      ELDAT(IADR(IELM)+1)=(CPIDEAL/CPREAL)*ELDAT(IADR(IELM)+1)
      IERSET=1
C (BE SURE TO RESET THE QUAD VALUE IN ERESET!)
      END IF
      DO 9 IMAT=1,6
      DO 9 JMAT=1,27
      SAVMAT(IMAT,JMAT)=AMAT(JMAT,IMAT,MATADR)
    9 CONTINUE
      IEMSAV=1
      CALL MATGEN(IELM)
      RETURN
      END
      SUBROUTINE EXPAND(JBEAM,JACT,NELM,NFREE,IPOS1,IPOS2,ERROR)
C---- EXPAND A BEAM LINE
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
      LOGICAL           ERROR
C-----------------------------------------------------------------------
C---- ELEMENT TABLE
      PARAMETER         (MAXELM = 5000)
      PARAMETER         (MXLINE = 1000)
      COMMON /ELMNAM/   KELEM(MAXELM),KETYP(MAXELM),KELABL(MAXELM)
      CHARACTER*8       KELEM,KELABL*14
      CHARACTER*4       KETYP
      COMMON /ELMDAT/   IELEM1,IELEM2,IETYP(MAXELM),IEDAT(MAXELM,3),
     +                  IELIN(MAXELM)
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- LINK TABLE
      PARAMETER         (MAXLST = 14000)
      COMMON /LPDATA/   IUSED,ILDAT(MAXLST,6)
C---- SEQUENCE TABLE
      PARAMETER         (MAXPOS = 10000)
      COMMON /SEQNUM/   ITEM(MAXPOS)
C-----------------------------------------------------------------------
      LOGICAL           FLAG
C-----------------------------------------------------------------------
C---- INITIALIZE
      ERROR = .FALSE.
      NELM = 0
      IPOS = NFREE
      IDIR = 1
      IREP = 1
      ICELL = 0
      IBEAM = JBEAM
      IHEAD = IEDAT(IBEAM,3)
      IACT = JACT
      IDIREP = 1
C---- ENTER NAMED BEAM LINE
   90 CALL FRMSET(IBEAM,IACT,FLAG)
      ERROR = ERROR .OR. FLAG
C---- ENTER BEAM LINE --- STACK TRACKING PARAMETERS
  100 ILDAT(IHEAD,4) = IDIR*IREP
      ILDAT(IHEAD,5) = ICELL
      ILDAT(IHEAD,6) = IBEAM
      IDIR = ISIGN(1,IDIREP)
      IREP = IABS(IDIREP)
      ICELL = IHEAD
C---- BEGIN TRACKING THROUGH BEAM LINE
  110 IF (IBEAM .NE. 0) THEN
        IF (IPOS .GE. MAXPOS) CALL OVFLOW(4,MAXPOS)
        IPOS = IPOS + 1
        ITEM(IPOS) = IBEAM + MAXELM
      ENDIF
C---- STEP THROUGH LINE
  120 IF (IDIR .LT. 0) ICELL = ILDAT(ICELL,2)
      IF (IDIR .GT. 0) ICELL = ILDAT(ICELL,3)
C---- SWITCH ON LIST CELL TYPE
      GO TO (150, 200, 250), ILDAT(ICELL,1)
C---- END TRACKING THROUGH BEAM LINE
  150 IBEAM = ILDAT(ICELL,6)
      IF (IBEAM .NE. 0) THEN
        IF (IPOS .GE. MAXPOS) CALL OVFLOW(4,MAXPOS)
        IPOS = IPOS + 1
        ITEM(IPOS) = IBEAM + MAXELM+MXLINE
      ENDIF
C---- ANY MORE REPETITIONS?
      IREP = IREP - 1
      IF (IREP .GT. 0) GO TO 110
C---- LEAVE CURRENT BEAM LINE --- UNSTACK TRACKING PARAMETERS
      IHEAD = ICELL
      IDIR = ISIGN(1,ILDAT(IHEAD,4))
      IREP = IABS(ILDAT(IHEAD,4))
      ICELL = ILDAT(IHEAD,5)
      IBEAM = ILDAT(IHEAD,6)
      ILDAT(IHEAD,4) = 0
      ILDAT(IHEAD,5) = 0
      ILDAT(IHEAD,6) = 0
      IF (ICELL .NE. 0) GO TO 120
C---- PRINT ENDING MESSAGE
      LE = LENGTH(KELEM(IBEAM))
      IF (ERROR) THEN
        WRITE (IECHO,910) KELEM(IBEAM)(1:LE)
        NFAIL = NFAIL + 1
        IPOS1 = 0
        IPOS2 = 0
      ELSE
        NPOS = IPOS - NFREE
        WRITE (IECHO,920) KELEM(IBEAM)(1:LE),NELM,NPOS
        IPOS1 = NFREE + 1
        IPOS2 = IPOS
        NFREE = IPOS
      ENDIF
      RETURN
C---- CALL UNNAMED BEAM LINE
  200 IDIREP = ILDAT(ICELL,4)*IDIR
      IF (IDIREP .EQ. 0) GO TO 120
      IHEAD = ILDAT(ICELL,5)
      IBEAM = 0
      GO TO 100
C---- CALL NAMED BEAM LINE OR BEAM ELEMENT
  250 IDIREP = ILDAT(ICELL,4)*IDIR
      IF (IDIREP .EQ. 0) GO TO 120
      IELEM = ILDAT(ICELL,5)
      IF (IETYP(IELEM)) 260,270,300
C---- CALL UNDEFINED ELEMENT
  260 LE = LENGTH(KELEM(IELEM))
      WRITE (IECHO,930) KELEM(IELEM)(1:LE)
      NFAIL = NFAIL + 1
      ERROR = .TRUE.
      GO TO 120
C---- CALL FORMAL ARGUMENT OR NAMED BEAM LINE
  270 IHEAD = IEDAT(IELEM,3)
      IF (ILDAT(IHEAD,4) .NE. 0) GO TO 280
      IF (IELEM .GE. IELEM2) THEN
        IACT  = 0
        IBEAM = 0
        GO TO 100
      ELSE
        IACT  = ILDAT(ICELL,6)
        IBEAM = IELEM
        GO TO 90
      ENDIF
C---- BEAM LINE CALLS ITSELF
  280 LE = LENGTH(KELEM(IELEM))
      WRITE (IECHO,940) KELEM(IELEM)(1:LE)
      NFAIL = NFAIL + 1
      ERROR = .TRUE.
      GO TO 120
C---- CALL BEAM ELEMENT
  300 IEREP = IABS(IDIREP)
      IF (IPOS + IEREP .GT. MAXPOS) CALL OVFLOW(4,MAXPOS)
      DO 310 J = 1, IEREP
        NELM = NELM + 1
        IPOS = IPOS + 1
        ITEM(IPOS) = IELEM
  310 CONTINUE
      GO TO 120
C-----------------------------------------------------------------------
  910 FORMAT('0*** ERROR *** EXPANSION OF "',A,'" FAILED'/' ')
  920 FORMAT('0... BEAM LINE "',A,'" EXPANDED:',
     +       I10,' ELEMENTS,',I10,' POSITIONS')
  930 FORMAT('0*** ERROR *** UNDEFINED ELEMENT "',A,
     +       '" ENCOUNTERED DURING EXPANSION')
  940 FORMAT('0*** ERROR *** THE BEAM LINE "',A,'" REFERS TO ITSELF')
C-----------------------------------------------------------------------
      END
      SUBROUTINE FALCT(M,N,X,FVEC,IFLAG)
C     ********************************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      PARAMETER     (MAXCOR = 600)
      COMMON/CORR/CORVAL(MAXCOR,4),ICRID(MAXCOR),
     >ICRPOS(MAXCOR),ICRSET(MAXCOR),
     >ICROPT(MAXCOR),NCORR,NCURCR,ICRFLG,ICRCHK,ALMNEL,ICRPTR,NPARC
      PARAMETER  (mxlcnd = 200)
      PARAMETER  (mxlvar = 100)
      COMMON/MONIT/VALMON(MXLCND,4,3)
      COMMON/MONFIT/VALFA(MXLCND),WGHTA(MXLCND),ERRA(MXLCND),
     >AMULTA(MXLVAR,6),ADDA(MXLVAR,6),DELA(MXLVAR)
     >,NPARA(MXLVAR,6),NELFA(MXLVAR,6),
     >NPVARA(MXLVAR),INDA(MXLVAR,6),VALR(MXLCND),RMOSIG,
     >NMONA(MXLCND),NVALA(MXLCND),NVARA,NCONDA
     >,IALFLG,MONFLG,MONLST,NOPTER,
     >IAFRST,IMOOPT,IMSBEG,NALPRT
      COMMON/CSEEDS/ISEED,IXG,IXS,IXMSTP,IMSD,IMOSTP,ISYNSD,ISYSTP,
     >ISDBEG,IBGSTP,IXES,IXESTP,IESBEG,IESTBG,isdcol
      COMMON/CFALC/IMSDSV,IMSVTP
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      DIMENSION VAL0(MXLCND),X(1),FVEC(1)
      DO 102 IFL=1,NVARA
      IF(IFL.LE.NPARC)GOTO 103
      CORVAL(NELFA(IFL,1),NPARA(IFL,1))=X(IFL)
      GOTO 102
  103 ELDAT(INDA(IFL,1))=X(IFL)
      JFL=NPVARA(IFL)
      DO 105 JAA=1,JFL
      ELDAT(INDA(IFL,JAA))=X(IFL)*AMULTA(IFL,JAA)+ADDA(IFL,JAA)
  105 CALL MATGEN(NELFA(IFL,JAA))
  102 CONTINUE
      IMOSTP=IMSVTP
      IMSD=IMSDSV
      CALL DETAIL(IEND)
      DO 200 IFL=1,NCONDA
      JAA=(NVALA(IFL)-1)/4+1
      IAA=NVALA(IFL)-(JAA-1)*4
  200 VAL0(IFL)=VALMON(IFL,IAA,JAA)
      DO 201 IFL=1,NCONDA
  201 FVEC(IFL)=(VALR(IFL)-VAL0(IFL))*WGHTA(IFL)
      RETURN
      END
      SUBROUTINE FFFCT(M,N,X,FVEC,IFLAG)
C     ********************************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXELMD = 3000)
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/LAYOUT/SHI,XHI,YHI,ZHI,THETAI,PHIHI,PSIHI,CONVH,
     >SRH,XRH,YRH,ZRH,THETAR,PHIRH,PSIRH,NLAY,layflg
      COMMON/FOUT/OUTFL(350)
      PARAMETER  (mxlvar = 100)
      PARAMETER  (mxlcnd = 200)
      COMMON/FITL/COEF(MXLVAR,6),VALF(MXLCND),
     >  WGHT(MXLCND),RVAL(MXLCND),XM(MXLVAR)
     >  ,EM(MXLVAR),WV,NELF(MXLVAR,6),NPAR(MXLVAR,6),
     >  IND(MXLVAR,6),NPVAR(MXLVAR),NVAL(MXLCND)
     >  ,NSTEP,NVAR,NCOND,ISTART,NDIV,IFITM,IFITD,IFITBM
      COMMON/LIMIT/VLO(MXLVAR),VUP(MXLVAR),WLIM(MXLVAR),
     >  DIS(MXLVAR),NELLIM(MXLVAR),
     >  WGHLIM(MXLVAR),VLOLIM(MXLVAR),VUPLIM(MXLVAR),
     >  DISLIM(MXLVAR),NPRLIM(MXLVAR),IFLCST,LIMFLG,NLIM,NEXP
      DIMENSION X(nvar),FVEC(ncond)
      COMMON/CNEWLN/NEWLEN
      LOGICAL NEWLEN
      DO 100 I=1,NVAR
      JF=NPVAR(I)
      VXT=X(I)
      IF((LIMFLG.NE.0).AND.(WGHLIM(I).NE.0.0D0))THEN
        ALO=VLOLIM(I)
        AUP=VUPLIM(I)
        ADIS=DISLIM(I)
        IF(VXT.LE.ALO) VXT=(ADIS**2*(ALO-ADIS)*(VXT-ALO)+2.0D0*ALO)/
     >                   (ADIS**2*(VXT-ALO)+2.0D0)
        IF(VXT.GE.AUP) VXT=(ADIS**2*(AUP+ADIS)*(VXT-AUP)+2.0D0*AUP)/
     >                   (ADIS**2*(VXT-AUP)+2.0D0)
C        amid=0.5d0*(alo+aup)
C        vxt=amid+(aup-alo)*datan(vxt)/pi
      ENDIF
      VAL=ELDAT(IND(I,1))
      IF(VAL.EQ.VXT)GOTO 100
      DO 200 J=1,JF
      ELDAT(IND(I,J))=VXT*COEF(I,J)
      CALL MATGEN(NELF(I,J))
  200 CONTINUE
  100 CONTINUE
      IF(NEWLEN)CALL LENG
      IF(IFITM.EQ.0)GOTO 1
      CALL MATRIX
      IF(IFITM.EQ.2)CALL ANAL
    1 IF(IFITD.EQ.1)CALL DETAIL(IEND)
      IF(NLAY.EQ.1)CALL HWPNT
      CALL SETOUT
      DO 300 IC=1,NCOND
  300 FVEC(IC)=(OUTFL(NVAL(IC))-RVAL(IC))*WGHT(IC)
C     WRITE(IOUT,400)(X(IC),FVEC(IC),IC=1,NCOND)
C 400 FORMAT('  IN FFFCT X FVEC ',/,2(2E14.5))
      RETURN
      END

      SUBROUTINE FFT(A,B,NTOT,N,NSPAN,ISN)
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
C  MULTIVARIATE COMPLEX FOURIER TRANSFORM, COMPUTED IN PLACE
C    USING MIXED-RADIX FAST FOURIER TRANSFORM ALGORITHM.
C  BY R. C. SINGLETON, STANFORD RESEARCH INSTITUTE, SEPT. 1968
C  ARRAYS A AND B ORIGINALLY HOLD THE REAL AND IMAGINARY
C    COMPONENTS OF THE DATA, AND RETURN THE REAL AND
C    IMAGINARY COMPONENTS OF THE RESULTING FOURIER COEFFICIENTS.
C  MULTIVARIATE DATA IS INDEXED ACCORDING TO THE FORTRAN
C    ARRAY ELEMENT SUCCESSOR FUNCTION, WITHOUT LIMIT
C    ON THE NUMBER OF IMPLIED MULTIPLE SUBSCRIPTS.
C    THE SUBROUTINE IS CALLED ONCE FOR EACH VARIATE.
C    THE CALLS FOR A MULTIVARIATE TRANSFORM MAY BE IN ANY ORDER.
C  NTOT IS THE TOTAL NUMBER OF COMPLEX DATA VALUES.
C  N IS THE DIMENSION OF THE CURRENT VARIABLE.
C  NSPAN/N IS THE SPACING OF CONSECUTIVE DATA VALUES
C    WHILE INDEXING THE CURRENT VARIABLE.
C  THE SIGN OF ISN DETERMINES THE SIGN OF THE COMPLEX
C    EXPONENTIAL, AND THE MAGNITUDE OF ISN IS NORMALLY ONE.
C  A TRI-VARIATE TRANSFORM WITH A(N1,N2,N3), B(N1,N2,N3)
C    IS COMPUTED BY
C      CALL FFT(A,B,N1*N2*N3,N1,N1,1)
C      CALL FFT(A,B,N1*N2*N3,N2,N1*N2,1)
C      CALL FFT(A,B,N1*N2*N3,N3,N1*N2*N3,1)
C  FOR A SINGLE-VARIATE TRANSFORM,
C    NTOT = N = NSPAN = (NUMBER OF COMPLEX DATA VALUES), E.G.
C      CALL FFT(A,B,N,N,N,1)
C  THE DATA CAN ALTERNATIVELY BE STORED IN A SINGLE COMPLEX ARRAY C
C    IN STANDARD FORTRAN FASHION, I.E. ALTERNATING REAL AND IMAGINARY
C    PARTS. THEN WITH MOST FORTRAN COMPILERS, THE COMPLEX ARRAY C CAN
C    BE EQUIVALENCED TO A REAL ARRAY A, THE MAGNITUDE OF ISN CHANGED
C    TO TWO TO GIVE CORRECT INDEXING INCREMENT, AND A(1) AND A(2) USED
C    TO PASS THE INITIAL ADDRESSES FOR THE SEQUENCES OF REAL AND
C    IMAGINARY VALUES, E.G.
C       COMPLEX C(NTOT)
C       REAL    A(2*NTOT)
C       EQUIVALENCE (C(1),A(1))
C       CALL FFT(A(1),A(2),NTOT,N,NSPAN,2)
C  ARRAYS AT(MAXF), CK(MAXF), BT(MAXF), SK(MAXF), AND NP(MAXP)
C    ARE USED FOR TEMPORARY STORAGE.  IF THE AVAILABLE STORAGE
C    IS INSUFFICIENT, THE PROGRAM IS TERMINATED BY A STOP.
C    MAXF MUST BE .GE. THE MAXIMUM PRIME FACTOR OF N.
C    MAXP MUST BE .GT. THE NUMBER OF PRIME FACTORS OF N.
C    IN ADDITION, IF THE SQUARE-FREE PORTION K OF N HAS TWO OR
C    MORE PRIME FACTORS, THEN MAXP MUST BE .GE. K-1.
      DIMENSION A(1),B(1)
C  ARRAY STORAGE IN NFAC FOR A MAXIMUM OF 15 PRIME FACTORS OF N.
C  IF N HAS MORE THAN ONE SQUARE-FREE FACTOR, THE PRODUCT OF THE
C    SQUARE-FREE FACTORS MUST BE .LE. 210
      DIMENSION NFAC(11),NP(209)
C  ARRAY STORAGE FOR MAXIMUM PRIME FACTOR OF 23
      DIMENSION AT(23),CK(23),BT(23),SK(23)
      EQUIVALENCE (I,II)
C  THE FOLLOWING TWO CONSTANTS SHOULD AGREE WITH THE ARRAY DIMENSIONS.
C-----------------------------------------------------------------
CALL LIB MONITOR FROM FFT, MAINTENANCE NUMBER 427, DATE 76170
C       CALL LIBMON(427)
C***PLEASE DON'T REMOVE OR CHANGE THE ABOVE CALL. IT IS YOUR ONLY
C***PROTECTION AGAINST YOUR USING AN OUT-OF-DATE OF INCORRECT
C***VERSION OF THE ROUTINE. THE LIBRARY MONITOR REMOVES THIS CALL,
C***SO IT ONLY OCCURS ONCE, ON THE FIRST ENTRY TO THIS ROUTINE.
C-----------------------------------------------------------------
      MAXF=23
      MAXP=209
      IF(N .LT. 2) RETURN
      INC=ISN
      C72=0.30901699437494742
      S72=0.95105651629515357
      S120=0.86602540378443865
      RAD=6.2831853071796
      IF(ISN .GE. 0) GO TO 10
      S72=-S72
      S120=-S120
      RAD=-RAD
      INC=-INC
   10 NT=INC*NTOT
      KS=INC*NSPAN
      KSPAN=KS
      NN=NT-INC
      JC=KS/N
      RADF=RAD*FLOAT(JC)*0.5
      I=0
      JF=0
C  DETERMINE THE FACTORS OF N
      M=0
      K=N
      GO TO 20
   15 M=M+1
      NFAC(M)=4
      K=K/16
   20 IF(K-(K/16)*16 .EQ. 0) GO TO 15
      J=3
      JJ=9
      GO TO 30
   25 M=M+1
      NFAC(M)=J
      K=K/JJ
   30 IF(MOD(K,JJ) .EQ. 0) GO TO 25
      J=J+2
      JJ=J**2
      IF(JJ .LE. K) GO TO 30
      IF(K .GT. 4) GO TO 40
      KT=M
      NFAC(M+1)=K
      IF(K .NE. 1) M=M+1
      GO TO 80
   40 IF(K-(K/4)*4 .NE. 0) GO TO 50
      M=M+1
      NFAC(M)=2
      K=K/4
   50 KT=M
      J=2
   60 IF(MOD(K,J) .NE. 0) GO TO 70
      M=M+1
      NFAC(M)=J
      K=K/J
   70 J=((J+1)/2)*2+1
      IF(J .LE. K) GO TO 60
   80 IF(KT .EQ. 0) GO TO 100
      J=KT
   90 M=M+1
      NFAC(M)=NFAC(J)
      J=J-1
      IF(J .NE. 0) GO TO 90
C  COMPUTE FOURIER TRANSFORM
  100 SD=RADF/FLOAT(KSPAN)
      CD=2.0*SIN(SD)**2
      SD=SIN(SD+SD)
      KK=1
      I=I+1
      IF(NFAC(I) .NE. 2) GO TO 400
C  TRANSFORM FOR FACTOR OF 2 (INCLUDING ROTATION FACTOR)
      KSPAN=KSPAN/2
      K1=KSPAN+2
  210 K2=KK+KSPAN
      AK=A(K2)
      BK=B(K2)
      A(K2)=A(KK)-AK
      B(K2)=B(KK)-BK
      A(KK)=A(KK)+AK
      B(KK)=B(KK)+BK
      KK=K2+KSPAN
      IF(KK .LE. NN) GO TO 210
      KK=KK-NN
      IF(KK .LE. JC) GO TO 210
      IF(KK .GT. KSPAN) GO TO 800
  220 C1=1.0-CD
      S1=SD
  230 K2=KK+KSPAN
      AK=A(KK)-A(K2)
      BK=B(KK)-B(K2)
      A(KK)=A(KK)+A(K2)
      B(KK)=B(KK)+B(K2)
      A(K2)=C1*AK-S1*BK
      B(K2)=S1*AK+C1*BK
      KK=K2+KSPAN
      IF(KK .LT. NT) GO TO 230
      K2=KK-NT
      C1=-C1
      KK=K1-K2
      IF(KK .GT. K2) GO TO 230
      AK=C1-(CD*C1+SD*S1)
      S1=(SD*C1-CD*S1)+S1
      C1=2.0-(AK**2+S1**2)
      S1=C1*S1
      C1=C1*AK
      KK=KK+JC
      IF(KK .LT. K2) GO TO 230
      K1=K1+INC+INC
      KK=(K1-KSPAN)/2+JC
      IF(KK .LE. JC+JC) GO TO 220
      GO TO 100
C  TRANSFORM FOR FACTOR OF 3 (OPTIONAL CODE)
  320 K1=KK+KSPAN
      K2=K1+KSPAN
      AK=A(KK)
      BK=B(KK)
      AJ=A(K1)+A(K2)
      BJ=B(K1)+B(K2)
      A(KK)=AK+AJ
      B(KK)=BK+BJ
      AK=-0.5*AJ+AK
      BK=-0.5*BJ+BK
      AJ=(A(K1)-A(K2))*S120
      BJ=(B(K1)-B(K2))*S120
      A(K1)=AK-BJ
      B(K1)=BK+AJ
      A(K2)=AK+BJ
      B(K2)=BK-AJ
      KK=K2+KSPAN
      IF(KK .LT. NN) GO TO 320
      KK=KK-NN
      IF(KK .LE. KSPAN) GO TO 320
      GO TO 700
C  TRANSFORM FOR FACTOR OF 4
  400 IF(NFAC(I) .NE. 4) GO TO 600
      KSPNN=KSPAN
      KSPAN=KSPAN/4
  410 C1=1.0
      S1=0
  420 K1=KK+KSPAN
      K2=K1+KSPAN
      K3=K2+KSPAN
      AKP=A(KK)+A(K2)
      AKM=A(KK)-A(K2)
      AJP=A(K1)+A(K3)
      AJM=A(K1)-A(K3)
      A(KK)=AKP+AJP
      AJP=AKP-AJP
      BKP=B(KK)+B(K2)
      BKM=B(KK)-B(K2)
      BJP=B(K1)+B(K3)
      BJM=B(K1)-B(K3)
      B(KK)=BKP+BJP
      BJP=BKP-BJP
      IF(ISN .LT. 0) GO TO 450
      AKP=AKM-BJM
      AKM=AKM+BJM
      BKP=BKM+AJM
      BKM=BKM-AJM
      IF(S1 .EQ. 0) GO TO 460
  430 A(K1)=AKP*C1-BKP*S1
      B(K1)=AKP*S1+BKP*C1
      A(K2)=AJP*C2-BJP*S2
      B(K2)=AJP*S2+BJP*C2
      A(K3)=AKM*C3-BKM*S3
      B(K3)=AKM*S3+BKM*C3
      KK=K3+KSPAN
      IF(KK .LE. NT) GO TO 420
  440 C2=C1-(CD*C1+SD*S1)
      S1=(SD*C1-CD*S1)+S1
      C1=2.0-(C2**2+S1**2)
      S1=C1*S1
      C1=C1*C2
      C2=C1**2-S1**2
      S2=2.0*C1*S1
      C3=C2*C1-S2*S1
      S3=C2*S1+S2*C1
      KK=KK-NT+JC
      IF(KK .LE. KSPAN) GO TO 420
      KK=KK-KSPAN+INC
      IF(KK .LE. JC) GO TO 410
      IF(KSPAN .EQ. JC) GO TO 800
      GO TO 100
  450 AKP=AKM+BJM
      AKM=AKM-BJM
      BKP=BKM-AJM
      BKM=BKM+AJM
      IF(S1 .NE. 0) GO TO 430
  460 A(K1)=AKP
      B(K1)=BKP
      A(K2)=AJP
      B(K2)=BJP
      A(K3)=AKM
      B(K3)=BKM
      KK=K3+KSPAN
      IF(KK .LE. NT) GO TO 420
      GO TO 440
C  TRANSFORM FOR FACTOR OF 5 (OPTIONAL CODE)
  510 C2=C72**2-S72**2
      S2=2.0*C72*S72
  520 K1=KK+KSPAN
      K2=K1+KSPAN
      K3=K2+KSPAN
      K4=K3+KSPAN
      AKP=A(K1)+A(K4)
      AKM=A(K1)-A(K4)
      BKP=B(K1)+B(K4)
      BKM=B(K1)-B(K4)
      AJP=A(K2)+A(K3)
      AJM=A(K2)-A(K3)
      BJP=B(K2)+B(K3)
      BJM=B(K2)-B(K3)
      AA=A(KK)
      BB=B(KK)
      A(KK)=AA+AKP+AJP
      B(KK)=BB+BKP+BJP
      AK=AKP*C72+AJP*C2+AA
      BK=BKP*C72+BJP*C2+BB
      AJ=AKM*S72+AJM*S2
      BJ=BKM*S72+BJM*S2
      A(K1)=AK-BJ
      A(K4)=AK+BJ
      B(K1)=BK+AJ
      B(K4)=BK-AJ
      AK=AKP*C2+AJP*C72+AA
      BK=BKP*C2+BJP*C72+BB
      AJ=AKM*S2-AJM*S72
      BJ=BKM*S2-BJM*S72
      A(K2)=AK-BJ
      A(K3)=AK+BJ
      B(K2)=BK+AJ
      B(K3)=BK-AJ
      KK=K4+KSPAN
      IF(KK .LT. NN) GO TO 520
      KK=KK-NN
      IF(KK .LE. KSPAN) GO TO 520
      GO TO 700
C  TRANSFORM FOR ODD FACTORS
  600 K=NFAC(I)
      KSPNN=KSPAN
      KSPAN=KSPAN/K
      IF(K .EQ. 3) GO TO 320
      IF(K .EQ. 5) GO TO 510
      IF(K .EQ. JF) GO TO 640
      JF=K
      S1=RAD/FLOAT(K)
      C1=COS(S1)
      S1=SIN(S1)
      IF(JF .GT. MAXF) GO TO 998
      CK(JF)=1.0
      SK(JF)=0.0
      J=1
  630 CK(J)=CK(K)*C1+SK(K)*S1
      SK(J)=CK(K)*S1-SK(K)*C1
      K=K-1
      CK(K)=CK(J)
      SK(K)=-SK(J)
      J=J+1
      IF(J .LT. K) GO TO 630
  640 K1=KK
      K2=KK+KSPNN
      AA=A(KK)
      BB=B(KK)
      AK=AA
      BK=BB
      J=1
      K1=K1+KSPAN
  650 K2=K2-KSPAN
      J=J+1
      AT(J)=A(K1)+A(K2)
      AK=AT(J)+AK
      BT(J)=B(K1)+B(K2)
      BK=BT(J)+BK
      J=J+1
      AT(J)=A(K1)-A(K2)
      BT(J)=B(K1)-B(K2)
      K1=K1+KSPAN
      IF(K1 .LT. K2) GO TO 650
      A(KK)=AK
      B(KK)=BK
      K1=KK
      K2=KK+KSPNN
      J=1
  660 K1=K1+KSPAN
      K2=K2-KSPAN
      JJ=J
      AK=AA
      BK=BB
      AJ=0.0
      BJ=0.0
      K=1
  670 K=K+1
      AK=AT(K)*CK(JJ)+AK
      BK=BT(K)*CK(JJ)+BK
      K=K+1
      AJ=AT(K)*SK(JJ)+AJ
      BJ=BT(K)*SK(JJ)+BJ
      JJ=JJ+J
      IF(JJ .GT. JF) JJ=JJ-JF
      IF(K .LT. JF) GO TO 670
      K=JF-J
      A(K1)=AK-BJ
      B(K1)=BK+AJ
      A(K2)=AK+BJ
      B(K2)=BK-AJ
      J=J+1
      IF(J .LT. K) GO TO 660
      KK=KK+KSPNN
      IF(KK .LE. NN) GO TO 640
      KK=KK-NN
      IF(KK .LE. KSPAN) GO TO 640
C  MULTIPLY BY ROTATION FACTOR (EXCEPT FOR FACTORS OF 2 AND 4)
  700 IF(I .EQ. M) GO TO 800
      KK=JC+1
  710 C2=1.0-CD
      S1=SD
  720 C1=C2
      S2=S1
      KK=KK+KSPAN
  730 AK=A(KK)
      A(KK)=C2*AK-S2*B(KK)
      B(KK)=S2*AK+C2*B(KK)
      KK=KK+KSPNN
      IF(KK .LE. NT) GO TO 730
      AK=S1*S2
      S2=S1*C2+C1*S2
      C2=C1*C2-AK
      KK=KK-NT+KSPAN
      IF(KK .LE. KSPNN) GO TO 730
      C2=C1-(CD*C1+SD*S1)
      S1=S1+(SD*C1-CD*S1)
      C1=2.0-(C2**2+S1**2)
      S1=C1*S1
      C2=C1*C2
      KK=KK-KSPNN+JC
      IF(KK .LE. KSPAN) GO TO 720
      KK=KK-KSPAN+JC+INC
      IF(KK .LE. JC+JC) GO TO 710
      GO TO 100
C  PERMUTE THE RESULTS TO NORMAL ORDER---DONE IN TWO STAGES
C  PERMUTATION FOR SQUARE FACTORS OF N
  800 NP(1)=KS
      IF(KT .EQ. 0) GO TO 890
      K=KT+KT+1
      IF(M .LT. K) K=K-1
      J=1
      NP(K+1)=JC
  810 NP(J+1)=NP(J)/NFAC(J)
      NP(K)=NP(K+1)*NFAC(J)
      J=J+1
      K=K-1
      IF(J .LT. K) GO TO 810
      K3=NP(K+1)
      KSPAN=NP(2)
      KK=JC+1
      K2=KSPAN+1
      J=1
      IF(N .NE. NTOT) GO TO 850
C  PERMUTATION FOR SINGLE-VARIATE TRANSFORM (OPTIONAL CODE)
  820 AK=A(KK)
      A(KK)=A(K2)
      A(K2)=AK
      BK=B(KK)
      B(KK)=B(K2)
      B(K2)=BK
      KK=KK+INC
      K2=KSPAN+K2
      IF(K2 .LT. KS) GO TO 820
  830 K2=K2-NP(J)
      J=J+1
      K2=NP(J+1)+K2
      IF(K2 .GT. NP(J)) GO TO 830
      J=1
  840 IF(KK .LT. K2) GO TO 820
      KK=KK+INC
      K2=KSPAN+K2
      IF(K2 .LT. KS) GO TO 840
      IF(KK .LT. KS) GO TO 830
      JC=K3
      GO TO 890
C  PERMUTATION FOR MULTIVARIATE TRANSFORM
  850 K=KK+JC
  860 AK=A(KK)
      A(KK)=A(K2)
      A(K2)=AK
      BK=B(KK)
      B(KK)=B(K2)
      B(K2)=BK
      KK=KK+INC
      K2=K2+INC
      IF(KK .LT. K) GO TO 860
      KK=KK+KS-JC
      K2=K2+KS-JC
      IF(KK .LT. NT) GO TO 850
      K2=K2-NT+KSPAN
      KK=KK-NT+JC
      IF(K2 .LT. KS) GO TO 850
  870 K2=K2-NP(J)
      J=J+1
      K2=NP(J+1)+K2
      IF(K2 .GT. NP(J)) GO TO 870
      J=1
  880 IF(KK .LT. K2) GO TO 850
      KK=KK+JC
      K2=KSPAN+K2
      IF(K2 .LT. KS) GO TO 880
      IF(KK .LT. KS) GO TO 870
      JC=K3
  890 IF(2*KT+1 .GE. M) RETURN
      KSPNN=NP(KT+1)
C  PERMUTATION FOR SQUARE-FREE FACTORS OF N
      J=M-KT
      NFAC(J+1)=1
  900 NFAC(J)=NFAC(J)*NFAC(J+1)
      J=J-1
      IF(J .NE. KT) GO TO 900
      KT=KT+1
      NN=NFAC(KT)-1
      IF(NN .GT. MAXP) GO TO 998
      JJ=0
      J=0
      GO TO 906
  902 JJ=JJ-K2
      K2=KK
      K=K+1
      KK=NFAC(K)
  904 JJ=KK+JJ
      IF(JJ .GE. K2) GO TO 902
      NP(J)=JJ
  906 K2=NFAC(KT)
      K=KT+1
      KK=NFAC(K)
      J=J+1
      IF(J .LE. NN) GO TO 904
C  DETERMINE THE PERMUTATION CYCLES OF LENGTH GREATER THAN 1
      J=0
      GO TO 914
  910 K=KK
      KK=NP(K)
      NP(K)=-KK
      IF(KK .NE. J) GO TO 910
      K3=KK
  914 J=J+1
      KK=NP(J)
      IF(KK .LT. 0) GO TO 914
      IF(KK .NE. J) GO TO 910
      NP(J)=-J
      IF(J .NE. NN) GO TO 914
      MAXF=INC*MAXF
C  REORDER A AND B, FOLLOWING THE PERMUTATION CYCLES
      GO TO 950
  924 J=J-1
      IF(NP(J) .LT. 0) GO TO 924
      JJ=JC
  926 KSPAN=JJ
      IF(JJ .GT. MAXF) KSPAN=MAXF
      JJ=JJ-KSPAN
      K=NP(J)
      KK=JC*K+II+JJ
      K1=KK+KSPAN
      K2=0
  928 K2=K2+1
      AT(K2)=A(K1)
      BT(K2)=B(K1)
      K1=K1-INC
      IF(K1 .NE. KK) GO TO 928
  932 K1=KK+KSPAN
      K2=K1-JC*(K+NP(K))
      K=-NP(K)
  936 A(K1)=A(K2)
      B(K1)=B(K2)
      K1=K1-INC
      K2=K2-INC
      IF(K1 .NE. KK) GO TO 936
      KK=K2
      IF(K .NE. J) GO TO 932
      K1=KK+KSPAN
      K2=0
  940 K2=K2+1
      A(K1)=AT(K2)
      B(K1)=BT(K2)
      K1=K1-INC
      IF(K1 .NE. KK) GO TO 940
      IF(JJ .NE. 0) GO TO 926
      IF(J .NE. 1) GO TO 924
  950 J=K3+1
      NT=NT-KSPNN
      II=NT-INC+1
      IF(NT .GE. 0) GO TO 924
      RETURN
C  ERROR FINISH, INSUFFICIENT ARRAY STORAGE
  998 ISN=0
      PRINT 999
      STOP
  999 FORMAT(44H0ARRAY BOUNDS EXCEEDED WITHIN SUBROUTINE FFT)
      END
C     ***********************
      SUBROUTINE FFTAN(IEND)
C     ********************************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER  (MXGACA = 15)
      PARAMETER  (MXGATR = 1030)
      COMMON/GEOM/XCO,XPCO,YCO,YPCO,NCASE,NJOB,
     <    EPSX(MXGACA),EPSY(MXGACA),XI(MXGACA),YI(MXGACA),
     <    XG(MXGATR,MXGACA),
     <    XPG(MXGATR,MXGACA),YG(MXGATR,MXGACA),YPG(MXGATR,MXGACA),
     <    LCASE(MXGACA)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      PARAMETER    (mxpart = 128000)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      COMMON/PLT/
     1XMIN,XMAX,YMIN,YMAX,XPMIN,XPMAX,YPMIN,YPMAX,ALMIN,ALMAX,
     >DELMIN,DELMAX,DNUMIN,DNUMAX,DBMIN,DBMAX,
     2MALL,NPLOT,NCCUM,NGRAPH,NCOL,NLINE
      COMMON/CHPLT/MXXPR,MYYPR,MXY,MALE
      CHARACTER*1 MALE(101,51),MXXPR(101,51),MYYPR(101,51),MXY(101,51)
      COMMON/CFFT/fbetax,falphx,fbetay,falphy,fnux,fnuy,ifftan,nprplt
      COMMON/ANALC/COMPF,RNU0X,CETAX,CETAPX,CALPHX,CBETAX,
     1RMU1X,CHROMX,ALPH1X,BETA1X,
     1RMU0Y,RNU0Y,CETAY,CETAPY,CALPHY,CBETAY,
     1RMU1Y,CHROMY,ALPH1Y,BETA1Y,RMU0X,CDETAX,CDETPX,CDETAY,CDETPY,
     >COSX,ALX1,ALX2,VX1,VXP1,VX2,VXP2,
     >COSY,ALY1,ALY2,VY1,VYP1,VY2,VYP2,NSTABX,NSTABY,NSTAB,NWRNCP
      DIMENSION X(1024),XP(1024),Y(1024),YP(1024)
      EQUIVALENCE (X(1),XG(1,1)),(XP(1),XPG(1,1))
      EQUIVALENCE (Y(1),YG(1,1)),(YP(1),YPG(1,1))
      CHARACTER*28 NPTIT
      dimension xapk(50),xvpk(50),xphipk(50)
      dimension yapk(50),yvpk(50),yphipk(50)
      dimension tf(120),ior(120),jor(120)
      DATA NPTIT/'FAST FOURIER TRANSFORM TUNE '/
      NxPEAK=0
      NyPEAK=0
      NPT=NTURN
      ncol=101
      nline=51
      IPRT = MOD(NPRPLT,10)
      NPRPLT=(NPRPLT-IPRT)/10
      IPLT = MOD(NPRPLT,10)
      IANAL= (NPRPLT-IPLT)/10
      IF ((IPRT.GT.1).OR.(IPLT.GT.1).OR.(IANAL.GT.1)) THEN
             WRITE(IOUT,10002)
10002        FORMAT('  WRONG PRINT,PLOT ANALYSIS FLAG ')
             RETURN
      ENDIF
      sbetax=dsqrt(fbetax)
      sbetay=dsqrt(fbetay)
      DO 10 I=1,NPT
      XP(I)=XP(I)*sbetax+fALPHX*X(I)/sBETAX
      x(i)=x(i)/sbetax
      x(i)=dsqrt(x(i)**2+xp(i)**2)
      xp(i)=0.0d0
      YP(I)=YP(I)*sbetay+fALPHY*Y(I)/sBETAY
      y(i)=y(i)/sbetay
      y(i)=dsqrt(y(i)**2+yp(i)**2)
      yp(i)=0.0d0
   10 CONTINUE
      DO 3 I=1,NPT
      FACT=0.5D0 - 0.5D0*(DCOS((I-1)*TWOPI/NPT))
      X(I)=FACT*X(I)
      XP(I)=FACT*XP(I)
      Y(I)=FACT*Y(I)
      YP(I)=FACT*YP(I)
    3 CONTINUE
      CALL FFT(X,XP,NPT,NPT,NPT,1)
      CALL FFT(Y,YP,NPT,NPT,NPT,1)
      IF(IPRT.NE.0) WRITE(IOUT,10005)
10005 FORMAT(/,'   FOURIER ANALYSIS PRINTOUT  ',/)
      cmax=0.0d0
      dmax=0.0d0
      nhpt=npt/2
      do 21 i=1,nhpt
      C=SQRT(X(I)**2+XP(I)**2)
      D=SQRT(Y(I)**2+YP(I)**2)
      if(i.le.3) then
      c=0.0d0
      d=0.0d0
      endif
      if(c.gt.cmax)cmax=c
      if(d.gt.dmax)dmax=d
   21 continue
      kpnt=1
      logpar(1)=.true.
      DO 2 I=1,NhPT
      C=SQRT(X(I)**2+XP(I)**2)/cmax
C      C=DLOG(C)
      D=SQRT(Y(I)**2+YP(I)**2)/dmax
C      D=DLOG(D)
      ABSC=FLOAT(I-1)/FLOAT(NPT)
      YCOORD=(C+D)/2.0D0
      IF(IPRT.NE.0)WRITE(IOUT,40000)ABSC,C,D,YCOORD
40000 FORMAT(4E13.5,' 0 ')
      IF(IPLT.NE.0) THEN
          NCHAR=39
        if((absc.ge.0.0).and.(absc.le.0.1))then
          nzero=1
          if(absc.eq.0.0)nzero=0
          nprt1=1
          NPRINT=0
          yplmin=0.0d0
          yplmax=2.0d0
          xplmin=0.0d0
          xplmax=0.1d0
          nchar=33
          vc=c+1.0d0
          CALL PLOT(ABSC,vc,KPNT,XPLMAX,XPLMIN,YPLMAX,YPLMIN,
     >        NPRINT,NZERO,NCHAR,NCOL,NLINE,NPTIT,MXY,LOGPAR)
          nchar=34
          vc=d
          nzero=1
          CALL PLOT(ABSC,vc,KPNT,XPLMAX,XPLMIN,YPLMAX,YPLMIN,
     >        NPRINT,NZERO,NCHAR,NCOL,NLINE,NPTIT,MXY,LOGPAR)
        endif
        if((absc.ge.0.1).and.(absc.le.0.2))then
            if(nprt1.eq.1) then
              WRITE(IOUT,10003)
10003 FORMAT('1')
              NPRINT=1
              nchar=42
          CALL PLOT(ABSC,vC,KPNT,XPLMAX,XPLMIN,YPLMAX,YPLMIN,
     >        NPRINT,NZERO,NCHAR,NCOL,NLINE,NPTIT,MXY,LOGPAR)
              nprt1=0
              nzero=0
              nprint=0
            endif
          nprt2=1
          xplmin=0.1d0
          xplmax=0.2d0
          nchar=33
          vc=c+1.0d0
          CALL PLOT(ABSC,vc,KPNT,XPLMAX,XPLMIN,YPLMAX,YPLMIN,
     >        NPRINT,NZERO,NCHAR,NCOL,NLINE,NPTIT,MXY,LOGPAR)
          nchar=34
          vc=d
          nzero=1
          CALL PLOT(ABSC,vc,KPNT,XPLMAX,XPLMIN,YPLMAX,YPLMIN,
     >        NPRINT,NZERO,NCHAR,NCOL,NLINE,NPTIT,MXY,LOGPAR)
        endif
        if((absc.ge.0.2).and.(absc.le.0.3))then
            if(nprt2.eq.1) then
C              WRITE(IOUT,10003)
              NPRINT=1
              nchar=42
          CALL PLOT(ABSC,vC,KPNT,XPLMAX,XPLMIN,YPLMAX,YPLMIN,
     >        NPRINT,NZERO,NCHAR,NCOL,NLINE,NPTIT,MXY,LOGPAR)
              nprt2=0
              nzero=0
              nprint=0
            endif
          nprt3=1
          xplmin=0.2d0
          xplmax=0.3d0
          nchar=33
          vc=c+1.0d0
          CALL PLOT(ABSC,vc,KPNT,XPLMAX,XPLMIN,YPLMAX,YPLMIN,
     >        NPRINT,NZERO,NCHAR,NCOL,NLINE,NPTIT,MXY,LOGPAR)
          nchar=34
          vc=d
          nzero=1
          CALL PLOT(ABSC,vc,KPNT,XPLMAX,XPLMIN,YPLMAX,YPLMIN,
     >        NPRINT,NZERO,NCHAR,NCOL,NLINE,NPTIT,MXY,LOGPAR)
        endif
        if((absc.ge.0.3).and.(absc.le.0.4))then
            if(nprt3.eq.1) then
C              WRITE(IOUT,10003)
              NPRINT=1
              nchar=42
          CALL PLOT(ABSC,vC,KPNT,XPLMAX,XPLMIN,YPLMAX,YPLMIN,
     >        NPRINT,NZERO,NCHAR,NCOL,NLINE,NPTIT,MXY,LOGPAR)
              nprt3=0
              nzero=0
              nprint=0
            endif
          nprt4=1
          xplmin=0.3d0
          xplmax=0.4d0
          nchar=33
          vc=c+1.0d0
          CALL PLOT(ABSC,vc,KPNT,XPLMAX,XPLMIN,YPLMAX,YPLMIN,
     >        NPRINT,NZERO,NCHAR,NCOL,NLINE,NPTIT,MXY,LOGPAR)
          nchar=34
          vc=d
          nzero=1
          CALL PLOT(ABSC,vc,KPNT,XPLMAX,XPLMIN,YPLMAX,YPLMIN,
     >        NPRINT,NZERO,NCHAR,NCOL,NLINE,NPTIT,MXY,LOGPAR)
        endif
        if((absc.ge.0.4).and.(absc.le.0.5))then
            if(nprt4.eq.1) then
C              WRITE(IOUT,10003)
              NPRINT=1
              nchar=42
          CALL PLOT(ABSC,vC,KPNT,XPLMAX,XPLMIN,YPLMAX,YPLMIN,
     >        NPRINT,NZERO,NCHAR,NCOL,NLINE,NPTIT,MXY,LOGPAR)
              nprt4=0
              nzero=0
              nprint=0
            endif
          nprt5=1
          xplmin=0.4d0
          xplmax=0.5d0
          nchar=33
          vc=c+1.0d0
          CALL PLOT(ABSC,vc,KPNT,XPLMAX,XPLMIN,YPLMAX,YPLMIN,
     >        NPRINT,NZERO,NCHAR,NCOL,NLINE,NPTIT,MXY,LOGPAR)
          nchar=34
          vc=d
          nzero=1
          CALL PLOT(ABSC,vc,KPNT,XPLMAX,XPLMIN,YPLMAX,YPLMIN,
     >        NPRINT,NZERO,NCHAR,NCOL,NLINE,NPTIT,MXY,LOGPAR)
        endif
            if((nprt5.eq.1).and.(i.eq.nhpt)) then
C              WRITE(IOUT,10003)
              NPRINT=1
              nchar=42
          CALL PLOT(ABSC,vC,KPNT,XPLMAX,XPLMIN,YPLMAX,YPLMIN,
     >        NPRINT,NZERO,NCHAR,NCOL,NLINE,NPTIT,MXY,LOGPAR)
              nprt5=0
              nzero=0
              nprint=0
            endif
      ENDIF
      IF (IANAL.NE.0) THEN
          IF(I.GT.2)THEN
                X3=c
                Dx1=X2-X1
                Dx3=X2-X3
                IF((X2.GT.0.0300D0).AND.
     >            (((Dx1.GT.0.0D0).AND.(Dx3.GE.0.0D0)).OR.
     >            ((Dx1.GE.0.0D0).AND.(Dx3.GT.0.0D0)))) THEN
                    apk=(X1-X3)/((X1-2.0D0*X2+X3)*2.0D0)+
     >                   DFLOAT(I-2)
                    vpk=x3*(apk-i+3)*(apk-i+2)/2.0d0
     >                 +x1*(apk-i+2)*(apk-i+1)/2.0d0
     >                 -x2*(apk-i+3)*(apk-i+1)
                    phi1=datan2(xp(i-2),x(i-2))
                    phi2=datan2(xp(i-1),x(i-1))
                    phi3=datan2(xp(i),x(i))
                    phipk=phi3*(apk-i+3)*(apk-i+2)/2.0d0
     >                 +phi1*(apk-i+2)*(apk-i+1)/2.0d0
     >                 -phi2*(apk-i+3)*(apk-i+1)
                    if(nxpeak.eq.50) then
                    write(iout,*)' too many x peaks : 50 kept only'
                    endif
                    NxPEAK=NxPEAK+1
                    if(nxpeak.le.50) then
                    Xapk(NxPEAK)=apk/npt
                    Xvpk(nxpeak)=vpk
                    xphipk(nxpeak)=phipk/crdeg
                    endif
                 ENDIF
                 X1=X2
                 X2=X3
          ENDIF
          IF(I.EQ.1)x1=d
          IF(I.EQ.2)x2=d
          IF(I.GT.2)THEN
                Y3=d
                Dy1=Y2-Y1
                Dy3=Y2-Y3
                IF((Y2.GT.0.030D0).AND.
     >            (((Dy1.GT.0.0D0).AND.(Dy3.GE.0.0D0)).OR.
     >            ((Dy1.GE.0.0D0).AND.(Dy3.GT.0.0D0)))) THEN
                    apk=(Y1-Y3)/((Y1-2.0D0*Y2+Y3)*2.0D0)+
     >                   DFLOAT(I-2)
                    vpk=y3*(apk-i+3)*(apk-i+2)/2.0d0
     >                 +y1*(apk-i+2)*(apk-i+1)/2.0d0
     >                 -y2*(apk-i+3)*(apk-i+1)
                    phi1=datan2(yp(i-2),y(i-2))
                    phi2=datan2(yp(i-1),y(i-1))
                    phi3=datan2(yp(i),y(i))
                    phipk=phi3*(apk-i+3)*(apk-i+2)/2.0d0
     >                 +phi1*(apk-i+2)*(apk-i+1)/2.0d0
     >                 -phi2*(apk-i+3)*(apk-i+1)
                    if(nypeak.eq.50)then
                    write(iout,*)' too many ypeaks : 50 kept only'
                    endif
                    NyPEAK=NyPEAK+1
                    if(nypeak.le.50) then
                    Yapk(NyPEAK)=apk/npt
                    Yvpk(nypeak)=vpk
                    yphipk(nypeak)=phipk/crdeg
                    endif
                 ENDIF
                 Y1=Y2
                 Y2=Y3
          ENDIF
          IF(I.EQ.1)y1=d
          IF(I.EQ.2)y2=d
      ENDIF
    2 CONTINUE
      IF(IANAL.NE.0) THEN
      write(iout,40100)cmax,dmax
40100 format(/,'  unit x is : ',e10.3,'  unit y is : ',e10.3,/)
           npeak=max(nxpeak,nypeak)
**           write(iout,10010)
*10010 format('1',//,14x,'    x tune peaks',24x,'y tune peaks ',//)
*           write(iout,10011)
*10011 format(7x,' tune ',5x,' amplitude',3x,' phase ',6x,
*     >          ' tune ',5x,' amplitude',3x,' phase ',/)
*           DO 20 IPK=1,NPEAK
*           if(ipk.gt.nxpeak) then
*           WRITE(IOUT,10015)yapk(ipk),yvpk(ipk),yphipk(ipk)
*10015      FORMAT(5x,9x,5x,7x,17x,f9.5,5x,f7.3,5x,f7.2)
*                             else
*            if(ipk.gt.nypeak)   then
*           WRITE(IOUT,10016)Xapk(IPK),xvpk(ipk),xphipk(ipk)
*10016      FORMAT(5x,F9.5,5x,f7.3,5x,f7.2)
*                                else
*           WRITE(IOUT,10014)Xapk(IPK),xvpk(ipk),xphipk(ipk),
*     >                      yapk(ipk),yvpk(ipk),yphipk(ipk)
*10014      FORMAT(5x,F9.5,5x,f7.3,5x,f7.2,5x,f9.5,5x,f7.3,5x,f7.2)
*            endif
*           endif
*   20      CONTINUE
           kr=0
           do 30 m=2,10
           do 30 i=0,m
           j=m-i
           tunep=i*fnux+j*fnuy
           tunep=dmod(tunep,1.0d0)
           tfftp=dabs(tunep)
           if(tfftp.gt.0.5d0)tfftp=1.0d0-tfftp
           kr=kr+1
           ior(kr)=i
           jor(kr)=j
           tf(kr)=tfftp
c           write(iout,10030)i,j,tunep,tfftp
c10030 format(10x ,i2,' nux + ',i2,' nuy : ',2f9.5)
           if((i.ne.0).and.(j.ne.0))  then
             tunem=i*fnux-j*fnuy
             tunem=dmod(tunem,1.0d0)
             tfftm=dabs(tunem)
             if(tfftm.gt.0.5d0) tfftm=1.0d0-tfftm
             kr=kr+1
             ior(kr)=i
             jor(kr)=-j
             tf(kr)=tfftm
c             write(iout,10031)i,j,tunem,tfftm
c10031 format(10x ,i2,' nux - ',i2,' nuy : ',2f9.5)
           endif
   30      continue
      ENDIF
      m=kr
   52 tst=0.0d0
      do 50 l=1,m
      if(tf(l).ge.tst)then
        io=l
        isv=ior(io)
        jsv=jor(io)
        tst=tf(l)
      endif
   50 continue
      do 51 n=io+1,m
      ior(n-1)=ior(n)
      jor(n-1)=jor(n)
   51 tf(n-1) =tf(n)
      ior(m)=isv
      jor(m)=jsv
      tf(m) =tst
      m=m-1
      if(m.ge.2) goto 52
      write(iout,10044)
10044 format(/,20x,'    X-tune peaks  identification  ',//,7x,
     > ' tune       amplitude     phase      identification  ',
     > '   accuracy ',/)
      do 40 ipk=1,nxpeak
      do 41 ik=1,kr
      if(xapk(ipk).lt.tf(ik)) goto 42
   41 continue
      ik=ik-1
   42 d=(tf(ik)-tf(ik-1))/2.0d0
      d1=xapk(ipk)-tf(ik-1)
      if(d1.le.d) then
        kw=ik-1  
                  else
        kw=ik
        d1=2.0d0*d-d1
      endif
      if(jor(kw).ge.0) write(iout,10040)
     > xapk(ipk),xvpk(ipk),xphipk(ipk),ior(kw),jor(kw),d1
10040 format(5x,f9.5,5x,f7.3,5x,f7.2,5x,i2,' nux + ',i2,' nuy ',2x,f9.5)
      if(jor(kw).lt.0) write(iout,10041)
     > xapk(ipk),xvpk(ipk),xphipk(ipk),ior(kw),-jor(kw),d1
10041 format(5x,f9.5,5x,f7.3,5x,f7.2,5x,i2,' nux - ',i2,' nuy ',2x,f9.5)
   40 continue
      write(iout,10045)
10045 format(/,20x,'    Y-tune peaks  identification  ',//,7x,
     > ' tune       amplitude     phase      identification  ',
     > '   accuracy ',/)
      do 43 ipk=1,nypeak
      do 44 ik=1,kr
      if(yapk(ipk).lt.tf(ik)) goto 45
   44 continue
      ik=ik-1
   45 d=(tf(ik)-tf(ik-1))/2.0d0
      d1=yapk(ipk)-tf(ik-1)
      if(d1.le.d) then
        kw=ik-1  
                  else
        kw=ik
        d1=2.0d0*d-d1
      endif
      if(jor(kw).ge.0) write(iout,10042)
     > yapk(ipk),yvpk(ipk),yphipk(ipk),ior(kw),jor(kw),d1
10042 format(5x,f9.5,5x,f7.3,5x,f7.2,5x,i2,' nux + ',i2,' nuy ',2x,f9.5)
      if(jor(kw).lt.0) write(iout,10043)
     > yapk(ipk),yvpk(ipk),yphipk(ipk),ior(kw),-jor(kw),d1
10043 format(5x,f9.5,5x,f7.3,5x,f7.2,5x,i2,' nux - ',i2,' nuy ',2x,f9.5)
   43 continue
           write(iout,10032)
10032 format(//,'     table of resonances     ',/)
      kwt=kr/4
      do 53 kw=1,kwt
      write(iout,10052)
     >ior(kw),jor(kw),tf(kw),ior(kw+kwt),jor(kw+kwt),tf(kw+kwt),
     >ior(kw+2*kwt),jor(kw+2*kwt),tf(kw+2*kwt),
     >ior(kw+3*kwt),jor(kw+3*kwt),tf(kw+3*kwt)
10052 format(4(3x ,i2,' nux + ',i2,' nuy :',f8.5))
*      if(jor(kw).ge.0)write(iout,10050)ior(kw),jor(kw),tf(kw)
*10050 format(10x ,i2,' nux + ',i2,' nuy :',2f9.5)
*      if(jor(kw).lt.0)write(iout,10051)ior(kw),-jor(kw),tf(kw)
*10051 format(10x ,i2,' nux - ',i2,' nuy :',2f9.5)
   53 continue
      IFFTAN=0
      RETURN
      END

      subroutine filpre(iend)
C     ***********************
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON /SYMMAP/ BSYMAT(6,6,MAXMAT),CSYMAT(6,27,MAXMAT)
      COMMON/DETL/DENER(15),NH,NV,NVH,NHVP(105),MDPRT,NDENER,
     1NUXS(45),NUX(45),NUYS(45),NUY(45),NCO,NHNVHV,MULPRT,NSIG
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
       COMMON/V/AL,ALO2,VV(27),X1,X2,X3,X4,X5,X6,Y1,Y2,Y3,Y4,Y5,Y6
      COMMON/PLT/
     1XMIN,XMAX,YMIN,YMAX,XPMIN,XPMAX,YPMIN,YPMAX,ALMIN,ALMAX,
     >DELMIN,DELMAX,DNUMIN,DNUMAX,DBMIN,DBMAX,
     2MALL,NPLOT,NCCUM,NGRAPH,NCOL,NLINE
      COMMON/CHPLT/MXXPR,MYYPR,MXY,MALE
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      COMMON/TRI/WCO(15,6),GEN(5,4),PGEN(75,6),DIST,
     <A1(15),B1(15),A2(15),B2(15),XCOR(3,15),XPCOR(3,15),
     1AL1(15),AL2(15),MESH,NIT,NENER,NITX,NITS,NITM1,NANAL,NOPRT
      PARAMETER  (MXGACA = 15)
      PARAMETER  (MXGATR = 1030)
      COMMON/GEOM/XCO,XPCO,YCO,YPCO,NCASE,NJOB,
     <    EPSX(MXGACA),EPSY(MXGACA),XI(MXGACA),YI(MXGACA),
     <    XG(MXGATR,MXGACA),
     <    XPG(MXGATR,MXGACA),YG(MXGATR,MXGACA),YPG(MXGATR,MXGACA),
     <    LCASE(MXGACA)
      COMMON/MISSET/DX1,DX2,DXP1,DXP2,DY1,DY2,DYP1,DYP2,
     >DZ1,DZ2,DZC1,DZS1,DZC2,DZS2,DDEL,I,IEP,MNEL
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      PARAMETER  (mxmis = 1000)
      COMMON/MIS/RMISA(8,MXMIS),MISELE(MXMIS),NMIS,NOPT,
     >NMISE,MISSEL(MXMIS),NMRNGE(MXMIS),
     >MSRNGE(2,10,MXMIS),MISFLG,MCHFLG
      PARAMETER    (MXMTR = 5000)
      COMMON/MISTRK/AKMIS(15,MXMTR),KMPOS(MXMTR),IMEXP,NMTOT,MISPTR
      COMMON/CSEEDS/ISEED,IXG,IXS,IXMSTP,IMSD,IMOSTP,ISYNSD,ISYSTP,
     >ISDBEG,IBGSTP,IXES,IXESTP,IESBEG,IESTBG,isdcol
      parameter   (mxerr = 25)
      parameter   (MXEREL = 500)
      parameter   (MXERRG = 6)
      COMMON/cERR/ERRVAL(mxerr,mxerel),erv(mxerr,mxerel),NERELE(mxerel),
     > NERPAR(mxerr,mxerel),NERR,NEROPT,NERRE,MERSEL(mxerel),
     > NERNGE(mxerel),MERNGE(2,mxerrg,mxerel),MERFLG
      PARAMETER  (MAXERR = 100)
      COMMON /ERRSRT/ ERRSRT(MAXERR),NERSRT,IERSRT,IERBEG
      COMMON/ERSAV/SAV(mxerr),SAVMAT(6,27),IERSET,IER,IDE,IEMSAV
      PARAMETER  (mxlcnd = 200)
      PARAMETER  (mxlvar = 100)
      COMMON/FITL/COEF(MXLVAR,6),VALF(MXLCND),
     >  WGHT(MXLCND),RVAL(MXLCND),XM(MXLVAR)
     >  ,EM(MXLVAR),WV,NELF(MXLVAR,6),NPAR(MXLVAR,6),
     >  IND(MXLVAR,6),NPVAR(MXLVAR),NVAL(MXLCND)
     >  ,NSTEP,NVAR,NCOND,ISTART,NDIV,IFITM,IFITD,IFITBM
      COMMON/MONIT/VALMON(MXLCND,4,3)
      COMMON/MONFIT/VALFA(MXLCND),WGHTA(MXLCND),ERRA(MXLCND),
     >AMULTA(MXLVAR,6),ADDA(MXLVAR,6),DELA(MXLVAR)
     >,NPARA(MXLVAR,6),NELFA(MXLVAR,6),
     >NPVARA(MXLVAR),INDA(MXLVAR,6),VALR(MXLCND),RMOSIG,
     >NMONA(MXLCND),NVALA(MXLCND),NVARA,NCONDA
     >,IALFLG,MONFLG,MONLST,NOPTER,
     >IAFRST,IMOOPT,IMSBEG,NALPRT
      PARAMETER     (MAXCOR = 600)
      COMMON/CORR/CORVAL(MAXCOR,4),ICRID(MAXCOR),
     >ICRPOS(MAXCOR),ICRSET(MAXCOR),
     >ICROPT(MAXCOR),NCORR,NCURCR,ICRFLG,ICRCHK,ALMNEL,ICRPTR,NPARC
      COMMON/CORSET/DCX1,DCX2,DCXR1,DCXR2,DCY1,DCY2,DCYR1,DCYR2,
     >DCXP,DCYP,DCDEL
      COMMON/ORBIT/SIZEX,SIZEY,RMSX,RMSY,RMSIX,RMSIY,
     >RTEMPX,RTEMPY,RMSPX(5),RMSPY(5),RPX,RPY,
     >RMAXX,RMAXY,RMINX,RMINY,MAXX,MAXY,MINX,MINY,PLENG,
     >IRNG,IRANGE(5),NPRORB,IORB,IREF,IPAGE,IPOINT
      COMMON/SYNCH/ENOM,SYNDEL,EMITGR,EMITK,EMITK2,ISYNFL,ISYNQD,IRND,iff
      COMMON/ARB/PARA(20),NarT(MXPART),NARBP
      PARAMETER    (MXADIV = 15)
      PARAMETER    (MXADIP = 100)
      COMMON/ADIA/VPARM(mxadiv,2*mxadip),IADFLG,IADCAV,NADVAR,
     >ivid(mxadiv),IVPAR(mxadiv),IVOPT(mxadiv)
      COMMON/SYM/ENERLI,GAMMLI,BETALI,bili,b2li,b2ili,
     >ISYOPT,ISYFLG,MATTOT,KANVAR
      COMMON/LNGTH/TLENG,ALENG(MXELMD),ACLENG(MAXPOS)
      COMMON/COLL/COLENG, XSIZE, YSIZE, ISHAPE
      CHARACTER*1 MALE(101,51),MXXPR(101,51),MYYPR(101,51),MXY(101,51)
      COMMON/CTRMAT/ AM1(27),AM2(27),AM3(27),AM4(27),AM5(27),AM6(27),
     >ZI(6),ZF(6),NEL,IMSAV,
     >M1(27),M2(27),M3(27),M4(27),M5(27),M6(27),N1,N2,N3,N4,N5,N6
      common /ctrsym/
     >bs11,bs12,bs13,bs14,bs15,bs16,bs21,bs22,bs23,bs24,bs25,bs26,
     >bs31,bs32,bs33,bs34,bs35,bs36,bs41,bs42,bs43,bs44,bs45,bs46,
     >bs51,bs52,bs53,bs54,bs55,bs56,
     >cs17,cs18,cs19,cs110,cs111,cs112,cs113,cs114,cs115,cs116,cs117,
     >cs118,cs119,cs120,cs121,cs122,cs123,cs124,cs125,cs126,cs127,
     >cs27,cs28,cs29,cs210,cs211,cs212,cs213,cs214,cs215,cs216,cs217,
     >cs218,cs219,cs220,cs221,cs222,cs223,cs224,cs225,cs226,cs227,
     >cs37,cs38,cs39,cs310,cs311,cs312,cs313,cs314,cs315,cs316,cs317,
     >cs318,cs319,cs320,cs321,cs322,cs323,cs324,cs325,cs326,cs327,
     >cs47,cs48,cs49,cs410,cs411,cs412,cs413,cs414,cs415,cs416,cs417,
     >cs418,cs419,cs420,cs421,cs422,cs423,cs424,cs425,cs426,cs427,
     >cs57,cs58,cs59,cs510,cs511,cs512,cs513,cs514,cs515,cs516,cs517,
     >cs518,cs519,cs520,cs521,cs522,cs523,cs524,cs525,cs526,cs527,
     >isysav
      COMMON/CRDMON/MONAME(8),MOBEG,MOEND,MRDFLG
     >,MRDCHK
      CHARACTER*1 MONAME
      COMMON/CSEIS/XLAMBS,AXSEIS,PHIXS,YLAMBS,
     >AYSEIS,PHIYS,XSEIS,YSEIS,ISEIFL,IBEGSE,IENDSE
      COMMON/CRMAT/ACIN(6),AINC(6),ACOUT(6),eps1,eps2,
     >betix,alphix,epsix,betiy,alphiy,epsiy,
     >  IFLMAT,NRMPRT,NRMORD,nmopt
      common/cspch/delspx(mxpart),delspy(mxpart),
     >dpmax,dkxmax,dkymax,ispopt,ispchf
      COMMON/CAV/FREQ,ALC,AML,CAVPHI,DEOVE,CPHI(MXPART),
     >PINGAM,PBETA,PCLENG,DTN,DAML,DTNA(MXPART),
     >CTF,CLP,DPHI,F0CAV,F1CAV,PERCAV,APHIAD,ICOPT,IAML,
     >N0CAV,N1CAV,INCAV
      COMMON/LINCAV/LCAVIN,NUMCAV,ENJECT,IECAV(MAXMAT),
     &              EIDEAL(MAXPOS),EREAL(MAXPOS)
      LOGICAL LCAVIN
      common/cinter/inumel,niplot,intflg,iprpl,jherr,itrap,
     > numel(20),iscx(20),iscy(20),
     > iscsx(20),iscsy(20),avx(11,101),avy(11,101),axis(101)
      character*1 avx,avy,axis
      COMMON/MULT/HMLENG,SF,COSM,SINM,AN(20),BN(20),
     >FR(0:20),FI(0:20),NP,Nm(20),MAXORD
      DIMENSION Y(6),X(6)
      EQUIVALENCE (Y1,Y(1)),(X1,X(1))
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      COMMON /PAGTIT/   KTIT,KVERS,KDATE,KTIME
      CHARACTER*8       KTIT*80,KVERS,KDATE,KTIME
      COMMON/CUPLO/LOTOUP,UPTOLO(26)
      DIMENSION loup(26)
      dimension ij(2),cs(3),bs(2)
      CHARACTER*26      LOTOUP,uplo
      CHARACTER*1       UPTOLO,loup
      CHARACTER*1 ICHAR,fnam(40)
      character*40 filnam
      equivalence (filnam,fnam(1)),(uplo,uptolo(1)),(lotoup,loup(1))
      data filnam/'                                        '/
      data erest/0.00051106/,prest/0.938256/
      ndata=0
      nchar=40
      NPRINT=1
      CALL INPUT(filnam,NCHAR,data,mxinp,IEND,Ndata,NPRINT)
      do 1 icp=1,40
      jnd=index(uplo,fnam(icp))
c      write(iout,*)fnam(icp),jnd
    1 if(jnd.ne.0) fnam(icp)=loup(jnd)
      open(unit=10,status='unknown',file=filnam)
      write(10,10002)ktit
10002 format(a80)
      write(10,10003)tleng
10003 format(e24.16)
      NCHAR=0
      ndata=1
      CALL INPUT(ICHAR,NCHAR,data,mxinp,IEND,Ndata,NPRINT)
      ifilop=data(1)
c      NCHECK=0
c      PINGAM=0.0D0
c      PBETA=1.0D0
c      CTF=0.0D0
c      ntbeg=1
c      if(ncturn.eq.1)then
c         DO 11011 IPT=1,MXPART
c11011    DTNA(IPT)=0.0D0
c         PCLENG=0
c         INCAV=0
c         DTN=0
c         isyfl=0
c      endif
c         if(ispchf.eq.1) then
c          do 811 ipart=1,npart
c          delspx(ipart)=-dkxmax*dmax1(0.0d0,
c     >     (dabs(part(ipart,6))+dpmax-dabs(del(ipart)))/dpmax)
c          delspy(ipart)=-dkymax*dmax1(0.0d0,
c     >     (dabs(part(ipart,6))+dpmax-dabs(del(ipart)))/dpmax)
c  811     continue
c         endif
c      if(isyfl.eq.1)syphip=syphi
c      IF(IADFLG.EQ.1)CALL ADICHK
      ITRBEG=1
      ITREND=NELM
      IF(IXMSTP.NE.0) THEN
           IXS=1
           IXMSTP=1
                      ELSE
           IXS=ISEED
      ENDIF
      IF(IXESTP.NE.0) THEN
           IXES=1
           IXESTP=1
                      ELSE
           IXES=ISEED
      ENDIF
      IERSRT = 1
      ILIST=1
      MISPTR = 1
      ICRPTR = 1
      ITCHCK = (NCTURN-1)*(ITREND-ITRBEG+1)
      DO 110 IE=ITRBEG,ITREND
       IEP=IE
      NEL=NORLST(IE)
      MNEL=NEL
      IAD=IADR(NEL)
      MATADR=MADR(NEL)
      NkT=KODE(NEL)
      NkTP1=NkT+1
      CLP=CTF*ALENG(NEL)*PINGAM*PINGAM
c      IF(ISEIFL.EQ.1) THEN
c       IF((IE.GE.IBEGSE).AND.(IE.LE.IENDSE)) THEN
c        DXS=-XSEIS
c        XSEIS=AXSEIS*DSIN(PHIXS+ACLENG(IE)*TWOPI/XLAMBS)
c        DXS=DXS+XSEIS
c        DYS=-YSEIS
c        YSEIS=AYSEIS*DSIN(PHIYS+ACLENG(IE)*TWOPI/YLAMBS)
c        DYS=DYS+YSEIS
c        DO 333 IP=1,NPART
c        IF(.NOT.LOGPAR(IP))GOTO 333
c        PART(IP,1)=PART(IP,1)+DXS
c        PART(IP,3)=PART(IP,3)+DYS
c  333   CONTINUE
c       ENDIF
c      ENDIF
      GOTO(10000,1000,4000,4000,4000,5000,6000,7000,8000,
     >9000,9000,20000,12000,13000,20000,9000,110,9500,
     >18000,9000),NkTP1
C
C (SKIP OVER ELEMENT IF KODE=16 - NO CODE 16 ELEMENTS)
C
C
C    TREATING DRIFTS : CODE 0 , NO ERRORS ,ALIGNMENTS, PARTICLE CHECK
C
10000 AL=ALENG(NEL)
      IF(AL.ne.0.0d0) then
        nkode=0
        write(10,10001)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >   acleng(ie),al
10001   format(' ',8a1,2i4,e20.12,e20.12,',')
                      else
        nkode=4
        write(10,10001)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >   acleng(ie),al
      endif
      GOTO 99888
C
C  TREATING BENDS : CODE 1 ,ERRORS,MISALIGNEMENTS,PARTICLE CHECK
C       CORRECTOR ELEMENTS  AND SYNCHROTON RADIATION
C
 1000 MCHFLG=0
      ICRCHK=0
      IF(ISYNFL.NE.0) CALL SYNPRE(IAD,NEL)
      IF(ICRFLG.EQ.1) CALL CORCHK(IE)
      IF(MISFLG.EQ.1) CALL MISCHK
      IF((MERFLG.EQ.1).OR.(ICRCHK.EQ.2)) CALL ESET(NEL,MATADR)
      if(isynfl.eq.1) then
        nkode=20
        sdel=-0.5*syndel
        write(10,11001)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >  acleng(ie),sdel
11001   format(' ',8a1,2i4,e20.12,e20.12,',')
      endif
      if(icrchk.eq.1) then
        nkode=21
        cdx1=dcx1
        cdxr1=dcxr1
        cdy1=dcy1
        cdyr1=dcyr1
        cdel=dcdel
        al=0.0d0
        write(10,11002)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >  acleng(ie),al,cdx1,cdxr1,cdy1,cdyr1,cdel
C11002   format(' ',8a1,2i4,2e20.12,/,5e20.12,',')
11002   format(' ',8a1,2i4,2e20.12,/,3e20.12,/,2e20.12,',')
      endif
      if(mchflg.eq.1)then
        nkode=22
        dmx1=-dx1
        dmxp1=-dxp1
        dmy1=-dy1
        dmyp1=-dyp1
        dmz1=-dz1
        dmdel=-ddel
        dmzc1=dzc1
        dmzs1=-dzs1
        al=0.0d0
        write(10,11003)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >  acleng(ie),al,dmx1,dmxp1,dmy1,dmyp1,dmz1,dmdel,dmzc1,dmzs1
c11003   format(' ',8a1,2i4,2e20.12,/,6e20.12,/,2e20.12,',')
11003   format(' ',8a1,2i4,2e20.12,/,3e20.12,/,3e20.12,/,2e20.12,',')
      endif
      nkode=12
      al=aleng(nel)
      write(10,11004)(name(jn,nel),jn=1,8),kode(nel),nkode,
     > acleng(ie),al
11004 format(' ',8a1,2i4,2e20.12)
      nmatel=0
      do 1001 im=1,5
      do 1001 jm=7,27
      csym=csymat(im,jm,matadr)
      if(csym.ne.0.0d0) then
        nmatel=nmatel+1
        ijm=100*im+jm
        ij(nmatel)=ijm
        cs(nmatel)=csym
        if(nmatel.eq.2) then
          write(10,11005)ij(1),cs(1),ij(2),cs(2)
11005     format(2(' ',i3,e24.16))
          nmatel=0
        endif
      endif
 1001 continue
      if(nmatel.eq.1) then
       write(10,11006)ij(1),cs(1)
11006  format(' ',i3,e24.16,',')
                      else
       write(10,11007)
11007  format(',')
      endif
      nkode=11
      write(10,11008)(name(jn,nel),jn=1,8),kode(nel),nkode,
     > acleng(ie),al
11008 format(' ',8a1,2i4,2e20.12)
      nmatel=0
      do 1002 im=1,5
      do 1002 jm=1,6
      bsym=bsymat(im,jm,matadr)
      if(bsym.ne.0.0d0) then
        nmatel=nmatel+1
        ijm=100*im+jm
        ij(nmatel)=ijm
        cs(nmatel)=bsym
        if(nmatel.eq.2) then
          write(10,11005)ij(1),cs(1),ij(2),cs(2)
          nmatel=0
        endif
      endif
 1002 continue
      if(nmatel.eq.1) then
       write(10,11006)ij(1),cs(1)
                      else
       write(10,11007)
      endif
      if(mchflg.eq.1) then
        nkode=23
        dmx2=-dx2
        dmxp2=-dxp2
        dmy2=-dy2
        dmyp2=-dyp2
        dmz2=-dz2
        dmdel=ddel
        dmzc2=dzc2
        dmzs2=-dzs2
        al=0.0d0
        write(10,11003)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >  acleng(ie),al,dmx2,dmxp2,dmy2,dmyp2,dmz2,dmdel,dmzc2,dmzs2
      endif
      if(icrchk.eq.1) then
        nkode=21
        cdx2=dcx2
        cdxr2=dcxr2
        cdy2=dcy2
        cdyr2=dcyr2
        cdel=-dcdel
        al=0.0d0
        write(10,11002)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >  acleng(ie),al,cdx2,cdxr2,cdy2,cdyr2,cdel
      endif
      if(isynfl.eq.1) then
        nkode=20
        sdel=-0.5*syndel
        write(10,11001)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >  acleng(ie),sdel
      endif
      GOTO 99888
C
C  TREATING QUADS : CODE 2,SEXTUPOLES : CODE 3,QUADSEXT : CODE 4
C        ERRORS,MISALIGNEMENTS,PARTICLE CHECK
C       CORRECTOR ELEMENTS
C
 4000 MCHFLG=0
      ICRCHK=0
c      isptst=0
c      if((ispchf.eq.1).and.(nktp1.eq.3))isptst=1
c      IF(ISYNQD.EQ.1) CALL SYNPRE(IAD,NEL)
      IF(ICRFLG.EQ.1) CALL CORCHK(IE)
      IF(MISFLG.EQ.1) CALL MISCHK
      IF((MERFLG.EQ.1).OR.(ICRCHK.EQ.2)) CALL ESET(NEL,MATADR)
      if(icrchk.eq.1) then
        nkode=21
        cdx1=dcx1
        cdxr1=dcxr1
        cdy1=dcy1
        cdyr1=dcyr1
        cdel=dcdel
        al=0.0d0
        write(10,14002)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >  acleng(ie),al,cdx1,cdxr1,cdy1,cdyr1,cdel
c14002   format(' ',8a1,2i4,2e20.12,/,5e20.12,',')
14002   format(' ',8a1,2i4,2e20.12,/,3e20.12,/,2e20.12,',')
      endif
      if(mchflg.eq.1)then
        nkode=22
        dmx1=-dx1
        dmxp1=-dxp1
        dmy1=-dy1
        dmyp1=-dyp1
        dmz1=-dz1
        dmdel=-ddel
        dmzc1=dzc1
        dmzs1=-dzs1
        al=0.0d0
        write(10,14003)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >  acleng(ie),al,dmx1,dmxp1,dmy1,dmyp1,dmz1,dmdel,dmzc1,dmzs1
c14003   format(' ',8a1,2i4,2e20.12,/,6e20.12,/,2e20.12,',')
14003   format(' ',8a1,2i4,2e20.12,/,3e20.12,/,3e20.12,/,2e20.12,',')
      endif
      nkode=12
      al=aleng(nel)
      write(10,14004)(name(jn,nel),jn=1,8),kode(nel),nkode,
     > acleng(ie),al
14004 format(' ',8a1,2i4,2e20.12)
      nmatel=0
      do 4001 im=1,5
      do 4001 jm=7,27
      csym=csymat(im,jm,matadr)
      if(csym.ne.0.0d0) then
        nmatel=nmatel+1
        ijm=100*im+jm
        ij(nmatel)=ijm
        cs(nmatel)=csym
        if(nmatel.eq.2) then
          write(10,11005)ij(1),cs(1),ij(2),cs(2)
          nmatel=0
        endif
      endif
 4001 continue
      if(nmatel.eq.1) then
       write(10,11006)ij(1),cs(1)
                      else
       write(10,11007)
      endif
      nkode=11
      write(10,14008)(name(jn,nel),jn=1,8),kode(nel),nkode,
     > acleng(ie),al
14008 format(' ',8a1,2i4,2e20.12)
      nmatel=0
      do 4002 im=1,5
      do 4002 jm=1,6
      bsym=bsymat(im,jm,matadr)
      if(bsym.ne.0.0d0) then
        nmatel=nmatel+1
        ijm=100*im+jm
        ij(nmatel)=ijm
        cs(nmatel)=bsym
        if(nmatel.eq.2) then
          write(10,11005)ij(1),cs(1),ij(2),cs(2)
          nmatel=0
        endif
      endif
 4002 continue
      if(nmatel.eq.1) then
       write(10,11006)ij(1),cs(1)
                      else
       write(10,11007)
      endif
      if(mchflg.eq.1) then
        nkode=23
        dmx2=-dx2
        dmxp2=-dxp2
        dmy2=-dy2
        dmyp2=-dyp2
        dmz2=-dz2
        dmdel=ddel
        dmzc2=dzc2
        dmzs2=-dzs2
        al=0.0d0
        write(10,14003)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >  acleng(ie),al,dmx2,dmxp2,dmy2,dmyp2,dmz2,dmdel,dmzc2,dmzs2
      endif
      if(icrchk.eq.1) then
        nkode=21
        cdx2=dcx2
        cdxr2=dcxr2
        cdy2=dcy2
        cdyr2=dcyr2
        cdel=-dcdel
        al=0.0d0
        write(10,14002)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >  acleng(ie),al,cdx2,cdxr2,cdy2,cdyr2,cdel
      endif
      GOTO 99888
C
C  TREAT MULTIPOLES : CODE 5 . MISALIGNMENTS AND ERRORS
C
 5000 AL = 0.5D0*ALENG(NEL)
      ALO2=0.5D0*AL
      MCHFLG=0
      IF(MISFLG.EQ.1)CALL MISCHK
      IF(MERFLG.EQ.1)CALL ESET(NEL,MATADR)
      CALL MULTIT(NEL)
      if(mchflg.eq.1)then
        nkode=22
        dmx1=-dx1
        dmxp1=-dxp1
        dmy1=-dy1
        dmyp1=-dyp1
        dmz1=-dz1
        dmdel=-ddel
        dmzc1=dzc1
        dmzs1=-dzs1
        alm=0.0d0
        write(10,15003)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >  acleng(ie),alm,dmx1,dmxp1,dmy1,dmyp1,dmz1,dmdel,dmzc1,dmzs1
c15003   format(' ',8a1,2i4,2e20.12,/,6e20.12,/,2e20.12,',')
15003   format(' ',8a1,2i4,2e20.12,/,3e20.12,/,3e20.12,/,2e20.12,',')
      endif
      if(al.ne.0.0d0) then
      nkode=12
      write(10,15004)(name(jn,nel),jn=1,8),kode(nel),nkode,
     > acleng(ie),al
15004 format(' ',8a1,2i4,2e20.12)
      nmatel=0
      do 5001 im=1,5
      do 5001 jm=7,27
      csym=csymat(im,jm,matadr)
      if(csym.ne.0.0d0) then
        nmatel=nmatel+1
        ijm=100*im+jm
        ij(nmatel)=ijm
        cs(nmatel)=csym
        if(nmatel.eq.2) then
          write(10,11005)ij(1),cs(1),ij(2),cs(2)
          nmatel=0
        endif
      endif
 5001 continue
      if(nmatel.eq.1) then
       write(10,11006)ij(1),cs(1)
                      else
       write(10,11007)
      endif
      nkode=11
      write(10,15008)(name(jn,nel),jn=1,8),kode(nel),nkode,
     > acleng(ie),al
15008 format(' ',8a1,2i4,2e20.12)
      nmatel=0
      do 5002 im=1,5
      do 5002 jm=1,6
      bsym=bsymat(im,jm,matadr)
      if(bsym.ne.0.0d0) then
        nmatel=nmatel+1
        ijm=100*im+jm
        ij(nmatel)=ijm
        cs(nmatel)=bsym
        if(nmatel.eq.2) then
          write(10,11005)ij(1),cs(1),ij(2),cs(2)
          nmatel=0
        endif
      endif
 5002 continue
      if(nmatel.eq.1) then
       write(10,11006)ij(1),cs(1)
                      else
       write(10,11007)
      endif
      endif
C**************************
C start of multipole proper
C**************************
      if(maxord.ne.0) then
        nkode=30
        write(10,15004)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >   acleng(ie),alm
        write(10,15011)sinm,cosm,sf,maxord
15011 format(' ',3(e20.12),i4)
        ikord=0
        do 15012 iord=0,maxord
        if((fr(iord).ne.0.0d0).or.(fi(iord).ne.0.0d0)) then
          ikord=ikord+1
          ij(ikord)=iord
          cs(ikord)=fr(iord)
          bs(ikord)=fi(iord)
          if(ikord.eq.2) then
           write(10,15013)ij(1),cs(1),bs(1),ij(2),cs(2),bs(2)
15013      format(2(i4,2(e16.8)))
           ikord=0
          endif
c          if((ikord.ne.3).or.(iord.eq.maxord)) then
c          if((ikord.ne.2).or.(iord.eq.maxord)) then
c            write(10,15013)iord,fr(iord),fi(iord)
c15013       format(i4,2(e16.8),$)
c                                                else
c            ikord=0
c            write(10,15014)iord,fr(iord),fi(iord)
c15014       format(i4,2(e16.8))
c          endif
        endif
15012   continue
        if(ikord.eq.1) then
         write(10,15014)ij(1),cs(1),bs(1)
15014    format(i4,2(e16.8),',')
                       else
         write(10,11007)
        endif
      endif
C**************************
C  end  of multipole proper
C**************************
      if(al.ne.0.0d0) then
      nkode=12
      write(10,15004)(name(jn,nel),jn=1,8),kode(nel),nkode,
     > acleng(ie),al
      nmatel=0
      do 5003 im=1,5
      do 5003 jm=7,27
      csym=csymat(im,jm,matadr)
      if(csym.ne.0.0d0) then
        nmatel=nmatel+1
        ijm=100*im+jm
        ij(nmatel)=ijm
        cs(nmatel)=csym
        if(nmatel.eq.2) then
          write(10,11005)ij(1),cs(1),ij(2),cs(2)
          nmatel=0
        endif
      endif
 5003 continue
      if(nmatel.eq.1) then
       write(10,11006)ij(1),cs(1)
                      else
       write(10,11007)
      endif
      nkode=11
      write(10,15008)(name(jn,nel),jn=1,8),kode(nel),nkode,
     > acleng(ie),al
      nmatel=0
      do 5004 im=1,5
      do 5004 jm=1,6
      bsym=bsymat(im,jm,matadr)
      if(bsym.ne.0.0d0) then
        nmatel=nmatel+1
        ijm=100*im+jm
        ij(nmatel)=ijm
        cs(nmatel)=bsym
        if(nmatel.eq.2) then
          write(10,11005)ij(1),cs(1),ij(2),cs(2)
          nmatel=0
        endif
      endif
 5004 continue
      if(nmatel.eq.1) then
       write(10,11006)ij(1),cs(1)
                      else
       write(10,11007)
      endif
      endif
      if(mchflg.eq.1) then
        nkode=23
        dmx2=-dx2
        dmxp2=-dxp2
        dmy2=-dy2
        dmyp2=-dyp2
        dmz2=-dz2
        dmdel=ddel
        dmzc2=dzc2
        dmzs2=-dzs2
        alm=0.0d0
        write(10,15003)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >  acleng(ie),alm,dmx2,dmxp2,dmy2,dmyp2,dmz2,dmdel,dmzc2,dmzs2
      endif
c      IF(AL.NE.0.0D0)THEN
c       IMSAV=0
c      isysav=0
cc       IF((NCPART.GT.2).AND.(ISYOPT.LT.1))THEN
c      IF(NCPART.GT.2) THEN
c       IMSAV=1
c       CALL TRSAV(MATADR)
c       ENDIF
c      ENDIF
c      DO 5001 ICPART=1,NPART
c      IF(.NOT.LOGPAR(ICPART)) GO TO 5001
c      X1=PART(ICPART,1)
c      X2=PART(ICPART,2)
c      X3=PART(ICPART,3)
c      X4=PART(ICPART,4)
c      X5=PART(ICPART,5)
c      X6=PART(ICPART,6)
c      TEST=(X1)**2+(X3)**2
c      IF(TEST.LT.EXPEL2) GO TO 5002
c      WRITE(IOUT,10024)ICPART,IE,(NAME(IZ,NEL),IZ=1,8),NCTURN
c      IF(ISO.NE.0)WRITE(ISOUT,10024)ICPART,IE,(NAME(IZ,NEL),IZ=1,8)
c     <,NCTURN
c      NCPART=NCPART-1
c      LOGPAR(ICPART)=.FALSE.
c      WRITE(IOUT,10300)ICPART,(PART(ICPART,J),J=1,6)
c      GOTO 5001
c 5002 IF(MCHFLG.EQ.1)CALL MSET
c      IF(AL.NE.0.0d0) THEN
c       CALL TRMAT(MATADR,ICPART)
c      DX5=Y5-X5
c      CPHI(ICPART)=CPHI(ICPART)+CTF*DX5-CLP*X6
c       X1=Y1
c       X2=Y2
c       X3=Y3
c       X4=Y4
c       X5=Y5
c       X6=Y6
c      ENDIF
c      CALL MULTTR(X1,X2,X3,X4,X5,X6,Y1,Y2,Y3,Y4,Y5,Y6)
c      IF(AL.NE.0.0d0) THEN
c       X1=Y1
c       X2=Y2
c       X3=Y3
c       X4=Y4
c       X5=Y5
c       X6=Y6
c       CALL TRMAT(MATADR,ICPART)
c      DX5=Y5-X5
c      CPHI(ICPART)=CPHI(ICPART)+CTF*DX5-CLP*X6
c      ENDIF
c      IF(MCHFLG.EQ.1)CALL MRESET
c      PART(ICPART,1)=Y1
c      PART(ICPART,2)=Y2
c      PART(ICPART,3)=Y3
c      PART(ICPART,4)=Y4
c      PART(ICPART,5)=Y5
c      PART(ICPART,6)=Y6
c 5001 CONTINUE
      GOTO 99888
C
C   TREAT COLLIMATORS : CODE 6 . NO MISALIGNEMENTS NO ERRORS
C
 6000 AL = ALENG(NEL)
      CALL COLPRE(IAD)
      nkode=ishape
      alc=0.0d0
      write(10,16002)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >acleng(ie),alc,xsize,ysize
c16002 format(' ',8a1,2i4,4e20.12,',')
16002 format(' ',8a1,2i4,2e20.12,/,2e20.12,',')
      IF(AL.ne.0.0d0) then
        nkode=0
        write(10,16001)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >   acleng(ie),al
16001   format(' ',8a1,2i4,e20.12,e20.12,',')
        nkode=ishape
        write(10,16002)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >  acleng(ie),alc,xsize,ysize
       endif
c      DO 6001 ICPART=1,NPART
c      IF(.NOT.LOGPAR(ICPART)) GO TO 6001
c      X1=PART(ICPART,1)
c      X2=PART(ICPART,2)
c      X3=PART(ICPART,3)
c      X4=PART(ICPART,4)
c      X5=PART(ICPART,5)
c      X6=PART(ICPART,6)
C    CHECK COORDINATES AT ENTRY, BOTH RECTANGULAR AND ELLIPTIC CASES
c      IF(ISHAPE.EQ.2) THEN
c        IF(DABS(X1).GT.XSIZE.OR.DABS(X3).GT.YSIZE) GO TO 6002
c      ELSE
c        ALIM = (X1/XSIZE)**2 + (X3/YSIZE)**2
c        IF(ALIM.GT.1.0) GO TO 6002
c      ENDIF
C     IF ZERO LENGTH, THEN JOB IS DONE
c      IF(AL.EQ.0.0) GOTO 6001
c      CALL TRDRIF
c      PART(ICPART,1)=Y1
c      PART(ICPART,3)=Y3
c      PART(ICPART,5)=Y5
C     IF(ISYFLG.EQ.1) THEN         REDUNDANT STATEMENTS
C      PART(ICPART,2)=Y2           DRIFT DOES NOT CHANGE
C      PART(ICPART,4)=Y4           MOMENTUM OR ANGLE
C     ENDIF
C   NOW CHECK COORDINATES AT EXIT
c      IF(ISHAPE.EQ.2) THEN
c        IF((DABS(Y1).GT.XSIZE).OR.(DABS(Y3).GT.YSIZE)) GO TO 6002
c      ELSE
c        ALIM = (Y1/XSIZE)**2 + (Y3/YSIZE)**2
c        IF(ALIM.GT.1.0) GO TO 6002
c      ENDIF
c      GO TO 6001
c6002  WRITE(IOUT,10024)ICPART,IE,(NAME(IZ,NEL),IZ=1,8),NCTURN
c      IF(ISO.NE.0)WRITE(ISOUT,10024)ICPART,IE,(NAME(IZ,NEL),IZ=1,8)
c     <,NCTURN
c10024 FORMAT(//,'  PARTICLE #',I6,' IS LOST BEFORE ELEMENT',I6,
c     +  '(',8A1,')',
c     +  ' DURING TURN:',I6,/,' ITS POSITION IS :',//)
c      NCPART=NCPART-1
c      LOGPAR(ICPART)=.FALSE.
c      WRITE(IOUT,10300)ICPART,(PART(ICPART,J),J=1,6)
c      IF(ISO.NE.0)WRITE(ISOUT,10300)ICPART,(PART(ICPART,J),J=1,6)
c10300 FORMAT(' ',I4,6(E14.5))
c      DX5=Y5-X5
c      CPHI(ICPART)=CPHI(ICPART)+CTF*DX5-CLP*X6
c 6001 CONTINUE
      GOTO 99888
C***************************************
C   treating cavity
C***************************************
 7000 CALL CAVPRE(IAD,NEL,NCTURN,IE)
      al=0.5d0*aleng(nel)
      if(al.ne.0.0d0) then
      nkode=0
      write(10,17001)(name(jn,nel),jn=1,8),kode(nel),nkode,
     > acleng(ie),al
17001   format(' ',8a1,2i4,e20.12,e20.12,',')
      endif
      alc=0.0d0
      nkode=31
      if(iptyp.eq.0) restm=erest
      if(iptyp.eq.1) restm=prest
      ekin=eldat(iad+1)
      hcav=eldat(iad+3)
      ihcav=hcav
      hovtl=ihcav/tleng
      volts=eldat(iad+2)*1.0e-06
      if(kunits.ne.2)volts=volts*1.0e03
      write(10,17002)(name(jn,nel),jn=1,8),kode(nel),nkode,
     > acleng(ie),alc
17002 format(' ',8a1,2i4,2e20.12)
      write(10,17003)restm,ekin,hcav,hovtl,volts,cavphi
c17003 format(' ',6e20.12,',')
17003 format(' ',3e20.12,/,3e20.12,',')
      if(al.ne.0.0d0) then
      nkode=0
      write(10,17001)(name(jn,nel),jn=1,8),kode(nel),nkode,
     > acleng(ie),al
      endif
c      DO 7001 ICPART=1,NPART
c      IF(.NOT.LOGPAR(ICPART)) GO TO 7001
c      X1=PART(ICPART,1)
c      X2=PART(ICPART,2)
c      X3=PART(ICPART,3)
c      X4=PART(ICPART,4)
c      X5=PART(ICPART,5)
c      X6=PART(ICPART,6)
c      CALL CAVITY(X1,X2,X3,X4,X5,X6,Y1,Y2,Y3,Y4,Y5,Y6,ICPART,NCTURN)
c      PART(ICPART,1)=Y1
c      PART(ICPART,2)=Y2
c      PART(ICPART,3)=Y3
c      PART(ICPART,4)=Y4
c      PART(ICPART,5)=Y5
c      PART(ICPART,6)=Y6
c      DX5=Y5-X5
c      CPHI(ICPART)=CPHI(ICPART)+CTF*DX5-CLP*X6
c 7001 CONTINUE
c      IF(INCAV.EQ.1)INCAV=2
      GOTO 99888
C
C
C  TREAT KICKS : CODE 8 . NO MISALIGNMENT , ERRORS (FOR POSSIBLE ROLL
C  STUDY), CORRECTORS OPTION 3 ONLY.
C
 8000 AL=0.5D0*ALENG(NEL)
      ALO2=0.5D0*AL
      ICRCHK=0
c      IF(AL.NE.0.0D0) CALL TRFDR
      if(al.ne.0.0d0) then
      nkode=0
      write(10,18001)(name(jn,nel),jn=1,8),kode(nel),nkode,
     > acleng(ie),al
18001   format(' ',8a1,2i4,e20.12,' ',e20.12,',')
      endif
      IF(ICRFLG.EQ.1) CALL CORCHK(IE)
      if(icrchk.eq.2) then
      nkode=24
      alk=0.0d0
        write(10,18002)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >  acleng(ie),alk,dcxp,dcyp
c18002   format(' ',8a1,2i4,4e20.12,',')
18002   format(' ',8a1,2i4,2e20.12,/,' ',2e20.12,',')
                      else
      IF(KUNITS.EQ.2) ANGKIK=ELDAT(IAD+7)*CRDEG
      IF(KUNITS.EQ.1) ANGKIK = -ELDAT(IAD+7)
      IF(KUNITS.EQ.0) ANGKIK = ELDAT(IAD+7)
      COSK=DCOS(ANGKIK)
      SINK=DSIN(ANGKIK)
      IF(MERFLG.EQ.1)CALL ESET(NEL,MATADR)
      aKI=DABS(ELDAT(IAD+9))
c      IKM=MOD(NCTURN,IKI)
c      IF(IKM.NE.0)GO TO 8002
      aSYN=ELDAT(IAD+10)
c      IF(MSYN.LT.0) THEN
c         NSYN=ABS(FLOAT(MSYN))
c        if(isyfl.eq.0) then
c           syphip=-twopi/nsyn
c           isyfl=1
c         endif
c         if(ntbeg.eq.1) then
c           syphi=syphip+twopi/nsyn
c           ntbeg=0
c         endif
c         SYNFAC=DCOS(TWOPI*(ACLENG(IE)/TLENG)/NSYN+syphi)
c      ENDIF
      IFACTK=ELDAT(IAD+10)
      DXK=ELDAT(IAD+1)
      IF(KUNITS.EQ.1) THEN
           DXPK=-ELDAT(IAD+2)
                      ELSE
           DXPK=ELDAT(IAD+2)
      ENDIF
      DYK=ELDAT(IAD+3)
      DYPK=ELDAT(IAD+4)
      DALK=ELDAT(IAD+5)
      DDELK=ELDAT(IAD+6)
      if(asyn.lt.0.0d0) then
        test=dxk*dxpk*dyk*dypk*dalk*ddelk*angkik
        if(test.ne.0.0d0) then
          write(iout,18003)
18003     format(' THERE ARE NON ZERO KICK VALUES IN A SYNCH KICK',
     >    ' THEY ARE IGNORED !!')
        endif
        nkode=33
        alk=0.0d0
        asyn=dabs(asyn)
        write(10,18004)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >  acleng(ie),alk,asyn
18004   format(' ',8a1,2i4,3e20.12,',')
                    else
        nkode=32
        alk=0.0d0
        write(10,18005)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >  acleng(ie),alk,dxk,dxpk,dyk,dypk,dalk,ddelk,cosk,sink,aki,asyn
c18005   format(' ',8a1,2i4,2e20.12,/,6e20.12,/,4e20.12,',')
18005   format(' ',8a1,2i4,2e20.12,/,' ',3e20.12,/,
     >   ' ',3e20.12,/,' ',3e20.12,/,' ',e20.12,',')
      endif
cccccccccccC
C  SCALE MOMENTA KICKS BY RATIO OF IDEAL TO REAL MOMENTA IF CAVITIES
C  ARE PRESENT AND ERRORS ARE ACTIVATED
C
c      IF((LCAVIN).AND.(MERFLG.EQ.1)) THEN
c      CPIDEAL=DSQRT(EIDEAL(IE)**2-EMASS**2)
c      CPREAL =DSQRT(EREAL(IE)**2-EMASS**2)
c      RATMOM=(CPIDEAL/CPREAL)
c      DXPK=RATMOM*DXPK
c      DYPK=RATMOM*DYPK
c      DDELK=RATMOM*DDELK
c      END IF
c      DO 8001 ICPART=1,NPART
c      IF(.NOT.LOGPAR(ICPART)) GO TO 8001
c      X1=PART(ICPART,1)
c      X2=PART(ICPART,2)
c      X3=PART(ICPART,3)
c      X4=PART(ICPART,4)
c      X5=PART(ICPART,5)
c      X6=PART(ICPART,6)
c      IF(ICRCHK.EQ.2) CALL CSET
c      FACTE=1.0D0
c      IF(IFACTK.EQ.1)FACTE=1.0D0/(1.0D0+X6)
c      SX1=X1*COSK+X3*SINK
c      X3=-X1*SINK+X3*COSK
c      X1=SX1
c      SX2=X2*COSK+X4*SINK
c      X4=-X2*SINK+X4*COSK
c      X2=SX2
c      Y1=X1+DXK
c      Y2=X2+DXPK*FACTE
c      Y3=X3+DYK
c      Y4=X4+DYPK*FACTE
c      Y5=X5+DALK
c      DX5=DALK
c      CPHI(ICPART)=CPHI(ICPART)+CTF*(DX5-DALK*PINGAM*PINGAM*X6)
c      Y6=X6+DDELK
c      IF(MSYN.LT.0) Y6=DEL(ICPART)*SYNFAC
c      PART(ICPART,1)=Y1
c      PART(ICPART,2)=Y2
c      PART(ICPART,3)=Y3
c      PART(ICPART,4)=Y4
c      PART(ICPART,5)=Y5
c      PART(ICPART,6)=Y6
c 8001 CONTINUE
cc 8002 IF(AL.NE.0.0D0)CALL TRFDR
      endif
      if(al.ne.0.0d0) then
      nkode=0
      write(10,10001)(name(jn,nel),jn=1,8),kode(nel),nkode,
     > acleng(ie),al
      endif
      GOTO 99888
C
C  TREATING
C   TWISS : CODE 9,GENERAL MATRIX : CODE 10, SOLQUA : CODE 15
C   quadac : code 19
C        ERRORS,MISALIGNEMENTS,PARTICLE CHECK
C       CORRECTOR ELEMENTS
C
 9000 MCHFLG=0
      ICRCHK=0
      IF(ICRFLG.EQ.1) CALL CORCHK(IE)
      IF(MISFLG.EQ.1) CALL MISCHK
      IF((MERFLG.EQ.1).OR.(ICRCHK.EQ.2)) CALL ESET(NEL,MATADR)
      if(icrchk.eq.1) then
        nkode=21
        cdx1=dcx1
        cdxr1=dcxr1
        cdy1=dcy1
        cdyr1=dcyr1
        cdel=dcdel
        al=0.0d0
        write(10,19002)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >  acleng(ie),al,cdx1,cdxr1,cdy1,cdyr1,cdel
c19002   format(' ',8a1,2i4,2e20.12,/,5e20.12,',')
19002   format(' ',8a1,2i4,2e20.12,/,3e20.12,/,2e20.12,',')
      endif
      if(mchflg.eq.1)then
        nkode=22
        dmx1=-dx1
        dmxp1=-dxp1
        dmy1=-dy1
        dmyp1=-dyp1
        dmz1=-dz1
        dmdel=-ddel
        dmzc1=dzc1
        dmzs1=-dzs1
        al=0.0d0
        write(10,19003)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >  acleng(ie),al,dmx1,dmxp1,dmy1,dmyp1,dmz1,dmdel,dmzc1,dmzs1
c19003   format(' ',8a1,2i4,2e20.12,/,6e20.12,/,2e20.12,',')
19003   format(' ',8a1,2i4,2e20.12,/,3e20.12,/,3e20.12,/,2e20.12,',')
      endif
C***************
C   check if there any non zero second order terms
C***************
      izero=0
      do 9004 im=1,5
      do 9004 jm=7,27
      if(csymat(im,jm,matadr).ne.0.0d0) then
      izero=1
      goto 9003
      endif
 9004 continue
 9003 if(izero.eq.0) goto 9005
      nkode=12
      al=aleng(nel)
      write(10,19004)(name(jn,nel),jn=1,8),kode(nel),nkode,
     > acleng(ie),al
19004 format(' ',8a1,2i4,2e20.12)
      nmatel=0
      do 9001 im=1,5
      do 9001 jm=7,27
      csym=csymat(im,jm,matadr)
      if(csym.ne.0.0d0) then
        nmatel=nmatel+1
        ijm=100*im+jm
        ij(nmatel)=ijm
        cs(nmatel)=csym
        if(nmatel.eq.2) then
          write(10,11005)ij(1),cs(1),ij(2),cs(2)
          nmatel=0
        endif
      endif
 9001 continue
      if(nmatel.eq.1) then
       write(10,11006)ij(1),cs(1)
                      else
       write(10,11007)
      endif
 9005 nkode=11
      write(10,19008)(name(jn,nel),jn=1,8),kode(nel),nkode,
     > acleng(ie),al
19008 format(' ',8a1,2i4,2e20.12)
      nmatel=0
      do 9002 im=1,5
      do 9002 jm=1,6
      bsym=bsymat(im,jm,matadr)
      if(bsym.ne.0.0d0) then
        nmatel=nmatel+1
        ijm=100*im+jm
        ij(nmatel)=ijm
        cs(nmatel)=bsym
        if(nmatel.eq.2) then
          write(10,11005)ij(1),cs(1),ij(2),cs(2)
          nmatel=0
        endif
      endif
 9002 continue
      if(nmatel.eq.1) then
       write(10,11006)ij(1),cs(1)
                      else
       write(10,11007)
      endif
      if(mchflg.eq.1) then
        nkode=23
        dmx2=-dx2
        dmxp2=-dxp2
        dmy2=-dy2
        dmyp2=-dyp2
        dmz2=-dz2
        dmdel=ddel
        dmzc2=dzc2
        dmzs2=-dzs2
        al=0.0d0
        write(10,19003)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >  acleng(ie),al,dmx2,dmxp2,dmy2,dmyp2,dmz2,dmdel,dmzc2,dmzs2
      endif
      if(icrchk.eq.1) then
        nkode=21
        cdx2=dcx2
        cdxr2=dcxr2
        cdy2=dcy2
        cdyr2=dcyr2
        cdel=-dcdel
        al=0.0d0
        write(10,19002)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >  acleng(ie),al,cdx2,cdxr2,cdy2,cdyr2,cdel
      endif
c      IMSAV=0
c      isysav=0
c      IF((NCPART.GT.2).AND.(ISYOPT.LT.1)) THEN
c      IF(NCPART.GT.2) THEN
c          IMSAV=1
c          CALL TRSAV(MATADR)
c      ENDIF
c      DO 9001 ICPART=1,NPART
c      IF(.NOT.LOGPAR(ICPART)) GO TO 9001
c      X1=PART(ICPART,1)
c      X2=PART(ICPART,2)
c      X3=PART(ICPART,3)
c      X4=PART(ICPART,4)
c      X5=PART(ICPART,5)
c      X6=PART(ICPART,6)
c      TEST=(X1)**2+(X3)**2
c      IF(TEST.LT.EXPEL2) GO TO 9002
c      WRITE(IOUT,10024)ICPART,IE,(NAME(IZ,NEL),IZ=1,8),NCTURN
c      IF(ISO.NE.0)WRITE(ISOUT,10024)ICPART,IE,(NAME(IZ,NEL),IZ=1,8)
c     <,NCTURN
c      NCPART=NCPART-1
c      LOGPAR(ICPART)=.FALSE.
c      WRITE(IOUT,10300)ICPART,(PART(ICPART,J),J=1,6)
c      GOTO 9001
c 9002 IF(ICRCHK.EQ.1) CALL CSET
c      IF(MCHFLG.EQ.1) CALL MSET
c      CALL TRMAT(MATADR,ICPART)
c      IF(MCHFLG.EQ.1) CALL MRESET
c      IF(ICRCHK.EQ.1) CALL CRESET
c      PART(ICPART,1)=Y1
c      PART(ICPART,2)=Y2
c      PART(ICPART,3)=Y3
c      PART(ICPART,4)=Y4
c      PART(ICPART,5)=Y5
c      PART(ICPART,6)=Y6
c      DX5=Y5-X5
c      CPHI(ICPART)=CPHI(ICPART)+CTF*DX5-CLP*X6
c 9001 CONTINUE
      GOTO 99888
C-----------------------------------------------------------------------
C
C   TREAT LINAC CAVITY: CODE 17
C        ERRORS,MISALIGNEMENTS,PARTICLE CHECK
C       CORRECTOR ELEMENTS
C
 9500 MCHFLG=0
      ICRCHK=0
      IF(ICRFLG.EQ.1) CALL CORCHK(IE)
      IF(MISFLG.EQ.1) CALL MISCHK
      IF((MERFLG.EQ.1).OR.(ICRCHK.EQ.2)) CALL ESET(NEL,MATADR)
c      IMSAV=0
c      isysav=0
cc      IF((NCPART.GT.2).AND.(ISYOPT.LT.1)) THEN
c      IF(NCPART.GT.2) THEN
c          IMSAV=1
c          CALL TRSAV(MATADR)
c      ENDIF
cC
cC GET KICK PARAMETERS FROM ELEMENT DATA
cC
c      DELTAE=ELDAT(IAD+2)
c      PHI0  =ELDAT(IAD+3)*CRDEG
c      AKICK =ELDAT(IAD+5)
c      KONOFF=ELDAT(IAD+6)
cC DEFAULTS (USED IF KONOFF=0)
c      ENOW=1.D0
c      SHIFT=0.D0
cC GET ENERGY IF KICK BEFORE CAVITY
c      IF(KONOFF.LT.0) THEN
c        IF(IE.EQ.1) THEN
c           ENOW=ENJECT
c        ELSE
c           ENOW=EREAL(IE-1)
c        END IF
c      END IF
cC GET ENERGY IF KICK AFTER CAVITY
c      IF(KONOFF.GT.0) THEN
c        ENOW=EREAL(IE)
c      END IF
cC GET KICK MAGNITUDE IF NONZERO
c      IF(KONOFF.NE.0) THEN
c        CPNOW=DSQRT(ENOW**2-EMASS**2)
c        SHIFT=(DELTAE*AKICK*DCOS(PHI0))/CPNOW
c      END IF
c      DO 9501 ICPART=1,NPART
c      IF(.NOT.LOGPAR(ICPART)) GO TO 9501
c      X1=PART(ICPART,1)
c      X2=PART(ICPART,2)
c      X3=PART(ICPART,3)
c      X4=PART(ICPART,4)
c      X5=PART(ICPART,5)
c      X6=PART(ICPART,6)
c      TEST=(X1)**2+(X3)**2
c      IF(TEST.LT.EXPEL2) GO TO 9502
c      WRITE(IOUT,10024)ICPART,IE,(NAME(IZ,NEL),IZ=1,8),NCTURN
c      IF(ISO.NE.0)WRITE(ISOUT,10024)ICPART,IE,(NAME(IZ,NEL),IZ=1,8)
c     <,NCTURN
c      NCPART=NCPART-1
c      LOGPAR(ICPART)=.FALSE.
c      WRITE(IOUT,10300)ICPART,(PART(ICPART,J),J=1,6)
c      GOTO 9501
c 9502 IF(ICRCHK.EQ.1) CALL CSET
c      IF(MCHFLG.EQ.1) CALL MSET
cC
cC  CHECK KICK PARAMETERS; PROCESS KICK IF REQUIRED
cC
c      IF(KONOFF.EQ.(-2)) X4=X4+SHIFT
c      IF(KONOFF.EQ.(-1)) X2=X2+SHIFT
c      CALL TRMAT(MATADR,ICPART)
cC
cC  CHECK KICK PARAMETERS; PROCESS KICK IF REQUIRED
cC
c      IF(KONOFF.EQ.1)    Y2=Y2+SHIFT
c      IF(KONOFF.EQ.2)    Y4=Y4+SHIFT
c      IF(MCHFLG.EQ.1) CALL MRESET
c      IF(ICRCHK.EQ.1) CALL CRESET
c      PART(ICPART,1)=Y1
c      PART(ICPART,2)=Y2
c      PART(ICPART,3)=Y3
c      PART(ICPART,4)=Y4
c      PART(ICPART,5)=Y5
c      PART(ICPART,6)=Y6
c      DX5=Y5-X5
c      CPHI(ICPART)=CPHI(ICPART)+CTF*DX5-CLP*X6
c 9501 CONTINUE
      GOTO 99888
C-----------------------------------------------------------------------
C TREAT ARBITRARY ELEMENT : CODE 12 MISALIGNEMENT ERRORS
C
C
12000 MCHFLG = 0
      IERSET = 0
      IF (MISFLG.EQ.1) CALL MISCHK
      IF ( (MERFLG.EQ.1).OR.(ICRCHK.EQ.2) ) CALL ESET(NEL,MATADR)
      CALL ARBIT(IAD,NEL)
      if(mchflg.eq.1)then
        nkode=22
        dmx1=-dx1
        dmxp1=-dxp1
        dmy1=-dy1
        dmyp1=-dyp1
        dmz1=-dz1
        dmdel=-ddel
        dmzc1=dzc1
        dmzs1=-dzs1
        al=0.0d0
        write(10,22005)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >  acleng(ie),al,dmx1,dmxp1,dmy1,dmyp1,dmz1,dmdel,dmzc1,dmzs1
c19003   format(' ',8a1,2i4,2e20.12,/,6e20.12,/,2e20.12,',')
22005   format(' ',8a1,2i4,2e20.12,/,3e20.12,/,3e20.12,/,2e20.12,',')
      endif
C  no treatment of drift, must be done by user in the
C  arbitrary element in fast
C param for abitrary element code 34
       nkode=34
       al=aleng(nel)
        write(10,22006)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >   acleng(ie),al,narbp
22006   format(' ',8a1,2i4,e20.12,e20.12,i4)
       ndat=0
       do 12001 inp=1,narbp
      ndat=ndat+1
      cs(ndat)=para(inp)
      if(ndat.eq.3) then
       write(10,22001)cs(1),cs(2),cs(3)
22001  format(3(' ',e24.16))
       ndat=0
      endif
c      if((ndat.eq.3).and.(inp.ne.narbp)) then
c        write(10,22001)para(inp)
c22001 format(' ',e24.16)
c        ndat=0
c                                         else
c        write(10,22002)para(inp)
c22002 format(' ',e24.16,$)
c      endif
12001 continue
      if(ndat.eq.2) then
       write(10,22002)cs(1),cs(2)
22002  format(2(' ',e24.16),',')
      elseif (ndat.eq.1) then
       write(10,22003)cs(1)
22003  format(' ',e24.16,',')
                         else
      write(10,11007)
      endif
      if(mchflg.eq.1) then
        nkode=23
        dmx2=-dx2
        dmxp2=-dxp2
        dmy2=-dy2
        dmyp2=-dyp2
        dmz2=-dz2
        dmdel=ddel
        dmzc2=dzc2
        dmzs2=-dzs2
        al=0.0d0
        write(10,22003)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >  acleng(ie),al,dmx2,dmxp2,dmy2,dmyp2,dmz2,dmdel,dmzc2,dmzs2
      endif
c      DO 12001 ICPART=1,NPART
c      IF(.NOT.LOGPAR(ICPART)) GO TO 12001
c      X1=PART(ICPART,1)
c      X2=PART(ICPART,2)
c      X3=PART(ICPART,3)
c      X4=PART(ICPART,4)
c      X5=PART(ICPART,5)
c      X6=PART(ICPART,6)
c      IF (ICRCHK.NE.1) THEN
c         IF (MCHFLG.NE.1) THEN
c            CALL TRAFCT(X1,X2,X3,X4,X5,X6,Y1,Y2,Y3,Y4,Y5,Y6,ICPART)
c         ELSE
c            CALL MSET
c            CALL TRAFCT(X1,X2,X3,X4,X5,X6,Y1,Y2,Y3,Y4,Y5,Y6,ICPART)
c            CALL MRESET
c         END IF
c      ELSE
c         CALL CSET
c         IF (MCHFLG.NE.1) THEN
c            CALL TRAFCT(X1,X2,X3,X4,X5,X6,Y1,Y2,Y3,Y4,Y5,Y6,ICPART)
c         ELSE
c            CALL MSET
c            CALL TRAFCT(X1,X2,X3,X4,X5,X6,Y1,Y2,Y3,Y4,Y5,Y6,ICPART)
c            CALL MRESET
c         END IF
c         CALL CRESET
c      END IF
c      PART(ICPART,1)=Y1
c      PART(ICPART,2)=Y2
c      PART(ICPART,3)=Y3
c      PART(ICPART,4)=Y4
c      PART(ICPART,5)=Y5
c      PART(ICPART,6)=Y6
c12001 CONTINUE
      GOTO 99888
C
C TREAT MONITORS : THEY CAN BE MISALIGNED BUT HAVE NO ERRORS
C
13000 MCHFLG=0
      IF(MISFLG.EQ.1)CALL MISCHK
      if(mchflg.eq.1)then
        nkode=22
        dmx1=-dx1
        dmxp1=-dxp1
        dmy1=-dy1
        dmyp1=-dyp1
        dmz1=-dz1
        dmdel=-ddel
        dmzc1=dzc1
        dmzs1=-dzs1
        al=0.0d0
        write(10,11303)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >  acleng(ie),al,dmx1,dmxp1,dmy1,dmyp1,dmz1,dmdel,dmzc1,dmzs1
c11303   format(' ',8a1,2i4,2e20.12,/,6e20.12,/,2e20.12,',')
11303   format(' ',8a1,2i4,2e20.12,/,3e20.12,/,3e20.12,/,2e20.12,',')
      endif
      AL=0.5D0*ALENG(NEL)
      if(al.ne.0.0d0)then
        nkode=0
        write(10,11301)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >   acleng(ie),al
11301   format(' ',8a1,2i4,e20.12,e20.12,',')
      endif
        nkode=3
        aml=0.0d0
        write(10,11301)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >   acleng(ie),aml
      if(al.ne.0.0d0)then
        nkode=0
        write(10,11301)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >   acleng(ie),al
      endif
      if(mchflg.eq.1) then
        nkode=23
        dmx2=-dx2
        dmxp2=-dxp2
        dmy2=-dy2
        dmyp2=-dyp2
        dmz2=-dz2
        dmdel=ddel
        dmzc2=dzc2
        dmzs2=-dzs2
        al=0.0d0
        write(10,11303)(name(jn,nel),jn=1,8),kode(nel),nkode,
     >  acleng(ie),al,dmx2,dmxp2,dmy2,dmyp2,dmz2,dmdel,dmzc2,dmzs2
      endif
c      IF(MRDFLG.EQ.1)CALL RMOCHK(IE)
c      IF(IALFLG.EQ.2)CALL MONCHK(IE)
c        IF((MONFLG.NE.0).OR.(MRDCHK.EQ.1)) THEN
c          AL=0.5D0*ALENG(NEL)
c          ALO2=0.5D0*AL
c          DO 13001 ICPART=1,NPART
c          IF(.NOT.LOGPAR(ICPART))GOTO 13001
c          X1=PART(ICPART,1)
c          X3=PART(ICPART,3)
c          X5=PART(ICPART,5)
c          X2=PART(ICPART,2)
c          X4=PART(ICPART,4)
c          X6=PART(ICPART,6)
c          IF(MCHFLG.EQ.1) CALL MSET
c          CALL TRDRIF
c          PART(ICPART,1)=Y1
c          PART(ICPART,3)=Y3
c          PART(ICPART,5)=Y5
c          PART(ICPART,2)=Y2
c          PART(ICPART,4)=Y4
c          PART(ICPART,6)=Y6
c          DX5=Y5-X5
c          CPHI(ICPART)=CPHI(ICPART)+CTF*DX5-CLP*X6
c13001     CONTINUE
c          IF(IALFLG.EQ.2)CALL DETLPR(IE,ILIST)
c          IF(MRDFLG.EQ.1)CALL READMO(IE)
c          DO 13002 ICPART=1,NPART
c          IF(.NOT.LOGPAR(ICPART))GOTO 13002
c          X1=PART(ICPART,1)
c          X3=PART(ICPART,3)
c          X5=PART(ICPART,5)
c          X2=PART(ICPART,2)
c          X4=PART(ICPART,4)
c          X6=PART(ICPART,6)
c          CALL TRDRIF
c          IF(MCHFLG.EQ.1) CALL MRESET
c          PART(ICPART,1)=Y1
c          PART(ICPART,3)=Y3
c          PART(ICPART,5)=Y5
c          PART(ICPART,2)=Y2
c          PART(ICPART,4)=Y4
c          PART(ICPART,6)=Y6
c          DX5=Y5-X5
c          CPHI(ICPART)=CPHI(ICPART)+CTF*DX5-CLP*X6
c13002     CONTINUE
c          GOTO 13010
c        ENDIF
c      AL=ALENG(NEL)
c      ALO2=0.5D0*AL
c      CALL TRFDR
13010 GOTO 99888
18000 continue
C
C     HVcollimators not implemented yet
C
      goto 99888
20000 CONTINUE
99888 continue
c      IF(IFLMAT.NE.0)CALL RMAT(IE,ILIST)
c      IF(NANAL.EQ.0)GO TO 63
c      DO 64 IEN=1,NENER
c      XCOR(NCTURN,IEN)=PART(IEN,1)
c      XPCOR(NCTURN,IEN)=PART(IEN,2)
c   64 CONTINUE
c   63 IF (NJOB .EQ. 0) GO TO 62
c      NCP = 1
c      DO 61 IC = 1, NCASE
c      XG (NCTURN,IC) = PART(NCP, 1) - XCO
c      XPG(NCTURN,IC) = PART(NCP, 2) - XPCO
c      IF (NJOB .EQ. 2) NCP = NCP + 1
c      YG (NCTURN,IC) = PART(NCP, 3) - YCO
c      YPG(NCTURN,IC) = PART(NCP, 4) - YPCO
c      NCP=NCP+1
c   61 CONTINUE
c   62 CONTINUE
c      IF(NCPART.EQ.0) THEN
c        NCTURN=NTURN
c        NXREQ=NTURN
c      ENDIF
c      IF(IREF.EQ.1)CALL PLPORB(IE,NEL,NELM)
c      IF((MDPRT.EQ.-2).AND.(IFITD.NE.1))GOTO 76
c      IF(MDPRT.EQ.0)GOTO75
c      IF((MDPRT.LE.-1).AND.(IE.NE.NELM))GOTO76
c      IF(IE.EQ.NELM)GOTO75
c      CALL PRTTST(IE,ILIST,IPRT)
c      IF(IPRT.NE.1)GOTO76
c   75 CALL DETLPR(IE,ILIST)
c   76 IF(NPRINT.EQ.0)CALL TRAKPR(0,IEP)
c      IF(NPLOT.EQ.0) THEN
c              NZERO=0
c              NCCUM=1
c              CALL PLOTPR(IEP,NZERO)
c      ENDIF
cC
cC   PRINT AFTER N TURNS AT M LOCATIONS
cC
c   90 MODPR=1
c      MODPL=1
c      IF(NPRINT.GT.0)MODPR=MOD(NCTURN,NPRINT)
c      IF(NPLOT.GT.0)MODPL=MOD(NCTURN,NPLOT)
c      IF((MODPR.EQ.0).OR.(MODPL.EQ.0)) THEN
c                  CALL PRTTST(IE,ILIST,IPRT)
c                  IF(IPRT.EQ.1)THEN
c                          IF(MODPR.EQ.0)CALL TRAKPR(0,IEP)
c                          IF((MODPL.EQ.0).AND.(MLOCAT.NE.0)) THEN
c                             NZERO=0
c                             NCCUM=1
c                             CALL PLOTPR(IEP,NZERO)
c                           ENDIF
c                   ENDIF
c      ENDIF
      IF(IERSET.EQ.1)CALL ERESET(NEL,MATADR)
c      IF(MONFLG.EQ.2)GOTO112
c      IF(NCPART.NE.0) THEN
c      ICHECK=(ITCHCK+(IE-ITRBEG+1))*NCPART-NCHECK
c      IF(ICHECK.GE.100000) THEN
c         WRITE(ISOUT,99110)IE,NCTURN
c         call flush(isout)
c         NCHECK=NCHECK+100000
c      ENDIF
c99110 FORMAT('    AT ELEMENT ',I6,' DURING TURN ',I6)
c      ENDIF
  110 CONTINUE
      write(10,*)' end'
c  112 IF((IALFLG.EQ.1).or.(intflg.eq.1))THEN
c           IF(IXMSTP.NE.0) THEN
c                 ISDBEG=IXS
c                 IBGSTP=IXMSTP
c                           ELSE
c                 ISDBEG=IXS
c           ENDIF
c           IF(IXESTP.NE.0) THEN
c                 IESBEG=IXES
c                 IESTBG=IXESTP
c                           ELSE
c                 IESBEG=IXES
c           ENDIF
c           IERBEG=IERSRT
c      ENDIF
c      IF(IALFLG.EQ.1)CALL DETLPR(ITREND,ILIST)
cC
cC   CHECK THE PLOT REQUESTED FOR THIS TURN
cC
c      IF(NCTURN.LT.NTURN) GO TO 300
c      IF(((NPRINT.NE.-2).AND.(MLOCAT.EQ.0).AND.(NPRINT.NE.0))
c     >.OR.(NPRINT.EQ.-1))
c     >CALL TRAKPR(0,NELM)
c  300 IF((NPLOT.LE.0).OR.(MLOCAT.NE.0)) GO TO 200
c      IF(NCTURN.NE.NXREQ) GO TO 200
c      NZERO = 1
c      IF(NCTURN.EQ.NPLOT) NZERO = 0
c      IF(NCCUM.EQ.1) NZERO = 0
c      IF(NCTURN.EQ.LSTREQ) NCCUM = 1
c      CALL PLOTPR(NELM,NZERO)
c      NXREQ = NXREQ+NPLOT
c  200 IF(NCTURN.LT.NTURN) GO TO 10
      return
      end

      subroutine fitlsq(iend)
C     ***********************
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXELMD = 3000)
      PARAMETER  ( MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      COMMON/FOUT/OUTFL(350)
      COMMON/ANALC/COMPF,RNU0X,CETAX,CETAPX,CALPHX,CBETAX,
     1RMU1X,CHROMX,ALPH1X,BETA1X,
     1RMU0Y,RNU0Y,CETAY,CETAPY,CALPHY,CBETAY,
     1RMU1Y,CHROMY,ALPH1Y,BETA1Y,RMU0X,CDETAX,CDETPX,CDETAY,CDETPY,
     >COSX,ALX1,ALX2,VX1,VXP1,VX2,VXP2,
     >COSY,ALY1,ALY2,VY1,VYP1,VY2,VYP2,NSTABX,NSTABY,NSTAB,NWRNCP
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      COMMON/PRODCT/KODEPR,NEL,NOF
      COMMON/FUNC/BETAX,ALPHAX,ETAX,ETAPX,BETAY,ALPHAY,ETAY,ETAPY,
     <  STARTE,ENDE,DELTAE,DNU,MFPRNT,KOD,NLUM,NINT,NBUNCH
      COMMON/LAYOUT/SHI,XHI,YHI,ZHI,THETAI,PHIHI,PSIHI,CONVH,
     >SRH,XRH,YRH,ZRH,THETAR,PHIRH,PSIRH,NLAY,layflg
      PARAMETER   (mxlcnd = 200)
      PARAMETER   (mxlvar = 100)
      COMMON/FITL/COEF(MXLVAR,6),VALF(MXLCND),
     >  WGHT(MXLCND),RVAL(MXLCND),XM(MXLVAR)
     >  ,EM(MXLVAR),WV,NELF(MXLVAR,6),NPAR(MXLVAR,6),
     >  IND(MXLVAR,6),NPVAR(MXLVAR),NVAL(MXLCND)
     >  ,NSTEP,NVAR,NCOND,ISTART,NDIV,IFITM,IFITD,IFITBM
      COMMON/LIMIT/VLO(MXLVAR),VUP(MXLVAR),WLIM(MXLVAR),
     >  DIS(MXLVAR),NELLIM(MXLVAR),
     >  WGHLIM(MXLVAR),VLOLIM(MXLVAR),VUPLIM(MXLVAR),
     >  DISLIM(MXLVAR),NPRLIM(MXLVAR),IFLCST,LIMFLG,NLIM,NEXP
      COMMON/LMWORK/FVEC(MXLCND),
     >DIAG(MXLVAR),FJAC(MXLCND,MXLVAR),QTF(MXLVAR),WA1(MXLVAR),
     >WA2(MXLVAR),WA3(MXLVAR),WA4(MXLCND),IPVT(MXLVAR)
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
      DIMENSION DEL(20)
      EXTERNAL FFFCT
      COMMON/CNEWLN/NEWLEN
      LOGICAL NEWLEN
      NEWLEN=.FALSE.
      MPRINT=-2
      IFITM=0
      LIMFLG=0
      ISTART=0
      WV=0.0D0
      NORDER=1
      DO 100 I=1,20
      DEL(I)=0.0D0
      VALF(I)=0.0D0
      WGHT(I)=0.0D0
      NVAL(I)=0
      NPVAR(I)=1
      DO 100 J=1,6
      COEF(I,J)=0.0D0
      IF(J.EQ.1)COEF(I,J)=1.0D0
      NELF(I,J)=0
      NPAR(I,J)=0
  100 CONTINUE
      NDIM=mxinp
      NCHAR=0
      NOP=12
      NPRINT=1
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NOP,NPRINT)
      NSTEP=data(1)
      NIT=data(2)
      NVAR=data(3)
      NCOND=data(4)
      IF(data(5).EQ.0.0D0)GOTO 5101
      BETAX=data(5)
      ALPHAX=data(6)
      ETAX=data(7)
      ETAPX=data(8)
      BETAY=data(9)
      ALPHAY=data(10)
      ETAY=data(11)
      ETAPY=data(12)
      GOTO 5102
 5101 BETAX = CBETAX
      ALPHAX = CALPHX
      ETAX = CETAX
      ETAPX = CETAPX
      BETAY = CBETAY
      ALPHAY = CALPHY
      ETAY = CETAY
      ETAPY = CETAPY
5102  CONTINUE
      IF(IFLCST.NE.0) THEN
        DO 6001 IW=1,NLIM
 6001   WGHLIM(IW)=0.0D0
      ENDIF
      IF(NVAR.GT.MXLVAR)THEN
        WRITE(IOUT,6010)MXLVAR
        IF(ISO.NE.0)WRITE(ISOUT,6010)MXLVAR
 6010   FORMAT('  TOO MANY VARIABLES, MAXIMUM IS : ',I4,/,
     >  ' CHANGE PARAMETER MXLVAR ')
        CALL HALT(0)
      ENDIF
      IF(NCOND.GT.MXLCND)THEN
        WRITE(IOUT,6020)MXLCND
        IF(ISO.NE.0)WRITE(ISOUT,6020)MXLCND
 6020   FORMAT('  TOO MANY VARIABLES, MAXIMUM IS : ',I4,/,
     >  ' CHANGE PARAMETER MXLCND ')
        CALL HALT(0)
      ENDIF
      DO 1 IVAR=1,NVAR
      NOP = 0
      NCHAR = 8
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NOP,NPRINT)
      CALL ELID(ICHAR,NELID)
      NELF(IVAR,1)=NELID
      NOP = 1
      NCHAR = 8
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NOP,NPRINT)
      CALL DIMPAR(NELID, ICHAR, IDICT)
      NPAR(IVAR,1) = IDICT
      IF(NPAR(IVAR,1).EQ.1)NEWLEN=.TRUE.
      DEL(IVAR)=data(1)
      IF(IFLCST.NE.0) THEN
        DO 6002 ILIM=1,NLIM
        IF((NELID.EQ.NELLIM(ILIM)).AND.(IDICT.EQ.NPRLIM(ILIM)))THEN
          WGHLIM(IVAR)=WLIM(ILIM)
          VLOLIM(IVAR)=VLO(ILIM)
          VUPLIM(IVAR)=VUP(ILIM)
          DISLIM(IVAR)=DIS(ILIM)
          LIMFLG=1
        ENDIF
 6002   CONTINUE
      ENDIF
    1 CONTINUE
      NCHAR=0
      NOP=3
      DO 2 ICOND=1,NCOND
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NOP,NPRINT)
      NVAL(ICOND)=data(1)
      VALF(ICOND)=data(2)
      RVAL(ICOND)=data(2)
      WGHT(ICOND)=data(3)
      WV=WV+WGHT(ICOND)**2
      NVA=NVAL(ICOND)
      IF(NVA.LE.20)IFITM=2
      IF((NVA.LE.92).AND.IFITM.EQ.0)IFITM=1
      IF((NVA.GE.93).AND.(NVA.LE.98))IFITD=1
      IF((NVA.GE.271).AND.(NVA.LE.278))IFITD=1
      IF((NVA.GE.41).AND.(NVA.LE.61))IFITBM=1
      IF((NVA.GE.71).AND.(NVA.LE.91))IFITBM=1
      IF((NVA.GE.281).AND.(NVA.LE.288))NLAY=1
      IF((NVA.GE.7).AND.(NVA.LE.10))NORDER=2
      IF((NVA.GE.17).AND.(NVA.LE.20))NORDER=2
      IF(IFITD.EQ.1)NORDER=2
      IF((NVA.GE.1031).AND.(NVA.LE.1040)) THEN
         NVAL(ICOND)=NVA-730
         IF(IFITM.EQ.0)IFITM=1
         IF(IFITE(2).EQ.0) THEN
           WRITE(IOUT,19991)
            CALL HALT(255)
         ENDIF
      ENDIF
      IF((NVA.GE.1071).AND.(NVA.LE.1091)) THEN
         NVAL(ICOND)=NVA-780
         IFITBM=1
         IF(IFITE(2).EQ.0) THEN
          WRITE(IOUT,19991)
          CALL HALT(255)
         ENDIF
      ENDIF
19991 FORMAT('  NO SECOND FITPOINT WAS DEFINED, JOB STOPPED')
      IF(NVA.GT.1000)GOTO 2
      IF((NVA.GE.271).AND.(NVA.LE.288))GOTO 2
      IF(NVA.LT.110)GOTO 2
      IF(IFITM.EQ.0)IFITM=1
      IVA=NVA/100
      JVAL= NVA-100*IVA
      JVA=JVAL/10
      KVA=JVAL-10*JVA
      IF(KVA.EQ.0)GOTO 10
      NORDER=2
      NVAL(ICOND)=100+6*(6*JVA-JVA*(JVA-1)/2+KVA-1) + IVA
      GOTO2
   10 NVAL(ICOND)=6*(JVA-1)+IVA+100
    2 CONTINUE
      NOP=1
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NOP,NPRINT)
      NASP=data(1)
      IF (NASP.EQ.0)GOTO 50
      NOP=2
      DO 3 IASP=1,NASP
      NCHAR=8
      NOP=1
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NOP,NPRINT)
      CALL ELID(ICHAR,NELID)
      DO 31 IEL=1,NVAR
      IF(NELID.EQ.NELF(IEL,1))GOTO 32
   31 CONTINUE
      WRITE(IOUT,99990) ICHAR
99990 FORMAT('  ELEMENT NAME ',8A1,' NOT IN BASE ELEMENT LIST ')
      CALL HALT(259)
   32 JPAS=IEL
      NPAS=data(1)+1
      NPVAR(JPAS)=NPAS
      DO 4 KPAS=2,NPAS
      NCHAR=8
      NOP=0
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NOP,NPRINT)
      CALL ELID(ICHAR,NELID)
      NELF(JPAS,KPAS)=NELID
      NCHAR = 8
      NOP = 1
      IF((IASP.EQ.NASP).AND.(KPAS.EQ.NPAS))NOP=-1
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NOP,NPRINT)
      CALL DIMPAR(NELID, ICHAR, IDICT)
      NPAR(JPAS,KPAS)= IDICT
      IF(NPAR(JPAS,KPAS).EQ.1)NEWLEN=.TRUE.
      COEF(JPAS,KPAS)=data(1)
    4 CONTINUE
    3 CONTINUE
  50  DO 5 IFL=1,NVAR
      JFF=NPVAR(IFL)
      DO 5 JFL=1,JFF
      NELV=NELF(IFL,JFL)
      IND(IFL,JFL)=IADR(NELV)+NPAR(IFL,JFL)-1
    5 CONTINUE
      DO 200 I=1,NVAR
      VAL=ELDAT(IND(I,1))
      XM(I)=VAL
C      IF((LIMFLG.NE.0).AND.(WGHLIM(I).NE.0.0D0)) THEN
C        ALO=VLOLIM(I)
C        AUP=VUPLIM(I)
C        amid=0.5d0*(alo+aup)
C        xm(i)=dtan(pi*(val-amid)/(aup-alo))
C      endif
      EM(I)=DEL(I)
      JF=NPVAR(I)
      IF (NORDER.EQ.1)NOF=6
      IF (NORDER.EQ.2)NOF=27
      DO 210 J=1,JF
      ELDAT(IND(I,J))=VAL*COEF(I,J)
      CALL MATGEN(NELF(I,J))
  210 CONTINUE
  200 CONTINUE
      IPRINT=0
      NTSTEP=NSTEP+NIT
      NM1=NSTEP-1
      NDIV=3
      CALL FFFCT(NCOND,NVAR,XM,FVEC,IFLAG)
      F=0.0D0
      DO 2010 IC=1,NCOND
 2010 F=F+(FVEC(IC))**2
      F=F/WV
      F=DSQRT(F)
      IF(NOUT.GE.1)
     >WRITE(IOUT,10020)
10020 FORMAT(/,' THE REQUESTED FINAL VALUES ARE : ')
      IF(NOUT.GE.1)
     >WRITE(IOUT,10002)(VALF(I),I=1,NCOND)
      IF(NOUT.GE.3)
     >WRITE(IOUT,10021)
10021 FORMAT('  THE INITIAL VALUES ARE : ')
      IF(NOUT.GE.3)
     >WRITE(IOUT,10002)(OUTFL(NVAL(I)),I=1,NCOND)
      IF(NOUT.GE.3)
     >WRITE(IOUT,10022)F
10022 FORMAT(' THE INITIAL VALUE OF FIT FUNCTION IS ',E14.5)
      INFO=200
      NFEV=-10
      FTOL=TOLLSQ
      MODE=1
      FACTOR=100.0D0
      NMPRNT=100
      LDFJAC=NCOND
      DO 400 IS=1,NTSTEP
      IF(IS.EQ.2)NDIV=2
      IF(IS.LE.NM1)GOTO 1001
      NDIV=1
 1001 FTOL=FTOL/30.0D0
      XTOL=FTOL
      GTOL=FTOL
      EPSFCN=FTOL
      MAXFEV=NVAR*IS*NIT*MAXFAC
      DO 2020 IC=1,NCOND
      VAL0=OUTFL(NVAL(IC))
 2020 RVAL(IC)=VAL0-(VAL0-VALF(IC))/NDIV
      CALL LMDIF(FFFCT,NCOND,NVAR,XM,FVEC,FTOL,XTOL,GTOL,MAXFEV,
     >EPSFCN,DIAG,MODE,FACTOR,NMPRNT,INFO,NFEV,FJAC,LDFJAC,
     >IPVT,QTF,WA1,WA2,WA3,WA4)
      CALL LMDMES(INFO,NFEV)
      F=0.0D0
      DO 3010 IC=1,NCOND
 3010 F=F+((OUTFL(NVAL(IC))-RVAL(IC))*WGHT(IC))**2
      F=F/WV
      F=DSQRT(F)
      IF(IS.EQ.NTSTEP)NORDER=2
      IF(IS.EQ.NTSTEP)NOF=27
      DO 300 I=1,NVAR
      VAL=XM(I)
      IF((LIMFLG.NE.0).AND.(WGHLIM(I).NE.0.0D0))THEN
        ALO=VLOLIM(I)
        AUP=VUPLIM(I)
        ADIS=DISLIM(I)
        IF(VAL.LE.ALO) VAL=(ADIS**2*(ALO-ADIS)*(VAL-ALO)+2.0D0*ALO)/
     >                   (ADIS**2*(VAL-ALO)+2.0D0)
        IF(VAL.GE.AUP) VAL=(ADIS**2*(AUP+ADIS)*(VAL-AUP)+2.0D0*AUP)/
     >                   (ADIS**2*(VAL-AUP)+2.0D0)
C        amid=0.5d0*(alo+aup)
C        val=amid+(aup-alo)*datan(val)/pi
      ENDIF
      JF=NPVAR(I)
      DO 310 J=1,JF
      ELDAT(IND(I,J))=VAL*COEF(I,J)
      CALL MATGEN(NELF(I,J))
  310 CONTINUE
  300 CONTINUE
      IF(NOUT.GE.3)
     >WRITE(IOUT,10001)IS
10001 FORMAT(/,' REQUESTED VALUES AT STEP :',I5)
      IF(NOUT.GE.3)
     >WRITE(IOUT,10002)(RVAL(I),I=1,NCOND)
10002 FORMAT(/,5(' ',4E22.14,/),/)
      IF(NOUT.GE.3)
     >WRITE(IOUT,10003)
10003 FORMAT(/,' ACHIEVED VALUES ')
      IF(NOUT.GE.3)
     >WRITE(IOUT,10002)(OUTFL(NVAL(I)),I=1,NCOND)
      IF(NOUT.GE.1)
     >WRITE(IOUT,10004)
      IF(ISO.NE.0)WRITE(ISOUT,10004)
10004 FORMAT(/,'  FITTED PARAMETERS VALUES ')
      DO 60 IFL=1,NVAR
      JFF=NPVAR(IFL)
      DO 60 J=1,JFF
      NELV=NELF(IFL,J)
      IF(NOUT.GE.1)
     >WRITE(IOUT,10010)NPAR(IFL,J),(NAME(I,NELV),I=1,8)
     >  ,ELDAT(IND(IFL,J))
      IF(ISO.NE.0)WRITE(ISOUT,10010)NPAR(IFL,J),(NAME(I,NELV),I=1,8)
     >  ,ELDAT(IND(IFL,J))
10010 FORMAT('  PARAMETER # ',I3,' OF ',8A1,' = ',E22.14)
   60 CONTINUE
      IF(NOUT.GE.1)
     >WRITE(IOUT,10005) F
      IF(ISO.NE.0)WRITE(ISOUT,10005) F
10005 FORMAT(/,'  THE FIT FUNCTION VALUE IS :',E14.5,/)
  400 CONTINUE
      IFITD=0
      IFITM=0
      IFITBM=0
      CALL LENG
      RETURN
      END
      SUBROUTINE FITMAT(IEND)
C     ***********************
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON/ANALC/COMPF,RNU0X,CETAX,CETAPX,CALPHX,CBETAX,
     1RMU1X,CHROMX,ALPH1X,BETA1X,
     1RMU0Y,RNU0Y,CETAY,CETAPY,CALPHY,CBETAY,
     1RMU1Y,CHROMY,ALPH1Y,BETA1Y,RMU0X,CDETAX,CDETPX,CDETAY,CDETPY,
     >COSX,ALX1,ALX2,VX1,VXP1,VX2,VXP2,
     >COSY,ALY1,ALY2,VY1,VYP1,VY2,VYP2,NSTABX,NSTABY,NSTAB,NWRNCP
      PARAMETER    (MXELMD = 3000)
      PARAMETER  ( MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      COMMON/LAYOUT/SHI,XHI,YHI,ZHI,THETAI,PHIHI,PSIHI,CONVH,
     >SRH,XRH,YRH,ZRH,THETAR,PHIRH,PSIRH,NLAY,layflg
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/PRODCT/KODEPR,NEL,NOF
      DIMENSION VALMAT(100),VALF(10),DEL(10),DVAL(10),QVAL(10),
     >VALR(10),VAL0(10),NPVAR(10),
     >NELFM(10,6),NVAL(10),IND(10,6),NPAR(10,6),
     >LV(10),MV(10)
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
      DIMENSION AMULT(10,6),ADD(10,6)
      DIMENSION OUTP1(20),OUTP2(7)
      EQUIVALENCE (OUTP1(1),COMPF),(OUTP2(1),SRH)
      COMMON/CNEWLN/NEWLEN
      LOGICAL NEWLEN
      NEWLEN=.FALSE.
      DO 100 IFT=1,10
      DEL(IFT)=0.0D0
      VALF(IFT)=0.0D0
      NVAL(IFT)=0
      NPVAR(IFT)=1
      DO 100 JFT=1,6
      AMULT(IFT,JFT)=0.0D0
      ADD(IFT,JFT)=0.0D0
      NELFM(IFT,JFT)=0
      NPAR(IFT,JFT)=0
      IF(JFT.EQ.1)AMULT(IFT,JFT)=1.0D0
  100 CONTINUE
      MPRINT=-2
      NORDER=1
      NDIM=mxinp
      NOF=6
      NCHAR=0
      NOP=3
      NPRINT=1
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NOP,NPRINT)
      NSTEP=data(1)
      NIT=data(2)
      NVAR=data(3)
      DO 1 IVAR=1,NVAR
      NOP=0
      NCHAR=8
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NOP,NPRINT)
      CALL ELID(ICHAR,NELID)
      NELFM(IVAR,1)=NELID
      NOP = 1
      NCHAR = 8
      CALL INPUT(ICHAR, NCHAR, data, NDIM, IEND, NOP, NPRINT)
      CALL DIMPAR(NELID, ICHAR, IDICT)
      NPAR(IVAR,1)=IDICT
      IF(NPAR(IVAR,1).EQ.1)NEWLEN=.TRUE.
      DEL(IVAR)=data(1)
    1 CONTINUE
      NOP=2*NVAR
      NCHAR=0
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NOP,NPRINT)
      DO 3 IVAR=1,NVAR
      NVA=data(2*IVAR-1)
      NVAL(IVAR)=NVA
      IF((NVA.GE.7).AND.(NVA.LE.10))NORDER=2
      IF((NVA.GE.17).AND.(NVA.LE.20))NORDER=2
      IF(NVA.GT.20)NLAY=1
      VALF(IVAR)=data(2*IVAR)
    3 CONTINUE
COLLECT INFORMATION ABOUT ASSOCIATED PARAMETERS
      NCHAR=0
      NDATA=1
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NDATA,NPRINT)
      NASP=data(1)
      IF(NASP.EQ.0)GOTO 55
      DO 104 IASP=1,NASP
      NOP = 0
      NCHAR=8
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NOP,NPRINT)
      CALL ELID(ICHAR,NELID)
      NOP = 1
      NCHAR = 8
      CALL INPUT(ICHAR, NCHAR, data, NDIM, IEND, NOP, NPRINT)
      CALL DIMPAR(NELID, ICHAR, IDICT)
      IPAR = IDICT
CHECK IF NAME IS IN BASE LIST OF VARIED ELEMENTS
      DO 143 IEL=1,NVAR
      IF((NELID.EQ.NELFM(IEL,1)).AND.(IPAR.EQ.NPAR(IEL,1)))GO TO 144
  143 CONTINUE
      WRITE(IOUT,99990)ICHAR,NELID,IPAR,(NELFM(IN,1),IN=1,NVAR),
     >(NPAR(IN,1),IN=1,NVAR)
99990 FORMAT(/,' ELEMENT NAME AND PARAMETER # IS NOT IN BASE LIST',
     >' OF VARIED ELEMENTS',/,' ',8A1,26I6)
      CALL HALT(257)
  144 JPAS=IEL
      NPAS=data(1)+1
      NPVAR(JPAS)=NPAS
      DO 105 KPAS=2,NPAS
      NCHAR=8
      NDATA=0
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NDATA,NPRINT)
      CALL ELID(ICHAR,NELID)
      NELFM(JPAS,KPAS)=NELID
      IF((IASP.EQ.NASP).AND.(KPAS.EQ.NPAS))NDATA=-1
      NCHAR = 8
      NDATA = 2
      CALL INPUT(ICHAR, NCHAR, data, NDIM, IEND, NDATA, NPRINT)
      CALL DIMPAR(NELID, ICHAR, IDICT)
      NPAR(JPAS,KPAS)= IDICT
      AMULT(JPAS,KPAS)=data(1)
      ADD(JPAS,KPAS)=data(2)
  105 CONTINUE
  104 CONTINUE
   55 IF(NORDER.EQ.2)NOF=27
      IF(NLAY.EQ.1)CALL HWPNT
      IF(NLAY.EQ.1)GOTO 110
      CALL MATRIX
      CALL ANAL
      IF(NSTABX.EQ.1.OR.NSTABY.EQ.1) GOTO 50
  110 DO 40 I=1,NVAR
      JFF=NPVAR(I)
      DO 140 JFT=1,JFF
      NELV=NELFM(I,JFT)
  140 IND(I,JFT)=IADR(NELV)+NPAR(I,JFT)-1
      NVA=NVAL(I)
      IF(NVA.LE.20)OUTPUT=OUTP1(NVA)
      IF(NVA.GE.21)OUTPUT=OUTP2(NVA-20)
   40 VAL0(I)=OUTPUT
      DO 141 IFT=1,NVAR
      VAL=ELDAT(IND(IFT,1))
      JFF=NPVAR(IFT)
      DO 141 JFT=1,JFF
      ELDAT(IND(IFT,JFT))=VAL*AMULT(IFT,JFT)+ADD(IFT,JFT)
  141 CALL MATGEN(NELFM(IFT,JFT))
      NITT=NSTEP+NIT
      DO 9 IS=1,NITT
      NDIV=NSTEP-IS+1
      IF(NDIV.LT.1)NDIV=1
      DO 10 I =1,NVAR
   10 VALR(I)=VAL0(I)-(VAL0(I)-VALF(I))/NDIV
      IF(IS.LE.NSTEP)GOTO 14
      DO 12 I=1,NVAR
   12 DEL(I)=DEL(I)/5
   14 DO 4 I=1,NVAR
      VAL=ELDAT(IND(I,1))+DEL(I)
      JFF=NPVAR(I)
      DO 41 JFT=1,JFF
      ELDAT(IND(I,JFT))=VAL*AMULT(I,JFT)+ADD(I,JFT)
   41 CALL MATGEN(NELFM(I,JFT))
      IF(NLAY.EQ.1)CALL HWPNT
      IF(NEWLEN)CALL LENG
      IF(NLAY.EQ.1)GOTO 120
      CALL MATRIX
      CALL ANAL
      IF(NSTABX.EQ.1.OR.NSTABY.EQ.1) GOTO 50
  120 DO 5 IV=1,NVAR
      NVA=NVAL(IV)
      IF(NVA.LE.20)OUTPUT=OUTP1(NVA)
      IF(NVA.GE.21)OUTPUT=OUTP2(NVA-20)
    5 VALMAT((IV-1)*NVAR+I)=(OUTPUT-VAL0(IV))/DEL(I)
      VAL=ELDAT(IND(I,1))-DEL(I)
      DO 42 JFT=1,JFF
      ELDAT(IND(I,JFT))=VAL*AMULT(I,JFT)+ADD(I,JFT)
   42 CALL MATGEN(NELFM(I,JFT))
    4 CONTINUE
      CALL DMINV(VALMAT,NVAR,D,LV,MV)
      IF(IS.EQ.NITT)NORDER=2
      IF(IS.EQ.NITT)NOF=27
      DO 6 I=1,NVAR
    6 DVAL(I)=VALR(I)-VAL0(I)
      DO 7 I=1,NVAR
      QVAL(I)=0.0D0
      DO 8 J=1,NVAR
    8 QVAL(I)=QVAL(I)+VALMAT((I-1)*NVAR+J)*DVAL(J)
      VAL = ELDAT(IND(I,1))+QVAL(I)
      JFF=NPVAR(I)
      DO 43 JFT=1,JFF
      ELDAT(IND(I,JFT))=VAL*AMULT(I,JFT)+ADD(I,JFT)
   43 CALL MATGEN(NELFM(I,JFT))
    7 CONTINUE
      IF(NLAY.EQ.1)CALL HWPNT
      IF(NEWLEN)CALL LENG
      IF(NLAY.EQ.1)GOTO 130
      CALL MATRIX
      CALL ANAL
      IF(NSTABX.EQ.1.OR.NSTABY.EQ.1) GOTO 50
  130 DO 11 I=1,NVAR
      NVA=NVAL(I)
      IF(NVA.LE.20)OUTPUT=OUTP1(NVA)
      IF(NVA.GE.21)OUTPUT=OUTP2(NVA-20)
   11 VAL0(I)=OUTPUT
    9 CONTINUE
      IF(ISO.NE.0)WRITE(ISOUT,10011)
      IF(NOUT.GE.1)
     >WRITE(IOUT,10011)
10011 FORMAT(//,' THE FITTED PARAMETERS ARE : ')
      DO 60 IP=1,NVAR
      JFF=NPVAR(IP)
      DO 60 JFT=1,JFF
      NELV=NELFM(IP,JFT)
      IF(NOUT.GE.1)
     >WRITE(IOUT,10010)NPAR(IP,JFT),(NAME(J,NELV),J=1,8),
     >ELDAT(IND(IP,JFT))
      IF(ISO.NE.0)
     > WRITE(ISOUT,10010)NPAR(IP,JFT),(NAME(J,NELV),J=1,8)
     >,ELDAT(IND(IP,JFT))
10010 FORMAT('  PARAMETER # ',I3,' OF ',8A1,' = ',E22.14)
   60 CONTINUE
      IF(NLAY.EQ.1)CALL HWPNT
      IF(NLAY.EQ.1)GOTO 131
      CALL PRANAL(NORDER)
  131 RETURN
   50 WRITE (IOUT,99998)
      IF(ISO.NE.0)WRITE(ISOUT,99998)
99998 FORMAT('   UNSTABLE MOTION ENCOUNTERED DURING FIT',
     >' COMPUTATION ',/,'  JOB HALTED ')
      CALL HALT(258)
      END
      SUBROUTINE FITPT(IEND)
C     ***********************
      IMPLICIT REAL*8 (A-H,O-Z)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      PARAMETER  ( MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
      CHARACTER*1 NAME,LABEL
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      NCHAR = 0
      NDATA = 1
      NPRINT=1
      NDIM=mxinp
      CALL INPUT(ICHAR, NCHAR, data, NDIM, IEND, NDATA, NPRINT)
      NIND=data(1)
      DO 10 INP=1,NIND
      NCHAR = 8
      NDATA = 0
      NPRINT=1
      CALL INPUT(ICHAR, NCHAR, data, NDIM, IEND, NDATA, NPRINT)
      DO 1 IN=1,NA
      DO 2 INC=1,8
      IF(ICHAR(INC).NE.NAME(INC,IN))GOTO 1
    2 CONTINUE
      GOTO 3
    1 CONTINUE
      WRITE(IOUT,10001)ICHAR
10001 FORMAT(/,'  FITNAME IS NOT IN NAMELIST :',8A1)
      CALL HALT(256)
    3 DO 4 IFP=1,NELM
      IF(NORLST(IFP).EQ.IN) GOTO 5
    4 CONTINUE
      WRITE(IOUT,10002)ICHAR
10002 FORMAT(/,'  FITNAME IS NOT IN MACHINE LIST :',8A1)
      CALL HALT(256)
    5 IFITE(INP)=IFP
   10 CONTINUE
      RETURN
      END
C     ***********************
      SUBROUTINE FLEN2(IELM,MATADR)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER  ( MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/PRODCT/KODEPR,NEL,NOF
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      IAD=IADR(IELM)
      AL=ELDAT(IAD)
      AK=ELDAT(IAD+1)
      IF(KUNITS.EQ.1) AK = -AK
      call flen2m(al,ak,matadr)
      RETURN
      END
C     ***********************
      SUBROUTINE FLEN2m(al,ak,MATADR)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER  ( MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/PRODCT/KODEPR,NEL,NOF
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      DO 100 I=1,6
      DO 100 J=1,NOF
      AMAT(J,I,MATADR)=0.0D0
      IF(I.EQ.J) AMAT(J,I,MATADR)=1.0D0
  100 CONTINUE
      SQAK=DSQRT(DABS(AK))
      ARGM=SQAK*AL
      CSIN=DSIN(ARGM)
      CCOS=DCOS(ARGM)
      HSIN=DSINH(ARGM)
      HCOS=DCOSH(ARGM)
      IF(AK)2,4,1
    1 A=CCOS
      B=CSIN
      C=HCOS
      D=HSIN
      E=-B
      F=D
      GOTO3
    2 A=HCOS
      B=HSIN
      C=CCOS
      D=CSIN
      E=B
      F=-D
    3 P=B/SQAK
      Q=D/SQAK
      AMAT( 1,1,MATADR)=A
      AMAT( 2,1,MATADR)=P
      AMAT( 1,2,MATADR)=E*SQAK
      AMAT( 2,2,MATADR)=A
      AMAT( 3,3,MATADR)=C
      AMAT( 4,3,MATADR)=Q
      AMAT( 3,4,MATADR)=F*SQAK
      AMAT( 4,4,MATADR)=C
      IF(NORDER.EQ.1)RETURN
      R=SQAK*0.5D0
      S=ARGM*0.5D0
      AMAT(12,1,MATADR)=-E*S
      AMAT(17,1,MATADR)=(P-A*AL)*0.5D0
      AMAT(12,2,MATADR)= (A*ARGM+B)*R*DABS(AK)/AK
      AMAT(17,2,MATADR)=-E*S
      AMAT(21,3,MATADR)=-F*S
      AMAT(24,3,MATADR)=(Q-C*AL)*0.5D0
      AMAT(21,4,MATADR)=-(C*ARGM+D)*R*DABS(AK)/AK
      AMAT(24,4,MATADR)=-F*S
C
C     PATH LENGTH
C
      AMAT(7,5,MATADR) = (AK*AL+A*E*SQAK)/4.0D0
      AMAT(8,5,MATADR) = E*B/2.0D0
      AMAT(13,5,MATADR) = (AL+A*B/SQAK)/4.0D0
      AMAT(18,5,MATADR) = (-AK*AL+F*C*SQAK)/4.0D0
      AMAT(19,5,MATADR) = F*D/2.0D0
      AMAT(22,5,MATADR) = (AL+C*D/SQAK)/4.0D0
      RETURN
4     AMAT(2,1,MATADR) = AL
      AMAT(4,3,MATADR) = AL
      IF(NORDER.EQ.1)RETURN
      AMAT(13,5,MATADR) = AL/2.0D0
      AMAT(22,5,MATADR) = AL/2.0D0
      RETURN
      END
      SUBROUTINE FNDELM(ILCOM,KNAME,IELEM)
C---- DEAL WITH ELEMENT NAMELIST
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
      CHARACTER*8       KNAME
C-----------------------------------------------------------------------
C---- ELEMENT TABLE
      PARAMETER         (MAXELM = 5000)
      COMMON /ELMNAM/   KELEM(MAXELM),KETYP(MAXELM),KELABL(MAXELM)
      CHARACTER*8       KELEM,KELABL*14
      CHARACTER*4       KETYP
      COMMON /ELMDAT/   IELEM1,IELEM2,IETYP(MAXELM),IEDAT(MAXELM,3),
     +                  IELIN(MAXELM)
C-----------------------------------------------------------------------
C---- PREVIOUS DEFINITION?
      CALL RDLOOK(KNAME,8,KELEM,1,IELEM1,IELEM)
      IF (IELEM .NE. 0) RETURN
C---- NEW DEFINITION --- ALLOCATE ELEMENT CELL
      IELEM = IELEM1 + 1
      IF (IELEM .GE. IELEM2) CALL OVFLOW(1,MAXELM)
      IELEM1 = IELEM
C---- FILL IN DEFAULT DATA
      IETYP(IELEM) = -1
      IEDAT(IELEM,1) = 0
      IEDAT(IELEM,2) = 0
      IEDAT(IELEM,3) = 0
      IELIN(IELEM) = ILCOM
      KELEM(IELEM) = KNAME
      KETYP(IELEM) = '    '
      RETURN
C-----------------------------------------------------------------------
      END
      SUBROUTINE FNDPAR(ILCOM,KNAME,IPARM)
C---- DEAL WITH PARAMETER NAMELIST
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
      CHARACTER*8       KNAME
C-----------------------------------------------------------------------
C---- PARAMETER TABLE
      PARAMETER         (MAXPAR = 19000)
      COMMON /PARNAM/   KPARM(MAXPAR)
      CHARACTER*8       KPARM
      COMMON /PARDAT/   IPARM1,IPARM2,IPTYP(MAXPAR),IPDAT(MAXPAR,2),
     +                  IPLIN(MAXPAR)
      COMMON /PARVAL/   PDATA(MAXPAR)
C-----------------------------------------------------------------------
C---- PREVIOUS DEFINITION?
      CALL RDLOOK(KNAME,8,KPARM,1,IPARM1,IPARM)
      IF (IPARM .NE. 0) RETURN
C---- NEW DEFINITION --- ALLOCATE PARAMETER CELL
      IPARM = IPARM1 + 1
      IF (IPARM .GE. IPARM2) CALL OVFLOW(2,MAXPAR)
      IPARM1 = IPARM
C---- FILL IN DEFAULT DATA
      IPTYP(IPARM) = -1
      IPDAT(IPARM,1) = 0
      IPDAT(IPARM,2) = 0
      PDATA(IPARM) = 0.0
      IPLIN(IPARM) = ILCOM
      KPARM(IPARM) = KNAME
      RETURN
C-----------------------------------------------------------------------
      END
      SUBROUTINE FORB(M,NF,X,FVEC,IFLAG)
C     ********************************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      COMMON/PLT/
     1XMIN,XMAX,YMIN,YMAX,XPMIN,XPMAX,YPMIN,YPMAX,ALMIN,ALMAX,
     >DELMIN,DELMAX,DNUMIN,DNUMAX,DBMIN,DBMAX,
     2MALL,NPLOT,NCCUM,NGRAPH,NCOL,NLINE
      COMMON/CHPLT/MXXPR,MYYPR,MXY,MALE
      CHARACTER*1 MALE(101,51),MXXPR(101,51),MYYPR(101,51),MXY(101,51)
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      COMMON /CFORB/ALCO,DELCO
      DIMENSION X(6),FVEC(6)
      LOGICAL LOGPAR
      LOGPAR(1)=.TRUE.
      NPART=1
      NCPART=1
      NTURN=1
      NCTURN=0
      NPRINT=-2
      NPLOT=-2
      PART(1,1)=X(1)
      PART(1,2)=X(2)
      PART(1,3)=X(3)
      PART(1,4)=X(4)
      IF(M.EQ.4) THEN
         PART(1,5)=ALCO
         PART(1,6)=DELCO
      ENDIF
      IF(M.EQ.6) THEN
           PART(1,5)=X(5)
           PART(1,6)=X(6)
      ENDIF
      CALL TRACKT
      FVEC(1)=PART(1,1)-X(1)
      FVEC(2)=PART(1,2)-X(2)
      FVEC(3)=PART(1,3)-X(3)
      FVEC(4)=PART(1,4)-X(4)
      IF(M.EQ.6) THEN
      FVEC(5)=PART(1,5)-X(5)
      FVEC(6)=PART(1,6)-X(6)
      ENDIF
      RETURN
      END
      SUBROUTINE FORM(IN,IPOS,STR)
      CHARACTER*1 STR(1),IBL
      CHARACTER*1 IDIGIT(10)
      DATA IDIGIT/'0','1','2','3','4','5','6','7','8','9'/
      DATA IBL/' '/
      IT=IN/10
      IF(IT.EQ.0) THEN
           STR(IPOS)=IBL
                  ELSE
           STR(IPOS)=IDIGIT(IT+1)
      ENDIF
      IU=IN-IT*10
      STR(IPOS+1)=IDIGIT(IU+1)
      RETURN
      END
      SUBROUTINE FRMSET(IBEAM,LACT,ERROR)
C---- REPLACE FORMAL ARGUMENTS
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
      LOGICAL           ERROR
C-----------------------------------------------------------------------
C---- ELEMENT TABLE
      PARAMETER         (MAXELM = 5000)
      COMMON /ELMNAM/   KELEM(MAXELM),KETYP(MAXELM),KELABL(MAXELM)
      CHARACTER*8       KELEM,KELABL*14
      CHARACTER*4       KETYP
      COMMON /ELMDAT/   IELEM1,IELEM2,IETYP(MAXELM),IEDAT(MAXELM,3),
     +                  IELIN(MAXELM)
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- LINK TABLE
      PARAMETER         (MAXLST = 14000)
      COMMON /LPDATA/   IUSED,ILDAT(MAXLST,6)
C-----------------------------------------------------------------------
      ERROR = .FALSE.
      LB = LENGTH(KELEM(IBEAM))
C---- VALID REPLACEMENT?
      IFORM1 = IEDAT(IBEAM,1)
      IFORM2 = IEDAT(IBEAM,2)
      IF (IFORM1 .EQ. 0 .AND. LACT .EQ. 0) RETURN
      IF (IFORM1 .EQ. 0) THEN
        WRITE (IECHO,910) KELEM(IBEAM)(1:LB)
        GO TO 700
      ENDIF
      IF (LACT .EQ. 0) THEN
        WRITE (IECHO,920) KELEM(IBEAM)(1:LB)
        GO TO 700
      ENDIF
C---- REPLACE FORMAL ARGUMENTS BY ACTUAL ARGUMENTS
      IACT = ILDAT(LACT,3)
      DO 10 IFORM = IFORM2, IFORM1, -1
        IF (ILDAT(IACT,1) .EQ. 1) THEN
          WRITE (IECHO,930) KELEM(IBEAM)(1:LB)
          GO TO 700
        ENDIF
        IHEAD = IEDAT(IFORM,3)
        ICELL = ILDAT(IHEAD,3)
        ILDAT(ICELL,1) = ILDAT(IACT,1)
        ILDAT(ICELL,4) = ILDAT(IACT,4)
        ILDAT(ICELL,5) = ILDAT(IACT,5)
        ILDAT(ICELL,6) = ILDAT(IACT,6)
        IACT = ILDAT(IACT,3)
   10 CONTINUE
      IF (ILDAT(IACT,1) .NE. 1) THEN
        WRITE (IECHO,940) KELEM(IBEAM)(1:LB)
        GO TO 700
      ENDIF
      RETURN
C---- ERROR EXIT
  700 NFAIL = NFAIL + 1
      ERROR = .TRUE.
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT('0*** ERROR *** ACTUAL ARGUMENT LIST IS REDUNDANT ',
     +       'FOR LINE "',A,'"'/' ')
  920 FORMAT('0*** ERROR *** ACTUAL ARGUMENT LIST IS MISSING ',
     +       'FOR LINE "',A,'"'/' ')
  930 FORMAT('0*** ERROR *** TOO FEW ACTUAL ARGUMENTS FOUND ',
     +       'FOR LINE "',A,'"'/' ')
  940 FORMAT('0*** ERROR *** TOO MANY ACTUAL ARGUMENTS FOUND ',
     +       'FOR LINE "',A,'"'/' ')
C-----------------------------------------------------------------------
      END
      SUBROUTINE GABAN
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      PARAMETER  (MXGACA = 15)
      PARAMETER  (MXGATR = 1030)
      COMMON/GEOM/XCO,XPCO,YCO,YPCO,NCASE,NJOB,
     <    EPSX(MXGACA),EPSY(MXGACA),XI(MXGACA),YI(MXGACA),
     <    XG(MXGATR,MXGACA),
     <    XPG(MXGATR,MXGACA),YG(MXGATR,MXGACA),YPG(MXGATR,MXGACA),
     <    LCASE(MXGACA)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      COMMON/PLT/
     1XMIN,XMAX,YMIN,YMAX,XPMIN,XPMAX,YPMIN,YPMAX,ALMIN,ALMAX,
     >DELMIN,DELMAX,DNUMIN,DNUMAX,DBMIN,DBMAX,
     2MALL,NPLOT,NCCUM,NGRAPH,NCOL,NLINE
      COMMON/CHPLT/MXXPR,MYYPR,MXY,MALE
      CHARACTER*1 MALE(101,51),MXXPR(101,51),MYYPR(101,51),MXY(101,51)
      COMMON/CFFT/fbetax,falphx,fbetay,falphy,fnux,fnuy,ifftan,nprplt
      DIMENSION A(9),B(3),EPSCX(MXGATR),EPSCY(MXGATR),
     >AMUX(MXGATR),AMUY(MXGATR)
      LOGICAL LCASE
      CHARACTER*28 NPTIT
      DATA NPTIT/'nux nuy diagram             '/
      DO 1 NC = 1, NCASE
      IF(LCASE(NC))GOTO20
      WRITE(IOUT,10012) EPSX(NC), EPSY(NC)
10012 FORMAT(/,'  CASE OF EPSX =',E10.3,'  EPSY =',E10.3,/,
     <'  NOT ANALYSED BECAUSE OF LOST PARTICLES  ',/)
      GO TO 1
   20 WRITE(IOUT,10010)EPSX(NC),EPSY(NC)
10010 FORMAT(/,'  VALUES FOR NOMINAL EPSX =',E10.3,/,
     >'     AND FOR NOMINAL EPSY =',E10.3,//)
      IPLOTX=0
      IPLOTY=0
      IFLGX=0
      IFLGY=0
      BETAVX=1.0D0
      BETAVY=1.0D0
      GAMAVX=1.0D0
      GAMAVY=1.0D0
      ALPAVX=1.0D0
      ALPAVY=1.0D0
      IF(EPSX(NC).EQ.0.0D0)GOTO10
      SUMX1 = 0.0D0
      SUMX2 = 0.0D0
      SUMX3 = 0.0D0
      SUMX4 = 0.0D0
      SUMX5 = 0.0D0
      SUMX6 = 0.0D0
      SUMX7 = 0.0D0
      SUMX8 = 0.0D0
      SUMY1 = 0.0D0
      SUMY2 = 0.0D0
      SUMY3 = 0.0D0
      SUMY4 = 0.0D0
      SUMY5 = 0.0D0
      SUMY6 = 0.0D0
      SUMY7 = 0.0D0
      SUMY8 = 0.0D0
      DO 2 NT = 1, NTURN
      X = XG(NT,NC)
      XP = XPG(NT,NC)
      Y = YG(NT,NC)
      YP = YPG(NT,NC)
      X2 = X*X
      Y2 = Y*Y
      XP2 = XP*XP
      YP2 = YP*YP
      X3 = X2*X
      Y3 = Y2*Y
      XP3 = XP2*XP
      YP3 = YP2*YP
      X4 = X3*X
      Y4 = Y3*Y
      XP4 = XP3*XP
      YP4 = YP3*YP
      SUMX1 = SUMX1 + X4
      SUMY1 = SUMY1 + Y4
      SUMX2 = SUMX2 + X3*XP
      SUMY2 = SUMY2 + Y3*YP
      SUMX3 = SUMX3 + X2*XP2
      SUMY3 = SUMY3 + Y2*YP2
      SUMX4 = SUMX4 + X*XP3
      SUMY4 = SUMY4 + Y*YP3
      SUMX5 = SUMX5 + XP4
      SUMY5 = SUMY5 + YP4
      SUMX6 = SUMX6 + X2
      SUMY6 = SUMY6 + Y2
      SUMX7 = SUMX7 + X*XP
      SUMY7 = SUMY7 + Y*YP
      SUMX8 = SUMX8 + XP2
      SUMY8 = SUMY8 + YP2
    2 CONTINUE
      A(1) = SUMX1
      A(2) = SUMX3
      A(3) = SUMX2
      A(4) = SUMX3
      A(5) = SUMX5
      A(6) = SUMX4
      A(7) = SUMX2
      A(8) = SUMX4
      A(9) = SUMX3
      B(1) = SUMX6
      B(2) = SUMX8
      B(3) = SUMX7
      CALL DSIMQ(A,B,3,KS)
      CX = B(1)
      BX = B(2)
      AX = B(3)
      ARG=BX*CX-(AX*AX)/4.0D0
      IF(ARG.LT.0.0D0)GOTO 30
      EPSAVX = 1.0D0/(DSQRT(ARG))
      BETAVX = BX*EPSAVX
      ALPAVX = AX*EPSAVX/2.0D0
      GAMAVX = (1.0D0 + ALPAVX*ALPAVX)/BETAVX
      GOTO 10
   30 WRITE(IOUT,99999)ARG
99999 FORMAT(/,'  ELLIPSE COULD NOT BE FITTED TO X DATA, EPS IMAG: ',
     >E12.3/)
      IFLGX=0
   10 IF(EPSY(NC).EQ.0.0D0)GOTO 50
      A(1) = SUMY1
      A(2) = SUMY3
      A(3) = SUMY2
      A(4) = SUMY3
      A(5) = SUMY5
      A(6) = SUMY4
      A(7) = SUMY2
      A(8) = SUMY4
      A(9) = SUMY3
      B(1) = SUMY6
      B(2) = SUMY8
      B(3) = SUMY7
      CALL DSIMQ(A,B,3,KS)
      CY = B(1)
      BY = B(2)
      AY = B(3)
      ARG=BY*CY-(AY*AY)/4.0D0
      IF(ARG.LT.0.0D0)GOTO 11
      EPSAVY = 1.0D0/(DSQRT(ARG))
      BETAVY = BY*EPSAVY
      ALPAVY = AY*EPSAVY/2.0D0
      GAMAVY = (1.0D0 + ALPAVY*ALPAVY)/BETAVY
      GOTO 50
   11 WRITE(IOUT,99998)ARG
99998 FORMAT(/,'  ELLIPSE COULD NOT BE FITTED TO Y DATA, EPS IMAG : ',
     >E12.3,/)
      IFLGY=0
   50 xnumax=-1.0d0
      xnumin=1.0d0
      ynumax=-1.0d0
      ynumin=1.0d0
      DO 3 NT = 1, NTURN
      EPSCX(NT) = GAMAVX*XG(NT,NC)*XG(NT,NC) + BETAVX*XPG(NT,NC)
     < *XPG(NT,NC)  + 2.0D0*ALPAVX*XG(NT,NC)*XPG(NT,NC)
      EPSCY(NT) = GAMAVY*YG(NT,NC)*YG(NT,NC) + BETAVY*YPG(NT,NC)
     < *YPG(NT,NC)  + 2.0D0*ALPAVY*YG(NT,NC)*YPG(NT,NC)
      amux(1)=1.0d10
      amuy(1)=1.0d10
      IF (NT .EQ. 1) GO TO 3
      XIN = XG(NT - 1,NC)
      XPIN = XPG(NT-1,NC)
      XO=XG(NT,NC)
      XPO=XPG(NT,NC)
      ANUM = XO*XPIN-XPO*XIN
      DENOM=XO*(GAMAVX*XIN+ALPAVX*XPIN)+XPO*(BETAVX*XPIN+ALPAVX*XIN)
      AMUX(NT) = DATAN2(ANUM, DENOM)
C      IF(AMUX(NT).LT.0.0D0)AMUX(NT)=AMUX(NT)+TWOPI
      AMUX(NT)=AMUX(NT)/TWOPI
      if(amux(nt).gt.xnumax)xnumax=amux(nt)
      if(amux(nt).lt.xnumin)xnumin=amux(nt)
      YIN=YG(NT-1,NC)
      YPIN=YPG(NT-1,NC)
      YO=YG(NT,NC)
      YPO=YPG(NT,NC)
      ANUM = YO*YPIN-YPO*YIN
      DENOM =YO*(GAMAVY*YIN+ALPAVY*YPIN)+YPO*(BETAVY*YPIN+ALPAVY*YIN)
      AMUY(NT) = DATAN2(ANUM, DENOM)
C     IF(AMUY(NT).LT.0.0D0)AMUY(NT)=AMUY(NT)+TWOPI
      AMUY(NT)=AMUY(NT)/TWOPI
      if(amuy(nt).gt.ynumax)ynumax=amuy(nt)
      if(amuy(nt).lt.ynumin)ynumin=amuy(nt)
    3 CONTINUE
      if(dabs(xnumax-xnumin-1.0d0).lt.0.1d0) then
        do 33 nt=2,nturn
        if(amux(nt).le.0.0d0)amux(nt)=amux(nt)+1.0d0
   33   continue
      endif
      if(dabs(ynumax-ynumin-1.0d0).lt.0.1d0) then
        do 34 nt=2,nturn
        if(amuy(nt).le.0.0d0)amuy(nt)=amuy(nt)+1.0d0
   34   continue
      endif
      WRITE(IOUT,10011)
10011 FORMAT('  AVERAGE :   BETAX',8X,'ALPHAX',7X,'EPSX',9X,'BETAY',
     <8X,'ALPHAY',7X,'EPSY',/)
      WRITE (IOUT, 10001) BETAVX,ALPAVX,EPSAVX,
     >                    BETAVY,ALPAVY,EPSAVY
10001 FORMAT (9X,6E13.5 )
      EXMAX = 0.0D0
      EYMAX = 0.0D0
      SUMX = 0.0D0
      SUMY = 0.0D0
      EXMIN = 1.0D32
      EYMIN = 1.0D32
      amuxmx=-10.0d0
      amuxmn=10.0d0
      amuymx=-10.0d0
      amuymn=10.0d0
      DO 4 NT = 1, NTURN
      IF(EPSCX(NT) .GT. EXMAX)EXMAX = EPSCX(NT)
      IF(EPSCX(NT) .LT. EXMIN)EXMIN = EPSCX(NT)
      IF(EPSCY(NT) .GT. EYMAX)EYMAX = EPSCY(NT)
      IF(EPSCY(NT) .LT. EYMIN)EYMIN = EPSCY(NT)
      IF (NT .EQ. 1) GO TO 4
      SUMX = SUMX + AMUX(NT)
      SUMY = SUMY + AMUY(NT)
      logpar(nt)=.true.
      if(amux(nt).gt.amuxmx)amuxmx=amux(nt)
      if(amux(nt).lt.amuxmn)amuxmn=amux(nt)
      if(amuy(nt).gt.amuymx)amuymx=amuy(nt)
      if(amuy(nt).lt.amuymn)amuymn=amuy(nt)
    4 CONTINUE
      AVNUX = SUMX/(NTURN - 1)
      AVNUY = SUMY/(NTURN - 1)
      SUMX = 0.0D0
      SUMY = 0.0D0
      DO 5 NT =2, NTURN
      SUMX = SUMX + (AMUX(NT)-AVNUX)**2
      SUMY = SUMY + (AMUY(NT)-AVNUY)**2
      if(mod(nt,100).eq.0) then
        rx=epscx(nt)/epsx(nc)
        ry=epscy(nt)/epsy(nc)
        write(iout,10007)rx,ry
10007 format('  ',2f8.4)
      endif
    5 CONTINUE
      SIGNUX = DSQRT(SUMX/(NTURN - 1))
      SIGNUY = DSQRT(SUMY/(NTURN - 1))
      DEX = EXMAX - EXMIN
      DEY = EYMAX - EYMIN
      WRITE(IOUT, 10003)EXMAX, EXMIN, DEX, EYMAX, EYMIN, DEY
10003 FORMAT(/,'   EPSXMAX   EPSXMIN   DELEPSX   EPSYMAX ',
     <'   EPSYMIN   DELEPSY',/,' ',6E10.3,/)
      DEEPSX=DEX/EPSAVX
      DEEPSY=DEY/EPSAVY
      WRITE(IOUT,10006)DEEPSX,DEEPSY
10006 FORMAT(/,' DELEPSX/EPSX   DELEPSY/EPSY ',/,2E10.3,/)
      WRITE(IOUT, 10004) AVNUX, SIGNUX, AVNUY, SIGNUY
10004 FORMAT(/,'   AVENUX     SIGNUX     AVENUY     SIGNUY',/,
     <' ',4E13.5,/)
      XMIN = DSQRT(BETAVX*EXMIN)
      XMAX = DSQRT(BETAVX*EXMAX)
      YMIN = DSQRT(BETAVY*EYMIN)
      YMAX = DSQRT(BETAVY*EYMAX)
      CANOM = XI(NC)*YI(NC)
      CAMIN = XMIN*YMIN
      CAMAX = XMAX*YMAX
      IF(CAMIN.NE.0.0D0)CARAT=CAMAX/CAMIN
      WRITE(IOUT, 10005)CANOM,CAMAX,CAMIN,CARAT
10005 FORMAT(/,'  CROSS SECTIONAL AREAS',//,10X,'  NOMINAL',5X,
     <'  MAXIMUM',5X,'  MINIMUM',5X,'   MAX/MIN',//,10X,4(E10.3,2X),/)
      if(nc.eq.1)then
        fnux=avnux
        fnuy=avnuy
        fbetax=betavx
        falphx=alpavx
        fbetay=betavy
        falphy=alpavy
        xplmax=(int((amuxmx+2.0d0)*4.0d0)+1.0d0)/4.0d0 -2.0d0
        xplmin=(int((amuxmn-2.0d0)*4.0d0)-1.0d0)/4.0d0 +2.0d0
        yplmax=(int((amuymx+2.0d0)*4.0d0)+1.0d0)/4.0d0 -2.0d0
        yplmin=(int((amuymn-2.0d0)*4.0d0)-1.0d0)/4.0d0 +2.0d0
        dx=xplmax-xplmin
        dy=yplmax-yplmin
        dmx=dmax1(dx,dy)
        xplmax=xplmin+dmx
        yplmax=yplmin+dmx
        nzero=0
        nplprt=1
        nchar=39
        ncol=101
        nline=51
        do 551 itst=1,mxpart
        logpar(itst)=.true.
  551   continue
        logpar(1)=.false.
C        do 552 itst=1,100
C       write(IOUT,*)AMUX(itst),amuy(itst),logpar(itst),nturn
C  552   continue
        write(iout,55552)
55552  format('1')
          CALL PLOT(amux,amuy,nturn,XPLMAX,XPLMIN,YPLMAX,YPLMIN,
     >        NplprT,NZERO,NCHAR,NCOL,NLINE,NPTIT,MXY,LOGPAR)
      endif
C          CALL PLOT(amux,amuy,nturn,XPLMAX,XPLMIN,YPLMAX,YPLMIN,
C     >        NplprT,NZERO,NCHAR,NCOL,NLINE,NPTIT,MXY,LOGPAR)
    1 CONTINUE
      if(lcase(1))then
      if(ifftan.eq.1) call fftan
      endif
      RETURN
      END
      FUNCTION GAUSS(IX)
C     *************************
      IMPLICIT REAL*8(A-H,O-Z)
      G=0
      DO 1 I=1,12
    1 G = G+URAND(IX)
      GAUSS = G - 6
      RETURN
      END
C     ***********************
      SUBROUTINE GEABER(IEND)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      COMMON/PLT/
     1XMIN,XMAX,YMIN,YMAX,XPMIN,XPMAX,YPMIN,YPMAX,ALMIN,ALMAX,
     >DELMIN,DELMAX,DNUMIN,DNUMAX,DBMIN,DBMAX,
     2MALL,NPLOT,NCCUM,NGRAPH,NCOL,NLINE
      COMMON/CHPLT/MXXPR,MYYPR,MXY,MALE
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      PARAMETER  (MXGACA = 15)
      PARAMETER  (MXGATR = 1030)
      COMMON/GEOM/XCO,XPCO,YCO,YPCO,NCASE,NJOB,
     <    EPSX(MXGACA),EPSY(MXGACA),XI(MXGACA),YI(MXGACA),
     <    XG(MXGATR,MXGACA),
     <    XPG(MXGATR,MXGACA),YG(MXGATR,MXGACA),YPG(MXGATR,MXGACA),
     <    LCASE(MXGACA)
      COMMON /CTUNE/DNU0X,DNU0Y,DBETX,DBETY,DALPHX,DALPHY,
     >DXCO,DXPCO,DYCO,DYPCO,DDELCO
      COMMON/CFFT/fbetax,falphx,fbetay,falphy,fnux,fnuy,ifftan,nprplt
      CHARACTER*1 MALE(101,51),MXXPR(101,51),MYYPR(101,51),MXY(101,51)
      LOGICAL LCASE
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
      NORDER = 2
      NCHAR = 0
      NOP = -1
      DO 11 IL = 1,MXGACA
  11  LCASE(IL) = .TRUE.
      DO 10 IP = 1, MXPART
   10 LOGPAR(IP) = .TRUE.
      NDIM=mxinp
      NIPR=1
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NOP,NIPR)
      IF(data(1).GT.0.0D0) THEN
      BETAX = data(1)
      ALPHAX = data(2)
      BETAY = data(3)
      ALPHAY = data(4)
      XCO = data(5)
      XPCO = data(6)
      YCO = data(7)
      YPCO = data(8)
      DELTA = data(9)
                             ELSE
      BETAX=DBETX
      ALPHAX=DALPHX
      XCO=DXCO
      XPCO=DXPCO
      BETAY=DBETY
      ALPHAY=DALPHY
      YCO=DYCO
      YPCO=DYPCO
      DELTA=DDELCO
      IF(NOUT.GE.2)WRITE(IOUT,10100)BETAX,ALPHAX,BETAY,ALPHAY,
     >XCO,XPCO,YCO,YPCO,DELTA
10100 FORMAT(' BETAX =',F10.3,' ALPHAX =',F10.3,
     >' BETAY =',F10.3,' ALPHAY =',F10.3,/,
     >' XCO =',E10.3,' XPCO =',E10.3,' YCO =',E10.3,' YPCO =',E10.3,
     >' DELTA =',E10.3,/)
      ENDIF
      NCASE = data(10)
      IF(NCASE .LE. MXGACA) GO TO 6
      NCASE = MXGACA
      WRITE (IOUT,10000)MXGACA
10000 FORMAT (/,' TOO MANY CASES REQUESTED:DEFAULT MAX',I4,' ARE READ',
     >/,' ADJUST PARAMETER MXGACA TO REQUIRED VALUE')
    6 NTURN = data(11)
      IF(NTURN .LE. MXGATR) GO TO 106
      NTURN = MXGATR
      WRITE (IOUT,10060)MXGATR
10060 FORMAT (/,' TOO MANY TURNS REQUESTED:DEFAULT MAX',I5,' ARE USED',
     >/,' ADJUST PARAMETER MXGATR TO REQUIRED VALUE')
  106 NJOB = data(12)
      NPLOT = data(13)
      NPRINT = data(14)
      MLOCAT=0
      EPSXM = 0.0D0
      EPSYM = 0.0D0
      DO 1 NC = 1, NCASE
      IND = (NC-1)*2 + 15
      EPSX(NC) = data(IND)*1.0D-06
      EPSY(NC) = data(IND + 1)*1.0D-06
      IF(EPSX(NC) .GT. EPSXM)EPSXM = EPSX(NC)
      IF(EPSY(NC) .GT. EPSYM)EPSYM = EPSY(NC)
    1 CONTINUE
      nprplt=0
      ifftan=0
      icnt=14+2*ncase
      if(nop.gt.icnt) then
        nprplt=data(icnt+1)
        ifftan=1
*        fbetax=betax
*        falphx=alphax
*        fbetay=betay
*        falphy=alphay
      endif
      NPART = NJOB*NCASE
      NCPART=NPART
      DO 2 NP = 1, NPART
      DO 3 IP = 1, 5
    3 PART(NP, IP) = 0.0D0
      PART(NP, 6) = DELTA
      DEL(NP)=DELTA
    2 CONTINUE
      NCP = 1
      DO 4 INP = 1, NCASE
      XI(INP) = DSQRT(BETAX*EPSX(INP))
      PART(NCP, 1) = XCO + DSQRT(BETAX*EPSX(INP))
      PART(NCP, 2) = XPCO - ALPHAX*DSQRT(EPSX(INP)/BETAX)
      IF (NJOB .EQ. 2) NCP = NCP + 1
      YI(INP) = DSQRT(BETAY*EPSY(INP))
      PART(NCP, 3) = YCO + DSQRT(BETAY*EPSY(INP))
      PART(NCP, 4) = YPCO - ALPHAY*DSQRT(EPSY(INP)/BETAY)
      NCP = NCP + 1
    4 CONTINUE
      IF(NPLOT .EQ. -1) GO TO 5
      XMAX = DSQRT(EPSXM*BETAX)*1.5D0
      XMIN = -XMAX
      XMAX=XMAX+XCO
      XMIN=XMIN+XCO
      YMAX = DSQRT(EPSYM*BETAY)*1.5D0
      YMIN = -YMAX
      YMAX=YMAX+YCO
      YMIN=YMIN+YCO
      GAMMAX = (1.0D0 + ALPHAX*ALPHAX)/BETAX
      GAMMAY = (1.0D0 + ALPHAY*ALPHAY)/BETAY
      NCCUM =0
      NGRAPH = 4
      MALL = 0
      NCOL = 71
      NLINE = 51
      XPMAX = DSQRT(EPSXM*GAMMAX)*1.5D0
      XPMIN = -XPMAX
      XPMAX=XPMAX+XPCO
      XPMIN=XPMIN+XPCO
      YPMAX = DSQRT(EPSYM*GAMMAY)*1.5D0
      YPMIN = -YPMAX
      YPMAX=YPMAX+YPCO
      YPMIN=YPMIN+YPCO
    5 NCTURN = 0
      CALL TRACKT
      IPART = 1
      DO 12 IC = 1, NCASE
      DO 12 IJ = 1, NJOB
      IF(.NOT.LOGPAR(IPART))LCASE(IC) = .FALSE.
      IPART = IPART + 1
   12 CONTINUE
      CALL GABAN
      NJOB = 0
      RETURN
      END

      SUBROUTINE GENER(IEND)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      PARAMETER  (mxmis = 1000)
      COMMON/MIS/RMISA(8,MXMIS),MISELE(MXMIS),NMIS,NOPT,
     >NMISE,MISSEL(MXMIS),NMRNGE(MXMIS),
     >MSRNGE(2,10,MXMIS),MISFLG,MCHFLG
      COMMON/CSEEDS/ISEED,IXG,IXS,IXMSTP,IMSD,IMOSTP,ISYNSD,ISYSTP,
     >ISDBEG,IBGSTP,IXES,IXESTP,IESBEG,IESTBG,isdcol
      COMMON/CBEAM/BSIG(6,6),BSIGF(6,6),MBPRT,IBMFLG,MENV
      COMMON/CANAL/ave(6),rms(6),SCALE,IANOPT,IANPRT
      COMMON/CGENER/RSIG(6),GCO(6),cpa(6,6),NGOPT
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
      DIMENSION SIGMA(6)
      DIMENSION A(6,6),D(6),E(6),Z(6,6)
      DIMENSION E2(6),PC(6),IO(6)
      IF(IBMFLG.NE.0)GOTO 351
      WRITE(IOUT,88888)
      IF(ISO.NE.0)WRITE(ISOUT,88888)
88888 FORMAT(//,'    A BEAM MATRIX WAS NOT DEFINED RUN IS STOPPED  ')
      CALL HALT(260)
  351 IF(IEND.GE.0) THEN
       NCHAR=0
       NDIM=mxinp
       NDATA=-1
       NIPR=1
       CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NIPR)
       NGOPT=DATA(1)
       DO 1020 IR=1,6
 1020  RSIG(IR)=DATA(1+IR)
       SCALE=DATA(8)
       NPART=DATA(9)
        DO 200 ICO=1,6
        GCO(ICO)=DATA(9+ICO)
  200   CONTINUE
      ENDIF
      if((ngopt.ge.10).and.((iend.ge.0).or.(iend.eq.-11))) then
        do 201 igm=1,6
        gco(igm)=ave(igm)
        do 202 jgm=1,6
        bsig(igm,jgm)=cpa(igm,jgm)
  202   continue
  201   continue
       endif
      do 901 ia=1,6
      do 901 ja=1,6
  901 a(ia,ja)=0.0d0
      DO 1 ILP=1,MXPART
      DO 2 JLP=1,6
      PART(ILP,JLP)=0.0D0
    2 CONTINUE
    1 LOGPAR(ILP)=.TRUE.
      NCPART=NPART
      NTURN=0
      NCTURN=0
      MGOPT=NGOPT/10
      NGOPT=NGOPT-10*MGOPT
      GOTO(300,100,300),NGOPT
  100 WRITE(IOUT,9999)NGOPT
 9999 FORMAT(/,'   ERROR IN OPTION NUMBER ',I4)
      CALL HALT(261)
  300 continue
      if(npart.gt.1) then
      IXG=ISEED
      NM=6
      MB=6
      N=6
      DO 10 IM=1,6
      DO 11 JM=1,IM
      A(7-JM,IM)=BSIG(IM-JM+1,7-JM)
   11 CONTINUE
   10 CONTINUE
C      write(iout,*)' in gener'
C      write(iout,99999)((a(ia,ja),ja=1,6),ia=1,6)
C99999 format(6(' ',6e12.3,/))
      CALL BANDR(NM,N,MB,A,D,E,E2,.TRUE.,Z)
      CALL TQL2(NM,N,D,E,Z,IERR)
      IF(IERR.NE.0) THEN
        WRITE(IOUT,10100)IERR
        IF(ISO.NE.0)WRITE(ISOUT,10100)IERR
10100 FORMAT(' BEAM MATRIX DIAGONALIZATION FAILED:CHECK FOR ERROR',/,
     >' IN BEAM MATRIX OR FIND A POINT WHERE BEAM IS LESS ',
     >'ELONGATED',/)
        CALL HALT(262)
      ENDIF
      DO 32 IT=1,6
      IF(D(IT).LE.0.0D0) THEN
        WRITE(IOUT,320)IT,D(IT)
        IF(ISO.NE.0)WRITE(ISOUT,320)IT,D(IT)
  320 FORMAT(' NUMBER',I2,' EIGENVALUE',E12.3,' IS NON POSITIVE',/,
     >' BEAM ELLIPSE PROBABLY TOO ELONGATED, DIAGONALIZATION FAILED',
     >/,' FIND ANOTHER POINT AT WHICH TO GENERATE THE BEAM',/)
        CALL HALT(262)
      ENDIF
   32 CONTINUE
      DO 33 IT=1,6
      ZMAX=0.0D0
      DO 34 JT=1,6
      ZABS=DABS(Z(JT,IT))
      IF(ZABS.GT.ZMAX) THEN
        IO(IT)=JT
        ZMAX=ZABS
      ENDIF
   34 CONTINUE
   33 CONTINUE
      DO 4 IB=1,6
      SIGMA(IB)=DSQRT(D(IB))
    4 CONTINUE
      DO 301 IP=1,NPART
      DO 303 JP=1,6
  302 FACT=GAUSS(IXG)
      IF(DABS(FACT).GT.RSIG(IO(JP)))GOTO 302
  303 PART(IP,JP)=FACT*SIGMA(JP)*SCALE
      IF(NGOPT.EQ.1) THEN
          SCF=0.0D0
          DO 304 JP=1,6
  304     SCF=SCF+(PART(IP,JP)/SIGMA(JP))**2
          SCF=DSQRT(SCF)
          DO 305 JP=1,6
  305     PART(IP,JP)=SCALE*PART(IP,JP)/SCF
      ENDIF
  301 CONTINUE
      endif
      DO 19 IP=1,NPART
      DO 20 IPP=1,6
      PC(IPP)=PART(IP,IPP)
   20 CONTINUE
      DO 21 IPP=1,6
      PART(IP,IPP)=0.0D0
      DO 22 JPP=1,6
      PART(IP,IPP)=PART(IP,IPP)+Z(IPP,JPP)*PC(JPP)
   22 CONTINUE
      PART(IP,IPP)=PART(IP,IPP)+GCO(IPP)
   21 CONTINUE
      DEL(IP)=PART(IP,6)
   19 CONTINUE
      RETURN
      END
      SUBROUTINE GENRAL(IELM,MATADR)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      IAD = IADR(IELM)
C
C     GET NUMBER OF PARAMETERS
C
      NUM = IADR(IELM+1)-IAD-1
      IF(NUM/2*2.EQ.NUM) GO TO 10
      WRITE(IOUT,5) NUM
      IF(ISO.NE.0)WRITE(ISOUT,5) NUM
5     FORMAT(/,' ERROR IN GENERAL MATRIX PARAMETERS ',I5,
     +'  SHOULD BE A MULTIPLE OF TWO',/)
      CALL HALT(265)
10    CONTINUE
C
C     CLEAR AMAT(27,6,MATADR)
C
      DO 20 I=1,6
      DO 20 J=1,27
      AMAT(J,I,MATADR) = 0.0D0
C      IF(I.EQ.J) AMAT(J,I,MATADR) = 1.0D0
20    CONTINUE
C
C     SET UP AMAT (N,6,27)
C
      DO 50 IP = 1,NUM,2
      NIND=ELDAT(IAD+IP)
      I=NIND/100
      JIND=NIND-I*100
      J=JIND/10
      K=JIND-J*10
      VALUE=ELDAT(IAD+IP+1)
C
C     CHECK 'K' IS VALID AND IF THIS A SECOND OR FIRST
C        ORDER TERM
C
      IF (K.EQ.0) GO TO 40
      IF (K.GE.J) GO TO 30
      WRITE(IOUT,25) J,K
      IF(ISO.NE.0)WRITE(ISOUT,25) J,K
25    FORMAT(/,' ERROR IN DEFINING GENERAL MATRIX, K<J',2I5,/)
      CALL HALT(266)
30    J = K+(13-J)*J/2
40    AMAT(J,I,MATADR) = VALUE
50    CONTINUE
      RETURN
      END
C******************************
      subroutine getop(kod,ikod,ititop,nwpg)
C******************************
      IMPLICIT REAL*8 (A-H,O-Z)
      character*1 ititop(80)
      COMMON/CUPLO/LOTOUP,UPTOLO(26)
      COMMON/DETL/DENER(15),NH,NV,NVH,NHVP(105),MDPRT,NDENER,
     1NUXS(45),NUX(45),NUYS(45),NUY(45),NCO,NHNVHV,MULPRT,NSIG
      COMMON/BETAL/BETA0X,ALPH0X,ETA0X,ETAP0X,
     >BETA0Y,ALPH0Y,ETA0Y,ETAP0Y,X0,XP0,Y0,YP0,DLEN0
     >,DX0,DXP0,DY0,DYP0,DEL0,XS(15),XPS(15),YS(15),YPS(15),DLENS(15)
      COMMON/TRI/WCO(15,6),GEN(5,4),PGEN(75,6),DIST,
     <A1(15),B1(15),A2(15),B2(15),XCOR(3,15),XPCOR(3,15),
     1AL1(15),AL2(15),MESH,NIT,NENER,NITX,NITS,NITM1,NANAL,NOPRT
      PARAMETER    (mxpart = 128000)
      COMMON/ARB/PARA(20),NarT(MXPART),NARBP
      COMMON/ORBIT/SIZEX,SIZEY,RMSX,RMSY,RMSIX,RMSIY,
     >RTEMPX,RTEMPY,RMSPX(5),RMSPY(5),RPX,RPY,
     >RMAXX,RMAXY,RMINX,RMINY,MAXX,MAXY,MINX,MINY,PLENG,
     >IRNG,IRANGE(5),NPRORB,IORB,IREF,IPAGE,IPOINT
      COMMON/LAYOUT/SHI,XHI,YHI,ZHI,THETAI,PHIHI,PSIHI,CONVH,
     >SRH,XRH,YRH,ZRH,THETAR,PHIRH,PSIRH,NLAY,layflg
      PARAMETER  (mxlcnd = 200)
      PARAMETER  (mxlvar = 100)
      COMMON/FITL/COEF(MXLVAR,6),VALF(MXLCND),
     >  WGHT(MXLCND),RVAL(MXLCND),XM(MXLVAR)
     >  ,EM(MXLVAR),WV,NELF(MXLVAR,6),NPAR(MXLVAR,6),
     >  IND(MXLVAR,6),NPVAR(MXLVAR),NVAL(MXLCND)
     >  ,NSTEP,NVAR,NCOND,ISTART,NDIV,IFITM,IFITD,IFITBM
      COMMON/MONFIT/VALFA(MXLCND),WGHTA(MXLCND),ERRA(MXLCND),
     >AMULTA(MXLVAR,6),ADDA(MXLVAR,6),DELA(MXLVAR)
     >,NPARA(MXLVAR,6),NELFA(MXLVAR,6),
     >NPVARA(MXLVAR),INDA(MXLVAR,6),VALR(MXLCND),RMOSIG,
     >NMONA(MXLCND),NVALA(MXLCND),NVARA,NCONDA
     >,IALFLG,MONFLG,MONLST,NOPTER,
     >IAFRST,IMOOPT,IMSBEG,NALPRT
      CHARACTER*26      LOTOUP
      CHARACTER*1       UPTOLO
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      common/cinp/iop
      CHARACTER*1 ibl,IBRKT,ISTAR,IAT,IEXCL,ic1
      DATA IBRKT/'('/,ISTAR/'*'/,IAT/'@'/,IEXCL/'!'/
      data ibl/' '/
C
C   READ AN OPERATION CODE
C
      iop=0
99134 READ(IIN,9998)ITITOP
 9998 FORMAT(80A1)
C---- CHANGE UPPER CASE TO LOWER
      DO 919 IUL=1,72
        INDX = INDEX(LOTOUP, ITITOP(IUL))
        IF(INDX.NE.0) ITITOP(IUL) = UPTOLO(INDX)
 919  CONTINUE
      KCOM=0
      IC1=ITITOP(1)
      IF((IC1.EQ.IBRKT).OR.(IC1.EQ.ISTAR).OR.(IC1.EQ.IAT)
     >.OR.(IC1.EQ.IEXCL))KCOM=1
      IF(KCOM.EQ.1)WRITE(IOUT,9996)ITITOP
 9996 FORMAT('   ',80A1)
      IF(KCOM.EQ.1)GOTO 99134
      DO 99132 ICRD=1,80
      IF(ITITOP(ICRD).NE.IBL)GOTO 99133
99132 CONTINUE
      GOTO 99134
99133 CONTINUE
C
C     DETERMINE THE OPERATION CODE
C
      CALL OPTITL(ITITOP,KOD)
      IKOD=(KOD+1)/100
      IF((IKOD.EQ.14).AND.(NALPRT.NE.1))GOTO 134
      IF((NOUT.GE.2).and.(nwpg.eq.1))WRITE(IOUT,10200)
10200 FORMAT('1')
      IF(NOUT.GE.2)WRITE(IOUT,10021)
C============================================================ FWJ
CC10021  FORMAT(17H OPERATION LIST ,///)
10021  FORMAT(17H OPERATION LIST ,/)
CC      IF(NOUT.GE.2)WRITE(IOUT,19999)KTIT
C============================================================
      IF(NOUT.GE.1)WRITE(IOUT,9997)ITITOP
      IF(ISO.NE.0)   then
            WRITE(ISOUT,99971)ITITOP
      endif
99971 FORMAT(' ',80A1)
C============================================================ FWJ
CC 9997 FORMAT(/,'   ',80A1,//)
 9997 FORMAT('   ',80A1,/)
C============================================================
      NALPRT=1
  134 MDPRT=-2
      NANAL=0
      NARBP=0
      IREF=0
      NLAY=0
      IALFLG=0
      MONFLG=0
      IFITM=0
      IFITBM=0
      IFITD=0
      return
      end
C     ***********************
      SUBROUTINE HALT(IHERR)
C     ***********************
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      common/cinter/inumel,niplot,intflg,iprpl,jherr,itrap,
     > numel(20),iscx(20),iscy(20),
     > iscsx(20),iscsy(20),avx(11,101),avy(11,101),axis(101)
      character*1 avx,avy,axis
      DIMENSION KERR(80)
      CHARACTER*20 ERRMES(81),ERMES1(50),ERMES2(31)
      EQUIVALENCE (ERRMES(1),ERMES1(1)),(ERRMES(51),ERMES2(1))
      DATA KERR/0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,
     >17,18,
     >100,101,102,103,
     >200,201,202,203,204,205,206,210,211,215,220,221,223,
     >230,235,236,240,241,245,246,250,251,252,255,256,257,258,
     >259,260,261,262,265,266,270,271,272,273,275,276,277,278,
     >280,281,282,285,286,288,290,
     >300,301,302,303,304,305,310,320,400/
      DATA ERMES1/
     >'ARR MXLVAR MXLCOND','ARRSIZE MAXCOR    ','ARRSIZE MXLIST    ',
     >'ARRSIZE MAXMAT    ','ARRSIZE MAXPOS    ','ARRSIZE MAXELM    ',
     >'ARRSIZE MAXDAT','ARRSIZE MXELMD','ARRSIZE ','ARRSIZE MAXPAR',
     >'ARRSIZE MAXLST',
     >'ARRSIZE SEQUENCE','ARRSIZE HARMON','ARRSIZE ADIAPAR',
     >'ARR SHOMIS INTVAL#','ARR SHOMIS ELM #','ARRSIZE MXMTR',
     >'ARR PRT TYPE #','ARR PRT NAME #',
     >'MAD INP MAJOR ERR','MADIN NORMAL END','MADIN READ ERROR',
     >'MADIN SCAN STOP',
     >'ADIA:OPTION ERR','ALIG:NOCORR FOUND','ALIG:MORE MONIT',
     >'ALIG:NO MON FOUND','ALIG:MON OPT ERR','ALIG:BAD ELM PAR',
     >'ALIG:MORE CORR',
     >'BASE:NO BEGIN KICK','BASE:NO END KICK','CAV:NOT A CAVITY',
     >'CHNGCOR:NOT A COR','CORDAT:NOT EVEN #','SETCOR:NO MATCH',
     >'CONDF:# ERROR','INTER:TERM ID ERR','INTER:NORMAL STOP',
     >'NOT A PARM NAME','USE A GKICK','ELID:NO MATCH',
     >'ELEM NOT IN MACH','ERR: RAND OPT ERR','ERR: BAD NUMBER',
     >'ERR:ELEM NO ERR','FIT:NO 2 FITPT','FIT:NO FITPT MATCH',
     >'FIT: WRONG ELEM PARM','FIT: UNSTABLE MOVMT'/
      DATA ERMES2/'FIT:WRONG ELEM',
     >'GENER:NO BEAM DEF','GENER:BAD OPT #','GENER: DIAGON FAIL',
     >'ELEM: NOT EVEN #','ELEM:BAD INDEX','INPUT:BAD OUPUT OPT',
     >'INPUT:MORE INP #','INPUT:BAD FORMAT','LESS INPUT #',
     >'MIS:BAD RAN OPT','MIS:BAD MIS OPT','MIS:REPORT ERROR',
     >'MIS:ELEM NOT MISAL',
     >'OPER:BAD OPER NAME','PARTAN:DIAGON FAIL','PLOT:NGRAPH ERR',
     >'RAND:BAD OPT #','RAND: BAD SIGMA #','RMAT:PART LOST',
     >'SHOCOR:BAD OPT #',
     >'DETAIL: PART LOST','DETAIL:NO BEAM DEF','TRACK:PART LOST',
     >'  ','MOVMT:PART LOST','MOVMT:BAD DETERM','LMDIF:INFORM',
     >'SIMEQ:SING SET OF EQ','PRINT:WRNG KWD','ERROR NOT IN TABLE'/
      DO 1 IS=1,80
      IF(KERR(IS).EQ.IHERR)GOTO 2
   1  CONTINUE
   2  CONTINUE
      if(itrap.eq.0) then
      WRITE(iout,10000)IHERR,ERRMES(IS)
      IF(ISO.NE.0)WRITE(ISOUT,10000)IHERR,ERRMES(IS)
10000 FORMAT (/,'  HALTING WITH ERROR NUMBER : ',I6,/,
     >'  AND ERROR : ',A20)
      endif
      if(itrap.eq.1)   then
          if(jherr.eq.0) then
            jherr=iherr
            WRITE(iout,10000)IHERR,ERRMES(IS)
            WRITE(ISOUT,10000)IHERR,ERRMES(IS)
          endif
          return
      endif
      close(unit=isout)
      STOP
      END
C     ***********************
      SUBROUTINE HBEND(IELM,MATADR)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/PRODCT/KODEPR,NEL,NOF
      COMMON/BND/IAD
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
C
C     GET ADDRESS OF THE PARAMETERS AND THE MATRIX
C
      IAD = IADR(IELM)
      AL=ELDAT(IAD)
      IF(ELDAT(IAD+1).EQ.0.0D0) GOTO 199
C
C     CLEAR AMAT(27,6,MATADR)
C
      DO 100 I=1,6
      DO 100 J=1,27
      AMAT(J,I,MATADR)=0.0D0
 100  CONTINUE
C
C     SET UP THE IDENTITY MATRIX IN TEMP
C
      DO 10 IX = 1,6
      DO 10 IY = 1,27
      TEMP(IX,IY)=0.0D0
      IF(IX.EQ.IY) TEMP(IX,IY) = 1.0D0
10    CONTINUE
      CALL BEND(IELM,MATADR)
C
C     PUT TEMP INTO AMAT(27,6,MATADR)
C
      DO 20 IX=1,6
      DO 20 IY=1,27
  20  AMAT(IY,IX,MATADR) = TEMP(IX,IY)
      RETURN
  199 DO 200 I=1,6
      DO 201 J=1,27
      AMAT(J,I,MATADR)=0.0D0
      IF(I.EQ.J) AMAT(J,I,MATADR)=1.0D0
  201 CONTINUE
  200 CONTINUE
      ALO2=0.5D0*AL
      AMAT(2,1,MATADR)=AL
      AMAT(4,3,MATADR)=AL
      AMAT(13,5,MATADR)=ALO2
      AMAT(22,5,MATADR)=ALO2
      RETURN
      END
C     ***********************
      SUBROUTINE HEXA2(IELM,MATADR)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/PRODCT/KODEPR,NEL,NOF
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      IAD = IADR(IELM)
      al=ELDAT(IAD)
      IF(KUNITS.EQ.2) AK=ELDAT(IAD+1)
      IF(KUNITS.EQ.1) AK = -ELDAT(IAD+1)/2.
      IF(KUNITS.EQ.0) AK = ELDAT(IAD+1)/2.
      call hexa2m(al,ak,matadr)
      RETURN
      END
C     ***********************
      SUBROUTINE HEXA2m(al,ak,MATADR)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      DO 100 I=1,6
      DO 100 J=1,27
      AMAT(J,I,MATADR)=0.0
  100 CONTINUE
      DO 101 I=1,6
      AMAT(I,I,MATADR)=1.0
  101 CONTINUE
      AMAT( 2,1,MATADR)=al
      AMAT( 4,3,MATADR)= al
      IF(NORDER.EQ.1)RETURN
      AKL1=AK*al
      AKL2=AKL1*al
      AKL3=AKL2*al
      AKL4=AKL3*al
      AMAT( 7,1,MATADR)=-AKL2/2.0
      AMAT( 8,1,MATADR)=-AKL3/3.0
      AMAT(13,1,MATADR)=-AKL4/12.0
      AMAT(18,1,MATADR)= AKL2/2.0
      AMAT(19,1,MATADR)= AKL3/3.0
      AMAT(22,1,MATADR)= AKL4/12.0
      AMAT( 7,2,MATADR)=-AKL1
      AMAT( 8,2,MATADR)=-AKL2
      AMAT(13,2,MATADR)=-AKL3/3.0
      AMAT(18,2,MATADR)= AKL1
      AMAT(19,2,MATADR)= AKL2
      AMAT(22,2,MATADR)= AKL3/3.0
      AMAT( 9,3,MATADR)= AKL2
      AMAT( 10,3,MATADR)= AKL3/3.0
      AMAT(14,3,MATADR)= AKL3/3.0
      AMAT(15,3,MATADR)= AKL4/6.0
      AMAT( 9,4,MATADR)= AKL1*2.0
      AMAT( 10,4,MATADR)= AKL2
      AMAT(14,4,MATADR)= AKL2
      AMAT(15,4,MATADR)= AKL3*2.0/3.0
C
C     PATH LENGTH
C
      AMAT(13,5,MATADR) = al/2.0D0
      AMAT(22,5,MATADR) = al/2.0D0
      RETURN
      END
C********************************************************************
      SUBROUTINE HPDRAW
C********************************************************************
C  SUBROUTINE TO GENERATE OUTPUT FILE FOR016.DAT TO DRIVE HP
C  CAD SYSTEM
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/LNGTH/TLENG,ALENG(MXELMD),ACLENG(MAXPOS)
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/HPDAT/
     &                 QFOCAL,XPRE,YPRE,ZPRE,THETAPRE,PHIPRE,PSIPRE,
     &                        XNOW,YNOW,ZNOW,THETANOW,PHINOW,PSINOW,
     &                        KADOUT,IHPXY,
     &                        IEHP
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      DIMENSION ENGNAM(7)
      CHARACTER*8 OUTNAM,ENGNAM
      DATA ENGNAM/'DIPOL036','DIPOL088','DIPOL120',
     &            'QPOLE12 ','QPOLE12A','QPOLE24 ',
     &            'SPOLE10 '
     &/
      NEL=NORLST(IEHP)
      KOD=KODE(NEL)
      IAT=IADR(NEL)
      ALEN=ELDAT(IAT)
C
C               BEGIN OUTPUT CODING
C
C  DRIFT
C
      IF(KOD.EQ.0) THEN
C
          IF(IHPXY.EQ.1)  THEN
             WRITE(16,90001) ZPRE,XPRE,ZNOW,XNOW
90001        FORMAT(' ADD L31      :P ',F12.4,',',F12.4,
     &                              ' ',F12.4,',',F12.4,' ;')
          ELSE
             IF(IHPXY.EQ.2) THEN
                WRITE(16,90002) ZPRE,YPRE,ZNOW,YNOW
90002           FORMAT(' ADD L31      :P ',F12.4,',',F12.4,
     &                                 ' ',F12.4,',',F12.4,' ;')
             END IF
          END IF
C
      ELSE
C
C  DIPOLE
C
          IF(KOD.EQ.1) THEN
             IF(ALEN.LT.1.5D0) THEN
                OUTNAM=ENGNAM(1)
             ELSE
                IF(ALEN.GT.2.5D0) THEN
                   OUTNAM=ENGNAM(3)
                ELSE
                   OUTNAM=ENGNAM(2)
                END IF
             END IF
             IF(IHPXY.EQ.1) THEN
                ANGLE=0.5D0*(THETANOW + THETAPRE)
                WRITE(16,90003) OUTNAM,ANGLE,ZPRE,XPRE
90003           FORMAT(' ADD ',A8,' :R ',F12.4,' ',
     &                         F12.4,',',F12.4,' ;')
             ELSE
                IF(IHPXY.EQ.2) THEN
                   ANGLE=0.5D0*(PHINOW + PHIPRE)
                   WRITE(16,90004) OUTNAM,ANGLE,ZPRE,YPRE
90004              FORMAT(' ADD ',A8,' :R ',F12.4,' ',
     &                            F12.4,',',F12.4,' ;')
                END IF
             END IF
          END IF
C
C  QUADRUPOLE
C
          IF(KOD.EQ.2) THEN
             IF(ALEN.GT.0.5D0) THEN
                 OUTNAM=ENGNAM(6)
             ELSE
                IF(QFOCAL.LT.2.1D0) THEN
                   OUTNAM=ENGNAM(4)
                ELSE
                   OUTNAM=ENGNAM(5)
                END IF
             END IF
             IF(IHPXY.EQ.1) THEN
                ANGLE=THETAPRE
                WRITE(16,90005) OUTNAM,ANGLE,ZPRE,XPRE
90005           FORMAT(' ADD ',A8,' :R ',F12.4,
     &                         F12.4,',',F12.4,' ;')
             ELSE
                IF(IHPXY.EQ.2) THEN
                   ANGLE=PHIPRE
                   WRITE(16,90006) OUTNAM,ANGLE,ZPRE,YPRE
90006              FORMAT(' ADD ',A8,' :R ',F12.4,
     &                            F12.4,',',F12.4,' ;')
                END IF
             END IF
          END IF
C
C  SEXTUPOLE
C
          IF(KOD.EQ.3) THEN
             OUTNAM=ENGNAM(7)
             IF(IHPXY.EQ.1) THEN
                ANGLE=THETAPRE
                WRITE(16,90007) OUTNAM,ANGLE,ZPRE,XPRE
90007           FORMAT(' ADD ',A8,' :R ',F12.4,
     &                         F12.4,',',F12.4,' ;')
             ELSE
                IF(IHPXY.EQ.2) THEN
                   ANGLE=PHIPRE
                   WRITE(16,90008) OUTNAM,ANGLE,ZPRE,YPRE
90008              FORMAT(' ADD ',A8,' :R ',F12.4,
     &                            F12.4,',',F12.4,' ;')
                END IF
             END IF
          END IF
      END IF
C
C  STORE THE CURRENT POINT DATA IN THE PREVIOUS POINT DATA AND
C  RETURN TO HWPNT, TO MOVE ON TO THE NEXT ELEMENT
C
      XPRE=XNOW
      YPRE=YNOW
      ZPRE=ZNOW
      THETAPRE=THETANOW
      PHIPRE=PHINOW
      PSIPRE=PSINOW
      RETURN
      END
      SUBROUTINE HPON
C**********************************************************************
C  TURN ON OR OFF OUTPUT FOR HP CAD SYSTEM
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      COMMON/HPDAT/
     &                 QFOCAL,XPRE,YPRE,ZPRE,THETAPRE,PHIPRE,PSIPRE,
     &                        XNOW,YNOW,ZNOW,THETANOW,PHINOW,PSINOW,
     &                        KADOUT,IHPXY,
     &                        IEHP
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      DIMENSION DATA(2)
      NDIM=2
      NPRINT=1
      NCHAR=0
      NDATA=2
      CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NPRINT)
      KADOUT=DATA(1)
C  VALUE 0 DISABLES OUTPUT TO FOR016.DAT FOR HP CAD SYSTEM
C  VALUE 1 ENABLES OUTPUT TO FOR016.DAT FOR HP CAD SYSTEM
      IHPXY=DATA(2)
C  VALUE 1 GENERATES DATA FOR PROJECTION INTO HORIZONTAL PLANE
C  VALUE 2 GENERATES DATA FOR PROJECTION INTO VERTICAL PLANE
      RETURN
      END
      SUBROUTINE HWPNT
C     *************************
      IMPLICIT REAL*8 (A-H,O-Z)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/LNGTH/TLENG,ALENG(MXELMD),ACLENG(MAXPOS)
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      COMMON/FUNC/BETAX,ALPHAX,ETAX,ETAPX,BETAY,ALPHAY,ETAY,ETAPY,
     <  STARTE,ENDE,DELTAE,DNU,MFPRNT,KOD,NLUM,NINT,NBUNCH
      COMMON/LAYOUT/SHI,XHI,YHI,ZHI,THETAI,PHIHI,PSIHI,CONVH,
     >SRH,XRH,YRH,ZRH,THETAR,PHIRH,PSIRH,NLAY,layflg
      COMMON/HPDAT/
     &                 QFOCAL,XPRE,YPRE,ZPRE,THETAPRE,PHIPRE,PSIPRE,
     &                        XNOW,YNOW,ZNOW,THETANOW,PHINOW,PSINOW,
     &                        KADOUT,IHPXY,
     &                        IEHP
      DIMENSION R(3),U(3,3),S(3),NUNITS(6,7)
      CHARACTER*1 NUNITS,ILL,ILR,ILP
      DATA NUNITS/'M','E','T','E','R','S','C','M',' ',' ',' ',' '
     >,'M','M',' ',' ',' ',' ','M','I','C','R','O','N'
     >,'Y','A','R','D','S',' ','F','E','E','T',' ',' '
     >,'I','N','C','H','E','S'/
      DATA ILL/'L'/,ILR/'R'/
      IF((NLAY.EQ.0).AND.(NOUT.GE.1).and.(layflg.ne.1))
     >  WRITE(IOUT,88880)STARTE
88880 FORMAT(//,'         VALUES ARE FOR ENERGY :',E12.3,' GEV',/)
      if(layflg.ne.0) then
C
C   SET COORDINATES AND ANGLE INITIALLY TO ZERO
C
      SH=SHI*CONVH
      XH=XHI*CONVH
      YH=YHI*CONVH
      ZH=ZHI*CONVH
      THETAH=THETAI*CRDEG
      PHIH=PHIHI*CRDEG
      PSIH=PSIHI*CRDEG
      XPRE=XHI
      YPRE=YHI
      ZPRE=ZHI
      THETAP=THETAI
      PHIPRE=PHIHI
      PSIPRE=PHIHI
      CT=DCOS(THETAH)
      ST=DSIN(THETAH)
      CF=DCOS(PHIH)
      SF=DSIN(PHIH)
      CPS=DCOS(PSIH)
      SPS=DSIN(PSIH)
      endif
      IF((NLAY.GE.1).or.(layflg.eq.1))GOTO 2000
C
C   SECTION FOR PRINTING OUT THE DATA ON THE MAGNETS
C
      BRHO = CMAGEN*STARTE
      DO 4 IJK=1,NA
      KODIJK = KODE(IJK)
      IF(KODIJK.EQ.1)GOTO1
      IF(KODIJK.EQ.2)GOTO 2
      IF(KODIJK.EQ.3)GOTO3
      IF(KODIJK.EQ.4) GOTO 40
      IF (KODIJK.EQ.15) GOTO 15
C
C KODE IS NOT IN 1-4 NOR EQUAL TO 15 , IGNORE ELEMENT
C
      GO TO 4
C
C   BEND COMPUTATION
C
    1 IPAR = IADR(IJK)
      IPARn = IADR(IJK+1)
      tiltan=eldat(iparn-1)
      if((kunits.eq.1).or.(kunits.eq.0))tiltan=tiltan/crdeg
      D2 = ELDAT(IPAR+6)
      IF(KUNITS.EQ.2) THEN
        ALPHA = ELDAT(IPAR+1)
        if(alpha.eq.0.0d0) then
          aindct=0.0d0
                           else
          RHO = ELDAT(IPAR) / (ELDAT(IPAR+1)*CRDEG)
          AINDCT = BRHO/RHO
        endif
        FIELDN = ELDAT(IPAR+2)
        FIELDB = ELDAT(IPAR+3)
        ALENTH = ELDAT(IPAR)
        ENTANG = ELDAT(IPAR+4)
        EXANG  = ELDAT(IPAR+8)
        ENTCUR = ELDAT(IPAR+5)
        EXCUR  = ELDAT(IPAR+9)
      ENDIF
      IF(KUNITS.EQ.1) THEN
        ALPHA = ELDAT(IPAR+1)/CRDEG
        if(alpha.eq.0.0d0) then
          aindct=0.0d0
          fieldn=0.0d0
          fieldb=0.0d0
                           else
          RHO = ELDAT(IPAR) / ELDAT(IPAR+1)
          AINDCT = BRHO/RHO
          FIELDN = ELDAT(IPAR+2)/RHO**2
          FIELDB = -ELDAT(IPAR+3)/RHO**3
        endif
        ALENTH = ELDAT(IPAR)
        ENTANG = ELDAT(IPAR+4)/CRDEG
        EXANG  = ELDAT(IPAR+8)/CRDEG
        ENTCUR = ELDAT(IPAR+5)
        EXCUR  = ELDAT(IPAR+9)
      ENDIF
      IF(KUNITS.EQ.0) THEN
        ALPHA = ELDAT(IPAR+1)/CRDEG
        if(alpha.eq.0.0d0) then
          aindct=0.0d0
          fieldn=0.0d0
          fieldb=0.0d0
                           else
          RHO = ELDAT(IPAR) / ELDAT(IPAR+1)
          AINDCT = BRHO/RHO
          FIELDN = -ELDAT(IPAR+2)/RHO**2
          FIELDB = ELDAT(IPAR+3)/RHO**3
        endif
        ALENTH = ELDAT(IPAR)
        ENTANG = ELDAT(IPAR+4)/CRDEG
        EXANG  = ELDAT(IPAR+8)/CRDEG
        ENTCUR = ELDAT(IPAR+5)
        EXCUR  = ELDAT(IPAR+9)
      ENDIF
      IF(NOUT.GE.3)
     >WRITE(IOUT,10)(NAME(I,IJK),I=1,8),D2,ALPHA,RHO,ALENTH,AINDCT,
     <FIELDN,FIELDB,ENTANG,ENTCUR,EXANG,EXCUR,tiltan
   10 FORMAT(/,' ELEMENT:',8A1,/,10X,
     > 'HALFGAP=',F13.8,'(M)','  BENDING ANGLE=',F13.8,'(DEG)',
     >'  BENDING ',
     > 'RADIUS=',F17.8,'(M.)',/,
     > 10X,'LENGTH=',E15.7,'(M)',' INDUCTION=',F13.8,'(KG)',/,
     > 10X,7X,'FIELD INDEX N=',F13.4,7X,'FIELD INDEX BETA=',F13.4,/,
     > 10X,'ENTRANCE ANGLE=',F12.8,'(DEG)',
     > 1X,'ENTRANCE CURVATURE=',F17.9,'(/M)',/,
     > 10X,'EXIT ANGLE =',F12.8,'(DEG)',
     > 4X,'EXIT CURVATURE=',F17.9,'(/M)',/,
     > 10x,'TILT ANGLE =',F17.9,'(DEG)')
      GO TO 4
C
C   QUADRUPOLE
C
    2 IPAR = IADR(IJK)
      IPARN= IADR(IJK+1)
      tiltan=eldat(iparn-1)
      if((kunits.eq.1).or.(kunits.eq.0))tiltan=tiltan/crdeg
      APTURE = ELDAT(IPARN-2)
      ALENTH = ELDAT(IPAR)
      STRGTH = ELDAT(IPAR+1)
      IF(KUNITS.EQ.1)STRGTH = -STRGTH
      AK = DSQRT(DABS(STRGTH))
      THETA = AK*ALENTH
      IF(AK.GT.0.0D0)FOCAL = 1.0D0/(AK*DSIN(THETA))
      IF(AK.EQ.0.0D0)FOCAL=0.0D0
      IF(AK.LT.0.0D0)FOCAL = -1.0D0/(AK*DSINH(THETA))
      IF (KADOUT.EQ.1) QFOCAL=FOCAL
      AINDCT = STRGTH*BRHO*APTURE
      AINT = STRGTH*ALENTH
      IF(NOUT.GE.3)
     >WRITE(IOUT,20)(NAME(I,IJK),I=1,8),APTURE,ALENTH,STRGTH,FOCAL,
     > AINDCT,AINT,tiltan
   20 FORMAT(/,' ELEMENT:',8A1,/,10X,
     > 'HALF APERTURE=',F13.8,'(M)','  LENGTH=',F13.8,'(M)',12X,
     > '  STRENGTH=',F13.8,'(/M**2)',/,10X,
     > 'FOCAL LENGTH=',E15.7,'(M)',' POLE TIP INDUCTION=',F13.8,
     > '(KG)','  INTEGRATED STRENGTH=',F13.8,'(/M)',/,
     > 10x,'TILT ANGLE =',f17.9,'(DEG)')
      GO TO 4
C
C   SEXTUPOLE
C
    3 IPAR = IADR(IJK)
      IPARN= IADR(IJK+1)
      tiltan=eldat(iparn-1)
      if((kunits.eq.1).or.(kunits.eq.0))tiltan=tiltan/crdeg
      APTURE = ELDAT(IPARN-2)
      ALENTH = ELDAT(IPAR)
      IF(KUNITS.EQ.2)STRGTH = ELDAT(IPAR+1)
      IF(KUNITS.EQ.1)STRGTH = -ELDAT(IPAR+1)/2.
      IF(KUNITS.EQ.0)STRGTH = ELDAT(IPAR+1)/2.
      AINDCT = STRGTH*BRHO*APTURE*APTURE
      AINT = STRGTH*ALENTH
      IF(NOUT.GE.3)
     >WRITE(IOUT,30)(NAME(I,IJK),I=1,8),APTURE,ALENTH,STRGTH,AINDCT,
     > AINT,tiltan
   30 FORMAT(/,' ELEMENT:',8A1,/,10X,
     > 'HALF APERTURE=',F13.8,'(M)',6X,'  LENGTH=',F13.8,'(M.)',
     > '  STRENGTH=',F13.8,'(/M**3)',/,10X,
     > 'POLE TIP INDUCTION=',F13.8,'(KG)','  INTEGRATED STRENGTH=',
     > F13.8,'(/M**2)',/,
     > 10x,'TILT ANGLE =',f17.9,'(DEG)')
      GOTO 4
C
C    QUADRUPOLE-SEXTUPOLE ELEMENT CODE D OR 4
C
   40 IPAR = IADR(IJK)
      IPARN= IADR(IJK+1)
      tiltan=eldat(iparn-1)
      if((kunits.eq.1).or.(kunits.eq.0))tiltan=tiltan/crdeg
      APTURE = ELDAT(IPARN-2)
      ALENTH=ELDAT(IPAR)
      QSTR=ELDAT(IPAR+1)
      IF(KUNITS.EQ.1) QSTR = -QSTR
      IF(KUNITS.EQ.2)SSTR=ELDAT(IPAR+2)
      IF(KUNITS.EQ.1)SSTR = -ELDAT(IPAR+2)/2.
      IF(KUNITS.EQ.0)SSTR = ELDAT(IPAR+2)/2.
      QIND=QSTR*BRHO*APTURE
      SIND=SSTR*BRHO*APTURE*APTURE
      QINT=QSTR*ALENTH
      SINT=SSTR*ALENTH
      IF(NOUT.GE.3)
     >WRITE(IOUT,41)(NAME(I,IJK),I=1,8),APTURE,ALENTH,
     > QSTR,QIND,QINT,SSTR,SIND,SINT,tiltan
   41 FORMAT(/,'  ELEMENT :',8A1,/,10X,'  HALF APERTURE =',F13.8,'(M)',
     >' LENGTH =',F13.8,'(M)',/,30X,'QUADRUPOLE COMPONENT',/,
     >10X,' STRENGTH =',F13.8,'(/M**2)',10X,'POLETIP INDUCTION =',
     >F13.8,'(KG)',/,10X,'INTEGRATED STRENGTH =',F13.8,'(/M)',/,
     >30X,'SEXTUPOLE COMPONENT',/,
     >10X,' STRENGTH =',F13.8,'(/M**3)',10X,'POLETIP INDUCTION =',
     >F13.8,'(KG)',/,10X,'INTEGRATED STRENGTH =',F13.8,'(/M**2)',/,
     > 10x,'TILT ANGLE =',f17.9,'(DEG)')
   15 CONTINUE
    4 CONTINUE
      starte=0.0d0
      if(layflg.eq.0) return
C
C   START THE LOOP TO GET THE HALFWAY POINT
C
 2000 continue
      R(1)=ZH
      R(2)=XH
      R(3)=YH
      U(1,1)=CT*CF
      U(1,2)=ST*CF
      U(1,3)=SF
      U(2,1)=-CT*SF*SPS - ST*CPS
      U(2,2)=-ST*SF*SPS + CT*CPS
      U(2,3)=SPS*CF
      U(3,1)=-CT*SF*CPS + ST*SPS
      U(3,2)=-ST*SF*CPS - CT*SPS
      U(3,3)=CF*CPS
      ILIST=1
      IU=0
      IF(DABS(CONVH-1.0D0).LT.1.0D-03)IU=1
      IF(DABS(CONVH-1.0D-02).LT.1.0D-05)IU=2
      IF(DABS(CONVH-1.0D-03).LT.1.0D-06)IU=3
      IF(DABS(CONVH-1.0D-06).LT.1.0D-09)IU=4
      IF(DABS(CONVH-0.9144D0).LT.1.0D-03)IU=5
      IF(DABS(CONVH-0.3048D0).LT.1.0D-03)IU=6
      IF(DABS(CONVH-2.54D-02).LT.1.0D-05)IU=7
      IF(IU.EQ.0) GOTO 20000
      IF((NLAY.EQ.0).AND.(NOUT.GE.1))
     > WRITE(IOUT,90003)(NUNITS(IIU,IU),IIU=1,6)
90003 FORMAT(///,
     >10x,' THE LENGTHS ARE MEASURED IN ',6A1,' ,THE ANGLES IN',
     >' DEGREES',/)
      GOTO 20001
20000 IF((NLAY.EQ.0).AND.(NOUT.GE.1))WRITE(IOUT,88887)
88887 FORMAT(10x,' ***SPECIAL UNITS ARE USED FOR THE LENGTHS!!!!****',/)
20001 IF((NLAY.EQ.0).AND.(NOUT.GE.1))WRITE(IOUT,88888)
88888 FORMAT(//, ' THE SXYZ COORDINATES,AZIMUTH,ELEVATION AND ROLL',
     >' ANGLES ARE :',//,'  #   NAME ',6X,'S',12X,'X',10X,'Y',12X,'Z',
     >8X,'THETA',9X,'PHI',8X,'PSI',9X,'ALPHA',/)
      DO 1000 IE=1,NELM
      IEHP=IE
      NEL=NORLST(IE)
      KOD=KODE(NEL)
      IAT=IADR(NEL)
      IATN=IADR(NEL+1)
      ALEN=ELDAT(IAT)
      IF(KOD.EQ.8)GOTO 800
      IF(KOD.EQ.1)GOTO 500
      DO 101 IR=1,3
  101 R(IR)=R(IR) + U(1,IR)*ALEN
      GOTO 1100
  500 CONTINUE
      IF(KUNITS.EQ.2) THEN
      ARG=ELDAT(IAT+1)*CRDEG
      TILTAN=ELDAT(IATN-1)*CRDEG
      ELSE
      ARG = ELDAT(IAT+1)
      TILTAN=ELDAT(IATN-1)
      ENDIF
      ITILT=2
      IF(TILTAN.EQ.0.0D0)ITILT=0
c      IF(DABS(TILTAN-(PI/2.0D0)).LT.1.0D-03)ITILT=1
      DC=DCOS(ARG)
      DS=DSIN(ARG)
      if(arg.ne.0.0d0) then
        rhoomc=alen*(1.0d0-dc)/arg
        rhods=alen*ds/arg
                        else
        rhoomc=0.0d0
        rhods=alen
      endif
c      OMC=1.0D0-DC
c      RHO=ALEN/ARG
      IF(ITILT.EQ.0)GOTO 200
c      IF(ITILT.EQ.1)GOTO 300
      IF(ITILT.EQ.2)GOTO 400
  200 DO 201 IR=1,3
      R(IR)=R(IR)-RHOOMC*U(2,IR)
     <+rhoDS*U(1,IR)
c      R(IR)=R(IR)-RHO*(OMC*U(2,IR)
c     <-DS*U(1,IR))
      U(3,IR)=U(3,IR)
      S(IR)=U(1,IR)*DC-U(2,IR)*DS
      U(2,IR)=U(2,IR)*DC+U(1,IR)*DS
  201 U(1,IR)=S(IR)
      GOTO 1100
c  300 DO 301 IR=1,3
c      R(IR)=R(IR)+RHO*(OMC*U(3,IR)
c     <+DS*U(1,IR))
c      U(2,IR)=U(2,IR)
c      S(IR)=U(1,IR)*DC+U(3,IR)*DS
c      U(3,IR)=U(3,IR)*DC-U(1,IR)*DS
c  301 U(1,IR)=S(IR)
c      GO TO 1100
  400 dct=dcos(tiltan)
      dst=dsin(tiltan)
      DO 401 IR=1,3
      V2=U(2,IR)*DCt+U(3,IR)*DSt
      V3=-U(2,IR)*DSt+U(3,IR)*DCt
      U(2,IR)=V2
      U(3,IR)=V3
      R(IR)=R(IR)
  401 CONTINUE
      DO 402 IR=1,3
      R(IR)=R(IR)-RHOOMC*U(2,IR)
     <+rhoDS*U(1,IR)
c      R(IR)=R(IR)-RHO*(OMC*U(2,IR)
c     <-DS*U(1,IR))
      U(3,IR)=U(3,IR)
      S(IR)=U(1,IR)*DC-U(2,IR)*DS
      U(2,IR)=U(2,IR)*DC+U(1,IR)*DS
  402 U(1,IR)=S(IR)
      DO 403 IR=1,3
      V2=U(2,IR)*DCt-U(3,IR)*DSt
      V3=U(2,IR)*DSt+U(3,IR)*DCt
      U(2,IR)=V2
      U(3,IR)=V3
      R(IR)=R(IR)
  403 CONTINUE
      GOTO 1100
  800 ALEN=ELDAT(IAT+8)+ELDAT(IAT)
      IF(KUNITS.EQ.2) THEN
      ARG=ELDAT(IAT+7)*CRDEG
      ELSE
      ARG = ELDAT(IAT+7)
      ENDIF
      DC=DCOS(ARG)
      DS=DSIN(ARG)
      DO 801 IR=1,3
      V2=U(2,IR)*DC+U(3,IR)*DS
      V3=-U(2,IR)*DS+U(3,IR)*DC
      U(2,IR)=V2
      U(3,IR)=V3
      R(IR)=R(IR)+U(1,IR)*ALEN
  801 CONTINUE
      GOTO 1100
 1100 IF (MFPRNT.LT.-1)GOTO 1000
      IF((MFPRNT.EQ.0).AND.(IE.NE.NELM))GOTO 1200
      CALL PRTTST(IE,ILIST,IPRT)
      IF((IPRT.NE.1).AND.(IE.NE.NELM))GOTO 1000
 1200 XRH=R(2)/CONVH
      YRH=R(3)/CONVH
      ZRH=R(1)/CONVH
C     WRITE(IOUT,90001)U(2,2),U(2,3),U(2,1)
C     WRITE(IOUT,90002)U(3,2),U(3,3),U(3,1)
C     WRITE(IOUT,90002)U(1,2),U(1,3),U(1,1)
90001 FORMAT(/,' THE COMPONENTS OF THE UNIT VECTORS ALONG THE LOCAL',
     >' COORDINATES IN THE REFERENCE COORDINATES ARE :',//,3F15.5,//)
90002 FORMAT(3F15.5)
      DENOM=DSQRT(U(1,2)**2+U(1,1)**2)
      THETAR=DATAN2(U(1,2),U(1,1))
      PHIRH=DATAN2(U(1,3),DENOM)
      PSIRH=DATAN2(U(2,3),U(3,3))
      THETAR=THETAR/CRDEG
      PHIRH=PHIRH/CRDEG
      PSIRH=PSIRH/CRDEG
      ALPHAR=PSIRH
      ILP=ILR
      IF((PSIRH.GT.90.0D0).AND.(PSIRH.LE.180.0D0))GOTO 601
      IF((PSIRH.GE.-180.0D0).AND.(PSIRH.LT.-90.0D0))GOTO 602
      GOTO 603
  601 ILP=ILL
      ALPHAR=-(180.0D0-PSIRH)
      GOTO 603
  602 ILP=ILL
      ALPHAR=(180.0D0+PSIRH)
  603 SRH=(ACLENG(IE)+SH)/CONVH
      IF((NLAY.EQ.0).AND.(NOUT.GE.1))
     > WRITE(IOUT,90004)IE,(NAME(IN,NORLST(IE)),IN=1,8)
     >,SRH,XRH,YRH,ZRH,THETAR,PHIRH,PSIRH,ALPHAR,ILP
90004 FORMAT(I5,1X,8A1,8F14.7,A4)
      XNOW=XRH
      YNOW=YRH
      ZNOW=ZRH
      THETAN=THETAR
      PHINOW=PHIRH
      PSINOW=PSIRH
      IF(KADOUT.EQ.1) CALL HPDRAW
 1000 CONTINUE
      RETURN
      END
      SUBROUTINE INPUT(ICHAR,NCHAR,ARRAY,NDIM,IEND,NE,NPRINT)
C     ***********************
C    THIS ROUTINE READS VALUES AND PUTS THEM INTO 'ARRAY' WHICH HAS
C      A DIMENSION OF NDIM
C    A COMMA SEPARATES ARRAYS; A SEMICOLON INDICATES THE END OF THE DATA
C   WHEN A SEMICOLON IS FOUND THE FLAG 'IEND' IS ASSIGNED THE VALUE OF 1
C   IF NE IS A POSITIVE VARIABLE OR CONSTANT, THEN NE ELEMENTS OF DATA
C         ARE READ INTO THE GIVEN ARRAY
C    IF NE IS NEGATIVE, IT MUST BE A VARIABLE AND WILL BE RETURNED WITH
C          THE NUMBER OF ELEMENTS THAT HAVE BEEN READ INTO THE ARRAY
      PARAMETER    (MXINP = 100)
      DIMENSION IDIGIT(10)
      REAL*8 ARRAY,TEMP
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      common/cinp/iop
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      COMMON/CUPLO/LOTOUP,UPTOLO(26)
      CHARACTER*26      LOTOUP
      CHARACTER*1       UPTOLO
      DIMENSION ARRAY(mxinp),ICHAR(20),IOTEST(4)
      INTEGER TABLE(8,8),P
      CHARACTER*1 CHTAB(7)
      INTEGER DIGIT
      CHARACTER*1 IDIGIT,CARD(72),ICHAR,IAA,IZ,IBLANK,ICOM,ISCOL,IBRKT,
     >ISTAR,IAT,IEXCL,IOTEST,IC1,ICARD(72)
      DATA TABLE/1,0,60,0,60,0,0,60,4,4,5,0,0,0,0,0,
     1  2,0,0,0,0,7,0,0,12,0,0,0,0,47,0,0,90,0,70,0,70,0,0,70,
     2  99,0,80,0,80,0,0,80,0,0,6,0,6,0,0,0,23,23,23,35,35,58,58,58/
      DATA CHTAB/' ','.','+','-',',',';','E'/
      DATA P/0/
      DATA IDIGIT/'0','1','2','3','4','5','6','7','8','9'/
      DATA IAA/'A'/,IZ/'Z'/,IBLANK/' '/,ICOM/','/,ISCOL/';'/
      DATA IBRKT/'('/,ISTAR/'*'/,IAT/'@'/,IEXCL/'!'/
      DATA IOTEST/'O','U','T','P'/
C  INITIALIZE:
      IA=0
      ICOUNT=0
      M=1
      NOCHAR=0
      IF(IOP.NE.0) GO TO 410
11    READ(IIN,99) CARD
C---- CHANGE UPPER CASE TO LOWER
      DO 919 IUL=1,72
        IND = INDEX(LOTOUP, CARD(IUL))
        IF(IND.NE.0) CARD(IUL) = UPTOLO(IND)
 919  CONTINUE
      KCOM=0
      IC1=CARD(1)
      IF((IC1.EQ.IBRKT).OR.(IC1.EQ.ISTAR).OR.(IC1.EQ.IAT)
     >.OR.(IC1.EQ.IEXCL))KCOM=1
      IF((KCOM.EQ.1).AND.(NPRINT.GE.0).AND.(NOUT.GE.2))
     >                              WRITE(IOUT,300)CARD
      IF(KCOM.EQ.1)GOTO 11
      IF((NPRINT.EQ.1).AND.(NOUT.GE.2))WRITE(IOUT,300)CARD
      IF((NPRINT.EQ.2).AND.(NOUT.GE.2))WRITE(IOUT,301)NELM,CARD
      ICT=0
      DO 1000 IOT=1,4
 1006 ICT=ICT+1
      IF(ICT.GT.72)GOTO 11
      IF(CARD(ICT).NE.IBLANK)GOTO 1005
      GOTO 1006
 1005 IF(CARD(ICT).NE.IOTEST(IOT))GOTO 1001
 1000 CONTINUE
 1009 READ(IIN,99)CARD
C---- CHANGE UPPER CASE TO LOWER
      DO 920 IUL=1,72
        IND = INDEX(LOTOUP, CARD(IUL))
        IF(IND.NE.0) CARD(IUL) = UPTOLO(IND)
 920  CONTINUE
      ICT=1
      DO 1002 IOT=1,10
 1008 IF(CARD(ICT).NE.IBLANK)GOTO 1007
      ICT=ICT+1
      IF(ICT.GT.72)GOTO 1009
      GOTO 1008
 1007 IF(CARD(ICT).EQ.IDIGIT(IOT))GOTO 1003
 1002 CONTINUE
      WRITE(IOUT,1004)
 1004 FORMAT('  ERROR IN OUTPUT CODE NUMBER ')
      CALL HALT(270)
      return
 1003 NOUT=IOT-1
      GOTO 11
  301 FORMAT(' ',I5,' ',72A1)
 1001 IOP=0
  410 IF((NCHAR.EQ.0).OR.(NOCHAR.EQ.1)) GO TO 18
400   IOP=IOP+1
      IF(IOP.GT.72) GO TO 11
C
C  ACCEPT INITIAL CHARACTER A-Z AND 0-9 BUT NOTHING ELSE
C
      IF(CARD(IOP).EQ.ICOM) GO TO 411
      IF(CARD(IOP).GE.IAA.AND.CARD(IOP).LE.IZ) GO TO 230
      IF(CARD(IOP).GE.IDIGIT(1).AND.CARD(IOP).LE.IDIGIT(10))GOTO230
      IF(CARD(IOP).LE.IAA.AND.CARD(IOP).GE.IZ) GO TO 230
      IF(CARD(IOP).LE.IDIGIT(1).AND.CARD(IOP).GE.IDIGIT(10))GOTO230
      GO TO 400
  411 IEND=2
      ICHAR(1)=IBLANK
      RETURN
230   IEPOS=IOP+NCHAR-1
      IF(IEPOS.GT.72)IEPOS=72
      DO 240 JJ=IOP,IEPOS
      L=JJ
      IF(CARD(L).EQ.IBLANK) GO TO 250
      IF((CARD(JJ).NE.ICOM).AND.(CARD(JJ).NE.ISCOL))GO TO 235
      IF(CARD(JJ).EQ.ISCOL)IEND=1
      IF(CARD(JJ).EQ.ICOM)IEND=2
      GO TO 250
235   ICHAR(M)=CARD(JJ)
      M=M+1
      ICOUNT=ICOUNT+1
240   CONTINUE
      IEPOS=IEPOS-1
      GO TO 270
250   II=JJ-IOP+1
  251 ICHAR(II)=IBLANK
      IEPOS=IEPOS-1
      ICOUNT=ICOUNT+1
      II=II+1
      IF(II.LE.NCHAR)GOTO251
  270 IOP=IEPOS+1
      NCHAR=ICOUNT
      IF(NDIM.NE.0.AND.NE.NE.0.AND.IOP.NE.72) GO TO 18
      RETURN
18    I=1
      IXSIGN=1
      NCHECK=0
      MSIGN=1
      IX=0
      NIX = 0
      IY = 0
      NIY = 0
      KOD = 0
       M=0
       IEXP=0
      GO TO 8
C  FIND CHARACTER IN TABLE:
2     IF(I.EQ.0)GOTO 5
8     IOP=IOP+1
      J=1
      NOCHAR=1
      IF(IOP.GT.72) GO TO 11
3     IF(CARD(IOP).NE.CHTAB(J)) GO TO 7
4     N=TABLE(I,J)/10
      IF(TABLE(I,J).EQ.99) GO TO 100
      I=TABLE(I,J)-N*10
      IF(N.LT.1.OR.N.GT.9) GO TO 2
      GO TO (10,20,30,40,50,60,70,80,90),N
      GO TO 2
7     J=J+1
      IF(J.LT.8) GO TO 3
      DO 700 IJK=1,10
      IF(CARD(IOP).EQ.IDIGIT(IJK)) GO TO 701
700   CONTINUE
      GO TO 5
701   DIGIT=IJK-1
      GO TO 4
C  BUILD NUMBER
10    IXSIGN=-1
      GO TO 2
30    KOD = 30
20    NIX = NIX + 1
      IF (NIX.GT.16) GO TO 2
      IF (KOD.EQ.0) GO TO 32
      IEXP = IEXP + 1
32    IF (NIX.GT.8) GO TO 22
      IX = 10*IX + DIGIT
      GO TO 2
22    IY = 10*IY + DIGIT
      NIY = NIY + 1
      GO TO 2
40    MSIGN=-1
      GO TO 2
50    M=10*M+DIGIT
      IF(M.GT.50)GO TO 5
      GO TO 2
60    NCHECK=NCHECK+1
70    NCHECK=NCHECK+1
80    NCHECK=NCHECK+1
      IA=IA+1
      IF (IA.GT.NDIM) GO TO 200
      ARRAY(IA)=IXSIGN*(IX*10.0D0**NIY+IY)/10.D0**IEXP*10.D0**(MSIGN*M)
      IF (IA.EQ.NE) GOTO 90
      IF(NCHECK.EQ.3) GO TO 18
      IF(NE.GT.0) GO TO 66
75    IF(NCHECK.EQ.2) GO TO 90
100   IEND=1
90    NE=IA
      IF(CARD(IOP).EQ.ISCOL)IEND=1
      IF(CARD(IOP).EQ.ICOM)IEND=2
      IF(IOP.EQ.72)GOTO 91
      IF(CARD(IOP+1).EQ.ISCOL)IEND=1
      IF(CARD(IOP+1).EQ.ICOM)IEND=2
   91 RETURN
66    WRITE(IOUT,96) NE
      IF(ISO.NE.0)WRITE(ISOUT,96) NE
96    FORMAT(10H   ERROR--,I3,24H ELEMENTS WERE NOT FOUND)
      CALL HALT(271)
      return
99    FORMAT(72A1)
5     WRITE(IOUT,98)
      IF(ISO.NE.0)WRITE(ISOUT,98)
98    FORMAT('   IMPROPER NUMBER FORMAT ')
      WRITE(IOUT,300)CARD
      IF(ISO.NE.0) WRITE(ISOUT,300)CARD
      DO 198 ICD=1,72
      IF(ICD.NE.IOP) THEN
         ICARD(ICD)=IBLANK
                   ELSE
         ICARD(ICD)=ISTAR
      ENDIF
 198  CONTINUE
      WRITE(IOUT,300)ICARD
      IF(ISO.NE.0)WRITE(ISOUT,300)ICARD
      CALL HALT(272)
      return
 200  WRITE(IOUT,201) IA,NDIM
      IF(ISO.NE.0)WRITE(ISOUT,201) IA,NDIM
 201  FORMAT(' ',I5,36H ELEMENTS READ IN: EXEEDS ARRAY SIZE,I5)
  300 FORMAT(' ',72A1)
      CALL HALT(273)
      return
      END

      function iequal(s1,s2)
C**********************************************
      character*1 s1(8),s2(8),fstar
      istar=0
      fstar=' '
      i=1
      j=1
    1 if(S1(i).eq.'*') then
       if(i.eq.8) goto 100
       if(S1(i+1).eq.' ')goto 100
       istar=1
       fstar=S1(i+1)
       i=i+1
    2  if(S1(i).eq.s2(j)) goto 3
       j=j+1
       if(j.gt.8) goto 200
       goto 2
                      else
       if(S1(i).ne.s2(j)) goto 250
    3  i=i+1
       j=j+1
       if(i.gt.8) then
        if(j.gt.8) goto 100
        if(s2(j).eq.' ') goto 100
        goto 200
                  else
        if(s1(i).eq.' ') then
         if(j.gt.8)goto 100
         if(s2(j).eq.' ') goto 100
         goto 250
        endif
        if(j.le.8)goto 1
        if(s1(i).ne.'*') goto 200
        if(i.eq.8) goto 100
        if(S1(i+1).eq.' ')goto 100
        goto 200
       endif
      endif
CC      stop
  100 iequal=1
      return
  200 iequal=0
      return
  250 if(istar.eq.0)goto 200
      j=j+1
      if(j.gt.8)goto 200
      if(s2(j).eq.fstar) then
      j=j+1
      goto 1
      endif
      goto 250
       end
C***************************************
      SUBROUTINE INTER(IEND)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      PARAMETER  (MAXDAT = 16000)
      PARAMETER  (MAXTW  = 10)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      COMMON/PLT/
     1XMIN,XMAX,YMIN,YMAX,XPMIN,XPMAX,YPMIN,YPMAX,ALMIN,ALMAX,
     >DELMIN,DELMAX,DNUMIN,DNUMAX,DBMIN,DBMAX,
     2MALL,NPLOT,NCCUM,NGRAPH,NCOL,NLINE
      COMMON/CHPLT/MXXPR,MYYPR,MXY,MALE
      COMMON/CTERM/IMACH,idt,IDIGIT(10),ESC
      common/cinter/inumel,niplot,intflg,iprpl,jherr,itrap,
     > numel(20),iscx(20),iscy(20),
     > iscsx(20),iscsy(20),avx(11,101),avy(11,101),axis(101)
      character*1 avx,avy,axis
      CHARACTER*1 NAME,LABEL
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR,NTITLE(28),MXXPR(101,51),MYYPR(101,51),
     >MXY(101,51),MALE(101,51)
      PARAMETER  (mxlcnd = 200)
      PARAMETER  (mxlvar = 100)
      COMMON/MONIT/VALMON(MXLCND,4,3)
      COMMON/MONFIT/VALFA(MXLCND),WGHTA(MXLCND),ERRA(MXLCND),
     >AMULTA(MXLVAR,6),ADDA(MXLVAR,6),DELA(MXLVAR)
     >,NPARA(MXLVAR,6),NELFA(MXLVAR,6),
     >NPVARA(MXLVAR),INDA(MXLVAR,6),VALR(MXLCND),RMOSIG,
     >NMONA(MXLCND),NVALA(MXLCND),NVARA,NCONDA
     >,IALFLG,MONFLG,MONLST,NOPTER,
     >IAFRST,IMOOPT,IMSBEG,NALPRT
      COMMON/CANAL/ave(6),rms(6),SCALE,IANOPT,IANPRT
      COMMON/CGENER/RSIG(6),GXC,GXPC,GYC,GYPC,GLC,GPC,cpa(6,6),NGOPT
      COMMON/CUPLO/LOTOUP,UPTOLO(26)
      CHARACTER*26      LOTOUP
      CHARACTER*1       UPTOLO
      DIMENSION NIEL(MAXTW),NIPAR(MAXTW),FIELP(MAXTW),FIELM(MAXTW)
      DIMENSION BVAL(MAXTW)
      CHARACTER*1 RCHAR,IDIGIT,CHAR8(20),DIGIT(10),CHE(80),UPLET(10)
      CHARACTER*1 ESC,CCUR(8),CSCR(4),LIN(80),LOLET(10),LOLETL(10)
      INTEGER*2 ICUR(4),ISCR(2)
      EQUIVALENCE(CCUR(1),ICUR(1)),(CSCR(1),ISCR(1))
      CHARACTER*80 CH80
      EQUIVALENCE (CH80,CHE(1))
      DATA ICUR/27,61,32,32/,ISCR/27,42/
      DATA DIGIT/'0','1','2','3','4','5','6','7','8','9'/
      DATA UPLET/'1','2','3','4','5','6','7','8','9','0'/
      DATA LOLET/'Q','W','E','R','T','Y','U','I','O','P'/
      DATA LOLETL/'Q','W','E','R','T','Y','U','I','O','P'/
      DATA LIN/79*' ',' '/
      DO 111 IDG=1,10
      IDIGIT(IDG)=DIGIT(IDG)
  111 CONTINUE
      ITW=0
      ihelp=0
      NOP=2
      NCHAR=0
      NIPR=1
      CALL INPUT(ICHAR,NCHAR,DATA,MXINP,IEND,NOP,NIPR)
      NIOPT=DATA(1)
      NIVAR=DATA(2)
      nop=0
      nchar=8
      CALL INPUT(ICHAR,NCHAR,DATA,MXINP,IEND,NOP,NIPR)
      call elpos(ichar,nelpos)
      iafrst=nelpos
      CALL INPUT(ICHAR,NCHAR,DATA,MXINP,IEND,NOP,NIPR)
      call elpos(ichar,nelpos)
      monlst=nelpos
      intflg=1
      ngopt=1
      isend=iend
      iend=-1
      call gener(iend)
      nprint=-2
      nturn=1
      ncturn=0
      nplot=-1
      call trackt
      iend=-1
      ianopt=0
      call partan(iend)
      ngopt=11
      iend=-11
      intflg=2
      call gener(iend)
      IIVT=1
      ITOPT=1
      TWVAL=1.0D-05
      NCHAR=8
      NOP=0
      DO 1 II=1,NIVAR
      CALL INPUT(ICHAR,NCHAR,DATA,MXINP,IEND,NOP,NIPR)
      CALL ELID(ICHAR,NELID)
      NIEL(II)=NELID
      CALL INPUT(ICHAR,NCHAR,DATA,MXINP,IEND,NOP,NIPR)
      CALL DIMPAR(NELID, ICHAR, IDICT)
      NIPAR(II)=IDICT
      NTPAR=NIPAR(II)
      NTEL=NIEL(II)
      BVAL(II)=ELDAT(IADR(NTEL)+NTPAR-1)
      FIELP(II)=TWVAL
      FIELM(II)=-TWVAL
    1 CONTINUE
      ISEND=IEND
    4 WRITE(ISOUT,99972)
99972 FORMAT(' TYPE IN MACHINE # ; 1:IBM;2:VAX ')
      READ(ISOUT,*,ERR=4)IMACH
      ESC=CHAR(39)
      IF(IMACH.EQ.2)ESC=CHAR(27)
    3 WRITE(ISOUT,99971)
99971 FORMAT('  TYPE IN TERMINAL # ; 1:QVT102;2:VT100,AMBASS24 ',
     >';3:AMBASS43')
      READ(ISOUT,*,ERR=3)IDT
      ILS=17
      NCOL=35
      NLINE=13
      IF(IDT.EQ.3) THEN
         IDT=2
         ILS=39
         NLINE=30
      ENDIF
      NPLOT=-1
      NIPLOT=1
      XMIN=-10D-03
      XMAX=10D-03
      YMIN=-10D-03
      YMAX=10D-03
      IANOPT=1
      IANPRT=1
      CALL SCRCLR
  100 CONTINUE
C     ICUR(3)=50
C     ICUR(4)=32
C     WRITE(ISOUT,99998)(CCUR(I),I=1,7,2)
      CALL CURMV(ILS,1,IDT)
      WRITE(ISOUT,99981)LIN
      CALL CURMV(ILS,1,IDT)
99981 FORMAT(80A1)
C99998 FORMAT(' ',4A1)
      WRITE(ISOUT,99999)
99999 FORMAT(' TYPE ACTION WANTED :K,B,F,D,G,X,P,C,T,S,Q,H(elp): ')
  102 ilt=ils+1
      CALL CURMV(ILt,52,IDT)
      READ(ISOUT,10001,ERR=102)RCHAR
        INDX = INDEX(LOTOUP, RCHAR)
        IF(INDX.NE.0) RCHAR = UPTOLO(INDX)
10001 FORMAT(A1)
      if(ihelp.eq.1) then
         call scrclr
         ihelp=0
      endif
      IF((RCHAR.EQ.'B')) GOTO 10000
      IF((RCHAR.EQ.'F')) GOTO 1000
      IF((RCHAR.EQ.'D')) GOTO 2000
      IF((RCHAR.EQ.'G')) GOTO 3000
      IF((RCHAR.EQ.'X')) GOTO 4000
      IF((RCHAR.EQ.'K')) GOTO 8100
      IF((RCHAR.EQ.'P')) GOTO 6000
      IF((RCHAR.EQ.'C')) GOTO 7000
      IF((RCHAR.EQ.'T')) GOTO 1006
      IF((RCHAR.EQ.'S')) GOTO 9000
      IF((RCHAR.EQ.'Q')) CALL HALT(236)
      IF((RCHAR.EQ.'H')) GOTO 20000
      CALL CURMV(ILS+3,1,IDT)
      WRITE(ISOUT,99981)LIN
      CALL CURMV(ILS+3,1,IDT)
      WRITE(ISOUT,10002)RCHAR
10002 FORMAT(' WRONG CHARACTER : ',A1,' REENTER ')
      GOTO 100
20000 CONTINUE
      ihelp=1
      call scrclr
      call curmv(1,1,idt)
      write(isout,20001)
20001 format(
     > '  B : reset initial values ',/
     >,'  F : set additive or multiplicative tweaks ',/
     >,'  D : not used ',/
     >,'  G : compute ',/
     >,'  X : exit and return to Dimad non interactive mode ',/
     >,'  K : make knobs available ',/
     >,'  P : select display type ',/
     >,'  C : clear upper part of screen ',/
     >,'  T : change tweak values ',/
     >,'  S : print to regular output files the values of knobs ',/
     >,'  Q : terminate complete job ',/
     >,'  H : call this display ',/
     > )
      GOTO 100
 1000 CONTINUE
      REWIND(10)
      DO 1112 IC=1,80
 1112 CHE(IC)=' '
 1002 CALL CURMV(ILS+1,1,IDT)
      WRITE(ISOUT,99981)LIN
      CALL CURMV(ILS+1,1,IDT)
      WRITE(ISOUT,10003)
10003 FORMAT(' ADDITIVE (1) OR MULTIPLICATIVE (2) TWEAK : ')
      ilt=ils+1
      CALL CURMV(ILt+1,50,IDT)
      IF(IMACH.EQ.1) THEN
             READ(10,ERR=1002,END=1002)CH80
             READ(UNIT=CH80,FMT=*,ERR=1002,END=1002)ITOPT
      ENDIF
      IF(IMACH.EQ.2)READ(ISOUT,*,ERR=1002)ITOPT
 1003 CONTINUE
      REWIND(10)
      DO 1210 IC=1,80
 1210 CHE(IC)=' '
      CALL CURMV(ILS+1,1,IDT)
      WRITE(ISOUT,99981)LIN
      CALL CURMV(ILS+1,1,IDT)
      WRITE(ISOUT,10004)
10004 FORMAT(' ENTER TWEAKING INCREMENT OR FACTOR : ')
      ilt=ils+1
      CALL CURMV(ILt+1,45,IDT)
      IF(IMACH.EQ.1) THEN
             READ(10,ERR=1003,END=1003)CH80
             READ(UNIT=CH80,FMT=*,ERR=1003,END=1003)TWVALP
      ENDIF
      IF(IMACH.EQ.2)READ(ISOUT,*,ERR=1003)TWVALP
      IF(ITOPT.EQ.1) THEN
           DO 1004 ITV=1,MAXTW
           FIELP(ITV)=TWVALP
 1004      FIELM(ITV)=-TWVALP
      ENDIF
      IF(ITOPT.EQ.2) THEN
           DO 1005 ITV=1,MAXTW
           FIELP(ITV)=TWVALP
 1005      FIELM(ITV)=1.0D0/TWVALP
      ENDIF
      ITW=1
      GOTO 100
 1006 REWIND(10)
      DO 1110 IC=1,80
 1110 CHE(IC)=' '
      ITW=1
 1001 CALL CURMV(ILS+1,1,IDT)
      WRITE(ISOUT,99981)LIN
      CALL CURMV(ILS+1,1,IDT)
      WRITE(ISOUT,11001)
11001 FORMAT(' KNOB # AND TWEAK VALUE : X TO EXIT ')
      ilt=ils+1
      CALL CURMV(ILt+1,38,IDT)
      IF(IMACH.EQ.1) THEN
             READ(10,ERR=1006,END=1006)CH80
      ENDIF
      IF(IMACH.EQ.2)READ(10,FMT=11002,ERR=1006,END=1006)CH80
11002 FORMAT(A80)
        INDX = INDEX(LOTOUP, CHE(1))
        IF(INDX.NE.0) CHE(1) = UPTOLO(INDX)
      IF((CHE(1).EQ.'X')) GOTO 100
      READ(UNIT=CH80,FMT=*,ERR=1006,END=1006)IFA,FVAL
      FIELP(IFA)=FVAL
      IF(ITOPT.EQ.1)  FIELM(IFA)=-FIELP(IFA)
      IF(ITOPT.EQ.2)  FIELM(IFA)=1.0D0/FIELP(IFA)
      GOTO 1001
 2000 CONTINUE
      GOTO 100
 3000 CONTINUE
      IEND=-1
      CALL CURMV(1,1,IDT)
      CALL GENER(IEND)
      NPRINT=-2
      NTURN=1
      NCTURN=0
      CALL TRACKT
 3010 IF(NIPLOT.EQ.1)THEN
         CALL PLOT(PART(1,1),PART(1,3),NPART,XMAX,XMIN,
     >YMAX,YMIN,-1,0,39,NCOL,NLINE,NTITLE,MXY,LOGPAR)
                     ELSE
         CALL PARTAN(IEND)
      ENDIF
      IF(ITW.EQ.1)GOTO 8400
      GOTO 100
 6000 CONTINUE
      CALL CURMV(ILS+1,1,IDT)
      WRITE(ISOUT,99981)LIN
      CALL CURMV(ILS+1,1,IDT)
      WRITE(ISOUT,10005)
10005 FORMAT(' DO YOU WANT PLOT OR PRINT : P , R ? : ')
 6001 ilt=ils+1
      CALL CURMV(ILt+1,45,IDT)
      READ(ISOUT,10001,ERR=6001)RCHAR
        INDX = INDEX(LOTOUP, RCHAR)
        IF(INDX.NE.0) RCHAR = UPTOLO(INDX)
      IF((RCHAR.EQ.'P')) GOTO 6100
      IF((RCHAR.EQ.'R')) GOTO 6200
 6100 REWIND(10)
      DO 6110 IC=1,80
 6110 CHE(IC)=' '
      CALL CURMV(ILS+1,1,IDT)
      WRITE(ISOUT,99981)LIN
      CALL CURMV(ILS+1,1,IDT)
      WRITE(ISOUT,10006)
10006 FORMAT(' TYPE IN XMIN,XMAX,YMIN,YMAX : ')
      ilt=ils+1
      CALL CURMV(ILt+1,35,IDT)
      IF(IMACH.EQ.1) THEN
             READ(10,ERR=6100,END=6100)CH80
             READ(UNIT=CH80,FMT=*,ERR=6100,END=6100)XMIN,XMAX,YMIN,YMAX
      ENDIF
      IF(IMACH.EQ.2)READ(ISOUT,*,ERR=6100)XMIN,XMAX,YMIN,YMAX
      NIPLOT=1
      GOTO 100
 6200 NIPLOT=-1
      GOTO 100
 7000 CONTINUE
      CALL CURMV(1,1,IDT)
      DO 7001 IL=1,18
 7001 WRITE(ISOUT,99981)LIN
      GOTO 100
 8000 CONTINUE
      REWIND(10)
      DO 8010 IC=1,80
 8010 CHE(IC)=' '
      CALL CURMV(ILS+1,1,IDT)
      WRITE(ISOUT,99981)LIN
      CALL CURMV(ILS+1,1,IDT)
      WRITE(ISOUT,80001)
80001 FORMAT(' SET TWEAK  KNOB#1,2,..,Q,W,..,D,M,X,H(elp) : ')
 8002 ilt=ils+1
      CALL CURMV(ILt+1,55,IDT)
      DO 8001 ICH=1,20
 8001 CHAR8(ICH)=' '
      IF(IMACH.EQ.1) THEN
             READ(10,ERR=8000,END=8000)CH80
             READ(UNIT=CH80,FMT=80002,ERR=8000,END=8000)CHAR8
      ENDIF
      IF(IMACH.EQ.2)READ(ISOUT,80002,ERR=8000)CHAR8
80002 FORMAT(20A1)
        INDX = INDEX(LOTOUP, CHAR8(1))
        IF(INDX.NE.0) CHAR8(1) = UPTOLO(INDX)
      if(ihelp.eq.1) then
         call scrclr
         ihelp=0
      endif
      IF((CHAR8(1).EQ.'D'))GOTO 8920
      IF((CHAR8(1).EQ.'M'))GOTO 8910
      IF((CHAR8(1).EQ.'X'))GOTO 8100
      IF((CHAR8(1).EQ.'H'))GOTO 8930
      DO 812 II=1,10
      IF(CHAR8(1).EQ.LOLET(II)) GOTO 8310
  812 CONTINUE
      DO 8121 II=1,10
      IF(CHAR8(1).EQ.LOLETL(II)) GOTO 8310
 8121 CONTINUE
      DO 813 II=1,10
      IF(CHAR8(1).EQ.UPLET(II)) GOTO 8210
  813 CONTINUE
      CALL CURMV(ILS+3,1,IDT)
      WRITE(ISOUT,99981)LIN
      CALL CURMV(ILS+3,1,IDT)
      WRITE(ISOUT,10002)CHAR8(1)
      GOTO 8000
 8210 IIVT=II
      IF((IIVT.LE.0).OR.(IIVT.GT.NIVAR)) THEN
           CALL CURMV(ILS+3,1,IDT)
           WRITE(ISOUT,99981)LIN
           CALL CURMV(ILS+3,1,IDT)
           WRITE(ISOUT,10002)CHAR8(1)
           GOTO 8000
      ENDIF
      DO 8211 ICH=1,20
      IF(CHAR8(ICH).EQ.' ')GOTO 8212
 8211 CONTINUE
 8212 ITIMES=ICH-1
      IF(ITOPT.EQ.1) THEN
             FIELP(IIVT)=FIELP(IIVT)*(10.0D0**ITIMES)
             FIELM(IIVT)=-FIELP(IIVT)
      ENDIF
      IF(ITOPT.EQ.2) THEN
             FIELP(IIVT)=FIELP(IIVT)**(10.0D0**ITIMES)
             FIELM(IIVT)=1.0D0/FIELP(IIVT)
      ENDIF
      GOTO 8314
 8310 IIVT=II
      IF((IIVT.LE.0).OR.(IIVT.GT.NIVAR)) THEN
           CALL CURMV(ILS+3,1,IDT)
           WRITE(ISOUT,99981)LIN
           CALL CURMV(ILS+3,1,IDT)
           WRITE(ISOUT,10002)CHAR8(1)
           GOTO 8000
      ENDIF
      DO 8311 ICH=1,20
      IF(CHAR8(ICH).EQ.' ')GOTO 8312
 8311 CONTINUE
 8312 ITIMES=ICH-1
      IF(ITOPT.EQ.1) THEN
             FIELP(IIVT)=FIELP(IIVT)/(10.0D0**ITIMES)
             FIELM(IIVT)=-FIELP(IIVT)
      ENDIF
      IF(ITOPT.EQ.2) THEN
             FIELP(IIVT)=FIELP(IIVT)**(10.0D0**(-ITIMES))
             FIELM(IIVT)=1.0D0/FIELP(IIVT)
      ENDIF
      GOTO 8314
 8314 CONTINUE
      NTPAR=NIPAR(IIVT)
      NTEL=NIEL(IIVT)
      CALL CURMV(ILS+2,1,IDT)
      WRITE(ISOUT,99981)LIN
      CALL CURMV(ILS+2,1,IDT)
      WRITE(ISOUT,80016)IIVT,NTPAR,
     >(NAME(JIN,NTEL),JIN=1,8),FIELP(IIVT),ELDAT(IADR(NTEL)+NTPAR-1)
80016 FORMAT(' KNOB',I2,' PARAMETER',I2,
     >' OF ',8A1,' TWEAK =',E12.5,' VALUE =',E12.5)
      GOTO 8000
 8910 CONTINUE
      GOTO 8000
 8920 CONTINUE
      GOTO 8000
 8930 CONTINUE
      ihelp=1
      call scrclr
      call curmv(1,1,idt)
      write(isout,18930)
18930 format(
     > ' 1 to 8 : increase knob tweak value ',/
     >,' q to i : decrease knob tweak value ',/
     >,' D : not used ',/
     >,' M : not used ',/
     >,' X : exit this level ',/
     >,' H ; type this display ',/
     >)
      GOTO 8000
 8100 ITW=1
      CALL CURMV(ILS+2,1,IDT)
      WRITE(ISOUT,99981)LIN
      CALL CURMV(ILS+2,1,IDT)
      NTPAR=NIPAR(IIVT)
      NTEL=NIEL(IIVT)
      WRITE(ISOUT,80003)IIVT,NIPAR(IIVT),
     >(NAME(JIN,NIEL(IIVT)),JIN=1,8)
     >,FIELP(IIVT),ELDAT(IADR(NTEL)+NTPAR-1)
80003 FORMAT(' KNOB',I2,' PARAMETER',I2,' OF ',8A1,
     >' TWEAK =',E12.5,' VALUE =',E12.5)
 8400 REWIND(10)
      DO 8410 IC=1,80
 8410 CHE(IC)=' '
      CALL CURMV(ILS+1,1,IDT)
      WRITE(ISOUT,99981)LIN
      CALL CURMV(ILS+1,1,IDT)
      WRITE(ISOUT,80004)
80004 FORMAT(' TYPE IN OPTION KNOB(1,2,..,Q,W,..,B,D,M,X,S,H(elp): ')
 8402 ilt=ils+1
      CALL CURMV(ILt+1,55,IDT)
      DO 8401 ICH=1,20
 8401 CHAR8(ICH)=' '
      IF(IMACH.EQ.1) THEN
             READ(10,ERR=8400,END=8400)CH80
             READ(UNIT=CH80,FMT=80002,ERR=8400,END=8400)CHAR8
      ENDIF
      IF(IMACH.EQ.2)READ(ISOUT,80002,ERR=8400)CHAR8
80005 FORMAT(20A1)
        INDX = INDEX(LOTOUP, CHAR8(1))
        IF(INDX.NE.0) CHAR8(1) = UPTOLO(INDX)
      if(ihelp.eq.1) then
         call scrclr
         ihelp=0
      endif
      IF((CHAR8(1).EQ.'B'))GOTO 8700
      IF((CHAR8(1).EQ.'D'))GOTO 8800
      IF((CHAR8(1).EQ.'M'))GOTO 8900
      IF((CHAR8(1).EQ.'X'))GOTO 8500
      IF((CHAR8(1).EQ.'S'))GOTO 8000
      IF((CHAR8(1).EQ.'H'))GOTO 8940
      DO 82 II=1,10
      IF(CHAR8(1).EQ.LOLET(II)) GOTO 8300
   82 CONTINUE
      DO 84 II=1,10
      IF(CHAR8(1).EQ.LOLETL(II)) GOTO 8300
   84 CONTINUE
      DO 83 II=1,10
      IF(CHAR8(1).EQ.UPLET(II)) GOTO 8200
   83 CONTINUE
      CALL CURMV(ILS+3,1,IDT)
      WRITE(ISOUT,99981)LIN
      CALL CURMV(ILS+3,1,IDT)
      WRITE(ISOUT,10002)CHAR8(1)
      GOTO 8400
 8200 IIVT=II
      IF((IIVT.LE.0).OR.(IIVT.GT.NIVAR)) THEN
           CALL CURMV(ILS+3,1,IDT)
           WRITE(ISOUT,99981)LIN
           CALL CURMV(ILS+3,1,IDT)
           WRITE(ISOUT,10002)RCHAR
           GOTO 8400
      ENDIF
      DO 8201 ICH=1,20
      IF(CHAR8(ICH).EQ.' ')GOTO 8202
 8201 CONTINUE
 8202 ITIMES=ICH-1
      IF(ITOPT.EQ.1)TWVALP=FIELP(IIVT)*ITIMES
      IF(ITOPT.EQ.2)TWVALP=FIELP(IIVT)**ITIMES
      CALL VARY(NIEL(IIVT),NIPAR(IIVT),TWVALP,ITOPT)
      GOTO 8304
 8300 IIVT=II
      IF((IIVT.LE.0).OR.(IIVT.GT.NIVAR)) THEN
           CALL CURMV(ILS+3,1,IDT)
           WRITE(ISOUT,99981)LIN
           CALL CURMV(ILS+3,1,IDT)
           WRITE(ISOUT,10002)RCHAR
           GOTO 8400
      ENDIF
      DO 8301 ICH=1,20
      IF(CHAR8(ICH).EQ.' ')GOTO 8302
 8301 CONTINUE
 8302 ITIMES=ICH-1
      IF(ITOPT.EQ.1)TWVALM=FIELM(IIVT)*ITIMES
      IF(ITOPT.EQ.2)TWVALM=FIELM(IIVT)**ITIMES
      CALL VARY(NIEL(IIVT),NIPAR(IIVT),TWVALM,ITOPT)
      GOTO 8304
 8304 CONTINUE
      NTPAR=NIPAR(IIVT)
      NTEL=NIEL(IIVT)
      CALL CURMV(ILS+2,1,IDT)
      WRITE(ISOUT,99981)LIN
      CALL CURMV(ILS+2,1,IDT)
      WRITE(ISOUT,80006)IIVT,NTPAR,
     >(NAME(JIN,NTEL),JIN=1,8),FIELP(IIVT),ELDAT(IADR(NTEL)+NTPAR-1)
80006 FORMAT(' KNOB',I2,' PARAMETER',I2,
     >' OF ',8A1,' TWEAK =',E12.5,' VALUE =',E12.5)
      ITW=1
      GOTO 3000
 8500 ITW=0
      GOTO 100
 8700 CONTINUE
      NTPAR=NIPAR(IIVT)
      NTEL=NIEL(IIVT)
      ELDAT(IADR(NTEL)+NTPAR-1)=BVAL(IIVT)
      GOTO 8100
 8800 CONTINUE
      DO 8801 ICH=1,20
      IF(CHAR8(ICH).EQ.' ')GOTO 8802
 8801 CONTINUE
 8802 FACTP=DSQRT(10.0D0)**(ICH-1)
 8810 XMIN=XMIN*FACTP
      XMAX=XMAX*FACTP
      YMIN=YMIN*FACTP
      YMAX=YMAX*FACTP
      ITW=1
      CALL CURMV(1,1,IDT)
      GOTO 3010
 8900 CONTINUE
      DO 8901 ICH=1,20
      IF(CHAR8(ICH).EQ.' ')GOTO 8902
 8901 CONTINUE
 8902 FACTP=1.0D0/DSQRT(10.0D0)**(ICH-1)
      GOTO 8810
 8940 CONTINUE
      ihelp=1
      call scrclr
      call curmv(1,1,idt)
      write(isout,18940)
18940 format(
     > ' 1 to 8 : increase knob value ',/
     >,' q to i : decrease knob value ',/
     >,' B : reset initial values ',/
     >,' D : increase plotting window ',/
     >,' M : decrease plotting window ',/
     >,' S : change tweak value of knobs ',/
     >,' X : exit this level ',/
     >,' H ; type this display ',/
     >)
      GOTO 8400
 9000 CONTINUE
      DO 9001 IIVT=1,NIVAR
      NTPAR=NIPAR(IIVT)
      NTEL=NIEL(IIVT)
 9001 WRITE(IOUT,80006)IIVT,NTPAR,
     >(NAME(JIN,NTEL),JIN=1,8),FIELP(IIVT),ELDAT(IADR(NTEL)+NTPAR-1)
      GOTO 100
10000 DO 10100 IIVT=1,NIVAR
      NTPAR=NIPAR(IIVT)
      NTEL=NIEL(IIVT)
      ELDAT(IADR(NTEL)+NTPAR-1)=BVAL(IIVT)
10100 CONTINUE
      GOTO 100
 4000 CONTINUE
      IEND=ISEND
      intflg=0
      RETURN
      END
      LOGICAL FUNCTION INTRAC()
C---- TRUE, IF PROGRAM RUNS INTERACTIVELY
C-----------------------------------------------------------------------
      INTRAC = .FALSE.
      RETURN
C-----------------------------------------------------------------------
      END
      SUBROUTINE JOBNAM(NAME)
C---- RETURN JOB NAME
C-----------------------------------------------------------------------
      CHARACTER*8       NAME
C-----------------------------------------------------------------------
      NAME = 'JOBNAME '
      RETURN
C-----------------------------------------------------------------------
      END
      SUBROUTINE KICK(IELM,MATADR)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/PRODCT/KODEPR,NEL,NOF
      IAD=IADR(IELM)
      DO 520 I=1,6
      IF(ELDAT(IAD+I).NE.0.0D0) GO TO 524
520   CONTINUE
521   CONTINUE
      IF(KUNITS.EQ.2) ARG=ELDAT(IAD+7)* CRDEG
      IF(KUNITS.EQ.1) ARG = -ELDAT(IAD+7)
      IF(KUNITS.EQ.0) ARG = ELDAT(IAD+7)
      AL=ELDAT(IAD+8)+ELDAT(IAD)
      SINK=DSIN(ARG)
      COSK=DCOS(ARG)
      DO 522 I=1,6
      DO 523 J=1,NOF
 523  AMAT(J,I,MATADR)=0.0D0
 522  AMAT(I,I,MATADR)=COSK
      AMAT(3,1,MATADR)=SINK
      AMAT(4,2,MATADR)=SINK
      AMAT(1,3,MATADR)=-SINK
      AMAT(2,4,MATADR)=-SINK
      AMAT(5,5,MATADR)=1.0D0
      AMAT(6,6,MATADR)=1.0D0
      AMAT(2,1,MATADR)=AL*COSK
      AMAT(4,1,MATADR)=AL*SINK
      AMAT(2,3,MATADR)=-SINK*AL
      AMAT(4,3,MATADR)=COSK*AL
      RETURN
  524 KCOUNT=KCOUNT+1
      GOTO 521
      END
      FUNCTION KMAND(STR,IS)
C******************************************************
C            DUMMY FUNCTION KMAND TO BE DEACTIVATED FOR IBM
C********************************************************
      KMAND=0
      RETURN
      END

      SUBROUTINE LABAN(INC,INDF,INDG,DELTA)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      COMMON/PLT/
     1XMIN,XMAX,YMIN,YMAX,XPMIN,XPMAX,YPMIN,YPMAX,ALMIN,ALMAX,
     >DELMIN,DELMAX,DNUMIN,DNUMAX,DBMIN,DBMAX,
     2MALL,NPLOT,NCCUM,NGRAPH,NCOL,NLINE
      COMMON/CHPLT/MXXPR,MYYPR,MXY,MALE
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      PARAMETER  (MXGACA = 15)
      PARAMETER  (MXGATR = 1030)
      COMMON/GEOM/XCO,XPCO,YCO,YPCO,NCASE,NJOB,
     <    EPSX(MXGACA),EPSY(MXGACA),XI(MXGACA),YI(MXGACA),
     <    XG(MXGATR,MXGACA),
     <    XPG(MXGATR,MXGACA),YG(MXGATR,MXGACA),YPG(MXGATR,MXGACA),
     <    LCASE(MXGACA)
      COMMON/CLINE/BETAXF(MXGACA),ALPHXF(MXGACA),BETAYF(MXGACA),
     >        ALPHYF(MXGACA),
     >XCOF(MXGACA),XPCOF(MXGACA),YCOF(MXGACA),YPCOF(MXGACA)
      COMMON/FUNC/BETAX,ALPHAX,ETAX,ETAPX,BETAY,ALPHAY,ETAY,ETAPY,
     <  STARTE,ENDE,DELTAE,DNU,MFPRNT,KOD,NLUM,NINT,NBUNCH
      COMMON/ANALC/COMPF,RNU0X,CETAX,CETAPX,CALPHX,CBETAX,
     1RMU1X,CHROMX,ALPH1X,BETA1X,
     1RMU0Y,RNU0Y,CETAY,CETAPY,CALPHY,CBETAY,
     1RMU1Y,CHROMY,ALPH1Y,BETA1Y,RMU0X,CDETAX,CDETPX,CDETAY,CDETPY,
     >COSX,ALX1,ALX2,VX1,VXP1,VX2,VXP2,
     >COSY,ALY1,ALY2,VY1,VYP1,VY2,VYP2,NSTABX,NSTABY,NSTAB,NWRNCP
      common/cprt/prnam(8,10),kodprt(2),
     >   iprtfl,intfl,itypfl,namfl,inam,itkod
      character*1 prnam
      CHARACTER*1 MALE(101,51),MXXPR(101,51),MYYPR(101,51),MXY(101,51)
      DIMENSION A(9),B(3),EPSCX(MXGATR),EPSCY(MXGATR)
      CHARACTER*1 NTITL1(28),NTITL2(28)
      LOGICAL LCASE
      DATA NTITL1/4*' ','H','O','R','I','Z','O','N','T','A','L',
     >' ','P','H','A','S','E',' ','S','P','A','C','E',' ',' '/
      DATA NTITL2/4*' ','V','E','R','T','I','C','A','L',' ',
     >'P','H','A','S','E',' ','S','P','A','C','E',' ',' ',' ',' '/
      IF(LCASE(INC))GOTO 120
      WRITE(IOUT,10012) EPSX(INC), EPSY(INC)
10012 FORMAT(/,'  CASE OF EPSX =',E10.3,'  EPSY =',E10.3,/,
     <'  NOT ANALYSED BECAUSE OF LOST PARTICLES  ',/)
      GO TO 1
  120 WRITE(IOUT,10010)EPSX(INC),EPSY(INC)
10010 FORMAT(/,30X,'  VALUES FOR NOMINAL EPSX =',E10.3,/,
     >30X,'     AND FOR NOMINAL EPSY =',E10.3,//)
      WRITE(IOUT,10020)BETAXF(INDF),ALPHXF(INDF),BETAYF(INDF),
     > ALPHYF(INDF),XCOF(INDF),XPCOF(INDF),YCOF(INDF),YPCOF(INDF)
10020 FORMAT(/,10X,'FUNCTION VALUES AT END OF BEAM LINE ARE ',//,
     >10X,'   BETAX =',E12.5,'  ALPHAX =',E12.5,'  BETAY =',E12.5,
     >'  ALPHAY =',E12.5,/,10X,'   XCOF  =',E12.5,'  XPCOF  =',
     >E12.5,'  YCOF  =',E12.5,'YPCOF  =',E12.5,//)
      IPLOTX=0
      IPLOTY=0
      IFLGX=0
      IFLGY=0
      BETAVX=1.0D0
      BETAVY=1.0D0
      GAMAVX=1.0D0
      GAMAVY=1.0D0
      ALPAVX=1.0D0
      ALPAVY=1.0D0
      SUMX1 = 0.0D0
      SUMX2 = 0.0D0
      SUMX3 = 0.0D0
      SUMX4 = 0.0D0
      SUMX5 = 0.0D0
      SUMX6 = 0.0D0
      SUMX7 = 0.0D0
      SUMX8 = 0.0D0
      SUMY1 = 0.0D0
      SUMY2 = 0.0D0
      SUMY3 = 0.0D0
      SUMY4 = 0.0D0
      SUMY5 = 0.0D0
      SUMY6 = 0.0D0
      SUMY7 = 0.0D0
      SUMY8 = 0.0D0
      NPRM1=NPART-1
      DO 2 NT = 1, NPRM1
      X = XG(NT,INDG)
      XP = XPG(NT,INDG)
      Y = YG(NT,INDG)
      YP = YPG(NT,INDG)
      IF(DABS(X).LT.1.0D-16)X=0.0D0
      IF(DABS(XP).LT.1.0D-16)XP=0.0D0
      IF(DABS(Y).LT.1.0D-16)Y=0.0D0
      IF(DABS(YP).LT.1.0D-16)YP=0.0D0
      X2 = X*X
      Y2 = Y*Y
      XP2 = XP*XP
      YP2 = YP*YP
      IF(DABS(X2).LT.1.0D-16)X2=0.0D0
      IF(DABS(XP2).LT.1.0D-16)XP2=0.0D0
      IF(DABS(Y2).LT.1.0D-16)Y2=0.0D0
      IF(DABS(YP2).LT.1.0D-16)YP2=0.0D0
      X3 = X2*X
      Y3 = Y2*Y
      XP3 = XP2*XP
      YP3 = YP2*YP
      X4 = X3*X
      Y4 = Y3*Y
      XP4 = XP3*XP
      YP4 = YP3*YP
      SUMX1 = SUMX1 + X4
      SUMY1 = SUMY1 + Y4
      SUMX2 = SUMX2 + X3*XP
      SUMY2 = SUMY2 + Y3*YP
      SUMX3 = SUMX3 + X2*XP2
      SUMY3 = SUMY3 + Y2*YP2
      SUMX4 = SUMX4 + X*XP3
      SUMY4 = SUMY4 + Y*YP3
      SUMX5 = SUMX5 + XP4
      SUMY5 = SUMY5 + YP4
      SUMX6 = SUMX6 + X2
      SUMY6 = SUMY6 + Y2
      SUMX7 = SUMX7 + X*XP
      SUMY7 = SUMY7 + Y*YP
      SUMX8 = SUMX8 + XP2
      SUMY8 = SUMY8 + YP2
    2 CONTINUE
      EPSAVX=1.0D0
      EPSAVY=1.0D0
      IF(EPSX(INC).EQ.0.0D0)GOTO 10
      IFLGX=1
      IPLOTX=1
      A(1) = SUMX1
      A(2) = SUMX3
      A(3) = SUMX2
      A(4) = SUMX3
      A(5) = SUMX5
      A(6) = SUMX4
      A(7) = SUMX2
      A(8) = SUMX4
      A(9) = SUMX3
      B(1) = SUMX6
      B(2) = SUMX8
      B(3) = SUMX7
      CALL DSIMQ(A,B,3,KS)
      CX = B(1)
      BX = B(2)
      AX = B(3)
      ARG=BX*CX-(AX*AX)/4.0D0
      IF(ARG.LT.0.0D0) GOTO 30
      EPSAVX = 1.0D0/(DSQRT(ARG))
      BETAVX = BX*EPSAVX
      ALPAVX = AX*EPSAVX/2.0D0
      GAMAVX = (1.0D0 + ALPAVX*ALPAVX)/BETAVX
      GOTO 10
   30 WRITE(IOUT,99999)
99999 FORMAT(/,' ELLIPSE COULD NOT BE FITTED TO X DATA',/)
      IFLGX=0
   10 IF(EPSY(INC).EQ.0.0D0)GOTO11
      IFLGY=1
      IPLOTY=1
      A(1) = SUMY1
      A(2) = SUMY3
      A(3) = SUMY2
      A(4) = SUMY3
      A(5) = SUMY5
      A(6) = SUMY4
      A(7) = SUMY2
      A(8) = SUMY4
      A(9) = SUMY3
      B(1) = SUMY6
      B(2) = SUMY8
      B(3) = SUMY7
      CALL DSIMQ(A,B,3,KS)
      CY = B(1)
      BY = B(2)
      AY = B(3)
      ARG=BY*CY-(AY*AY)/4.0D0
      IF(ARG.LT.0.0D0)GOTO 31
      EPSAVY = 1.0D0/(DSQRT(BY*CY-(AY*AY)/4.0D0))
      BETAVY = BY*EPSAVY
      ALPAVY = AY*EPSAVY/2.0D0
      GAMAVY = (1.0D0 + ALPAVY*ALPAVY)/BETAVY
      GOTO 11
   31 WRITE(IOUT,99998)
99998 FORMAT(/,' ELLIPSE COULD NOT BE FITTED TO Y DATA',/)
      IFLGY=0
   11 DO 3 NT = 1, NPRM1
      X = XG(NT,INDG)
      XP = XPG(NT,INDG)
      Y = YG(NT,INDG)
      YP = YPG(NT,INDG)
      IF(DABS(X).LT.1.0D-16)X=0.0D0
      IF(DABS(XP).LT.1.0D-16)XP=0.0D0
      IF(DABS(Y).LT.1.0D-16)Y=0.0D0
      IF(DABS(YP).LT.1.0D-16)YP=0.0D0
      EPSCX(NT) = GAMAVX*X*X + BETAVX*XP
     < *XP  + 2.0D0*ALPAVX*X*XP
      EPSCY(NT) = GAMAVY*Y*Y + BETAVY*YP
     < *YP + 2.0D0*ALPAVY*Y*YP
    3 CONTINUE
      EXMAX = 0.0D0
      EYMAX = 0.0D0
      SUMX = 0.0D0
      SUMY = 0.0D0
      EXMIN = 1.0D32
      EYMIN = 1.0D32
      DO 4 NT = 1, NPRM1
      IF(EPSCX(NT) .GT. EXMAX)EXMAX = EPSCX(NT)
      IF(EPSCX(NT) .LT. EXMIN)EXMIN = EPSCX(NT)
      IF(EPSCY(NT) .GT. EYMAX)EYMAX = EPSCY(NT)
      IF(EPSCY(NT) .LT. EYMIN)EYMIN = EPSCY(NT)
    4 CONTINUE
      DEX = EXMAX - EXMIN
      DEY = EYMAX - EYMIN
      DEEPSX=DEX/EPSAVX
      DEEPSY=DEY/EPSAVY
      XMIN = DSQRT(BETAVX*EXMIN)
      XMAX = DSQRT(BETAVX*EXMAX)
      YMIN = DSQRT(BETAVY*EYMIN)
      YMAX = DSQRT(BETAVY*EYMAX)
      CAMIN = XMIN*YMIN
      CAMAX = XMAX*YMAX
      IF(CAMIN.NE.0.0D0)CARAT=CAMAX/CAMIN
      IF((IFLGX.EQ.0).AND.(IFLGY.EQ.0))GOTO 40
      IF(IFLGX.EQ.0)GOTO 50
      IF(IFLGY.EQ.0)GOTO 60
      GOTO 70
   40 WRITE(IOUT,99997)
99997 FORMAT(/,'  PLOTS ONLY ARE PROVIDED ',/)
      GOTO 41
   70 WRITE(IOUT,10011)
10011 FORMAT('  AVERAGE :   BETAX',7X,'ALPHAX',6X,'EPSX',8X,'BETAY',
     <7X,'ALPHAY',6X,'EPSY',/)
      WRITE (IOUT, 10001) BETAVX,ALPAVX,EPSAVX,
     >                    BETAVY,ALPAVY,EPSAVY
10001 FORMAT (9X,6E12.3 )
      WRITE(IOUT, 10003)EXMAX, EXMIN, DEX, EYMAX, EYMIN, DEY
10003 FORMAT(/,'   EPSXMAX   EPSXMIN   DELEPSX   EPSYMAX ',
     <'   EPSYMIN   DELEPSY',/,' ',6E10.3,/)
      WRITE(IOUT,10006)DEEPSX,DEEPSY
10006 FORMAT(/,'  DELEPSX/EPSX   DELEPSY/EPSY ',/,2E10.3,/)
      WRITE(IOUT, 10005)CAMAX,CAMIN,CARAT
10005 FORMAT(/,'  CROSS SECTIONAL AREAS',//,10X,
     <'  MAXIMUM',5X,'  MINIMUM',5X,'   MAX/MIN',//,10X,4(E10.3,2X),/)
      GOTO 41
   50 WRITE(IOUT,50011)
50011 FORMAT('  AVERAGE :   BETAY',
     <7X,'ALPHAY',6X,'EPSY',/)
      WRITE (IOUT, 50001)
     >                    BETAVY,ALPAVY,EPSAVY
50001 FORMAT (9X,3E12.3 )
      WRITE(IOUT, 50003) EYMAX, EYMIN, DEY
50003 FORMAT(/,'   EPSYMAX ',
     <'   EPSYMIN   DELEPSY',/,' ',3E10.3,/)
      WRITE(IOUT,50006)DEEPSY
50006 FORMAT(/,'  DELEPSY/EPSY ',/,E10.3,/)
      GOTO 41
   60 WRITE(IOUT,60011)
60011 FORMAT('  AVERAGE :   BETAX',7X,'ALPHAX',6X,'EPSX',8X,
     </)
      WRITE (IOUT, 60001) BETAVX,ALPAVX,EPSAVX
60001 FORMAT (9X,3E12.3 )
      WRITE(IOUT, 60003)EXMAX, EXMIN, DEX
60003 FORMAT(/,'   EPSXMAX   EPSXMIN   DELEPSX'
     <,/,' ',3E10.3,/)
      WRITE(IOUT,60006)DEEPSX
60006 FORMAT(/,' DELEPSX/EPSX ',/,E10.3,/)
   41 IF(NPLOT .EQ. -1) GO TO 1
      XMAX = DSQRT(EPSX(INC)*BETAXF(INDF))*2.0D0
      XMIN = -XMAX
      YMAX = DSQRT(EPSY(INC)*BETAYF(INDF))*2.0D0
      YMIN = -YMAX
      GAMMFX = (1.0D0 + ALPHXF(INDF)*ALPHXF(INDF))/BETAXF(INDF)
      GAMMFY = (1.0D0 + ALPHYF(INDF)*ALPHYF(INDF))/BETAYF(INDF)
      NZERO = 0
      NCHAR = 39
      IF(DELTA.GT.0.0D0)NCHAR=36
      IF(DELTA.LT.0.0D0)NCHAR=38
      NCCUM =1
      NGRAPH = 4
      MALL = 0
      NCOL = 71
      NLINE = 51
      XPMAX = DSQRT(EPSX(INC)*GAMMFX)*2.0D0
      XPMIN = -XPMAX
      YPMAX = DSQRT(EPSY(INC)*GAMMFY)*2.0D0
      YPMIN = -YPMAX
      XMAX=XMAX+XCOF(INDG)
      XMIN=XMIN+XCOF(INDG)
      XPMAX=XPMAX+XPCOF(INDG)
      XPMIN=XPMIN+XPCOF(INDG)
      YMAX=YMAX+YCOF(INDG)
      YMIN=YMIN+YCOF(INDG)
      YPMAX=YPMAX+YPCOF(INDG)
      YPMIN=YPMIN+YPCOF(INDG)
      WRITE(IOUT,10021)
10021 FORMAT(///,'  THE FOLLOWING PLOTS ARE CENTERED AROUND THE ',
     >'CHOSEN ORBIT ')
      WRITE(IOUT,10022)
      IF(IPLOTX.EQ.1)CALL PLOT(PART(1,1),PART(1,2)
     >,NPART,XMAX,XMIN,XPMAX,XPMIN,
     > NCCUM,NZERO,NCHAR,NCOL,NLINE,NTITL1,MXXPR,LOGPAR)
      IF(IPLOTY.EQ.1)CALL PLOT(PART(1,3),PART(1,4)
     >,NPART,YMAX,YMIN,YPMAX,YPMIN,
     > NCCUM,NZERO,NCHAR,NCOL,NLINE,NTITL2,MYYPR,LOGPAR)
      WRITE(IOUT,10022)
10022 FORMAT('1')
    1 CONTINUE
      RETURN
      END
C     ***********************
      SUBROUTINE LAy(iend)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/LAYOUT/SHI,XHI,YHI,ZHI,THETAI,PHIHI,PSIHI,CONVH,
     >SRH,XRH,YRH,ZRH,THETAR,PHIRH,PSIRH,NLAY,layflg
      COMMON/FUNC/BETAX,ALPHAX,ETAX,ETAPX,BETAY,ALPHAY,ETAY,ETAPY,
     <  STARTE,ENDE,DELTAE,DNU,MFPRNT,KOD,NLUM,NINT,NBUNCH
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      character*1 ichar
      common/cprt/prnam(8,10),kodprt(2),
     >   iprtfl,intfl,itypfl,namfl,inam,itkod
      character*1 prnam
      PARAMETER    (MXLIST = 40)
      cOMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      NIPR=1
      NDATA=-1
      NCHAR=0
      CALL INPUT(ICHAR,NCHAR,DATA,MXINP,IEND,NDATA,NIPR)
      SHI=DATA(1)
      XHI=DATA(2)
      YHI=DATA(3)
      ZHI=DATA(4)
      THETAI=DATA(5)
      PHIHI=DATA(6)
      PSIHI=DATA(7)
      CONVH=DATA(8)
      MFPRNT = DATA(9)
      if(iprtfl.eq.1)goto 5210
      IF(MFPRNT.LE.0) GO TO 5210
      MLOCAT=MFPRNT
                 IF(MLOCAT.GT.MXLIST) THEN
                       WRITE(IOUT,30301)MLOCAT
30301 FORMAT(' **** TOO MANY INTERVALS ',I4,/,
     >' CHANGE MXLIST PARAMETER TO VALUE NEEDED')
                       CALL HALT(2)
                 ENDIF
      DO 5205 IL=1,MFPRNT
      iNDIL=2*IL-1
      INDOP=INDIL+9
      NLIST(INDIL)=DATA(INDOP)
 5205 NLIST(INDIL+1)=DATA(INDOP+1)
 5210 layflg=1
      call hwpnt
      return
      end
C     ***********************
      SUBROUTINE LCAV(IELM,MATADR)
C     ***********************
C  SUBROUTINE FOR MATRIX OF LINAC CAVITY WITH LENGTH AL,
C  ENTRANCE ENERGY E0, ENERGY GAIN DELTAE, REFERENCE PHASE
C  PHI0, AND FREQUENCY FREQ.
C
C  ADDED 11.20.86, R. YORK AND D. DOUGLAS
C
C  MODIFIED 12.16.86 TO ALLOW ERRORS IN ENERGY GAIN
C
C  RECOMMENTED, 01.14.86 TO DOCUMENT USE OF KICK SIMULATING
C  EFFECT OF R.F. COUPLER
C
C  L IN M
C  E0 IN GEV
C  DELTAE IN GEV
C  PHI0 IN DEGREES
C  FREQ NOT YET USED
C  KICKCOEF IN RADIANS-GEV
C  T - UNITLESS
C
C  SUBROUTINE FOR MATRIX OF LINAC CAVITY WITH LENGTH AL, ENTRANCE
C  ENERGY E0, ENERGY GAIN DELTAE, REFERENCE PHASE PHI0, AND FREQUENCY
C  FREQ.  KICK PARAMETERS KICKCOEF AND T SIMULATE (VIA SUBROUTINE TRACKT
C  ONLY)THE EFFECT OF DIPOLE FIELD AT RF COUPLER.KICKCOEF (ELDAT(IAD+6))
C  IS THE ANGULAR KICK IN RADIAN-GEV; THE MAGNITUDE OF THE KICK WILL BE
C  DELTAE*KICKCOEF*DCOS(PHI0)/CPREAL, WHERE CPREAL IS THE MOMENTUM
C  IN GEV AT THE SITE OF THE KICK.  CPREAL=DSQRT(EREAL**2-EMASS**2).
C
C  T IS A CONTROL SWITCH = -2,-1,0,1,2.  T<0 FOR KICK BEFORE THE CAVITY,
C                                        T>0 FOR KICK AFTER THE CAVITY
C                                        T=0 FOR NO KICK
C                                        |T|=1 FOR HORIZONTAL KICK
C                                        |T=2| FOR VERTICAL KICK
C
C *********** W A R N I N G !!!!!!! ************
C
C  LIKE MULTIPOLE STRENGTHS, KICKCOEF AND T ARE PACKED OUT BY MADIN
C  IF THEY ARE NOT INPUT OR IF THEY ARE INPUT WITH ZERO VALUE.
C  THEREFORE, DO NOT ENTER A ZERO KICKCOEF IF ERRORS ARE TO BE
C  PUT ON THIS PARAMETER DURING SUBSEQUENT COMPUTATIONS - INSTEAD
C  ENTER A SMALL NONZERO VALUE SUCH AS 10**-9.
C
C
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/PRODCT/KODEPR,NEL,NOF
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
C
C  COMMON CONTAINING LINAC CAVITY INFORMATION
C
      COMMON/LINCAV/LCAVIN,NUMCAV,ENJECT,IECAV(MAXMAT),
     &              EIDEAL(MAXPOS),EREAL(MAXPOS)
      LOGICAL LCAVIN
C
C LCAVIN    - FLAG FOR PRESENCE OF LINAC CAVITY
C NUMCAV    - NUMBER OF CAVITIES IN MACHINE
C ENJECT    - INJECTION ENERGY (GEV) - DEFAULTS TO 1 GEV
C IECAV(K)  - NORLST ADDRESS OF K-TH CAVITY IN THE MACHINE:
C             NORLST(IECAV(K)) IS THE ELEMENT IDENTIFIER OF THE
C             K-TH CAVITY: KODE(NORLST(IECAV(K)))=17
C
C EIDEAL(K) - ENERGY OF IDEAL MACHINE AT POSITION K
C EREAL(K)  - ENERGY OF REAL MACHINE (WITH ENERGY ERRORS) AT POSITION K
C
      LOGICAL HERE
C
C   CHECK TO SEE IF CAVITY IS IN MACHINE LIST. IF NOT, RETURN WITHOUT
C   COMPUTING MATRIX
C
      HERE=.FALSE.
      KAVPOS=0
      KAVORD=0
      DO 2 K=1,NELM
        IF(IELM.EQ.NORLST(K)) THEN
          HERE=.TRUE.
          KAVPOS=K
C
C! ADDRESS OF CAVITY IN NORLST - POSITION IN MACHINE
          DO 1 LYN=1,MAXMAT
            IF(KAVPOS.EQ.IECAV(LYN)) THEN
              KAVORD=LYN
C                            ! RELATIVE POSITION OF CAVITY IN MACHINE
C                            ! (ORDER NUMBER: 1ST, 2ND, 3RD, ...)
              GO TO 3
            END IF
    1     CONTINUE
        END IF
    2 CONTINUE
      IF(.NOT.HERE) RETURN
    3 CONTINUE
      IF ((KAVPOS*KAVORD).EQ.0) THEN
        WRITE(IOUT,1776)
 1776   FORMAT(1H1,'     CAVITY NOT FOUND IN LCAV: ERROR EXIT '///)
        CALL HALT(215)
      END IF
      IAD=IADR(IELM)
      AL=ELDAT(IAD)
C      E0=ELDAT(IAD+1)
      DELTAE=ELDAT(IAD+2)
      PHI0=ELDAT(IAD+3)
      FREQ=ELDAT(IAD+4)
      RKIK=ELDAT(IAD+5)
C
C  INITIALISE STORAGE ARRAY TO IDENTITY TRANSFORMATION
C
      DO 100 I=1,6
      DO 100 J=1,NOF
      AMAT(J,I,MATADR)=0.0D0
      IF(I.EQ.J) AMAT(J,I,MATADR)=1.0D0
  100 CONTINUE
C
C DETERMINE INJECTION ENERGY E0 FROM EREAL ARRAY
C
C    FIRST CAVITY USES INJECTION ENERGY ENJECT
C
      IF(KAVORD.EQ.1) THEN
         E0=ENJECT
                      ELSE
         E0=EREAL(KAVPOS-1)
      END IF
C
C  CHECK ENERGY GAIN AND UPDATE EREAL ARRAY IF PRESENT ENERGY GAIN
C  DIFFERS FROM GAIN RECORDED IN EREAL
C
      DEREAL=EREAL(KAVPOS)-E0
      DIFFDE=DELTAE-DEREAL
      IF(DABS(DIFFDE).GT.1.D-9) THEN
C                               UPDATE EREAL
         DO 4 KEVIN=KAVPOS,NELM
            EREAL(KEVIN)=EREAL(KEVIN)+DIFFDE
    4    CONTINUE
      END IF
C
C CODING DEFINING THE MATRIX GOES HERE
C
      IF (DABS(DELTAE).GT.1.D-9) THEN
      CPZ0=DSQRT(E0**2-EMASS**2)
      CPZL=DSQRT((E0+DELTAE)**2-EMASS**2)
      AMAT(2,1,MATADR)=(CPZ0*AL/DELTAE)*DLOG((E0+DELTAE+CPZL)/(E0+CPZ0))
      AMAT(2,2,MATADR)=CPZ0/CPZL
      AMAT(4,3,MATADR)=(CPZ0*AL/DELTAE)*DLOG((E0+DELTAE+CPZL)/(E0+CPZ0))
      AMAT(4,4,MATADR)=CPZ0/CPZL
      AMAT(6,6,MATADR)=CPZ0/CPZL
                                  ELSE
      AMAT(2,1,MATADR)=AL
      AMAT(4,3,MATADR)=AL
      END IF
      RETURN
      END
      SUBROUTINE LENG
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/LNGTH/TLENG,ALENG(MXELMD),ACLENG(MAXPOS)
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
C
C     STORE LENGTH OF EACH MACHINE ELEMENT
C
      DO 1 IE = 1,NA
      NGT=KODE(IE)+1
      GO TO (400,400,400,400,400,400,400,400,408,400,400,
     >400,400,400,400,400,400,400),NGT
  400 ALENG(IE)=ELDAT(IADR(IE))
      GO TO   1
  408 ALENG(IE)=ELDAT(IADR(IE)+8)+ELDAT(IADR(IE))
      GO TO   1
    1 CONTINUE
C
C     COMPUTE LENGTH OF MACHINE
C
      NGT=NORLST(1)
      ACLENG(1)=ALENG(NGT)
      DO 90 IL=2,NELM
      NGT=NORLST(IL)
  90  ACLENG(IL)=ACLENG(IL-1)+ALENG(NGT)
      TLENG=ACLENG(NELM)
      RETURN
      END
      INTEGER FUNCTION LENGTH(STRING)
C---- FIND LAST NON-BLANK CHARACTER IN "STRING"
C-----------------------------------------------------------------------
      CHARACTER*(*)     STRING
C-----------------------------------------------------------------------
      DO 10 L = LEN(STRING), 1, -1
        IF (STRING(L:L) .NE. ' ') GO TO 20
   10 CONTINUE
      L = 1
   20 LENGTH = L
      RETURN
      END
      SUBROUTINE LIMITS(IEND)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
      PARAMETER  (mxlvar = 100)
      PARAMETER  (mxlcnd = 200)
      COMMON/FITL/COEF(MXLVAR,6),VALF(MXLCND),
     >  WGHT(MXLCND),RVAL(MXLCND),XM(MXLVAR)
     >  ,EM(MXLVAR),WV,NELF(MXLVAR,6),NPAR(MXLVAR,6),
     >  IND(MXLVAR,6),NPVAR(MXLVAR),NVAL(MXLCND)
     >  ,NSTEP,NVAR,NCOND,ISTART,NDIV,IFITM,IFITD,IFITBM
      COMMON/LIMIT/VLO(MXLVAR),VUP(MXLVAR),WLIM(MXLVAR),
     >  DIS(MXLVAR),NELLIM(MXLVAR),
     >  WGHLIM(MXLVAR),VLOLIM(MXLVAR),VUPLIM(MXLVAR),
     >  DISLIM(MXLVAR),NPRLIM(MXLVAR),IFLCST,LIMFLG,NLIM,NEXP
      CHARACTER*1 NINE
      DATA NINE/'9'/
      NIPR=1
      IEL=1
    1 NDATA=0
      NCHAR=8
      CALL INPUT(ICHAR,NCHAR,DATA,MXINP,IEND,NDATA,NIPR)
      IF((ICHAR(1).EQ.NINE).AND.(ICHAR(2).EQ.NINE))GO TO 99
      CALL ELID(ICHAR,NELID)
      NELLIM(IEL)=NELID
      NDATA=0
      NCHAR=8
      CALL INPUT(ICHAR,NCHAR,DATA,MXINP,IEND,NDATA,NIPR)
      CALL DIMPAR(NELID,ICHAR,IDICT)
      NPRLIM(IEL)=IDICT
      NDATA=4
      NCHAR=0
      CALL INPUT(ICHAR,NCHAR,DATA,MXINP,IEND,NDATA,NIPR)
      VLO(IEL)=DATA(1)
      VUP(IEL)=DATA(2)
      WLIM(IEL)=DATA(3)
      DIS(IEL)=DATA(4)
      IEL=IEL+1
      IF(IEL.GT.MXLVAR) THEN
         WRITE(IOUT,10001)MXLVAR
         IF(ISO.NE.0)WRITE(ISOUT,10001)MXLVAR
10001 FORMAT(/,'  TOO MANY VARIABLE LIMITS . MAXIMUM IS : ',I4,/,
     > '  CHANGE PARAMETER MXLVAR ')
         CALL HALT(0)
      ENDIF
      IEM=IEL-1
       WRITE(IOUT,999)VLO(IEM),VUP(IEM),WLIM(IEM),DIS(IEM)
  999 FORMAT(' ',4E12.4)
      GOTO 1
   99 NLIM=IEL-1
      IFLCST=1
      RETURN
      END
      SUBROUTINE LINABE(IEND)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      COMMON/PLT/
     1XMIN,XMAX,YMIN,YMAX,XPMIN,XPMAX,YPMIN,YPMAX,ALMIN,ALMAX,
     >DELMIN,DELMAX,DNUMIN,DNUMAX,DBMIN,DBMAX,
     2MALL,NPLOT,NCCUM,NGRAPH,NCOL,NLINE
      COMMON/CHPLT/MXXPR,MYYPR,MXY,MALE
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      PARAMETER  (MXGACA = 15)
      PARAMETER  (MXGATR = 1030)
      COMMON/GEOM/XCO,XPCO,YCO,YPCO,NCASE,NJOB,
     <    EPSX(MXGACA),EPSY(MXGACA),XI(MXGACA),YI(MXGACA),
     <    XG(MXGATR,MXGACA),
     <    XPG(MXGATR,MXGACA),YG(MXGATR,MXGACA),YPG(MXGATR,MXGACA),
     <    LCASE(MXGACA)
      COMMON/CLINE/BETAXF(MXGACA),ALPHXF(MXGACA),BETAYF(MXGACA),
     >        ALPHYF(MXGACA),
     >XCOF(MXGACA),XPCOF(MXGACA),YCOF(MXGACA),YPCOF(MXGACA)
      COMMON/FUNC/BETAX,ALPHAX,ETAX,ETAPX,BETAY,ALPHAY,ETAY,ETAPY,
     <  STARTE,ENDE,DELTAE,DNU,MFPRNT,KOD,NLUM,NINT,NBUNCH
      COMMON/ANALC/COMPF,RNU0X,CETAX,CETAPX,CALPHX,CBETAX,
     1RMU1X,CHROMX,ALPH1X,BETA1X,
     1RMU0Y,RNU0Y,CETAY,CETAPY,CALPHY,CBETAY,
     1RMU1Y,CHROMY,ALPH1Y,BETA1Y,RMU0X,CDETAX,CDETPX,CDETAY,CDETPY,
     >COSX,ALX1,ALX2,VX1,VXP1,VX2,VXP2,
     >COSY,ALY1,ALY2,VY1,VYP1,VY2,VYP2,NSTABX,NSTABY,NSTAB,NWRNCP
      common/cprt/prnam(8,10),kodprt(2),
     >   iprtfl,intfl,itypfl,namfl,inam,itkod
      character*1 prnam
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
      CHARACTER*1 MALE(101,51),MXXPR(101,51),MYYPR(101,51),MXY(101,51)
      LOGICAL LCASE
      NORDER = 2
      NCHAR = 0
      NOP = -1
      DO 11 IL = 1,MXGACA
  11  LCASE(IL) = .TRUE.
      DO 10 IP = 1, MXPART
   10 LOGPAR(IP) = .TRUE.
      NDIM=mxinp
      NIPR=1
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NOP,NIPR)
      BETAX = data(1)
      ALPHAX = data(2)
      BETAY = data(3)
      ALPHAY = data(4)
      GAMMAX = (1.0D0+ALPHAX*ALPHAX)/BETAX
      GAMMAY = (1.0D0+ALPHAY*ALPHAY)/BETAY
      XCO = data(5)
      XPCO = data(6)
      YCO = data(7)
      YPCO = data(8)
      DELTA = data(9)
      NCASE = data(10)
      IF(NCASE .LE. MXGACA) GO TO 6
      NCASE = MXGACA
      WRITE (IOUT,10000)MXGACA
10000 FORMAT (/,' TOO MANY CASES REQUESTED:DEFAULT MAX',I4,' ARE READ',
     >/,' ADJUST PARAMETER MXGACA TO REQUIRED VALUE')
    6 NGPART = data(11)
      IF(NGPART .LE. MXGATR) GO TO 66
      NGPART = MXGATR
      WRITE (IOUT,10060)MXGATR
10060 FORMAT (/,' TOO MANY PARTICLES REQUESTED:DEFAULT MAX',I5,
     >' ARE USED ',/,'  ADJUST PARAMETER MXGATR TO REQUIRED VALUE')
   66 NCOUP= data(12)
      NGPLOT = data(13)
      NGPRNT = data(14)
      if(iprtfl.eq.1)goto 7
      MLOCAT= data(15)
      IF(MLOCAT.EQ.0)GOTO 7
                 IF(MLOCAT.GT.MXLIST) THEN
                       WRITE(IOUT,30301)MLOCAT
30301 FORMAT(' **** TOO MANY INTERVALS ',I4,/,
     >' CHANGE MXLIST PARAMETER TO VALUE NEEDED')
                       CALL HALT(2)
                 ENDIF
      DO 4 IML=1,MLOCAT
      INDIM = 2*IML -1
      INDOP = INDIM + 15
      NLIST(INDIM) = data(INDOP)
    4 NLIST(INDIM+1) = data(INDOP+1)
    7 EPSXM = 0.0D0
      EPSYM = 0.0D0
      DO 1 NC = 1, NCASE
      IND = (NC-1)*2 + 16 + 2*MLOCAT
      EPSX(NC) = data(IND)*1.0D-06
      EPSY(NC) = data(IND + 1)*1.0D-06
      IF(EPSX(NC) .GT. EPSXM)EPSXM = EPSX(NC)
      IF(EPSY(NC) .GT. EPSYM)EPSYM = EPSY(NC)
    1 CONTINUE
      DO 2 NP = 1, NGPART
      DO 3 IP = 1, 5
    3 PART(NP, IP) = 0.0D0
      PART(NP, 6) = DELTA
      DEL(NP)=DELTA
    2 CONTINUE
      NPART = 5
      NCPART = NPART
      PART(1,1) = XCO
      PART(1,2) = XPCO
      PART(1,3) = YCO
      PART(1,4) = YPCO
      PART(2,1) = XCO + 1.0D-06
      PART(2,2) = XPCO
      PART(2,3) = YCO
      PART(2,4) = YPCO
      PART(3,1) = XCO
      PART(3,2) = XPCO + 1.0D-06
      PART(3,3) = YCO
      PART(3,4) = YPCO
      PART(4,1) = XCO
      PART(4,2) = XPCO
      PART(4,3) = YCO + 1.0D-06
      PART(4,4) = YPCO
      PART(5,1) = XCO
      PART(5,2) = XPCO
      PART(5,3) = YCO
      PART(5,4) = YPCO + 1.0D-06
      NPLOT = -1
      NPRINT = -2
      NTURN = 1
      NCTURN = 0
C     WRITE(IOUT,77777)MDPRT
77777 FORMAT(' IN LINABE',I6)
      CALL TRACKT
      INDF=MLOCAT*2+1
      XCOF(INDF) = PART(1,1)
      XPCOF(INDF) = PART(1,2)
      YCOF(INDF) = PART(1,3)
      YPCOF(INDF) = PART(1,4)
      CX = (PART(2,1)-PART(1,1))*1.0D06
      CPX = (PART(2,2)-PART(1,2))*1.0D06
      SX = (PART(3,1)-PART(1,1))*1.0D06
      SPX = (PART(3,2)-PART(1,2))*1.0D06
      CY = (PART(4,3)-PART(1,3))*1.0D06
      CPY = (PART(4,4)-PART(1,4))*1.0D06
      SY = (PART(5,3)-PART(1,3))*1.0D06
      SPY = (PART(5,4)-PART(1,4))*1.0D06
      BETAXF(INDF) = CX*CX*BETAX-2.0D0*CX*SX*ALPHAX+SX*SX*GAMMAX
      ALPHXF(INDF) = -CPX*CX*BETAX+(1.0D0+2.0D0*SX*CPX)*ALPHAX
     >-SX*SPX*GAMMAX
      BETAYF(INDF) = CY*CY*BETAY-2.0D0*CY*SY*ALPHAY+SY*SY*GAMMAY
      ALPHYF(INDF) = -CPY*CY*BETAY+(1.0D0+2.0D0*SY*CPY)*ALPHAY
     >-SY*SPY*GAMMAY
      NPART = NGPART
      NPM1=NPART-1
      DO 20 INC=1,NCASE
      NPLOT = -1
      NPRINT = NGPRNT
      X0I=DSQRT(BETAX*EPSX(INC))
      XP0I=-ALPHAX*DSQRT(EPSX(INC)/BETAX)
      Y0I=DSQRT(BETAY*EPSY(INC))
      YP0I=-ALPHAY*DSQRT(EPSY(INC)/BETAY)
      DO 21 INP=1,NPM1
      ALCOS = DCOS((INP-1)*TWOPI/NPM1)
      ALSIN = DSIN((INP-1)*TWOPI/NPM1)
      XIL=X0I*(ALCOS+ALPHAX*ALSIN)+XP0I*BETAX*ALSIN
      XPIL=-X0I*GAMMAX*ALSIN+XP0I*(ALCOS-ALPHAX*ALSIN)
      YIL=Y0I*(ALCOS+ALPHAY*ALSIN)+YP0I*BETAY*ALSIN
      YPIL=-Y0I*GAMMAY*ALSIN+YP0I*(ALCOS-ALPHAY*ALSIN)
      PART(INP,1)=XCO+XIL
      PART(INP,2)=XPCO+XPIL
      PART(INP,3)=YCO+YIL
      PART(INP,4)=YPCO+YPIL
      PART(INP,5)=0.0D0
      PART(INP,6)=DELTA
   21 CONTINUE
      PART(NPART,1)=XCO
      PART(NPART,2)=XPCO
      PART(NPART,3)=YCO
      PART(NPART,4)=YPCO
      PART(NPART,5)=0.0D0
      PART(NPART,6)=DELTA
      NCPART=NPART
      NCTURN = 0
      CALL TRACKT
      NPLOT=NGPLOT
      DO 22 INP=1,NPART
      IF(.NOT.LOGPAR(INP))GOTO 23
      INDG=MLOCAT*2+1
      XG(INP,INDG)=PART(INP,1)-XCOF(INDG)
      XPG(INP,INDG)=PART(INP,2)-XPCOF(INDG)
      YG(INP,INDG)=PART(INP,3)-YCOF(INDG)
      YPG(INP,INDG)=PART(INP,4)-YPCOF(INDG)
   22 CONTINUE
      GOTO 24
   23 LCASE(INC)=.FALSE.
   24 CALL LABAN(INC,INDF,INDG,DELTA)
   20 CONTINUE
      RETURN
      END

      SUBROUTINE LINE(KNAME,LNAME)
C---- DEFINE A BEAM LINE
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
      CHARACTER*8       KNAME
C-----------------------------------------------------------------------
C---- ELEMENT TABLE
      PARAMETER         (MAXELM = 5000)
      COMMON /ELMDAT/   IELEM1,IELEM2,IETYP(MAXELM),IEDAT(MAXELM,3),
     +                  IELIN(MAXELM)
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- FLAGS FOR I/O
      COMMON /IOFLAG/   SCAN,ERROR,SKIP,ENDFIL,INTER
      LOGICAL           SCAN,ERROR,SKIP,ENDFIL,INTER
C-----------------------------------------------------------------------
      LOGICAL           FLAG
C-----------------------------------------------------------------------
C---- IF OLD FORMAT, READ BEAM LINE NAME
      IF (LNAME .EQ. 0) THEN
        CALL RDTEST(',',FLAG)
        IF (FLAG) GO TO 900
        CALL RDNEXT
        CALL RDWORD(KNAME,LNAME)
        IF (LNAME .EQ. 0) THEN
          CALL RDFAIL
          WRITE (IECHO,910)
          GO TO 900
        ENDIF
      ENDIF
C---- ALLOCATE ELEMENT CELL AND TEST FOR REDEFINITION
      CALL FNDELM(ILCOM,KNAME,IELEM)
      IF (IETYP(IELEM) .GE. 0) THEN
        CALL RDWARN
        WRITE (IECHO,920) IELIN(IELEM)
        IETYP(IELEM) = -1
      ENDIF
C---- FORMAL ARGUMENT LIST
      CALL DECFRM(IFORM1,IFORM2,FLAG)
      IF (FLAG) GO TO 900
C---- IF THERE WERE ARGUMENTS, SKIP TO =
      IF(IFORM1.NE.0 .AND. IFORM2.NE.0) CALL RDSKIP(':LINE')
C---- EQUALS SIGN?
      CALL RDTEST('=',FLAG)
      IF (FLAG) GO TO 900
      CALL RDNEXT
C---- BEAM LINE LIST
      CALL DECLST(IBEAM,IFORM1,IFORM2,FLAG)
      IF (FLAG) GO TO 900
C---- END OF COMMAND?
      CALL RDTEST(';',FLAG)
      IF (FLAG) GO TO 900
C---- STORE DEFINITION
      IETYP(IELEM) = 0
      IEDAT(IELEM,1) = IFORM1
      IEDAT(IELEM,2) = IFORM2
      IEDAT(IELEM,3) = IBEAM
      IELIN(IELEM) = ILCOM
      RETURN
C---- ERROR EXIT --- LEAVE BEAM LINE UNDEFINED
  900 ERROR = .TRUE.
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT(' *** ERROR *** BEAM LINE NAME EXPECTED'/' ')
  920 FORMAT(' ** WARNING ** THE ABOVE NAME WAS DEFINED IN LINE ',I5,
     +       ', IT WILL BE REDEFINED'/' ')
C-----------------------------------------------------------------------
      END
      SUBROUTINE LMDMES(INFO,NFEV)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      IF(INFO.EQ.0) THEN
         WRITE(IOUT,15000) NFEV
15000 FORMAT(/,' LMDIF: IMPROPER INPUT PARAMETERS: ',/,
     >' THE NUMBER OF FUNCTION CALLS WAS : ',I4)
         CALL HALT(310)
      ENDIF
      IF(NOUT.GE.3.AND.INFO.EQ.1)WRITE(IOUT,15001) NFEV
15001 FORMAT(/,' LMDIF: ACTUAL AND PREDICTED REDUCTIONS IN THE SUM OF ',
     > 'SQUARES ARE AT MOST FTOL',/,
     >' THE NUMBER OF FUNCTION CALLS WAS : ',I4)
      IF(NOUT.GE.3.AND.INFO.EQ.2)WRITE(IOUT,15002) NFEV
15002 FORMAT(/,' LMDIF: RELATIVE ERROR BETWEEN TWO CONSECUTIVE',
     >' ITERATES IS AT MOST XTOL',/,
     >' THE NUMBER OF FUNCTION CALLS WAS : ',I4)
      IF(NOUT.GE.3.AND.INFO.EQ.3)WRITE(IOUT,15003) NFEV
15003 FORMAT(/,' LMDIF: THIS IS YOUR LUCKY DAY!',/,
     >' THE NUMBER OF FUNCTION CALLS WAS : ',I4)
      IF(NOUT.GE.3.AND.INFO.EQ.4)WRITE(IOUT,15004) NFEV
15004 FORMAT(/,' LMDIF: THE COSINE OF THE ANGLE BETWEEN FVEC AND ANY ',/
     > '     COLUMN OF THE JACOBIAN IS AT MOST GTOL IN ABSOLUTE VALUE',/
     >' THE NUMBER OF FUNCTION CALLS WAS : ',I4)
      IF(NOUT.GE.3.AND.INFO.EQ.5)WRITE(IOUT,15005) NFEV
15005 FORMAT(/,' LMDIF: NUMBER OF CALLS TO FUNCTION HAS MET OR',
     > ' EXCEEDED MAXFEV',/,
     >' THE NUMBER OF FUNCTION CALLS WAS : ',I4)
      IF(NOUT.GE.3.AND.INFO.EQ.6)WRITE(IOUT,15006) NFEV
15006 FORMAT(/,' LMDIF: FTOL IS TOO SMALL, NO FURTHER REDUCTION',
     > ' IN THE SUM OF SQUARES IS POSSIBLE',/,
     >' THE NUMBER OF FUNCTION CALLS WAS : ',I4)
      IF(NOUT.GE.3.AND.INFO.EQ.7)WRITE(IOUT,15007) NFEV
15007 FORMAT(/,' LMDIF: XTOL IS TOO SMALL, NO FURTHER REDUCTION',
     > ' IN THE SUM OF SQUARES IS POSSIBLE',/,
     >' THE NUMBER OF FUNCTION CALLS WAS : ',I4)
      IF(NOUT.GE.3.AND.INFO.EQ.8)WRITE(IOUT,15008) NFEV
15008 FORMAT(/,' LMDIF: GTOL IS TOO SMALL. FVEC IS ORTHOGONAL TO THE ',
     >'COLUMNS OF THE JACOBIAN TO MACHINE PRECISION',/,
     >' THE NUMBER OF FUNCTION CALLS WAS : ',I4)
      RETURN
      END
      SUBROUTINE LSQ
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      COMMON/TRI/WCO(15,6),GEN(5,4),PGEN(75,6),DIST,
     <A1(15),B1(15),A2(15),B2(15),XCOR(3,15),XPCOR(3,15),
     1AL1(15),AL2(15),MESH,NIT,NENER,NITX,NITS,NITM1,NANAL,NOPRT
      COMMON/CLSQ/ALSQ(15,2,4),IXY,NCOEF,NAPLT,JENER,LENER(15)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/CONDEF/REFEN
      DIMENSION  AL(100),B(10),R(10,2,4),LL(10),ML(10),AMAX(2,4)
      LOGICAL LENER
      REF=REFEN
      IF((NENER.LT.NCOEF).OR.(NCOEF.EQ.0)) GO TO 1000
      IT=0
      DO 1 IE=1,NENER
    1 IF(LENER(IE))IT=IT+1
      IF(IT.LT.NCOEF) GO TO 1000
      DO 10 JXY=1,2
      DO 10 JNB=1,4
      DO 20 I=1,10
      B(I)=0.0
      R(I,JXY,JNB)=0.0
      DO 20 J=1,10
   20 AL((I-1)*10+J)=0.0
      DO 30 IE=1,NENER
      IF(.NOT.LENER(IE)) GO TO 30
      ENVAL=WCO(IE,6)/REF
      DO 40 IA=1,NCOEF
      DO 50 JA=IA,NCOEF
      IF(JA.NE.1) GO TO 49
      AL((IA-1)*NCOEF+JA)=AL((IA-1)*NCOEF+JA)+1.0
      GO TO 50
  49  AL((IA-1)*NCOEF+JA)=AL((IA-1)*NCOEF+JA)+ENVAL**(IA+JA-2)
   50 AL((JA-1)*NCOEF+IA)=AL((IA-1)*NCOEF+JA)
      IF(IA.NE.1) GO TO 39
      B(IA)=B(IA)+ALSQ(IE,JXY,JNB)
      GO TO 40
   39 B(IA)=B(IA)+ALSQ(IE,JXY,JNB)*ENVAL**(IA-1)
   40 CONTINUE
   30 CONTINUE
      CALL DMINV(AL,NCOEF,D,LL,ML)
      DO 60 IA=1,NCOEF
      DO 60 JA=1,NCOEF
   60 R(IA,JXY,JNB)=R(IA,JXY,JNB)+AL((IA-1)*NCOEF+JA)*B(JA)
   10 CONTINUE
      IF(NOUT.GE.1)
     >WRITE(IOUT,20003)REF
      IF(ISO.NE.0)WRITE(ISOUT,20003)REF
20003 FORMAT(/,'   THE REFERENCE ENERGY IS : ',E10.2,/)
      IF(NOUT.GE.1)
     >WRITE(IOUT,20000)
      IF(ISO.NE.0)WRITE(ISOUT,20000)
20000 FORMAT(//,'         EXPANSION COEFFICIENTS FOR ',//,
     >11X,'NUX',12X,'NUY',11X,'BETAX',10X,'BETAY',//)
      DO 61 I=1,NCOEF
      IM1=I-1
      IF(NOUT.GE.1)
     >WRITE(IOUT,20001)IM1,((R(I,J,K),J=1,2),K=1,2)
      IF(ISO.NE.0)WRITE(ISOUT,20001)I,((R(I,J,K),J=1,2),K=1,2)
   61 CONTINUE
20001 FORMAT(' ',I5,4E15.5)
      IF(NOUT.GE.1)
     >WRITE(IOUT,20002)
      IF(ISO.NE.0)WRITE(ISOUT,20002)
20002 FORMAT(//,'         EXPANSION COEFFICIENTS FOR ',//,
     >10X,'XCO ',11X,'YCO ',10X,'XPCO ',10X,'YPCO ',//)
      DO 62 I=1,NCOEF
      IM1=I-1
      IF(NOUT.GE.1)
     >WRITE(IOUT,20001)IM1,((R(I,J,K),J=1,2),K=3,4)
      IF(ISO.NE.0)WRITE(ISOUT,20001)I,((R(I,J,K),J=1,2),K=3,4)
   62 CONTINUE
      DO 31 K=1,4
      DO 32 J=1,2
      AMAX(J,K)=0.0
      DO 33 IE=1,NENER
      IF(.NOT.LENER(IE)) GO TO 33
      XE=WCO(IE,6)/REF
      VAL=0.0
      DO 34 I=1,NCOEF
   34 VAL =VAL*XE + R(NCOEF+1-I,J,K)
      ERR=DABS(VAL-ALSQ(IE,J,K))
      IF(ERR.GT.AMAX(J,K)) AMAX(J,K)=ERR
   33 CONTINUE
   32 CONTINUE
   31 CONTINUE
      IF(NOUT.GE.1)
     >WRITE(IOUT,30000) AMAX
30000 FORMAT(//,' MAXIMUM ABSOLUTE ERRORS ',//,2(4E15.6,/),//)
      RETURN
 1000 IF(NOUT.GE.1)
     >WRITE(IOUT,10000)
10000 FORMAT(47H   LEAST SQUARE FIT NOT DONE,LESS THAN FIVE PTS   )
      RETURN
      END
      SUBROUTINE LUMIN
C     *****************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      COMMON/FUNC/BETAX,ALPHAX,ETAX,ETAPX,BETAY,ALPHAY,ETAY,ETAPY,
     <  STARTE,ENDE,DELTAE,DNU,MFPRNT,KOD,NLUM,NINT,NBUNCH
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      COMMON/LNGTH/TLENG,ALENG(MXELMD),ACLENG(MAXPOS)
      COMMON/LUM/ UO,TAUX,ALPHX,ALPHY,TAUY,
     <  ALPHE,TAUE,SIGE,SIGX,EPSX,
     <SIGY,EPSY,SIGXT,SIGYT,ENERGY,TAUREV
      SIGXT2=SIGXT*SIGXT
      SIGYT2=SIGYT*SIGYT
      BRAT=BETAY/BETAX
      SIGX2=SIGX*SIGX
      SIGY2=SIGY*SIGY
      SIGE2=SIGE*SIGE
      TAURAT=TAUX/TAUY
      DENOM=SIGX2-SIGY2*TAURAT
      DENOM=DENOM-(ETAX*ETAX*BRAT-(ETAY*ETAY)/BRAT)*SIGE2
      COUP=(SIGXT2*BRAT-SIGYT2/BRAT)/DENOM
    1 A=DSQRT(COUP)
      GAMMA=(ENERGY/EMASS)
      SIGNX2=(SIGX2+COUP*TAURAT*SIGY2/BRAT)/(1.0D0+COUP)
      SIGNY2=(SIGY2+COUP*SIGX2*BRAT/TAURAT)/(1.0D0+COUP)
      SIGNX=DSQRT(SIGNX2)
      SIGNY=DSQRT(SIGNY2)
      SIGTX=DSQRT(SIGNX2+ETAX*ETAX*SIGE2)
      SIGTY=DSQRT(SIGNY2+ETAY*ETAY*SIGE2)
      SIGT=SIGTX+SIGTY
      ANPBN=2.0D0*PI*GAMMA*SIGTX*SIGT*DNU/(ERAD*BETAX)
      AIBEAM=ECHG*ANPBN*NBUNCH/TAUREV
      DENOM=(2.0D0*ERAD*BETAX*SIGTY*TAUREV*1.0D04)
      ALUM=GAMMA*NBUNCH*ANPBN*SIGT*DNU/DENOM
      IF(COUP.EQ.1.0D0) GOTO 2
      WRITE(IOUT,10002)A,SIGNX,SIGNY,SIGTX,SIGTY,ANPBN,AIBEAM,ALUM
      COUP= 1.0D0
      GOTO 1
   2  IF(NOUT.GE.3)
     >WRITE(IOUT,10003)A,SIGNX,SIGNY,SIGTX,SIGTY
10002 FORMAT('          VALUES FOR OPTIMUM COUPLING : ',F6.3,
     < //,' SIGX = ',E11.4,' (M)',10X,' SIGY = ',E11.4,' (M)'
     < /,' SIGXT = ',E11.4,' (M)',10X,'SIGYT = ',E11.4,' (M)',/,
     < ' # OF PARTICLES/BUNCH = ',E11.4,5X,' INTENSITY/BEAM = ',
     < E11.4,' AMP ',/
     < ' LUMINOSITY = ',E11.4,' (CM(-2)SEC(-1)) ')
10003 FORMAT(/,'          VALUES FOR MAXIMUM COUPLING : ',F6.3,
     < //,' SIGX = ',E11.4,' (M)',10X,' SIGY = ',E11.4,' (M)'
     < /,' SIGXT = ',E11.4,' (M)',10X,'SIGYT = ',E11.4,' (M)')
      RETURN
      END
      PROGRAM MADIN
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
C-----------------------------------------------------------------------
C---- PAGE HEADER
      COMMON /PAGTIT/   KTIT,KVERS,KDATE,KTIME
      CHARACTER*8       KTIT*80,KVERS,KDATE,KTIME
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
c******************** for use under ultrix
      integer time
      character*24 ctime,chtime
      external time,ctime
c********************for use on IBM under VM XA
      dimension now(8)
C---- UNITS FLAG
C-----------------------------------------------------------------------
C---- DEFAULT UNITS TO STANDARD
      KFLAGU = 0
C---- INITIALIZE TITLE
      KTIT = ' '
      IIN=15
      IOUT=16
      ISOUT=9
      kdate='        '
      KVERS = '1.01'
C---- INITIALIZE PLOT AND READ PACKAGES
      CALL PLINIT(10)
      CALL RDINIT(IIN,IOUT,ISOUT)
      OPEN(UNIT=IIN,STATUS='unknown')
      OPEN(UNIT=Iout,STATUS='unknown')
C*************  for use with Vax under VMS
c      CALL DATIMH(KDATE,KTIME)
c      WRITE (ISOUT,910) KVERS,KDATE,KTIME
c  910 FORMAT('1DIMAT VERSION ',A8,/,
c     +       '0DATE AND TIME OF THIS RUN:     ',A8,5X,A8)
c      WRITE (IouT,910) KVERS,KDATE,KTIME
C*************  for use with IBM under VM or XA
c      call datim(now)
c      write(iout,911)now(6),now(7),now(8),now(5),now(4),now(3)
c      write(isout,911)now(6),now(7),now(8),now(5),now(4),now(3)
c  911 format(/,'  THE DATE AND TIME OF THIS RUN : ',
c     > i2,'/',i2,'/',i4,'  ',i2,':',i2,':',i2,/)
c************* for use with ultrix
c     chtime=ctime(time())
c     write(iout,911)chtime
c 911 format(/,'  THE DATE AND TIME OF THIS RUN : ',a24,/)
C
C***************** end of special sets of statements
      WRITE (ISOUT,920)
C---- CLEAR STORAGE
      CALL CLEAR
C---- CALL CONTROL MODULE
      CALL CNTROL
C---- TERMINATE PLOT AND READ PACKAGES
      CALL PLEND
      CALL RDEND(101)
C-----------------------------------------------------------------------
  920 FORMAT('0INPUT STREAM AND MESSAGE LOG:'/' ')
C-----------------------------------------------------------------------
      END
      SUBROUTINE MAGT2(PARM,MATADR)
C     ***********************
C
C **** WARNING : IN THIS ROUTINE ALL VARIABLES ARE REAL UNLESS
C                OTHERWIZE DECLARED *********
C
      IMPLICIT REAL*8(A-Z)
      INTEGER KODE,IADR,KCOUNT,NA,KUNITS,MADR,MATADR,MAXMAT
      INTEGER NORDER,MPRINT,IMAT,NMAT,IFITE,NELM,NOP,NLIST
      INTEGER IIN,IOUT,ISOUT,ISO,NOUT,NSLC,NORLST,MAXDAT
      INTEGER N,I,J,MAXFAC,MXELMD,MAXPOS,MXPART,MXLIST
      INTEGER IPTYP
      EQUIVALENCE (COSR,CX,SPX),(COSV,CY,SPY),(DPX,SINEPR)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      DIMENSION PARM(20)
C
C     CLEAR AMAT(27,6,MATADR)
C
      DO 99 I=1,6
      DO 99 J=1,27
      AMAT(J,I,MATADR) = 0.0D0
99    CONTINUE
      DEFAND=PARM(1)
      AL=PARM(2)
      FIELDN=PARM(3)
      BETA=PARM(4)
      DEFANG=DEFAND*CRDEG
      H=DEFANG/AL
      RAD=1.0D0/H
      H2=H*H
      H3=H2*H
      H4=H3*H
      H5=H4*H
      H6=H5*H
      KX2=(1.0D0-FIELDN)*H2
      KY2=FIELDN*H2
      KX=DSQRT(DABS(KX2))
      KY=DSQRT(DABS(KY2))
      ARGX=KX*AL
      SINX=DSIN(ARGX)
      COSX=DCOS(ARGX)
      SHX=DSINH(ARGX)
      CHX=DCOSH(ARGX)
      KX4=KX2*KX2
      KX6=KX4*KX2
      ARGY=KY*AL
      SINY=DSIN(ARGY)
      COSY=DCOS(ARGY)
      SHY=DSINH(ARGY)
      CHY=DCOSH(ARGY)
      KY3=KY2*KY
      KY4=KY2*KY2
      TARGX=ARGX+ARGX
      SIN2X=DSIN(TARGX)
      COS2X=DCOS(TARGX)
      SH2X=DSINH(TARGX)
      CH2X=DCOSH(TARGX)
      KX3=KX*KX2
      KX5=KX3*KX2
      KX7=KX5*KX2
      TARGY=ARGY+ARGY
      SIN2Y=DSIN(TARGY)
      COS2Y=DCOS(TARGY)
      SH2Y=DSINH(TARGY)
      CH2Y=DCOSH(TARGY)
      AL2=AL*AL
      AL3=AL2*AL
      AL4=AL3*AL
      AL5=AL4*AL
      AL6=AL5*AL
      AL7=AL6*AL
      C=1.0D0/(KX2-4.0D0*KY2)
      IF (KX2) 1,2,3
    1 CX=DCOSH(KX*AL)
      SX=DSINH(KX*AL)/KX
      DX=H*(1.0D0-CX)/KX2
      J1XL=(ARGX-SHX)/KX3
      J2XL=(1.0D0-CHX+.5D0*ARGX*SHX)/KX4
      J3XL=.5D0*(SHX-ARGX*CHX)/KX3
      J4XL=(.5D0*ARGX-2.0D0*SHX/3.0D0+SH2X/12.0D0)/KX5
      J5XL=(.25D0-CHX/3.0D0+CH2X/12.0D0)/KX4
      J10XL=(ARGX-1.5D0*SHX+.5D0*ARGX*CHX)/KX5
      J11XL=(-2.0D0*ARGX+3.0D0*SHX-ARGX*CHX)/KX5
      J12XL=(4.0D0*ARGX-5.5D0*SHX+1.5D0*ARGX*CHX)/KX3
      J13XL=(.75D0-2.0D0*CHX/3.0D0-CH2X/12.0D0+.5D0*ARGX*SHX)
     <  /KX6
      J14XL=(1.5D0-4.0D0*CHX/3.0D0-CH2X/6.0D0+ARGX*SHX)/KX6
      J15XL=(-1.75D0+4.0D0*CHX/3.0D0+5.0D0*CH2X/12.0D0-1.5D0*ARGX*SHX)
     <  /KX4
      J16XL=(1.5D0*ARGX-7.0D0*SHX/3.0D0-SH2X/12.0D0+ARGX*CHX)/
     <  KX7
      J17XL=(-1.75D0*ARGX+17.0D0*SHX/6.0D0+5.0D0*SH2X/24.0D0-1.5D0
     <  *ARGX*CHX)/KX5
      J1L=(.5D0*ARGX-.25D0*SH2X)/KX3
      J2L=(.5D0*ARGX+.25D0*SH2X)/KX
      J3L=.25D0*(1.0D0-CH2X)/KX2
      IF(KY2) 345,346,347
345   J7XL=.5*(ARGX-SHX+KX2*C*(SHX-.5*KX*SH2Y/KY))/(KX3*KY2)
      J9XL=C*((CHX-1)/KX2+(1.0D0-CH2Y)/(4.0D0*KY2))
      GO TO 4
346   J7XL=(2.0D0*(SINX-ARGX)/KX3+AL3/3.0D0)/KX2
      J9XL=AL2/(2.0D0*KX2)+(CHX-1.0D0)/KX4
      GO TO 4
347   J7XL=.5D0*(ARGX-SHX+KX2*C*(SHX-.5D0*KX*SIN2Y/KY))/(KX3*KY2)
      J9XL=C*((CHX-1.0D0)/KX2+(1.0D0-COS2Y)/(4.0D0*KY2))
      GO TO 4
2     CX=1
      SX=AL
      DX=H*AL*AL/2.0D0
      J1XL=AL3/6.0D0
      J2XL=AL4/24.0D0
      J3XL=AL3/6.0D0
      J4XL=AL5/60.0D0
      J5XL=AL4/24.0D0
      J7XL=(AL3/12.0D0-AL/(8.0D0*KY2)-SIN2Y/(16.0D0*KY3))/KY2
      J10XL=-AL5/24.0D0
      J11XL=-AL5/60.0D0
      J12XL=AL3/6.0D0
      J9XL=AL2/(8.0D0*KY2)-(1.0D0-COS2Y)/(16.0D0*KY4)
      J13XL=AL6/240.0D0
      J14XL=AL6/1080.0D0
      J15XL=AL4/12.0D0
      J16XL=AL7/840.0D0
      J17XL=AL5/60.0D0
      J1L=AL3/3.0D0
      J2L=AL
      J3L=AL2/2.0D0
      GO TO 4
    3 CX=DCOS(KX*AL)
      SX=DSIN(KX*AL)/KX
      DX=H*(1.0D0-CX)/KX2
      J1XL=(ARGX-SINX)/KX3
      J2XL=(1.0D0-COSX-.5D0*ARGX*SINX)/KX4
      J3XL=.5D0*(SINX-ARGX*COSX)/KX3
      J4XL=(.5D0*ARGX-2.0D0*SINX/3.0D0+SIN2X/12.0D0)/KX5
      J5XL=(.25D0-COSX/3.0D0+COS2X/12.0D0)/KX4
      J10XL=(ARGX-1.5D0*SINX+.5D0*ARGX*COSX)/KX5
      J11XL=(-2.0D0*ARGX+3.0D0*SINX-ARGX*COSX)/KX5
      J12XL=(4.0D0*ARGX-5.5D0*SINX+1.5D0*ARGX*COSX)/KX3
      J13XL=(.75D0-2.0D0*COSX/3.0D0-COS2X/12.0D0-.5D0*ARGX*SINX)
     <  /KX6
      J14XL=(1.5D0-4.0D0*COSX/3.0D0-COS2X/6.0D0-ARGX*SINX)/KX6
      J15XL=(-1.75D0+4.0D0*COSX/3.0D0+5.0D0*COS2X/12.0D0+1.5D0*ARGX
     <  *SINX)/KX4
      J16XL=(1.5D0*ARGX-7.0D0*SINX/3.0D0-SIN2X/12.0D0+ARGX*COSX)/
     <  KX7
      J17XL=(-1.75D0*ARGX+17.0D0*SINX/6.0D0+5.0D0*SIN2X/24.0D0-1.5D0
     <  *ARGX*COSX)/KX5
      J1L=(.5D0*ARGX-.25D0*SIN2X)/KX3
      J2L=(.5D0*ARGX+.25D0*SIN2X)/KX
      J3L=.25D0*(1.0D0-COS2X)/KX2
      IF(KY2) 234,244,245
234   J7XL=.5D0*(ARGX-SINX+KX2*C*(SINX-.5D0*KX*SH2Y/KY))/(KX3*KY2)
      J9XL=C*((COSX-1.0D0)/KX2+(1.0D0-CH2Y)/(4.0D0*KY2))
      GO TO 4
244   J7XL=(2.0D0*(SINX-ARGX)/KX3+AL3/3.0D0)/KX2
      J9XL=AL2/(2.0D0*KX2)+(COSX-1.0D0)/KX4
      GO TO 4
245   J7XL=.5D0*(ARGX-SINX+KX2*C*(SINX-.5D0*KX*SIN2Y/KY))/(KX3*KY2)
      J9XL=C*((COSX-1.0D0)/KX2+(1.0D0-COS2Y)/(4.0D0*KY2))
    4 CPX=-KX2*SX
      SPX=CX
      DPX=H*SX
      IF (KY2) 5,6,7
    5 CY=DCOSH(KY*AL)
      SY=DSINH(KY*AL)/KY
      J4L=(.5D0*ARGY-.25D0*SH2Y)/KY3
      J5L=(.5D0*ARGY+.25D0*SH2Y)/KY
      J6L=.25D0*(1.0D0-CH2Y)/KY2
      GO TO 8
6     CY=1.0D0
      SY=AL
      J4L=AL3/3.0D0
      J5L=AL
      J6L=AL2/2.0D0
      GO TO 8
    7 CY=DCOS(KY*AL)
      SY=DSIN(KY*AL)/KY
      J4L=(.5D0*ARGY-.25D0*SIN2Y)/KY3
      J5L=(.5D0*ARGY+.25D0*SIN2Y)/KY
      J6L=.25D0*(1.0D0-COS2Y)/KY2
    8 CPY=-KY2*SY
      SPY=CY
      SY2=SY*SY
      A=2.0D0*FIELDN-1.0D0-BETA
      B=(2.0D0-FIELDN)
      BN1=2.0D0*FIELDN-1.0D0-BETA
      BN2=2.5D0*FIELDN-BETA-1.5D0
      BN3=2.0D0*BETA-FIELDN
      I10=DX/H
      I11=0.5D0*AL*SX
      I111=1.0D0*(SX**2+DX*RAD)/3.0D0
      I112=SX*DX*RAD/3.0D0
      I133=DX/H-(KY2/(KX2-4.0D0*KY2))*(SY2-2.0D0*DX*RAD)
      I134=C*(SY*CY-SX)
      I144=(SY2-2.0D0*DX*RAD)*C
      I20=SX
      I21=(SX+AL*CX)/2.0D0
      I22=I11
      I211=SX*(1.0D0+2.0D0*CX)/3.0D0
      I212=(2.0D0*SX**2-DX/H)/3.0D0
      I222=2.0D0*SX*DX*RAD/3.0D0
      I233=SX-2.0D0*KY2*(SY*CY-SX)*C
      I234=(KX2*DX*RAD-2.0D0*KY2*SY2)*C
      I244=2.0D0*C*(SY*CY-SX)
      I33=0.5D0*AL*SY
      IF(KY2.EQ.0.0D0) GO TO 9
      I34=0.5*(SY-AL*CY)/KY2
      GO TO 10
    9 I34=AL3/6.0D0
   10 I313=C*(KX2*CY*DX*RAD-2.0D0*SX*SY*KY2)
      I314=(2.0D0*SX*CY-SY*(1.0D0+CX))*C
      I324=C*(2.0D0*CY*DX*RAD-SX*SY)
      I43=0.5D0*(SY+AL*CY)
      I44=I33
      I413=C*((KX2-2.0D0*KY2)*SX*CY-KY2*SY*(1.0D0+CX))
      I414=C*((KX2-2.0D0*KY2)*SX*SY-CY*(1.0D0-CX))
      I424=C*(CY*SX-CX*SY-2.0D0*KY2*SY*DX*RAD)
      IF (KX.EQ.0.0D0) GO TO 20
      I12=(SX-AL*CX)*0.5D0/KX2
      I27=(DX*RAD-.5*AL*SX)/KX2
      I116=(0.5D0*AL*SX-(SX**2+DX/H)/3.0D0)*H/KX2
      I122=(2.0D0*DX/H-SX**2)/3.0D0/KX2
      I126=H*(SX+2.0D0*SX*CX-3.0D0*AL*CX)/6.0D0/KX2**2
      I166=H2*(4.0D0*DX*RAD/3.0D0+SX**2/3.0D0-AL*SX)/KX2**2
      I216=H*(AL*CX/2.0D0+SX/6.0D0-2.0D0*SX*CX/3.0D0)/KX2
      I226=H*(0.5D0*AL*SX-2.0D0*SX**2/3.0D0+DX*RAD/3.0D0)/KX2
      I266=H2*(SX/3.0D0+2.0D0*SX*CX/3.0D0-AL*CX)/KX2**2
      I323=C*(2.0D0*KY2*SY*(1.0D0+CX)/KX2-SX*CY)+SY/KX2
      I336=H*(0.5D0*AL*SY-C*(CY*(1.0D0-CX)-2.0D0*KY2*SX*SY))/KX2
      I346=H*(I34-C*(2.0D0*SX*CY-SY*(1.0D0+CX)))/KX2
      I423=C*(2.0D0*KY2*CY*(1.0D0+CX)/KX2-CX*CY-KY2*SX*SY)+CY/KX2
      I436=H*(0.5D0*AL*CY+0.5D0*SY+C*(KY2*SY*(1.0D0+CX)
     >-(KX2-2.0D0*KY2)*SX*CY))/KX2
      I446=H*(AL*SY*0.5D0-C*((KX2-2.0D0*KY2)*SX*SY-CY*(1.0D0-CX)))/KX2
      GO TO 21
20    I12=AL3/6.0D0
      I27=AL4/12.0D0
      I116=H*AL4/24.0D0
      I122=AL4/12.0D0
      I126=H*AL5/40.0D0
      I166=H2*AL2/120.0D0
      I216=H*AL3/6.0D0
      I226=H*AL4/8.0D0
      I266=H2*AL5/20.0D0
      I323=AL2*SY/4.0D0
      I336=H*AL*(AL2*SY/12.0D0+(AL*CY-SY)/(KY2*8.0D0))
      I346=H*AL2*(SY/(KY2*8.0D0)-AL*CY/(KY2*12.0D0))
      I423=(AL2*CY+AL*SY)/4.0D0
      I436=H*AL2*(SY/8.0D0+CY*AL/12.0D0)
      I446=H*AL*(AL2*SY/12.0D0+(SY-AL*CY)/(KY2*8.0D0))
21    AMAT( 1,1,MATADR)=CX
      I26=I12*H
      AMAT( 2,1,MATADR)=SX
      AMAT( 3,1,MATADR)=0.0D0
      AMAT( 4,1,MATADR)=0.0D0
      AMAT( 6,1,MATADR)=DX
      AMAT( 7,1,MATADR)=A*H3*I111+0.5D0*KX2**2*I122*H
      AMAT( 8,1,MATADR)=2.0D0*A*H3*I112-KX2*H*I112+H*SX
      AMAT( 9,1,MATADR)=0.0D0
      AMAT(10,1,MATADR)=0.0D0
      AMAT(12,1,MATADR)=B*H2*I11+2.0D0*A*H3*I116-KX2*H2*I122
      AMAT(13,1,MATADR)=A*H3*I122+0.5D0*H*I111
      AMAT(14,1,MATADR)=0.0D0
      AMAT(15,1,MATADR)=0.0D0
      AMAT(17,1,MATADR)=B*H2*I12+2.0D0*A*H3*I126+H2*I112
      AMAT(18,1,MATADR)=BETA*H3*I133-0.5D0*KY2*H*I10
      AMAT(19,1,MATADR)=2.0D0*BETA*H3*I134
      AMAT(21,1,MATADR)=0.0D0
      AMAT(22,1,MATADR)=BETA*H3*I144-0.5D0*H*I10
      AMAT(24,1,MATADR)=0.0D0
      AMAT(27,1,MATADR)=B*H2*H*I27+A*H3*I166+0.5D0*H3*I122-
     1           H*I10
      AMAT( 1,2,MATADR)=CPX
      AMAT( 2,2,MATADR)=SPX
      AMAT( 3,2,MATADR)=0.0D0
      AMAT( 4,2,MATADR)=0.0D0
      AMAT( 6,2,MATADR)=DPX
      AMAT( 7,2,MATADR)=A*H3*I211+0.5D0*KX2**2*H*I222-H*CX*CPX
      AMAT( 8,2,MATADR)=H*SPX+2.0D0*A*H3*I212-KX2*H*I212
     >       -H*(CX*SPX+CPX*SX)
      AMAT( 9,2,MATADR)=0.0D0
      AMAT(10,2,MATADR)=0.0D0
      AMAT(12,2,MATADR)=B*H2*I21+2.0D0*A*H3*I216-KX2*H2*I222-H*
     >(CX*DPX+CPX*DX)
      AMAT(13,2,MATADR)=A*H3*I222+0.5D0*H*I211-H*SX*SPX
      AMAT(14,2,MATADR)=0.0D0
      AMAT(15,2,MATADR)=0.0D0
      AMAT(17,2,MATADR)=B*H2*I22+2.0D0*A*H3*I226+H2*I212
     >        -H*(SX*DPX+SPX*DX)
      AMAT(18,2,MATADR)=BETA*H3*I233-0.5D0*KY2*H*I20
      AMAT(19,2,MATADR)=2.0D0*BETA*H3*I234
      AMAT(21,2,MATADR)=0.0D0
      AMAT(22,2,MATADR)=BETA*H3*I244-0.5D0*H*I20
      AMAT(24,2,MATADR)=0.0D0
      AMAT(27,2,MATADR)=B*H2*I26+A*H3*I266+0.5D0*H3*I222-H*DX*DPX-H*I20
C
C     VALUE OF "B" IS CHANGED.
C
      B=BETA-FIELDN
      AMAT( 1,3,MATADR)=0.0D0
      AMAT( 2,3,MATADR)=0.0D0
      AMAT( 3,3,MATADR)=CY
      AMAT( 4,3,MATADR)=SY
      AMAT( 6,3,MATADR)=0.0D0
      AMAT( 7,3,MATADR)=0.0D0
      AMAT( 8,3,MATADR)=0.0D0
      AMAT(9,3,MATADR)=2.0D0*B*H3*I313+KX2*KY2*H*I324
      AMAT(10,3,MATADR)=H*SY+2.0D0*B*H3*I314-KX2*H*I323
      AMAT(12,3,MATADR)=0.0D0
      AMAT(13,3,MATADR)=0.0D0
      AMAT(14,3,MATADR)=2.0D0*B*H3*I323-KY2*H*I314
      AMAT(15,3,MATADR)=2.0D0*B*H3*I324+H*I313
      AMAT(17,3,MATADR)=0.0D0
      AMAT(18,3,MATADR)=0.0D0
      AMAT(19,3,MATADR)=0.0D0
      AMAT(21,3,MATADR)=KY2*I33+2.0D0*B*H3*I336-KY2*H2*I324
      AMAT(22,3,MATADR)=0.0D0
      AMAT(24,3,MATADR)=KY2*I34+2.0D0*B*H3*I346+H2*I323
      AMAT(27,3,MATADR)=0.0D0
      AMAT( 1,4,MATADR)=0.0D0
      AMAT( 2,4,MATADR)=0.0D0
      AMAT( 3,4,MATADR)=CPY
      AMAT( 4,4,MATADR)=SPY
      AMAT( 6,4,MATADR)=0.0D0
      AMAT( 7,4,MATADR)=0.0D0
      AMAT( 8,4,MATADR)=0.0D0
      AMAT( 9,4,MATADR)=2.0D0*B*H3*I413+KX2*KY2*H*I424-H*CX*CPY
      AMAT(10,4,MATADR)=H*SPY+2.0D0*H3*B*I414-KX2*H*I423-H*CX*SPY
      AMAT(12,4,MATADR)=0.0D0
      AMAT(13,4,MATADR)=0.0D0
      AMAT(14,4,MATADR)=2.0D0*B*H3*I423-KY2*H*I414-H*SX*CPY
      AMAT(15,4,MATADR)=2.0D0*B*H3*I424+H*I413-H*SX*SPY
      AMAT(17,4,MATADR)=0.0D0
      AMAT(18,4,MATADR)=0.0D0
      AMAT(19,4,MATADR)=0.0D0
      AMAT(21,4,MATADR)=KY2*I43+2.0D0*B*H3*I436-KY2*H2*I424-H*DX*CPY
      AMAT(22,4,MATADR)=0.0D0
      AMAT(24,4,MATADR)=KY2*I44+2.0D0*B*H3*I446+H2*I423-H*DX*SPY
      AMAT(27,4,MATADR)=0.0D0
      AMAT(1,5,MATADR)=H*SX
      AMAT(2,5,MATADR)=DX
      AMAT(6,5,MATADR)=H2*J1XL
      AMAT(7,5,MATADR)=H4*(BN1*J1XL-BN2*KX2*J4XL)+.5D0*KX4*J1L
      AMAT(8,5,MATADR)=H4*2.0D0*BN2*J5XL-KX2*J3L+H*DX
      AMAT(12,5,MATADR)=H5*J11XL+H3*J12XL+H*KX2*J3XL
     <   +H5*2.0D0*BN2*J4XL+2.0D0*BETA*H5*J10XL-H*KX2*J1L
      AMAT(13,5,MATADR)=.5D0*(H2*J1XL+H4*2.0D0*BN2*J4XL+J2L)
      AMAT(17,5,MATADR)=-2.0D0*BETA*H5*J13XL+H5*J14XL+H3*J15XL+H*KX2*
     <  J2XL+H*J3L
      AMAT(18,5,MATADR)=.5D0*(H4*(BN3*J1XL-2.0D0*BETA*KY2*J7XL)+KY4*J4L)
      AMAT(19,5,MATADR)=2.0D0*BETA*H4*J9XL-KY2*J6L
      AMAT(22,5,MATADR)=BETA*H4*J7XL-.5D0*(H2*J1XL-J5L)
      AMAT(27,5,MATADR)=(1.0D0-BETA)*H6*J16XL+H4*J17XL-H2*J3XL
     >        +.5D0*H2*J1L
      DO 100 J=1,27
      AMAT( J,6,MATADR)=0.0D0
  100 CONTINUE
      AMAT(5,5,MATADR) = 1.0D0
      AMAT( 6,6,MATADR)=1.0D0
      RETURN
      END
      SUBROUTINE MATGEN(ILK)
C   *****************************
      IMPLICIT REAL*8 (A-H,O-Z)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/SYM/ENERLI,GAMMLI,BETALI,bili,b2li,b2ili,
     >ISYOPT,ISYFLG,MATTOT,KANVAR
      CHARACTER*1 NAME,LABEL
      MATADR=MADR(ILK)
      NGT=KODE(ILK)+1
c      write(iout,1000)ilk,ngt,matadr
c 1000 format(' entering matgen ilk,ngt,matadr are :',3i4)
C
C  ******* WARNING CODE 11 IS RESERVED INTERNALLY
C
      GO TO (100,101,102,103,104,105,106,107,108,109,110,111
     +,100,113,114,115,116,117,100,119),NGT
  111 GOTO 121
  116 GOTO 121
100   CONTINUE
      GOTO 121
101   CALL HBEND(ILK,MATADR)
      CALL TILTM(ILK,MATADR)
      GO TO 120
102   CALL FLEN2(ILK,MATADR)
      CALL TILTM(ILK,MATADR)
      GO TO 120
103   CALL HEXA2(ILK,MATADR)
      CALL TILTM(ILK,MATADR)
      GO TO 120
104   CALL QUASEX(ILK,MATADR)
      CALL TILTM(ILK,MATADR)
      GOTO 120
105   CALL MULTIM(ILK,MATADR)
      CALL TILTM(ILK,MATADR)
      GOTO 120
106   CONTINUE
      GO TO 121
107   CALL CAVMAT(ILK,MATADR)
      GO TO 120
108   continue
      GO TO 120
109   CALL TWISS(ILK,MATADR)
      GO TO 120
110   CALL GENRAL(ILK,MATADR)
      GO TO 120
115   CALL SOLQUA(ILK,MATADR)
      CALL TILTM(ILK,MATADR)
      GOTO 120
113   CONTINUE
      GOTO 121
114   GOTO 121
117   CALL LCAV(ILK,MATADR)
      IF(ISYFLG.EQ.1)WRITE(IOUT,99999)
99999 FORMAT(1H ,' *****WARNING: SYMPLECTIC OPTION IS ON !!!!***** '//
     &1H ,' SYMPLECTIC OPTION IS ACTIVATED IN PRESENCE OF LINAC '/
     &1H ,' CAVITIES.  THIS IS ILL-ADVISED.  CHECK THE MANUAL OR '/
     &1H ,' CALL AN AUTHOR FOR ADVICE - TRANSFORMATION OF MATRIX '/
     &1H ,' IS NOT PERFORMED '////)
      GO TO 121
119   continue
      CALL QUAdac(ILK,MATADR)
      CALL TILTM(ILK,MATADR)
      GOTO 120
120   IF(ISYFLG.EQ.1)CALL SYMMTX(MATADR)
121   continue
C      write(iout,2000)((amat(i,j,matadr),i=1,4),j=1,4)
C 2000 format(' exiting matgen, the matrix is :',/,4(4e12.4,/))
      RETURN
      END

C   *****************************
      subroutine matpre(kkod,iend)
C   *****************************
      IMPLICIT REAL*8 (A-H,O-Z)
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      common/cprt/prnam(8,10),kodprt(2),
     >   iprtfl,intfl,itypfl,namfl,inam,itkod
      character*1 prnam
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      COMMON/FUNC/BETAX,ALPHAX,ETAX,ETAPX,BETAY,ALPHAY,ETAY,ETAPY,
     <  STARTE,ENDE,DELTAE,DNU,MFPRNT,KOD,NLUM,NINT,NBUNCH
      COMMON/LAYOUT/SHI,XHI,YHI,ZHI,THETAI,PHIHI,PSIHI,CONVH,
     >SRH,XRH,YRH,ZRH,THETAR,PHIRH,PSIRH,NLAY,layflg
      COMMON/LNGTH/TLENG,ALENG(MXELMD),ACLENG(MAXPOS)
      COMMON/ANALC/COMPF,RNU0X,CETAX,CETAPX,CALPHX,CBETAX,
     1RMU1X,CHROMX,ALPH1X,BETA1X,
     1RMU0Y,RNU0Y,CETAY,CETAPY,CALPHY,CBETAY,
     1RMU1Y,CHROMY,ALPH1Y,BETA1Y,RMU0X,CDETAX,CDETPX,CDETAY,CDETPY,
     >COSX,ALX1,ALX2,VX1,VXP1,VX2,VXP2,
     >COSY,ALY1,ALY2,VY1,VYP1,VY2,VYP2,NSTABX,NSTABY,NSTAB,NWRNCP
      COMMON/LINCAV/LCAVIN,NUMCAV,ENJECT,IECAV(MAXMAT),
     &              EIDEAL(MAXPOS),EREAL(MAXPOS)
      LOGICAL LCAVIN
      COMMON/CBEAM/BSIG(6,6),BSIGF(6,6),MBPRT,IBMFLG,MENV
      kod=kkod
C
C     OPERATION CODE:  500, 510 OR 520
C
5000  NOP = -1
      NCHAR=0
      NIPR=1
      CALL INPUT(ICHAR,NCHAR,DATA,MXINP,IEND,NOP,NIPR)
      IF(KOD.EQ.500) GO TO 5001
      IF(KOD.EQ.510) GO TO 5100
      IF(KOD.EQ.515) GO TO 5500
      IF(KOD.EQ.520) GO TO 5200
      WRITE(IOUT,10010)
10010 FORMAT(24H ERROR IN OPERATION CODE)
      return
C
C   MATRIX COMPUTATION
C
5001  NORDER = DATA(1)
      NMAT=0
      IF(NORDER.LT.0)THEN
         NORDER=DABS(DATA(1))
         NMAT=1
         NMPR=NORDER/10
         NMAT=NMAT+NMPR*10
         NORDER=NORDER-NMPR*10
      ENDIF
      MPRINT = DATA(2)
      MFPRNT = -2
      if(iprtfl.eq.1) then
       goto 5010
      endif
      IF(MPRINT.LE.0) GO TO 5010
      MLOCAT=MPRINT
                 IF(MLOCAT.GT.MXLIST) THEN
                       WRITE(IOUT,30301)MLOCAT
30301 FORMAT(' **** TOO MANY INTERVALS ',I4,/,
     >' CHANGE MXLIST PARAMETER TO VALUE NEEDED')
                       CALL HALT(2)
                 ENDIF
      DO 5005 JM=1,MPRINT
      INDJM=2*JM-1
      INDOP=INDJM+2
      NLIST(INDJM)=DATA(INDOP)
 5005 NLIST(INDJM+1)=DATA(INDOP+1)
5010  CALL MATRIX
      NMAT=0
      return
C
C   FUNCTION COMPUTATION
C
5100  continue
      STARTE = DATA(1)
      NLUM=0
      DELTAE=1.0D0
      IF(DATA(1).EQ.0.0D0)GOTO 5101
      ENDE = DATA(2)
      DELTAE = DATA(3)
      NLUM = DATA(4)
      DNU = DATA(5)
      NINT = DATA(6)
      NBUNCH = DATA(7)
      IF(DATA(8).EQ.0.0D0)GOTO 5101
      BETAX = DATA(8)
      ALPHAX = DATA(9)
      ETAX = DATA(10)
      ETAPX = DATA(11)
      BETAY = DATA(12)
      ALPHAY = DATA(13)
      ETAY = DATA(14)
      ETAPY = DATA(15)
      GOTO 5102
 5101 BETAX = CBETAX
      ALPHAX = CALPHX
      ETAX = CETAX
      ETAPX = CETAPX
      BETAY = CBETAY
      ALPHAY = CALPHY
      ETAY = CETAY
      ETAPY = CETAPY
5102  IF(NOUT.GE.1)WRITE(IOUT,5120)
5120  FORMAT(/,' ELEMENT   #    BETAX   ALPHAX    BETAY   ALPHAY  ',
     <   ' ETAX   ETAPX  ETAY   ETAPY   NUX     NUY'
     <,'    EL. LEN   TOT. LEN    EIDEAL  EREAL ',/)
      IF(NOUT.GE.3)WRITE(IOUT,5125)BETAX,ALPHAX,BETAY,ALPHAY
     >,ETAX,ETAPX,ETAY,ETAPY,ENJECT,ENJECT
5125  FORMAT(/,14X,F9.3,F9.4,F9.3,F9.4,4F7.3,39X,2F7.3)
      MFPRNT = DATA(16)
      MPRINT = MFPRNT
      NORDER = 1
      if(iprtfl.eq.1) goto 5110
      IF (MFPRNT.LE.0) GO TO 5110
      MLOCAT=MFPRNT
                 IF(MLOCAT.GT.MXLIST) THEN
                       WRITE(IOUT,30301)MLOCAT
                       CALL HALT(2)
                 ENDIF
      DO 5105 JM=1,MFPRNT
      INDJM=2*JM-1
      INDOP=INDJM+16
      NLIST(INDJM)=DATA(INDOP)
 5105 NLIST(INDJM+1)=DATA(INDOP+1)
5110  CALL MATRIX
      return
C
C   HALFWAY POINT COMPUTATION
C
5200  continue
      layflg=2
      if(nop.eq.1) layflg=0
      STARTE = DATA(1)
      if(layflg.eq.2) then
      SHI=DATA(2)
      XHI=DATA(3)
      YHI=DATA(4)
      ZHI=DATA(5)
      THETAI=DATA(6)
      PHIHI=DATA(7)
      PSIHI=DATA(8)
      CONVH=DATA(9)
      MFPRNT = DATA(10)
      if(iprtfl.eq.1)goto 5210
      IF(MFPRNT.LE.0) GO TO 5210
      MLOCAT=MFPRNT
                 IF(MLOCAT.GT.MXLIST) THEN
                       WRITE(IOUT,30301)MLOCAT
                       CALL HALT(2)
                 ENDIF
      DO 5205 IL=1,MFPRNT
      INDIL=2*IL-1
      INDOP=INDIL+10
      NLIST(INDIL)=DATA(INDOP)
 5205 NLIST(INDIL+1)=DATA(INDOP+1)
      endif
5210  CALL HWPNT
      return
 5500 CONTINUE
      IF(DATA(1).NE.0.0D0)GOTO 5520
      DO 5557 IBB=1,6
      DO 5556 JBB=1,6
      BSIG(IBB,JBB)=0.0D0
 5556 CONTINUE
 5557 CONTINUE
      IF(DATA(2).NE.0.0D0) THEN
         BETXB=DATA(2)
         ALFXB=DATA(3)
         ETXB=DATA(4)
         ETXPB=DATA(5)
         BETYB=DATA(7)
         ALFYB=DATA(8)
         ETYB=DATA(9)
         ETYPB=DATA(10)
                                   ELSE
         BETXB=CBETAX
         ALFXB=CALPHX
         ETXB=CETAX
         ETXPB=CETAPX
         BETYB=CBETAY
         ALFYB=CALPHY
         ETYB=CETAY
         ETYPB=CETAPY
      ENDIF
      EPSXB=DATA(6)
      EPSYB=DATA(11)
      SIGL=DATA(12)
      SIGE=DATA(13)
      BSIG(5,5)=SIGL
      BSIG(6,6)=SIGE
      BSIG(5,6)=0.0D0
      INDB=14
      GAMXB=(1.0D0+ALFXB**2)/BETXB
      GAMYB=(1.0D0+ALFYB**2)/BETYB
      BSIG(1,1)=DSQRT(EPSXB*BETXB+(ETXB*SIGE)**2)
      BSIG(2,2)=DSQRT(EPSXB*GAMXB+(ETXPB*SIGE)**2)
      BSIG(1,2)=-ALFXB/(DSQRT(BETXB*GAMXB))
      BSIG(3,3)=DSQRT(EPSYB*BETYB+(ETYB*SIGE)**2)
      BSIG(4,4)=DSQRT(EPSYB*GAMYB+(ETYPB*SIGE)**2)
      BSIG(3,4)=-ALFYB/(DSQRT(BETYB*GAMYB))
      BSIG(1,6)=ETXB*SIGE/BSIG(1,1)
      BSIG(2,6)=ETXPB*SIGE/BSIG(2,2)
      BSIG(3,6)=ETYB*SIGE/BSIG(3,3)
      BSIG(4,6)=ETYPB*SIGE/BSIG(4,4)
      WRITE(IOUT,15500)((BSIG(I,J),J=I,6),I=1,6)
15500 FORMAT(' INPUT BEAM IS : ',/,
     >2X,6E12.4,/,14X,5E12.4,/,26X,4E12.4,/,38X,3E12.4,/,
     >50X,2E12.4,/,62X,E12.4,/)
      GOTO 5511
 5520 BSIG(1,1)=DATA(1)
      BSIG(1,2)=DATA(2)
      BSIG(1,3)=DATA(3)
      BSIG(1,4)=DATA(4)
      BSIG(1,5)=DATA(5)
      BSIG(1,6)=DATA(6)
      BSIG(2,2)=DATA(7)
      BSIG(2,3)=DATA(8)
      BSIG(2,4)=DATA(9)
      BSIG(2,5)=DATA(10)
      BSIG(2,6)=DATA(11)
      BSIG(3,3)=DATA(12)
      BSIG(3,4)=DATA(13)
      BSIG(3,5)=DATA(14)
      BSIG(3,6)=DATA(15)
      BSIG(4,4)=DATA(16)
      BSIG(4,5)=DATA(17)
      BSIG(4,6)=DATA(18)
      BSIG(5,5)=DATA(19)
      BSIG(5,6)=DATA(20)
      BSIG(6,6)=DATA(21)
      INDB=22
 5511 DO 5501 IBB=1,5
      JBB=IBB+1
      DO 5501 JB=JBB,6
      BSIG(IBB,JB)=BSIG(IBB,JB)*BSIG(IBB,IBB)*BSIG(JB,JB)
 5501 BSIG(JB,IBB)=BSIG(IBB,JB)
      DO 5503 IBB=1,6
 5503 BSIG(IBB,IBB)=BSIG(IBB,IBB)*BSIG(IBB,IBB)
      MBPRT=DATA(INDB)
      IBMFLG=1
      MENV=0
      IF(MBPRT.LT.900)GOTO 5505
      MENV=1
      MBPRT=MBPRT-1000
      IF(NOUT.GE.1)WRITE(IOUT,50001)
50001 FORMAT(//,20X,'   BEAM ENVELOPES ',//,
     >' NAMES  #       SIGX       SIGXP      epsxproj   SIGY       ',
     >'SIGYP      epsyproj   SIGL       SIG DEL ',//)
 5505 MPRINT=MBPRT
      NORDER=1
      if(iprtfl.eq.1) goto 5510
      IF(MBPRT.LE.0)GOTO 5510
      MLOCAT=MBPRT
                 IF(MLOCAT.GT.MXLIST) THEN
                       WRITE(IOUT,30301)MLOCAT
                       CALL HALT(2)
                 ENDIF
      DO 5502 JM=1,MBPRT
      INDJM=2*JM-1
      INDOP=INDJM+INDB
      NLIST(INDJM)=DATA(INDOP)
 5502 NLIST(INDJM+1)=DATA(INDOP+1)
 5510 IF(MBPRT.EQ.-2)GOTO 99050
      CALL MATRIX
99050 MENV=0
      return
      end
C   *****************************
      SUBROUTINE MATRIX
C   *****************************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      COMMON/PRODCT/KODEPR,NEL,NOF
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      COMMON/FOUT/OUTFL(350)
      COMMON/FUNC/BETAX,ALPHAX,ETAX,ETAPX,BETAY,ALPHAY,ETAY,ETAPY,
     <  STARTE,ENDE,DELTAE,DNU,MFPRNT,KOD,NLUM,NINT,NBUNCH
      COMMON/TWF/BETAOX,ALPHOX,ETAOX,ETAPOX,ANUX,
     >            BETAOY,ALPHOY,ETAOY,ETAPOY,ANUY,IE
      COMMON/LNGTH/TLENG,ALENG(MXELMD),ACLENG(MAXPOS)
      COMMON/LUM/ UO,TAUX,ALPHX,ALPHY,TAUY,
     <  ALPHE,TAUE,SIGE,SIGX,EPSX,
     <SIGY,EPSY,SIGXT,SIGYT,ENERGY,TAUREV
      PARAMETER  (mxlvar = 100)
      PARAMETER  (mxlcnd = 200)
      COMMON/FITL/COEF(MXLVAR,6),VALF(MXLCND),
     >  WGHT(MXLCND),RVAL(MXLCND),XM(MXLVAR)
     >  ,EM(MXLVAR),WV,NELF(MXLVAR,6),NPAR(MXLVAR,6),
     >  IND(MXLVAR,6),NPVAR(MXLVAR),NVAL(MXLCND)
     >  ,NSTEP,NVAR,NCOND,ISTART,NDIV,IFITM,IFITD,IFITBM
      COMMON/CBEAM/BSIG(6,6),BSIGF(6,6),MBPRT,IBMFLG,MENV
      COMMON/LINCAV/LCAVIN,NUMCAV,ENJECT,IECAV(MAXMAT),
     &              EIDEAL(MAXPOS),EREAL(MAXPOS)
      LOGICAL LCAVIN
      COMMON/MISSET/DX1,DX2,DXP1,DXP2,DY1,DY2,DYP1,DYP2,
     >DZ1,DZ2,DZC1,DZS1,DZC2,DZS2,DDEL,I,IEP,MNEL
      parameter    (MXCEB = 2000)
      common/cebcav/cebmat(6,6,mxceb),estart,ecav(mxceb),
     >ipos(mxceb),icavtot,icebflg,iestflg,icurcav
C
C ADDED 12.22.86 TO ALLOW TRANSFER OF IEP TO ESET AND THEREBY TO
C ACTIVATE ERRORS AND TO SET LOCATION OF ELEMENT IN MACHINE SO THAT
C LOCAL ENERGY (IDEAL AND REAL) IS KNOWN IN ORDER TO SCALE QUAD AND
C KICK STRENGTHS
C
      COMMON/CSEEDS/ISEED,IXG,IXS,IXMSTP,IMSD,IMOSTP,ISYNSD,ISYSTP,
     >ISDBEG,IBGSTP,IXES,IXESTP,IESBEG,IESTBG,isdcol
C
C  ADDED 12.23.86 TO ALLOW TRANSFER OF RANDOM SEEDS AND THEREBY TO
C  ACTIVATE PROPER SUCCESION OF SEEDS IN ERRORS
C
      BMAXX=-1000.0D0
      BMAXY=-1000.0D0
      EMAXX=-1000.0D0
      EMAXY=-1000.0D0
      IFUN=0
      IFITF=0
      IBEAM=0
      IMAT=0
      IWARN=0
      NOF=27
      IF(NORDER.EQ.1)NOF=6
      NUX = 0
      NUXS = 0
      NUY = 0
      NUYS = 0
      IF(KOD.EQ.500)IMAT=1
      IF(KOD.EQ.510)IFUN=1
      IF(KOD.EQ.110)IFITF=1
      IF(KOD.EQ.515)IBEAM=1
C
C   SET INTEGRALS INITIALLY TO ZERO
C
      IF(IFUN.EQ.0)GOTO 11
      AI1X=0.0D0
      AI2X=0.0D0
      AI3X=0.0D0
      AI4X=0.0D0
      AI5X=0.0D0
      AI1Y=0.0D0
      AI2Y=0.0D0
      AI3Y=0.0D0
      AI4Y=0.0D0
      AI5Y=0.0D0
C
C     SET TEMP TO IDENTITY
C
   11 DO 10 IX=1,6
      DO 10 IY=1,27
      TEMP(IX,IY)=0.0D0
      IF(IX.EQ.IY) TEMP(IX,IY)=1.0D0
10    CONTINUE
C
C     PROCESS EACH MACHINE ELEMENT FOR MATRIX PRODUCT EXCEPT CODE 12
C
      ILIST = 1
      JLIST=1
      KLIST=2
      ICMAT=0
C
C  SET SEEDS TO COVER ENTIRE MACHINE
C
      IF(IXMSTP.NE.0) THEN
           IXS=1
           IXMSTP=1
                      ELSE
           IXS=ISEED
      ENDIF
      IF(IXESTP.NE.0) THEN
           IXES=1
           IXESTP=1
                      ELSE
           IXES=ISEED
      ENDIF
      IERSRT = 1
C  THIS ASSIGNMENT (IERSRT=1) HAS IMPLICATIONS FOR THE NEROPT=5 CASE
C  AT PRESENT (12.23.86) I'M NOT SURE EXACTLY WHAT THEY ARE
C  BUT THIS AFFECTS ONLY THE ERROR OPERATION WHICH READS FROM FOR007
C
      icurcav=0
      DO 1000 IE=1,NELM
      IEP=IE
      IF((NMAT.GE.1).AND.(IE.EQ.NLIST(JLIST))) THEN
         IF(ICMAT.EQ.0) THEN
           CLEN=0.0D0
           ICMAT=1
           NEL1=NORLST(IE)
           IE1=IE
           DO 2001 IX=1,6
           DO 2001 IY=1,27
           TEMP(IX,IY)=0.0D0
           IF(IX.EQ.IY)TEMP(IX,IY)=1.0D0
 2001      CONTINUE
                         ELSE
           ICMAT=0
         ENDIF
         JLIST=JLIST+1
      ENDIF
 2000 NEL=NORLST(IE)
      CLEN=CLEN+ALENG(NEL)
      N=NEL
      MATADR=MADR(NEL)
      NT=KODE(NEL)
      KODEPR = KODE(NEL)
      CALL PROMtm(NEL,MATADR,ie)
C
C
  101 CONTINUE
      IF(IFUN.EQ.1)GOTO 12
      IF((IFITBM.EQ.1).AND.(IE.EQ.IFITE(1).OR.IE.EQ.IFITE(2)
     >.OR.IE.EQ.NELM))CALL BEAM
      IF(IFITF.EQ.1.AND.NT.EQ.2)GOTO12
      IF(IFITF.EQ.1.AND.(IE.EQ.IFITE(1).OR.IE.EQ.IFITE(2)
     >.OR.IE.EQ.NELM))GOTO 12
      IF(IBEAM.NE.0) CALL BEAM
      GOTO 840
   12 ANUX = DATAN2(TEMP(1,2),TEMP(1,1)*BETAX-TEMP(1,2)*ALPHAX)
      ANUX = ANUX/TWOPI
      IF (ANUX.LT.0.0) GO TO 810
      NUXS = 0
805   ANUX = ANUX+NUX
      GO TO 820
810   IF (NUXS.NE.0) GO TO 805
      NUX = NUX+1
      NUXS = 1
      GO TO 805
820   ANUY = DATAN2(TEMP(3,4),TEMP(3,3)*BETAY-TEMP(3,4)*ALPHAY)
      ANUY = ANUY/TWOPI
      IF (ANUY.LT.0.0) GO TO 830
      NUYS = 0
825   ANUY = ANUY+NUY
      GO TO 860
830   IF (NUYS.NE.0) GO TO 825
      NUY = NUY+1
      NUYS = 1
      GO TO 825
C
860   CONTINUE
      GAMMAX = (1.0D0+ALPHAX*ALPHAX)/BETAX
      GAMMAY = (1.0D0+ALPHAY*ALPHAY)/BETAY
      XM1122 = TEMP(1,1)*TEMP(2,2)
      XM1112 = TEMP(1,1)*TEMP(1,2)
      XM2111 = TEMP(2,1)*TEMP(1,1)
      XM1221 = TEMP(1,2)*TEMP(2,1)
      XM1222 = TEMP(1,2)*TEMP(2,2)
      BETAOX = TEMP(1,1)*TEMP(1,1)*BETAX-2.0D0*XM1112*ALPHAX+
     <     TEMP(1,2)*TEMP(1,2)*GAMMAX
      ALPHOX = -XM2111*BETAX+(xm1122+XM1221)*ALPHAX-
     <     XM1222*GAMMAX
      det = temp(1,1)*temp(2,2)-temp(1,2)*temp(2,1)
      betaox=betaox/det
      alphox=alphox/det
      ETAOX = TEMP(1,1)*ETAX+TEMP(1,2)*ETAPX+TEMP(1,6)
     >      + TEMP(1,3)*ETAY+TEMP(1,4)*ETAPY
      ETAPOX = TEMP(2,1)*ETAX+TEMP(2,2)*ETAPX+TEMP(2,6)
     >       + TEMP(2,3)*ETAY+TEMP(2,4)*ETAPY
      AMUX = ANUX*TWOPI
C
      YM1122 = TEMP(3,3)*TEMP(4,4)
      YM1112 = TEMP(3,3)*TEMP(3,4)
      YM2111 = TEMP(4,3)*TEMP(3,3)
      YM1221 = TEMP(3,4)*TEMP(4,3)
      YM1222 = TEMP(3,4)*TEMP(4,4)
      BETAOY = TEMP(3,3)*TEMP(3,3)*BETAY-2.0D0*YM1112*ALPHAY+
     <     TEMP(3,4)*TEMP(3,4)*GAMMAY
      ALPHOY = -YM2111*BETAY+(ym1122+YM1221)*ALPHAY-
     <     YM1222*GAMMAY
      det = temp(3,3)*temp(4,4)-temp(3,4)*temp(4,3)
      betaoy=betaoy/det
      alphoy=alphoy/det
      ETAOY = TEMP(3,3)*ETAY+TEMP(3,4)*ETAPY+TEMP(3,6)
     >      + TEMP(3,1)*ETAX+TEMP(3,2)*ETAPX
      ETAPOY = TEMP(4,3)*ETAY+TEMP(4,4)*ETAPY+TEMP(4,6)
     >       + TEMP(4,1)*ETAX+TEMP(4,2)*ETAPX
      AMUY = ANUY*TWOPI
      IF(NT.NE.2)GOTO 500
      IAD=IADR(NEL)
      AL=ELDAT(IAD)
      ST=ELDAT(IAD+1)
      IF(KUNITS.EQ.1) ST = -ST
      ALST=AL*ST/(2.0D0*TWOPI)
  500 IF(IFITF.NE.1)GOTO 300
      IF(((IE.EQ.IFITE(1).OR.IE.EQ.IFITE(2))
     >.OR.(IE.EQ.NELM)).AND.(IBEAM.NE.0))CALL BEAM
      IF(IE.EQ.IFITE(1).OR.IE.EQ.IFITE(2))CALL SETOUT
  300 IF(IFUN.EQ.0)GOTO 840
      IF(NLUM.EQ.0)GOTO 840
C
C
C   IS THE NEXT ELEMENT A BEND
C
C
      NEXT=IE+1
      NEXTEL=NORLST(NEXT)
      IF(NEXT.GT.NELM) GO TO 840
      KODN=KODE(NEXTEL)
      IBEND=0
      IF(KODN.EQ.1)IBEND=1
      IF(IBEND.EQ.0)GOTO 840
C
C   GET THE PARAMETERS
C
      IAT=IADR(NEXTEL)
      NNXTEL=NEXTEL+1
      NIAT=IADR(NNXTEL)
      TILT=ELDAT(NIAT-1)
      ANG=ELDAT(IAT+1)
      IF(ANG.EQ.0.0D0) GOTO 840
      IF(KUNITS.EQ.2) ANG = ANG*CRDEG
      IF(KUNITS.EQ.2) TILT=TILT*CRDEG
      AL=ELDAT(IAT)
      RAD=AL/ANG
      IF(KUNITS.EQ.2)FIELDN=ELDAT(IAT+2)
      IF(KUNITS.EQ.1)FIELDN = ELDAT(IAT+2)*RAD**2
      IF(KUNITS.EQ.0)FIELDN = -ELDAT(IAT+2)*RAD**2
      PHI1=ELDAT(IAT+4)
      IF(KUNITS.EQ.2) PHI1 = PHI1*CRDEG
      PHI2=ELDAT(IAT+8)
      IF(KUNITS.EQ.2) PHI2 = PHI2*CRDEG
      RAD2=RAD*RAD
      RAD3=RAD2*RAD
      AK2=(1.0D0-FIELDN)/RAD2
      AK=DSQRT(DABS(AK2))
      ARG=AK*AL
      AL2=AL*AL
      ARG2=AK2*AL*AL
      ARG3=ARG2*ARG
      ARG4=ARG2*ARG2
      ARG5=ARG3*ARG2
      IF(AK2)1,2,3
1     C=DCOSH(ARG)
      S=DSINH(ARG)
      GO TO 4
2     C=1.0D0
      S=0.0D0
      F1=1.0D0
      F2=.5D0
      F3=1.0D0/6.0D0
      F4=1.0D0/3.0D0
      F5=1.0D0/60.0D0
      GO TO 5
3     C=DCOS(ARG)
      S=DSIN(ARG)
4     F1=S/ARG
      F2=(1.0D0-C)/ARG2
      F3=(ARG-S)/ARG3
      F4=(ARG-S*C)/ARG3
      F5=(3.0D0*ARG-4.0D0*S+S*C)/ARG5
C
C   FIND THE VALUES THAT CONTRIBUTE TO THE INTEGRALS
C
    5 IF(DABS(DABS(TILT)-(PI/2.0D0)).LT.1.0D-04) GOTO 870
      IF((DABS(TILT).GE.1.0D-04).AND.(IWARN.EQ.0)) THEN
        WRITE(IOUT,99888)TILT
99888 FORMAT(' A BEND WITH A TILT OTHER THAN 0 OR 90 DEGREES WAS MET',
     >E12.4,/,' SYNCHROTRON INTEGRALS MAY BE ERRONEOUS ',/)
        IWARN=1
      ENDIF
      ETAP1=ETAPOX+ETAOX*DTAN(PHI1)/RAD
      AVETA=ETAOX*F1+ETAP1*AL*F2+AL2*F3/RAD
      ETA2=ETAOX*C+ETAP1*S*AL/ARG+(AL2*(1.0D0-C))/(RAD*ARG2)
      AVEFOR=FIELDN*AVETA/RAD3+(ETAOX*DTAN(PHI1)+ETA2*DTAN(PHI2))/
     <  (2.0D0*AL*RAD2)
      ALPHA1=ALPHOX-BETAOX*DTAN(PHI1)/RAD
      GAMMA=(1.0D0+ALPHA1*ALPHA1)/BETAOX
      T1=GAMMA*ETAOX*ETAOX
      T2=2.0D0*ALPHA1*ETAOX*ETAP1
      T3=BETAOX*ETAP1*ETAP1
      T4=-(GAMMA*ETAOX+ALPHA1*ETAP1)*F3*AL
      T5=(ALPHA1*ETAOX+BETAOX*ETAP1)*F2
      T45=2.0D0*AL*(T4+T5)/RAD
      T6=GAMMA*F5*AL2/2.0D0
      T7=ALPHA1*F2*F2*AL
      T8=BETAOX*F4/2.0D0
      T678=AL2*(T6-T7+T8)/RAD2
      HAV=T1+T2+T3+T45+T678
C
C   COMPUTE THE INTEGRALS
C
      AI1X=AI1X+AL*AVETA/RAD
      AI2X=AI2X+AL/RAD2
      AI3X=AI3X+AL/(DABS(RAD))**3
      AI4X=AI4X+(AL*AVETA/RAD3-2.0D0*AL*AVEFOR)
      AI5X=AI5X+AL*HAV/(DABS(RAD))**3
      GO TO 840
  870 ETAP1=ETAPOY+ETAOY*DTAN(PHI1)/RAD
      AVETA=ETAOY*F1+ETAP1*AL*F2+AL2*F3/RAD
      ETA2=ETAOY*C+ETAP1*S*AL/ARG+(AL2*(1.0D0-C))/(RAD*ARG2)
      AVEFOR=FIELDN*AVETA/RAD3+(ETAOY*DTAN(PHI1)+ETA2*DTAN(PHI2))/
     <  (2.0D0*AL*RAD2)
      ALPHA1=ALPHOY-BETAOY*DTAN(PHI1)/RAD
      GAMMA=(1.0D0+ALPHA1*ALPHA1)/BETAOY
      T1=GAMMA*ETAOY*ETAOY
      T2=2.0D0*ALPHA1*ETAOY*ETAP1
      T3=BETAOY*ETAP1*ETAP1
      T4=-(GAMMA*ETAOY+ALPHA1*ETAP1)*F3*AL
      T5=(ALPHA1*ETAOY+BETAOY*ETAP1)*F2
      T45=2.0D0*AL*(T4+T5)/RAD
      T6=GAMMA*F5*AL2/2.0D0
      T7=ALPHA1*F2*F2*AL
      T8=BETAOY*F4/2.0D0
      T678=AL2*(T6-T7+T8)/RAD2
      HAV=T1+T2+T3+T45+T678
C
C   COMPUTE THE INTEGRALS
C
      AI1Y=AI1Y+AL*AVETA/RAD
      AI2Y=AI2Y+AL/RAD2
      AI3Y=AI3Y+AL/(DABS(RAD))**3
      AI4Y=AI4Y+(AL*AVETA/RAD3-2.0D0*AL*AVEFOR)
      AI5Y=AI5Y+AL*HAV/(DABS(RAD))**3
      GO TO 840
C
C
  840 IF(MPRINT.EQ.-2)GOTO 1000
      IF(MPRINT.EQ.-1.AND.IE.NE.NELM)GOTO 1000
      IF(MPRINT.EQ.0)GO TO 900
      IF (NMAT .LT. 1)GO TO 2100
      IF (IE.NE.NLIST(KLIST))GO TO 1000
      NEL2=NORLST(IE)
      IE2=IE
      KLIST=KLIST+2
      IF(NOUT.GE.2)WRITE(IOUT,22222)(NAME(IN,NEL1),IN=1,8),IE1,
     <(NAME(IN,NEL2),IN=1,8),IE2
22222 FORMAT(///,'  BETWEEN  ',8A1, '  ELEMENT # ',I4,'  AND ',8A1,
     >'  ELEMENT # ',I4,/)
      CALL PRMAT(TEMP,NMAT,NORDER,CLEN)
      if(KLIST.GT.2*MPRINT) return
      GO TO 1000
 2100 IF(IE.EQ.NELM)GOTO 900
      CALL PRTTST(IE,ILIST,IPRT)
      IF(IPRT.NE.1) GOTO 1000
  900 IF(IMAT.EQ.0)GOTO 910
      WRITE(IOUT,8888)(NAME(IN,NEL),IN=1,8),IE
8888  FORMAT(////,'  AFTER :',8A1,' ELEMENT #:',I4,/)
      CALL PRMAT(TEMP,NMAT,NORDER,CLEN)
      IF(IE.NE.NELM)GOTO 910
      CALL ANAL
      CALL PRANAL(NORDER)
  910 IF((IFUN.EQ.0).OR.(MPRINT.EQ.-2))GOTO 950
      IF((NOUT.GE.2).OR.((NOUT.GE.1).AND.(IE.EQ.NELM)))
     >WRITE(IOUT,880)(NAME(IN,NEL),IN=1,8),
     >IE,BETAOX,ALPHOX,BETAOY,
     <ALPHOY,ETAOX,ETAPOX,ETAOY,ETAPOY,ANUX,ANUY,ALENG(NEL),ACLENG(IE)
     <,EIDEAL(IE),EREAL(IE)
880   FORMAT(1X,8A1,I5,F9.3,F9.4,F9.3,F9.4,4F7.3,2F8.4,1X,F7.3,3X,F9.3,
     &3X,2F7.3)
c============================================================ FWJ
c-----Output for DEPOL program, if wanted (idepol.ne.0)
c============================================================
        idepol=0
      if (idepol .ne. 0) then
        if (name(1,nel) .eq.'H') then   !Get (bending radius)^-1 = rhoi
          j_hbend_position = iadr(nel)
          hbend_rhoi = eldat(j_hbend_position+1)/
     >                   eldat(j_hbend_position)*crdeg
          entrance_angle = eldat(j_hbend_position+4)*crdeg
          exit_angle     = eldat(j_hbend_position+8)*crdeg
        else
          hbend_rhoi = 0.
          entrance_angle = 0.
          exit_angle = 0.
        endif
        if (name(1,nel) .eq. 'Q') then  ! Get Quad focussing strength
          j_quad_position = iadr(nel)
          quad_k = eldat(j_quad_position+1)
        else
          quad_k = 0.
        endif
        write (idepol,881) acleng(ie),anuy,betaoy,
     >                           hbend_rhoi,quad_k,entrance_angle,
     >                           exit_angle,dummy
881     format(' ',7(d15.8,','),d15.8)
      endif
C============================================================ FWJ
      IF(BETAOX.GT.BMAXX)BMAXX=BETAOX
      IF(BETAOY.GT.BMAXY)BMAXY=BETAOY
      IF(ETAOX.GT.EMAXX)EMAXX=ETAOX
      IF(ETAOY.GT.EMAXY)EMAXY=ETAOY
  950 IF(IBEAM.EQ.0)GOTO 1000
      IF(MENV.EQ.1)GOTO 1001
      IF((NOUT.GE.2).OR.((NOUT.GE.1).AND.(IE.EQ.NELM)))
     >WRITE(IOUT,9999)(NAME(IN,NEL),IN=1,8),IE,
     >((BSIGF(I,J),J=I,6),I=1,6)
 9999 FORMAT(//,' AFTER :',8A1,' ELEMENT #:',I4,' THE BEAM MATRIX IS :'
     >//,' ',6E12.4,/,' ',12X,5E12.4,/,' ',24X,4E12.4,/,' ',36X,
     >3E12.4,/,' ',48X,2E12.4,/,' ',60X,E12.4,/)
      GOTO 1000
1001  IF(NSLC.EQ.0) THEN
c     IF((NOUT.GE.2).OR.((NOUT.GE.1).AND.(IE.EQ.NELM)))          modified 4/10/95 to ease plotting DRD
c    >WRITE(IOUT,9998)(NAME(IN,NEL),IN=1,8),IE,
c    >BSIGF(1,1),BSIGF(2,2),BSIGF(3,3),BSIGF(4,4),BSIGF(5,5),
c    >BSIGF(6,6)
C     IF((NOUT.GE.2).OR.((NOUT.GE.1).AND.(IE.EQ.NELM)))          modified 4/13/95 to ease plotting DRD
C    >WRITE(IOUT,9998)(NAME(IN,NEL),IN=1,8),IE,
C    >BSIGF(1,1),BSIGF(2,2),BSIGF(3,3),BSIGF(4,4),BSIGF(5,5),
C    >BSIGF(6,6),acleng(ie)
      IF((NOUT.GE.2).OR.((NOUT.GE.1).AND.(IE.EQ.NELM)))
     >WRITE(IOUT,9998)(NAME(IN,NEL),IN=1,8),IE,
     >BSIGF(1,1),BSIGF(2,2),
     >bsigf(1,1)*bsigf(2,2)*dsqrt(1.d0-bsigf(1,2)*bsigf(1,2)),
     >BSIGF(3,3),BSIGF(4,4),
     >bsigf(3,3)*bsigf(4,4)*dsqrt(1.d0-bsigf(3,4)*bsigf(3,4)),
     >BSIGF(5,5),BSIGF(6,6),acleng(ie)
c
                    ELSE
      IF((NOUT.GE.2).OR.((NOUT.GE.1).AND.(IE.EQ.NELM)))
     >WRITE(IOUT,9997)(LABEL(IN,NEL),IN=1,14),
     >BSIGF(1,1),BSIGF(2,2),BSIGF(3,3),BSIGF(4,4),BSIGF(5,5),
     >BSIGF(6,6)
      ENDIF
c
c9998 FORMAT(' ',8A1,I5,6E11.4)
c
C9998 FORMAT(' ',8A1,I5,6E11.4,3x,f9.3)
 9998 FORMAT(' ',8A1,I5,8E11.4,3x,f9.3)
c
 9997 FORMAT(' ',14A1,6E11.4)
1000  CONTINUE
      IF(KOD.EQ.510.AND.MPRINT.EQ.0) THEN
        WRITE(IOUT,10011)BMAXX,BMAXY,EMAXX,EMAXY
        IF(ISO.NE.0)WRITE(ISOUT,10011)BMAXX,BMAXY,EMAXX,EMAXY
      ENDIF
10011  FORMAT(/,' MAXIMUM LATTICE FUNCTIONS :',/,
     >  ' BETA X =',E20.10,'     BETA Y =',E20.10,/,
     >  ' ETA  X =',E20.10,'     ETA  Y =',E20.10)
      IF(IFUN.EQ.0)RETURN
      IF(KOD.EQ.110)RETURN
      AI1=AI1X+AI1Y
      AI2=AI2X+AI2Y
      AI3=AI3X+AI3Y
      AI4=AI4X+AI4Y
       AI5=AI5X+AI5Y
C
C
      IF(NLUM.EQ.0)GOTO 5000
      WRITE(IOUT,1100)AI1X,AI2X,AI3X,AI4X,AI5X
 1100 FORMAT(/,'   SYNCHROTRON INTEGRALS ARE  ',//,
     >3X,'INTEGRAL X1=',E18.11,13X,'INTEGRAL X2=',E18.11,/,
     <       3X,'INTEGRAL X3=',E18.11,13X,'INTEGRAL X4=',E18.11,/,
     <       3X,'INTEGRAL X5=',E18.11,/)
      WRITE(IOUT,1101)AI1Y,AI2Y,AI3Y,AI4Y,AI5Y
1101  FORMAT(/,3X,'INTEGRAL Y1=',E18.11,13X,'INTEGRAL Y2=',E18.11,/,
     <       3X,'INTEGRAL Y3=',E18.11,13X,'INTEGRAL Y4=',E18.11,/,
     <       3X,'INTEGRAL Y5=',E18.11,/)
5000  COMPAC = AI1/TLENG
      IF(DABS(AI2).LT.1.0E-30)RETURN
      AJX = 1.0D0-(AI4X/AI2)
      AJY = 1.0D0-(AI4Y/AI2)
      AJE = 2.0D0+(AI4/AI2)
      TAUREV = NINT*TLENG/CLIGHT
      FREV = 1.0D0/TAUREV
      ENERGY = STARTE
C
C   OUTPUT THE RESULTS
C
      WRITE(IOUT,10001)
10001 FORMAT(//,10X,' LUMINOSITY RESULTS FOR OPTIMUM AND '
     <,'MAXIMUM COUPLING ONLY ',//)
      TOTLEN=NINT*TLENG
      WRITE(IOUT,10002)TOTLEN,NINT,NBUNCH,DNU
10002 FORMAT(' TOTAL LENGTH = ',F11.3,' (M)   # INTERACTION PTS = '
     <,I3,/,' # BUNCHES = ',I3,10X,' DNU FOR OPTIMUM = ',F6.3)
      WRITE(IOUT,734)COMPAC,AJX,AJY,AJE,TAUREV,FREV
      IF(ISO.NE.0)WRITE(ISOUT,734)COMPAC,AJX,AJY,AJE,TAUREV,FREV
734   FORMAT(/,' MOMENTUM COMPACTION=',E15.7,3X,'JX=',F8.5,3X,
     < 'JY=',F8.5,3X,
     <  'JE=',F8.5,/,' TAUREV=',E15.7,'(SEC)',3X,'FREV=',E15.7,
     <  '(HZ)'/)
733   ALPH = 7.039346E-06*ENERGY**3*FREV*NINT
      UO = 1.4078692E-02*ENERGY**4*AI2*NINT
      ALPHX = ALPH*(AI2-AI4X)
      TAUX = 1.0D0/ALPHX
      ALPHY = ALPH*(AI2-AI4Y)
      TAUY = 1.0D0/ALPHY
      ALPHE = ALPH*(2.0D0*AI2+AI4)
      TAUE = 1.0D0/ALPHE
      SIG = 1.211335E-03*ENERGY
      SIGE = SIG*DSQRT(AI3/(2.0D0*AI2+AI4))
      EPSX = DABS(AI5X/(AI2-AI4X))*SIG**2
      SIGX = DSQRT(EPSX*BETAX)
      EPSY = DABS(AI5Y/(AI2-AI4Y))*SIG**2
      SIGY = DSQRT(EPSY*BETAY)
      SIGXT=DSQRT(SIGX**2+(ETAX*SIGE)**2)
      SIGYT=DSQRT(SIGY**2+(ETAY*SIGE)**2)
      WRITE(IOUT,735)ENERGY,UO,ALPHX,ALPHY,ALPHE,
     <  TAUX,TAUY,TAUE,SIGE,EPSX,SIGX,
     <SIGXT,EPSY,SIGY,SIGYT
      IF(ISO.NE.0)WRITE(ISOUT,735)ENERGY,UO,ALPHX
     <,ALPHY,ALPHE,
     <  TAUX,TAUY,TAUE,SIGE,EPSX,SIGX,
     <SIGXT,EPSY,SIGY,SIGYT
735   FORMAT(//,20X,' ENERGY = ',F8.4,'(GEV)',//,' ENERGY LOSS =',
     < E13.5,'(MEV/REV)'
     < ,/,' AX=',E13.5,'(/SEC)',5X,'AY=',E13.5,'(/SEC)',5X,'AE=',
     <  E13.5,'(/SEC)',/,' TAUX=',E13.5,'(SEC)',4X,'TAUY=',E13.5,'(SEC)'
     < ,4X,'TAUE=',E13.5,'(SEC)',/,' SIGE=',E13.5,/,
     <  ' EPSX=',E13.5,'(M-RAD)',2X,'SIGX=',E13.5,'(M.)',5X,
     <'SIGXT=',E13.5,'(M.)',/,
     <  ' EPSY=',E13.5,'(M-RAD)',2X,'SIGY=',E13.5,'(M.)',5X,
     <'SIGYT=',E13.5,'(M.)',/)
      IF(NLUM.EQ.2) CALL LUMIN
      ENERGY = ENERGY+DELTAE
      IF(ENERGY.LE.ENDE) GO TO 733
      RETURN
      END

      SUBROUTINE MISCHK
C     *****************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      COMMON/LNGTH/TLENG,ALENG(MXELMD),ACLENG(MAXPOS)
      PARAMETER  (mxmis = 1000)
      COMMON/MIS/RMISA(8,MXMIS),MISELE(MXMIS),NMIS,NOPT,
     >NMISE,MISSEL(MXMIS),NMRNGE(MXMIS),
     >MSRNGE(2,10,MXMIS),MISFLG,MCHFLG
      COMMON/CSEEDS/ISEED,IXG,IXS,IXMSTP,IMSD,IMOSTP,ISYNSD,ISYSTP,
     >ISDBEG,IBGSTP,IXES,IXESTP,IESBEG,IESTBG,isdcol
      COMMON/MISSET/DX1,DX2,DXP1,DXP2,DY1,DY2,DYP1,DYP2,
     >DZ1,DZ2,DZC1,DZS1,DZC2,DZS2,DDEL,I,IEP,MNEL
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      PARAMETER    (MXMTR = 5000)
      COMMON/MISTRK/AKMIS(15,MXMTR),KMPOS(MXMTR),IMEXP,NMTOT,MISPTR
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      IF(IMEXP.EQ.1) GOTO 6
      DO 1 IEL=1,NMISE
      IF(MNEL.EQ.MISELE(MISSEL(IEL)))GOTO 2
    1 CONTINUE
      IF(IMEXP.EQ.2)GOTO 6
      RETURN
    2 NMR=NMRNGE(IEL)
      IF(NMR.EQ.0) GOTO 4
      IF(NMR.EQ.-1) THEN
       IF(IMEXP.EQ.2)GOTO 6
       RETURN
      ENDIF
      DO 3 IMR=1,NMR
      IF((IEP.GE.MSRNGE(1,IMR,IEL)).AND.
     >(IEP.LE.MSRNGE(2,IMR,IEL)))GOTO4
    3 CONTINUE
      IF(IMEXP.EQ.2)GOTO 6
      RETURN
    4 ALPHA=0.0D0
      IAD=IADR(MNEL)
      IADN=IADR(MNEL+1)
      TILTAN=0.0D0
      ITLTST=0
      KD=KODE(MNEL)
      IF(KD.EQ.1)THEN
      ALPHA = ELDAT(IAD+1)
      TILTAN = ELDAT(IADN-1)
      IF(KUNITS.EQ.2) ALPHA = ALPHA*CRDEG
      IF(KUNITS.EQ.2) TILTAN = TILTAN*CRDEG
      ENDIF
      IF(DABS(TILTAN-(PI/2.0D0)).LT.1.0D-03)ITLTST=1
C      WRITE(IOUT,88888)KD,IAD,ALPHA
C88888 FORMAT(//,'  ',2I4,E14.7)
      ALMNEL=ALENG(MNEL)
      HLMNEL=ALMNEL*0.5D0
      QLMNEL=0.25D0*ALMNEL
      NCEL=MISSEL(IEL)
      IMOPT=RMISA(8,NCEL)
      IF(NOPT.EQ.0)GOTO 100
      IF((NOPT.LT.0).OR.(NOPT.GT.4))GOTO 5
      SIG=2.0D0
      IOPT=NOPT
      IF(NOPT.EQ.4)SIG=6.0D0
      IF(NOPT.EQ.4)IOPT=3
      GOTO 200
    5 WRITE(IOUT,99999)
99999 FORMAT(/,'    ERROR IN OPTION NUMBER')
      CALL HALT(275)
  100 DM1=RMISA(1,NCEL)
      DM2=RMISA(2,NCEL)
      DM3=RMISA(3,NCEL)
      DM4=RMISA(4,NCEL)
      DZ=RMISA(5,NCEL)
      DZR=RMISA(6,NCEL)
      DDEL=RMISA(7,NCEL)
      GOTO 10
  200 DM1=RANNUM(IXS,IOPT,SIG,IXMSTP)*RMISA(1,NCEL)
      DM2=RANNUM(IXS,IOPT,SIG,IXMSTP)*RMISA(2,NCEL)
      DM3=RANNUM(IXS,IOPT,SIG,IXMSTP)*RMISA(3,NCEL)
      DM4=RANNUM(IXS,IOPT,SIG,IXMSTP)*RMISA(4,NCEL)
      DZ=RANNUM(IXS,IOPT,SIG,IXMSTP)*RMISA(5,NCEL)
      DZR=RANNUM(IXS,IOPT,SIG,IXMSTP)*RMISA(6,NCEL)
      DDEL=RANNUM(IXS,IOPT,SIG,IXMSTP)*RMISA(7,NCEL)
   10 CONTINUE
      DXC=0.0D0
      DYC=0.0D0
      DXPC=0.0D0
      DYPC=0.0D0
      IF(KD.NE.1)GOTO 1200
      IF(ITLTST.NE.0)GOTO 1100
      GOTO(1110,1120,1130),IMOPT
      WRITE(IOUT,11100)IMOPT
11100 FORMAT(//,'  ERROR IN THE MISALIGNMENT OPTION NUMBER :',I6)
      CALL HALT(276)
 1110 DC=2.0D0*ALMNEL*(DSIN(ALPHA/2.0D0)**2)/ALPHA
      DYC=DC*DSIN(DZR)
      DXC=2.0D0*DC*(DSIN(DZR/2.0D0)**2)
      DYPC=DYC/HLMNEL
      DXPC=DXC/ALMNEL
      GOTO 1200
 1120 DC=2.0D0*ALMNEL*(DSIN(ALPHA/4.0D0)**2)/ALPHA
      DXC=0.0D0
      DYC=0.0D0
      DXPC=2.0D0*DC*(DSIN(DZR/2.0D0)**2)/HLMNEL
      DYPC=DC*DSIN(DZR)/QLMNEL
      GOTO 1200
 1130 DC=2.0D0*ALMNEL*(DSIN(ALPHA/4.0D0)**2)/ALPHA
      DXC=2.0D0*DC*(DSIN(DZR/2.0D0)**2)
      DYC=DC*DSIN(DZR)
      DXPC=DXC/HLMNEL
      DYPC=DYC/QLMNEL
      GOTO 1200
 1100 GOTO(1210,1220,1230),IMOPT
      WRITE(IOUT,11100)IMOPT
      CALL HALT(276)
 1210 DC=2.0D0*ALMNEL*(DSIN(ALPHA/2.0D0)**2)/ALPHA
      DXC=DC*DSIN(DZR)
      DYC=2.0D0*DC*(DSIN(DZR/2.0D0)**2)
      DYPC=DYC/HLMNEL
      DXPC=DXC/ALMNEL
      GOTO 1200
 1220 DC=2.0D0*ALMNEL*(DSIN(ALPHA/4.0D0)**2)/ALPHA
      DXC=0.0D0
      DYC=0.0D0
      DYPC=2.0D0*DC*(DSIN(DZR/2.0D0)**2)/QLMNEL
      DXPC=DC*DSIN(DZR)/HLMNEL
      GOTO 1200
 1230 DC=2.0D0*ALMNEL*(DSIN(ALPHA/4.0D0)**2)/ALPHA
      DYC=2.0D0*DC*(DSIN(DZR/2.0D0)**2)
      DXC=DC*DSIN(DZR)
      DXPC=DXC/HLMNEL
      DYPC=DYC/QLMNEL
      GOTO 1200
 1200 GOTO(1310,1320,1330,1340),IMOPT
      WRITE(IOUT,11100)IMOPT
      CALL HALT(276)
 1310 DX1=DM1
      DY1=DM3
      DZ1=DZ
      DZR1=DZR
      DXP1=DM4
      DYP1=DM2
      DX2=-DM1-ALMNEL*DM4-DXC
      DY2=-DM3-ALMNEL*DM2-DYC
      DZ2=-DZ
      DZR2=-DZR
      DXP2=-DM4-DXPC
      DYP2=-DM2-DYPC
      GOTO 12
 1320 DX1=DM1
      DY1=DM3
      DZ1=DZ
      DZR1=DZR
      DXP1=(DM2-DM1)/ALMNEL-DXPC
      DYP1=(DM4-DM3)/ALMNEL-DYPC
      DX2=-DM2
      DY2=-DM4
      DZ2=-DZ
      DZR2=-DZR
      DXP2=-(DM2-DM1)/ALMNEL-DXPC
      DYP2=-(DM4-DM3)/ALMNEL-DYPC
      GO TO 12
 1330 DX1=DM1-HLMNEL*DM4+DXC
      DY1=DM3-HLMNEL*DM2+DYC
      DZ1=DZ
      DZR1=DZR
      DXP1=DM4-DXPC
      DYP1=DM2-DYPC
      DX2=-DM1-HLMNEL*DM4-DXC
      DY2=-DM3-HLMNEL*DM2-DYC
      DZ2=-DZ
      DZR2=-DZR
      DXP2=-DM4-DXPC
      DYP2=-DM2-DYPC
      GO TO 12
 1340 DX1=DM1
      DY1=DM3
      DZ1=DZ
      DZR1=DZR
      DXP1=DM4/2.0D0
      DYP1=DM2/2.0D0
      DX2=-DM1
      DY2=-DM3
      DZ2=-DZ
      DZR2=-DZR
      DXP2=DXP1
      DYP2=DYP1
   12 MCHFLG=1
      DZC1=DCOS(DZR1)
      DZS1=DSIN(DZR1)
      DZC2=DCOS(DZR2)
      DZS2=DSIN(DZR2)
      IF(IMEXP.NE.2)then
       RETURN
      endif
   6  IF(MISPTR.GT.NMTOT)then
       RETURN
      endif
      IF(KMPOS(MISPTR).LT.IEP) THEN
           MISPTR=MISPTR+1
           GOTO 6
      ENDIF
      IF(KMPOS(MISPTR).GT.IEP)then
       RETURN
      endif
C    6 DO 61 IM=1,NMTOT
C      IF(KMPOS(IM).EQ.IEP)GOTO 62
C   61 CONTINUE
C      WRITE(IOUT,99601)IEP
C99601 FORMAT(' NO MISALIGNMENT FOUND FOR ELEMENT ',I5,/,
C     >' THIS IS A BASIC PROGRAMMING ERROR PLEASE REPORT IT ',/,
C     >' THE PROGRAM SHOULD WORK WITHOUT THE USE OF NRNG NEGATIVE ',
C     >' IN SHO MISASLIGNMENT OPERATION ',/)
C      CALL HALT(277)
   62 IF(IMEXP.EQ.1) THEN
        DX1=AKMIS(1,MISPTR)
        DXP1=AKMIS(2,MISPTR)
        DY1=AKMIS(3,MISPTR)
        DYP1=AKMIS(4,MISPTR)
        DZ1=AKMIS(5,MISPTR)
        DZC1=AKMIS(6,MISPTR)
        DZS1=AKMIS(7,MISPTR)
        DX2=AKMIS(8,MISPTR)
        DXP2=AKMIS(9,MISPTR)
        DY2=AKMIS(10,MISPTR)
        DYP2=AKMIS(11,MISPTR)
        DZ2=AKMIS(12,MISPTR)
        DZC2=AKMIS(13,MISPTR)
        DZS2=AKMIS(14,MISPTR)
        DDEL=AKMIS(15,MISPTR)
      ENDIF
      IF(IMEXP.EQ.2) THEN
        DX1=DX1+AKMIS(1,MISPTR)
        DXP1=DXP1+AKMIS(2,MISPTR)
        DY1=DY1+AKMIS(3,MISPTR)
        DYP1=DYP1+AKMIS(4,MISPTR)
        DZ1=DZ1+AKMIS(5,MISPTR)
        C1=DZC1
        S1=DZS1
        C2=AKMIS(6,MISPTR)
        S2=AKMIS(7,MISPTR)
        DZC1=C1*C2-S1*S2
        DZS1=S1*C2+C1*S2
        DX2=DX2+AKMIS(8,MISPTR)
        DXP2=DXP2+AKMIS(9,MISPTR)
        DY2=DY2+AKMIS(10,MISPTR)
        DYP2=DYP2+AKMIS(11,MISPTR)
        DZ2=DZ2+AKMIS(12,MISPTR)
        C1=DZC2
        S1=DZS2
        C2=AKMIS(13,MISPTR)
        S2=AKMIS(14,MISPTR)
        DZC2=C1*C2-S1*S2
        DZS2=S1*C2+C1*S2
        DDEL=DDEL+AKMIS(15,MISPTR)
      ENDIF
      MCHFLG=1
      RETURN
      END
C     ***********************
      SUBROUTINE MISDAT(IEND)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER  (mxmis = 1000)
      COMMON/MIS/RMISA(8,MXMIS),MISELE(MXMIS),NMIS,NOPT,
     >NMISE,MISSEL(MXMIS),NMRNGE(MXMIS),
     >MSRNGE(2,10,MXMIS),MISFLG,MCHFLG
      COMMON/CSEEDS/ISEED,IXG,IXS,IXMSTP,IMSD,IMOSTP,ISYNSD,ISYSTP,
     >ISDBEG,IBGSTP,IXES,IXESTP,IESBEG,IESTBG,isdcol
      PARAMETER    (MXMTR = 5000)
      COMMON/MISTRK/AKMIS(15,MXMTR),KMPOS(MXMTR),IMEXP,NMTOT,MISPTR
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
      CHARACTER*1 NINE
      DATA NINE/'9'/
      NPRINT=1
      IEND=0
      NMIS=0
    2 NCHAR=8
      NDATA=0
      NDIM=mxinp
      CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NPRINT)
      IF((ICHAR(1).EQ.NINE).AND.(ICHAR(2).EQ.NINE))GOTO 99
      CALL ELID(ICHAR,NELID)
      NMIS=NMIS+1
      IF(NMIS.GT.MXMIS) THEN
          WRITE(IOUT,100)MXMIS
          NMIS=NMIS-1
          GOTO 99
      ENDIF
  100 FORMAT(/,'  ******************************************** ',/,
     >' TOO MANY MISALIGNED ELEMENTS FIRST',I4,' ONLY KEPT',/,
     >' CHANGE PARAMETER MXMIS ',/,
     >'  ************************************************* ',/)
      MISELE(NMIS)=NELID
      NCHAR=0
      NDATA=8
      CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NPRINT)
      DO 1 ID=1,NDATA
    1 RMISA(ID,NMIS)=DATA(ID)
      GOTO 2
   99 CONTINUE
      WRITE(IOUT,10002)NMIS,MXMIS
10002 FORMAT(/,' TOTAL NUMBER OF MISALIGNED ELEMENTS :',I5,/,
     >' MAXIMUM ALLOWED IS PARAMETER MXMIS :',I5,/)
      RETURN
      END
C     ***********************
      subroutine modpre(iend)
C     ***********************
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
      PARAMETER    (MXELMD = 3000)
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
C
C     GET THE NUMBER OF VARIES TO BE DONE
C
      NOP=1
      NCHAR=0
      NIPR=1
      CALL INPUT(ICHAR,NCHAR,DATA,MXINP,IEND,NOP,NIPR)
      NV = DATA(1)
C
C     VARY 'NV' PARAMETERS
C
      DO 4003 IVM=1,NV
C
C     GET THE ELEMENT NAME AND TWO PARAMETERS
C
      NOP=0
      NCHAR=8
      NIPR=1
      CALL INPUT(ICHAR,NCHAR,DATA,MXINP,IEND,NOP,NIPR)
C
C     MATCH THE NAME
C
      DO 4002 J=1,NA
      DO 4001 K=1,8
      IF (ICHAR(K).NE.NAME(K,J)) GO TO 4002
4001  CONTINUE
C
C     FOUND EQUAL NAMES
C
      NOP=1
      NCHAR=8
      NIPR=1
      CALL INPUT(ICHAR,NCHAR,DATA,MXINP,IEND,NOP,NIPR)
      CALL DIMPAR(J, ICHAR, IDICT)
      NVPAR = IDICT
      VARVAL = DATA(1)
      CALL VARY (J,NVPAR,VARVAL,0)
      GO TO 4003
4002  CONTINUE
C
C     ERROR COULDN'T FIND THIS ELEMENT
C
      WRITE(IOUT,4010) (ICHAR(K),K=1,4)
      IF(ISO.NE.0)WRITE(ISOUT,4010) (ICHAR(K),K=1,4)
4010  FORMAT(/,' COULDNT MATCH ELEMENT',2X,4A1,' IN OPERATION 400'/)
4003  CONTINUE
      return
      end
C     ***********************
      SUBROUTINE MONCHK(IE)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      PARAMETER  (mxlcnd = 200)
      PARAMETER  (mxlvar = 100)
      COMMON/MONIT/VALMON(MXLCND,4,3)
      COMMON/MONFIT/VALFA(MXLCND),WGHTA(MXLCND),ERRA(MXLCND),
     >AMULTA(MXLVAR,6),ADDA(MXLVAR,6),DELA(MXLVAR)
     >,NPARA(MXLVAR,6),NELFA(MXLVAR,6),
     >NPVARA(MXLVAR),INDA(MXLVAR,6),VALR(MXLCND),RMOSIG,
     >NMONA(MXLCND),NVALA(MXLCND),NVARA,NCONDA
     >,IALFLG,MONFLG,MONLST,NOPTER,
     >IAFRST,IMOOPT,IMSBEG,NALPRT
      COMMON/CSEEDS/ISEED,IXG,IXS,IXMSTP,IMSD,IMOSTP,ISYNSD,ISYSTP,
     >ISDBEG,IBGSTP,IXES,IXESTP,IESBEG,IESTBG,isdcol
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      MONFLG=0
      DO 1 IM=1,NCONDA
      IF(IE.EQ.NMONA(IM))GOTO 2
    1 CONTINUE
      RETURN
    2 MONFLG=1
      IF(NMONA(IM).EQ.MONLST)MONFLG=2
C     WRITE(6,10)MONFLG,IM,NMONA(IM),MONLST
   10 FORMAT('  IN MONCHK',4I6)
      RETURN
      END
C     ***********************
      SUBROUTINE MOVMT
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      COMMON /MVT/ U(5,4)
      COMMON/CLSQ/ALSQ(15,2,4),IXY,NCOEF,NAPLT,JENER,LENER(15)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/TRI/WCO(15,6),GEN(5,4),PGEN(75,6),DIST,
     <A1(15),B1(15),A2(15),B2(15),XCOR(3,15),XPCOR(3,15),
     1AL1(15),AL2(15),MESH,NIT,NENER,NITX,NITS,NITM1,NANAL,NOPRT
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      COMMON /CTUNE/DNU0X,DNU0Y,DBETX,DBETY,DALPHX,DALPHY,
     >DXCO,DXPCO,DYCO,DYPCO,DDELCO
      LOGICAL  LENER
      C1=(U(2,1)+U(3,2))/2.0D0
      IF(NOUT.GE.3)
     >WRITE (IOUT,1) C1
    1 FORMAT('-','THE COS(MU) IS ', E20.10)
      IF(DABS(C1).GT.1.0D0) GO TO 4
      IF(C1.EQ.1.0D0) GO TO 8
      S=DSQRT(1.0D0-C1*C1)
      S=DSIGN(S,U(3,1))
      AM1=DATAN2(S,C1)
      IF(AM1.LT.0.0D0) AM1=TWOPI+AM1
      B=U(3,1)/S
      A=(U(3,2)-U(2,1))/(2.0D0*S)
      A=-A
      AN1=AM1/TWOPI
      IF(JENER.EQ.1) THEN
       IF(IXY.EQ.1) DNU0X=AN1
       IF(IXY.EQ.2) DNU0Y=AN1
      ENDIF
      IF(NOUT.GE.1)
     >WRITE(IOUT,10) AM1,AN1
   10 FORMAT('-', 3X, 'MU = ', E17.10, 3X, 'NU = ',E17.10)
      IF(NOUT.GE.1)
     >WRITE(IOUT,20) A,B
   20 FORMAT('-',3X, 'A = ', E17.10, 3X, 'B = ', E17.10)
      ALSQ(JENER,IXY,1)=AN1
      ALSQ(JENER,IXY,2)=B
      IF(JENER.EQ.1) THEN
       IF(IXY.EQ.1) THEN
        DBETX=B
        DALPHX=A
       ENDIF
       IF(IXY.EQ.2) THEN
        DBETY=B
        DALPHY=A
       ENDIF
      ENDIF
      RETURN
    4 IF(NOUT.GE.1)
     >WRITE (IOUT,30)
   30 FORMAT('-', 3X, 'MOVEMENT IS UNSTABLE.')
      RAL1=C1+DSQRT(C1*C1-1.0D0)
      RAL2=C1-DSQRT(C1*C1-1.0D0)
      A12=U(3,1)
      A11=U(2,1)
      VP1=A11-RAL1
      DENOM=DSQRT(A12*A12+VP1*VP1)
      V1=-A12/DENOM
      VP1=VP1/DENOM
      VP2=A11-RAL2
      DENOM=DSQRT(A12*A12+VP2*VP2)
      V2=-A12/DENOM
      VP2=VP2/DENOM
      IF(NOUT.GE.1)
     >WRITE(IOUT,10003)C1,RAL1,V1,VP1,RAL2,V2,VP2
10003 FORMAT(/,20X,'  HALF-TRACE =   ',E21.14,/,
     >3X,' EIGENVALUE1 =  ',E21.14,/,5X,'  WITH EIGENVECTOR : ',/,
     >10X,'  X =  ',E21.14,5X,'  XP =  ',E21.14,/,
     >3X,' EIGENVALUE2 =  ',E21.14,/,5X,'  WITH EIGENVECTOR : ',/,
     >10X,'  X =  ',E21.14,5X,'  XP =  ',E21.14,/)
      LENER(JENER)=.FALSE.
      IF(RAL2.GT.1.0D0)GO TO 100
      AL1(JENER)=RAL1
      AL2(JENER)=RAL2
      A1(JENER)=V1
      B1(JENER)=VP1
      A2(JENER)=V2
      B2(JENER)=VP2
      RETURN
  100 A1(JENER)=V2
      B1(JENER)=VP2
      A2(JENER)=V1
      B2(JENER)=VP1
      AL1(JENER)=RAL2
      AL2(JENER)=RAL1
      RETURN
    8 IF (U(3,1).NE.0.0D0) GO TO 4
      IF (U(2,2).NE.0.0D0) GO TO 4
      WRITE (IOUT,40)
   40 FORMAT('-', 3X, 'TRANSFER MATRIX IS THE IDENTITY.')
      RETURN
      END
      SUBROUTINE MRESET
C     *****************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/MISSET/DX1,DX2,DXP1,DXP2,DY1,DY2,DYP1,DYP2,
     >DZ1,DZ2,DZC1,DZS1,DZC2,DZS2,DDEL,I,IEP,MNEL
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      PARAMETER     (MAXCOR = 600)
      COMMON/CORR/CORVAL(MAXCOR,4),ICRID(MAXCOR),
     >ICRPOS(MAXCOR),ICRSET(MAXCOR),
     >ICROPT(MAXCOR),NCORR,NCURCR,ICRFLG,ICRCHK,ALMNEL,ICRPTR,NPARC
       COMMON/V/AL,ALO2,VV(27),X1,X2,X3,X4,X5,X6,Y1,Y2,Y3,Y4,Y5,Y6
      DATA MSIGN /-1/
      YS=Y1*DZC2+Y3*DZS2*MSIGN
      Y3 =-Y1*DZS2*MSIGN+Y3*DZC2
      Y1=YS
      Y2S=Y2*DZC2+Y4*DZS2*MSIGN
      Y4=-Y2*DZS2*MSIGN+Y4*DZC2
      Y2=Y2S
      Y1=Y1+Y2*DZ2*MSIGN
      Y3=Y3+Y4*DZ2*MSIGN
      Y3=Y3+DY2*MSIGN
      Y4=Y4+DYP2*MSIGN
      Y1=Y1+DX2*MSIGN
      Y2=Y2+DXP2*MSIGN
      Y6=Y6-DDEL*MSIGN
      RETURN
      END
      SUBROUTINE MSET
C     ***************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      PARAMETER    (mxpart = 128000)
      COMMON/MISSET/DX1,DX2,DXP1,DXP2,DY1,DY2,DYP1,DYP2,
     >DZ1,DZ2,DZC1,DZS1,DZC2,DZS2,DDEL,I,IEP,MNEL
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      PARAMETER     (MAXCOR = 600)
      COMMON/CORR/CORVAL(MAXCOR,4),ICRID(MAXCOR),
     >ICRPOS(MAXCOR),ICRSET(MAXCOR),
     >ICROPT(MAXCOR),NCORR,NCURCR,ICRFLG,ICRCHK,ALMNEL,ICRPTR,NPARC
       COMMON/V/AL,ALO2,VV(27),X1,X2,X3,X4,X5,X6,Y1,Y2,Y3,Y4,Y5,Y6
      DATA MSIGN /-1/
      X1=X1+DX1*MSIGN
      X2=X2+DXP1*MSIGN
      X3=X3+DY1*MSIGN
      X4=X4+DYP1*MSIGN
      X6=X6+DDEL*MSIGN
      X1=X1+X2*DZ1*MSIGN
      X3=X3+X4*DZ1*MSIGN
      XS=X1*DZC1+X3*DZS1*MSIGN
      X3 =-X1*DZS1*MSIGN+X3*DZC1
      X1=XS
      X2S=X2*DZC1+X4*DZS1*MSIGN
      X4=-X2*DZS1*MSIGN+X4*DZC1
      X2=X2S
      RETURN
      END
      SUBROUTINE MULTIM(IELM,MATADR)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      dimension savmat(6,27)
      IAD=IADR(IELM)
      ELENG=ELDAT(IAD)*0.5d0
CC  set unit matrix in amat
        do 110 i=1,6
        do 110 j=1,27
          if(i.eq.j)  then
            amat(j,i,matadr)=1.0d0
                      else
            amat(j,i,matadr)=0.0d0
          endif
  110   continue
c        write(iout,*)' half magnet matrix '
      FACT1=1.0D06
      FACT2=1.0D-06
      NQ=0
      AKQ=0.0D0
      NS=0
      AKS=0.0D0
      SF=ELDAT(IAD+1)
      NP=ELDAT(IAD+2)
      DO 1 IM=1,NP
      NI=ELDAT(IAD+3+(IM-1)*3)
      IF(NI.eq.2) then
        NQ=1
        AKQ=ELDAT(IAD+4+(IM-1)*3)*SF
        TILTQ=ELDAT(IAD+5+(IM-1)*3)
        IF(KUNITS.EQ.1) THEN
          AKQ = -AKQ
          TILTQ = -TILTQ
        ENDIF
      endif
      IF(NI.eq.3)  then
        NS=1
        AKS=ELDAT(IAD+4+(IM-1)*3)*SF
        TILTS=ELDAT(IAD+5+(IM-1)*3)
        IF(KUNITS.EQ.1) THEN
          AKS = -AKS/2.
          TILTS = -TILTS
        ENDIF
        IF(KUNITS.EQ.0) AKS = AKS/2.
      endif
    1 CONTINUE
        if(kunits.eq.2) then
          tiltq=tiltq*crdeg
          tilts=tilts*crdeg
        endif
      heleng=eleng*0.5d0
      if((nq.eq.1).and.(ns.eq.1)) then
        IF(ELENG.EQ.0.0D0) then
          ELENG=FACT2*0.5d0
          akq=akq*fact1
          elengs=fact2*0.5d0
          aks=aks*fact1
                           else
          elengs=fact2*0.5d0
          aks=aks*eleng*fact1
        endif
        call hexa2m(elengs,aks,matadr)
        call tiltmm(ielm,matadr,tilts)
CC transfer amat to savmat
        do 100 i=1,6
        do 100 j=1,27
  100   savmat(i,j)=amat(j,i,matadr)
        call flen2m(eleng,akq,matadr)
        call tiltmm(ielm,matadr,tiltq)
C  put savmat to temp
        do 101 i=1,6
        do 101 j=1,27
  101   temp(i,j)=savmat(i,j)
        call promat(ielm,matadr)
C  put temp to savmat
        do 102 i=1,6
        do 102 j=1,27
  102   savmat(i,j)=temp(i,j)
        call hexa2m(elengs,aks,matadr)
        call tiltmm(ielm,matadr,tilts)
C  put savmat to temp
        do 103 i=1,6
        do 103 j=1,27
  103   temp(i,j)=savmat(i,j)
        call promat(ielm,matadr)
CC  transfer temp to amat
        do 104 i=1,6
        do 104 j=1,27
  104   amat(j,i,matadr)=temp(i,j)
      endif
      if((nq.eq.1).and.(ns.eq.0)) then
        IF(ELENG.EQ.0.0D0) then
          ELENG=FACT2*0.5d0
          akq=akq*fact1
        endif
        call flen2m(eleng,akq,matadr)
        call tiltmm(ielm,matadr,tiltq)
      endif
      if((nq.eq.0).and.(ns.eq.1)) then
        IF(ELENG.EQ.0.0D0) then
          ELENG=FACT2*0.5d0
          aks=aks*fact1
        endif
        call hexa2m(eleng,aks,matadr)
        call tiltmm(ielm,matadr,tilts)
      endif
      RETURN
      END
      SUBROUTINE MULTIT(NEL)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/MULT/HMLENG,SF,COSM,SINM,AN(20),BN(20),
     >FR(0:20),FI(0:20),NP,Nm(20),MAXORD
      IAD=IADR(NEL)
      IADN=IADR(NEL+1)
      HMLENG=ELDAT(IAD)*0.5D0
      IF(KUNITS.EQ.2) TILTMA=ELDAT(IADN-1)*CRDEG
      IF(KUNITS.EQ.1) TILTMA = -ELDAT(IADN-1)
      IF(KUNITS.EQ.0) TILTMA = ELDAT(IADN-1)
      COSM=DCOS(TILTMA)
      SINM=DSIN(TILTMA)
      SF=ELDAT(IAD+1)
      NP=ELDAT(IAD+2)
      DO 1 IM=1,NP
      Nm(IM)=ELDAT(IAD+3+(IM-1)*3)
      IF(KUNITS.EQ.2) AN(IM)=ELDAT(IAD+4+(IM-1)*3)
      IF(KUNITS.EQ.1) AN(IM) = (-1)**(Nm(IM)-1)*
     >                         ELDAT(IAD+4+(IM-1)*3)/BANG(Nm(IM)-1)
      IF(KUNITS.EQ.0) AN(IM) = ELDAT(IAD+4+(IM-1)*3)/BANG(Nm(IM)-1)
      BN(IM)=ELDAT(IAD+5+(IM-1)*3)
      IF(KUNITS.EQ.1) BN(IM) = -BN(IM)
      IF(KUNITS.EQ.2) BN(IM) = BN(IM)*CRDEG
      IF(HMLENG.NE.0.0D0)AN(IM)=AN(IM)*2.0D0*HMLENG
    1 CONTINUE
C--   MAD CODE BEGINS HERE
C-- REQUIRES THAT POLES ARE STORED IN INCREASING ORDER
      FR(0) = 0.0
      FI(0) = 0.0
      MAXORD = 0
      DO 2 IM=1,NP
        IORD = Nm(IM)-1
        VAL = AN(IM)
        IF(((IORD.EQ.1).OR.(IORD.EQ.2)).AND.(HMLENG.NE.0.0D0))VAL=0.0D0
        ANG = BN(IM)*FLOAT(IORD+1)
        FR(IORD) = VAL*COS(ANG)
        FI(IORD) = -VAL*SIN(ANG)
        IF(VAL.NE.0.0) MAXORD = IORD
 2    CONTINUE
      RETURN
      END
      SUBROUTINE MULTTR(X1,X2,X3,X4,X5,X6,Y1,Y2,Y3,Y4,Y5,Y6)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      PARAMETER    (MXELMD = 3000)
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/MULT/HMLENG,SF,COSM,SINM,AN(20),BN(20),
     >FR(0:20),FI(0:20),NP,Nm(20),MAXORD
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      IF(DABS(SINM).GT.1.0D-12) THEN
        Y1=X1*COSM+X3*SINM
        Y3=-X1*SINM+X3*COSM
        Y2=X2*COSM+X4*SINM
        Y4=-X2*SINM+X4*COSM
                                 ELSE
        Y1=X1
        Y2=X2
        Y3=X3
        Y4=X4
      ENDIF
      Y5=X5
      Y6=X6
      EFACT=1.0D0/(1.0D0+Y6)
C--   MAD CODE BEGINS HERE
C-- REQUIRES THAT POLES ARE STORED IN INCREASING ORDER
      IF (MAXORD.GT.0) THEN
        DR = 0.0
        DI = 0.0
        DO 3 IORD = MAXORD,0,-1
          DRT = (DR*Y1 - DI*Y3) + FR(IORD)
          DI =  (DR*Y3 + DI*Y1) + FI(IORD)
          DR = DRT
 3      CONTINUE
        DR = DR*SF
        DI = DI*SF
        Y2 = Y2 - DR*EFACT
        Y4 = Y4 + DI*EFACT
      ENDIF
C-- OLD DIMAT CODE RESUMES HERE
      IF(DABS(SINM).GT.1.0D-12) THEN
        SY1=Y1*COSM-Y3*SINM
        Y3= Y1*SINM+Y3*COSM
        Y1=SY1
        SY2=Y2*COSM-Y4*SINM
        Y4= Y2*SINM+Y4*COSM
        Y2=SY2
      ENDIF
      RETURN
      END

      SUBROUTINE NCVAR(ZC,ZNC,GAMMA,BETA)
C
C***********************************************************************
C
C
C  NEW VERSION TO CONVERT (X,PX,Y,PY,-T,E) TO (X,X',Y,Y',L,DEL)
C     ( ZC(5) IS DEFINED TO BE MINUS THE PATH LENGTH DEVIATION AND
C       ZC(6) IS THE ENERGY DEVIATION DIVIDED BY P0*C)
C                                                        (4/22/85)
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      DIMENSION ZC(6),ZNC(6)
      data nmes/0/
      ZNC(1)= ZC(1)
      ZNC(3)= ZC(3)
      ZNC(5)=-ZC(5)
      ARG= (ZC(6)+(1.D0/BETA))**2-ZC(2)**2-ZC(4)**2
     &    -((1.D0-BETA**2)/(BETA**2))
      if(arg.lt.0.0d0) then
        if(nmes.lt.2) then
          write(iout,10001)
10001 format(/,' ********************************************',/,
     >' Excessive transverse momentum produced a negative argument',/,
     >' for the canonical variable transformation.',/,
     >' Check your results ',/,
     >' *********************************************',/)
          if(iso.ne.0)write(isout,10001)
          nmes=nmes+1
        endif
        arg=dabs(arg)
      endif
      FAC=1.D0/DSQRT(ARG)
      ZNC(2)=FAC*ZC(2)
      ZNC(4)=FAC*ZC(4)
      ZNC(6)=-1.D0+DSQRT(1.D0+ZC(6)**2+(2.D0*ZC(6)/BETA))
      RETURN
      END
      SUBROUTINE NEWLFT(IOLD,INEW)
C---- INSERT NEW CELL "INEW" TO THE LEFT OF CELL "IOLD"
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
C-----------------------------------------------------------------------
C---- LINK TABLE
      PARAMETER         (MAXLST = 14000)
      COMMON /LPDATA/   IUSED,ILDAT(MAXLST,6)
C-----------------------------------------------------------------------
C---- RESERVE A "CALL" CELL
      IPRE = ILDAT(IOLD,2)
      ISUC = IOLD
      IF (IUSED .GE. MAXLST) CALL OVFLOW(3,MAXLST)
      IUSED = IUSED + 1
      INEW = IUSED
      ILDAT(INEW,1) = 2
C---- SET LINKS
      ILDAT(IPRE,3) = INEW
      ILDAT(INEW,2) = IPRE
      ILDAT(INEW,3) = ISUC
      ILDAT(ISUC,2) = INEW
C---- CLEAR REMAINING CELL WORDS
      ILDAT(INEW,4) = 0
      ILDAT(INEW,5) = 0
      ILDAT(INEW,6) = 0
      RETURN
C-----------------------------------------------------------------------
      END
      SUBROUTINE NEWLST(IHEAD)
C---- GENERATE A NEW EMPTY LIST
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
C-----------------------------------------------------------------------
C---- LINK TABLE
      PARAMETER         (MAXLST = 14000)
      COMMON /LPDATA/   IUSED,ILDAT(MAXLST,6)
C-----------------------------------------------------------------------
C---- RESERVE A "HEAD" CELL
      IF (IUSED .GE. MAXLST) CALL OVFLOW(3,MAXLST)
      IUSED = IUSED + 1
      IHEAD = IUSED
      ILDAT(IHEAD,1) = 1
C---- STORE LINKS FOR EMPTY LIST
      ILDAT(IHEAD,2) = IHEAD
      ILDAT(IHEAD,3) = IHEAD
C---- CLEAR REMAINING CELL WORDS
      ILDAT(IHEAD,4) = 0
      ILDAT(IHEAD,5) = 0
      ILDAT(IHEAD,6) = 0
      RETURN
C-----------------------------------------------------------------------
      END
      SUBROUTINE NEWRGT(IOLD,INEW)
C---- INSERT NEW CELL "INEW" TO THE RIGHT OF CELL "IOLD"
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
C-----------------------------------------------------------------------
C---- LINK TABLE
      PARAMETER         (MAXLST = 14000)
      COMMON /LPDATA/   IUSED,ILDAT(MAXLST,6)
C-----------------------------------------------------------------------
C---- RESERVE A "CALL" CELL
      IPRE = IOLD
      ISUC = ILDAT(IOLD,3)
      IF (IUSED .GE. MAXLST) CALL OVFLOW(3,MAXLST)
      IUSED = IUSED + 1
      INEW = IUSED
      ILDAT(INEW,1) = 2
C---- SET LINKS
      ILDAT(IPRE,3) = INEW
      ILDAT(INEW,2) = IPRE
      ILDAT(INEW,3) = ISUC
      ILDAT(ISUC,2) = INEW
C---- CLEAR REMAINING CELL WORDS
      ILDAT(INEW,4) = 0
      ILDAT(INEW,5) = 0
      ILDAT(INEW,6) = 0
      RETURN
C-----------------------------------------------------------------------
      END
      SUBROUTINE OPDEF(ILCOM)
C---- CONSTRUCT OPERATION ON PARAMETERS
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
C-----------------------------------------------------------------------
C---- PARAMETER TABLE
      PARAMETER         (MAXPAR = 19000)
      COMMON /PARNAM/   KPARM(MAXPAR)
      CHARACTER*8       KPARM
      COMMON /PARDAT/   IPARM1,IPARM2,IPTYP(MAXPAR),IPDAT(MAXPAR,2),
     +                  IPLIN(MAXPAR)
      COMMON /PARVAL/   PDATA(MAXPAR)
C---- STACK FOR EXPRESSION ENCODING AND DECODING
      COMMON /STACK/    LEV,IOP(50),IVAL(50)
C-----------------------------------------------------------------------
C---- ALLOCATE AN UPPER PARAMETER CELL
      IPARM = IPARM2 - 1
      IF (IPARM1 .GE. IPARM) CALL OVFLOW(2,MAXPAR)
      IPARM2 = IPARM
C---- FILL IN OPERATION DATA
      IPTYP(IPARM) = IOP(LEV)
      IF (IOP(LEV) .LE. 10) THEN
        IPDAT(IPARM,1) = IVAL(LEV-1)
      ELSE
        IPDAT(IPARM,1) = 0
      ENDIF
      IPDAT(IPARM,2) = IVAL(LEV)
      PDATA(IPARM) = 0.0
      IPLIN(IPARM) = ILCOM
      WRITE (KPARM(IPARM),910) IPARM
      LEV = LEV - 1
      IVAL(LEV) = IPARM
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT('*T',I5.5,'*')
C-----------------------------------------------------------------------
      END
      SUBROUTINE OPTITL(ITITOP,KOD)
C     ****************************
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      DIMENSION ITITOP(80),IOP(4,50)
      CHARACTER*1 ITITOP,IOP,IBL
      DATA IOP/
     >'S','I','M','P','L','E','A','S','M','O','V','E','T','R','A','C',
     >'M','O','D','I','M','A','T','R','M','A','C','H','H','A','R','D',
     >'B','E','A','M','D','E','T','A','G','E','O','M','L','I','N','E',
     >'M','I','S','A','E','R','R','O','S','E','T','M','S','E','T','E',
     >'S','E','E','D','A','L','I','G','R','E','F','E','C','O','R','R',
     >'S','E','T','C','S','Y','N','C','S','H','O','C','G','E','N','E',
     >'B','A','S','E','P','A','R','T','C','O','N','S','S','H','O','E',
     >'S','H','O','M','O','U','T','P','A','D','I','A','S','E','T','S',
     >'S','H','O','V','F','I','L','E','S','E','T','F','C','H','A','N',
     >'R','E','A','D','C','A','D','O','R','M','A','T','I','N','T','E',
     >'S','E','I','S','B','L','O','C','T','U','N','E','S','L','C','O',
     >'S','E','T','L','P','R','I','N','S','P','A','C','L','A','Y','O',
     >'C','O','S','Y','C','A','V','I'
     >/
      DATA IBL /' '/
      NOPER=50
      DO 1 IO=1,NOPER
      NCH=0
      DO 2 JO=1,4
    5 NCH=NCH+1
      IF(ITITOP(NCH).EQ.IBL)GOTO 5
      IF(ITITOP(NCH).NE.IOP(JO,IO))GOTO 1
    2 CONTINUE
      GOTO 4
    1 CONTINUE
    3 WRITE(IOUT,10010)(ITITOP(IT),IT=1,10)
10010 FORMAT(/,'   ERROR IN OPERATION NAME : ',
     >10A1,' : JOB STOPPED ')
      CALL HALT(280)
    4 IF(IO.LE.2)KOD=100+(IO-1)*10
      IF((IO.GT.2).AND.(IO.LE.6))KOD=(IO-1)*100
      IF((IO.GE.7).AND.(IO.LE.8))KOD=500+(IO-6)*10
      IF(IO.EQ.9)KOD=515
      IF(IO.GE.10)KOD=(IO-4)*100
      RETURN
      END
      SUBROUTINE OUTCON(IEND)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
      NCHAR=0
      NDIM=mxinp
      NDATA=1
      NIPR=1
      CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NIPR)
      NOUT=DATA(1)
      RETURN
      END
      SUBROUTINE OVFLOW(ISWI,ISIZE)
C---- PRINT OVERFLOW MESSAGE AND QUIT
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
C-----------------------------------------------------------------------
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C-----------------------------------------------------------------------
      GO TO (10, 20, 30, 40, 50), ISWI
   10   WRITE (IECHO,910)
      IHERR=5
      GO TO 100
   20   WRITE (IECHO,920)
      IHERR=9
      GO TO 100
   30   WRITE (IECHO,930)
      IHERR=10
      GO TO 100
   40   WRITE (IECHO,940)
      IHERR=11
      GO TO 100
   50   WRITE (IECHO,950)
      IHERR=12
  100 CONTINUE
      WRITE (IECHO,990) ISIZE
      NFAIL = NFAIL + 1
      CALL PLEND
      CALL RDEND(IHERR)
C-----------------------------------------------------------------------
  910 FORMAT('0*** ERROR STOP *** ELEMENT SPACE OVERFLOW')
  920 FORMAT('0*** ERROR STOP *** PARAMETER SPACE OVERFLOW')
  930 FORMAT('0*** ERROR STOP *** LIST SPACE OVERFLOW')
  940 FORMAT('0*** ERROR STOP *** ELEMENT SEQUENCE OVERFLOW')
  950 FORMAT('0*** ERROR STOP *** HARMON ELEMENT TABLE OVERFLOW')
  990 FORMAT(20X,'THIS VERSION OF "MAD" ACCEPTS ',I10,' ENTRIES')
C-----------------------------------------------------------------------
      END
      SUBROUTINE PARAM(KNAME,LNAME,PFLAG)
C---- DEFINE A PARAMETER
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
C-----------------------------------------------------------------------
C---- ELEMENT TABLE
      PARAMETER         (MAXELM = 5000)
      COMMON /ELMNAM/   KELEM(MAXELM),KETYP(MAXELM),KELABL(MAXELM)
      CHARACTER*8       KELEM,KELABL*14
      CHARACTER*4       KETYP
      COMMON /ELMDAT/   IELEM1,IELEM2,IETYP(MAXELM),IEDAT(MAXELM,3),
     +                  IELIN(MAXELM)
C---- MACHINE STRUCTURE FLAGS
      COMMON /FLAGS/    INVAL,NEWCON,NEWPAR,PERI,STABX,STABZ,SYMM
      LOGICAL           INVAL,NEWCON,NEWPAR,PERI,STABX,STABZ,SYMM
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- FLAGS FOR I/O
      COMMON /IOFLAG/   SCAN,ERROR,SKIP,ENDFIL,INTER
      LOGICAL           SCAN,ERROR,SKIP,ENDFIL,INTER
C---- PARAMETER TABLE
      PARAMETER         (MAXPAR = 19000)
      COMMON /PARNAM/   KPARM(MAXPAR)
      CHARACTER*8       KPARM
      COMMON /PARDAT/   IPARM1,IPARM2,IPTYP(MAXPAR),IPDAT(MAXPAR,2),
     +                  IPLIN(MAXPAR)
      COMMON /PARVAL/   PDATA(MAXPAR)
C---- INPUT BUFFER
      COMMON /RDBUFF/   KLINE(81)
      CHARACTER*1       KLINE
      CHARACTER*80      KTEXT
      EQUIVALENCE       (KTEXT,KLINE(1))
C-----------------------------------------------------------------------
      CHARACTER*8       KNAME,KPARA
      LOGICAL           FLAG
      LOGICAL           PFLAG
C-----------------------------------------------------------------------
      IF (PFLAG) THEN
C---- COMMA?
        CALL RDTEST(',',FLAG)
        IF (FLAG) GO TO 900
        CALL RDNEXT
C---- PARAMETER NAME
        CALL RDWORD(KNAME,LNAME)
      ENDIF
      IF (LNAME .EQ. 0) THEN
        CALL RDFAIL
        WRITE (IECHO,910)
        GO TO 900
      ENDIF
      IF (KLINE(ICOL) .EQ. '[') THEN
        CALL RDLOOK(KNAME,8,KELEM,1,IELEM1,IELEM)
        IF (IELEM .NE. 0) THEN
          IF (IETYP(IELEM) .LE. 0) IELEM = 0
        ENDIF
        IF (IELEM .EQ. 0) THEN
          CALL RDFAIL
          WRITE (IECHO,920) KNAME(1:LNAME)
          GO TO 900
        ENDIF
        CALL RDNEXT
        CALL RDWORD(KPARA,LPARA)
        IF (LPARA .EQ. 0) THEN
          CALL RDFAIL
          WRITE (IECHO,930)
          GO TO 900
        ENDIF
        CALL RDTEST(']',FLAG)
        IF (FLAG) GO TO 900
        IEP1 = IEDAT(IELEM,1)
        IEP2 = IEDAT(IELEM,2)
        CALL RDLOOK(KPARA,LPARA,KPARM,IEP1,IEP2,IPARM)
        IF (IPARM .EQ. 0) THEN
          CALL RDFAIL
          WRITE (IECHO,940) KNAME(1:LNAME),KPARA(1:LPARA)
          GO TO 900
        ENDIF
        CALL RDNEXT
      ELSE
        CALL FNDPAR(ILCOM,KNAME,IPARM)
      ENDIF
C---- TEST FOR REDEFINITION
      IF (IPTYP(IPARM) .GE. 0) THEN
        CALL RDWARN
        WRITE (IECHO,950) IPLIN(IPARM)
      ENDIF
C---- EQUALS SIGN?
      CALL RDTEST('=',FLAG)
      IF (FLAG) GO TO 800
      CALL RDNEXT
C---- PARAMETER EXPRESSION
      CALL DECEXP(IPARM,FLAG)
      IF (FLAG) GO TO 800
C---- END OF COMMAND?
      CALL RDTEST(';',FLAG)
      IF (FLAG) GO TO 800
      NEWPAR = .TRUE.
      RETURN
C---- ERROR EXIT
  800 IPTYP(IPARM) = -1
      PDATA(IPARM) = 0.0
  900 ERROR = .TRUE.
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT(' *** ERROR *** PARAMETER NAME EXPECTED'/' ')
  920 FORMAT(' *** ERROR *** UNKNOWN BEAM ELEMENT "',A,'"'/' ')
  930 FORMAT(' *** ERROR *** PARAMETER KEYWORD EXPECTED'/' ')
  940 FORMAT(' *** ERROR *** UNKNOWN ELEMENT PARAMETER "',
     +       A,'[',A,']"'/' ')
  950 FORMAT(' ** WARNING ** THE ABOVE NAME WAS DEFINED IN LINE ',I5,
     +       ', IT WILL BE REDEFINED'/' ')
C-----------------------------------------------------------------------
      END
      SUBROUTINE PARCON(ILCOM,IPARM,VALUE)
C---- ALLOCATE CONSTANT CELL
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
C-----------------------------------------------------------------------
C      CHARACTER*8 SPARM
C      CHARACTER*1 UPARM(8),IDIGIT(10),IBLANK
C      DATA UPARM/'*','C',' ',' ',' ',' ',' ','*'/
C      DATA IDIGIT/'0','1','2','3','4','5','6','7','8','9'/
C      DATA IBLANK/' '/
C      EQUIVALENCE (SPARM,UPARM(1))
C---- PARAMETER TABLE
      PARAMETER         (MAXPAR = 19000)
      COMMON /PARNAM/   KPARM(MAXPAR)
      CHARACTER*8       KPARM
      COMMON /PARDAT/   IPARM1,IPARM2,IPTYP(MAXPAR),IPDAT(MAXPAR,2),
     +                  IPLIN(MAXPAR)
      COMMON /PARVAL/   PDATA(MAXPAR)
C-----------------------------------------------------------------------
C---- ALLOCATE AN UPPER PARAMETER CELL
      IPARM = IPARM2 - 1
      IF (IPARM1 .GE. IPARM) CALL OVFLOW(2,MAXPAR)
      IPARM2 = IPARM
C---- FILL IN CONSTANT DATA
      IPTYP(IPARM) = 0
      IPDAT(IPARM,1) = 0
      IPDAT(IPARM,2) = 0
      PDATA(IPARM) = VALUE
      IPLIN(IPARM) = ILCOM
C      IDFL=0
C      RPARM=IPARM
C      RPARM=RPARM*1.0D-04
C      DO 1 ID=1,5
C      IDD=RPARM
C      IF(IDD.EQ.0) THEN
C           IF(IDFL.EQ.0) THEN
C                 UPARM(ID+2)=IBLANK
C                         ELSE
C                 UPARM(ID+2)=IDIGIT(IDD+1)
C            ENDIF
C                   ELSE
C            IDFL=1
C            UPARM(ID+2)=IDIGIT(IDD+1)
C      ENDIF
C      RPARM=RPARM-IDD
C      RPARM=RPARM*10.0D0
C    1 CONTINUE
C      KPARM(IPARM)=SPARM
      WRITE(KPARM(IPARM),910) IPARM
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT('*C',I5.5,'*')
C-----------------------------------------------------------------------
      END
      SUBROUTINE PAREVL
C---- EVALUATE COUPLED PARAMETERS
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
C-----------------------------------------------------------------------
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- PARAMETER TABLE
      PARAMETER         (MAXPAR = 19000)
      COMMON /PARDAT/   IPARM1,IPARM2,IPTYP(MAXPAR),IPDAT(MAXPAR,2),
     +                  IPLIN(MAXPAR)
      COMMON /PARVAL/   PDATA(MAXPAR)
      COMMON /PARLST/   IPLIST,IPNEXT(MAXPAR)
C-----------------------------------------------------------------------
      IPARM = IPLIST
      IF (IPARM .EQ. 0) RETURN
C---- PERFORM OPERATION
  100   ITYPE = IPTYP(IPARM)
        IF (ITYPE .LE. 0 .OR. ITYPE .GT. 20) GO TO 500
        IOP1 = IPDAT(IPARM,1)
        IOP2 = IPDAT(IPARM,2)
        GO TO (110,120,130,140,500,500,500,500,500,500,
     +         210,220,230,240,250,260,270,500,500,500), ITYPE
C---- BINARY OPERATIONS
  110     PDATA(IPARM) = PDATA(IOP1) + PDATA(IOP2)
        GO TO 500
  120     PDATA(IPARM) = PDATA(IOP1) - PDATA(IOP2)
        GO TO 500
  130     PDATA(IPARM) = PDATA(IOP1)*PDATA(IOP2)
        GO TO 500
  140     IF (PDATA(IOP2) .EQ. 0.0) THEN
            WRITE (IECHO,910)
            CALL PARPRT(IPARM)
            NWARN = NWARN + 1
            PDATA(IPARM) = 0.0
          ELSE
            PDATA(IPARM) = PDATA(IOP1) / PDATA(IOP2)
          ENDIF
        GO TO 500
C---- UNARY OPERATIONS
  210     PDATA(IPARM) = PDATA(IOP2)
        GO TO 500
  220     PDATA(IPARM) = -PDATA(IOP2)
        GO TO 500
  230     IF (PDATA(IOP2) .LT. 0.0) THEN
            WRITE (IECHO,920)
            CALL PARPRT(IPARM)
            NWARN = NWARN + 1
            PDATA(IPARM) = 0.0
          ELSE
            PDATA(IPARM) = SQRT(PDATA(IOP2))
          ENDIF
        GO TO 500
  240     IF (PDATA(IOP2) .LE. 0.0) THEN
            WRITE (IECHO,930)
            CALL PARPRT(IPARM)
            NWARN = NWARN + 1
            PDATA(IPARM) = 0.0
          ELSE
            PDATA(IPARM) = LOG(PDATA(IOP2))
          ENDIF
        GO TO 500
  250     PDATA(IPARM) = EXP(PDATA(IOP2))
        GO TO 500
  260     PDATA(IPARM) = SIN(PDATA(IOP2))
        GO TO 500
  270     PDATA(IPARM) = COS(PDATA(IOP2))
C---- NEXT LIST MEMBER
  500   IPARM = IPNEXT(IPARM)
        IF (IPARM .NE. 0) GO TO 100
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT('0** WARNING ** DIVISION BY ZERO ATTEMPTED --- ',
     +       'RESULT SET TO ZERO')
  920 FORMAT('0** WARNING ** SQUARE ROOT OF A NUMBER < 0.0 --- ',
     +       'RESULT SET TO ZERO')
  930 FORMAT('0** WARNING ** LOGARITHM OF A NUMBER <= 0.0 --- ',
     +       'RESULT SET TO ZERO')
C-----------------------------------------------------------------------
      END
      SUBROUTINE PARORD(ERROR)
C---- SET UP ORDERED LIST FOR EVALUATION OF DEPENDENT PARAMETERS
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
      LOGICAL           ERROR
C-----------------------------------------------------------------------
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- PARAMETER TABLE
      PARAMETER         (MAXPAR = 19000)
      COMMON /PARDAT/   IPARM1,IPARM2,IPTYP(MAXPAR),IPDAT(MAXPAR,2),
     +                  IPLIN(MAXPAR)
      COMMON /PARVAL/   PDATA(MAXPAR)
      COMMON /PARLST/   IPLIST,IPNEXT(MAXPAR)
C-----------------------------------------------------------------------
      ERROR = .FALSE.
C---- FLAG DEPENDENT PARAMETERS
      IPDEP = 0
      IPLIST = 0
      DO 10 IPARM = 1, IPARM1
        IF (IPTYP(IPARM) .GT. 0) THEN
          IPDEP = IPDEP + 1
          IPNEXT(IPARM) = -1
        ELSE
          IPNEXT(IPARM) = 0
        ENDIF
   10 CONTINUE
      DO 20 IPARM = IPARM2, MAXPAR
        IF (IPTYP(IPARM) .GT. 0) THEN
          IPDEP = IPDEP + 1
          IPNEXT(IPARM) = -1
        ELSE
          IPNEXT(IPARM) = 0
        ENDIF
   20 CONTINUE
      IF (IPDEP .EQ. 0) RETURN
C---- ORDER THE TABLE JUST CREATED -------------------------------------
C---- PASS THROUGH LIST TO FIND PARAMETERS WHOSE OPERANDS ARE DEFINED
  100 ICOUNT = IPDEP
C---- DEFINE GLOBAL PARAMETERS, IF POSSIBLE
      DO 140 IPARM = 1, IPARM1
        IF (IPNEXT(IPARM) .LT. 0) THEN
          IOP2 = IPDAT(IPARM,2)
          IOP1 = IOP2
          IF (IPTYP(IPARM) .LE. 10) IOP1 = IPDAT(IPARM,1)
          IF (IPNEXT(IOP1) .GE. 0 .AND. IPNEXT(IOP2) .GE. 0) THEN
            IPDEP = IPDEP - 1
            IPNEXT(IPARM) = IPLIST
            IPLIST = IPARM
          ENDIF
        ENDIF
  140 CONTINUE
C---- DEFINE ELEMENT PARAMETERS, IF POSSIBLE
      DO 190 IPARM = IPARM2, MAXPAR
        IF (IPNEXT(IPARM) .LT. 0) THEN
          IOP2 = IPDAT(IPARM,2)
          IOP1 = IOP2
          IF (IPTYP(IPARM) .LE. 10) IOP1 = IPDAT(IPARM,1)
          IF (IPNEXT(IOP1) .GE. 0 .AND. IPNEXT(IOP2) .GE. 0) THEN
            IPDEP = IPDEP - 1
            IPNEXT(IPARM) = IPLIST
            IPLIST = IPARM
          ENDIF
        ENDIF
  190 CONTINUE
C---- END OF PASS --- ALL DEFINED?
      IF (IPDEP .LE. 0) GO TO 300
C---- ANY DEFINITIONS ADDED IN LAST PASS?
      IF (IPDEP .LT. ICOUNT) GO TO 100
C---- CIRCULAR DEFINITIONS LEFT
      WRITE (IECHO,910)
      NFAIL = NFAIL + 1
      ERROR = .TRUE.
      DO 240 IPARM = 1, IPARM1
        IF (IPNEXT(IPARM) .LT. 0) THEN
          CALL PARPRT(IPARM)
          PDATA(IPARM) = 0.0
          IPNEXT(IPARM) = 0
        ENDIF
  240 CONTINUE
      DO 290 IPARM = IPARM2, MAXPAR
        IF (IPNEXT(IPARM) .LT. 0) THEN
          CALL PARPRT(IPARM)
          PDATA(IPARM) = 0.0
          IPNEXT(IPARM) = 0
        ENDIF
  290 CONTINUE
C---- REVERSE LIST (IT WAS GENERATED IN REVERSE ORDER!)
  300 IF (IPLIST .EQ. 0) RETURN
      IPARM = IPLIST
      IPLIST = 0
  310 IPSUCC = IPNEXT(IPARM)
        IPNEXT(IPARM) = IPLIST
        IPLIST = IPARM
        IPARM = IPSUCC
      IF (IPARM .NE. 0) GO TO 310
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT('0*** ERROR *** CIRCULAR PARAMETER DEFINITION(S):')
C-----------------------------------------------------------------------
      END
      SUBROUTINE PARPRT(IPARM)
C---- PRINT PARAMETER OPERATION
C**** ROUTINE NOT COMPLETE
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
C-----------------------------------------------------------------------
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- PARAMETER TABLE
      PARAMETER         (MAXPAR = 19000)
      COMMON /PARNAM/   KPARM(MAXPAR)
      CHARACTER*8       KPARM
      COMMON /PARDAT/   IPARM1,IPARM2,IPTYP(MAXPAR),IPDAT(MAXPAR,2),
     +                  IPLIN(MAXPAR)
C-----------------------------------------------------------------------
      CHARACTER*8       KOPER(20)
C-----------------------------------------------------------------------
      DATA KOPER(1)     / 'ADD     ' /
      DATA KOPER(2)     / 'SUBTRACT' /
      DATA KOPER(3)     / 'MULTIPLY' /
      DATA KOPER(4)     / 'DIVIDE  ' /
      DATA KOPER(11)    / 'EQUALS  ' /
      DATA KOPER(12)    / 'NEGATE  ' /
      DATA KOPER(13)    / 'SQRT    ' /
      DATA KOPER(14)    / 'LOG     ' /
      DATA KOPER(15)    / 'EXP     ' /
      DATA KOPER(16)    / 'SIN     ' /
      DATA KOPER(17)    / 'COS     ' /
C-----------------------------------------------------------------------
      IOP = IPTYP(IPARM)
      IOP1 = IPDAT(IPARM,1)
      IOP2 = IPDAT(IPARM,2)
      WRITE (IECHO,910) KPARM(IPARM),KOPER(IOP),KPARM(IOP1),KPARM(IOP2)
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT(15X,A,' = ',A,' ( ',A,' , ',A,' )')
C-----------------------------------------------------------------------
      END

      SUBROUTINE PARTAN(IEND)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      COMMON/CANAL/ave(6),rms(6),SCALE,IANOPT,IANPRT
      common/cgener/rsig(6),gco(6),cpa(6,6),ngopt
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
      DIMENSION CORR(6,6),NPA(129,129)
      DIMENSION A(6,6),D(6),E(6),Z(6,6)
      DIMENSION E2(6)
      CHARACTER*1 JCHAR(40)
      DATA JCHAR/' ','1','2','3','4','5','6','7','8','9','A','B','C',
     >'D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S',
     >'T','U','V','W','X','Y','Z','$','+','|','-'/
      DATA DX/4.0D-07/,DY/4.0D-07/
      IF(IEND.GE.0) THEN
        NCHAR=0
        NDIM=mxinp
        NDATA=1
        NIPR=1
        CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NIPR)
        IANOPT=DATA(1)
        IANPRT=0
      ENDIF
      DO 1 IPP=1,6
      AVE(IPP)=0.0D0
      DO 1 JPP=1,6
      a(ipp,jpp)=0.0d0
      CORR(IPP,JPP)=0.0D0
    1 CONTINUE
      NNPART=0
      DO 2 IP=1,NPART
      IF(.NOT.(LOGPAR(IP)))GOTO 2
      DO 3 IPP=1,6
      AVE(IPP)=AVE(IPP)+PART(IP,IPP)
    3 CONTINUE
      NNPART=NNPART+1
    2 CONTINUE
      DO 4 IPP=1,6
    4 AVE(IPP)=AVE(IPP)/NNPART
      DO 7 IP=1,NPART
      IF(.NOT.(LOGPAR(IP)))GOTO 7
      DO 8 IPP=1,6
      DO 8 JPP=IPP,6
      CORR(IPP,JPP)=CORR(IPP,JPP)+(PART(IP,IPP)-AVE(IPP))*
     >(PART(IP,JPP)-AVE(JPP))
    8 CONTINUE
    7 CONTINUE
      DO 9 IPP=1,6
      RMS(IPP)=DSQRT(CORR(IPP,IPP)/NNPART)
    9 CONTINUE
      DO 10 IPP=1,6
      CORR(IPP,IPP)=RMS(IPP)
      DO 10 JPP=IPP,5
      CORR(IPP,JPP+1)=CORR(IPP,JPP+1)/(RMS(IPP)*RMS(JPP+1)*NNPART)
   10 CONTINUE
      IF(IEND.GE.0) THEN
       if(nout.gt.0)WRITE(IOUT,10001)AVE
       IF(ISO.NE.0)WRITE(ISOUT,10001)AVE
                    ELSE
       if(nout.gt.0)WRITE(ISOUT,20001)AVE(1),AVE(3)
      ENDIF
20001 FORMAT('    X = ',E14.5,'    Y = ',E14.5)
10001 FORMAT(/' AVERAGES FOR X,XP,Y,YP,L,DELTA ARE',//,6E14.5,/)
      IF(NgOPT.EQ.1) THEN
           DO 101 IR=1,6
           FMUL=DSQRT(6.0D0)/SCALE
           CORR(IR,IR)=FMUL*CORR(IR,IR)
  101      RMS(IR)=RMS(IR)*FMUL
      ENDIF
      do 301 ibm=1,6
      do 302 jbm=1,6
      if(ibm.eq.jbm) then
       cpa(ibm,jbm)=corr(ibm,jbm)**2
                     else
       cpa(ibm,jbm)=corr(ibm,jbm)*corr(ibm,ibm)*corr(jbm,jbm)
      endif
  302 continue
  301 continue
c      if(ianopt.eq.0)return
      IF(IEND.GE.0) THEN
       if(nout.gt.0)WRITE(IOUT,10002)RMS
       IF(ISO.NE.0)WRITE(ISOUT,10002)RMS
                    ELSE
       PROD=RMS(1)*RMS(3)
       if(nout.gt.0)WRITE(ISOUT,20002)RMS(1),RMS(3),PROD
      ENDIF
20002 FORMAT(' SIGX = ',E14.5,' SIGY = ',E14.5,
     >/,' PROD = ',E14.5 )
10002 FORMAT(/,
     >' STDDEV FOR X,XP,Y,YP,L,DELTA ARE',//,6E14.5,/)
      IF((IEND.GE.0).and.(nout.gt.0))
     >     WRITE(IOUT,9999)((CORR(I,J),J=I,6),I=1,6)
 9999 FORMAT(//,' THE FULL BEAM MATRIX IS :'
     >//,' ',6E12.4,/,' ',12X,5E12.4,/,' ',24X,4E12.4,/,' ',36X,
     >3E12.4,/,' ',48X,2E12.4,/,' ',60X,E12.4,/)
      drdtempx=corr(1,1)*corr(2,2)*dsqrt(1-corr(1,2)**2)
      drdtempy=corr(3,3)*corr(4,4)*dsqrt(1-corr(3,4)**2)
      drdtempl=corr(5,5)*corr(6,6)*dsqrt(1-corr(5,6)**2)
      write(iout,*) ' epsxproj =',drdtempx
      write(iout,*) ' epsyproj =',drdtempy
      write(iout,*) ' epslproj =',drdtempl
      NM=6
      MB=6
      N=6
      DO 12 IM=1,6
      DO 11 JM=1,IM
      ICM=IM-JM+1
      JCM=7-JM
      IF(ICM.EQ.JCM) THEN
           BSIG=CORR(ICM,JCM)**2
                   ELSE
           BSIG=CORR(ICM,JCM)*CORR(ICM,ICM)*CORR(JCM,JCM)
      ENDIF
      A(7-JM,IM)=BSIG
CC      km=7-jm
CC      write(iout,*)' 7-jm,im,a ',km,im,a(km,im)
   11 CONTINUE
   12 CONTINUE
C      write(iout,99999)((A(ia,ja),ja=1,6),ia=1,6)
C99999 format(6(' ',6e12.3,/))
      if(ianopt.eq.0)return
      CALL BANDR(NM,N,MB,A,D,E,E2,.TRUE.,Z)
      CALL TQL2(NM,N,D,E,Z,IERR)
      IF(IERR.NE.0) THEN
        WRITE(IOUT,10100)IERR
        IF(ISO.NE.0)WRITE(ISOUT,10100)IERR
10100 FORMAT(' BEAM MATRIX DIAGONALIZATION FAILED:BEAM MAY BE TOO',
     >' ELONGATED',/)
        CALL HALT(281)
      ENDIF
      DO 32 IT=1,6
      IF(D(IT).LE.0.0D0) THEN
        WRITE(IOUT,320)IT,D(IT)
        IF(ISO.NE.0)WRITE(ISOUT,320)IT,D(IT)
  320 FORMAT(' NUMBER',I2,' EIGENVALUE',E12.3,' IS NON POSITIVE',/,
     >' BEAM ELLIPSE PROBABLY TOO ELONGATED, DIAGONALIZATION FAILED',
     >/)
        CALL HALT(281)
      ENDIF
   32 CONTINUE
      NKE=0
      BEDET=1.0D0
      DO 34 IB=1,6
      BEDET=BEDET*D(IB)
      IF(D(IB).LT.1.0E-8) THEN
         BEDET=BEDET*1.0E8
         NKE=NKE+8
      ENDIF
   34 CONTINUE
      IF(IEND.GE.0)WRITE(IOUT,10200)NKE,BEDET
10200 FORMAT(/,'  DETERMINANT OF FULL BEAM MATRIX * 1.0E',I2,' IS : ',
     >/,'      ',E14.4,/)
      IF(IANPRT.EQ.0) RETURN
      EPSX=RMS(1)*RMS(2)*DSQRT(1.0D0-CORR(1,2)**2)
      EPSY=RMS(3)*RMS(4)*DSQRT(1.0D0-CORR(3,4)**2)
      IF(IEND.GE.0)WRITE(IOUT,10003)EPSX,EPSY
10003 FORMAT(/,' ASSUMING NO X-Y CORRELATION THE X AND Y EMITTANCES ',
     >'ARE : ',/,'  EPSX = ',E12.4,'  EPSY = ',E12.4,/)
      CORFAC=DSQRT(1.0D0-CORR(1,3)**2)
      SIGLUM=25.0D16*180.0D0/(4.0D0*PI*RMS(1)*RMS(3)*CORFAC)
      IF(IEND.GE.0)WRITE(IOUT,10004)SIGLUM
10004 FORMAT(/,'  UNDER NORMAL OPERATION THE SLC LUMINOSITY ',/,
     >'  COMPUTED FROM THE X AND Y SIGMAS IS : ',/,E12.4,/)
      IF(NgOPT.LE.1) RETURN
      DO 20 INP=1,129
      DO 20 JNP=1,129
   20 NPA(INP,JNP)=0
      NPT=0
   30 XSTRT=-DX*64
      YSTRT=-DY*64
      IF(NCPART.GE.400) THEN
C     NSTP=100
      ATST=DFLOAT(NCPART)/100.0D0
      NTST=ATST/4.0D0
      NSTP=NTST*100
      IF(NCPART.GE.800) NSTP=200
      DO 41 IP=1,NPART
      IF(.NOT.LOGPAR(IP))GOTO 41
      IX=(PART(IP,1)-XSTRT)/DX + 1.5D0
      IY=(PART(IP,3)-YSTRT)/DY + 1.5D0
      IF((IX.LT.1).OR.(IX.GT.129))GO TO 41
      IF((IY.LT.1).OR.(IY.GT.129))GO TO 41
      NPA(IY,IX)=NPA(IY,IX)+1
      NPT=NPT+1
      IF(NPT.EQ.NSTP)GO TO 42
   41 CONTINUE
   42 CONTINUE
      NPART1=IP+1
      NPT1=NPT
      RN1=1.0D0/DFLOAT(NPT1)
      NINC=1
      NSQ=0
      DO 43 INP=1,129,NINC
      DO 43 JNP=1,129,NINC
      NSP=0
      DO 44 INIP=1,NINC
      DO 44 JNIP=1,NINC
   44 NSP=NSP+NPA(INP+INIP-1,JNP+JNIP-1)
   43 NSQ=NSQ+NSP**2
      SLUM=DFLOAT(NSQ)/(DFLOAT(NPT1**2)*DX*DY*NINC**2)
      ALUM1=25.0D16*180.0D0*SLUM
      DO 45 IP=NPART1,NPART
      IF(.NOT.LOGPAR(IP))GOTO 45
      IX=(PART(IP,1)-XSTRT)/DX + 1.5D0
      IY=(PART(IP,3)-YSTRT)/DY + 1.5D0
      IF((IX.LT.1).OR.(IX.GT.129))GO TO 45
      IF((IY.LT.1).OR.(IY.GT.129))GO TO 45
      NPA(IY,IX)=NPA(IY,IX)+1
      NPT=NPT+1
      NST2=2*NSTP
      IF(NPT.EQ.NST2)GO TO 46
   45 CONTINUE
   46 CONTINUE
      NPART2=IP+1
      NPT2=NPT
      RN2=1.0D0/DFLOAT(NPT2)
      NSQ=0
      DO 47 INP=1,129,NINC
      DO 47 JNP=1,129,NINC
      NSP=0
      DO 48 INIP=1,NINC
      DO 48 JNIP=1,NINC
   48 NSP=NSP+NPA(INP+INIP-1,JNP+JNIP-1)
   47 NSQ=NSQ+NSP**2
      SLUM=DFLOAT(NSQ)/(DFLOAT(NPT2**2)*DX*DY*NINC**2)
      ALUM2=25.0D16*180.0D0*SLUM
      DO 51 IP=NPART2,NPART
      IF(.NOT.LOGPAR(IP))GOTO 51
      IX=(PART(IP,1)-XSTRT)/DX + 1.5D0
      IY=(PART(IP,3)-YSTRT)/DY + 1.5D0
      IF((IX.LT.1).OR.(IX.GT.129))GO TO 51
      IF((IY.LT.1).OR.(IY.GT.129))GO TO 51
      NPA(IY,IX)=NPA(IY,IX)+1
      NPT=NPT+1
      NST4=2*NST2
      IF(NPT.EQ.NST4)GO TO 52
   51 CONTINUE
   52 CONTINUE
      NPART3=IP+1
      NPT3=NPT
      RN3=1.0D0/DFLOAT(NPT3)
      NSQ=0
      DO 53 INP=1,129,NINC
      DO 53 JNP=1,129,NINC
      NSP=0
      DO 54 INIP=1,NINC
      DO 54 JNIP=1,NINC
   54 NSP=NSP+NPA(INP+INIP-1,JNP+JNIP-1)
   53 NSQ=NSQ+NSP**2
      SLUM=DFLOAT(NSQ)/(DFLOAT(NPT3**2)*DX*DY*NINC**2)
      ALUM3=25.0D16*180.0D0*SLUM
      WRITE(IOUT,10010)NPT1,RN1,ALUM1,NPT2,RN2,ALUM2,NPT3,RN3,ALUM3
10010 FORMAT(/,' USING DISCRETE SUMS OF N**2 THE FOLLOWING ',/,'   ',
     >'LUMINOSITIES USING THE INDICATED NUMBER OF POINTS ARE :',/,
     >3(I6,2E12.4,/))
      SUML= ALUM1+ALUM2+ALUM3
      SUMLR=ALUM1*RN1+ALUM2*RN2+ALUM3*RN3
      SUMR=RN1+RN2+RN3
      SUMR2=RN1*RN1+RN2*RN2+RN3*RN3
      ALUM=(SUML*SUMR2-SUMLR*SUMR)/(3.0D0*SUMR2-SUMR*SUMR)
      WRITE(IOUT,10022)ALUM
10022 FORMAT(/,'   THE EXTRAPOLATED LUMINOSITY IS : ',E12.4,/)
                        ELSE
      DO 21 IP=1,NPART
      IF(.NOT.LOGPAR(IP))GOTO 21
      IX=(PART(IP,1)-XSTRT)/DX + 1.5D0
      IY=(PART(IP,3)-YSTRT)/DY + 1.5D0
      IF((IX.LT.1).OR.(IX.GT.129))GO TO 21
      IF((IY.LT.1).OR.(IY.GT.129))GO TO 21
      NPA(IY,IX)=NPA(IY,IX)+1
      NPT=NPT+1
   21 CONTINUE
      NINC=1
      NSQ=0
      DO 23 INP=1,129,NINC
      DO 23 JNP=1,129,NINC
      NSP=0
      DO 24 INIP=1,NINC
      DO 24 JNIP=1,NINC
   24 NSP=NSP+NPA(INP+INIP-1,JNP+JNIP-1)
   23 NSQ=NSQ+NSP**2
      SLUM=DFLOAT(NSQ)/(DFLOAT(NPT**2)*DX*DY*NINC**2)
      ALUM=25.0D16*180.0D0*SLUM
      WRITE(IOUT,10020)NPT,ALUM
10020 FORMAT(/,'  USING THE INDICATE NUMBER OF POINTS AND SUM OF N**2',
     >' THE SLC LUMINOSITY IS :',/,I6,E12.4)
      ENDIF
      RETURN
      END
      SUBROUTINE PLEND
C---- TERMINATE PLOTTER OUTPUT
C-----------------------------------------------------------------------
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- PLOTTER INFORMATION
      COMMON /PLDATA/   HMIN,VMIN,HMAX,VMAX,IFRAM,IUNIT
      REAL              HMIN,HMAX,VMIN,VMAX
      SAVE              /PLDATA/
C     HMIN,HMAX         HORIZONTAL PLOT RANGE
C     VMIN,VMAX         VERTICAL PLOT RANGE
C     IFRAM             CURRENT PLOT FRAME NUMBER
C     IUNIT             LOGICAL UNIT NUMBER FOR PLOTTER OUTPUT
C-----------------------------------------------------------------------
      CALL TVEND
      IF (IFRAM .GT. 0) WRITE (IECHO,910) IFRAM,IUNIT
      IFRAM = 0
      IUNIT = 0
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT('0... ',I5,' PLOT FRAMES WRITTEN ON LOGICAL UNIT ',I5)
C-----------------------------------------------------------------------
      END
      SUBROUTINE PLINIT(IFILE)
C---- INITIALIZE PLOTTER SYSTEM
C-----------------------------------------------------------------------
C---- PLOTTER INFORMATION
      COMMON /PLDATA/   HMIN,VMIN,HMAX,VMAX,IFRAM,IUNIT
      REAL              HMIN,HMAX,VMIN,VMAX
      SAVE              /PLDATA/
C     HMIN,HMAX         HORIZONTAL PLOT RANGE
C     VMIN,VMAX         VERTICAL PLOT RANGE
C     IFRAM             CURRENT PLOT FRAME NUMBER
C     IUNIT             LOGICAL UNIT NUMBER FOR PLOTTER OUTPUT
C-----------------------------------------------------------------------
      IUNIT = IFILE
      CALL TVBGN(IUNIT)
      CALL TVRNG('DISPLAY ',160.0,160.0,924.0,924.0)
      IFRAM = 0
      RETURN
C-----------------------------------------------------------------------
      END
      SUBROUTINE PLOT(A,B,NPART,XMAX,XMIN,YMAX,YMIN,NCCUM,NZERO,
     1 NCHAR,NCOL,NLINE,NTITLE,APLOT,LOGPAR)
C     **********************************************************
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      DIMENSION X(MXPART),Y(MXPART),A(npart),B(npart)
      CHARACTER*1 APLOT(101,51),APRINT(42),NTITLE(28)
      LOGICAL LOGPAR(mxpart)
      DATA APRINT/'1','2','3','4','5','6','7','8','9','A','B','C','D',
     1'E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T',
     2'U','V','W','X','Y','Z','+','.','-','*','!','=',' '/
       IF(NCCUM.NE.-1) THEN
           IPOUT=IOUT
                       ELSE
           IPOUT=ISOUT
       ENDIF
       DO 340 I=1,NPART
      X(I)=A(I)
340    Y(I)=B(I)
      NCH=NCHAR
      DX = (XMAX-XMIN)/(NCOL - 1)
      DY = (YMAX - YMIN)/(NLINE - 1)
      NORX = 1
      NORY = NLINE
      NF = NORX+NCOL-1
      IF(NZERO.NE.0)GO TO 1
      DO 2 J= 1,51
         DO 2 I=1,101
      APLOT(I,J) = APRINT(42)
    2 CONTINUE
      DO 3 I = NORX,NF,5
      APLOT(I,NORY) = APRINT(40)
    3 APLOT(I,NORY-NLINE+1) = APRINT(40)
      NI = NORY-NLINE+1
      DO 4 J = NI,NORY,5
      APLOT(NORX,J) =APRINT(38)
    4 APLOT(NORX + NCOL -1,J) = APRINT(38)
      APLOT(NORX,NORY) = APRINT(36)
      APLOT(NORX,NORY - NLINE + 1) = APRINT(36)
      APLOT(NORX + NCOL - 1,NORY) = APRINT(36)
      APLOT(NORX + NCOL - 1,NORY - NLINE + 1) = APRINT(36)
    1 DO 5 I = 1,NPART
      IF(.NOT.LOGPAR(I)) GO TO 5
      IF ((X(I)-XMIN)*(X(I)-XMAX).GT.0) GO TO 5
      IX=((X(I)-XMIN)/DX) +0.5 + NORX
      IF ((Y(I)-YMIN)*(Y(I)-YMAX).GT.0) GO TO 5
      IY=NORY - (((Y(I) - YMIN)/DY) - 0.5)
      IF(NCHAR.EQ.0)NCH=(MOD(I-1,35)+1)
      APLOT(IX,IY) = APRINT(NCH)
    5 CONTINUE
      IF(NCCUM. EQ.0) GO TO 7
      IF((NCCUM.NE.-1).AND.(NOUT.GE.2))WRITE(IOUT,1002) NTITLE
1002   FORMAT('-',40X,28A1,//)
      IF(NOUT.GE.2)
     >WRITE(IPOUT,1003) YMAX,(APLOT(I,NORY-NLINE + 1) , I = NORX,NCOL)
 1003 FORMAT(' ',E10.3,'   ',111A1)
      NI = NORY-NLINE+2
      NF = NORY - 1
      DO 6 J = NI,NF
    6 IF(NOUT.GE.2)WRITE(IPOUT,1004) (APLOT(I,J) ,I = NORX,NCOL)
 1004 FORMAT('              ',111A1)
      IF(NOUT.GE.2)WRITE(IPOUT,1005) YMIN,(APLOT(I,NORY),I=NORX,NCOL)
 1005 FORMAT(' ',E10.3,'   ',111A1)
      NFO=NCOL/10
      GOTO(11,12,13,14,15,16,17,18,19,20),NFO
   11 IF(NOUT.GE.2)WRITE(IPOUT,20011)XMIN,XMAX
20011 FORMAT(10X,E10.3,5X,E10.3)
      GOTO 9
   12 IF(NOUT.GE.2)WRITE(IPOUT,20012)XMIN,XMAX
20012 FORMAT(10X,E10.3,10X,E10.3)
      GOTO 9
   13 IF(NOUT.GE.2)WRITE(IPOUT,20013)XMIN,XMAX
20013 FORMAT(10X,E10.3,20X,E10.3)
      GOTO 9
   14 IF(NOUT.GE.2)WRITE(IPOUT,20014)XMIN,XMAX
20014 FORMAT(10X,E10.3,30X,E10.3)
      GOTO 9
   15 IF(NOUT.GE.2)WRITE(IPOUT,20015)XMIN,XMAX
20015 FORMAT(10X,E10.3,40X,E10.3)
      GOTO 9
   16 IF(NOUT.GE.2)WRITE(IPOUT,20016)XMIN,XMAX
20016 FORMAT(10X,E10.3,50X,E10.3)
      GOTO 9
   17 IF(NOUT.GE.2)WRITE(IPOUT,20017)XMIN,XMAX
20017 FORMAT(10X,E10.3,60X,E10.3)
      GOTO 9
   18 IF(NOUT.GE.2)WRITE(IPOUT,20018)XMIN,XMAX
20018 FORMAT(10X,E10.3,70X,E10.3)
      GOTO 9
   19 IF(NOUT.GE.2)WRITE(IPOUT,20019)XMIN,XMAX
20019 FORMAT(10X,E10.3,80X,E10.3)
      GOTO 9
   20 IF(NOUT.GE.2)WRITE(IPOUT,20020)XMIN,XMAX
20020 FORMAT(10X,E10.3,90X,E10.3)
      GOTO 9
    9 IF(NOUT.GE.2)WRITE(IPOUT,1001)
 1001 FORMAT('1')
    7 RETURN
      END
      SUBROUTINE PLOTEN
C     ********************
        IMPLICIT REAL*8 (A-H,O-Z)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/PLT/
     1XMIN,XMAX,YMIN,YMAX,XPMIN,XPMAX,YPMIN,YPMAX,ALMIN,ALMAX,
     >DELMIN,DELMAX,DNUMIN,DNUMAX,DBMIN,DBMAX,
     2MALL,NPLOT,NCCUM,NGRAPH,NCOL,NLINE
      COMMON/CHPLT/MXXPR,MYYPR,MXY,MALE
      COMMON/CLSQ/ALSQ(15,2,4),IXY,NCOEF,NAPLT,JENER,LENER(15)
      COMMON/TRI/WCO(15,6),GEN(5,4),PGEN(75,6),DIST,
     <A1(15),B1(15),A2(15),B2(15),XCOR(3,15),XPCOR(3,15),
     1AL1(15),AL2(15),MESH,NIT,NENER,NITX,NITS,NITM1,NANAL,NOPRT
      DIMENSION A(15),B(15)
      CHARACTER*1 APLOT(101,51)
      LOGICAL LENER
      CHARACTER*1 MALE(101,51),MXXPR(101,51),MYYPR(101,51),MXY(101,51)
      CHARACTER*1 NTITL1(28),NTITL2(28)
      DATA NTITL1/4*' ','D','N','U',' ','P','L','O','T',' ',
     >'V','E','R','S','U','S',' ','E','N','E','R','G','Y',' ',' '/
      DATA NTITL2/2*' ','D','B','E','T','A','/','B','E','T','A',' ',
     >'V','E','R','S','U','S',' ','E','N','E','R','G','Y',' ',' '/
      WRITE(IOUT,1001)
 1001 FORMAT('1')
      DO 1 K=1,2
      DO 2 IXY = 1,2
      DO 3 JENER = 1,NENER
      A(JENER) = WCO(JENER,6)
      B(JENER) = ALSQ(JENER,IXY,K) - ALSQ(1,IXY,K)
      IF(K.EQ.2)B(JENER)=B(JENER)/ALSQ(1,IXY,K)
    3 CONTINUE
      NCHAR=32+IXY
      IF(IXY.EQ.1.AND.K.EQ.1)CALL PLOT(A,B,NENER,DELMAX,DELMIN,DNUMAX
     >,DNUMIN,0,0,NCHAR,NCOL,NLINE,NTITL1,APLOT,LENER)
      IF(IXY.EQ.1.AND.K.EQ.2)CALL PLOT(A,B,NENER,DELMAX,DELMIN,DBMAX
     >,DBMIN,0,0,NCHAR,NCOL,NLINE,NTITL2,APLOT,LENER)
      IF(IXY.EQ.2.AND.K.EQ.1)CALL PLOT(A,B,NENER,DELMAX,DELMIN,DNUMAX
     >,DNUMIN,1,1,NCHAR,NCOL,NLINE,NTITL1,APLOT,LENER)
      IF(IXY.EQ.2.AND.K.EQ.2)CALL PLOT(A,B,NENER,DELMAX,DELMIN,DBMAX
     >,DBMIN,1,1,NCHAR,NCOL,NLINE,NTITL2,APLOT,LENER)
    2 CONTINUE
    1 CONTINUE
      RETURN
      END
      SUBROUTINE PLOTO(X,IORB,SIZE,IL,ICHAR,IPAGE)
C     ********************************************
        IMPLICIT REAL*8 (A-H,O-Z)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      DIMENSION X(iorb)
      CHARACTER*1 IPLOT(120,11),ICHAR,IM,IBL,IL(iorb)
      DATA IM/'-'/,IBL/' '/
      DO 1 IZ=1,120
      IPLOT(IZ,1)=IM
      IPLOT(IZ,11)=IM
      DO 1 JZ=2,10
    1 IPLOT(IZ,JZ)=IBL
      DO 2 IO=1,IORB
      IX=((X(IO)+SIZE)/(2.0D0*SIZE))*10.0D0+0.5D0
      IF(IX.LT.0)IX=0
      IF(IX.GT.10)IX=10
      IX=IX+1
      IPLOT(IO,IX)=ICHAR
    2 IPLOT(IO,6)=IL(IO)
      IF(NOUT.GE.3)
     >WRITE(IOUT,10001)SIZE,(IPLOT(JPL,11),JPL=1,IORB)
10001 FORMAT(/,E11.3,120A1)
      DO 3 IPL=2,10
      IRPL=12-IPL
    3 IF(NOUT.GE.3)
     >WRITE(IOUT,10002)(IPLOT(JPL,IRPL),JPL=1,IORB)
10002 FORMAT(11X,120A1)
      SIZEM=-SIZE
      IF(NOUT.GE.3)
     >WRITE(IOUT,10001)SIZEM,(IPLOT(JPL,1),JPL=1,IORB)
      IPAGE=IPAGE+1
      IF(IPAGE.NE.4)RETURN
      IF(NOUT.GE.3)
     >WRITE(IOUT,10000)
10000 FORMAT('1')
      IPAGE=0
      RETURN
      END
      SUBROUTINE PLOTPR(IE,NZERO)
C     *********************
      IMPLICIT REAL*8 (A-H,O-Z)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      COMMON/PLT/
     1XMIN,XMAX,YMIN,YMAX,XPMIN,XPMAX,YPMIN,YPMAX,ALMIN,ALMAX,
     >DELMIN,DELMAX,DNUMIN,DNUMAX,DBMIN,DBMAX,
     2MALL,NPLOT,NCCUM,NGRAPH,NCOL,NLINE
      COMMON/CHPLT/MXXPR,MYYPR,MXY,MALE
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      COMMON/CAV/FREQ,ALC,AML,CAVPHI,DEOVE,CPHI(MXPART),
     >PINGAM,PBETA,PCLENG,DTN,DAML,DTNA(MXPART),
     >CTF,CLP,DPHI,F0CAV,F1CAV,PERCAV,APHIAD,ICOPT,IAML,
     >N0CAV,N1CAV,INCAV
      CHARACTER*1 MALE(101,51),MXXPR(101,51),MYYPR(101,51),MXY(101,51)
      CHARACTER*1 NTITL1(28),NTITL2(28),NTITL3(28),NTITL5(28)
      DATA NTITL1/4*' ','H','O','R','I','Z','O','N','T','A','L',
     >' ','P','H','A','S','E',' ','S','P','A','C','E',' ',' '/
      DATA NTITL2/4*' ','V','E','R','T','I','C','A','L',' ',
     >'P','H','A','S','E',' ','S','P','A','C','E',' ',' ',' ',' '/
      DATA NTITL3/4*' ','P','H','Y','S','I','C','A','L',' ',
     >'P','H','A','S','E',' ','S','P','A','C','E',' ',' ',' ',' '/
      DATA NTITL5/4*' ','E','N','E','R','G','Y',' ',' ',' ',
     >'P','H','A','S','E',' ','S','P','A','C','E',' ',' ',' ',' '/
C
C
      NCHAR = 0
      NEL = NORLST(IE)
      IF(NCCUM.EQ.0.OR.NPRINT.EQ.0) GO TO 5
      WRITE(IOUT,1001)
 1001 FORMAT('1')
      IF(NOUT.GE.2)
     >WRITE(IOUT,19876)IE,(NAME(IZ,NEL),IZ=1,8),NCTURN
19876 FORMAT(' PLOTS OF PARTICLE POSITIONS AFTER ELEMENT',2X,
     *  I4,'(',8A1,')',2X,'DURING TURN',I6,/)
    5 IF(NGRAPH.NE.1.AND.MALL.EQ.1) GO TO 10
C
C   X-X PRIME PLOT
C
      CALL PLOT(PART(1,1),PART(1,2),NPART,XMAX,XMIN,XPMAX,XPMIN,
     *      NCCUM,NZERO,NCHAR,NCOL,NLINE,NTITL1,MXXPR,LOGPAR)
      IF(MALL.EQ.0) GO TO 11
      RETURN
   10 IF(NGRAPH.NE.2) GO TO 20
C
C   Y-Y PRIME PLOT
C
   11 CALL PLOT(PART(1,3),PART(1,4),NPART,YMAX,YMIN,YPMAX,YPMIN,
     *      NCCUM,NZERO,NCHAR,NCOL,NLINE,NTITL2,MYYPR,LOGPAR)
      IF(MALL.EQ.0) GO TO 21
      RETURN
   20 IF(NGRAPH.NE.3) GO TO 30
C
C   X-Y PLOT
C
   21 CALL PLOT(PART(1,1),PART(1,3),NPART,XMAX,XMIN,YMAX,YMIN,
     *      NCCUM,NZERO,NCHAR,NCOL,NLINE,NTITL3,MXY,LOGPAR)
      IF (NGRAPH.GT.4)GOTO 30
      RETURN
   30 IF(NGRAPH.NE.5)GOTO 40
   31 CALL PLOT(PART(1,5),PART(1,6),NPART,ALMAX,ALMIN,DELMAX,DELMIN,
     *      NCCUM,NZERO,NCHAR,NCOL,NLINE,NTITL5,MALE,LOGPAR)
      RETURN
   40 IF(NGRAPH.NE.6)GOTO 50
   41 CALL PLOT(CPHI(1),PART(1,6),NPART,ALMAX,ALMIN,DELMAX,DELMIN,
     *      NCCUM,NZERO,NCHAR,NCOL,NLINE,NTITL5,MALE,LOGPAR)
      RETURN
C
C   ERROR
C
   50 WRITE(IOUT,8431)NGRAPH
      IF(ISO.NE.0)WRITE(ISOUT,8431)NGRAPH
 8431 FORMAT(' ERROR NGRAPH VALUE',I6)
      CALL HALT(282)
      END
      SUBROUTINE PLPORB(IE,NEL,NELM)
C     *******************************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/LNGTH/TLENG,ALENG(MXELMD),ACLENG(MAXPOS)
      COMMON/ORBIT/SIZEX,SIZEY,RMSX,RMSY,RMSIX,RMSIY,
     >RTEMPX,RTEMPY,RMSPX(5),RMSPY(5),RPX,RPY,
     >RMAXX,RMAXY,RMINX,RMINY,MAXX,MAXY,MINX,MINY,PLENG,
     >IRNG,IRANGE(5),NPRORB,IORB,IREF,IPAGE,IPOINT
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      DIMENSION X(120),Y(120)
      CHARACTER*1 IX,IY,IK,IPL(120)
      DATA IX/'X'/,IY/'Y'/,IK/'K'/
      CLENG=ALENG(NORLST(IE))
      XPAR=PART(1,1)
      YPAR=PART(1,3)
C     IF(NAME(1,NEL).NE.IK)GOTO 10
C     IAD=IADR(NEL)
C     XPAR=XPAR-ELDAT(IAD)
C     YPAR=YPAR-ELDAT(IAD+2)
C  10 CONTINUE
      IF(XPAR.LE.RMAXX)GOTO 40
      RMAXX=XPAR
      MAXX=IE
   40 IF(XPAR.GE.RMINX)GOTO 50
      RMINX=XPAR
      MINX=IE
   50 IF(YPAR.LE.RMAXY)GOTO 60
      RMAXY=YPAR
      MAXY=IE
   60 IF(YPAR.GE.RMINY)GOTO 70
      RMINY=YPAR
      MINY=IE
   70 RMSX=RMSX+XPAR**2
      RMSY=RMSY+YPAR**2
      RMSIX=RMSIX+0.5D0*CLENG*(XPAR**2+RPX)
      RMSIY=RMSIY+0.5D0*CLENG*(YPAR**2+RPY)
      RPX=XPAR**2
      RPY=YPAR**2
      IF(IE.NE.IRANGE(IRNG))GOTO 30
      RMSPX(IRNG)=(RMSIX-RTEMPX)/(ACLENG(IE)-PLENG)
      RMSPY(IRNG)=(RMSIY-RTEMPY)/(ACLENG(IE)-PLENG)
      RTEMPX=RMSIX
      RTEMPY=RMSIY
      PLENG=ACLENG(IE)
      IRNG=IRNG+1
   30 IPOINT=IPOINT+1
      IF(NPRORB.EQ.2)GOTO 200
      IF(NOUT.GE.3)
c     >WRITE(IOUT,1)IE,(NAME(IN,NEL),IN=1,8),XPAR,YPAR       ! modified 11/15/94 to assist plotting
c    1 FORMAT(I6,1X,8A1,3X,2E16.5)                           ! modified 11/15/94 to assist plotting
     >WRITE(IOUT,1)IE,(NAME(IN,NEL),IN=1,8),XPAR,YPAR,acleng(ie)
    1 FORMAT(I6,1X,8A1,3X,2E16.5,3x,f15.3)
      RETURN
 200  IORB=IORB+1
      IPL(IORB)=NAME(1,NEL)
      X(IORB)=XPAR
      Y(IORB)=YPAR
      IF((IORB.EQ.120).OR.(IE.EQ.NELM))GOTO 3
      RETURN
    3 if(nout.ge.3) then
        CALL PLOTO(X,IORB,SIZEX,IPL,IX,IPAGE)
        CALL PLOTO(Y,IORB,SIZEY,IPL,IY,IPAGE)
      endif
      IORB=0
      RETURN
      END
C*************************************
      SUBROUTINE POISSN (AMU,N,IERROR)
C*************************************
C
C    POISSON GENERATOR
C    CODED FROM LOS ALAMOS REPORT      LA-5061-MS
C    PROB(N)=EXP(-AMU)*AMU**N/FACT(N)
C        WHERE FACT(N) STANDS FOR FACTORIAL OF N
C    ON RETURN IERROR.EQ.0 NORMALLY
C              IERROR.EQ.1 IF AMU.LE.0.
C
      implicit double precision (a-h,o-z)
      COMMON/CSEEDS/ISEED,IXG,IXS,IXMSTP,IMSD,IMOSTP,ISYNSD,ISYSTP,
     >ISDBEG,IBGSTP,IXES,IXESTP,IESBEG,IESTBG,isdcol
      DATA AMUOL/-1./
      IF(AMU.EQ.AMUOL) GO TO 200
      IF(AMU.GT.0.) GO TO 100
C    MEAN SHOULD BE POSITIVE
      IERROR=1
      N = 0
      GO TO 999
  100 CONTINUE
C    SAVE EXPONENTIAL FOR FURTHER IDENTICAL REQUESTS
      IERROR = 0
      AMUOL=AMU
      EXPMA=EXP(-AMU)
  200 CONTINUE
      PIR=1.
      N=-1
  300 CONTINUE
      N=N+1
      PIR=PIR*urand(isynsd)
      IF(PIR.GT.EXPMA) GO TO 300
  999 CONTINUE
      RETURN
      END
C     **********************************
      SUBROUTINE POLLSQ(X,Y,NE,NC,B,REF)
C     **********************************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      DIMENSION X(ne),Y(ne),B(nc),A(36)
      DO 10 IC=1,NC
      B(IC)=0.0D0
      DO 10 JC=1,NC
   10 A((IC-1)*NC+JC)=0.0D0
      DO 1 IE=1,NE
      DO 2 IC=1,NC
      DO 3 JC=IC,NC
      IF(JC.NE.1)GOTO 4
      A((IC-1)*NC+JC)=A((IC-1)*NC+JC)+1.0D0
      GOTO 3
    4 A((IC-1)*NC+JC)=A((IC-1)*NC+JC)+(X(IE)/REF)**(IC+JC-2)
    3 A((JC-1)*NC+IC)=A((IC-1)*NC+JC)
      IF(IC.NE.1)GOTO 5
      B(IC)=B(IC)+Y(IE)
      GOTO 2
    5 B(IC)=B(IC)+Y(IE)*(X(IE)/REF)**(IC-1)
    2 CONTINUE
    1 CONTINUE
      CALL DSIMQ(A,B,NC,KS)
      RETURN
      END
      SUBROUTINE POSCHK(NELID,IPOSCH)
C     *******************************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      DO 1 IELP=1,NELM
      IF(NELID.EQ.NORLST(IELP))GOTO 2
    1 CONTINUE
      WRITE(IOUT,10000)
10000 FORMAT(/,'  THIS ELEMENT IS NOT IN THE MACHINE LIST ',/)
      CALL HALT(246)
      return
    2 IPOSCH=IELP
      RETURN
      END

      SUBROUTINE PRANAL (NORDER)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/ANALC/COMPF,RNU0X,CETAX,CETAPX,CALPHX,CBETAX,
     1RMU1X,CHROMX,ALPH1X,BETA1X,
     1RMU0Y,RNU0Y,CETAY,CETAPY,CALPHY,CBETAY,
     1RMU1Y,CHROMY,ALPH1Y,BETA1Y,RMU0X,CDETAX,CDETPX,CDETAY,CDETPY,
     >COSX,ALX1,ALX2,VX1,VXP1,VX2,VXP2,
     >COSY,ALY1,ALY2,VY1,VYP1,VY2,VYP2,NSTABX,NSTABY,NSTAB,NWRNCP
      IF(NWRNCP.EQ.1)WRITE(IOUT,10005)
      IF((NWRNCP.EQ.1).AND.(ISO.NE.0))WRITE(ISOUT,10005)
      IF(NSTAB.EQ.1) GOTO 5
10005 FORMAT(/,'  **** WARNING : X-Y COUPLING NOT NEGLIGIBLE'
     >,' FOLLOWING ANALYSIS MAY BE MEANINGLESS ****',//)
      IF(NOUT.GE.1)
     >WRITE(IOUT,580)
      IF(ISO.NE.0)WRITE(ISOUT,580)
 580  FORMAT(//,'    HORIZONTAL MOVEMENT ANALYSIS',/)
C============================================================ FWJ
CC      IF(NOUT.GE.1)
CC     >WRITE(IOUT,500)COMPF
C============================================================
      IF((DABS(DABS(COSX)-1.0D0).LT.1.0D-06).AND.(NOUT.GE.1))
     >WRITE(IOUT,88881)
88881 FORMAT(/,' ******** WARNING : NEAR +-UNIT MATRIX FOLLOWING',
     >' ANALYSIS MAY BE MEANINGLESS!!!*******',/)
C============================================================ FWJ
      IF(COMPF.GT.0.D0)THEN
        GAMMAT=DSQRT(1.D0/COMPF)
      ELSE IF(COMPF.EQ.0.D0)THEN
        GAMMAT=0.D0
      ELSE
        GAMMAT=-DSQRT(-1.D0/COMPF)
      ENDIF
      IF(NOUT.GE.1)WRITE(IOUT,500)COMPF,GAMMAT
  500 FORMAT(/,'   COMPACTION FACTOR =',E14.7,
     #         '   GAMMA TR =         ',E14.7/)
      IF(ISO.NE.0)WRITE(ISOUT,500)COMPF,GAMMAT
CC  500 FORMAT(/,'   COMPACTION FACTOR =',E14.7,/)
CC      IF(ISO.NE.0)WRITE(ISOUT,500)COMPF
C============================================================
      IF(NSTABX.GE.1) GO TO 1
      IF(NOUT.GE.1)
     >WRITE(IOUT,581)COSX,RNU0X,CETAX,CETAPX,CALPHX,CBETAX
      IF(ISO.NE.0)WRITE(ISOUT,581)COSX,RNU0X,CETAX,CETAPX,CALPHX
     <,CBETAX
      IF (NORDER.EQ.1) GO TO 3
      IF(NOUT.GE.1)
     >WRITE(IOUT,583) RMU1X,CHROMX,ALPH1X,BETA1X,CDETAX,CDETPX
      IF(ISO.NE.0)WRITE(ISOUT,583) RMU1X,CHROMX,ALPH1X,BETA1X,CDETAX,
     >CDETPX
 581  FORMAT(3X,'COS(MU)=',E21.14,9X,'NU =',E21.14,/,
     >3X,'ETA =',E21.14,12X,'ETAP =',E21.14,/,
     1 3X,'ALPHA =',E21.14,10X,'BETA =',E21.14,/)
583   FORMAT
     >(3X,'DMU /DELTA=',E21.14,6X,'CHROMATICITY   =',E21.14,/,
     > 3X,'DALPHA /DDELTA=',E21.14,2X,'DBETA/DDELTA=',E21.14,/,
     > 3X,'DETA/DDELTA=',E21.14,5X,'DETAP/DDELTA=',E21.14,/)
    3 IF(NOUT.GE.1)
     >WRITE(IOUT,582)
      IF(ISO.NE.0)WRITE(ISOUT,582)
 582  FORMAT(//,'    VERTICAL MOVEMENT ANALYSIS',/)
      IF(NSTABY.GE.1) GO TO 2
      IF((DABS(DABS(COSY)-1.0D0).LT.1.0D-06).AND.(NOUT.GE.1))
     >WRITE(IOUT,88881)
      IF(NOUT.GE.1)
     >WRITE(IOUT,581)COSY,RNU0Y,CETAY,CETAPY,CALPHY,CBETAY
      IF(ISO.NE.0)WRITE(ISOUT,581)COSY,RNU0Y,CETAY,CETAPY,CALPHY
     <,CBETAY
      IF (NORDER.EQ.1) GO TO 4
      IF(NOUT.GE.1)
     >WRITE(IOUT,583) RMU1Y,CHROMY,ALPH1Y,BETA1Y,CDETAY,CDETPY
      IF(ISO.NE.0)WRITE(ISOUT,583) RMU1Y,CHROMY,ALPH1Y,BETA1Y,CDETAY,
     >CDETPY
    4 RETURN
    1 IF(NOUT.GE.1)
     >WRITE(IOUT,10001)
      IF(ISO.NE.0)WRITE(ISOUT,10001)
10001 FORMAT('   MOVEMENT IS UNSTABLE  ')
      IF(NOUT.GE.1)
     >WRITE(IOUT,10003)COSX,ALX1,VX1,VXP1,ALX2,VX2,VXP2
10003 FORMAT(/,20X,'  HALF-TRACE =   ',E21.14,/,
     >3X,' EIGENVALUE1 =  ',E21.14,/,5X,'  WITH EIGENVECTOR : ',/,
     >10X,'  X =  ',E21.14,5X,'  XP =  ',E21.14,/,
     >3X,' EIGENVALUE2 =  ',E21.14,/,5X,'  WITH EIGENVECTOR : ',/,
     >10X,'  X =  ',E21.14,5X,'  XP =  ',E21.14,/)
      GOTO 3
    2 IF(NOUT.GE.1)
     >WRITE(IOUT,10001)
      IF(ISO.NE.0)WRITE(ISOUT,10001)
      IF(NOUT.GE.1)
     >WRITE(IOUT,10004)COSY,ALY1,VY1,VYP1,ALY2,VY2,VYP2
10004 FORMAT(/,20X,'  HALF-TRACE =   ',E21.14,/,
     >3X,' EIGENVALUE1 = ',E21.14,/,5X,'  WITH EIGENVECTOR : ',/,
     >10X,'  Y =  ',E21.14,5X,'  YP =  ',E21.14,/,
     >3X,' EIGENVALUE2 = ',E21.14,/,5X,'  WITH EIGENVECTOR : ',/,
     >10X,'  Y =  ',E21.14,5X,'  YP =  ',E21.14,/)
      GOTO 4
    5 IF(NOUT.GE.1)
     >WRITE(IOUT,10002)
      IF(ISO.NE.0)WRITE(ISOUT,10002)
10002 FORMAT(//,'    MOVEMENT ANALYSIS NOT PERFORMED  ',//)
      GOTO 4
      END
      SUBROUTINE PRCO(ACO,NMAT,IFLOUT)
C     *********************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      DIMENSION ACO(6)
      IF(NMAT.EQ.-1) THEN
         IF(IFLOUT.EQ.1) THEN
            WRITE(IOUT,10001)ACO
10001 FORMAT(' THE INPUT COORDINATES OF THE BEAM CENTROID ARE :',/,
     >      6E14.6)
         ENDIF
         IF(IFLOUT.EQ.2) THEN
            WRITE(IOUT,10002)ACO
10002 FORMAT(' THE OUTPUT COORDINATES OF THE BEAM CENTROID ARE :',/,
     >      6E14.6)
         ENDIF
      ENDIF
      IF(NMAT.EQ.1) THEN
          IF(IFLOUT.EQ.1) THEN
             DO 1 IC=1,6
    1        ACO(IC)=-ACO(IC)
             WRITE(IOUT,10003)ACO
10003 FORMAT('* ENTRANCE KICK TO SHIFT CENTROID OF BEAM ',/,
     >'KIN:GKICK,DX=',E20.13,',DXP=',E20.13,'       &',/,
     >',DY=',E20.13,',DYP=',E20.13,'      &',/,
     >',DL=',E20.13,',DP=',E20.13)
          ENDIF
          IF(IFLOUT.EQ.2) THEN
             WRITE(IOUT,10004)ACO
10004 FORMAT('* EXIT KICK TO SHIFT CENTROID OF BEAM ',/,
     >'KOUT:GKICK,DX=',E20.13,',DXP=',E20.13,'       &',/,
     >',DY=',E20.13,',DYP=',E20.13,'      &',/,
     >',DL=',E20.13,',DP=',E20.13)
          ENDIF
      ENDIF
      RETURN
      END
      SUBROUTINE PRINT
C---- PRINT COMMAND
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
C-----------------------------------------------------------------------
C---- ELEMENT TABLE
      PARAMETER         (MAXELM = 5000)
      PARAMETER         (MXLINE = 1000)
      COMMON /ELMDAT/   IELEM1,IELEM2,IETYP(MAXELM),IEDAT(MAXELM,3),
     +                  IELIN(MAXELM)
C---- MACHINE STRUCTURE FLAGS
      COMMON /FLAGS/    INVAL,NEWCON,NEWPAR,PERI,STABX,STABZ,SYMM
      LOGICAL           INVAL,NEWCON,NEWPAR,PERI,STABX,STABZ,SYMM
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- FLAGS FOR I/O
      COMMON /IOFLAG/   SCAN,ERROR,SKIP,ENDFIL,INTER
      LOGICAL           SCAN,ERROR,SKIP,ENDFIL,INTER
C---- MACHINE PERIOD DEFINITION
      COMMON /PERIOD/   IPERI,IACT,NSUP,NELM,NFREE,NPOS1,NPOS2
C---- SEQUENCE TABLE
      PARAMETER         (MAXPOS = 10000)
      COMMON /SEQNUM/   ITEM(MAXPOS)
      COMMON /SEQFLG/   PRTFLG(MAXPOS)
      LOGICAL           PRTFLG
C-----------------------------------------------------------------------
      LOGICAL           FLAG
C-----------------------------------------------------------------------
C---- COMMA?
      CALL RDTEST(',',ERROR)
      IF (ERROR) RETURN
      CALL RDNEXT
C---- DECODE OBSERVATION POINT(S)
      CALL DECOBS(IELEM,IR1,IR2,ERROR)
      IF (ERROR) RETURN
C---- END OF COMMAND?
      CALL RDTEST(';',ERROR)
      IF (SCAN .OR. ERROR) RETURN
C---- IS BEAM LINE DEFINED?
      IF (.NOT. PERI) THEN
        CALL RDFAIL
        WRITE (IECHO,910)
        ERROR = .TRUE.
        RETURN
      ENDIF
C---- SET CORRESPONDING PRINT FLAGS
      IF (IELEM .EQ. 0) THEN
        IEPOS = 0
        DO 10 IPOS = NPOS1, NPOS2
          IF (ITEM(IPOS) .LE. MAXELM) THEN
            IEPOS = IEPOS + 1
            FLAG = (IEPOS .GE. IR1) .AND. (IEPOS .LE. IR2)
            PRTFLG(IPOS) = PRTFLG(IPOS) .OR. FLAG
          ENDIF
   10   CONTINUE
      ELSE IF (IETYP(IELEM) .EQ. 0) THEN
        IEPOS = 0
        FLAG = .FALSE.
        DO 20 IPOS = NPOS1, NPOS2
          IF (ITEM(IPOS) .EQ. IELEM + MAXELM) THEN
            IEPOS = IEPOS + 1
            FLAG = (IEPOS .GE. IR1) .AND. (IEPOS .LE. IR2)
          ENDIF
          PRTFLG(IPOS) = PRTFLG(IPOS) .OR. FLAG
          IF (ITEM(IPOS) .EQ. IELEM + (MAXELM + MXLINE)) FLAG = .FALSE.
   20   CONTINUE
      ELSE IF (IETYP(IELEM) .GT. 0) THEN
        IEPOS = 0
        DO 30 IPOS = NPOS1, NPOS2
          IF (ITEM(IPOS) .EQ. IELEM) THEN
            IEPOS = IEPOS + 1
            FLAG = (IEPOS .GE. IR1) .AND. (IEPOS .LE. IR2)
            PRTFLG(IPOS) = PRTFLG(IPOS) .OR. FLAG
          ENDIF
   30   CONTINUE
      ENDIF
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT(' *** ERROR *** "USE" COMMAND MISSING'/' ')
C-----------------------------------------------------------------------
      END
      SUBROUTINE PRLINE(IFILE)
C---- PRINT A LINE OF DASHES
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
C-----------------------------------------------------------------------
      WRITE (IFILE,910)
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT(' ',11('------------'))
C-----------------------------------------------------------------------
      END
      SUBROUTINE PRMAT(TEMP,NMAT,NORDER,CLEN)
C     *********************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      DIMENSION TEMP(6,27)
      DIMENSION AM(2),ISYM(2),IND(2),INDEX(27)
      CHARACTER*2 IND,INDEX
      CHARACTER*1 ISYM
      DATA INDEX/'1 ','2 ','3 ','4 ','5 ','6 ','11','12','13','14','15'
     <,'16','22','23','24','25','26','33','34','35','36','44','45','46'
     <,'55','56','66'/
      IF(NSLC.EQ.1)GOTO 200
      IF(NMAT.EQ.1)GO TO 100
      IF((NOUT.GE.3).AND.(NMAT.GE.0))
     >WRITE(IOUT,598)
 598  FORMAT(///,30(1H ),
     *     30(1H*),/,30(1H ),30H*   TRANSFORMATION  MATRIX   * ,
     * /,30(1H ),30(1H*),/)
      IF((NOUT.GE.3).AND.(NMAT.GE.0))
     >WRITE(IOUT,543)
  543 FORMAT(/,'          FIRST ORDER MATRIX')
      IF(NOUT.GE.3)
     >WRITE(IOUT,597)((TEMP(I,J),J=1,6),I=1,6)
  597 FORMAT(' ',6(/,'-',6(E15.7)))
      IF(NORDER.EQ.1)RETURN
      IF((NOUT.GE.3).AND.(NMAT.GE.0))
     >WRITE (IOUT,544)
  544 FORMAT(/,'               SECOND ORDER TERMS',/)
c      DO 560 I=1,5 2/01/07
      DO 560 I=1,6
      IF(NOUT.GE.3)
     >WRITE(IOUT,590)(TEMP(I,J),J=7,12)
  590 FORMAT('  ',6E15.7)
      IF(NOUT.GE.3)
     >WRITE(IOUT,591)(TEMP(I,J),J=13,17)
  591 FORMAT(' ',16X,5E15.7)
      IF(NOUT.GE.3)
     >WRITE(IOUT,592)(TEMP(I,J),J=18,21)
  592 FORMAT(' ',31X,4E15.7)
      IF(NOUT.GE.3)
     >WRITE(IOUT,593)(TEMP(I,J),J=22,24)
  593 FORMAT(' ',46X,3E15.7)
      IF(NOUT.GE.3)
     >WRITE(IOUT,5930)(TEMP(I,J),J=25,26)
 5930 FORMAT(' ',61X,2E15.7)
      IF(NOUT.GE.3)
     >WRITE(IOUT,594)TEMP(I,27)
  594 FORMAT(' ',76X,E15.7)
560   CONTINUE
      RETURN
  100 IPM=0
      WRITE(IOUT,10006)CLEN
10006 FORMAT('          :MATRIX,L=',E24.16,',   &')
      DO 101 IM=1,6
      IMM1=IM-1
      IF(IPM.EQ.1)
     > WRITE(IOUT,10001)(ISYM(IW),IMM1,IND(IW),AM(IW),IW=1,IPM)
      IF(IPM.EQ.2)
     > WRITE(IOUT,10002)(ISYM(IW),IMM1,IND(IW),AM(IW),IW=1,IPM)
10001 FORMAT(' ',A1,I1,A2,'=',E24.16,',   &')
10002 FORMAT(' ',2(A1,I1,A2,'=',E24.16,','),'   &')
      IPM=0
      DO 102 JM=1,27
      IF(TEMP(IM,JM).NE.0.0D0) THEN
            IF(IPM.EQ.2) THEN
                WRITE(IOUT,10002)(ISYM(IW),IM,IND(IW),AM(IW),IW=1,2)
                IPM=0
            ENDIF
            IPM=IPM+1
            AM(IPM)=TEMP(IM,JM)
            IND(IPM)=INDEX(JM)
            ISYM(IPM)='T'
            IF(JM.LE.6)ISYM(IPM)='R'
      ENDIF
  102 CONTINUE
  101 CONTINUE
      IMM1=IMM1+1
      IF(IPM.EQ.1)
     > WRITE(IOUT,10003)(ISYM(IW),IMM1,IND(IW),AM(IW),IW=1,IPM)
      IF(IPM.EQ.2)
     > WRITE(IOUT,10004)(ISYM(IW),IMM1,IND(IW),AM(IW),IW=1,IPM)
10003 FORMAT(' ',A1,I1,A2,'=',E24.16)
10004 FORMAT(' ',A1,I1,A2,'=',E24.16,',',A1,I1,A2,'=',E24.16)
      RETURN
  200 CONTINUE
      WRITE(IOUT,297)((TEMP(I,J),I=1,6),J=1,6)
  297 FORMAT(/,6(3E24.16,/,3E24.16,//))
      RETURN
      END
      SUBROUTINE PROMAT(IELM,MATADR)
C     ************************
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER    (mxpart = 128000)
      DIMENSION TRANS(27,27)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      COMMON/PRODCT/KODEPR,NEL,NOF
      COMMON/SYM/ENERLI,GAMMLI,BETALI,bili,b2li,b2ili,
     >ISYOPT,ISYFLG,MATTOT,KANVAR
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      parameter   (mxerr = 25)
      parameter   (MXEREL = 500)
      parameter   (MXERRG = 6)
      COMMON/cERR/ERRVAL(mxerr,mxerel),erv(mxerr,mxerel),NERELE(mxerel),
     > NERPAR(mxerr,mxerel),NERR,NEROPT,NERRE,MERSEL(mxerel),
     > NERNGE(mxerel),MERNGE(2,mxerrg,mxerel),MERFLG
      COMMON/ERSAV/SAV(mxerr),SAVMAT(6,27),IERSET,IER,IDE,IEMSAV
C
C NOTE: (12.23.86) THE RANDOM SEED FOR ERROR GENERATION IS SET
C IN SUBROUTINE MATRIX.  HOWEVER, THE SEED DOES NOT PROGRESS
C WHEN MISALIGNMENTS ARE INVOLVED - ONLY WHEN ERRORS ARE ENCOUNTERED
C IS THE SEED CHANGED.  HENCE, THE RESULTS OF A MACHINE OR MATRIX
C OPERATION WILL MATCH THE RESULTS OF A DETAILED, LINE, OR MOVEMENT
C ONLY WHEN NO MISALIGNMENTS OR SYNCHROTRON RADIATION ARE PRESENT.
C
C THIS COULD BE MODIFIED TO COVER THE ADVANCE OF THE SEED WITH MISALIGN-
C MENTS BY INCLUDING CALLS TO MSET AND MRESET (IF MISALIGNMENTS ARE
C ACTIVATED) SINCE THE MISALIGNMENT SEEDS HAVE ALSO BEEN SET IN MATRIX.
C AS FOR RADIATION - I THINK YOU'RE OUT OF LUCK FOR NOW
C
      CHARACTER*1 NAME,LABEL
C      ITWO=0
      IF(NORDER.EQ.2)NOF=27
C      WRITE(6,99999)IELM,MATADR,(MADR(IM),IM=1,10)
C99999 FORMAT(' IN PROMAT IELM,MATADR,MADR ARE ',/,2I5,/,10I5)
  541 DO 507 I=1,6
C      WRITE(6,99996)(TEMP(I,J),J=1,6)
C99996 FORMAT(' ',6E12.4)
      DO 507 J=1,NOF
 507  TRANS(I,J)=TEMP(I,J)
      IF (NORDER.EQ.1) GO TO 525
C   FIND TRANS--THE 27X27 MATRIX FOR MACHINE TO PRESENT ELEMENT
c      DO 508 I=1,5 2/01/07 print all six dimensions - hence "dimad6d"
      DO 508 I=1,5
      DO 508 K=I, 6
      ICOEF=7*I-I*(I+1)/2+K
      DO 508 J=1, 6
      TRANS(ICOEF,J)=0
      DO 508 L1=J, 6
      TRANC=TRANS(I,J)*TRANS(K,L1)
      IF (J.NE.L1) TRANC=TRANC+TRANS(I,L1)*TRANS(K,J)
      TRANS(ICOEF,7*J-J*(J+1)/2+L1) = TRANC
 508  CONTINUE
      DO 510 I=1, NOF
 510  TRANS(27,I)=0
      TRANS(27,27)=1
C
C     PROCESS ALL CODES EXCEPT 0 6 12 13 18 AND 20 (DRIFT,COLLIMATOR
C   General kick, ARBITRARY ELEMENT, monitor, hvcollimator and
C   cebaf cavity)
C
  525 KODP = KODE(IELM)
C      WRITE(6,99997)IELM,KODP
C99997 FORMAT(' IN PROMAT IELM KODP ARE ',/,2I5)
      IF((KODP.NE.0).AND.(KODP.NE.6).AND.(KODP.NE.12).AND.
     >(KODP.NE.13).AND.(KODP.NE.8).and.(kodp.ne.18).and.
     >(kodp.ne.20)) THEN
C
C  SET UP MATRIX WITH ERRORS
C
C      IF(MERFLG.EQ.1) CALL ESET(IELM,MATADR)
C
      DO 560 IM=1,6
      DO 560 I=1,NOF
      TEMP(IM,I)=0.0D0
      DO 561 JM=1,NOF
      AMIJ=AMAT(JM,IM,MATADR)
      IF(AMIJ.EQ.0.0D0)GOTO 561
      TEMP(IM,I)=TEMP(IM,I)+AMIJ*TRANS(JM,I)
561   CONTINUE
560   CONTINUE
C
C RESET MATRIX IF ERRORS PRESENT
C
C      IF(IERSET.EQ.1) CALL ERESET(IELM,MATADR)
                     ELSE
C
C    DRIFTS,COLLIMATORS,ARBITRARY ELEMENTS,KICKS
C    AND MONITORS HAVE NO INTERNAL MATRIX
C
C  INSERT CALLS TO ESET, ERESET TO INSURE PROGRESS OF RANDOM SEEDS
C  IN THE EVENT AN ERROR IS SET ON THE ARBITRARY ELEMENT
C
C      IF(MERFLG.EQ.1) CALL ESET(IELM,MATADR)
C
        IAD=IADR(IELM)
        AL=ELDAT(IAD)
        IF(KODP.EQ.8)AL=0.5D0*AL
        ALO2=0.5D0*AL
C        WRITE(6,99998)IELM,IAD,AL
C99998 FORMAT(' IN PROMAT IELM,IAD,AL ARE ',/2I5,E12.4)
        IF(KODP.NE.8) THEN
        DO 562 I = 1,NOF
        TEMP(1,I)=TRANS(1,I)+AL*TRANS(2,I)
        TEMP(2,I)=TRANS(2,I)
        TEMP(3,I)=TRANS(3,I)+AL*TRANS(4,I)
        TEMP(4,I)=TRANS(4,I)
        TEMP(6,I)=TRANS(6,I)
        IF (ISYflg.NE.0) THEN
           TEMP(1,I)=TEMP(1,I)-AL*TRANS(17,I)/BETALI
           TEMP(3,I)=TEMP(3,I)-AL*TRANS(24,I)/BETALI
           TEMP(5,I)=TRANS(5,I)-ALO2*(TRANS(13,I)+TRANS(22,I))
                         ELSE
           TEMP(5,I)=TRANS(5,I)+ALO2*(TRANS(13,I)+TRANS(22,I))
        ENDIF
  562   CONTINUE
                            ELSE
        DO 564 I = 1,NOF
        TEMP(1,I)=TRANS(1,I)+AL*TRANS(2,I)
        TEMP(2,I)=TRANS(2,I)
        TEMP(3,I)=TRANS(3,I)+AL*TRANS(4,I)
        TEMP(4,I)=TRANS(4,I)
        TEMP(6,I)=TRANS(6,I)
        IF (ISyflg.NE.0) THEN
           TEMP(1,I)=TEMP(1,I)-AL*TRANS(17,I)/BETALI
           TEMP(3,I)=TEMP(3,I)-AL*TRANS(24,I)/BETALI
           TEMP(5,I)=TRANS(5,I)-ALO2*(TRANS(13,I)+TRANS(22,I))
                         ELSE
           TEMP(5,I)=TRANS(5,I)+ALO2*(TRANS(13,I)+TRANS(22,I))
        ENDIF
  564   CONTINUE
         ANGKICK=ELDAT(IAD+7)
         IF(KUNITS.EQ.1)ANGKICK=-ANGKICK
         IF(KUNITS.EQ.2)ANGKICK=ANGKICK*CRDEG
         COSK=DCOS(ANGKICK)
         SINK=DSIN(ANGKICK)
         DO 563 IM=1,NOF
         TSAV=TEMP(1,IM)
         TEMP(1,IM)=COSK*TSAV+SINK*TEMP(3,IM)
         TEMP(3,IM)=-SINK*TSAV+COSK*TEMP(3,IM)
         TSAV=TEMP(2,IM)
         TEMP(2,IM)=COSK*TSAV+SINK*TEMP(4,IM)
         TEMP(4,IM)=-SINK*TSAV+COSK*TEMP(4,IM)
  563    CONTINUE
      DO 567 I=1,6
      DO 567 J=1,NOF
 567  TRANS(I,J)=TEMP(I,J)
      IF (NORDER.EQ.1) GO TO 575
C   FIND TRANS--THE 27X27 MATRIX FOR MACHINE TO PRESENT ELEMENT
      DO 568 I=1,5
      DO 568 K=I, 6
      ICOEF=7*I-I*(I+1)/2+K
      DO 568 J=1, 6
      TRANS(ICOEF,J)=0
      DO 568 L1=J, 6
      TRANC=TRANS(I,J)*TRANS(K,L1)
      IF (J.NE.L1) TRANC=TRANC+TRANS(I,L1)*TRANS(K,J)
      TRANS(ICOEF,7*J-J*(J+1)/2+L1) = TRANC
 568  CONTINUE
      DO 569 I=1, NOF
 569  TRANS(27,I)=0
      TRANS(27,27)=1
 575    DO 565 I = 1,NOF
        TEMP(1,I)=TRANS(1,I)+AL*TRANS(2,I)
        TEMP(2,I)=TRANS(2,I)
        TEMP(3,I)=TRANS(3,I)+AL*TRANS(4,I)
        TEMP(4,I)=TRANS(4,I)
        TEMP(6,I)=TRANS(6,I)
        IF (ISYflg.NE.0) THEN
           TEMP(1,I)=TEMP(1,I)-AL*TRANS(17,I)/BETALI
           TEMP(3,I)=TEMP(3,I)-AL*TRANS(24,I)/BETALI
           TEMP(5,I)=TRANS(5,I)-ALO2*(TRANS(13,I)+TRANS(22,I))
                         ELSE
           TEMP(5,I)=TRANS(5,I)+ALO2*(TRANS(13,I)+TRANS(22,I))
        ENDIF
  565   CONTINUE
        ENDIF
C
C RESET ELEMENT DATA IF ERRORS PRESENT
C
C      IF(IERSET.EQ.1) CALL ERESET(IELM,MATADR)
      ENDIF
C      ITWO=ITWO+1
C      IF((KODP.EQ.5).AND.(ITWO.EQ.1)) GOTO 541
590   RETURN
      end
C     ************************
      SUBROUTINE PROMtm(IELM,MATADR,iepm)
C     ************************
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER    (mxpart = 128000)
      DIMENSION TRANS(27,27)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      COMMON/PRODCT/KODEPR,NEL,NOF
      COMMON/SYM/ENERLI,GAMMLI,BETALI,bili,b2li,b2ili,
     >ISYOPT,ISYFLG,MATTOT,KANVAR
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      parameter   (mxerr = 25)
      parameter   (MXEREL = 500)
      parameter   (MXERRG = 6)
      COMMON/cERR/ERRVAL(mxerr,mxerel),erv(mxerr,mxerel),NERELE(mxerel),
     > NERPAR(mxerr,mxerel),NERR,NEROPT,NERRE,MERSEL(mxerel),
     > NERNGE(mxerel),MERNGE(2,mxerrg,mxerel),MERFLG
      COMMON/ERSAV/SAV(mxerr),SAVMAT(6,27),IERSET,IER,IDE,IEMSAV
      parameter    (MXCEB = 2000)
      common/cebcav/cebmat(6,6,mxceb),estart,ecav(mxceb),
     >ipos(mxceb),icavtot,icebflg,iestflg,icurcav
C
C NOTE: (12.23.86) THE RANDOM SEED FOR ERROR GENERATION IS SET
C IN SUBROUTINE MATRIX.  HOWEVER, THE SEED DOES NOT PROGRESS
C WHEN MISALIGNMENTS ARE INVOLVED - ONLY WHEN ERRORS ARE ENCOUNTERED
C IS THE SEED CHANGED.  HENCE, THE RESULTS OF A MACHINE OR MATRIX
C OPERATION WILL MATCH THE RESULTS OF A DETAILED, LINE, OR MOVEMENT
C ONLY WHEN NO MISALIGNMENTS OR SYNCHROTRON RADIATION ARE PRESENT.
C
C THIS COULD BE MODIFIED TO COVER THE ADVANCE OF THE SEED WITH MISALIGN-
C MENTS BY INCLUDING CALLS TO MSET AND MRESET (IF MISALIGNMENTS ARE
C ACTIVATED) SINCE THE MISALIGNMENT SEEDS HAVE ALSO BEEN SET IN MATRIX.
C AS FOR RADIATION - I THINK YOU'RE OUT OF LUCK FOR NOW
C
      CHARACTER*1 NAME,LABEL
      ITWO=0
      IF(NORDER.EQ.2)NOF=27
C      WRITE(6,99999)IELM,MATADR,(MADR(IM),IM=1,10)
C99999 FORMAT(' IN PROMAT IELM,MATADR,MADR ARE ',/,2I5,/,10I5)
  541 DO 507 I=1,6
C      WRITE(6,99996)(TEMP(I,J),J=1,6)
C99996 FORMAT(' ',6E12.4)
      DO 507 J=1,NOF
 507  TRANS(I,J)=TEMP(I,J)
      IF (NORDER.EQ.1) GO TO 525
C   FIND TRANS--THE 27X27 MATRIX FOR MACHINE TO PRESENT ELEMENT
c      DO 508 I=1,5 2/01/07 for 6d
      DO 508 I=1,5
      DO 508 K=I, 6
      ICOEF=7*I-I*(I+1)/2+K
      DO 508 J=1, 6
      TRANS(ICOEF,J)=0
      DO 508 L1=J, 6
      TRANC=TRANS(I,J)*TRANS(K,L1)
      IF (J.NE.L1) TRANC=TRANC+TRANS(I,L1)*TRANS(K,J)
      TRANS(ICOEF,7*J-J*(J+1)/2+L1) = TRANC
 508  CONTINUE
      DO 510 I=1, NOF
 510  TRANS(27,I)=0
      TRANS(27,27)=1
C
C     PROCESS ALL CODES EXCEPT 0 6 12 13 18 AND 20 (DRIFT,COLLIMATOR
C   General kick, ARBITRARY ELEMENT, monitor, hvcollimator and
C   cebaf-type cavity)
C
  525 KODP = KODE(IELM)
C      WRITE(6,99997)IELM,KODP
C99997 FORMAT(' IN PROMAT IELM KODP ARE ',/,2I5)
      IF((KODP.NE.0).AND.(KODP.NE.6).AND.(KODP.NE.12).AND.
     >(KODP.NE.13).AND.(KODP.NE.8).and.(kodp.ne.18).and.
     >(kodp.ne.20)) THEN
C
C  SET UP MATRIX WITH ERRORS
C
C      IF(MERFLG.EQ.1) CALL ESET(IELM,MATADR)
C
      DO 560 IM=1,6
      DO 560 I=1,NOF
      TEMP(IM,I)=0.0D0
      DO 561 JM=1,NOF
      AMIJ=AMAT(JM,IM,MATADR)
      IF(AMIJ.ne.0.0D0) then
      TEMP(IM,I)=TEMP(IM,I)+AMIJ*TRANS(JM,I)
      endif
561   CONTINUE
560   CONTINUE
C
C RESET MATRIX IF ERRORS PRESENT
C
C      IF(IERSET.EQ.1) CALL ERESET(IELM,MATADR)
                     ELSE
       if(kodp.ne.20) then
C do not treat the cebaf type cavities here
C
C    DRIFTS,COLLIMATORS,ARBITRARY ELEMENTS,KICKS
C    AND MONITORS HAVE NO INTERNAL MATRIX
C
C  INSERT CALLS TO ESET, ERESET TO INSURE PROGRESS OF RANDOM SEEDS
C  IN THE EVENT AN ERROR IS SET ON THE ARBITRARY ELEMENT
C
C      IF(MERFLG.EQ.1) CALL ESET(IELM,MATADR)
C
        IAD=IADR(IELM)
        AL=ELDAT(IAD)
        IF(KODP.EQ.8)AL=0.5D0*AL
        ALO2=0.5D0*AL
C        WRITE(6,99998)IELM,IAD,AL
C99998 FORMAT(' IN PROMAT IELM,IAD,AL ARE ',/2I5,E12.4)
        IF(KODP.NE.8) THEN
        DO 562 I = 1,NOF
        TEMP(1,I)=TRANS(1,I)+AL*TRANS(2,I)
        TEMP(2,I)=TRANS(2,I)
        TEMP(3,I)=TRANS(3,I)+AL*TRANS(4,I)
        TEMP(4,I)=TRANS(4,I)
        TEMP(6,I)=TRANS(6,I)
        IF (ISYflg.NE.0) THEN
           TEMP(1,I)=TEMP(1,I)-AL*TRANS(17,I)/BETALI
           TEMP(3,I)=TEMP(3,I)-AL*TRANS(24,I)/BETALI
           TEMP(5,I)=TRANS(5,I)-ALO2*(TRANS(13,I)+TRANS(22,I))
                         ELSE
           TEMP(5,I)=TRANS(5,I)+ALO2*(TRANS(13,I)+TRANS(22,I))
        ENDIF
  562   CONTINUE
                            ELSE
        DO 564 I = 1,NOF
        TEMP(1,I)=TRANS(1,I)+AL*TRANS(2,I)
        TEMP(2,I)=TRANS(2,I)
        TEMP(3,I)=TRANS(3,I)+AL*TRANS(4,I)
        TEMP(4,I)=TRANS(4,I)
        TEMP(6,I)=TRANS(6,I)
        IF (ISyflg.NE.0) THEN
           TEMP(1,I)=TEMP(1,I)-AL*TRANS(17,I)/BETALI
           TEMP(3,I)=TEMP(3,I)-AL*TRANS(24,I)/BETALI
           TEMP(5,I)=TRANS(5,I)-ALO2*(TRANS(13,I)+TRANS(22,I))
                         ELSE
           TEMP(5,I)=TRANS(5,I)+ALO2*(TRANS(13,I)+TRANS(22,I))
        ENDIF
  564   CONTINUE
         ANGKICK=ELDAT(IAD+7)
         IF(KUNITS.EQ.1)ANGKICK=-ANGKICK
         IF(KUNITS.EQ.2)ANGKICK=ANGKICK*CRDEG
         COSK=DCOS(ANGKICK)
         SINK=DSIN(ANGKICK)
         DO 563 IM=1,NOF
         TSAV=TEMP(1,IM)
         TEMP(1,IM)=COSK*TSAV+SINK*TEMP(3,IM)
         TEMP(3,IM)=-SINK*TSAV+COSK*TEMP(3,IM)
         TSAV=TEMP(2,IM)
         TEMP(2,IM)=COSK*TSAV+SINK*TEMP(4,IM)
         TEMP(4,IM)=-SINK*TSAV+COSK*TEMP(4,IM)
  563    CONTINUE
      DO 567 I=1,6
      DO 567 J=1,NOF
 567  TRANS(I,J)=TEMP(I,J)
      IF (NORDER.EQ.1) GO TO 575
C   FIND TRANS--THE 27X27 MATRIX FOR MACHINE TO PRESENT ELEMENT
c      DO 568 I=1,5 2/01/07
      DO 568 I=1,5
      DO 568 K=I, 6
      ICOEF=7*I-I*(I+1)/2+K
      DO 568 J=1, 6
      TRANS(ICOEF,J)=0
      DO 568 L1=J, 6
      TRANC=TRANS(I,J)*TRANS(K,L1)
      IF (J.NE.L1) TRANC=TRANC+TRANS(I,L1)*TRANS(K,J)
      TRANS(ICOEF,7*J-J*(J+1)/2+L1) = TRANC
 568  CONTINUE
      DO 569 I=1, NOF
 569  TRANS(27,I)=0
      TRANS(27,27)=1
 575    DO 565 I = 1,NOF
        TEMP(1,I)=TRANS(1,I)+AL*TRANS(2,I)
        TEMP(2,I)=TRANS(2,I)
        TEMP(3,I)=TRANS(3,I)+AL*TRANS(4,I)
        TEMP(4,I)=TRANS(4,I)
        TEMP(6,I)=TRANS(6,I)
        IF (ISYflg.NE.0) THEN
           TEMP(1,I)=TEMP(1,I)-AL*TRANS(17,I)/BETALI
           TEMP(3,I)=TEMP(3,I)-AL*TRANS(24,I)/BETALI
           TEMP(5,I)=TRANS(5,I)-ALO2*(TRANS(13,I)+TRANS(22,I))
                         ELSE
           TEMP(5,I)=TRANS(5,I)+ALO2*(TRANS(13,I)+TRANS(22,I))
        ENDIF
  565   CONTINUE
        ENDIF
                                 else
C  treat the cebaf type cavities here
*       write(iout,19997)((temp(i,j),j=1,27),i=1,6)
*19997 format(6(' ',3(' ',9e10.3,/)))
      icurcav=icurcav+1
      if(ipos(icurcav).ne.iepm) then
        write(iout,19999)icurcav,iepm,ipos(icurcav)
19999 format(' cavity',i4,' is not at position ',i6,/
     >,' it is recorded at ',i6,/
     >,' this is a program error, run is stopped in promtm')
        stop
      endif
      DO 1560 IM=1,6
      DO 1560 I=1,NOF
      TEMP(IM,I)=0.0D0
      DO 1561 JM=1,6
      AMIJ=cebMAT(JM,IM,icurcav)
      IF(AMIJ.ne.0.0D0) then 
      TEMP(IM,I)=TEMP(IM,I)+AMIJ*TRANS(JM,I)
      endif
1561  CONTINUE
1560  CONTINUE
*      write(iout,19997)((temp(i,j),j=1,27),i=1,6)
         endif
C
C RESET ELEMENT DATA IF ERRORS PRESENT
C
C      IF(IERSET.EQ.1) CALL ERESET(IELM,MATADR)
      ENDIF
      ITWO=ITWO+1
      IF((KODP.EQ.5).AND.(ITWO.EQ.1)) GOTO 541
590   RETURN
      end
      SUBROUTINE PRPAGE(IFILE)
C---- PRINT PAGE HEADER
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
C-----------------------------------------------------------------------
C---- PAGE HEADER
      COMMON /PAGTIT/   KTIT,KVERS,KDATE,KTIME
      CHARACTER*8       KTIT*80,KVERS,KDATE,KTIME
C-----------------------------------------------------------------------
      WRITE (IFILE,910) KTIT,KVERS,KDATE,KTIME
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT('1',A80,'   "MAD" VERSION: ',A,'   RUN: ',A,'  ',A)
C-----------------------------------------------------------------------
      END
      SUBROUTINE PRTDEF(IEND)
C************************************
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      PARAMETER    (mxpart = 128000)
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      CHARACTER*8 KEYW(18)
      CHARACTER*1 ICHAR,NINE,jchar(20)
      COMMON/CPRT/PRNAM(8,10),KODPRT(2),
     >   IPRTFL,INTFL,ITYPFL,NAMFL,INAM,ITKOD
      CHARACTER*1 PRNAM
      CHARACTER*8 INT,ITYPE,NAMPR,NAMEND
      DATA NINE/'9'/
      DATA KEYW /
     >'DRIFT   ','BEND    ','QUADRUPO','SEXTUPOL','QUADSEXT','MULTIPOL',
     >'COLLIMAT','RFCAVITY','GKICK   ','MTWISS  ','MATRIX  ','        ',
     >'ARBITRAR','MONITOR ','        ','SOLENOID','        ','LCAVITY '
     >/
      DATA INT/'INTERVAL'/
      DATA ITYPE/'TYPE    '/
      DATA NAMPR/'NAME    '/
      DATA NAMEND/'END     '/
      IPRTFL=0
      INTFL=0
      ITYPFL=0
      DO 1 IN=1,MXLIST
      NLIST(2*IN-1)=0
    1 NLIST(2*IN)=0
      NAMFL=0
  500 NCHAR=20
      NDATA=0
      NIPR=1
      CALL INPUT(jCHAR,NCHAR,DATA,MXINP,IEND,NDATA,NIPR)
      do 2 jch=1,8
    2 ichar(jch)=jchar(jch)
      IF(IEQUAL(ICHAR,INT).EQ.1)GOTO 100
      IF(IEQUAL(ICHAR,ITYPE).EQ.1)GOTO 200
      IF(IEQUAL(ICHAR,NAMPR).EQ.1)GOTO 300
      IF(IEQUAL(ICHAR,NAMEND).EQ.1) RETURN
      WRITE(IOUT,10001)ICHAR
      IF(ISO.NE.0)WRITE(ISOUT,10001)ICHAR
10001 FORMAT(' WRONG KEYWORD : ',8A1)
      CALL HALT(400)
      STOP
  100 ILIST=1
      IPRTFL=1
      INTFL=1
      MLOCAT=0
  101 CALL INPUT(jCHAR,NCHAR,DATA,MXINP,IEND,NDATA,NIPR)
      do 22 jch=1,8
   22 ichar(jch)=jchar(jch)
      IF((ICHAR(1).EQ.NINE).AND.(ICHAR(2).EQ.NINE)) GOTO 500
      CALL ELPOS(ICHAR,NELPOS)
      NLIST(ILIST)=NELPOS
      ILIST=ILIST+1
      CALL INPUT(jCHAR,NCHAR,DATA,MXINP,IEND,NDATA,NIPR)
      do 32 jch=1,8
   32 ichar(jch)=jchar(jch)
      CALL ELPOS(ICHAR,NELPOS)
      NLIST(ILIST)=NELPOS
      ILIST=ILIST+1
      IF(ILIST.GT.2*MXLIST) THEN
       WRITE(IOUT,10004)
       IF(ISO.NE.0)WRITE(ISOUT,10004)
10004 FORMAT('  TOO MANY INTERVALS REQUESTED ')
       CALL HALT(2)
      ENDIF
      MLOCAT=MLOCAT+1
      GOTO 101
  200 IPRTFL=1
      ITYPFL=1
      ITKOD=0
  201 CALL INPUT(jCHAR,NCHAR,DATA,MXINP,IEND,NDATA,NIPR)
      do 42 jch=1,8
   42 ichar(jch)=jchar(jch)
      IF((ICHAR(1).EQ.NINE).AND.(ICHAR(2).EQ.NINE)) GOTO 500
      ITKOD=ITKOD+1
      IF(ITKOD.GT.2) THEN
       WRITE(IOUT,10002)
       IF(ISO.NE.0)WRITE(ISOUT,10002)
10002 FORMAT(' TOO MANY TYPES ')
       CALL HALT(17)
      ENDIF
      DO 202 IK=1,17
      IF(IEQUAL(ICHAR,KEYW(IK)).EQ.1) GOTO 203
  202 CONTINUE
      WRITE(IOUT,10003)ICHAR
      IF(ISO.NE.0)WRITE(ISOUT,10003)ICHAR
10003 FORMAT(' WRONG KEYWORD ',8A1)
      CALL HALT(400)
 203  KODPRT(ITKOD)=IK-1
      GOTO 201
  300 IPRTFL=1
      NAMFL=1
      INAM=0
  301 CALL INPUT(jCHAR,NCHAR,DATA,MXINP,IEND,NDATA,NIPR)
      do 52 jch=1,8
   52 ichar(jch)=jchar(jch)
      IF((ICHAR(1).EQ.NINE).AND.(ICHAR(2).EQ.NINE)) GOTO 500
      INAM=INAM+1
      IF(INAM.GT.10) THEN
       WRITE(IOUT,10004)
       IF(ISO.NE.0)WRITE(ISOUT,10005)
10005 FORMAT(' TOO MANY NAMES : MAX IS 10')
       CALL HALT(18)
      ENDIF
      DO 302 ICH=1,8
      PRNAM(ICH,INAM)=ICHAR(ICH)
  302 CONTINUE
      GOTO 301
      END
      SUBROUTINE PRTTST(IELEM,ILIST,IPRT)
C     *************************
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      PARAMETER    (MXELMD = 3000)
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      COMMON/CPRT/PRNAM(8,10),KODPRT(2),
     >   IPRTFL,INTFL,ITYPFL,NAMFL,INAM,ITKOD
      CHARACTER*1 NAME,LABEL,PRNAM
      IPRT=0
      IF(IPRTFL.EQ.0)GOTO 10
      IF(NAMFL.EQ.1) THEN
       DO 20 JNAM=1,INAM
       IF(IEQUAL(PRNAM(1,JNAM),NAME(1,NORLST(IELEM))).EQ.1) THEN
        IPRT=1
        GOTO 1
       ENDIF
   20  CONTINUE
      ENDIF
      IF(ITYPFL.EQ.1)THEN
       DO 30 IK=1,ITKOD
       IF(KODPRT(IK).EQ.KODE(NORLST(IELEM))) THEN
        IPRT=1
        GOTO 1
        ENDIF
   30  CONTINUE
      ENDIF
      IF(INTFL.EQ.0)GOTO 1
   10 IF((MLOCAT.EQ.0).AND.(IELEM.EQ.NELM))IPRT=1
      IF(ILIST.GT.2*MLOCAT)GOTO 1
      LIMLO=NLIST(ILIST)
      LIMUP=NLIST(ILIST+1)
      IF(IELEM.GE.LIMLO.AND.IELEM.LE.LIMUP)IPRT=1
      IF(IELEM.NE.LIMUP)GOTO 1
      ILIST=ILIST+2
    1 IF((NCTURN.EQ.NTURN).AND.(IELEM.EQ.NELM))IPRT=0
      RETURN
      END
C     ***********************
      SUBROUTINE QUADAC(ielm,matadr)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      IAD=IADR(ielm)
      AS=ELDAT(IAD)
      AKQ=ELDAT(IAD+1)
      DE0=ELDAT(IAD+2)*1.0D09
C added because of change between dimad and dimtest
      de0=de0/as
      PHI=ELDAT(IAD+3)
      FREQ=ELDAT(IAD+4)*1.0D06
      EN0=ELDAT(IAD+5)*1.0D09
      if(kunits.eq.2) PHI=PHI*CRDEG

      DE=DE0*DCOS(PHI)
      EN=EN0+DE*AS
      ARGLOG=DE*AS/EN0
      ALMBDA=CLIGHT/FREQ
      DO 100 I=1,6
      DO 100 J=1,27
      AMAT(J,I,matadr)=0.0D0
      IF(I.EQ.J) AMAT(J,I,matadr)=1.0D0
  100 CONTINUE
      IF(DE0.EQ.0.0D0)THEN
                IF(AKQ.EQ.0.0D0) THEN
                      CALL DRIFT(ielm,matadr)
                                 ELSE
                      CALL FLEN2(ielm,matadr)
                ENDIF
                     ELSE
                IF(AKQ.EQ.0.0D0) THEN
                       IF(ARGLOG.LT.1.0D-08) THEN
                           R12=AS*(1.0D0+ARGLOG/2.0D0+ARGLOG**2/3.0D0)
                                             ELSE
                           R12=EN0/DE*DLOG(EN/EN0)
                       ENDIF
                AMAT(2,1,matadr)=R12
                AMAT(2,2,matadr)=EN0/EN
                AMAT(4,3,matadr)=R12
                AMAT(4,4,matadr)=EN0/EN
                AMAT(5,6,matadr)=TWOPI*DE0*AS*DSIN(PHI)/(ALMBDA*EN)
                AMAT(6,6,matadr)=EN0/EN
                                 ELSE
        SAKT=EN0*AKQ*(2.0D0/DE0)**2
        AKT=DABS(SAKT)
        X0=DSQRT(AKT*EN0)
        X =DSQRT(AKT*EN)
        FACT=DEXP(X0-X)
c       RI00=EBESI0(X0)
        ri00=besik(x0,1)
        ri0=besik(x,1)
c       RI0 =EBESI0(X)
c       RI10=EBESI1(X0)
        ri10=besik(x0,3)
        ri1=besik(x,3)
c       RI1 =EBESI1(X)
c       RK00=EBESK0(X0)
        rk00=besik(x0,5)
        rk0=besik(x,5)
c       RK0 =EBESK0(X)
c       RK10=EBESK1(X0)
        rk10=besik(x0,7)
        rk1=besik(x,7)
c       RK1 =EBESK1(X)
c       RJ00=BESJ0(X0)
        rj00=besjy(x0,1)
        rj0=besjy(x,1)
c       RJ0 =BESJ0(X)
c       RJ10=BESJ1(X0)
        rj10=besjy(x0,2)
        rj1=besjy(x,2)
c       RJ1 =BESJ1(X)
c       RN00=BESY0(X0)
        rn00=besjy(x0,3)
        rn0=besjy(x,3)
c       RN0 =BESY0(X)
c       RN10=BESY1(X0)
        rn10=besjy(x0,4)
        rn1=besjy(x,4)
c       RN1 =BESY1(X)
        R11=PI*X0*(RJ10*RN0-RN10*RJ0)/2.0D0
        R12=PI*EN0*(RJ00*RN0-RN00*RJ0)/DE
        R21=-PI*AKT*DE*DSQRT(EN0/EN)*(RJ10*RN1-RN10*RJ1)/4.0D0
        R22=PI*EN0*DSQRT(AKT/EN)*(-RJ00*RN1+RN00*RJ1)/2.0D0
        R33=X0*(RI10*RK0*FACT+RK10*RI0/FACT)
        R34=2.0D0*EN0*(-RI00*RK0*FACT+RK00*RI0/FACT)/DE
        R43=AKT*DE*DSQRT(EN0/EN)*(-RI10*RK1*FACT+RK10*RI1/FACT)/2.0D0
        R44=EN0*DSQRT(AKT/EN)*(RI00*RK1*FACT+RK00*RI1/FACT)
        AMAT(5,5,matadr)=1.0D0
        AMAT(5,6,matadr)=TWOPI*DE0*AS*DSIN(PHI)/(ALMBDA*EN)
        AMAT(6,6,matadr)=EN0/EN
        IF(SAKT.GT.0.0D0) THEN
            AMAT(1,1,matadr)=R11
            AMAT(2,1,matadr)=R12
            AMAT(1,2,matadr)=R21
            AMAT(2,2,matadr)=R22
            AMAT(3,3,matadr)=R33
            AMAT(4,3,matadr)=R34
            AMAT(3,4,matadr)=R43
            AMAT(4,4,matadr)=R44
                          ELSE
            AMAT(1,1,matadr)=R33
            AMAT(2,1,matadr)=R34
            AMAT(1,2,matadr)=R43
            AMAT(2,2,matadr)=R44
            AMAT(3,3,matadr)=R11
            AMAT(4,3,matadr)=R12
            AMAT(3,4,matadr)=R21
            AMAT(4,4,matadr)=R22
        ENDIF
                 ENDIF
      ENDIF
      RETURN
      END
C     ***********************
C  BESSELFUNCTIONS PACKAGE
C
      DOUBLE PRECISION FUNCTION BESIK(X,ient)
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
C
      LOGICAL L,E
      goto(100,200,300,400,500,600,700,800),ient
      write(iout,*)' error in ient value in besik ',ient
      stop
C
c  entry for ebesi0
C
  100 E=.TRUE.
      GO TO 1
C
c  entry for besi0
C
  200 E=.FALSE.
    1 L=.TRUE.
      V=DABS(X)
      IF(V .GE. 8.0) GO TO 4
    8 F=0.0625D0*X**2-2.0D0
      A =               0.00000 00000 00002 D0
      B = F * A     +   0.00000 00000 00120 D0
      A = F * B - A +   0.00000 00000 06097 D0
      B = F * A - B +   0.00000 00002 68828 D0
      A = F * B - A +   0.00000 00101 69727 D0
      B = F * A - B +   0.00000 03260 91051 D0
      A = F * B - A +   0.00000 87383 15497 D0
      B = F * A - B +   0.00019 24693 59688 D0
      A = F * B - A +   0.00341 63317 66012 D0
      B = F * A - B +   0.04771 87487 98174 D0
      A = F * B - A +   0.50949 33654 39983 D0
      B = F * A - B +   4.01167 37601 79349 D0
      A = F * B - A +  22.27481 92424 62231 D0
      B = F * A - B +  82.48903 27440 24100 D0
      A = F * B - A + 190.49432 01727 42844 D0
      A = F * A - B + 255.46687 96243 62167 D0
      BESIK=0.5D0*(A-B)
      IF(L .AND. E) BESIK=DEXP(-V)*BESIK
      IF(L) return
C
      A =           +   0.00000 00000 00003 D0
      B = F * A     +   0.00000 00000 00159 D0
      A = F * B - A +   0.00000 00000 07658 D0
      B = F * A - B +   0.00000 00003 18588 D0
      A = F * B - A +   0.00000 00112 81211 D0
      B = F * A - B +   0.00000 03351 95256 D0
      A = F * B - A +   0.00000 82160 25940 D0
      B = F * A - B +   0.00016 27083 79043 D0
      A = F * B - A +   0.00253 63081 88086 D0
      B = F * A - B +   0.03008 07224 20512 D0
      A = F * B - A +   0.25908 44324 34900 D0
      B = F * A - B +   1.51153 56760 29228 D0
      A = F * B - A +   5.28363 28668 73920 D0
      B = F * A - B +   8.00536 88687 00334 D0
      A = F * B - A -   4.56343 35864 48395 D0
      A = F * A - B -  21.05766 01774 02440 D0
      BESIK=-DLOG(0.125D0*X)*BESIK+0.5D0*(A-B)
      IF(E) BESIK=DEXP(X)*BESIK
      return
C
    4 F=32.0D0/V-2.0D0
      B =           - 0.00000 00000 00001   D0
      A = F * B     - 0.00000 00000 00001   D0
      B = F * A - B + 0.00000 00000 00004   D0
      A = F * B - A + 0.00000 00000 00010   D0
      B = F * A - B - 0.00000 00000 00024   D0
      A = F * B - A - 0.00000 00000 00104   D0
      B = F * A - B + 0.00000 00000 00039   D0
      A = F * B - A + 0.00000 00000 00966   D0
      B = F * A - B + 0.00000 00000 01800   D0
      A = F * B - A - 0.00000 00000 04497   D0
      B = F * A - B - 0.00000 00000 33127   D0
      A = F * B - A - 0.00000 00000 78957   D0
      B = F * A - B + 0.00000 00000 29802   D0
      A = F * B - A + 0.00000 00012 38425   D0
      B = F * A - B + 0.00000 00085 13091   D0
      A = F * B - A + 0.00000 00568 16966   D0
      B = F * A - B + 0.00000 05135 87727   D0
      A = F * B - A + 0.00000 72475 91100   D0
      B = F * A - B + 0.00017 27006 30778   D0
      A = F * B - A + 0.00844 51226 24921   D0
      A = F * A - B + 2.01655 84109 17480   D0
      BESIK=0.199471140200717D0*(A-B)/DSQRT(V)
      IF(E) return
      BESIK=DEXP(V)*BESIK
      return
C
c  entry for ebesi1
C
  300 E=.TRUE.
      GO TO 2
C
c  entry for besi1
C
  400 E=.FALSE.
    2 L=.TRUE.
      V=DABS(X)
      IF(V .GE. 8.0D0) GO TO 3
    7 F=0.0625D0*X**2-2.0D0
      A =           +   0.00000 00000 00001 D0
      B = F * A     +   0.00000 00000 00031 D0
      A = F * B - A +   0.00000 00000 01679 D0
      B = F * A - B +   0.00000 00000 79291 D0
      A = F * B - A +   0.00000 00032 27617 D0
      B = F * A - B +   0.00000 01119 46285 D0
      A = F * B - A +   0.00000 32641 38122 D0
      B = F * A - B +   0.00007 87567 85754 D0
      A = F * B - A +   0.00154 30190 15627 D0
      B = F * A - B +   0.02399 30791 47841 D0
      A = F * B - A +   0.28785 55118 04672 D0
      B = F * A - B +   2.57145 99063 47755 D0
      A = F * B - A +  16.33455 05525 22066 D0
      B = F * A - B +  69.39591 76337 34448 D0
      A = F * B - A + 181.31261 60405 70265 D0
      A = F * A - B + 259.89023 78064 77292 D0
      BESIK=0.0625D0*(A-B)*X
      IF(L .AND. E) BESIK=DEXP(-V)*BESIK
      IF(L) return
C
      A =           +   0.00000 00000 00001 D0
      B = F * A     +   0.00000 00000 00042 D0
      A = F * B - A +   0.00000 00000 02163 D0
      B = F * A - B +   0.00000 00000 96660 D0
      A = F * B - A +   0.00000 00036 96783 D0
      B = F * A - B +   0.00000 01193 67971 D0
      A = F * B - A +   0.00000 32025 10692 D0
      B = F * A - B +   0.00007 00106 27855 D0
      A = F * B - A +   0.00121 70569 94516 D0
      B = F * A - B +   0.01630 00492 89816 D0
      A = F * B - A +   0.16107 43016 56148 D0
      B = F * A - B +  1.10146 19930 04852  D0
      A = F * B - A +   4.66638 70268 62842 D0
      B = F * A - B +   9.36161 78313 95389 D0
      A = F * B - A -   1.83923 92242 86199 D0
      A = F * A - B -  26.68809 54808 62668 D0
      BESIK=DLOG(0.125D0*X)*BESIK+1.0D0/X-0.0625D0*(A-B)*X
      IF(E) BESIK=DEXP(X)*BESIK
      return
C
    3 F=32.0D0/V-2.0D0
      B =           + 0.00000 00000 00001   D0
      A = F * B     + 0.00000 00000 00001   D0
      B = F * A - B - 0.00000 00000 00005   D0
      A = F * B - A - 0.00000 00000 00010   D0
      B = F * A - B + 0.00000 00000 00026   D0
      A = F * B - A + 0.00000 00000 00107   D0
      B = F * A - B - 0.00000 00000 00053   D0
      A = F * B - A - 0.00000 00000 01024   D0
      B = F * A - B - 0.00000 00000 01804   D0
      A = F * B - A + 0.00000 00000 05103   D0
      B = F * A - B + 0.00000 00000 35408   D0
      A = F * B - A + 0.00000 00000 81531   D0
      B = F * A - B - 0.00000 00000 47563   D0
      A = F * B - A - 0.00000 00014 01141   D0
      B = F * A - B - 0.00000 00096 13873   D0
      A = F * B - A - 0.00000 00659 61142   D0
      B = F * A - B - 0.00000 06297 24239   D0
      A = F * B - A - 0.00000 97321 46728   D0
      B = F * A - B - 0.00027 72053 60764   D0
      A = F * B - A - 0.02446 74429 63276   D0
      A = F * A - B + 1.95160 12046 52572   D0
      BESIK=0.199471140200717D0*(A-B)/DSQRT(V)
      IF(X .LT. 0.0) BESIK=-BESIK
      IF(E) return
      BESIK=DEXP(V)*BESIK
      return
C
c  entry for ebesk0
C
C
  500 E=.TRUE.
      GO TO 11
C
c  entry for besk0
c
C
  600 E=.FALSE.
   11 IF(X .LE. 0.0) GO TO 9
      L=.FALSE.
      V=X
      IF(X .LT. 5.0D0) GO TO 8
      F=20.0D0/X-2.0D0
      A =           - 0.00000 00000 00002   D0
      B = F * A     + 0.00000 00000 00011   D0
      A = F * B - A - 0.00000 00000 00079   D0
      B = F * A - B + 0.00000 00000 00581   D0
      A = F * B - A - 0.00000 00000 04580   D0
      B = F * A - B + 0.00000 00000 39044   D0
      A = F * B - A - 0.00000 00003 64547   D0
      B = F * A - B + 0.00000 00037 92996   D0
      A = F * B - A - 0.00000 00450 47338   D0
      B = F * A - B + 0.00000 06325 75109   D0
      A = F * B - A - 0.00001 11066 85197   D0
      B = F * A - B + 0.00026 95326 12763   D0
      A = F * B - A - 0.01131 05046 46928   D0
      A = F * A - B + 1.97681 63484 61652   D0
      BESIK=0.626657068657750D0*(A-B)/DSQRT(X)
      IF(E) return
      BESIK=DEXP(-X)*BESIK
      return
C
c  entry for ebesk1
C
  700 E=.TRUE.
      GO TO 12
C
c  entry for besk1
C
  800 E=.FALSE.
   12 IF(X .LE. 0.0) GO TO 9
      L=.FALSE.
      V=X
      IF(X .LT. 5.0D0) GO TO 7
      F=20.0D0/X-2.0D0
      A =           + 0.00000 00000 00002   D0
      B = F * A     - 0.00000 00000 00013   D0
      A = F * B - A + 0.00000 00000 00089   D0
      B = F * A - B - 0.00000 00000 00663   D0
      A = F * B - A + 0.00000 00000 05288   D0
      B = F * A - B - 0.00000 00000 45757   D0
      A = F * B - A + 0.00000 00004 35417   D0
      B = F * A - B - 0.00000 00046 45555   D0
      A = F * B - A + 0.00000 00571 32218   D0
      B = F * A - B - 0.00000 08451 72048   D0
      A = F * B - A + 0.00001 61850 63810   D0
      B = F * A - B - 0.00046 84750 28167   D0
      A = F * B - A + 0.03546 52912 43331   D0
      A = F * A - B + 2.07190 17175 44716   D0
      BESIK=0.626657068657750D0*(A-B)/DSQRT(X)
      IF(E) return
      BESIK=DEXP(-X)*BESIK
      return
C
    9 BESIK=0.
      WRITE(6,1100) X
 1100 FORMAT(1X,'BESIK ... NON-POSITIVE ARGUMENT X = ',E15.4)
      RETURN
C
      END
      DOUBLE PRECISION FUNCTION BESJY(X,ient)
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
C
      LOGICAL L
      goto(100,200,300,400),ient
      write(iout,*)' error in value ient in besjy ',ient
      stop
C
c  entry for besj0
C
  100 L=.TRUE.
      V=DABS(X)
      IF(V .GE. 8.0D0) GO TO 4
    8 F=0.0625D0*X**2-2.0D0
      A =           - 0.00000 00000 000008  D0
      B = F * A     + 0.00000 00000 000413  D0
      A = F * B - A - 0.00000 00000 019438  D0
      B = F * A - B + 0.00000 00000 784870  D0
      A = F * B - A - 0.00000 00026 792535  D0
      B = F * A - B + 0.00000 00760 816359  D0
      A = F * B - A - 0.00000 17619 469078  D0
      B = F * A - B + 0.00003 24603 288210  D0
      A = F * B - A - 0.00046 06261 662063  D0
      B = F * A - B + 0.00481 91800 694676  D0
      A = F * B - A - 0.03489 37694 114089  D0
      B = F * A - B + 0.15806 71023 320973  D0
      A = F * B - A - 0.37009 49938 726498  D0
      B = F * A - B + 0.26517 86132 033368  D0
      A = F * B - A - 0.00872 34423 528522  D0
      A = F * A - B + 0.31545 59429 497802  D0
      BESJY=0.5D0*(A-B)
      IF(L) return
C
      A =           + 0.00000 00000 000016  D0
      B = F * A     - 0.00000 00000 000875  D0
      A = F * B - A + 0.00000 00000 040263  D0
      B = F * A - B - 0.00000 00001 583755  D0
      A = F * B - A + 0.00000 00052 487948  D0
      B = F * A - B - 0.00000 01440 723327  D0
      A = F * B - A + 0.00000 32065 325377  D0
      B = F * A - B - 0.00005 63207 914106  D0
      A = F * B - A + 0.00075 31135 932578  D0
      B = F * A - B - 0.00728 79624 795521  D0
      A = F * B - A + 0.04719 66895 957634  D0
      B = F * A - B - 0.17730 20127 811436  D0
      A = F * B - A + 0.26156 73462 550466  D0
      B = F * A - B + 0.17903 43140 771827  D0
      A = F * B - A - 0.27447 43055 297453  D0
      A = F * A - B - 0.06629 22264 065699  D0
      BESJY=0.636619772367581D0*DLOG(X)*BESJY+0.5D0*(A-B)
      return
C
    4 F=256.0D0/X**2-2.0D0
      B =           + 0.00000 00000 000007  D0
      A = F * B     - 0.00000 00000 000051  D0
      B = F * A - B + 0.00000 00000 000433  D0
      A = F * B - A - 0.00000 00000 004305  D0
      B = F * A - B + 0.00000 00000 051683  D0
      A = F * B - A - 0.00000 00000 786409  D0
      B = F * A - B + 0.00000 00016 306465  D0
      A = F * B - A - 0.00000 00517 059454  D0
      B = F * A - B + 0.00000 30751 847875  D0
      A = F * B - A - 0.00053 65220 468132  D0
      A = F * A - B + 1.99892 06986 950373  D0
      P=A-B
      B =           - 0.00000 00000 000006  D0
      A = F * B     + 0.00000 00000 000043  D0
      B = F * A - B - 0.00000 00000 000334  D0
      A = F * B - A + 0.00000 00000 003006  D0
      B = F * A - B - 0.00000 00000 032067  D0
      A = F * B - A + 0.00000 00000 422012  D0
      B = F * A - B - 0.00000 00007 271916  D0
      A = F * B - A + 0.00000 00179 724572  D0
      B = F * A - B - 0.00000 07414 498411  D0
      A = F * B - A + 0.00006 83851 994261  D0
      A = F * A - B - 0.03111 17092 106740  D0
      Q=8.0D0*(A-B)/V
      F=V-0.785398163397448D0
      A=DCOS(F)
      B=DSIN(F)
      F=0.398942280401432D0/DSQRT(V)
      IF(L) GO TO 6
      BESJY=F*(Q*A+P*B)
      return
    6 BESJY=F*(P*A-Q*B)
      return
C
c  entry for besj1
C
  200 L=.TRUE.
      V=DABS(X)
      IF(V .GE. 8.0D0) GO TO 5
    3 F=0.0625D0*X**2-2.0D0
      B =           + 0.00000 00000 000114  D0
      A = F * B     - 0.00000 00000 005777  D0
      B = F * A - B + 0.00000 00000 252812  D0
      A = F * B - A - 0.00000 00009 424213  D0
      B = F * A - B + 0.00000 00294 970701  D0
      A = F * B - A - 0.00000 07617 587805  D0
      B = F * A - B + 0.00001 58870 192399  D0
      A = F * B - A - 0.00026 04443 893486  D0
      B = F * A - B + 0.00324 02701 826839  D0
      A = F * B - A - 0.02917 55248 061542  D0
      B = F * A - B + 0.17770 91172 397283  D0
      A = F * B - A - 0.66144 39341 345433  D0
      B = F * A - B + 1.28799 40988 576776  D0
      A = F * B - A - 1.19180 11605 412169  D0
      A = F * A - B + 1.29671 75412 105298  D0
      BESJY=0.0625D0*(A-B)*X
      IF(L) return
C
      B =           - 0.00000 00000 000244  D0
      A = F * B     + 0.00000 00000 012114  D0
      B = F * A - B - 0.00000 00000 517212  D0
      A = F * B - A + 0.00000 00018 754703  D0
      B = F * A - B - 0.00000 00568 844004  D0
      A = F * B - A + 0.00000 14166 243645  D0
      B = F * A - B - 0.00002 83046 401495  D0
      A = F * B - A + 0.00044 04786 298671  D0
      B = F * A - B - 0.00513 16411 610611  D0
      A = F * B - A + 0.04231 91803 533369  D0
      B = F * A - B - 0.22662 49915 567549  D0
      A = F * B - A + 0.67561 57807 721877  D0
      B = F * A - B - 0.76729 63628 866459  D0
      A = F * B - A - 0.12869 73843 813500  D0
      A = F * A - B + 0.04060 82117 718685  D0
      BESJY=0.636619772367581D0*DLOG(X)*BESJY-0.636619772367581D0/X
     1     +0.0625D0*(A-B)*X
      return
C
    5 F=256.0D0/X**2-2.0D0
      B =           - 0.00000 00000 000007  D0
      A = F * B     + 0.00000 00000 000055  D0
      B = F * A - B - 0.00000 00000 000468  D0
      A = F * B - A + 0.00000 00000 004699  D0
      B = F * A - B - 0.00000 00000 057049  D0
      A = F * B - A + 0.00000 00000 881690  D0
      B = F * A - B - 0.00000 00018 718907  D0
      A = F * B - A + 0.00000 00617 763396  D0
      B = F * A - B - 0.00000 39872 843005  D0
      A = F * B - A + 0.00089 89898 330859  D0
      A = F * A - B + 2.00180 60817 200274  D0
      P=A-B
      B =           + 0.00000 00000 000007  D0
      A = F * B     - 0.00000 00000 000046  D0
      B = F * A - B + 0.00000 00000 000360  D0
      A = F * B - A - 0.00000 00000 003264  D0
      B = F * A - B + 0.00000 00000 035152  D0
      A = F * B - A - 0.00000 00000 468636  D0
      B = F * A - B + 0.00000 00008 229193  D0
      A = F * B - A - 0.00000 00209 597814  D0
      B = F * A - B + 0.00000 09138 615258  D0
      A = F * B - A - 0.00009 62772 354916  D0
      A = F * A - B + 0.09355 55741 390707  D0
      Q=8.0D0*(A-B)/V
      F=V-2.356194490192345D0
      A=DCOS(F)
      B=DSIN(F)
      F=0.398942280401432D0/DSQRT(V)
      IF(L) GO TO 7
      BESJY=F*(Q*A+P*B)
      return
    7 BESJY=F*(P*A-Q*B)
      IF(X .LT. 0.0) BESJY=-BESJY
      return
C
c  entry for besy0
C
  300 IF(X .LE. 0.0) GO TO 9
      L=.FALSE.
      V=X
      IF(V .GE. 8.0) GO TO 4
      GO TO 8
C
c  entry for besy1
C
  400 IF(X .LE. 0.0) GO TO 9
      L=.FALSE.
      V=X
      IF(V .GE. 8.0D0) GO TO 5
      GO TO 3
C
    9 BESJY=0.
      WRITE(6,1100) X
      RETURN
 1100 FORMAT(1X,'BESJY ... NON-POSITIVE ARGUMENT X = ',E15.4)
C
      END

      sUBROUTINE QSX(AL,AKQ2,AKS2,TILTQ,TILTS,MATADR)
C     ****************************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/PRODCT/KODEPR,NEL,NOF
      DO 100 I=1,6
      DO 100 J=1,NOF
      AMAT(J,I,MATADR)=0.0D0
      IF(I.EQ.J) AMAT(J,I,MATADR)=1.0D0
  100 CONTINUE
      AKQ=DSQRT(DABS(AKQ2))
      ARG=AKQ*AL
      CSIN=DSIN(ARG)
      CCOS=DCOS(ARG)
      HSIN=DSINH(ARG)
      HCOS=DCOSH(ARG)
      IF(AKQ2.NE.0.0D0)GOTO 1
      AMAT(2,1,MATADR)=AL
      AMAT(4,3,MATADR)=AL
      IF(NORDER.EQ.1)RETURN
      AMAT(13,5,MATADR)=AL/2.0D0
      AMAT(22,5,MATADR)=AL/2.0D0
      IF(AKS2.EQ.0.0D0)RETURN
      AKL1=AKS2*AL
      AKL2=AKL1*AL
      AKL3=AKL2*AL
      AKL4=AKL3*AL
      AMAT( 7,1,MATADR)=-AKL2/2.0D0
      AMAT( 8,1,MATADR)=-AKL3/3.0D0
      AMAT(13,1,MATADR)=-AKL4/12.0D0
      AMAT(18,1,MATADR)= AKL2/2.0D0
      AMAT(19,1,MATADR)= AKL3/3.0D0
      AMAT(22,1,MATADR)= AKL4/12.0D0
      AMAT( 7,2,MATADR)=-AKL1
      AMAT( 8,2,MATADR)=-AKL2
      AMAT(13,2,MATADR)=-AKL3/3.0D0
      AMAT(18,2,MATADR)= AKL1
      AMAT(19,2,MATADR)= AKL2
      AMAT(22,2,MATADR)= AKL3/3.0D0
      AMAT( 9,3,MATADR)= AKL2
      AMAT( 10,3,MATADR)= AKL3/3.0D0
      AMAT(14,3,MATADR)= AKL3/3.0D0
      AMAT(15,3,MATADR)= AKL4/6.0D0
      AMAT( 9,4,MATADR)= AKL1*2.0D0
      AMAT( 10,4,MATADR)= AKL2
      AMAT(14,4,MATADR)= AKL2
      AMAT(15,4,MATADR)= AKL3*2.0D0/3.0D0
      RETURN
    1 IF(AKQ2.LT.0.0D0)GOTO 2
      SSOK=CSIN/AKQ
      SC=CCOS
      BSOK=HSIN/AKQ
      BC=HCOS
      GOTO 3
    2 SSOK=HSIN/AKQ
      SC=HCOS
      BSOK=CSIN/AKQ
      BC=CCOS
    3 AMAT(1,1,MATADR)=SC
      AMAT(2,1,MATADR)=SSOK
      AMAT(1,2,MATADR)=-AKQ2*SSOK
      AMAT(2,2,MATADR)=SC
      AMAT(3,3,MATADR)=BC
      AMAT(4,3,MATADR)=BSOK
      AMAT(3,4,MATADR)=AKQ2*BSOK
      AMAT(4,4,MATADR)=BC
      IF(NORDER.EQ.1) RETURN
      AMAT(7,1,MATADR)=-AKS2*(SSOK*SSOK+(1.0D0-SC)/AKQ2)/3.0D0
      AMAT(8,1,MATADR)=-2.0D0*AKS2*(SSOK*(1.0D0-SC)/AKQ2)/3.0D0
      AMAT(12,1,MATADR)=AL*AKQ2*SSOK/2.0D0
      AMAT(13,1,MATADR)=-AKS2*(2.0D0*(1.0D0-SC)/AKQ2-SSOK*SSOK)/
     >(3.0D0*AKQ2)
      AMAT(17,1,MATADR)=(SSOK-AL*SC)/2.0D0
      AMAT(18,1,MATADR)=AKS2*(BSOK*BSOK+3.0D0*(1.0D0-SC)/AKQ2)/5.0D0
      AMAT(19,1,MATADR)=2.0D0*AKS2*(BSOK*BC-SSOK)/(5.0D0*AKQ2)
      AMAT(22,1,MATADR)=AKS2*(BSOK*BSOK-2.0D0*(1.0D0-SC)/AKQ2)/
     >(5.0D0*AKQ2)
      AMAT(7,2,MATADR)=-AKS2*(2.0D0*SSOK*SC+SSOK)/3.0D0
      AMAT(8,2,MATADR)=-2.0D0*AKS2*(SC*(1.0D0-SC)/AKQ2+SSOK*SSOK)/3.0D0
      AMAT(12,2,MATADR)=AKQ2*(SSOK+AL*SC)/2.0D0
      AMAT(13,2,MATADR)=-AKS2*(2.0D0*SSOK-2.0D0*SSOK*SC)/(3.0D0*AKQ2)
      AMAT(17,2,MATADR)=AMAT(12,1,MATADR)
      AMAT(18,2,MATADR)=AKS2*(2.0D0*BSOK*BC+3.0D0*SSOK)/5.0D0
      AMAT(19,2,MATADR)=2.0D0*AKS2*(BC*BC+BSOK*BSOK*AKQ2-SC)/
     >       (5.0D0*AKQ2)
      AMAT(22,2,MATADR)=2.0D0*AKS2*(BSOK*BC-SSOK)/(5.0D0*AKQ2)
      AMAT(9,3,MATADR)=2.0D0*AKS2*(BC*(1.0D0-SC)/AKQ2+
     >                2.0D0*SSOK*BSOK)/5.0D0
      AMAT(10,3,MATADR)=2.0D0*AKS2*(2.0D0*SSOK*BC-BSOK*(1.0D0+SC))
     >  /(5.0D0*AKQ2)
      AMAT(14,3,MATADR)=2.0D0*AKS2*(3.0D0*BSOK-2.0D0*BSOK*SC-
     >    SSOK*BC)/(5.0D0*AKQ2)
      AMAT(15,3,MATADR)=2.0D0*AKS2*(2.0D0*BC*(1.0D0-SC)/AKQ2-
     >     SSOK*BSOK)/(5.0D0*AKQ2)
      AMAT(21,3,MATADR)=-AL*AKQ2*BSOK/2.0D0
      AMAT(24,3,MATADR)=(BSOK-AL*BC)/2.0D0
      AMAT(9,4,MATADR)=2.0D0*AKS2*(BSOK*(1.0D0-SC)+BC*SSOK+
     >  2.0D0*SC*BSOK+2.0D0*SSOK*BC)/5.0D0
      AMAT(10,4,MATADR)=2.0D0*AKS2*(2.0D0*SC*BC+2.0D0*SSOK*BSOK*AKQ2-
     >   BC*(1.0D0+SC)+BSOK*SSOK*AKQ2)/(5.0D0*AKQ2)
      AMAT(14,4,MATADR)=2.0D0*AKS2*(3.0D0*BC-2.0D0*BC*SC
     > +2.0D0*BSOK*SSOK*AKQ2-SC*BC-SSOK*BSOK*AKQ2)/(5.0D0*AKQ2)
      AMAT(15,4,MATADR)=2.0D0*AKS2*(2.0D0*BSOK*(1.0D0-SC)+
     >  2.0D0*BC*SSOK-SC*BSOK-SSOK*BC)/(5.00*AKQ2)
      AMAT(21,4,MATADR)=-AKQ2*(BSOK+AL*BC)/2.0D0
      AMAT(24,4,MATADR)=AMAT(21,3,MATADR)
      AMAT(7,5,MATADR)=AKQ2*(AL-SC*SSOK)/4.0D0
      AMAT(8,5,MATADR)=-AKQ2*SSOK*SSOK/2.0D0
      AMAT(13,5,MATADR)=(AL+SC*SSOK)/4.0D0
      AMAT(18,5,MATADR)=-AKQ2*(AL-BC*BSOK)/4.0D0
      AMAT(19,5,MATADR)=AKQ2*(BSOK*BSOK)/2.0D0
      AMAT(22,5,MATADR)=(AL+BC*BSOK)/4.0D0
      RETURN
      END
      SUBROUTINE QUASEX(IELM,MATADR)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      COMMON/PRODCT/KODEPR,NEL,NOF
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      IAD=IADR(IELM)
      AL =ELDAT(IAD)
      AKQ2=ELDAT(IAD+1)
      IF(KUNITS.EQ.1) AKQ2 = -AKQ2
      IF(KUNITS.EQ.2) AKS2=ELDAT(IAD+2)
      IF(KUNITS.EQ.1) AKS2 = -ELDAT(IAD+2)/2.
      IF(KUNITS.EQ.0) AKS2 = ELDAT(IAD+2)/2.
      CALL QSX(AL,AKQ2,AKS2,TILTQ,TILTS,MATADR)
      RETURN
      END
      FUNCTION RANNUM(IX,IOPT,SIG,ISTP)
C     ******************************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/CRAN/ PMRAN(0:2002),UNRAN(0:2002),G2RAN(0:2002),
     >G6RAN(0:2002),FACT
      IF(ISTP.NE.0)GOTO 2
      GOTO(11,12,13),IOPT
      WRITE(IOUT,10000) IOPT
10000 FORMAT(/,'  ERROR IN OPTION NUMBER FOR RANDOM GENERATOR',I4)
      CALL HALT(285)
   11 RANNUM=1.0D0
      UR=URAND(IX)
      IF(UR.LT.0.5D0)RANNUM=-1.0D0
      RETURN
   12 RANNUM=FACT*(URAND(IX)-0.5D0)
      RETURN
   13 RANNUM=GAUSS(IX)
      IF(DABS(RANNUM).GT.SIG)GOTO 13
      RETURN
    2 GOTO(21,22,23),IOPT
      WRITE(IOUT,10000) IOPT
      CALL HALT(285)
   21 RANNUM=PMRAN(IX)
      IX=MOD(IX+ISTP,2003)
      IF(IX.EQ.1)ISTP=ISTP+1
      IF(ISTP.EQ.500)ISTP=1
      RETURN
   22 RANNUM=UNRAN(IX)
      IX=MOD(IX+ISTP,2003)
      IF(IX.EQ.1)ISTP=ISTP+1
      IF(ISTP.EQ.500)ISTP=1
      RETURN
   23 IF(SIG.EQ.6.0D0)GOTO 236
      IF(SIG.EQ.2.0D0)GOTO 232
      WRITE(6,200)
  200 FORMAT('   ERROR IN SIGMA REQUESTED SIG 2 OR 6 ONLY ')
      CALL HALT(286)
  232 RANNUM=G2RAN(IX)
      IX=MOD(IX+ISTP,2003)
      IF(IX.EQ.1)ISTP=ISTP+1
      IF(ISTP.EQ.500)ISTP=1
      RETURN
  236 RANNUM=G6RAN(IX)
      IX=MOD(IX+ISTP,2003)
      IF(IX.EQ.1)ISTP=ISTP+1
      IF(ISTP.EQ.500)ISTP=1
      RETURN
      END
      SUBROUTINE RDEND(IHERR)
C---- PRINT NUMBER OF ERROR MESSAGES GENERATED
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
C-----------------------------------------------------------------------
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- FLAGS FOR I/O
      COMMON /IOFLAG/   SCAN,ERROR,SKIP,ENDFIL,INTER
      LOGICAL           SCAN,ERROR,SKIP,ENDFIL,INTER
C-----------------------------------------------------------------------
      IF (NWARN .NE. 0 .OR. NFAIL .NE. 0) THEN
        WRITE (IECHO,910)
        WRITE (IECHO,920) NWARN
        WRITE (IECHO,930) NFAIL
        WRITE (IECHO,940)
      ENDIF
      IF (SCAN) CALL HALT(IHERR)
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT('1**************************************')
  920 FORMAT(' * NUMBER OF WARNING MESSAGES =',I6,' *')
  930 FORMAT(' * NUMBER OF FATAL ERRORS     =',I6,' *')
  940 FORMAT(' **************************************')
C-----------------------------------------------------------------------
      END
      SUBROUTINE RDFAIL
C---- MARK PLACE OF FATAL INPUT ERROR
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
C-----------------------------------------------------------------------
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- INPUT BUFFER
      COMMON /RDBUFF/   KLINE(81)
      CHARACTER*1       KLINE
      CHARACTER*80      KTEXT
      EQUIVALENCE       (KTEXT,KLINE(1))
C-----------------------------------------------------------------------
      WRITE (IECHO,910) ILINE,KTEXT
      WRITE (IPRNT,910) ILINE,KTEXT
      WRITE (IECHO,920) IMARK,(' ',I=1,IMARK),'?'
      NFAIL = NFAIL + 1
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT('0* LINE',I5,' * ',A80)
  920 FORMAT(' * COLUMN',I3,' *',82A1)
C-----------------------------------------------------------------------
      END
      SUBROUTINE RDFILE(IFILE,FLAG)
C---- DECODE LOGICAL UNIT NUMBER
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
      LOGICAL           FLAG
C-----------------------------------------------------------------------
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C-----------------------------------------------------------------------
      FLAG = .FALSE.
      IFILE = 0
      CALL RDTEST(',',FLAG)
      IF (FLAG) RETURN
      CALL RDNEXT
      CALL RDINT(JFILE,FLAG)
      IF (FLAG) RETURN
      CALL RDTEST(';',FLAG)
      IF (FLAG) RETURN
      IF (JFILE .LT. 1 .OR. JFILE .GT. 99) THEN
        CALL RDFAIL
        WRITE (IECHO,910)
        FLAG = .TRUE.
        RETURN
      ENDIF
      IFILE = JFILE
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT(' *** ERROR *** LOGICAL UNIT NUMBER MUST BE IN ',
     +       'THE RANGE 1...99'/' ')
C-----------------------------------------------------------------------
      END
      SUBROUTINE RDFIND(STRING)
C---- FIND NEXT CHARACTER OCCURRING IN "STRING"
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
      CHARACTER*(*)     STRING
C-----------------------------------------------------------------------
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- FLAGS FOR I/O
      COMMON /IOFLAG/   SCAN,ERROR,SKIP,ENDFIL,INTER
      LOGICAL           SCAN,ERROR,SKIP,ENDFIL,INTER
C---- INPUT BUFFER
      COMMON /RDBUFF/   KLINE(81)
      CHARACTER*1       KLINE
      CHARACTER*80      KTEXT
      EQUIVALENCE       (KTEXT,KLINE(1))
C-----------------------------------------------------------------------
   10 IF ((.NOT.ENDFIL) .AND. (INDEX(STRING,KLINE(ICOL)).EQ.0)) THEN
        CALL RDNEXT
        GO TO 10
      ENDIF
      RETURN
C-----------------------------------------------------------------------
      END
      SUBROUTINE RDINIT(LDATA,LPRNT,LECHO)
C---- INITIALIZE READ PACKAGE
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
C-----------------------------------------------------------------------
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- FLAGS FOR I/O
      COMMON /IOFLAG/   SCAN,ERROR,SKIP,ENDFIL,INTER
      LOGICAL           SCAN,ERROR,SKIP,ENDFIL,INTER
C---- INPUT BUFFER
      COMMON /RDBUFF/   KLINE(81)
      CHARACTER*1       KLINE
      CHARACTER*80      KTEXT
      EQUIVALENCE       (KTEXT,KLINE(1))
C-----------------------------------------------------------------------
      IDATA = LDATA
      IPRNT = LPRNT
      IECHO = LECHO
      ILINE = 0
      ILCOM = 0
      ICOL  = 81
      IMARK = 1
      NWARN = 0
      NFAIL = 0
      ENDFIL = .FALSE.
      KTEXT = ' '
      KLINE(81) = ';'
      RETURN
C-----------------------------------------------------------------------
      END
      SUBROUTINE RDINT(IVAL,FLAG)
C---- DECODE UNSIGNED INTEGER
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
      LOGICAL           FLAG
C-----------------------------------------------------------------------
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- INPUT BUFFER
      COMMON /RDBUFF/   KLINE(81)
      CHARACTER*1       KLINE
      CHARACTER*80      KTEXT
      EQUIVALENCE       (KTEXT,KLINE(1))
C-----------------------------------------------------------------------
      FLAG = .TRUE.
      IVAL = 0
   10 IDIG = INDEX('0123456789',KLINE(ICOL)) - 1
      IF (IDIG .GE. 0) THEN
        IVAL = 10 * IVAL + IDIG
        FLAG = .FALSE.
        CALL RDNEXT
        GO TO 10
      ENDIF
      IF (FLAG) THEN
        CALL RDFAIL
        WRITE (IECHO,910)
      ELSE IF (INDEX('.DE',KLINE(ICOL)) .NE. 0) THEN
        CALL RDSKIP('0123456789.E')
        CALL RDFAIL
        WRITE (IECHO,920)
        FLAG = .TRUE.
        IVAL = 0
      ENDIF
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT(' *** ERROR *** UNSIGNED INTEGER EXPECTED'/' ')
  920 FORMAT(' *** ERROR *** REAL VALUE NOT PERMITTED'/' ')
C-----------------------------------------------------------------------
      END
      SUBROUTINE RDLABL(KWORD,LWORD)
C---- READ AN IDENTIFIER OR KEYWORD OF UP TO 8 CHARACTERS
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
      CHARACTER*14      KWORD
C-----------------------------------------------------------------------
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- INPUT BUFFER
      COMMON /RDBUFF/   KLINE(81)
      CHARACTER*1       KLINE
      CHARACTER*80      KTEXT
      EQUIVALENCE       (KTEXT,KLINE(1))
C-----------------------------------------------------------------------
      KWORD = '              '
      LWORD = 0
      IF (INDEX('ABCDEFGHIJKLMNOPQRSTUVWXYZ',
     +          KLINE(ICOL)) .NE. 0) THEN
   10   CONTINUE
          IF (LWORD .LT. 14) THEN
            LWORD = LWORD + 1
            KWORD(LWORD:LWORD) = KLINE(ICOL)
          ENDIF
          CALL RDNEXT
        IF (INDEX('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789''',
     +            KLINE(ICOL)) .NE. 0) GO TO 10
      ENDIF
      RETURN
C-----------------------------------------------------------------------
      END
      SUBROUTINE RDLINE
C---- READ INPUT LINE AND PRINT ECHO
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
C-----------------------------------------------------------------------
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- FLAGS FOR I/O
      COMMON /IOFLAG/   SCAN,ERROR,SKIP,ENDFIL,INTER
      LOGICAL           SCAN,ERROR,SKIP,ENDFIL,INTER
C---- INPUT BUFFER
      COMMON /RDBUFF/   KLINE(81)
      COMMON /NOECHO/   NOECHO
      COMMON/CUPLO/LOTOUP,UPTOLO(26)
      CHARACTER*26      LOTOUP
      CHARACTER*1       UPTOLO
      CHARACTER*1       KLINE
      CHARACTER*80      KTEXT
      EQUIVALENCE       (KTEXT,KLINE(1))
C-----------------------------------------------------------------------
      IF (.NOT. ENDFIL) THEN
        READ (IDATA,910,IOSTAT=ISTAT) KTEXT
        DO 1 I=1,80
          IND = INDEX(LOTOUP, KLINE(I))
          IF(IND.NE.0) KLINE(I) = UPTOLO(IND)
 1      CONTINUE
        ILINE = ILINE + 1
        IMARK = 1
        ICOL = 0
C---- READ ERROR?
        IF (ISTAT .GT. 0) THEN
          WRITE (IECHO,920) ILINE
          NFAIL = NFAIL + 1
          CALL PLEND
          CALL RDEND(102)
C---- END OF FILE?
        ELSE IF (ISTAT .LT. 0) THEN
          ENDFIL = .TRUE.
          KTEXT = '!!! END OF FILE !!!'
          ICOL = 1
C---- READ WAS OK
        ELSE IF (MOD(ILINE,5) .EQ. 0) THEN
          IF (NOECHO.EQ.0) WRITE (IECHO,930) ILINE,KTEXT
          IF (NOECHO.EQ.0) WRITE (IPRNT,930) ILINE,KTEXT
        ELSE
          IF (NOECHO.EQ.0) WRITE (IECHO,940) KTEXT
          IF (NOECHO.EQ.0) WRITE (IPRNT,940) KTEXT
        ENDIF
        KLINE(81) = ';'
      ENDIF
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT(A80)
  920 FORMAT('0*** ERROR *** READ ERROR ON LOGICAL UNIT ',I2,
     +       ', LINE ',I4,' --- EXECUTION TERMINATED')
  930 FORMAT(' ',I9,5X,A80)
  940 FORMAT(15X,A80)
C-----------------------------------------------------------------------
      END
      SUBROUTINE RDLOOK(KWORD,LWORD,KDICT,IDICT1,IDICT2,IDICT)
C---- FIND WORD "KWORD" OF LENGTH "LWORD" IN DICTIONARY "KDICT"
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
      CHARACTER*8       KDICT(*),KWORD
C-----------------------------------------------------------------------
      CHARACTER*8       KTEMP
C-----------------------------------------------------------------------
      IF (IDICT1 .EQ. 0) GO TO 20
      IF (IDICT1 .GT. IDICT2) GO TO 20
      L = MAX0(4,LWORD)
      DO 10 IDICT = IDICT1, IDICT2
        KTEMP = KDICT(IDICT)(1:L)
        IF (KWORD .EQ. KTEMP) RETURN
   10 CONTINUE
   20 IDICT = 0
      RETURN
C-----------------------------------------------------------------------
      END
      SUBROUTINE RDMON(IEND)
C     ******************************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      COMMON/CRDMON/MONAME(8),MOBEG,MOEND,MRDFLG
     >,MRDCHK
      CHARACTER*1 MONAME
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
      NCHAR=0
      NDIM=mxinp
      NDATA=1
      NIPR=1
      CALL INPUT(MONAME,NCHAR,DATA,NDIM,IEND,NDATA,NIPR)
      irdfl=data(1)
      If(irdfl.eq.0) then
      mrdflg=0
      return
      endif
      NCHAR=8
      NDATA=0
      NIPR=1
      CALL INPUT(MONAME,NCHAR,DATA,NDIM,IEND,NDATA,NIPR)
      CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NIPR)
      CALL ELPOS(ICHAR,NELPOS)
      MOBEG=NELPOS
      CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NIPR)
      CALL ELPOS(ICHAR,NELPOS)
      MOEND=NELPOS
      MRDFLG=1
c      NCHAR=0
c      NDATA=6
c      CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NIPR)
c      DO 1 IPP=1,6
c      PART(1,IPP)=DATA(IPP)
c    1 CONTINUE
c      NPART = 1
c      NCPART = 1
c      DO 122 IP=1,5
c  122 LOGPAR(IP)=.TRUE.
c      NTURN = 1
c      NCTURN = 0
c      NPRINT = -2
c      NPLOT = -2
c      CALL TRACKT
c      MRDFLG=0
      RETURN
      END
      SUBROUTINE RDNEXT
C---- FIND NEXT NON-BLANK INPUT CHARACTER
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
C-----------------------------------------------------------------------
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- FLAGS FOR I/O
      COMMON /IOFLAG/   SCAN,ERROR,SKIP,ENDFIL,INTER
      LOGICAL           SCAN,ERROR,SKIP,ENDFIL,INTER
C---- INPUT BUFFER
      COMMON /RDBUFF/   KLINE(81)
      CHARACTER*1       KLINE
      CHARACTER*80      KTEXT
      EQUIVALENCE       (KTEXT,KLINE(1))
C-----------------------------------------------------------------------
      IF (ICOL .GT. 80) CALL RDLINE
   10 CONTINUE
        IF (ENDFIL) RETURN
        IMARK = ICOL + 1
   20   CONTINUE
          ICOL = ICOL + 1
        IF (KLINE(ICOL) .EQ. ' ') GO TO 20
      IF (KLINE(ICOL) .EQ. '&') THEN
        CALL RDLINE
        GO TO 10
      ENDIF
      IF (ICOL .LE. 80) IMARK = ICOL
      IF (KLINE(ICOL) .EQ. '!' .OR.
     +    KLINE(1) .EQ. '@' .OR.
     +    KLINE(1) .EQ. '*' .OR.
     +    KLINE(1) .EQ.'(') ICOL = 81
      RETURN
C-----------------------------------------------------------------------
      END
      SUBROUTINE RDNUMB(VALUE,FLAG)
C---- DECODE A REAL NUMBER
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
      LOGICAL           FLAG
C-----------------------------------------------------------------------
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- INPUT BUFFER
      COMMON /RDBUFF/   KLINE(81)
      CHARACTER*1       KLINE
      CHARACTER*80      KTEXT
      EQUIVALENCE       (KTEXT,KLINE(1))
C-----------------------------------------------------------------------
      LOGICAL           DIG,PNT
C-----------------------------------------------------------------------
      PARAMETER         (ZERO =  0.0D0)
      PARAMETER         (ONE  =  1.0D0)
      PARAMETER         (TEN  = 10.0D0)
C-----------------------------------------------------------------------
      FLAG = .FALSE.
      VALUE = ZERO
C---- ANY NUMERIC CHARACTER?
      IF (INDEX('0123456789+-.',KLINE(ICOL)) .NE. 0) THEN
        VAL = ZERO
        SIG = ONE
        IVE = 0
        ISE = 1
        NPL = 0
        DIG = .FALSE.
        PNT = .FALSE.
C---- SIGN?
        IF (KLINE(ICOL) .EQ. '+') THEN
          CALL RDNEXT
        ELSE IF (KLINE(ICOL) .EQ. '-') THEN
          SIG = -ONE
          CALL RDNEXT
        ENDIF
C---- DIGIT OR DECIMAL POINT?
   10   IDIG = INDEX('0123456789',KLINE(ICOL)) - 1
        IF (IDIG .GE. 0) THEN
          VAL = TEN * VAL + FLOAT(IDIG)
          DIG = .TRUE.
          IF (PNT) NPL = NPL + 1
          CALL RDNEXT
          GO TO 10
        ELSE IF (KLINE(ICOL) .EQ. '.') THEN
          IF (PNT) FLAG = .TRUE.
          PNT = .TRUE.
          CALL RDNEXT
          GO TO 10
        ENDIF
        FLAG = FLAG .OR. (.NOT. DIG)
C---- EXPONENT?
        IF (INDEX('DE',KLINE(ICOL)) .NE. 0) THEN
          CALL RDNEXT
          DIG = .FALSE.
          IF (KLINE(ICOL) .EQ. '+') THEN
            CALL RDNEXT
          ELSE IF (KLINE(ICOL) .EQ. '-') THEN
            ISE = -1
            CALL RDNEXT
          ENDIF
   20     IDIG = INDEX('0123456789',KLINE(ICOL)) - 1
          IF (IDIG .GE. 0) THEN
            IVE = 10 * IVE + IDIG
            DIG = .TRUE.
            CALL RDNEXT
            GO TO 20
          ENDIF
          FLAG = FLAG .OR. (.NOT. DIG)
   30     IF (INDEX('0123456789.DE',KLINE(ICOL)) .NE. 0) THEN
            CALL RDSKIP('0123456789.DE')
            FLAG = .TRUE.
          ENDIF
        ENDIF
C---- RETURN VALUE
        IF (FLAG) THEN
          CALL RDFAIL
          WRITE (IECHO,910)
        ELSE
          VALUE = SIG * VAL * TEN ** (ISE * IVE - NPL)
        ENDIF
      ELSE
        CALL RDFAIL
        WRITE (IECHO,920)
        FLAG = .TRUE.
      ENDIF
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT(' *** ERROR *** INCORRECT REAL VALUE'/' ')
  920 FORMAT(' *** ERROR *** REAL VALUE EXPECTED'/' ')
C-----------------------------------------------------------------------
      END
      SUBROUTINE RDPARA(NDICT,DICT,ITYPE,SEEN,IVAL,RVAL,FLAG)
C---- READ PARAMETER LIST
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
C-----------------------------------------------------------------------
      CHARACTER*8       DICT(NDICT)
      INTEGER           ITYPE(NDICT),IVAL(NDICT)
      LOGICAL           SEEN(NDICT),FLAG
      DIMENSION         RVAL(NDICT)
C-----------------------------------------------------------------------
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- INPUT BUFFER
      COMMON /RDBUFF/   KLINE(81)
      CHARACTER*1       KLINE
      CHARACTER*80      KTEXT
      EQUIVALENCE       (KTEXT,KLINE(1))
C-----------------------------------------------------------------------
      CHARACTER*8       KNAME
      LOGICAL           FAIL
C-----------------------------------------------------------------------
      FLAG = .FALSE.
      DO 10 I = 1, NDICT
        SEEN(I) = .FALSE.
   10 CONTINUE
C---- SEPARATOR?
      CALL RDTEST(',;',FLAG)
      IF (FLAG) RETURN
C---- ANOTHER PARAMETER?
  100 IF (KLINE(ICOL) .EQ. ',') THEN
        CALL RDNEXT
        CALL RDWORD(KNAME,LNAME)
        IF (LNAME .EQ. 0) THEN
          CALL RDFAIL
          WRITE (IECHO,910)
          GO TO 300
        ENDIF
        CALL RDLOOK(KNAME,LNAME,DICT,1,NDICT,IDICT)
        IF (IDICT .EQ. 0) THEN
          CALL RDFAIL
          WRITE (IECHO,920) KNAME(1:LNAME)
          GO TO 300
        ENDIF
        IF (SEEN(IDICT)) THEN
          CALL RDFAIL
          WRITE (IECHO,930) KNAME(1:LNAME)
          GO TO 300
        ENDIF
C---- INTEGER VALUE
        IF (ITYPE(IDICT) .EQ. 1) THEN
          CALL RDTEST('=',FAIL)
          IF (FAIL) GO TO 300
          CALL RDNEXT
          CALL RDINT(IV,FAIL)
          IF (FAIL) GO TO 300
          IVAL(IDICT) = IV
C---- REAL VALUE
        ELSE IF (ITYPE(IDICT) .EQ. 2) THEN
          CALL RDTEST('=',FAIL)
          IF (FAIL) GO TO 300
          CALL RDNEXT
          CALL RDNUMB(RV,FAIL)
          IF (FAIL) GO TO 300
          RVAL(IDICT) = RV
C---- KEYWORD VALUE
        ELSE IF (ITYPE(IDICT) .GT. 100) THEN
          CALL RDTEST('=',FAIL)
          IF (FAIL) GO TO 300
          CALL RDNEXT
          CALL RDWORD(KNAME,LNAME)
          IF (LNAME .EQ. 0) THEN
            CALL RDFAIL
            WRITE (IECHO,940)
            GO TO 300
          ENDIF
          JBASE = ITYPE(IDICT) / 100
          JDICT = MOD(ITYPE(IDICT),100)
          CALL RDLOOK(KNAME,LNAME,DICT(JBASE+1),1,JDICT,IV)
          IF (IV .EQ. 0) THEN
            CALL RDFAIL
            WRITE (IECHO,950) KNAME(1:LNAME)
            GO TO 300
          ENDIF
          IVAL(IDICT) = IV
        ENDIF
C---- END OF FIELD
        CALL RDTEST(',;',FAIL)
        IF (FAIL) GO TO 300
        SEEN(IDICT) = .TRUE.
        GO TO 100
C---- ERROR RECOVERY
  300   CALL RDFIND(',;')
        FLAG = .TRUE.
        GO TO 100
      ENDIF
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT(' *** ERROR *** PARAMETER KEYWORD EXPECTED'/' ')
  920 FORMAT(' *** ERROR *** UNKNOWN PARAMETER KEYWORD "',A,'"'/' ')
  930 FORMAT(' *** ERROR *** DUPLICATE PARAMETER "',A,'"'/' ')
  940 FORMAT(' *** ERROR *** VALUE KEYWORD EXPECTED'/' ')
  950 FORMAT(' *** ERROR *** UNKNOWN VALUE KEYWORD "',A,'"'/' ')
C-----------------------------------------------------------------------
      END
      SUBROUTINE RDPTAB(RVAL,NMAX,N,FAIL)
C---- READ A SET OF REAL VALUES
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
      DIMENSION         RVAL(NMAX)
      LOGICAL           FAIL
C-----------------------------------------------------------------------
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- INPUT BUFFER
      COMMON /RDBUFF/   KLINE(81)
      CHARACTER*1       KLINE
      CHARACTER*80      KTEXT
      EQUIVALENCE       (KTEXT,KLINE(1))
C-----------------------------------------------------------------------
      N    = 0
      FAIL = .FALSE.
C---- MAIN LOOP
  100 CONTINUE
        CALL RDNUMB(RTEMP,FAIL)
        IF (FAIL) RETURN
        CALL RDTEST('(/,;',FAIL)
        IF (FAIL) RETURN
        IF (KLINE(ICOL) .EQ. '(') THEN
          CALL RDNEXT
          CALL RDNUMB(RSTEP,FAIL)
          IF (FAIL) RETURN
          IF (RSTEP .EQ. 0.0) THEN
            CALL RDFAIL
            WRITE (IECHO,910)
            FAIL = .TRUE.
            RETURN
          ENDIF
          CALL RDTEST(')',FAIL)
          IF (FAIL) RETURN
          CALL RDNEXT
          CALL RDNUMB(RLAST,FAIL)
          IF (FAIL) RETURN
          CALL RDTEST('/,;',FAIL)
          IF (FAIL) RETURN
          IMAX = NINT((RLAST - RTEMP) / RSTEP) + 1
        ELSE
          IMAX = 1
          RSTEP = 0.0
        ENDIF
C---- STORE REAL VALUE(S)
        IF (N + IMAX .GT. NMAX) THEN
          CALL RDFAIL
          WRITE (IECHO,920)
          FAIL = .TRUE.
          RETURN
        ENDIF
        DO 190 I = 1, IMAX
          N = N + 1
          RVAL(N) = RTEMP
          RTEMP = RTEMP + RSTEP
  190   CONTINUE
C---- ANOTHER VALUE?
      IF (KLINE(ICOL) .EQ. '/') THEN
        CALL RDNEXT
        GO TO 100
      ENDIF
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT(' *** ERROR *** ZERO STEP NOT ALLOWED'/' ')
  920 FORMAT(' *** ERROR *** TOO MANY VALUES'/' ')
C-----------------------------------------------------------------------
      END
      SUBROUTINE RDSKIP(STRING)
C---- SKIP ANY CHARACTER(S) OCCURRING IN "STRING"
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
      CHARACTER*(*)     STRING
C-----------------------------------------------------------------------
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- FLAGS FOR I/O
      COMMON /IOFLAG/   SCAN,ERROR,SKIP,ENDFIL,INTER
      LOGICAL           SCAN,ERROR,SKIP,ENDFIL,INTER
C---- INPUT BUFFER
      COMMON /RDBUFF/   KLINE(81)
      CHARACTER*1       KLINE
      CHARACTER*80      KTEXT
      EQUIVALENCE       (KTEXT,KLINE(1))
C-----------------------------------------------------------------------
   10 IF ((.NOT.ENDFIL) .AND. (INDEX(STRING,KLINE(ICOL)).NE.0)) THEN
        CALL RDNEXT
        GO TO 10
      ENDIF
      RETURN
C-----------------------------------------------------------------------
      END
      SUBROUTINE RDTEST(STRING,FLAG)
C---- NEXT INPUT CHARACTER MUST BE CONTAINED IN "STRING"
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
      CHARACTER*(*)    STRING
      LOGICAL           FLAG
C-----------------------------------------------------------------------
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- INPUT BUFFER
      COMMON /RDBUFF/   KLINE(81)
      CHARACTER*1       KLINE
      CHARACTER*80      KTEXT
      EQUIVALENCE       (KTEXT,KLINE(1))
C-----------------------------------------------------------------------
      FLAG = .FALSE.
      IF (INDEX(STRING,KLINE(ICOL)) .EQ. 0) THEN
        CALL RDFAIL
        IF (LEN(STRING) .EQ. 1) THEN
          WRITE (IECHO,910) STRING
        ELSE
          WRITE (IECHO,920) STRING
        ENDIF
        FLAG = .TRUE.
      ENDIF
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT(' *** ERROR *** "',A1,'" EXPECTED'/' ')
  920 FORMAT(' *** ERROR *** ONE OF "',A,'" EXPECTED'/' ')
C-----------------------------------------------------------------------
      END
      SUBROUTINE RDWARN
C---- MARK PLACE OF WARNING LEVEL ERROR
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
C-----------------------------------------------------------------------
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- INPUT BUFFER
      COMMON /RDBUFF/   KLINE(81)
      CHARACTER*1       KLINE
      CHARACTER*80      KTEXT
      EQUIVALENCE       (KTEXT,KLINE(1))
C-----------------------------------------------------------------------
      WRITE (IECHO,910) ILINE,KTEXT
      WRITE (IECHO,920) IMARK,(' ',I=1,IMARK),'?'
      NWARN = NWARN + 1
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT('0* LINE',I5,' * ',A80)
  920 FORMAT(' * COLUMN',I3,' *',82A1)
C-----------------------------------------------------------------------
      END

      SUBROUTINE RDWORD(KWORD,LWORD)
C---- READ AN IDENTIFIER OR KEYWORD OF UP TO 8 CHARACTERS
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
      CHARACTER*8       KWORD
C-----------------------------------------------------------------------
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- INPUT BUFFER
      COMMON /RDBUFF/   KLINE(81)
      LOGICAL           QUOTES
      CHARACTER*1       KLINE
      CHARACTER*80      KTEXT
      EQUIVALENCE       (KTEXT,KLINE(1))
C-----------------------------------------------------------------------
      KWORD = '        '
      LWORD = 0

      DO WHILE (LWORD .LT. 8)

         IF (LWORD .EQ. 0) THEN        ! test for alpha or quote
            IF (INDEX('ABCDEFGHIJKLMNOPQRSTUVWXYZ"',
     >                KLINE(ICOL)) .NE. 0) THEN    ! is alpha or quote
               IF (INDEX('"',KLINE(ICOL)) .NE. 0) THEN   ! is quote
                  QUOTES   = .TRUE.
               ELSE
                  QUOTES   = .FALSE.
               ENDIF
               LWORD = LWORD + 1
               KWORD(LWORD:LWORD) = KLINE(ICOL)
            ELSE
               GO TO 999               ! return
            ENDIF
         ELSE
            IF ( (INDEX('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789''',
     >                 KLINE(ICOL)) .NE. 0) .OR. QUOTES) THEN
               LWORD = LWORD + 1
               KWORD(LWORD:LWORD) = KLINE(ICOL)
               IF (INDEX('"',KLINE(ICOL)) .NE. 0) THEN   ! close quote
                  QUOTES   = .FALSE.
               ENDIF
            ELSE
               GO TO 999               ! return
            ENDIF
         ENDIF
         CALL RDNEXT

      END DO
  998       IF ( (INDEX('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789''',
     >                 KLINE(ICOL)) .NE. 0) .OR. QUOTES) THEN
               IF (INDEX('"',KLINE(ICOL)) .eq. 0) THEN   ! close quote
                  QUOTES   = .FALSE.
               ENDIF
              call rdnext
              goto 998
            endif
  999 RETURN
C-----------------------------------------------------------------------
      END
CC      SUBROUTINE RDWORD(KWORD,LWORD)
C---- READ AN IDENTIFIER OR KEYWORD OF UP TO 8 CHARACTERS
C-----------------------------------------------------------------------
CC      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
CC      CHARACTER*8       KWORD
C-----------------------------------------------------------------------
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
CC      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
CC     +                  NWARN,NFAIL
C---- INPUT BUFFER
CC      COMMON /RDBUFF/   KLINE(81)
CC      CHARACTER*1       KLINE
CC      CHARACTER*80      KTEXT
CC      EQUIVALENCE       (KTEXT,KLINE(1))
C-----------------------------------------------------------------------
CC      KWORD = '        '
CC      LWORD = 0
CC      IF (INDEX('ABCDEFGHIJKLMNOPQRSTUVWXYZ',
CC     +          KLINE(ICOL)) .NE. 0) THEN
CC   10   CONTINUE
CC          IF (LWORD .LT. 8) THEN
CC            LWORD = LWORD + 1
CC            KWORD(LWORD:LWORD) = KLINE(ICOL)
CC          ENDIF
CC          CALL RDNEXT
CC        IF (INDEX('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789''',
CC     +            KLINE(ICOL)) .NE. 0) GO TO 10
CC      ENDIF
CC      RETURN
C-----------------------------------------------------------------------
CC      END
      SUBROUTINE readmO(IE)
C     ******************************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      COMMON/CRDMON/MONAME(8),MOBEG,MOEND,MRDFLG
     >,MRDCHK
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      common/canal/ave(6),rms(6),scale,ianopt,ianprt
      CHARACTER*1 MONAME
      ianopt=0
      iend=-1
      call partan(iend)
      X=ave(1)
      Y=ave(3)
      sigx=rms(1)
      sigy=rms(3)
C      WRITE(IOUT,10100)IE,X,Y,sigx,sigy
      WRITE(IsOUT,10100)IE,X,Y,sigx,sigy
10100 FORMAT(' ',I6,4E12.4)
      RETURN
      END

      SUBROUTINE REFORB(IEND)
C     ******************************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON/LNGTH/TLENG,ALENG(MXELMD),ACLENG(MAXPOS)
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      COMMON/ORBIT/SIZEX,SIZEY,RMSX,RMSY,RMSIX,RMSIY,
     >RTEMPX,RTEMPY,RMSPX(5),RMSPY(5),RPX,RPY,
     >RMAXX,RMAXY,RMINX,RMINY,MAXX,MAXY,MINX,MINY,PLENG,
     >IRNG,IRANGE(5),NPRORB,IORB,IREF,IPAGE,IPOINT
      COMMON/DETL/DENER(15),NH,NV,NVH,NHVP(105),MDPRT,NDENER,
     1NUXS(45),NUX(45),NUYS(45),NUY(45),NCO,NHNVHV,MULPRT,NSIG
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      COMMON/PLT/
     1XMIN,XMAX,YMIN,YMAX,XPMIN,XPMAX,YPMIN,YPMAX,ALMIN,ALMAX,
     >DELMIN,DELMAX,DNUMIN,DNUMAX,DBMIN,DBMAX,
     2MALL,NPLOT,NCCUM,NGRAPH,NCOL,NLINE
      COMMON/CHPLT/MXXPR,MYYPR,MXY,MALE
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      PARAMETER   (mxlcnd = 200)
      PARAMETER   (mxlvar = 100)
      COMMON/LMWORK/FVEC(MXLCND),
     >DIAG(MXLVAR),FJAC(MXLCND,MXLVAR),QTF(MXLVAR),WA1(MXLVAR),
     >WA2(MXLVAR),WA3(MXLVAR),WA4(MXLCND),IPVT(MXLVAR)
      LOGICAL LOGPAR
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA, KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      COMMON /CFORB/ALCO,DELCO
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
      CHARACTER*1 NAME,LABEL
      CHARACTER*1 MALE(101,51),MXXPR(101,51),MYYPR(101,51),MXY(101,51)
      DIMENSION XA(6)
      EXTERNAL FORB
      DO 500 ILO=1,MXPART
  500 LOGPAR(ILO)=.TRUE.
      NINP=1
      DO 10 IR=1,5
      RMSPX(IR)=0.0D0
      RMSPY(IR)=0.0D0
   10 IRANGE(IR)=0
      RMAXX=0.0D0
      RMINX=0.0D0
      RMAXY=0.0D0
      RMINY=0.0D0
      NDATA=10
      NDIM=mxinp
      NCHAR=0
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NDATA,NINP)
      NPRORB=data(1)
      SIZEX=data(2)
      SIZEY=data(3)
      XCO=data(4)
      XPCO=data(5)
      YCO=data(6)
      YPCO=data(7)
      ALCO=data(8)
      DELCO=data(9)
      NPOS=data(10)
      IF(NPOS.EQ.0)GOTO 20
      NDATA=NPOS
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NDATA,NINP)
      DO 30 IR=1,NPOS
   30 IRANGE(IR)=data(IR)
   20 IF(NPRORB.GT.10) THEN
                ICO=1
                NVAR=4
                NPRORB=NPRORB-10
                IF(NPRORB.GT.10)THEN
                      NVAR=6
                      NPRORB=NPRORB-10
                ENDIF
           ELSE
                ICO=0
      ENDIF
      IF(ICO.EQ.1)THEN
                       IREF=0
                       NCOND=NVAR
                       MAXFEV=20*MAXFAC
                       INFO=200
                       NFEV=-10
                       MODE=1
                       FACTOR=100
                       LDFJAC=NVAR
                       NMPRNT=100
                       XA(1)=XCO
                       XA(2)=XPCO
                       XA(3)=YCO
                       XA(4)=YPCO
                       XA(5)=ALCO
                       XA(6)=DELCO
                       CALL LMDIF(FORB,NCOND,NVAR,XA,FVEC,TOLLSQ,TOLLSQ,
     > TOLLSQ,MAXFEV,TOLLSQ,DIAG,MODE,FACTOR,NMPRNT,INFO,NFEV,FJAC,
     > LDFJAC,IPVT,QTF,WA1,WA2,WA3,WA4)
                       XCO=XA(1)
                       XPCO=XA(2)
                       YCO=XA(3)
                       YPCO=XA(4)
                       IF(NVAR.EQ.6)THEN
                             ALCO=XA(5)
                             DELCO=XA(6)
                       ENDIF
          if(nout.ge.1)WRITE(IOUT,22000)XCO,XPCO,YCO,YPCO,ALCO,DELCO
22000 FORMAT(/,' THE FITTED CLOSED ORBIT COORDINATES ARE :',/
     >,' ',6E20.13,//)
      ENDIF
      PART(1,1)=XCO
      PART(1,2)=XPCO
      PART(1,3)=YCO
      PART(1,4)=YPCO
      PART(1,5)=ALCO
      PART(1,6)=DELCO
      NPART=1
      NCPART=1
      NTURN=1
      NCTURN=0
      NPRINT=-2
      NPLOT=-2
      IORB=0
      IPAGE=0
      IPOINT=0
      RMSX=0.0D0
      RMSY=0.0D0
      RMSIX=0.0D0
      RMSIY=0.0D0
      RPX=0.0D0
      RPY=0.0D0
      IRNG=1
      RTEMPX=0.0D0
      RTEMPY=0.0D0
      PLENG=0.0D0
      IREF=1
      IF((NPRORB.EQ.1).AND.(NOUT.GE.3))WRITE(IOUT,10000)
      IF((NPRORB.EQ.2).AND.(NOUT.GE.3))WRITE(IOUT,20000)
10000 FORMAT(//,10X,'REFERENCE ORBIT DISPLACEMENTS',//,
     >'  #    NAME        X          Y',/)
20000 FORMAT('1',20X,'REFERENCE ORBIT DISPLACEMENT PLOT')
      CALL TRACKT
      RRMSPX=(RMSIX-RTEMPX)/(TLENG-PLENG)
      RRMSPX=DSQRT(RRMSPX)
      RRMSPY=(RMSIY-RTEMPY)/(TLENG-PLENG)
      RRMSPY=DSQRT(RRMSPY)
      RMSX=DSQRT(RMSX/IPOINT)
      RMSY=DSQRT(RMSY/IPOINT)
      RMSIX=DSQRT(RMSIX/TLENG)
      RMSIY=DSQRT(RMSIY/TLENG)
      IF(NOUT.GE.1)
     >WRITE(IOUT,30000)RMSX,RMSY
30000 FORMAT(//,' THE RMS X ORBIT DISPLACEMENT IS :',E12.4,/,
     >' THE RMS Y ORBIT DISPLACEMENT IS :',E12.4,/)
      IF(NOUT.GE.1)
     >WRITE(IOUT,30001)RMSIX,RMSIY
30001 FORMAT(//,' THE INTEGRATED RMS X ORBIT DISPLACEMENT IS :',E12.4,/,
     >' THE INTEGRATED RMS Y ORBIT DISPLACEMENT IS :',E12.4,/)
      IF(NOUT.GE.1)
     >WRITE(IOUT,40001)RMAXX,(NAME(JN,NORLST(MAXX)),JN=1,8),MAXX,
     >RMINX,(NAME(JM,NORLST(MINX)),JM=1,8),MINX
40001 FORMAT(/,'  THE MAXIMUM X ORBIT DISPLACEMENT:',E12.4,
     >' OCCURS AT ELEMENT:',8A1,' #',I6,/,
     >'  THE MINIMUM X ORBIT DISPLACEMENT:',E12.4,
     >' OCCURS AT ELEMENT:',8A1,' #',I6,/)
      IF(NOUT.GE.1)
     >WRITE(IOUT,40002)RMAXY,(NAME(JN,NORLST(MAXY)),JN=1,8),MAXY,
     >RMINY,(NAME(JM,NORLST(MINY)),JM=1,8),MINY
40002 FORMAT(/,'  THE MAXIMUM Y ORBIT DISPLACEMENT:',E12.4,
     >' OCCURS AT ELEMENT:',8A1,' #',I6,/,
     >'  THE MINIMUM Y ORBIT DISPLACEMENT:',E12.4,
     >' OCCURS AT ELEMENT:',8A1,' #',I6,/)
      IF(NPOS.EQ.0)RETURN
      IPPOS=0
      DO 100 IPR=1,NPOS
      RPRX=DSQRT(RMSPX(IPR))
      RPRY=DSQRT(RMSPY(IPR))
      IF(NOUT.GE.1)
     >WRITE(IOUT,30002)IPPOS,IRANGE(IPR),RPRX,RPRY
30002 FORMAT(' BETWEEN POSITION',I4,'  AND POSITION',I4,/,
     >' THE INTEGRATED RMS X ORBIT DISPLACEMENT IS :',E12.4,/,
     >' THE INTEGRATED RMS Y ORBIT DISPLACEMENT IS :',E12.4,/)
      IPPOS=IRANGE(IPR)
  100 CONTINUE
      IF(NOUT.GE.1)
     >WRITE(IOUT,30003)IRANGE(NPOS),NELM,RRMSPX,RRMSPY
30003 FORMAT(' BETWEEN POSITION',I4,'  AND POSITION',I4,/,
     >' THE INTEGRATED RMS X ORBIT DISPLACEMENT IS :',E12.4,/,
     >' THE INTEGRATED RMS Y ORBIT DISPLACEMENT IS :',E12.4,/)
      RETURN
      END
      SUBROUTINE RES
C     ******************************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/TRI/WCO(15,6),GEN(5,4),PGEN(75,6),DIST,
     <A1(15),B1(15),A2(15),B2(15),XCOR(3,15),XPCOR(3,15),
     1AL1(15),AL2(15),MESH,NIT,NENER,NITX,NITS,NITM1,NANAL,NOPRT
      COMMON/CLSQ/ALSQ(15,2,4),IXY,NCOEF,NAPLT,JENER,LENER(15)
      LOGICAL LENER
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      IF(NANAL.EQ.3) GO TO 3
      IF(NOUT.GE.1)
     >WRITE(IOUT,10000)
10000 FORMAT(///,20X,'ORDER TWO RESONANCE STUDY : C.O. ASSUMED ',
     <' CENTERED BETWEEN BOTH UNSTABLE ORBITS  ',//)
      DO 1 JEN=1,NENER
      EN=WCO(JEN,6)
      IF(.NOT.LENER(JEN)) GO TO 5
      IF(NOUT.GE.1)
     >WRITE(IOUT,10004)EN
10004 FORMAT(' *** ANALYSIS FOR ENERGY ',F10.6,' NOT DONE :',
     <' MOVEMENT IS STABLE ')
      GO TO 1
    5 X0=WCO(JEN,1)
      XP0=WCO(JEN,2)
      X1 = XCOR(1,JEN)
      XP1 = XPCOR(1,JEN)
      XMID=0.5D0*(X0+X1)
      XPMID=0.5D0*(XP0+XP1)
      AJ1 = A1(JEN)
      BJ1 = B1(JEN)
      AJ2 = A2(JEN)
      BJ2 = B2(JEN)
      IF(NOUT.GE.1)
     >WRITE(IOUT,10001)EN,X0,XP0,X1,XP1,XMID,XPMID
10001 FORMAT(//,20X,'ANALYSIS FOR ENERGY : ',
     >F10.6,//,'   CLOSED ORBITS ARE : ',/,
     >'   X1 = ',E20.12,'   XP1 = ',E20.12,/,
     >'   X2 = ',E20.12,'   XP2 = ',E20.12,//,
     >' STABLE ORBIT IS : ',/,
     >'   X0 = ',E20.12,'   XP0 = ',E20.12,/)
      IF(NOUT.GE.3)
     >WRITE(IOUT,10020)
10020 FORMAT(/,'  THE COORDINATES OF PAIRS OF TWO POINTS ADJACENT TO ',
     >' THE FIRST FIXED POINT',/,'  TO BE USED IN SEPARATRIX TRACING',
     >'  AND PITCH DETERMINATION ARE : ',//)
      FACT1=DSQRT((X0**2+XP0**2)/(AJ1**2+BJ1**2))/100.0D0
      AL = AL1(JEN)
      ALI=(AL-1.0D0)/5.0D0
      DO 100 ICO = 1,5
      FACT = FACT1/(1.0D0 +ALI*(ICO-1))
      XO1=X0+AJ1*FACT
      XO2=X0-AJ1*FACT
      XOP1=XP0+BJ1*FACT
      XOP2=XP0-BJ1*FACT
      IPP=2*ICO-1
      PART(IPP,1)=XO1
      PART(IPP,2)=XOP1
      PART(IPP,3)=0.0D0
      PART(IPP,4)=0.0D0
      PART(IPP,5)=0.0D0
      PART(IPP,6)=WCO(1,6)
      DEL(IPP)=WCO(1,6)
      LOGPAR(IPP)=.TRUE.
      PART(IPP+1,1)=XO2
      PART(IPP+1,2)=XOP2
      PART(IPP+1,3)=0.0D0
      PART(IPP+1,4)=0.0D0
      PART(IPP+1,5)=0.0D0
      PART(IPP+1,6)=WCO(1,6)
      DEL(IPP+1)=WCO(1,6)
      LOGPAR(IPP+1)=.TRUE.
      IF(NOUT.GE.3)
     >WRITE(IOUT,10002)XO1,XOP1,XO2,XOP2
  100 CONTINUE
      NPART=10
      NCPART=10
      NTURN=1
      NCTURN=1
10002 FORMAT(
     >'   X1 = ',E20.12,'   XP1 = ',E20.12,/,
     >'   X2 = ',E20.12,'   XP2 = ',E20.12)
      DENOM =(AJ1*BJ2-BJ1*AJ2)*3.0D0
      XA=X0-XMID
      XPA=XP0-XPMID
      ANUM=8.0D0*((AJ1*BJ2+BJ1*AJ2)*XA*XPA
     <        -AJ1*AJ2*XPA*XPA-BJ1*BJ2*XA*XA)
      AREA=DABS(ANUM/DENOM)
      IF(NOUT.GE.1)
     >WRITE(IOUT,10003)AREA
10003 FORMAT(/,'   THE STABLE AREA ENCLOSED BY THE SEPARATRICES IS ',
     <E12.4,/)
    1 CONTINUE
      GO TO 4
    3 IF(NOUT.GE.1)
     >WRITE(IOUT,10011)
10011 FORMAT(///,20X,' ORDER THREE RESONANCE STUDY ',//)
      DO 10 JEN=1,NENER
      EN = WCO(JEN,6)
      IF(.NOT.LENER(JEN))GO TO 15
      IF(NOUT.GE.1)
     >WRITE(IOUT,10004)EN
      GO TO 10
   15 X0=WCO(JEN,1)
      XP0 =WCO(JEN,2)
      X1=XCOR(1,JEN)
      XP1=XPCOR(1,JEN)
      X2=XCOR(2,JEN)
      XP2=XPCOR(2,JEN)
      IF(NOUT.GE.1)
     >WRITE(IOUT,10010)EN,X0,XP0,X1,XP1,X2,XP2
10010 FORMAT(//,20X,'  ANALYSIS FOR ENERGY : ',
     <F10.6,//,'    CLOSED ORBITS ARE  : ',/,
     <'    X1 = ',E20.12,'    XP1 = ',E20.12,/,
     <'    X2 = ',E20.12,'    XP2 = ',E20.12,/,
     <'    X3 = ',E20.12,'    XP3 = ',E20.12,/)
      AJ1=A1(JEN)
      BJ1=B1(JEN)
      AJ2=A2(JEN)
      BJ2 = B2(JEN)
      FACT1=DSQRT((X0**2+XP0**2)/(AJ1**2+BJ1**2))/100.0D0
      IF(NOUT.GE.3)
     >WRITE(IOUT,10020)
      AL = AL1(JEN)
      ALI=(AL-1.0D0)/5.0D0
      DO 101 ICO = 1,5
      FACT = FACT1/(1.0D0 +ALI*(ICO-1))
      XO1=X0+AJ1*FACT
      XO2=X0-AJ1*FACT
      XOP1=XP0+BJ1*FACT
      XOP2=XP0-BJ1*FACT
      IPP=2*ICO-1
      PART(IPP,1)=XO1
      PART(IPP,2)=XOP1
      PART(IPP,3)=0.0D0
      PART(IPP,4)=0.0D0
      PART(IPP,5)=0.0D0
      PART(IPP,6)=WCO(1,6)
      DEL(IPP)=WCO(1,6)
      LOGPAR(IPP)=.TRUE.
      PART(IPP+1,1)=XO2
      PART(IPP+1,2)=XOP2
      PART(IPP+1,3)=0.0D0
      PART(IPP+1,4)=0.0D0
      PART(IPP+1,5)=0.0D0
      PART(IPP+1,6)=WCO(1,6)
      DEL(IPP+1)=WCO(1,6)
      LOGPAR(IPP+1)=.TRUE.
      IF(NOUT.GE.3)
     >WRITE(IOUT,10002)XO1,XOP1,XO2,XOP2
      NPART=10
      NCPART=10
      NTURN=1
      NCTURN=1
  101 CONTINUE
      AREA=DABS(0.5D0*(X0*XP1-X1*XP0+X1*XP2-X2*XP1+X2*XP0-X0*XP2))
      IF(NOUT.GE.1)
     >WRITE(IOUT,10003)AREA
   10 CONTINUE
    4 RETURN
      END
      SUBROUTINE RMAT(IE,ILIST)
C     ******************************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      COMMON/CRMAT/ACIN(6),AINC(6),ACOUT(6),eps1,eps2,
     >betix,alphix,epsix,betiy,alphiy,epsiy,
     >  IFLMAT,NRMPRT,NRMORD,nmopt
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/LNGTH/TLENG,ALENG(MXELMD),ACLENG(MAXPOS)
      DIMENSION BEGM(6,6),ENDM(6,6),L(6),M(6)
      dimension ab(4,4),v(4,4),vi(4,4),vvi(4,4),tr(4,4)
      dimension bm(4,4),bmt(4,4),s(4,4)
      dimension bi(4,4),bim(4,4),be(4,4),bet(4,4)
      IEP1=IE+1
      IPRT=0
      IZERO=0
      NEXTLO=0
      jlist=ilist
      call prttst(ie,jlist,mprt)
      IF(NRMPRT.le.0) THEN
            IF(IE.EQ.NELM) THEN
                   IPRT=3
                           ELSE
                   IPRT=0
            ENDIF
                       ELSE
            IF(ILIST.GT.2*NRMPRT)RETURN
            LIMLO=NLIST(ILIST)
            LIMUP=NLIST(ILIST+1)
            IF((ILIST+2).LE.2*NRMPRT)NEXTLO=NLIST(ILIST+2)
            IF(LIMLO.EQ.LIMUP) THEN
                  IF(IE.EQ.LIMLO) THEN
                      IPRT=3
                      ILIST=ILIST+2
                                  ELSE
                      IPRT=0
                  ENDIF
                               ELSE
                  IPRT=0
                  IF((IE.EQ.1).AND.(LIMLO.EQ.1)) IPRT=11
                  IF(IEP1.EQ.LIMLO) IZERO=1
                  IF(IE.EQ.LIMUP) THEN
                      IF(IEP1.EQ.NEXTLO)IZERO=1
                      IPRT=2
                      ILIST=ILIST+2
                  ENDIF
            ENDIF
      ENDIF
      if((iprt.eq.0).and.(mprt.eq.1))iprt=3
      IF((IPRT.EQ.0).AND.(IZERO.EQ.0)) RETURN
      IF(IPRT.EQ.11) THEN
           DO 11 IM=1,6
           DO 21 JM=1,6
  21       BEGM(IM,JM)=0.0D0
  11       BEGM(IM,IM)=1.0D0
           BLEN=0.0D0
           RETURN
      ENDIF
      IF(IPRT.EQ.2) THEN
           DO 2 IM=1,6
           ACOUT(IM)=PART(1,IM)
           DO 2 JM=1,6
           ENDM(IM,JM)=(PART(JM+1,IM)-PART(1,IM))/AINC(JM)
    2      CONTINUE
           CLEN=ACLENG(IE)-BLEN
           CALL DMINV(BEGM,6,D,L,M)
           DO 12 IM=1,6
           DO 12 JM=1,6
           TEMP(IM,JM)=0.0D0
           DO 12 KM=1,6
   12      TEMP(IM,JM)=TEMP(IM,JM)+ENDM(IM,KM)*BEGM(KM,JM)
      ENDIF
      IF(IPRT.EQ.3) THEN
           DO 3 IM=1,6
           ACOUT(IM)=PART(1,IM)
           DO 3 JM=1,6
           TEMP(IM,JM)=(PART(JM+1,IM)-PART(1,IM))/AINC(JM)
    3      CONTINUE
           CLEN=ACLENG(IE)
      ENDIF
      NORDER=1
      NMAT=-1
      IF(IPRT.NE.0) THEN
      IF(NRMORD.GT.10) NMAT=1
      IF(NOUT.GE.1)WRITE(IOUT,10101)IE,(NAME(ICH,NORLST(IE)),ICH=1,8)
10101 FORMAT(' AFTER ELEMENT :',I6,1X,8A1)
      CALL PRCO(ACIN,NMAT,1)
           DO 22 IM=1,6
           DO 22 JM=7,27
   22      TEMP(IM,JM)=0.0D0
      CALL PRMAT(TEMP,NMAT,NORDER,CLEN)
      DETA=TEMP(1,1)*TEMP(2,2)-TEMP(1,2)*TEMP(2,1)
      DETB=TEMP(1,3)*TEMP(2,4)-TEMP(1,4)*TEMP(2,3)
      DETD=TEMP(3,3)*TEMP(4,4)-TEMP(3,4)*TEMP(4,3)
      DETC=TEMP(3,1)*TEMP(4,2)-TEMP(3,2)*TEMP(4,1)
      IF(NOUT.GE.1)WRITE(IOUT,10100)DETA,DETB,DETC,DETD
10100 FORMAT(/,' DET A=',F7.3,' DET B=',F7.3,
     >' DET C=',F7.3,' DET D=',F7.3,/)
      CALL PRCO(ACOUT,NMAT,2)
      ENDIF
      if(nmopt.lt.1)goto 300
      write(iout,10510)
10510 format(/,' Symplectic check',/)
      do 501 is=1,4
      do 501 js=1,1
  501 S(is,js)=0.0d0
      S(1,2)=1.0d0
      S(2,1)=-1.0d0
      S(3,4)=1.0d0
      S(4,3)=-1.0d0
      do 510 is=1,4
      do 511 js=1,4
      tr(is,js)=0.0d0
      do 512 ks=1,4
      sumkj=0.0d0
      do 513 ls=1,4
513   sumkj=sumkj+s(ks,ls)*temp(js,ls)
512   tr(is,js)=tr(is,js)+temp(is,ks)*sumkj
      tr(is,js)=tr(is,js)-S(is,js)
511   continue
      write(iout,10511)(tr(is,mv),mv=1,4)
10511 format(4e14.6)
510   continue
      write(iout,10512)
10512 format(/)

      bm11=temp(1,1)
      bm12=temp(1,2)
      bm21=temp(2,1)
      bm22=temp(2,2)
      bn11=temp(3,3)
      bn12=temp(3,4)
      bn21=temp(4,3)
      bn22=temp(4,4)
      sn11=temp(3,1)
      sn12=temp(3,2)
      sn21=temp(4,1)
      sn22=temp(4,2)
      sm11=temp(1,3)
      sm12=temp(1,4)
      sm21=temp(2,3)
      sm22=temp(2,4)
      snp11=sn22
      snp12=-sn12
      snp21=-sn21
      snp22=sn11
      idet=1
      detmpn=(sm11+snp11)*(sm22+snp22)-(sm12+snp12)*(sm21+snp21)
      if(detmpn.lt.0.0d0) then
       write(iout,*)' determinant m + n+ is negative '
        detmpn=-detmpn
        idet=-1
      endif
      write(iout,*)' detmpn ',detmpn,idet
      if(detmpn.eq.0.0d0) then
       write(iout,*)' determinant m + n+ is zero '
       goto 300
      endif
      delta=dsqrt(detmpn)
      d11=(sm11+snp11)/delta
      d12=(sm12+snp12)/delta
      d21=(sm21+snp21)/delta
      d22=(sm22+snp22)/delta
      trd=d11+d22
      write(iout,*)' d11 = ',d11,' d22 = ',d22,' trd = ',trd
      dp11=d22
      dp12=-d12
      dp21=-d21
      dp22=d11
      trMsN=0.5d0*(bm11-bn11+bm22-bn22)
      t2phi=-delta/trMsN
      if(idet.eq.1) then
        phi=-0.5d0*datan2(dsign(delta,trMsN),dabs(trMsN))
        tphi=dtan(phi)
        cphi=dcos(phi)
        sphi=dsin(phi)
                    else
        if(dabs(t2phi).ge.1.0d0) then
            write(iout,*)' t2phi = ',t2phi,' >1 '
            write(iout,*)
     >      ' motion is unstable with complex eigenvalues! '
            er=0.5d0*(bm11+bm22+bn11+bn22)
            ei=dsqrt(dabs(trMsN**2-delta**2))
            rho=dsqrt(er*er+ei*ei)
            rhoinv=1.0d0/rho
            theta=datan2(ei,er)
            write(iout,*)' the eigenvalues are '
            write(iout,*)rho,' +i ',theta
            write(iout,*)rhoinv,' -i ',theta
            write(iout,*)rho,' -i ',theta
            write(iout,*)rhoinv,' +i ',theta
            goto 300
        endif
        phi=0.25d0*(dlog(1.0d0+t2phi)-dlog(1.0d0-t2phi))
        tphi=dtanh(phi)
        cphi=dcosh(phi)
        sphi=dsinh(phi)
      endif
      write(iout,*)' phi ', phi
      write(iout,*)' tphi ', tphi
      write(iout,*)' cphi ', cphi
      write(iout,*)' sphi ', sphi
      a11=bm11-(d11*sn11+d12*sn21)*tphi
      a12=bm12-(d11*sn12+d12*sn22)*tphi
      a21=bm21-(d21*sn11+d22*sn21)*tphi
      a22=bm22-(d21*sn12+d22*sn22)*tphi
      b11=bn11+(dp11*sm11+dp12*sm21)*tphi
      b12=bn12+(dp11*sm12+dp12*sm22)*tphi
      b21=bn21+(dp21*sm11+dp22*sm21)*tphi
      b22=bn22+(dp21*sm12+dp22*sm22)*tphi
      deta=a11*a22-a12*a21
      detb=b11*b22-b12*b21
      detd=d11*d22-d12*d21
      write(iout,10200)tphi,deta,detb,detd
10200 format(/,4e14.6,/)
      v(1,1)=cphi
      v(1,2)=0.0d0
      v(1,3)=d11*sphi
      v(1,4)=d12*sphi
      v(2,1)=0.0d0
      v(2,2)=cphi
      v(2,3)=d21*sphi
      v(2,4)=d22*sphi
      v(3,1)=-dp11*sphi
      v(3,2)=-dp12*sphi
      v(3,3)=cphi
      v(3,4)=0.0d0
      v(4,1)=-dp21*sphi
      v(4,2)=-dp22*sphi
      v(4,3)=0.0d0
      v(4,4)=cphi
      vi(1,1)=cphi
      vi(1,2)=0.0d0
      vi(1,3)=-d11*sphi
      vi(1,4)=-d12*sphi
      vi(2,1)=0.0d0
      vi(2,2)=cphi
      vi(2,3)=-d21*sphi
      vi(2,4)=-d22*sphi
      vi(3,1)=dp11*sphi
      vi(3,2)=dp12*sphi
      vi(3,3)=cphi
      vi(3,4)=0.0d0
      vi(4,1)=dp21*sphi
      vi(4,2)=dp22*sphi
      vi(4,3)=0.0d0
      vi(4,4)=cphi
      do 200 iv=1,4
      do 201 jv=1,4
      vvi(iv,jv)=0.0d0
      do 202 kv=1,4
202   vvi(iv,jv)=vvi(iv,jv)+v(iv,kv)*vi(kv,jv)
201   continue
      write(iout,10201)(vvi(iv,lv),lv=1,4)
10201 format(' ',4e14.6)
200   continue
      ab(1,1)=a11
      ab(1,2)=a12
      ab(1,3)=0.0d0
      ab(1,4)=0.0d0
      ab(2,1)=a21
      ab(2,2)=a22
      ab(2,3)=0.0d0
      ab(2,4)=0.0d0
      ab(3,1)=0.0d0
      ab(3,2)=0.0d0
      ab(3,3)=b11
      ab(3,4)=b12
      ab(4,1)=0.0d0
      ab(4,2)=0.0d0
      ab(4,3)=b21
      ab(4,4)=b22
      write(iout,10220) a11,a12,a21,a22
10220 format(/,' matrix a is ',/,' ',4e14.6,/)
      write(iout,10230) b11,b12,b21,b22
10230 format(/,' matrix b is ',/,' ',4e14.6,/)
      do 210 iv=1,4
      do 211 jv=1,4
      tr(iv,jv)=0.0d0
      do 212 kv=1,4
      sumkj=0.0d0
      do 213 lv=1,4
213   sumkj=sumkj+ab(kv,lv)*vi(lv,jv)
212   tr(iv,jv)=tr(iv,jv)+v(iv,kv)*sumkj
211   continue
      write(iout,10210)(tr(iv,mv),mv=1,4)
10210 format(' ',4e14.6)
210   continue
      cos1=0.5d0*(a11+a22)
      nstab1=0
      if(dabs(cos1).ge.1.0d0) then
        write(iout,10400)
10400 format(' ',' motion 1 is unstable, analysis stopped ')
        nstab1=1
        goto 401
      endif
      sin1=dsqrt(1.0d0-cos1*cos1)
      sin1=dsign(sin1,a12)
      amu1=datan2(sin1,cos1)
      if(amu1.lt.0.0d0) amu1=amu1+twopi
      beta1=a12/sin1
      alph1=0.5d0*(a11-a22)/sin1
      anu1=amu1/twopi
      write(iout,10401)amu1,anu1,beta1,alph1
10401 format(/,' ','mu1 = ',e10.3,' nu1 = ',e10.3,' beta1 = ',
     > e10.3,' alpha1 = ',e10.3,/)
401   cos2=0.5d0*(b11+b22)
      nstab2=0
      if(dabs(cos2).ge.1.0d0) then
        write(iout,10402)
10402 format(' ',' motion 2 is unstable, analysis stopped ')
        nstab2=1
        goto 402
      endif
      sin2=dsqrt(1.0d0-cos2*cos2)
      sin2=dsign(sin2,b12)
      amu2=datan2(sin2,cos2)
      if(amu2.lt.0.0d0) amu2=amu2+twopi
      beta2=b12/sin2
      alph2=0.5d0*(b11-b22)/sin2
      anu2=amu2/twopi
      write(iout,10403)amu2,anu2,beta2,alph2
10403 format(/,' ','mu2 = ',e10.3,' nu2 = ',e10.3,' beta2 = ',
     > e10.3,' alpha2 = ',e10.3,/)
402   if((nstab1.eq.1).or.(nstab2.eq.1)) goto 300
      gam1=(1.0d0+alph1*alph1)/beta1
      gam2=(1.0d0+alph2*alph2)/beta2
      bm(1,1)=beta1*eps1
      bm(1,2)=-alph1*eps1
      bm(1,3)=0.0d0
      bm(1,4)=0.0d0
      bm(2,1)=-alph1*eps1
      bm(2,2)=gam1*eps1
      bm(2,3)=0.0d0
      bm(2,4)=0.0d0
      bm(3,1)=0.0d0
      bm(3,2)=0.0d0
      bm(3,3)=beta2*eps2
      bm(3,4)=-alph2*eps2
      bm(4,1)=0.0d0
      bm(4,2)=0.0d0
      bm(4,3)=-alph2*eps2
      bm(4,4)=gam2*eps2
      do 410 iv=1,4
      do 411 jv=1,4
      bmt(iv,jv)=0.0d0
      do 412 kv=1,4
      sumkj=0.0d0
      do 413 lv=1,4
413   sumkj=sumkj+bm(kv,lv)*v(jv,lv)
412   bmt(iv,jv)=bmt(iv,jv)+v(iv,kv)*sumkj
411   continue
      write(iout,10410)(bmt(iv,mv),mv=1,4)
10410 format(' ',4e14.6)
410   continue
      epsx=dsqrt(bmt(1,1)*bmt(2,2)-bmt(1,2)*bmt(2,1))
      epsy=dsqrt(bmt(3,3)*bmt(4,4)-bmt(3,4)*bmt(4,3))
      write(iout,10411)eps1,eps2,epsx,epsy
10411 format(/,'  eps1 = ',e10.3,' eps2 = ',e10.3,' epsx = ',e10.3,
     > ' epsy = ',e10.3,/)
      gamix=(1.0d0+alphix*alphix)/betix
      gamiy=(1.0d0+alphiy*alphiy)/betiy
      bi(1,1)=betix*epsix
      bi(1,2)=-alphix*epsix
      bi(1,3)=0.0d0
      bi(1,4)=0.0d0
      bi(2,1)=-alphix*epsix
      bi(2,2)=gamix*epsix
      bi(2,3)=0.0d0
      bi(2,4)=0.0d0
      bi(3,1)=0.0d0
      bi(3,2)=0.0d0
      bi(3,3)=betiy*epsiy
      bi(3,4)=-alphiy*epsiy
      bi(4,1)=0.0d0
      bi(4,2)=0.0d0
      bi(4,3)=-alphiy*epsiy
      bi(4,4)=gamiy*epsiy
      do 710 iv=1,4
      do 711 jv=1,4
      bim(iv,jv)=0.0d0
      do 712 kv=1,4
      sumkj=0.0d0
      do 713 lv=1,4
713   sumkj=sumkj+bi(kv,lv)*vi(jv,lv)
712   bim(iv,jv)=bim(iv,jv)+vi(iv,kv)*sumkj
711   continue
      write(iout,10410)(bim(iv,mv),mv=1,4)
710   continue
      epsmx=dsqrt(bim(1,1)*bim(2,2)-bim(1,2)*bim(2,1))
      betmx=bim(1,1)/epsmx
      gammx=bim(2,2)/epsmx
      alphmx=-bim(1,2)/epsmx
      epsmy=dsqrt(bim(3,3)*bim(4,4)-bim(3,4)*bim(4,3))
      betmy=bim(3,3)/epsmy
      gammy=bim(4,4)/epsmy
      alphmy=-bim(3,4)/epsmy
      d1=0.5d0*(betmx*gam1+gammx*beta1-2.0d0*alph1*alphmx)
      d2=0.5d0*(betmy*gam2+gammy*beta2-2.0d0*alph2*alphmy)
      epsi1=epsmx*(d1+dsqrt(d1*d1-1.0d0))
      epsi2=epsmy*(d2+dsqrt(d2*d2-1.0d0))
      be(1,1)=betmx*epsmx
      be(1,2)=-alphmx*epsmx
      be(1,3)=0.0d0
      be(1,4)=0.0d0
      be(2,1)=-alphmx*epsmx
      be(2,2)=gammx*epsmx
      be(2,3)=0.0d0
      be(2,4)=0.0d0
      be(3,1)=0.0d0
      be(3,2)=0.0d0
      be(3,3)=betmy*epsmy
      be(3,4)=-alphmy*epsmy
      be(4,1)=0.0d0
      be(4,2)=0.0d0
      be(4,3)=-alphmy*epsmy
      be(4,4)=gammy*epsmy
      do 610 iv=1,4
      do 611 jv=1,4
      bet(iv,jv)=0.0d0
      do 612 kv=1,4
      sumkj=0.0d0
      do 613 lv=1,4
613   sumkj=sumkj+be(kv,lv)*v(jv,lv)
612   bet(iv,jv)=bet(iv,jv)+v(iv,kv)*sumkj
611   continue
      write(iout,10410)(bet(iv,mv),mv=1,4)
610   continue
      epsex=dsqrt(bet(1,1)*bet(2,2)-bet(1,2)*bet(2,1))
      epsey=dsqrt(bet(3,3)*bet(4,4)-bet(3,4)*bet(4,3))
      write(iout,10611)epsex,epsey,epsix,epsiy
10611 format(/,'  epsex = ',e10.3,' epsex = ',e10.3,' epsix = ',e10.3,
     > ' epsiy = ',e10.3,/)

300   IF(IZERO.EQ.1) THEN
           DO 1 IM=1,6
           ACIN(IM)=PART(1,IM)
           DO 1 JM=1,6
           BEGM(IM,JM)=(PART(JM+1,IM)-PART(1,IM))/AINC(JM)
    1      CONTINUE
           BLEN=ACLENG(IE)
      ENDIF
      RETURN
      END
      SUBROUTINE RMOCHK(IE)
C     ******************************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/CRDMON/MONAME(8),MOBEG,MOEND,MRDFLG
     >,MRDCHK
      CHARACTER*1 MONAME
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL,ISTAR
      DATA ISTAR /'*'/
      MRDCHK=0
      IF((IE.GE.MOBEG).AND.(IE.LE.MOEND)) THEN
        NEL=NORLST(IE)
        DO 1 IN=1,8
        IF(MONAME(IN).EQ.ISTAR)GO TO 3
        IF (NAME(IN,NEL).NE.MONAME(IN)) GOTO 2
    1   CONTINUE
    3   MRDCHK=1
      ENDIF
    2 RETURN
      END

      SUBROUTINE RMPRE(IEND)
C     ********************************
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      common/cprt/prnam(8,10),kodprt(2),
     >   iprtfl,intfl,itypfl,namfl,inam,itkod
      character*1 prnam
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/LNGTH/TLENG,ALENG(MXELMD),ACLENG(MAXPOS)
      COMMON/PLT/
     1XMIN,XMAX,YMIN,YMAX,XPMIN,XPMAX,YPMIN,YPMAX,ALMIN,ALMAX,
     >DELMIN,DELMAX,DNUMIN,DNUMAX,DBMIN,DBMAX,
     2MALL,NPLOT,NCCUM,NGRAPH,NCOL,NLINE
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      COMMON/CRMAT/ACIN(6),AINC(6),ACOUT(6),eps1,eps2,
     >betix,alphix,epsix,betiy,alphiy,epsiy,
     >  IFLMAT,NRMPRT,NRMORD,nmopt
      COMMON /CTUNE/DNU0X,DNU0Y,DBETX,DBETY,DALPHX,DALPHY,
     >DXCO,DXPCO,DYCO,DYPCO,DDELCO
      CHARACTER*1 ICHAR
      NOP=-1
      NCHAR=0
      NIPR=1
      CALL INPUT(ICHAR,NCHAR,DATA,MXINP,IEND,NOP,NIPR)
      DO 10 IC=1,6
      ACIN(IC)=DATA(IC)
      AINC(IC)=DATA(IC+6)
   10 CONTINUE
      IF(DATA(6).EQ.1.0D0) THEN
       ACIN(1)=DXCO
       ACIN(2)=DXPCO
       ACIN(3)=DYCO
       ACIN(4)=DYPCO
       ACIN(5)=0.0D0
       ACIN(6)=DDELCO
      ENDIF
      NRMORD=DATA(13)
      NRMPRT=DATA(14)
      itst=14+2*nrmprt
      if(nrmprt.lt.0)itst=14
      if(nop.eq.itst) then
        nmopt=0
                      else
        nmopt=data(itst+1)
      endif
      if(nmopt.ge.1) then
        eps1=data(16+2*nrmprt)
        eps2=data(17+2*nrmprt)
        betix=data(18+2*nrmprt)
        alphix=data(19+2*nrmprt)
        epsix=data(20+2*nrmprt)
        betiy=data(21+2*nrmprt)
        alphiy=data(22+2*nrmprt)
        epsiy=data(23+2*nrmprt)
      endif
      if(iprtfl.eq.0)then
      IF(NRMPRT.GT.0) THEN
         DO 1 IRMIN=1,NRMPRT
         NLIST(2*IRMIN-1)=DATA(2*IRMIN+13)
         NLIST(2*IRMIN)  =DATA(2*IRMIN+14)
    1    CONTINUE
      ENDIF
                     else
         nrmprt=mlocat
      endif
      IFLMAT=1
      NPLOT=-1
      NPRINT=-2
      NTURN=1
      NCTURN=0
      NPART=7
      NCPART=7
      DO 2 IRMP=1,MXPART
      LOGPAR(IRMP)=.TRUE.
      DO 3 JIP=1,6
      PART(IRMP,JIP)=0.0D0
    3 CONTINUE
    2 CONTINUE
      DO 4 IRMP=1,7
      DO 4 JRMP=1,6
      PART(IRMP,JRMP)=ACIN(JRMP)
    4 CONTINUE
      DO 41 JRMP=1,6
   41 PART(JRMP+1,JRMP)=PART(JRMP+1,JRMP)+AINC(JRMP)
      CALL TRACKT
      IF(NCPART.EQ.0) THEN
        WRITE(IOUT,99999)
99999 FORMAT(/,'  ALL PARTICLES WERE LOST, JOB IS ABORTED ',/)
        CALL HALT(288)
      ENDIF
      IFLMAT=0
      RETURN
      END
      SUBROUTINE SCRCLR
C     ******************************
      IMPLICIT REAL*8(A-H,O-Z), integer(i-n)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      common/cterm/imach,idt,idigit(10),esc
      CHARACTER*1 ESC,IDIGIT,CBSCR(19)
      CHARACTER*19 BLKSCR
      CHARACTER*1 CSCR(4)
      EQUIVALENCE (CBSCR(16),CSCR(1)),(CBSCR(1),BLKSCR)
      DATA BLKSCR /'WRTASCI(TR STR     '/
      write(isout,*)idt,imach
      GOTO(100,200),IDT
      WRITE(ISOUT,10001)IDT
10001 FORMAT(' ERROR ON TERMINAL ID IN SCRCLR : ',I3)
      CALL HALT(235)
  100 CONTINUE
C     QVT102
      CSCR(1)=ESC
      CSCR(2)='*'
      CSCR(3)=CHAR(0)
      CSCR(4)=CHAR(0)
      GOTO 1000
  200 CONTINUE
C     VT100
      CSCR(1)=ESC
      CSCR(2)='['
      CSCR(3)='2'
      CSCR(4)='J'
      GOTO 1000
 1000 IF(IMACH.EQ.2)WRITE(ISOUT,10002)CSCR
      IF(IMACH.EQ.1)IK=KMAND(BLKSCR,19)
10002 FORMAT(' ',4A1)
      RETURN
      END
      SUBROUTINE SEED(IEND)
C     ********************************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER  (mxmis = 1000)
      COMMON/MIS/RMISA(8,MXMIS),MISELE(MXMIS),NMIS,NOPT,
     >NMISE,MISSEL(MXMIS),NMRNGE(MXMIS),
     >MSRNGE(2,10,MXMIS),MISFLG,MCHFLG
      COMMON/CSEEDS/ISEED,IXG,IXS,IXMSTP,IMSD,IMOSTP,ISYNSD,ISYSTP,
     >ISDBEG,IBGSTP,IXES,IXESTP,IESBEG,IESTBG,isdcol
      PARAMETER  (mxlcnd = 200)
      PARAMETER  (mxlvar = 100)
      COMMON/MONIT/VALMON(MXLCND,4,3)
      COMMON/MONFIT/VALFA(MXLCND),WGHTA(MXLCND),ERRA(MXLCND),
     >AMULTA(MXLVAR,6),ADDA(MXLVAR,6),DELA(MXLVAR)
     >,NPARA(MXLVAR,6),NELFA(MXLVAR,6),
     >NPVARA(MXLVAR),INDA(MXLVAR,6),VALR(MXLCND),RMOSIG,
     >NMONA(MXLCND),NVALA(MXLCND),NVARA,NCONDA
     >,IALFLG,MONFLG,MONLST,NOPTER,
     >IAFRST,IMOOPT,IMSBEG,NALPRT
      COMMON/CRAN/ PMRAN(0:2002),UNRAN(0:2002),G2RAN(0:2002),
     >G6RAN(0:2002),FACT
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
       INTEGER CLOCK1
       NCHAR=0
       NDIM=mxinp
       NDATA=1
       NPRINT=1
       CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NPRINT)
       ISEED = DATA(1)
       IF(ISEED.EQ.0)ISEED=CLOCK1(2)
       ISEED=(2*(ISEED/2))+1
       WRITE(IOUT,10000)ISEED
10000 FORMAT(//,'   THE SEED SELECTED FOR THIS RUN IS :',I16,//)
      FACT=DSQRT(3.0D0)*2.0D0
      IUR=ISEED
      isdcol=iseed
      DO 1 IG=1,2003
      IGM1=IG-1
      UNRAN(IGM1)=(URAND(IUR)-0.5D0)*FACT
      PMRAN(IGM1)=-1.0D0
      IF(UNRAN(IGM1).GT.0.0D0)PMRAN(IGM1)=1.0D0
    1 CONTINUE
      DO 4 IG =1,2003
      IGM1=IG-1
      G6RAN(IGM1)=GAUSS(IUR)
    4 CONTINUE
      DO 2 IG=1,2003
      IGM1=IG-1
    3 G=GAUSS(IUR)
      IF(DABS(G).GT.2.0D0)GOTO 3
      G2RAN(IGM1)=G
    2 CONTINUE
      RETURN
      END
      SUBROUTINE SEISM(IEND)
C     ********************************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      COMMON/CSEIS/XLAMBS,AXSEIS,PHIXS,YLAMBS,
     >AYSEIS,PHIYS,XSEIS,YSEIS,ISEIFL,IBEGSE,IENDSE
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
       IBEGSE=1
       IENDSE=NELM
       NCHAR=0
       NDIM=mxinp
       NDATA=6
       NPRINT=1
       CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NPRINT)
       XLAMBS=DATA(1)
       AXSEIS=DATA(2)
       PHIXS=DATA(3)*CRDEG
       YLAMBS=DATA(4)
       AYSEIS=DATA(5)
       PHIYS=DATA(6)*CRDEG
       XSEIS=0.0D0
       YSEIS=0.0D0
       ISEIFL=1
       NCHAR=8
       NDATA=0
       CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NPRINT)
       CALL ELPOS(ICHAR,NELPOS)
       IBEGSE=NELPOS
       CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NPRINT)
       CALL ELPOS(ICHAR,NELPOS)
       IENDSE=NELPOS
       RETURN
       END
      SUBROUTINE SETADI(IEND)
C     ***********************
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      PARAMETER    (MXADIV = 15)
      PARAMETER    (MXADIP = 100)
      COMMON/ADIA/VPARM(mxadiv,2*mxadip),IADFLG,IADCAV,NADVAR,
     >ivid(mxadiv),IVPAR(mxadiv),IVOPT(mxadiv)
      PARAMETER    (MXELMD = 3000)
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL,NINE,ICHAR
      DATA NINE/'9'/
      iadcav=0
      NADVAR=0
      IADFLG=1
    1 ndata = 0
      NCHAR=8
      INPRT=1
      CALL INPUT(ICHAR,NCHAR,data,mxinp,IEND,ndata,INPRT)
      IF((ICHAR(1).EQ.NINE).AND.(ICHAR(2).EQ.NINE))GO TO 99
      CALL ELID(ICHAR,NELID)
      NADVAR=NADVAR+1
      IF(NADVAR.GT.mxadiv)GOTO 100
      IVID(NADVAR)=NELID
      ndata = 1
      INPRT=1
      CALL INPUT(ICHAR,NCHAR,data,mxinp,IEND,ndata,INPRT)
      CALL DIMPAR(NELID, ICHAR, IDICT)
      if((kode(nelid).eq.7).and.(idict.eq.4))iadcav=1
      IVPAR(NADVAR)=IDICT
      iadiop=data(1)
      IVOPT(NADVAR)=iadiop
      nchar=0
      if(iadiop.eq.1) then
       ndata=4
       CALL INPUT(ICHAR,NCHAR,data,mxinp,IEND,ndata,INPRT)
       vparm(nadvar,1)=data(1)
       vparm(nadvar,2)=data(2)
       vparm(nadvar,3)=data(3)
       vparm(nadvar,4)=data(4)
      endif
      if(iadiop.eq.2) then
       ndata=6
       CALL INPUT(ICHAR,NCHAR,data,mxinp,IEND,ndata,INPRT)
       vparm(nadvar,1)=data(1)
       vparm(nadvar,2)=data(2)
       vparm(nadvar,3)=data(3)
       vparm(nadvar,4)=data(4)
       vparm(nadvar,5)=data(5)
       vparm(nadvar,6)=data(6)
      endif
      if(iadiop.eq.3) then
       ndata=1
       CALL INPUT(ICHAR,NCHAR,data,mxinp,IEND,ndata,INPRT)
       ndata=data(1)
       if(ndata.ge.mxadip) then
        write(iout,300)mxadip
  300   format(' too many parameters in the adiabatic option 3 .',
     > '  Maximum is : ',I5)
        call halt(13)
        return
       endif
       ndata=2*data(1)
       vparm(nadvar,1)=data(1)
       CALL INPUT(ICHAR,NCHAR,data,mxinp,IEND,ndata,INPRT)
       do 31 iapar=1,ndata
  31   vparm(nadvar,iapar+1)=data(iapar)
      endif
      GOTO 1
  100 WRITE(IOUT,10000)mxadiv
10000 FORMAT(' TOO MANY PARAMETERS TO BE VARIED ADIABATICALLY MAX is : ',
     > ,I5,/)
      CALL HALT(13)
   99 IF(NADVAR.EQ.0)IADFLG=0
      RETURN
      END
      SUBROUTINE SETCav(iend)
C     ***********************
      IMPLICIT REAL*8 (A-H,O-Z)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
      CHARACTER*1 NINE
      DATA NINE/'9'/
      parameter    (MXCEB = 2000)
      common/cebcav/cebmat(6,6,mxceb),estart,ecav(mxceb),
     >ipos(mxceb),icavtot,icebflg,iestflg,icurcav
      Ndata = 1
      NCHAR=0
      INPRT=1
      NDIM=mxinp
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,Ndata,INPRT)
      estart=data(1)
      icav=0
      iw=0
      iestflg=0
      do 1 iep=1,nelm
      ielm=norlst(iep)
      if(kode(ielm).eq.20) then
        icav=icav+1
        if(icav.gt.mxceb) then
          if(iw.eq.0) then
            write(iout,10001) mxceb
            iw=1
10001 format(/,
     >'***********************  WARNING  *****************************',
     >'  more than mxceb(',i4,') cebav cavities needed ',
     >' the first mxceb cavities are recorded the rest is ignored ',
     >' increase the parameter mxceb where it occurs ',
     >'***********************  WARNING  *****************************',
     >/)
          endif
          return
        endif
        call cmcomp(ielm,iep,icav)
        ipos(icav)=iep
      endif
    1 continue
      icavtot=icav
      iestflg=1
      RETURN
      END
      SUBROUTINE SETCOR(IEND)
C     ***********************
      IMPLICIT REAL*8 (A-H,O-Z)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER     (MAXCOR = 600)
      COMMON/CORR/CORVAL(MAXCOR,4),ICRID(MAXCOR),
     >ICRPOS(MAXCOR),ICRSET(MAXCOR),
     >ICROPT(MAXCOR),NCORR,NCURCR,ICRFLG,ICRCHK,ALMNEL,ICRPTR,NPARC
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
      CHARACTER*1 NINE
      DATA NINE/'9'/
    1 NOP = 0
      NCHAR=8
      INPRT=1
      NDIM=mxinp
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NOP,INPRT)
      IF((ICHAR(1).EQ.NINE).AND.(ICHAR(2).EQ.NINE))GO TO 99
      NOP = 6
      NCHAR=0
      INPRT=1
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NOP,INPRT)
      CALL ELID(ICHAR,NELID)
      ICPOS=data(1)
      DO 2 ICORR=1,NCORR
      IF(ICPOS.LT.ICRPOS(ICORR))GOTO 3
      IF((NELID.EQ.ICRID(ICORR)).AND.(ICPOS.EQ.ICRPOS(ICORR)))GOTO 4
    2 CONTINUE
    3 WRITE(IOUT,10001)
10001 FORMAT(/,'  NO MATCH WAS FOUND FOR CORRECTOR ID AND POSITION',
     >' IN THE CORRECTOR LIST',/,' DEFINED IN THE CORRECTOR DEFINITION',
     >' OPERATION . RUN IS STOPPED',/)
      CALL HALT(223)
    4 ICRSET(ICORR)=1
      ICROPT(ICORR)=data(2)
      CORVAL(ICORR,1)=data(3)
      CORVAL(ICORR,2)=data(4)
      CORVAL(ICORR,3)=data(5)
      CORVAL(ICORR,4)=data(6)
      GOTO 1
   99 ICRFLG=1
C      WRITE(IOUT,88888)(ICRPOS(IW),ICRID(IW),ICRSET(IW),ICROPT(IW),
C     >(CORVAL(IW,JW),JW=1,4),IW=1,NCORR)
C88888 FORMAT(' ',4I6,4E12.4)
      RETURN
      END
      SUBROUTINE SETERR(IEND)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      parameter   (mxerr = 25)
      parameter   (MXEREL = 500)
      parameter   (MXERRG = 6)
      COMMON/cERR/ERRVAL(mxerr,mxerel),erv(mxerr,mxerel),NERELE(mxerel),
     > NERPAR(mxerr,mxerel),NERR,NEROPT,NERRE,MERSEL(mxerel),
     > NERNGE(mxerel),MERNGE(2,mxerrg,mxerel),MERFLG
      COMMON/CSEEDS/ISEED,IXG,IXS,IXMSTP,IMSD,IMOSTP,ISYNSD,ISYSTP,
     >ISDBEG,IBGSTP,IXES,IXESTP,IESBEG,IESTBG,isdcol
      PARAMETER  (MAXERR = 100)
      COMMON /ERRSRT/ ERRSRT(MAXERR),NERSRT,IERSRT,IERBEG
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
C INITIALIZE TO 0 ALL ARRAYS DEFINED IN THIS ROUTINE
      DO 5 INER=1,mxerel
      MERSEL(INER)=0
      NERNGE(INER)=0
      DO 5 JNER=1,mxerrg
      DO 5 KNER=1,2
    5 MERNGE(KNER,JNER,INER)=0
      NDIM=mxinp
      NPRINT=1
      NCHAR=0
      NDATA=2
      CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NPRINT)
      NEROPT=DATA(1)
      IF(NEROPT.GT.10) THEN
              IXESTP=1
              NEROPT=NEROPT-10
                       ELSE
              IXESTP=0
      ENDIF
      NERRE=DATA(2)
      DO 1 IER=1,NERRE
      NCHAR=8
      NDATA=0
      CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NPRINT)
      CALL ELID(ICHAR,NELID)
      DO 3 JM=1,NERR
      IF(NELID.EQ.NERELE(JM))GOTO 4
    3 CONTINUE
      WRITE(IOUT,99984)ICHAR
99984 FORMAT(/,'  NAME ',8A1,' IS NOT IN THE LIST OF THE',
     >' ELEMENTS WITH ERROR AS DEFINED IN ERRDAT',/)
      CALL HALT(252)
    4 MERSEL(IER)=JM
      NDATA = 1
      NCHAR=0
      CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NPRINT)
      NERNGE(IER)=DATA(1)
      IF((DATA(1).EQ.0.0D0).OR.(DATA(1).EQ.-1.0D0))GOTO 1
      NDATA=NERNGE(IER)*2
      CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NPRINT)
      NFRNGE=NERNGE(IER)
      DO 2 IRNGE=1,NFRNGE
      MERNGE(1,IRNGE,IER)=DATA((2*IRNGE)-1)
    2 MERNGE(2,IRNGE,IER)=DATA(2*IRNGE)
    1 CONTINUE
      MERFLG=1
      IOPT=NEROPT+1
C     WRITE(IOUT,99000)((NERELE(IN),MERSEL(IN),NERNGE(IN),
C    >MERNGE(1,1,IN),MERNGE(2,1,IN)),IN=1,NERR)
99000 FORMAT(/,' IN ESET',5I5)
      IF (IOPT.EQ.6) THEN
        DO 6 I=1,MAXERR
          READ(7,*,END=7) ERRSRT(I)
    6   CONTINUE
CHECK FOR END OF FILE
        READ(7,*,END=7) DUMMY
        WRITE(IOUT,99) MAXERR
   99   FORMAT(' ',/,'MORE THAN MAXERR = ',I4,
     >  ' VALUES IN FILE FOR007.DAT')
        GO TO 8
    7   CONTINUE
        WRITE(IOUT,991) I-1
  991   FORMAT(' ',/, I7, ' VALUES READ FROM FOR007')
    8   CONTINUE
        NERSRT = I-1
      ENDIF
      IF(IXESTP.NE.0) WRITE(IOUT,88888)
88888 FORMAT(/,'  FAST RANDOM SEQUENCE GENERATION USED  ',/)
      GOTO (10,11,12,13,14,15), IOPT
   10 WRITE(IOUT,99990)
99990 FORMAT(/,' NO RANDOM GENERATOR IS USED IN SETTING UP THE'
     >,' ERRORS',/)
      RETURN
   11 WRITE(IOUT,99991)
99991 FORMAT(/,' THE ERROR VALUES ARE MULTIPLIED RANDOMLY BY',
     >/,' +1 AND -1',/)
      RETURN
   12 WRITE(IOUT,99992)
99992 FORMAT(/,' THE ERROR VALUES ARE MULTIPLIED BY THE VALUES',
     >/,' OF A UNIFORM RANDOM DISTRIBUTION WHOSE SIGMA IS 1',/)
      RETURN
   13 WRITE(IOUT,99993)
99993 FORMAT(/,' THE ERROR VALUES ARE MULTIPLIED BY THE VALUES',
     >/,' OF A GAUSSIAN DISTRIBUTION WHOSE SIGMA IS 1 AND THAT IS',/,
     >' TRUNCATED AT 2 SIGMAS',/)
      RETURN
   14 WRITE(IOUT,99994)
99994 FORMAT(/,' THE ERROR VALUES ARE MULTIPLIED BY THE VALUES',
     >/,' OF A GAUSSIAN DISTRIBUTION WHOSE SIGMA IS 1 AND THAT IS',/,
     >' TRUNCATED AT 6 SIGMAS',/)
      RETURN
   15 WRITE(IOUT, 99995)
99995 FORMAT(/,' THE ERROR VALUES ARE READ FROM THE FILE FOR007.DAT',
     +/,' AND USED WITH THE SIGMAS GIVEN IN THE ERRORS DATA ',
     +' DEFINITION')
      RETURN
      END
      SUBROUTINE SETMIS(IEND)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER  (mxmis = 1000)
      COMMON/MIS/RMISA(8,MXMIS),MISELE(MXMIS),NMIS,NOPT,
     >NMISE,MISSEL(MXMIS),NMRNGE(MXMIS),
     >MSRNGE(2,10,MXMIS),MISFLG,MCHFLG
      COMMON/CSEEDS/ISEED,IXG,IXS,IXMSTP,IMSD,IMOSTP,ISYNSD,ISYSTP,
     >ISDBEG,IBGSTP,IXES,IXESTP,IESBEG,IESTBG,isdcol
      PARAMETER    (MXMTR = 5000)
      COMMON/MISTRK/AKMIS(15,MXMTR),KMPOS(MXMTR),IMEXP,NMTOT,MISPTR
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
      IF(IMEXP.EQ.1)THEN
         IMEXP=2
         WRITE(IOUT,10001)
10001 FORMAT(/,
     >' A PREVIOUS SHO MIS -1 OPERATION SAVED THE PREVIOUSLY DEFINED ',
     >/,' MISALIGNMENT DATA. A NEW MISALIGNMENT IS NOW SET. ',
     >' BEFORE YOU',
     >/,' ISSUE A ANOTHER SHO MIS -1, MAKE SURE THAT THE NEW ',
     >'MISALIGNEMENT ',
     >/,' REQUEST IS COMPATIBLE WITH THE PREVIOUS ONES. THE NEW ',
     >/,'SHO MIS -1 MAY'
     >,' INFORM YOU OF SOME INCOMPATIBILITIES',/)
      ENDIF
      NPRINT=1
      NCHAR=0
      NDATA=2
      ndim=mxinp
      CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NPRINT)
      NOPT=DATA(1)
      IF(NOPT.GT.10) THEN
              IXMSTP=1
              NOPT=NOPT-10
                       ELSE
              IXMSTP=0
      ENDIF
      NMISE=DATA(2)
      DO 1 IMS=1,NMISE
      NCHAR=8
      NDATA=0
      CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NPRINT)
      CALL ELID(ICHAR,NELID)
      DO 3 JM=1,NMIS
      IF(NELID.EQ.MISELE(JM))GOTO 4
    3 CONTINUE
      WRITE(IOUT,99995)ICHAR
99995 FORMAT(/,'  NAME ',8A1,' IS NOT IN THE LIST OF THE',
     >' MISALIGNED ELEMENTS DEFINED IN MISDAT',/)
      CALL HALT(278)
    4 MISSEL(IMS)=JM
      NDATA = 1
      NCHAR=0
      CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NPRINT)
      NMRNGE(IMS)=DATA(1)
      IF((DATA(1).EQ.0.0D0).OR.(DATA(1).EQ.-1.0D0))GOTO 1
      NDATA=NMRNGE(IMS)*2
      CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NPRINT)
      NFRNGE=NMRNGE(IMS)
      DO 2 IRNGE=1,NFRNGE
      MSRNGE(1,IRNGE,IMS)=DATA((2*IRNGE)-1)
    2 MSRNGE(2,IRNGE,IMS)=DATA(2*IRNGE)
    1 CONTINUE
      MISFLG=1
      IOPT=NOPT+1
      IF(IXMSTP.NE.0) WRITE(IOUT,88888)
88888 FORMAT(/,'  FAST RANDOM SEQUENCE GENERATION USED  ',/)
      GOTO(10,11,12,13,14),IOPT
   10 WRITE(IOUT,99990)
99990 FORMAT(/,' NO RANDOM GENERATOR IS USED IN THE MISALIGNEMENT',/)
      RETURN
   11 WRITE(IOUT,99991)
99991 FORMAT(/,' THE MISALIGNEMENT VALUES ARE MULTIPLIED RANDOMLY BY',
     >/,' +1 AND -1',/)
      RETURN
   12 WRITE(IOUT,99992)
99992 FORMAT(/,' THE MISALIGNMENT VALUES ARE MULTIPLIED BY THE VALUES',
     >/,' OF A UNIFORM RANDOM DISTRIBUTION WHOSE SIGMA IS 1',/)
      RETURN
   13 WRITE(IOUT,99993)
99993 FORMAT(/,' THE MISALIGNMENT VALUES ARE MULTIPLIED BY THE VALUES',
     >/,' OF A GAUSSIAN DISTRIBUTION WHOSE SIGMA IS 1 AND THAT IS',/,
     >' TRUNCATED AT 2 SIGMAS',/)
      RETURN
   14 WRITE(IOUT,99994)
99994 FORMAT(/,' THE MISALIGNMENT VALUES ARE MULTIPLIED BY THE VALUES',
     >/,' OF A GAUSSIAN DISTRIBUTION WHOSE SIGMA IS 1 AND THAT IS',/,
     >' TRUNCATED AT 6 SIGMAS(MAXIMUM AVAILABLE WITH GENERATOR)',/)
      RETURN
      END
      SUBROUTINE SETOUT
C     ******************************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/FOUT/OUTFL(350)
      COMMON/CBEAM/BSIG(6,6),BSIGF(6,6),MBPRT,IBMFLG,MENV
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      COMMON/ANALC/COMPF,RNU0X,CETAX,CETAPX,CALPHX,CBETAX,
     1RMU1X,CHROMX,ALPH1X,BETA1X,
     1RMU0Y,RNU0Y,CETAY,CETAPY,CALPHY,CBETAY,
     1RMU1Y,CHROMY,ALPH1Y,BETA1Y,RMU0X,CDETAX,CDETPX,CDETAY,CDETPY,
     >COSX,ALX1,ALX2,VX1,VXP1,VX2,VXP2,
     >COSY,ALY1,ALY2,VY1,VYP1,VY2,VYP2,NSTABX,NSTABY,NSTAB,NWRNCP
      COMMON/TWF/BETAOX,ALPHOX,ETAOX,ETAPOX,ANUX,
     >            BETAOY,ALPHOY,ETAOY,ETAPOY,ANUY,IE
      COMMON/FITD/AVEBX,AVEAX,AVEBY,AVEAY,AVENUX,AVENUY,
     >AVER11,AVER12,AVER21,AVER22,AVER33,AVER34,AVER43,AVER44
      COMMON/LAYOUT/SHI,XHI,YHI,ZHI,THETAI,PHIHI,PSIHI,CONVH,
     >SRH,XRH,YRH,ZRH,THETAR,PHIRH,PSIRH,NLAY,layflg
      DIMENSION RELAY2(10),RELAY1(20),RELAY3(162)
      DIMENSION RELAY4(6),RELAY5(8),RELAY6(7)
      EQUIVALENCE(RELAY4(1),AVEBX)
      EQUIVALENCE(RELAY5(1),AVER11)
      EQUIVALENCE(RELAY6(1),SRH)
      EQUIVALENCE(COMPF,RELAY1(1))
      EQUIVALENCE(RELAY2(1),BETAOX)
      EQUIVALENCE(TEMP(1,1),RELAY3(1))
      IF((IE.EQ.IFITE(1)).AND.(IE.NE.0))GOTO 4
      IF((IE.EQ.IFITE(2)).AND.(IE.NE.0))GOTO 40
      DO 1 I=1,10
      OUTFL(I+20)=RELAY2(I)
    1 CONTINUE
      DO 2 I=1,20
      OUTFL(I)=RELAY1(I)
    2 CONTINUE
      DO 3 I = 1,162
      OUTFL(I+100)=RELAY3(I)
    3 CONTINUE
      IBS=1
      DO 6 IB=1,6
      DO 6 JB=IB,6
      OUTFL(40+IBS)=BSIGF(IB,JB)
    6 IBS=IBS+1
      DO 8 IR=1,6
      OUTFL(92+IR)=RELAY4(IR)
    8 CONTINUE
      DO 9 IR=1,8
      OUTFL(270+IR)=RELAY5(IR)
    9 CONTINUE
      DO 10 IR=1,7
      OUTFL(280+IR)=RELAY6(IR)
   10 CONTINUE
      RETURN
    4 DO 5 I=1,10
    5 OUTFL(I+30)=RELAY2(I)
      IBS=1
      DO 7 IB=1,6
      DO 7 JB=IB,6
      OUTFL(70+IBS)=BSIGF(IB,JB)
    7 IBS=IBS+1
      RETURN
   40 DO 50 I=1,10
   50 OUTFL(I+300)=RELAY2(I)-OUTFL(I+30)
      IBS=1
      DO 70 IB=1,6
      DO 70 JB=IB,6
      OUTFL(310+IBS)=BSIGF(IB,JB)-OUTFL(70+IBS)
   70 IBS=IBS+1
      RETURN
      END
      SUBROUTINE SETSYM(IEND)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      COMMON/SYM/ENERLI,GAMMLI,BETALI,bili,b2li,b2ili,
     >ISYOPT,ISYFLG,MATTOT,KANVAR
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
      NDIM=mxinp
      NPRINT=1
      NCHAR=0
      NDATA=2
      ISYOPT=0
      KANVAR=0
      CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NPRINT)
      ISYOPT=DATA(1)
C
C*****IF((ISYOPT.EQ.2).OR.(ISYOPT.EQ.4)) ISYFLG=1 !***DISABLE!!!***!
C
C  CANONICAL VARIABLES USED IF ISYOPT = 0, 2, OR 4
C
      IF (  ( (ISYOPT.EQ.0).OR.(ISYOPT.EQ.2) ).OR.(ISYOPT.EQ.4)  )
     &                                 KANVAR=1
      ENERLI=DATA(2)
      GAMMLI=ENERLI/EMASS
      BETALI=1.0D0
      bili=1.0d0/betali
      b2li=betali*betali
      b2ili=bili*bili
C
C  NOW CALL SYMMTX TO LOAD MATRICES IN CANONICAL VARIABLES AND
C  TO SET UP MATRICES FOR SYMPLECTIC TRACING
C  !!! WARNING !!!  THIS CALL WIPES OUT THE MATRICES IN THE AMAT ARRAY
C                   AND RELOADS AMAT WITH THE SINGLE ELEMENT MATRICES
C                   WRITTEN IN TERMS OF CANONICAL VARIABLES X,PX,Y,PY
C                   -T,E
C
      if(isyflg.eq.0)CALL SYMMTX(-1)
      ISYFLG=1
      RETURN
      END
      SUBROUTINE SETSYN(IEND)
C     ********************************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/SYNCH/ENOM,SYNDEL,EMITGR,EMITK,EMITK2,ISYNFL,ISYNQD,IRND,iff
      COMMON/CSEEDS/ISEED,IXG,IXS,IXMSTP,IMSD,IMOSTP,ISYNSD,ISYSTP,
     >ISDBEG,IBGSTP,IXES,IXESTP,IESBEG,IESTBG,isdcol
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
      NDIM=mxinp
      NDATA=3
      NCHAR=0
      NPRINT=1
      CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NPRINT)
      ENOM=DATA(1)
      ISYNFL=DATA(2)
      ISYNQD=0
c flag iff is used for the new radiation scheme by Ghislain Roy.
c iff = 0 : old scheme is used (cf Dimad manual)
c iff = 1 : energy loss and emittance growth are computed with new method
c iff = 2 : emittance growth only is computed with new method
      iff = 0
      if (isynfl.ge.10) then
         iff = 1
         if (isynfl.ge.12) iff = 2
         if (isynfl.eq.11 .or. isynfl.eq.13) isynqd = 1
         isynfl = 1
      endif
      IF(ISYNFL.GT.3) THEN
        ISYNQD=1
        ISYNFL=ISYNFL-2
      ENDIF
      IRND=DATA(3)
      IF(IRND.GT.10) THEN
            ISYSTP=1
            ISYNSD=1
            IRND=IRND-10
                     ELSE
            ISYSTP=0
            ISYNSD=ISEED
      ENDIF
      RETURN
      END
      SUBROUTINE SETUP
C     *************************
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
      COMMON /PAGTIT/   KTIT,KVERS,KDATE,KTIME
      CHARACTER*8       KTIT*80,KVERS,KDATE,KTIME
C******* THIS NEW VERSION GETS ITS INPUT OUTPUT FILE NUMBERS FROM THE
C******* MAD INPUT
C******* CHANGED 26.8.87 BY JKL
      character*1 filnam(10),ktitle(6)
      character*10 filenam
      equivalence (ktit,ktitle(1)),(filenam,filnam(1))
      data ist /-1/
      data filenam /'      .ech'/
      if(ist.ne.-1) return
      ISOUT=IECHO
      IIN=IDATA
      IOUT=IPRNT
      ISO=1
      IF(IOUT.EQ.ISOUT)ISO=0
      NSLC=0
      if(iso.ne.0) then
      do 1 ich=1,6
      filnam(ich)=ktitle(ich)
      if(ktitle(ich).eq.' ')  filnam(ich)='_'
    1 continue
      open(unit=isout,status='unknown',file=filenam)
      endif
      OPEN(UNIT=11,status='unknown')
      RETURN
      END
      SUBROUTINE SHOCON(IEND)
C     *************************
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/CONDEF/REFEN
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      CHARACTER*8 PNAME(2)
      DATA PNAME/'ELECTRON','PROTON  '/
      WRITE(IOUT,10001)PI,CLIGHT,EMASS,ERAD,ECHG,REFEN,TOLLSQ,MAXFAC,
     >EXPEL2,ETAFAC,SIGFAC,PNAME(IPTYP+1)
10001 FORMAT(//,
     >'                 PI    = ',F19.16,/,
     >'  VELOCITY OF LIGHT    = ',E17.10,' M/S ',/,
     >'      PARTICLE MASS    = ',E17.10,' GEV ',/,
     >'    PARTICLE RADIUS    = ',E17.10,' M ',/,
     >'    PARTICLE CHARGE    = ',E17.10,' COULOMB ',//,
     >'  REFERENCE MOMENTUM IN DP/P = ',E15.8,//,
     >'    LSQ TOLERANCE      = ',E12.2,/,
     >'  MAX FCT CALL FACT    = ',I4,/,
     >'  PART. EXPUL. FACT    = ',E10.3,/,
     >'  ETA SCALING FACTOR   = ',E10.3,/,
     >'  SIGMA SCALING FACTOR = ',E10.3,/,
     >'  THE PARTICLE IS      : ',A8,/,
     >//)
      RETURN
      END
      SUBROUTINE SHOCOR(IEND)
C     *************************
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      PARAMETER     (MAXCOR = 600)
      COMMON/CORR/CORVAL(MAXCOR,4),ICRID(MAXCOR),
     >ICRPOS(MAXCOR),ICRSET(MAXCOR),
     >ICROPT(MAXCOR),NCORR,NCURCR,ICRFLG,ICRCHK,ALMNEL,ICRPTR,NPARC
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
      DIMENSION AVE(4),RMS(4),RMAX(4),RMIN(4)
      DIMENSION NTCOR(4)
      NDIM=mxinp
      NDATA=1
      NCHAR=0
      NPRINT=1
      CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NPRINT)
      ICOPT=DATA(1)
      GOTO(100,200,300),ICOPT
      WRITE(IOUT,10000)ICOPT
10000 FORMAT('  ERROR IN OPTION NUMBER ',I4,' RUN STOPPED')
      CALL HALT(290)
  100 CONTINUE
      DO 1 IZ=1,4
      NTCOR(IZ)=0
      AVE(IZ)=0.0D0
      RMS(IZ)=0.0D0
      RMAX(IZ)=-1000.0D0
    1 RMIN(IZ)=1000.0D0
      DO 3 IC=1,4
      DO 2 ICOR=1,NCORR
      VAL=CORVAL(ICOR,IC)
      AVE(IC)=AVE(IC)+VAL
      IF(RMAX(IC).LT.VAL)RMAX(IC)=VAL
      IF(RMIN(IC).GT.VAL)RMIN(IC)=VAL
      IF(VAL.NE.0.0D0)NTCOR(IC)=NTCOR(IC)+1
    2 CONTINUE
      IF(NTCOR(IC).EQ.0)GOTO 3
      AVE(IC)=AVE(IC)/NTCOR(IC)
    3 CONTINUE
      DO 4 IC=1,4
      DO 5 ICOR=1,NCORR
      VAL=CORVAL(ICOR,IC)
      IF(VAL.EQ.0.0D0)GOTO 5
      RMS(IC)=RMS(IC)+(VAL-AVE(IC))**2
    5 CONTINUE
      IF(NTCOR(IC).EQ.0)GOTO 4
      RMS(IC)=DSQRT(RMS(IC)/NTCOR(IC))
    4 CONTINUE
      WRITE(IOUT,10001)AVE,RMS,RMAX,RMIN
10001 FORMAT(//
     > ,' AVERAGE CORRECTOR VALUES ',4E12.4,//
     > ,'   RMS   CORRECTOR VALUES ',4E12.4,//
     > ,' MAXIMUM CORRECTOR VALUES ',4E12.4,//
     > ,' MINIMUM CORRECTOR VALUES ',4E12.4
     >,/)
      RETURN
  200 NCHAR=8
      NDATA=0
      DO 201 IZ=1,4
      NTCOR(IZ)=0
      AVE(IZ)=0.0D0
      RMS(IZ)=0.0D0
      RMAX(IZ)=-1000.0D0
  201 RMIN(IZ)=1000.0D0
      CALL INPUT(ICHAR,NCHAR,DATA,NDIM,IEND,NDATA,NPRINT)
      IF(NOUT.GE.3)WRITE(IOUT,10201)ICHAR
10201 FORMAT(/,'  VALUES 1 AND 2 FOR CORRECTOR  : ',8A1,/)
      DO 203 ICOR=1,NCORR
C      DO 202 IC=1,8
C      IF(ICHAR(IC).NE.NAME(IC,ICRID(ICOR)))GO TO 203
C  202 CONTINUE
      IF(IEQUAL(ICHAR,NAME(1,ICRID(ICOR))).eq.1)THEN
      A=CORVAL(ICOR,1)*SIGFAC
      B=CORVAL(ICOR,2)*SIGFAC
      IF(NOUT.GE.3)WRITE(IOUT,10202)ICRPOS(ICOR),A,B
10202 FORMAT(' ',I6,2E12.4)
      DO 204 IC=1,4
      VAL=CORVAL(ICOR,IC)
      AVE(IC)=AVE(IC)+VAL
      IF(RMAX(IC).LT.VAL)RMAX(IC)=VAL
      IF(RMIN(IC).GT.VAL)RMIN(IC)=VAL
      IF(VAL.NE.0.0D0)NTCOR(IC)=NTCOR(IC)+1
  204 CONTINUE
      ENDIF
  203 CONTINUE
      DO 205 IC=1,4
      IF(NTCOR(IC).NE.0)AVE(IC)=AVE(IC)/NTCOR(IC)
  205 CONTINUE
      DO 206 IC=1,4
      DO 207 ICOR=1,NCORR
      IF(IEQUAL(ICHAR,NAME(1,ICRID(ICOR))).eq.1) THEN
      VAL=CORVAL(ICOR,IC)
      IF(VAL.NE.0.0D0)RMS(IC)=RMS(IC)+(VAL-AVE(IC))**2
      ENDIF
  207 CONTINUE
      IF(NTCOR(IC).NE.0)RMS(IC)=DSQRT(RMS(IC)/NTCOR(IC))
  206 CONTINUE
      IF(NOUT.GE.1)WRITE(IOUT,10203)ICHAR,AVE,RMS,RMAX,RMIN
10203 FORMAT(//,' ANALYSIS FOR CORRECTORS : ',8A1,//
     > ,' AVERAGE CORRECTOR VALUES ',4E12.4,//
     > ,'   RMS   CORRECTOR VALUES ',4E12.4,//
     > ,' MAXIMUM CORRECTOR VALUES ',4E12.4,//
     > ,' MINIMUM CORRECTOR VALUES ',4E12.4
     >,/)
      RETURN
  300 DO 301 ICR=1,NCORR
      WRITE(IOUT,10300)(NAME(IN,ICRID(ICR)),IN=1,8),
     >      ICRPOS(ICR),ICROPT(ICR),(CORVAL(ICR,IVCR),IVCR=1,4)
10300 FORMAT(' ',8A1,I7,I4,2E20.12,/,20X,2E20.12,',')
  301 CONTINUE
      WRITE(IOUT,10301)
10301 FORMAT(' ','99,',/)
      RETURN
      END
      SUBROUTINE SHOERR(IEND)
C     *************************
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      RETURN
      END

      SUBROUTINE SHOMIS(IEND)
C     *************************
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      common/cprt/prnam(8,10),kodprt(2),
     >   iprtfl,intfl,itypfl,namfl,inam,itkod
      character*1 prnam
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER    (MXMTR = 5000)
      COMMON/MISTRK/AKMIS(15,MXMTR),KMPOS(MXMTR),IMEXP,NMTOT,MISPTR
      COMMON/MISSET/DX1,DX2,DXP1,DXP2,DY1,DY2,DYP1,DYP2,
     >DZ1,DZ2,DZC1,DZS1,DZC2,DZS2,DDEL,I,IEP,MNEL
      PARAMETER  (mxmis = 1000)
      COMMON/MIS/RMISA(8,MXMIS),MISELE(MXMIS),NMIS,NOPT,
     >NMISE,MISSEL(MXMIS),NMRNGE(MXMIS),
     >MSRNGE(2,10,MXMIS),MISFLG,MCHFLG
      COMMON/CSEEDS/ISEED,IXG,IXS,IXMSTP,IMSD,IMOSTP,ISYNSD,ISYSTP,
     >ISDBEG,IBGSTP,IXES,IXESTP,IESBEG,IESTBG,isdcol
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
      DIMENSION NPOS(5,5,2)
      CHARACTER*1 MISNAM(5,8)
      parameter  (MAXBAS = 10)
      parameter  (MXSBAS = 40)
      common /cbase/albas(maxbas),alsbas(mxsbas),
     >npbas(maxbas),nelb(maxbas),npsbas(mxsbas),nelsb(mxsbas),
     >npen,nsub
      COMMON/LNGTH/TLENG,ALENG(MXELMD),ACLENG(MAXPOS)
      CHARACTER*1 NINE
      DATA NINE/'9'/
      DATA IFLG1 /0/
      Ndata=1
      NCHAR=0
      NDIM=mxinp
      NIPR=1
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,Ndata,NIPR)
      NRNG=data(1)
      if(iprtfl.eq.0)mlocat=nrng
      IF(NRNG.EQ.-1)IFLG1=1
      IF(NRNG.EQ.-10) THEN
      NCHAR=8
      ndata=0
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,Ndata,NIPR)
      ENDIF
      IF(NRNG.EQ.-2) THEN
      IMEXP=0
      DO 91 II=1,2
      DO 91 JJ=1,5
      DO 91 KK=1,5
   91 NPOS(KK,JJ,II)=0
      NCHAR=8
      ndata=0
      IM=1
  101 CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,Ndata,NIPR)
      IF((ICHAR(1).EQ.NINE).AND.(ICHAR(2).EQ.NINE))GO TO 99
      IF(IM.GT.5)GOTO 105
      DO 100 INAM=1,8
      MISNAM(IM,INAM)=ICHAR(INAM)
  100 CONTINUE
      IN=1
  102 CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,Ndata,NIPR)
      CALL ELPOS(ICHAR,NLPOS1)
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,Ndata,NIPR)
      CALL ELPOS(ICHAR,NLPOS2)
      IF(IN.GT.5)THEN
        IF(IEND.NE.2) THEN
          GOTO 102
                      ELSE
          GOTO 104
        ENDIF
      ENDIF
      NPOS(IM,IN,1)=NLPOS1
      NPOS(IM,IN,2)=NLPOS2
      IF(IEND.EQ.2) GOTO 103
      IN=IN+1
      GOTO 102
  104 WRITE(IOUT,10104)IN
10104 FORMAT(' TOO MANY INTERVALS :',I2,' MAX IS 5 . RUN STOPPED ')
      CALL HALT(14)
  103 IM=IM+1
      GOTO 101
  105 IF(IM.GT.5) THEN
        WRITE(IOUT,10099)IM
10099 FORMAT(' TOO MANY ELEMENTS :',I2,' MAX IS 5 . RUN  STOPPED ')
      CALL HALT(15)
      ENDIF
   99 NCHAR=0
      ndata=1
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,Ndata,NIPR)
      FACTM=data(1)
C      WRITE(IOUT,10505)(((NPOS(II,IJ,IK),IK=1,2),IJ=1,5),II=1,5),
C     >((MISNAM(III,IIJ),IIJ=1,8),III=1,5)
C10505 FORMAT(' NPOS ',/,5(5(2I5,/),/),/,' MISNAM ',/,5(8A1,/))
C      WRITE(IOUT,10506)IM,FACTM,NMTOT,(KMPOS(II),II=1,NMTOT)
C10506 FORMAT(' IM = ',I3,' FACTM = ',F8.3,/,
C     >' NMTOT = ',I6,/,' KMPOS = ',/,
C     >20(6I6,/))
      IM=IM-1
      ENDIF
      if(iprtfl.eq.1) goto11
      IF(NRNG.LE.0)GOTO 11
                 IF(NRNG.GT.MXLIST) THEN
                       WRITE(IOUT,30301)MLOCAT
30301 FORMAT(' **** TOO MANY INTERVALS ',I4,/,
     >' CHANGE MXLIST PARAMETER TO VALUE NEEDED')
                       CALL HALT(2)
                 ENDIF
      ndata=2*NRNG
      NCHAR=0
      NDIM=40
      NIPR=1
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,Ndata,NIPR)
      DO 10 INR=1,NRNG
      NLIST(INR*2-1)=data(INR*2-1)
      NLIST(INR*2)=data(INR*2)
   10 CONTINUE
   11 ILIST=1
      IF(IXMSTP.NE.0) THEN
           IXS=1
           IXMSTP=1
                      ELSE
           IXS=ISEED
      ENDIF
C      WRITE(IOUT,10510)IXMSTP,IXS
C10510 FORMAT(' IXMSTP = ',I3,' IXS = ',I12)
      IF(NRNG.EQ.-2) THEN
        IF(IXMSTP.EQ.1) THEN
          IXMSTP=2
                        ELSE
          DO 111 IRN=1,100
  111     R=URAND(IXS)
        ENDIF
      ENDIF
C      WRITE(IOUT,10510)IXMSTP,IXS
      IF(NRNG.GE.0)WRITE(IOUT,10002)
10002 FORMAT(//,'    # ',
     >'   NAME  ','     X1        X2        XP1    ',
     >'  XP2        Y1        Y2        YP1       YP2       Z',
     >'         ZR',
     >'        DELTA',//)
      IF(NRNG.EQ.-1)NMTOT1=0
      IF(NRNG.EQ.-10)WRITE(IOUT,10402)ICHAR
10402 FORMAT(/,'  AVERAGE X AND Y DISPLACEMENTS FOR ELEMENTS : ',8A1,/)
      MISPTR=1
      IF((IMEXP.EQ.2).AND.(NRNG.EQ.-1)) THEN
      MISPTR=MXMTR-NMTOT+1
      DO 1001 IAK=1,NMTOT
      IND1=NMTOT-IAK+1
      IND2=MXMTR-IAK+1
      KMPOS(IND2)=KMPOS(IND1)
      DO 1002 JAK=1,15
      AKMIS(JAK,IND2)=AKMIS(JAK,IND1)
 1002 CONTINUE
 1001 CONTINUE
      NMTOT=MXMTR
      ENDIF
      IWRN=0
      IF(NRNG.EQ.-20)  then
      ncpen=1
      ncsub=1
      xbas=0.0d0
      xpbas=0.0d0
      ybas=0.0d0
      ypbas=0.0d0
      xbref=0.0d0
      xpbref=0.0d0
      xb=0.0d0
      ybref=0.0d0
      ypbref=0.0d0
      yb=0.0d0
      aclref=0.0d0
      endif
      DO 1 IE=1,NELM
      MCHFLG=0
      NEL=NORLST(IE)
      MNEL=NEL
      IEP=IE
      CALL MISCHK
      IF(NRNG.EQ.0)GOTO 2
      if(nrng.eq.-20)GOTO 20
      IF(NRNG.EQ.-1)GOTO 3
      IF(NRNG.EQ.-2)GOTO 5
      IF(NRNG.EQ.-10)GOTO 4
      IF(ILIST.GT.(2*mlocat))GOTO 1
      IF((IE.GE.NLIST(ILIST)).AND.(IE.LE.NLIST(ILIST+1)))GOTO 2
      IF(IE.GT.NLIST(ILIST+1))ILIST=ILIST+2
      GOTO 1
    2 IF(MCHFLG.EQ.0)GOTO 1
      WRITE(IOUT,10001)IE,(NAME(INM,NEL),INM=1,8),DX1,DX2,DXP1,DXP2,
     >DY1,DY2,DYP1,DYP2,DZ1,DZS1,DDEL
10001 FORMAT(I6,' ',8A1,11(E10.2))
      GOTO 1
   20 continue
      if(mchflg.ne.0) then
      xb=xbref+xpbref*(acleng(ie)-aclref)
      yb=ybref+ypbref*(acleng(ie)-aclref)
      x1=dx1+xb
      x2=-dx2+xb
      y1=dy1+yb
      y2=-dy2+yb
      al=aleng(nel)
      acl2=acleng(ie)
      acl1=acl2-al
      endif
      if(ie.eq.npbas(ncpen)) then
      write(iout,99920)ncpen,nelb(ncpen),xbref,xpbref,aclref
99920 format(' ncpen,nelb,xbref,xpbref,aclref =',2i4,3e12.3)
      xbref=xbref+xpbref*(acleng(ie)-aclref)
      xpbref=xpbref+eldat(iadr(nelb(ncpen))+2)
      ybref=ybref+ypbref*(acleng(ie)-aclref)
      ypbref=ypbref+eldat(iadr(nelb(ncpen))+4)
      aclref=acleng(ie)
      ncpen=ncpen+1
      write(iout,99920)ncpen,nelb(ncpen),xbref,xpbref,aclref
      endif
      if(ie.eq.npsbas(ncsub)) then
      write(iout,99921)ncsub,nelsb(ncsub),xbref,xpbref,aclref
99921 format(' ncsub,nelsb,xbref,xpbref,aclref =',2i4,3e12.3)
      xbref=xbref+xpbref*(acleng(ie)-aclref)
      xpbref=xpbref+eldat(iadr(nelsb(ncsub))+2)
      ybref=ybref+ypbref*(acleng(ie)-aclref)
      ypbref=ypbref+eldat(iadr(nelsb(ncsub))+4)
      aclref=acleng(ie)
      ncsub=ncsub+1
      write(iout,99921)ncsub,nelsb(ncsub),xbref,xpbref,aclref
      endif
      IF(MCHFLG.EQ.0)GOTO 1
      WRITE(IOUT,10021)IE,(NAME(INM,NEL),INM=1,8),
     >     xb,xpbref,yb,ypbref
10021 FORMAT(I6,' ',8A1,4(E12.3))
      WRITE(IOUT,10022)IE,(NAME(INM,NEL),INM=1,8),
     >     x1,y1,acl1,x2,y2,acl2
10022 FORMAT(I6,' ',8A1,6(E12.3))
      GOTO 1
    3 IF(MCHFLG.EQ.0)GOTO 1
      NMTOT1=NMTOT1+1
      IF(IMEXP.EQ.2) THEN
        IF(NMTOT1.GT.MISPTR) THEN
          WRITE(IOUT,99665)MXMTR
99665 FORMAT(' TOTAL NUMBER OF MISALIGNED ELEMENTS '
     >,' EXCEEDS MAXIMUM :',I5,/,' CHANGE PARAMETER MXMTR ')
          CALL HALT(16)
          ENDIF
      ENDIF
        IF(NMTOT1.GT.MXMTR) THEN
          WRITE(IOUT,99666)NMTOT1,MXMTR
99666 FORMAT(' TOTAL NUMBER OF MISALIGNED ELEMENTS :',I5,
     >' EXCEEDS MAXIMUM :',I5,/,' CHANGE PARAMETER MXMTR ')
        CALL HALT(16)
      ENDIF
      KMPOS(NMTOT1)=IEP
      AKMIS(1,NMTOT1)=DX1
      AKMIS(2,NMTOT1)=DXP1
      AKMIS(3,NMTOT1)=DY1
      AKMIS(4,NMTOT1)=DYP1
      AKMIS(5,NMTOT1)=DZ1
      AKMIS(6,NMTOT1)=DZC1
      AKMIS(7,NMTOT1)=DZS1
      AKMIS(8,NMTOT1)=DX2
      AKMIS(9,NMTOT1)=DXP2
      AKMIS(10,NMTOT1)=DY2
      AKMIS(11,NMTOT1)=DYP2
      AKMIS(12,NMTOT1)=DZ2
      AKMIS(13,NMTOT1)=DZC2
      AKMIS(14,NMTOT1)=DZS2
      AKMIS(15,NMTOT1)=DDEL
      GOTO 1
    4 DO 41 IC=1,8
      IF(ICHAR(IC).NE.NAME(IC,NEL))GOTO 1
   41 CONTINUE
      DXM=SIGFAC*(DX1-DX2)/2.0D0
      DYM=SIGFAC*(DY1-DY2)/2.0D0
      WRITE(IOUT,10401)IE,DXM,DYM
10401 FORMAT(' ',I6,2E16.4)
      GOTO 1
    5 DO 51 INM=1,IM
      DO 52 INMP=1,8
      IF(NAME(INMP,NEL).NE.MISNAM(INM,INMP))GOTO 51
   52 CONTINUE
      GOTO 53
   51 CONTINUE
      GOTO 1
   53 DO 54 IRN=1,5
      IF(NPOS(INM,IRN,1).EQ.0) GOTO 1
      IF((IE.GE.NPOS(INM,IRN,1)).AND.(IE.LE.NPOS(INM,IRN,2)))GOTO 55
   54 CONTINUE
      GOTO 1
   55 DO 56 IMIS=1,NMTOT
      IF(KMPOS(IMIS).EQ.IE) GOTO 57
   56 CONTINUE
      GOTO 1
   57 CONTINUE
C      WRITE(IOUT,10059)IMIS,KMPOS(IMIS),IE,(AKMIS(II,IMIS),II=1,15)
C10059 FORMAT('  IMIS,KMPOS(IMIS,IE ARE : ',3I6,/
C     >,' ',7E14.5,/,' ',8E14.5,/)
      AKMIS(1,IMIS)=AKMIS(1,IMIS)+FACTM*DX1
      AKMIS(2,IMIS)=AKMIS(2,IMIS)+FACTM*DXP1
      AKMIS(3,IMIS)=AKMIS(3,IMIS)+FACTM*DY1
      AKMIS(4,IMIS)=AKMIS(4,IMIS)+FACTM*DYP1
      AKMIS(5,IMIS)=AKMIS(5,IMIS)+FACTM*DZ1
      C=AKMIS(6,IMIS)
      S=AKMIS(7,IMIS)
      ANG=FACTM*DATAN2(DZS1,DZC1)
      CN=DCOS(ANG)
      SN=DSIN(ANG)
      AKMIS(6,IMIS)=C*CN-S*SN
      AKMIS(7,IMIS)=S*CN+C*SN
      AKMIS(8,IMIS)=AKMIS(8,IMIS)+FACTM*DX2
      AKMIS(9,IMIS)=AKMIS(9,IMIS)+FACTM*DXP2
      AKMIS(10,IMIS)=AKMIS(10,IMIS)+FACTM*DY2
      AKMIS(11,IMIS)=AKMIS(11,IMIS)+FACTM*DYP2
      AKMIS(12,IMIS)=AKMIS(12,IMIS)+FACTM*DZ2
      C=AKMIS(13,IMIS)
      S=AKMIS(14,IMIS)
      ANG=FACTM*DATAN2(DZS2,DZC2)
      CN=DCOS(ANG)
      SN=DSIN(ANG)
      AKMIS(13,IMIS)=C*CN-S*SN
      AKMIS(14,IMIS)=S*CN+C*SN
      AKMIS(15,IMIS)=AKMIS(15,IMIS)+FACTM*DDEL
C      WRITE(IOUT,10059)IMIS,KMPOS(IMIS),IE,(AKMIS(II,IMIS),II=1,15)
    1 CONTINUE
      IF(NRNG.EQ.-2)IMEXP=1
      IF(NRNG.EQ.-1)THEN
         NMTOT=NMTOT1
         IMEXP=1
C         WRITE(IOUT,99668)(KMPOS(NK),NK=1,NMTOT)
C99668 FORMAT(100(' ',14I5,/))
         WRITE(IOUT,99667)NMTOT,MXMTR
99667 FORMAT(' TOTAL NUMBER OF MISALIGNED ELEMENTS : ',I5,/,
     >' MAXIMUM ALLOWED IS MXMTR : ',I5,/)
      ENDIF
      RETURN
      END
      SUBROUTINE SLCOUT(IELM,MATADR)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
C CINTAK : COMMON CONTAINING ARRAYS NEEDED FOR INPUT
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
      NOP=1
      NCHAR=0
      NIPR=1
      CALL INPUT(ICHAR,NCHAR,DATA,MXINP,IEND,NOP,NIPR)
      NSLC=DATA(1)
      RETURN
      END
      SUBROUTINE SOLQUA(IELM,MATADR)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      COMMON/PRODCT/KODEPR,NEL,NOF
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      IAD=IADR(IELM)
      AL =ELDAT(IAD)
      AKQ=ELDAT(IAD+1)
      IF(KUNITS.EQ.1) AKQ = -AKQ
      AKS=ELDAT(IAD+2)
      DO 100 I=1,6
      DO 100 J=1,NOF
      AMAT(J,I,MATADR)=0.0D0
      IF(I.EQ.J) AMAT(J,I,MATADR)=1.0D0
  100 CONTINUE
      IF(AKQ.NE.0.0D0.OR.AKS.NE.0.0D0)GO TO 2
      AMAT(2,1,MATADR)=AL
      AMAT(4,3,MATADR)=AL
      IF(NORDER.EQ.1)RETURN
      AMAT(13,5,MATADR)=AL/2.0D0
      AMAT(22,5,MATADR)=AL/2.0D0
      RETURN
    2 IKQ=1
      IF(AKQ.LT.0.0D0)IKQ=-1
      AKQ4=AKQ*AKQ
      AKS2=AKS*AKS
      AKS3=AKS2*AKS
      AKS4=AKS2*AKS2
      Q2=DSQRT(AKQ4+4.0D0*AKS4)
      Q2I=1.0D0/Q2
      SK1=DSQRT(2.0D0*AKS2+Q2)
      SK3=DSQRT(DABS(Q2-2.0D0*AKS2))
      SS=DSIN(SK1*AL)
      SC=DCOS(SK1*AL)
      BS=DSINH(SK3*AL)
      BC=DCOSH(SK3*AL)
      SKP=0.5D0*(SK1+SK3)
      SKM=0.5D0*(SK1-SK3)
      SKP2=SKP*SKP
      SKP3=SKP2*SKP
      SKM2=SKM*SKM
      SKM3=SKM2*SKM
      AMAT(1,1,MATADR)=Q2I*(SKP2*SC+SKM2*BC)
      AMAT(2,1,MATADR)=Q2I*(SKP*SS-SKM*BS)
      AMAT(3,1,MATADR)=Q2I*AKS*(SKM*SS+SKP*BS)
      AMAT(4,1,MATADR)=Q2I*AKS*(BC-SC)
      AMAT(1,2,MATADR)=Q2I*(-SKP3*SS-SKM3*BS)
      AMAT(2,2,MATADR)=Q2I*(SKP2*SC+SKM2*BC)
      AMAT(3,2,MATADR)=Q2I*AKS3*(SC-BC)
      AMAT(4,2,MATADR)=Q2I*AKS*(SKP*SS-SKM*BS)
      AMAT(1,3,MATADR)=Q2I*AKS*(SKM*BS-SKP*SS)
      AMAT(2,3,MATADR)=Q2I*AKS*(SC-BC)
      AMAT(3,3,MATADR)=Q2I*(SKM2*SC+SKP2*BC)
      AMAT(4,3,MATADR)=Q2I*(SKM*SS+SKP*BS)
      AMAT(1,4,MATADR)=Q2I*AKS3*(BC-SC)
      AMAT(2,4,MATADR)=Q2I*AKS*(-SKM*SS-SKP*BS)
      AMAT(3,4,MATADR)=Q2I*(SKP3*BS-SKM3*SS)
      AMAT(4,4,MATADR)=Q2I*(SKM2*SC+SKP2*BC)
      IF(NORDER.EQ.1)GOTO 300
      DAKS=-AKS
      DAKQ=-AKQ
      DAKQ4=2.0D0*AKQ*DAKQ
      DAKS2=2.0D0*AKS*DAKS
      DAKS3=3.0D0*AKS2*DAKS
      DAKS4=4.0D0*AKS3*DAKS
      DQ2=0.5D0*Q2I*(DAKQ4+4.0D0*DAKS4)
      Q2I2=Q2I*Q2I
      DQ2I=-Q2I2*DQ2
      DSK1=(2.0D0*DAKS2+DQ2)/(2.0D0*SK1)
      DSK3=0.0D0
      IF(SK3.NE.0.0D0)DSK3=(DQ2-2.0D0*DAKS2)/(2.0D0*SK3)
      DSS=SC*DSK1*AL
      DSC=-SS*DSK1*AL
      DBS=BC*DSK3*AL
      DBC=BS*DSK3*AL
      DSKP=0.5D0*(DSK1+DSK3)
      DSKM=0.5D0*(DSK1-DSK3)
      DSKP2=2.0D0*SKP*DSKP
      DSKP3=3.0D0*SKP2*DSKP
      DSKM2=2.0D0*SKM*DSKM
      DSKM3=3.0D0*SKM2*DSKM
      AMAT(12,1,MATADR)=DQ2I*(SKP2*SC+SKM2*BC)+
     > Q2I*(DSKP2*SC+SKP2*DSC+DSKM2*BC+SKM2*DBC)
      AMAT(17,1,MATADR)=DQ2I*(SKP*SS-SKM*BS)+
     > Q2I*(DSKP*SS+SKP*DSS-DSKM*BS-SKM*DBS)
      AMAT(21,1,MATADR)=(DQ2I*AKS+Q2I*DAKS)*(SKM*SS+SKP*BS)
     > +Q2I*AKS*(DSKM*SS+SKM*DSS+DSKP*BS+SKP*DBS)
      AMAT(24,1,MATADR)=(DQ2I*AKS+Q2I*DAKS)*(BC-SC)
     > +Q2I*AKS*(DBC-DSC)
      AMAT(12,2,MATADR)=DQ2I*(-SKP3*SS-SKM3*BS)
     > +Q2I*(-DSKP3*SS-SKP3*DSS-DSKM3*BS-SKM3*DBS)
      AMAT(17,2,MATADR)=AMAT(12,1,MATADR)
      AMAT(21,2,MATADR)=(DQ2I*AKS3+Q2I*DAKS3)*(SC-BC)
     > +Q2I*AKS3*(DSC-DBC)
      AMAT(24,2,MATADR)=(DQ2I*AKS+Q2I*DAKS)*(SKP*SS-SKM*BS)
     > +Q2I*AKS*(DSKP*SS+SKP*DSS-DSKM*BS-SKM*DBS)
      AMAT(12,3,MATADR)=-AMAT(24,2,MATADR)
      AMAT(17,3,MATADR)=-AMAT(24,1,MATADR)
      AMAT(21,3,MATADR)=DQ2I*(SKM2*SC+SKP2*BC)
     > +Q2I*(DSKM2*SC+SKM2*DSC+DSKP2*BC+SKP2*DBC)
      AMAT(24,3,MATADR)=DQ2I*(SKM*SS+SKP*BS)
     > +Q2I*(DSKM*SS+SKM*DSS+DSKP*BS+SKP*DBS)
      AMAT(12,4,MATADR)=-AMAT(21,2,MATADR)
      AMAT(17,4,MATADR)=-AMAT(21,1,MATADR)
      AMAT(21,4,MATADR)=DQ2I*(SKP3*BS-SKM3*SS)
     > +Q2I*(DSKP3*BS+SKP3*DBS-DSKM3*SS-SKM3*DSS)
      AMAT(24,4,MATADR)=AMAT(21,3,MATADR)
      AISSSC=0.0D0
      IF(SK1.NE.0.0D0)AISSSC=SS*SS/(2.0D0*SK1)
      AIBSBC=0.0D0
      IF(SK3.NE.0.0D0)AIBSBC=BS*BS/(2.0D0*SK3)
      AISSBC=Q2I*(SK3*SS*BS-SK1*SC*BC+SK1)
      AISCBS=Q2I*(SK3*SC*BC+SK1*SS*BS-SK3)
      AISS2=0.0D0
      AISC2=AL
      AIBS2=0.0D0
      AIBC2=AL
      IF(SK1.NE.0.0D0)AISS2=0.5D0*(AL-SS*SC/SK1)
      IF(SK1.NE.0.0D0)AISC2=0.5D0*(AL+SS*SC/SK1)
      IF(SK3.NE.0.0D0)AIBS2=0.5D0*(BS*BC/SK3 - AL)
      IF(SK3.NE.0.0D0)AIBC2=0.5D0*(AL+BS*BC/SK3)
      AISSBS=Q2I*(SK3*SS*BC-SK1*SC*BS)
      AISCBC=Q2I*(SK1*SS*BC+SK3*SC*BS)
      AKS5=AKS4*AKS
      AKS6=AKS5*AKS
      SKP4=SKP3*SKP
      SKP5=SKP4*SKP
      SKP6=SKP5*SKP
      SKM4=SKM3*SKM
      SKM5=SKM4*SKM
      SKM6=SKM5*SKM
      Q4I=Q2I*Q2I
      AMAT(7,5,MATADR)=Q4I*0.5D0*(SKP6*AISS2+SKM6*AIBS2-2.0D0*SKP3*SKM3
     >   *AISSBS+AKS6*(AISC2+AIBC2-2.0D0*AISCBC))
      AMAT(8,5,MATADR)=Q4I*(-SKP5*AISSSC-SKP3*SKM2*AISSBC
     >      -SKM3*SKP2*AISCBS
     > -SKM5*AIBSBC-AKS4*(-SKM*AISSSC-SKP*AISCBS+SKM*AISSBC+SKP*AIBSBC))
      AMAT(9,5,MATADR)=Q4I*AKS3*((SKP3-SKM3)*(AISSBC-AISSSC)
     >  +(SKP3+SKM3)*(AIBSBC-AISCBS))
      AMAT(10,5,MATADR)=Q4I*(AKS*(-SKP4*AISS2-(SKP3*SKM+SKM3*SKP)*AISSBS
     >  +SKM4*AIBS2)+AKS3*(-SKM2*AISC2-(SKP2-SKM2)*AISCBC+SKP2*AIBC2))
      AMAT(13,5,MATADR)=Q4I*0.5D0*(SKP4*AISC2+2.0D0*SKP2*SKM2*AISCBC
     >  +SKM4*AIBC2+AKS2*(SKM2*AISS2+2.0D0*SKP*SKM*AISSBS+SKP2*AIBS2))
      AMAT(14,5,MATADR)=Q4I*(AKS3*(SKP2*AISC2-(SKP2-SKM2)*AISCBC
     >  -SKM2*AIBC2)-AKS*(-SKM4*AISS2+(SKM*SKP3-SKP*SKM3)*AISSBS+
     >  SKP4*AIBS2))
      AMAT(15,5,MATADR)=Q4I*AKS*((SKP3-SKM3)*AISSSC-(SKP2*SKM+SKP*SKM2)
     >  *AISCBS+(SKM2*SKP-SKM*SKP2)*AISSBC-(SKM3+SKP3)*AIBSBC)
      AMAT(18,5,MATADR)=Q4I*0.5D0*(AKS6*(AISC2-2.0D0*AISCBC+AIBC2)
     >  +SKM6*AISS2-2.0D0*SKM3*SKP3*AISSBS+SKP6*AIBS2)
      AMAT(19,5,MATADR)=Q4I*(AKS4*(SKP*AISSSC-SKM*AISCBS-SKP*AISSBC
     >  +SKM*AIBSBC)-SKM5*AISSSC-SKM3*SKP2*AISSBC+SKP3*SKM2*AISCBS
     >  +SKP5*AIBSBC)
      AMAT(22,5,MATADR)=Q4I*0.5D0*(AKS2*(SKP2*AISS2-2.0D0*SKP*SKM*AISSBS
     > +SKM2*AIBS2)+SKM4*AISC2+2.0D0*SKM2*SKP2*AISCBC+SKP4*AIBC2)
  300 IF(IKQ.GE.0)RETURN
C
C     SET UP THE 90 DEGREE KICK MATRIX IN TEMP
C
      DO 10 IX = 1,6
      DO 10 IY = 1,NOF
      TEMP(IX,IY)=0.0D0
10    CONTINUE
      TEMP(1,3)=1
      TEMP(2,4)=1.0D0
      TEMP(3,1)=-1.0D0
      TEMP(4,2)=-1.0D0
      TEMP(5,5)=1.0D0
      TEMP(6,6)=1.0D0
       KODEPR=15
      CALL PROMAT(IELM,MATADR)
C
C  SET -90 DEGREE KICK MATRIX IN AMAT
C
      DO 200 I=1,6
      DO 200 J=1,NOF
      AMAT(J,I,MATADR)=0.0D0
 200  CONTINUE
      AMAT(3,1,MATADR)=-1.0D0
      AMAT(4,2,MATADR)=-1.0D0
      AMAT(1,3,MATADR)=1.0D0
      AMAT(2,4,MATADR)=1.0D0
      AMAT(5,5,MATADR)=1.0D0
      AMAT(6,6,MATADR)=1.0D0
      KODEPR=8
      CALL PROMAT(IELM,MATADR)
C
C     PUT TEMP INTO AMAT(27,6,MATADR)
C
      DO 20 IX=1,6
      DO 20 IY=1,NOF
  20  AMAT(IY,IX,MATADR) = TEMP(IX,IY)
      RETURN
      END
      SUBROUTINE Spchg(IEND)
C     *************************
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXINP = 100)
      PARAMETER    (mxpart = 128000)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      character*1 ichar
      common/cspch/delspx(mxpart),delspy(mxpart),
     >dpmax,dkxmax,dkymax,ispopt,ispchf
      NOP=-1
      NCHAR=0
      NDIM=100
      NIPR=1
      ispchf=0
      CALL INPUT(ICHAR,NCHAR,data,NDIM,IEND,NOP,NIPR)
      ispopt=data(1)
      dpmax=data(2)
      dkxmax=data(3)
      dkymax=data(4)
      if(ispopt.ge.1)ispchf=1
      return
      end
      SUBROUTINE SYMMTX(NS)
C     *************************************************************
C
C  COMPUTES MATRICES IN CANONICAL VARIABLES AND SETS UP MATRICES
C  FOR SYMPLECTIC TRACING.  !!! WARNING !!! WHEN CALLED BY THE
C  "SET SYMPLECTIC OPTION" OPERATION, THIS SUBROUTINE WIPES OUT
C  THE CONTENTS OF THE AMAT ARRAY, REPLACING IT WITH MATRICES IN
C  TERMS OF CANONICAL VARIABLES X,PX,Y,PY,-T,E
C
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON /SYMMAP/ BSYMAT(6,6,MAXMAT),CSYMAT(6,27,MAXMAT)
      PARAMETER  (MAXDAT = 16000)
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/SYM/ENERLI,GAMMLI,BETALI,bili,b2li,b2ili,
     >ISYOPT,ISYFLG,MATTOT,KANVAR
      DIMENSION AX(6,27),ACAN(6,27),BX(6,6),CX(6,27)
      itflg=0
      if(ns.lt.0) itflg=1
      DO 1000 JNDEX=1,MATTOT
      INDEX=JNDEX
      IF(NS.GT.0) INDEX=NS
      do 101 iel=1,nelm
      if(madr(iel).ne.index) goto 101
c      if(kode(iel).ne.9)itflg=0
c      if(kode(iel).eq.9)itflg=1
      goto 102
  101 continue
  102 continue
      DO 1 IM=1,6
      DO 1 JM=1,27
    1 AX(IM,JM)=AMAT(JM,IM,INDEX)
C
C  CALL CMAP TO CONVERT TO CANONICAL VARIABLES AND GET TRACING MATRICES
C  BX,CX
C
      CALL CMAP(AX,ACAN,BX,CX,GAMMLI,BETALI,index,itflg)
      DO 2 IM=1,6
      DO 2 JM=1,6
    2 BSYMAT(JM,IM,INDEX)=BX(JM,IM)
      DO 3 IM=1,27
      DO 3 JM=1,6
    3 CSYMAT(JM,IM,INDEX)=CX(JM,IM)
C
C  NOW RELOAD CANONICAL MATRIX ACAN INTO AMAT
C
      DO 4 IM=1,6
      DO 4 JM=1,27
    4 AMAT(JM,IM,INDEX)=ACAN(IM,JM)
      IF(NS.GT.0) RETURN
 1000 CONTINUE
      RETURN
      END
      SUBROUTINE SYMRAT(icpart,INDEX,ZI,ZF)
C
C***********************************************************************
C
C THIS IS OLD NEWTON SEARCH SYSTEM SOLVER - SHOULD NOT BE USED (4/24/85)
C
      IMPLICIT REAL*8 (A-H,O-Z)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXMAT = 500)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON /SYMMAP/ BSYMAT(6,6,MAXMAT),CSYMAT(6,27,MAXMAT)
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      DIMENSION ZI(6),ZF(6)
      DIMENSION RLIN(3,3),RINV(3,3)
      DIMENSION XTEMP(6),P0(3),PTEMP(3),PMAP(3),ZTEMP(6),DELP(3),CP(3)
      DIMENSION IAD1(27,2),IAD2(6,3),RWT(6,3)
      DATA
     & IAD1
     & /1,2,3,4,5,6,1,1,1,1,1,1,2,2,2,2,2,3,3,3,3,4,4,4,5,5,6,
     & 0,0,0,0,0,0,1,2,3,4,5,6,2,3,4,5,6,3,4,5,6,4,5,6,5,6,6/,
     & IAD2
     & /8,13,14,15,16,17,10,15,19,22,23,24,12,17,21,24,26,27/,
     & RWT
     & /1.D0,2.D0,1.D0,1.D0,1.D0,1.D0,1.D0,1.D0,1.D0,2.D0,1.D0,1.D0,
     & 1.D0,1.D0,1.D0,1.D0,1.D0,2.D0/
C     WRITE(6,99998) (ZI(J),J=1,6)
C9998 FORMAT(' IN SYMRAT, I.C. ARE:',/,6(' 'E12.6))
C
C  INITIALISE GLOBAL VARIABLES ZF,P0, AND INITIAL GUESS XTEMP FOR
C  NEWTON SEARCH
C
      DO 10 J=1,6
      ZF(J)   =0.D0
      XTEMP(J)=ZI(J)
   10 CONTINUE
      DO 20 J=1,3
      P0(J)   =ZI(2*J)
   20 CONTINUE
C
C  NEWTON SEARCH FOR IMAGE ZTEMP OF ZI UNDER NONLINEAR TRANSFORM CSYMAT
C
      DO 5000 ILOOP=1,50
C
C          INITIALISATIONS FOR EACH ITERATE
C
      DO 500 J=1,3
      PTEMP(J)=XTEMP(2*J)
      CP(J)   =XTEMP(2*J)
      PMAP(J) =P0(J)
  500 CONTINUE
      DO 520 K=1,3
      DO 510 J=1,3
      RLIN(J,K)=0.D0
  510 CONTINUE
      RLIN(K,K)=1.D0
  520 CONTINUE
C
C  EVALUATE IMAGE PMAP OF PTEMP UNDER NONLINEAR MAP
C
      DO 540 K=7,27
      XTXT=XTEMP(IAD1(K,1))*XTEMP(IAD1(K,2))
      DO 530 J=1,3
C
      PMAP(J)=PMAP(J)+CSYMAT(2*J,K,INDEX)*XTXT
C (IS JUST CSYMAT(2*J,K,INDEX)*XTEMP(IAD1(K,1))*XTEMP(IAD1(K,2))   )
C
  530 CONTINUE
  540 CONTINUE
C
C  EVALUATED LINEARISED MAP AND ITS INVERSE AT PTEMP
C
      DO 570 J=  1,3
      DO 560 K=  1,3
      DO 550 LYN=1,6
C
      RLIN(J,K)=RLIN(J,K)-
     &   RWT(LYN,K)*CSYMAT(2*J,IAD2(LYN,K),INDEX)*XTEMP(LYN)
C
  550 CONTINUE
  560 CONTINUE
  570 CONTINUE
C
C  THIS SETS RLIN [WHICH IS (IDENTITY)-(JACOBIAN EVALUATED AT PTEMP)]
C  NOW FIND ITS INVERSE, RINV
C
      DET= 1.D0/( RLIN(1,1)*RLIN(2,2)*RLIN(3,3)
     &           +RLIN(1,2)*RLIN(2,3)*RLIN(3,1)
     &           +RLIN(1,3)*RLIN(2,1)*RLIN(3,2)
     &           -RLIN(1,1)*RLIN(2,3)*RLIN(3,2)
     &           -RLIN(1,2)*RLIN(2,1)*RLIN(3,3)
     &           -RLIN(1,3)*RLIN(2,2)*RLIN(3,1) )
C
      RINV(1,1)=(RLIN(2,2)*RLIN(3,3)-RLIN(3,2)*RLIN(2,3))*DET
      RINV(2,2)=(RLIN(1,1)*RLIN(3,3)-RLIN(1,3)*RLIN(3,1))*DET
      RINV(3,3)=(RLIN(1,1)*RLIN(2,2)-RLIN(1,2)*RLIN(2,1))*DET
C
      RINV(1,2)=(RLIN(1,3)*RLIN(3,2)-RLIN(1,2)*RLIN(3,3))*DET
      RINV(1,3)=(RLIN(1,2)*RLIN(2,3)-RLIN(2,2)*RLIN(1,3))*DET
C
      RINV(2,1)=(RLIN(2,3)*RLIN(3,1)-RLIN(2,1)*RLIN(3,3))*DET
      RINV(2,3)=(RLIN(2,1)*RLIN(1,3)-RLIN(1,1)*RLIN(2,3))*DET
C
      RINV(3,1)=(RLIN(2,1)*RLIN(3,2)-RLIN(2,2)*RLIN(3,1))*DET
      RINV(3,2)=(RLIN(1,2)*RLIN(3,1)-RLIN(1,1)*RLIN(3,2))*DET
C
C  SET THE CORRECTION TO THE ILOOP-TH GUESS - I.E. COMPUTE THE ILOOP-TH
C  ITERATE OF THE CONTRACTION MAP ON THE INITIAL GUESS.
C  CP = IMAGE OF PTEMP UNDER THE CONTRACTION MAP
C
      DO 590 K=1,3
      XXXX=PTEMP(K)-PMAP(K)
      DO 580 J=1,3
C
      CP(J)=CP(J)-RINV(J,K)*XXXX
C
  580 CONTINUE
  590 CONTINUE
      DO 591 K=1,3
      DELP(K)   =CP(K)-PTEMP(K)
      XTEMP(2*K)=CP(K)
  591 CONTINUE
C
C  AT THIS POINT, THE "NEW GUESS" FOR PF (THE FINAL P VALUE)
C  IS ESTABLISHED AND MAY BE FOUND IN CP, AND WE HAVE RESET XTEMP TO
C  THE VALUES (X,CP(1),Y,CP(2),T,CP(3)). NOW CHECK FOR CONVERGENCE BY
C  LOOKING AT DELP (COMPUTER DEPENDENT CRITERION).  HERE WE CHOOSE
C  AN ERROR OF 1.D-11   FOR CONVERGENCE
C
      PCHNG=DABS(DELP(1))+DABS(DELP(2))+DABS(DELP(3))
      CPLEN=(1.D-11)*(DABS(CP(1))+DABS(CP(2))+DABS(CP(3)))
      IF(PCHNG.LE.CPLEN) GO TO 6000
 5000 CONTINUE
      write(iout,5001)ncturn,icpart,(zi(jz),jz=1,6)
 5001 FORMAT(' DURING TURN # ',I6,
     >' NEWTON SEARCH FAILS TO CONVERGE IN 50 ITERATIONS ',/,
     >' WHILE TRACKING PARTICLE #',
     >I5,' WITH INITIAL COORDINATES',/,6E14.5,/)
 6000 CONTINUE
C
C  TO FINISH COMPUTING THE NONLINEAR TRANSFORMATION, USE THE GENERATING
C  FUNCTION APPROACH TO EVALUATE "NEW" COORDINATES, GIVEN THE "OLD"
C  COORDINATES AND "NEW" MOMENTUM AS STORED IN XTEMP
C
      DO 601 J=1,6
      ZTEMP(J)=XTEMP(J)
  601 CONTINUE
      DO 610 K=7,27
      DO 600 J=1,3
C     COMPUTE NEW COORDINATES
      ZTEMP(2*J-1)=ZTEMP(2*J-1)
     &       +CSYMAT(2*J-1,K,INDEX)*XTEMP(IAD1(K,1))*XTEMP(IAD1(K,2))
C     COMPUTE OLD MOMENTA
      ZTEMP(2*J)  =ZTEMP(2*J)
     &       -CSYMAT(2*J,K,INDEX)*XTEMP(IAD1(K,1))*XTEMP(IAD1(K,2))
  600 CONTINUE
  610 CONTINUE
C
C  FLAG OLD MOMENTA COMPUTATIONS FOR CONSISTANCY
C     CHECK ZI(2,4, AND 6) VS. ZTEMP(2,4,AND 6).
C                    (MAY BYPASS THIS AFTER DEBUGGING)
C  FLAG CRITERION IS MACHINE DEPENDENT - WE TOLERATE ERRORS OF 1.D-15
C
      PERR=DABS(ZTEMP(2)-ZI(2))+DABS(ZTEMP(4)-ZI(4))
     &    +DABS(ZTEMP(6)-ZI(6))
      PLEN=(1.D-10)*(DABS(ZI(2))+DABS(ZI(4))+DABS(ZI(6)))
      IF (PERR.GT.PLEN) PRINT 611
  611 FORMAT(29H * MOMENTUM ERROR IN SYMRAT *)
C
C  RESET ZTEMP TO CONTAIN "NEW" MOMENTUM AS WELL AS "NEW" COORDINATES
C  TO COMPUTE ZF
C
      DO 620 J=2,6,2
      ZTEMP(J)=XTEMP(J)
  620 CONTINUE
C
C  FINALLY, TRANSFORM BY THE LINEAR TRANSFORMATION TO GET ZF
C
      DO 710 K=1,6
      DO 700 J=1,6
      ZF(J)=ZF(J)+BSYMAT(J,K,INDEX)*ZTEMP(K)
  700 CONTINUE
  710 CONTINUE
C
C  IMAGE OF ZI IS NOW STORED IN ZF
C
C     WRITE(6,99999) (ZF(J),J=1,6)
C9999 FORMAT(' IN SYMRAT ZF IS:',/,6(' ',E12.6))
      RETURN
      END

      SUBROUTINE SYMRTX(icpart,INDX,ZI,ZF)
C
C***********************************************************************
C
C  THIS IS THE 2ND VERSION OF 2/13/86.FOR DOCUMENTATION ON THE ALGORITHM
C  SEE "ANALYSIS OF NUMERICAL METHODS" BY ISAACSON AND KELLER,PP.120-122
C
      IMPLICIT REAL*8 (A-H,O-Z)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXMAT = 500)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON /SYMMAP/ BSYMAT(6,6,MAXMAT),CSYMAT(6,27,MAXMAT)
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
      DIMENSION ZI(6),ZF(6),p(6)
      common /ctrsym/
     >bs11,bs12,bs13,bs14,bs15,bs16,bs21,bs22,bs23,bs24,bs25,bs26,
     >bs31,bs32,bs33,bs34,bs35,bs36,bs41,bs42,bs43,bs44,bs45,bs46,
     >bs51,bs52,bs53,bs54,bs55,bs56,
     >cs17,cs18,cs19,cs110,cs111,cs112,cs113,cs114,cs115,cs116,cs117,
     >cs118,cs119,cs120,cs121,cs122,cs123,cs124,cs125,cs126,cs127,
     >cs27,cs28,cs29,cs210,cs211,cs212,cs213,cs214,cs215,cs216,cs217,
     >cs218,cs219,cs220,cs221,cs222,cs223,cs224,cs225,cs226,cs227,
     >cs37,cs38,cs39,cs310,cs311,cs312,cs313,cs314,cs315,cs316,cs317,
     >cs318,cs319,cs320,cs321,cs322,cs323,cs324,cs325,cs326,cs327,
     >cs47,cs48,cs49,cs410,cs411,cs412,cs413,cs414,cs415,cs416,cs417,
     >cs418,cs419,cs420,cs421,cs422,cs423,cs424,cs425,cs426,cs427,
     >cs57,cs58,cs59,cs510,cs511,cs512,cs513,cs514,cs515,cs516,cs517,
     >cs518,cs519,cs520,cs521,cs522,cs523,cs524,cs525,cs526,cs527,
     >isysav
      DATA TOLER/1.D-10/
c      isysav=0

      X7 =ZI(1)*ZI(1)
      X9 =ZI(1)*ZI(3)
      X11=ZI(1)*ZI(5)
      X18=ZI(3)*ZI(3)
      X20=ZI(3)*ZI(5)
      X25=ZI(5)*ZI(5)
C
      if(isysav.eq.0)                       then
      C01=ZI(2)
     &         +CSYMAT(2,7,INDX) *X7 +CSYMAT(2,9,INDX) *X9
     &         +CSYMAT(2,11,INDX)*X11+CSYMAT(2,18,INDX)*X18
     &         +CSYMAT(2,20,INDX)*X20+CSYMAT(2,25,INDX)*X25
      C02=ZI(4)
     &         +CSYMAT(4,7,INDX) *X7 +CSYMAT(4,9,INDX) *X9
     &         +CSYMAT(4,11,INDX)*X11+CSYMAT(4,18,INDX)*X18
     &         +CSYMAT(4,20,INDX)*X20+CSYMAT(4,25,INDX)*X25
c      C03=ZI(6)
c     &         +CSYMAT(6,7,INDX) *X7 +CSYMAT(6,9,INDX) *X9
c     &         +CSYMAT(6,11,INDX)*X11+CSYMAT(6,18,INDX)*X18
c     &         +CSYMAT(6,20,INDX)*X20+CSYMAT(6,25,INDX)*X25
C
      C11=CSYMAT(2,8,INDX)*ZI(1) +CSYMAT(2,14,INDX)*ZI(3)
     &                           +CSYMAT(2,16,INDX)*ZI(5)
      C12=CSYMAT(4,8,INDX)*ZI(1) +CSYMAT(4,14,INDX)*ZI(3)
     &                           +CSYMAT(4,16,INDX)*ZI(5)
c      C13=CSYMAT(6,8,INDX)*ZI(1) +CSYMAT(6,14,INDX)*ZI(3)
c     &                           +CSYMAT(6,16,INDX)*ZI(5)
      C21=CSYMAT(2,10,INDX)*ZI(1)+CSYMAT(2,19,INDX)*ZI(3)
     &                           +CSYMAT(2,23,INDX)*ZI(5)
      C22=CSYMAT(4,10,INDX)*ZI(1)+CSYMAT(4,19,INDX)*ZI(3)
     &                           +CSYMAT(4,23,INDX)*ZI(5)
c      C23=CSYMAT(6,10,INDX)*ZI(1)+CSYMAT(6,19,INDX)*ZI(3)
c     &                           +CSYMAT(6,23,INDX)*ZI(5)
      C31=CSYMAT(2,12,INDX)*ZI(1)+CSYMAT(2,21,INDX)*ZI(3)
     &                           +CSYMAT(2,26,INDX)*ZI(5)
      C32=CSYMAT(4,12,INDX)*ZI(1)+CSYMAT(4,21,INDX)*ZI(3)
     &                           +CSYMAT(4,26,INDX)*ZI(5)
c      C33=CSYMAT(6,12,INDX)*ZI(1)+CSYMAT(6,21,INDX)*ZI(3)
c     &                           +CSYMAT(6,26,INDX)*ZI(5)
C
      C213=CSYMAT(2,13,INDX)
      C413=CSYMAT(4,13,INDX)
c      C613=CSYMAT(6,13,INDX)
      C215=CSYMAT(2,15,INDX)
      C415=CSYMAT(4,15,INDX)
c      C615=CSYMAT(6,15,INDX)
      C217=CSYMAT(2,17,INDX)
      C417=CSYMAT(4,17,INDX)
c      C617=CSYMAT(6,17,INDX)
      C222=CSYMAT(2,22,INDX)
      C422=CSYMAT(4,22,INDX)
c      C622=CSYMAT(6,22,INDX)
      C224=CSYMAT(2,24,INDX)
      C424=CSYMAT(4,24,INDX)
c      C624=CSYMAT(6,24,INDX)
      C227=CSYMAT(2,27,INDX)
      C427=CSYMAT(4,27,INDX)
c      C627=CSYMAT(6,27,INDX)
                                       else
      C01=ZI(2)
     &         +cs27 *X7 +cs29 *X9
     &         +cs211*X11+cs218*X18
     &         +cs220*X20+cs225*X25
      C02=ZI(4)
     &         +cs47 *X7 +cs49 *X9
     &         +cs411*X11+cs418*X18
     &         +cs420*X20+cs425*X25
c      C03=ZI(6)
c     &         +cs67 *X7 +cs69 *X9
c     &         +cs611*X11+cs618*X18
c     &         +cs620*X20+cs625*X25
C
      C11=cs28*ZI(1) +cs214*ZI(3)
     &                           +cs216*ZI(5)
      C12=cs48*ZI(1) +cs414*ZI(3)
     &                           +cs416*ZI(5)
c      C13=cs68*ZI(1) +cs614*ZI(3)
c     &                           +cs616*ZI(5)
      C21=cs210*ZI(1)+cs219*ZI(3)
     &                           +cs223*ZI(5)
      C22=cs410*ZI(1)+cs419*ZI(3)
     &                           +cs423*ZI(5)
c      C23=cs610*ZI(1)+cs619*ZI(3)
c     &                           +cs623*ZI(5)
      C31=cs212*ZI(1)+cs221*ZI(3)
     &                           +cs226*ZI(5)
      C32=cs412*ZI(1)+cs421*ZI(3)
     &                           +cs426*ZI(5)
c      C33=cs612*ZI(1)+cs621*ZI(3)
c     &                           +cs626*ZI(5)
C
      C213=cs213
      C413=cs413
c      C613=cs613
      C215=cs215
      C415=cs415
c      C615=cs615
      C217=cs217
      C417=cs417
c      C617=cs617
      C222=cs222
      C422=cs422
c      C622=cs622
      C224=cs224
      C424=cs424
c      C624=cs624
      C227=cs227
      C427=cs427
c      C627=cs627
      endif
c
      A1=1.D0-C11
      A2=1.D0-C22
c      A3=1.D0-C33
C
      P1=ZI(2)
      P2=ZI(4)
      P3=ZI(6)
C
C  SEARCH FOR IMAGE OF ZI UNDER NONLINEAR TRANSFORM CSYMAT
C
      DO 5000 ILOOP=1,50
C
      P4=P1*P1
      P5=P1*P2
      P6=P1*P3
      P7=P2*P2
      P8=P2*P3
      P9=P3*P3
C
      CP1 = P1 + (  C01 - P1 + C11*P1 + C21*P2 + C31*P3
     & + C213*P4 + C215*P5 + C217*P6 + C222*P7 + C224*P8 + C227*P9  )
     & /(  A1 - 2.D0*C213*P1 - C215*P2 - C217*P3  )
      CP2 = P2 + (  C02 - P2 + C12*P1 + C22*P2 + C32*P3
     & + C413*P4 + C415*P5 + C417*P6 + C422*P7 + C424*P8 + C427*P9  )
     & /(  A2 - C415*P1 - 2.D0*C422*P2 - C424*P3  )
c      CP3 = P3 + (  C03 - P3 + C13*P1 + C23*P2 + C33*P3
c     & + C613*P4 + C615*P5 + C617*P6 + C622*P7 + C624*P8 + C627*P9  )
c     & /(  A3 - C617*P1 - C624*P2 - 2.D0*C627*P3  )
      cp3=p3
C
       IF(  (DABS(CP1-P1)+DABS(CP2-P2)+DABS(CP3-P3))  .LE.
     &       ((DABS(CP1)+DABS(CP2)+DABS(CP3))*TOLER)  )GO TO 6000
      P1=CP1
      P2=CP2
c      P3=CP3
 5000 CONTINUE
      write(iout,5001)ncturn,icpart,(zi(jz),jz=1,6)
 5001 FORMAT(' DURING TURN # ',I6,
     >' NEWTON SEARCH FAILS TO CONVERGE IN 50 ITERATIONS ',/,
     >' WHILE TRACKING PARTICLE #',
     >I5,' WITH INITIAL COORDINATES',/,6E14.5,/)
 6000 CONTINUE
c
      X8 =ZI(1)*CP1
      X10=ZI(1)*CP2
      X12=ZI(1)*CP3
      X13= p4
      X14=  CP1*ZI(3)
      X15= p5
      X16=  CP1*ZI(5)
      X17= p6
      X19=ZI(3)*CP2
      X21=ZI(3)*CP3
      X22= p7
      X23=  CP2*ZI(5)
      X24= p8
      X26=ZI(5)*CP3
      X27= p9
C
      if(isysav.eq.0)                           then
      ZI(1)  =  ZI(1)
     &+CSYMAT(1,7,INDX)*X7  +CSYMAT(1,8,INDX)*X8  +CSYMAT(1,9,INDX)*X9
     &+CSYMAT(1,10,INDX)*X10+CSYMAT(1,11,INDX)*X11+CSYMAT(1,12,INDX)*X12
     &+CSYMAT(1,13,INDX)*X13+CSYMAT(1,14,INDX)*X14+CSYMAT(1,15,INDX)*X15
     &+CSYMAT(1,16,INDX)*X16+CSYMAT(1,17,INDX)*X17+CSYMAT(1,18,INDX)*X18
     &+CSYMAT(1,19,INDX)*X19+CSYMAT(1,20,INDX)*X20+CSYMAT(1,21,INDX)*X21
     &+CSYMAT(1,22,INDX)*X22+CSYMAT(1,23,INDX)*X23+CSYMAT(1,24,INDX)*X24
     &+CSYMAT(1,25,INDX)*X25+CSYMAT(1,26,INDX)*X26+CSYMAT(1,27,INDX)*X27
      ZI(3)  =  ZI(3)
     &+CSYMAT(3,7,INDX)*X7  +CSYMAT(3,8,INDX)*X8  +CSYMAT(3,9,INDX)*X9
     &+CSYMAT(3,10,INDX)*X10+CSYMAT(3,11,INDX)*X11+CSYMAT(3,12,INDX)*X12
     &+CSYMAT(3,13,INDX)*X13+CSYMAT(3,14,INDX)*X14+CSYMAT(3,15,INDX)*X15
     &+CSYMAT(3,16,INDX)*X16+CSYMAT(3,17,INDX)*X17+CSYMAT(3,18,INDX)*X18
     &+CSYMAT(3,19,INDX)*X19+CSYMAT(3,20,INDX)*X20+CSYMAT(3,21,INDX)*X21
     &+CSYMAT(3,22,INDX)*X22+CSYMAT(3,23,INDX)*X23+CSYMAT(3,24,INDX)*X24
     &+CSYMAT(3,25,INDX)*X25+CSYMAT(3,26,INDX)*X26+CSYMAT(3,27,INDX)*X27
      ZI(5)  =  ZI(5)
     &+CSYMAT(5,7,INDX)*X7  +CSYMAT(5,8,INDX)*X8  +CSYMAT(5,9,INDX)*X9
     &+CSYMAT(5,10,INDX)*X10+CSYMAT(5,11,INDX)*X11+CSYMAT(5,12,INDX)*X12
     &+CSYMAT(5,13,INDX)*X13+CSYMAT(5,14,INDX)*X14+CSYMAT(5,15,INDX)*X15
     &+CSYMAT(5,16,INDX)*X16+CSYMAT(5,17,INDX)*X17+CSYMAT(5,18,INDX)*X18
     &+CSYMAT(5,19,INDX)*X19+CSYMAT(5,20,INDX)*X20+CSYMAT(5,21,INDX)*X21
     &+CSYMAT(5,22,INDX)*X22+CSYMAT(5,23,INDX)*X23+CSYMAT(5,24,INDX)*X24
     &+CSYMAT(5,25,INDX)*X25+CSYMAT(5,26,INDX)*X26+CSYMAT(5,27,INDX)*X27
C
      ZF(1)= BSYMAT(1,1,INDX)*ZI(1) + BSYMAT(1,2,INDX)*CP1
     &      +BSYMAT(1,3,INDX)*ZI(3) + BSYMAT(1,4,INDX)*CP2
     &      +BSYMAT(1,5,INDX)*ZI(5) + BSYMAT(1,6,INDX)*CP3
      ZF(2)= BSYMAT(2,1,INDX)*ZI(1) + BSYMAT(2,2,INDX)*CP1
     &      +BSYMAT(2,3,INDX)*ZI(3) + BSYMAT(2,4,INDX)*CP2
     &      +BSYMAT(2,5,INDX)*ZI(5) + BSYMAT(2,6,INDX)*CP3
      ZF(3)= BSYMAT(3,1,INDX)*ZI(1) + BSYMAT(3,2,INDX)*CP1
     &      +BSYMAT(3,3,INDX)*ZI(3) + BSYMAT(3,4,INDX)*CP2
     &      +BSYMAT(3,5,INDX)*ZI(5) + BSYMAT(3,6,INDX)*CP3
      ZF(4)= BSYMAT(4,1,INDX)*ZI(1) + BSYMAT(4,2,INDX)*CP1
     &      +BSYMAT(4,3,INDX)*ZI(3) + BSYMAT(4,4,INDX)*CP2
     &      +BSYMAT(4,5,INDX)*ZI(5) + BSYMAT(4,6,INDX)*CP3
      ZF(5)= BSYMAT(5,1,INDX)*ZI(1) + BSYMAT(5,2,INDX)*CP1
     &      +BSYMAT(5,3,INDX)*ZI(3) + BSYMAT(5,4,INDX)*CP2
     &      +BSYMAT(5,5,INDX)*ZI(5) + BSYMAT(5,6,INDX)*CP3
c      ZF(6)= BSYMAT(6,1,INDX)*ZI(1) + BSYMAT(6,2,INDX)*CP1
c     &      +BSYMAT(6,3,INDX)*ZI(3) + BSYMAT(6,4,INDX)*CP2
c     &      +BSYMAT(6,5,INDX)*ZI(5) + BSYMAT(6,6,INDX)*CP3
                                            else
      ZI(1)  =  ZI(1)
     &+cs17*X7  +cs18*X8  +cs19*X9
     &+cs110*X10+cs111*X11+cs112*X12
     &+cs113*X13+cs114*X14+cs115*X15
     &+cs116*X16+cs117*X17+cs118*X18
     &+cs119*X19+cs120*X20+cs121*X21
     &+cs122*X22+cs123*X23+cs124*X24
     &+cs125*X25+cs126*X26+cs127*X27
      ZI(3)  =  ZI(3)
     &+cs37*X7  +cs38*X8  +cs39*X9
     &+cs310*X10+cs311*X11+cs312*X12
     &+cs313*X13+cs314*X14+cs315*X15
     &+cs316*X16+cs317*X17+cs318*X18
     &+cs319*X19+cs320*X20+cs321*X21
     &+cs322*X22+cs323*X23+cs324*X24
     &+cs325*X25+cs326*X26+cs327*X27
      ZI(5)  =  ZI(5)
     &+cs57*X7  +cs58*X8  +cs59*X9
     &+cs510*X10+cs511*X11+cs512*X12
     &+cs513*X13+cs514*X14+cs515*X15
     &+cs516*X16+cs517*X17+cs518*X18
     &+cs519*X19+cs520*X20+cs521*X21
     &+cs522*X22+cs523*X23+cs524*X24
     &+cs525*X25+cs526*X26+cs527*X27
C
      ZF(1)= bs11*ZI(1) + bs12*CP1
     &      +bs13*ZI(3) + bs14*CP2
     &      +bs15*ZI(5) + bs16*CP3
      ZF(2)= bs21*ZI(1) + bs22*CP1
     &      +bs23*ZI(3) + bs24*CP2
     &      +bs25*ZI(5) + bs26*CP3
      ZF(3)= bs31*ZI(1) + bs32*CP1
     &      +bs33*ZI(3) + bs34*CP2
     &      +bs35*ZI(5) + bs36*CP3
      ZF(4)= bs41*ZI(1) + bs42*CP1
     &      +bs43*ZI(3) + bs44*CP2
     &      +bs45*ZI(5) + bs46*CP3
      ZF(5)= bs51*ZI(1) + bs52*CP1
     &      +bs53*ZI(3) + bs54*CP2
     &      +bs55*ZI(5) + bs56*CP3
c      ZF(6)= bs61*ZI(1) + bs62*CP1
c     &      +bs63*ZI(3) + bs64*CP2
c     &      +bs65*ZI(5) + bs66*CP3
      endif
      zf(6)=zi(6)
C
C  IMAGE OF ZI IS NOW STORED IN ZF
C
      RETURN
      END
c      SUBROUTINE SYMRTX(icpart,INDX,ZI,ZF)
C
C***********************************************************************
C
C  THIS IS THE 2ND VERSION OF 2/13/86.FOR DOCUMENTATION ON THE ALGORITHM
C  SEE "ANALYSIS OF NUMERICAL METHODS" BY ISAACSON AND KELLER,PP.120-122
C
c      IMPLICIT REAL*8 (A-H,O-Z)
c      PARAMETER    (MXELMD = 3000)
c      PARAMETER    (MAXMAT = 500)
c      PARAMETER    (mxpart = 128000)
c      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
c      COMMON /SYMMAP/ BSYMAT(6,6,MAXMAT),CSYMAT(6,27,MAXMAT)
c      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
c     <  NCTURN,MLOCAT,NTURN
c      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
c     +                  NWARN,NFAIL
c      common /ctrsym/bm1(6),bm2(6),bm3(6),bm4(6),bm5(6),bm6(6),
c     >cm1(21),cm2(21),cm3(21),cm4(21),cm5(21),cm6(21),
c     >mb1(6),mb2(6),mb3(6),mb4(6),mb5(6),mb6(6),
c     >nb1,nb2,nb3,nb4,nb5,nb6,
c     >mc1(21),mc2(21),mc3(21),mc4(21),mc5(21),mc6(21),
c     >nc1,nc2,nc3,nc4,nc5,nc6,isysav
c      DIMENSION zi(6),zf(6),vs1(6),vs2(21)
c      common /ils/ ilsflg,ilstat(50)
c      DATA TOLER/1.D-10/
C
c      X7 =ZI(1)*ZI(1)
c      X9 =ZI(1)*ZI(3)
c      X11=ZI(1)*ZI(5)
c      X18=ZI(3)*ZI(3)
c      X20=ZI(3)*ZI(5)
c      X25=ZI(5)*ZI(5)
C
c      C01=ZI(2)
c     &         +CSYMAT(2,7,INDX) *X7 +CSYMAT(2,9,INDX) *X9
c     &         +CSYMAT(2,11,INDX)*X11+CSYMAT(2,18,INDX)*X18
c     &         +CSYMAT(2,20,INDX)*X20+CSYMAT(2,25,INDX)*X25
c      C02=ZI(4)
c     &         +CSYMAT(4,7,INDX) *X7 +CSYMAT(4,9,INDX) *X9
c     &         +CSYMAT(4,11,INDX)*X11+CSYMAT(4,18,INDX)*X18
c     &         +CSYMAT(4,20,INDX)*X20+CSYMAT(4,25,INDX)*X25
c      C03=ZI(6)
c     &         +CSYMAT(6,7,INDX) *X7 +CSYMAT(6,9,INDX) *X9
c     &         +CSYMAT(6,11,INDX)*X11+CSYMAT(6,18,INDX)*X18
c     &         +CSYMAT(6,20,INDX)*X20+CSYMAT(6,25,INDX)*X25
C
c      C11=CSYMAT(2,8,INDX)*ZI(1) +CSYMAT(2,14,INDX)*ZI(3)
c     &                           +CSYMAT(2,16,INDX)*ZI(5)
c      C12=CSYMAT(4,8,INDX)*ZI(1) +CSYMAT(4,14,INDX)*ZI(3)
c     &                           +CSYMAT(4,16,INDX)*ZI(5)
c      C13=CSYMAT(6,8,INDX)*ZI(1) +CSYMAT(6,14,INDX)*ZI(3)
c     &                           +CSYMAT(6,16,INDX)*ZI(5)
c      C21=CSYMAT(2,10,INDX)*ZI(1)+CSYMAT(2,19,INDX)*ZI(3)
c     &                           +CSYMAT(2,23,INDX)*ZI(5)
c      C22=CSYMAT(4,10,INDX)*ZI(1)+CSYMAT(4,19,INDX)*ZI(3)
c     &                           +CSYMAT(4,23,INDX)*ZI(5)
c      C23=CSYMAT(6,10,INDX)*ZI(1)+CSYMAT(6,19,INDX)*ZI(3)
c     &                           +CSYMAT(6,23,INDX)*ZI(5)
c      C31=CSYMAT(2,12,INDX)*ZI(1)+CSYMAT(2,21,INDX)*ZI(3)
c     &                           +CSYMAT(2,26,INDX)*ZI(5)
c      C32=CSYMAT(4,12,INDX)*ZI(1)+CSYMAT(4,21,INDX)*ZI(3)
c     &                           +CSYMAT(4,26,INDX)*ZI(5)
c      C33=CSYMAT(6,12,INDX)*ZI(1)+CSYMAT(6,21,INDX)*ZI(3)
c     &                           +CSYMAT(6,26,INDX)*ZI(5)
C
c      C213=CSYMAT(2,13,INDX)
c      C413=CSYMAT(4,13,INDX)
c      C613=CSYMAT(6,13,INDX)
c      C215=CSYMAT(2,15,INDX)
c      C415=CSYMAT(4,15,INDX)
c      C615=CSYMAT(6,15,INDX)
c      C217=CSYMAT(2,17,INDX)
c      C417=CSYMAT(4,17,INDX)
c      C617=CSYMAT(6,17,INDX)
c      C222=CSYMAT(2,22,INDX)
c      C422=CSYMAT(4,22,INDX)
c      C622=CSYMAT(6,22,INDX)
c      C224=CSYMAT(2,24,INDX)
c      C424=CSYMAT(4,24,INDX)
c      C624=CSYMAT(6,24,INDX)
c      C227=CSYMAT(2,27,INDX)
c      C427=CSYMAT(4,27,INDX)
c      C627=CSYMAT(6,27,INDX)
C
c      A1=1.D0-C11
c      A2=1.D0-C22
c      A3=1.D0-C33
C
c      P1=ZI(2)
c      P2=ZI(4)
c      P3=ZI(6)
C
C  SEARCH FOR IMAGE OF ZI UNDER NONLINEAR TRANSFORM CSYMAT
C
c      DO 5000 ILOOP=1,50
C
c      P4=P1*P1
c      P5=P1*P2
c      P6=P1*P3
c      P7=P2*P2
c      P8=P2*P3
c      P9=P3*P3
C
c      CP1 = P1 + (  C01 - P1 + C11*P1 + C21*P2 + C31*P3
c     & + C213*P4 + C215*P5 + C217*P6 + C222*P7 + C224*P8 + C227*P9  )
c     & /(  A1 - 2.D0*C213*P1 - C215*P2 - C217*P3  )
c      CP2 = P2 + (  C02 - P2 + C12*P1 + C22*P2 + C32*P3
c     & + C413*P4 + C415*P5 + C417*P6 + C422*P7 + C424*P8 + C427*P9  )
c     & /(  A2 - C415*P1 - 2.D0*C422*P2 - C424*P3  )
c      CP3 = P3 + (  C03 - P3 + C13*P1 + C23*P2 + C33*P3
c     & + C613*P4 + C615*P5 + C617*P6 + C622*P7 + C624*P8 + C627*P9  )
c     & /(  A3 - C617*P1 - C624*P2 - 2.D0*C627*P3  )
C
c       IF(  (DABS(CP1-P1)+DABS(CP2-P2)+DABS(CP3-P3))  .LE.
c     &       ((DABS(CP1)+DABS(CP2)+DABS(CP))*TOLER)  )GO TO 6000
c      P1=CP1
c      P2=CP2
c      P3=CP3
c 5000 CONTINUE
c      write(iout,5001)ncturn,icpart,(zi(jz),jz=1,6)
c 5001 FORMAT(' DURING TURN # ',I6,
c     >' NEWTON SEARCH FAILS TO CONVERGE IN 50 ITERATIONS ',/,
c     >' WHILE TRACKING PARTICLE #',
c     >I5,' WITH INITIAL COORDINATES',/,6E14.5,/)
c 6000 CONTINUE
c      do 801 il=1,50
c      if(il.eq.iloop) ilstat(il)=ilstat(il)+1
c  801 continue
c      ilsflg=1
C
c      vs1(1)=zi(1)
c      vs1(2)=cp1
c      vs1(3)=zi(3)
c      vs1(4)=cp2
c      vs1(5)=zi(5)
c      vs1(6)=cp3
c      vs2(1)=zi(1)*zi(1)
c      vs2(2)=zi(1)*cp1
c      vs2(3)=zi(1)*zi(3)
c      vs2(4)=zi(1)*cp2
c      vs2(5)=zi(1)*zi(5)
c      vs2(6)=zi(1)*cp3
cc      vs2(7)=cp1*cp1
c      vs2(7)=p4
c      vs2(8)=cp1*zi(3)
cc      vs2(9)=cp1*cp2
c      vs2(9)=p5
c      vs2(10)=cp1*zi(5)
cc      vs2(11)=cp1*cp3
c      vs2(11)=p6
c      vs2(12)=zi(3)*zi(3)
c      vs2(13)=zi(3)*cp2
c      vs2(14)=zi(3)*zi(5)
c      vs2(15)=zi(3)*cp3
cc      vs2(16)=cp2*cp2
c      vs2(16)=p7
c      vs2(17)=cp2*zi(5)
cc      vs2(18)=cp2*cp3
c      vs2(18)=p8
c      vs2(19)=zi(5)*zi(5)
c      vs2(20)=zi(5)*cp3
cc      vs2(21)=cp3*cp3
c      vs2(21)=p9
C
c      isysav=0
c      if(isysav.eq.0) then
c      X8 =ZI(1)*CP1
c      X10=ZI(1)*CP2
c      X12=ZI(1)*CP3
c      X13=  P4
c      X14=  CP1*ZI(3)
c      X15=  P5
c      X16=  CP1*ZI(5)
c      X17=  P6
c      X19=ZI(3)*CP2
c      X21=ZI(3)*CP3
c      X22=  P7
c      X23=  CP2*ZI(5)
c      X24=  P8
c      X26=ZI(5)*CP3
c      X27=  P9
c      ZI(1)  =  ZI(1)
c     &+CSYMAT(1,7,INDX)*X7  +CSYMAT(1,8,INDX)*X8  +CSYMAT(1,9,INDX)*X9
c     &+CSYMAT(1,10,INDX)*X10+CSYMAT(1,11,INDX)*X11+CSYMAT(1,12,INDX)*X12
c     &+CSYMAT(1,13,INDX)*X13+CSYMAT(1,14,INDX)*X14+CSYMAT(1,15,INDX)*X15
c     &+CSYMAT(1,16,INDX)*X16+CSYMAT(1,17,INDX)*X17+CSYMAT(1,18,INDX)*X18
c     &+CSYMAT(1,19,INDX)*X19+CSYMAT(1,20,INDX)*X20+CSYMAT(1,21,INDX)*X21
c     &+CSYMAT(1,22,INDX)*X22+CSYMAT(1,23,INDX)*X23+CSYMAT(1,24,INDX)*X24
c     &+CSYMAT(1,25,INDX)*X25+CSYMAT(1,26,INDX)*X26+CSYMAT(1,27,INDX)*X27
c      ZI(3)  =  ZI(3)
c     &+CSYMAT(3,7,INDX)*X7  +CSYMAT(3,8,INDX)*X8  +CSYMAT(3,9,INDX)*X9
c     &+CSYMAT(3,10,INDX)*X10+CSYMAT(3,11,INDX)*X11+CSYMAT(3,12,INDX)*X12
c     &+CSYMAT(3,13,INDX)*X13+CSYMAT(3,14,INDX)*X14+CSYMAT(3,15,INDX)*X15
c     &+CSYMAT(3,16,INDX)*X16+CSYMAT(3,17,INDX)*X17+CSYMAT(3,18,INDX)*X18
c     &+CSYMAT(3,19,INDX)*X19+CSYMAT(3,20,INDX)*X20+CSYMAT(3,21,INDX)*X21
c     &+CSYMAT(3,22,INDX)*X22+CSYMAT(3,23,INDX)*X23+CSYMAT(3,24,INDX)*X24
c     &+CSYMAT(3,25,INDX)*X25+CSYMAT(3,26,INDX)*X26+CSYMAT(3,27,INDX)*X27
c      ZI(5)  =  ZI(5)
c     &+CSYMAT(5,7,INDX)*X7  +CSYMAT(5,8,INDX)*X8  +CSYMAT(5,9,INDX)*X9
c     &+CSYMAT(5,10,INDX)*X10+CSYMAT(5,11,INDX)*X11+CSYMAT(5,12,INDX)*X12
c     &+CSYMAT(5,13,INDX)*X13+CSYMAT(5,14,INDX)*X14+CSYMAT(5,15,INDX)*X15
c     &+CSYMAT(5,16,INDX)*X16+CSYMAT(5,17,INDX)*X17+CSYMAT(5,18,INDX)*X18
c     &+CSYMAT(5,19,INDX)*X19+CSYMAT(5,20,INDX)*X20+CSYMAT(5,21,INDX)*X21
c     &+CSYMAT(5,22,INDX)*X22+CSYMAT(5,23,INDX)*X23+CSYMAT(5,24,INDX)*X24
c     &+CSYMAT(5,25,INDX)*X25+CSYMAT(5,26,INDX)*X26+CSYMAT(5,27,INDX)*X27
C
c      ZF(1)= BSYMAT(1,1,INDX)*ZI(1) + BSYMAT(1,2,INDX)*CP1
c     &      +BSYMAT(1,3,INDX)*ZI(3) + BSYMAT(1,4,INDX)*CP2
c     &      +BSYMAT(1,5,INDX)*ZI(5) + BSYMAT(1,6,INDX)*CP3
c      ZF(2)= BSYMAT(2,1,INDX)*ZI(1) + BSYMAT(2,2,INDX)*CP1
c     &      +BSYMAT(2,3,INDX)*ZI(3) + BSYMAT(2,4,INDX)*CP2
c     &      +BSYMAT(2,5,INDX)*ZI(5) + BSYMAT(2,6,INDX)*CP3
c      ZF(3)= BSYMAT(3,1,INDX)*ZI(1) + BSYMAT(3,2,INDX)*CP1
c     &      +BSYMAT(3,3,INDX)*ZI(3) + BSYMAT(3,4,INDX)*CP2
c     &      +BSYMAT(3,5,INDX)*ZI(5) + BSYMAT(3,6,INDX)*CP3
c      ZF(4)= BSYMAT(4,1,INDX)*ZI(1) + BSYMAT(4,2,INDX)*CP1
c     &      +BSYMAT(4,3,INDX)*ZI(3) + BSYMAT(4,4,INDX)*CP2
c     &      +BSYMAT(4,5,INDX)*ZI(5) + BSYMAT(4,6,INDX)*CP3
c      ZF(5)= BSYMAT(5,1,INDX)*ZI(1) + BSYMAT(5,2,INDX)*CP1
c     &      +BSYMAT(5,3,INDX)*ZI(3) + BSYMAT(5,4,INDX)*CP2
c     &      +BSYMAT(5,5,INDX)*ZI(5) + BSYMAT(5,6,INDX)*CP3
c      ZF(6)= BSYMAT(6,1,INDX)*ZI(1) + BSYMAT(6,2,INDX)*CP1
c     &      +BSYMAT(6,3,INDX)*ZI(3) + BSYMAT(6,4,INDX)*CP2
c     &      +BSYMAT(6,5,INDX)*ZI(5) + BSYMAT(6,6,INDX)*CP3
c
c                        else
c      if(nc1.ne.0) then
c      do 101 im=1,nc1
c  101 vs1(1)=vs1(1)+cm1(im)*vs2(mc1(im))
c      endif
c      if(nc3.ne.0) then
c      do 103 im=1,nc3
c  103 vs1(3)=vs1(3)+cm3(im)*vs2(mc3(im))
c      endif
c      if(nc5.ne.0) then
c      do 105 im=1,nc5
c  105 vs1(5)=vs1(5)+cm5(im)*vs2(mc5(im))
c      endif
c      zf(1)=0.0d0
c      do 201 im=1,nb1
c  201 zf(1)=zf(1)+ bm1(im)*vs1(mb1(im))
c      zf(2)=0.0d0
c      do 202 im=1,nb2
c  202 zf(2)=zf(2)+ bm2(im)*vs1(mb2(im))
c      zf(3)=0.0d0
c      do 203 im=1,nb3
c  203 zf(3)=zf(3)+ bm3(im)*vs1(mb3(im))
c      zf(4)=0.0d0
c      do 204 im=1,nb4
c  204 zf(4)=zf(4)+ bm4(im)*vs1(mb4(im))
c      zf(5)=0.0d0
c      do 205 im=1,nb5
c  205 zf(5)=zf(5)+ bm5(im)*vs1(mb5(im))
c      zf(6)=0.0d0
c      do 206 im=1,nb6
c  206 zf(6)=zf(6)+ bm6(im)*vs1(mb6(im))
c      endif
c
C  IMAGE OF ZI IS NOW STORED IN ZF
C
c      RETURN
c      END
      SUBROUTINE SYNPRE(IAD,NEL)
C     **************************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/SYNCH/ENOM,SYNDEL,EMITGR,EMITK,EMITK2,ISYNFL,ISYNQD,IRND,iff
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      COMMON/LNGTH/TLENG,ALENG(MXELMD),ACLENG(MAXPOS)
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      ALEN=DABS(ALENG(NEL))
      ENOM3=ENOM*ENOM*ENOM
      ENOM5=ENOM3*ENOM*ENOM
      EMITK=4.132D-11*ENOM5/(ALEN*ALEN)
      EMITK2=1.408D-05*ENOM3/ALEN
      IF(KODE(NEL).EQ.1) THEN
       IF(KUNITS.EQ.2) THEN
         ANG=DABS(CRDEG*ELDAT(IAD+1))
                       ELSE
         ANG = DABS(ELDAT(IAD+1))
       ENDIF
       ANG2=ANG*ANG
       SYNDEL=EMITK2*ANG2
       EMITGR=EMITK*ANG2*ANG
       EMITGR =DSQRT(DABS(EMITGR))
      ENDIF
      RETURN
      END
c     ************************
      subroutine synrad (iflag, alen, angle)
c     ************************
c new version : includes a look-up table instead of trying to invert
c  an approximate formula for the function Y. ultra-basic interpolation
c  computed; leads to an extrapolation outside the table using the two
c  outmost point on each side (low and high).
c contact GHISLAIN@SLACVM for information.
c see also Proceedings of CPO3 in NIM A298 (1990) 128-133
c
      implicit real*8 (a-h,o-z)
      real*8 nmean
      common/SYNCH/enom,syndel,emitgr,emitk,emitk2,isynfl,isynqd,irnd,iff
      COMMON/CSEEDS/ISEED,IXG,IXS,IXMSTP,IMSD,IMOSTP,ISYNSD,ISYSTP,
     >ISDBEG,IBGSTP,IXES,IXESTP,IESBEG,IESTBG,isdcol
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      parameter    (mxpart = 128000)
      common/trace/part(mxpart,6),del(mxpart),npart,ncpart,nprint,
     <  ncturn,mlocat,nturn
c
c **********************************
c table version 1.0 - installed on may 25, 89 - GJR
      parameter (MAXTAB = 101)
      parameter (MAXTAa = 52)
      parameter (MAXTAc = 49)
      real*8 taby(maxtab),tabcsi(maxtab)
      real*8 tabya(maxtaa),tabca(maxtaa)
      real*8 tabyb(maxtac),tabcb(maxtac)
      equivalence(tabya(1),taby(1)),(tabyb(1),taby(53))
      equivalence(tabca(1),tabcsi(1)),(tabcb(1),tabcsi(53))
c
      data tabya /
     >-1.14084005d0 , -0.903336763d0, -0.769135833d0, -0.601840854d0,
     >-0.448812515d0, -0.345502228d0, -0.267485678d0, -0.204837948d0,
     >-0.107647471d0, -0.022640628d0, 0.044112321d0 , 0.0842842236d0,
     >0.132941082d0 , 0.169244036d0 , 0.196492359d0 , 0.230918407d0 ,
     >0.261785239d0 , 0.289741248d0 , 0.322174788d0 , 0.351361096d0 ,
     >0.383441716d0 , 0.412283719d0 , 0.442963421d0 , 0.472622454d0 ,
     >0.503019691d0 , 0.53197819d0  , 0.561058342d0 , 0.588547111d0 ,
     >0.613393188d0 , 0.636027336d0 , 0.675921738d0 , 0.710166812d0 ,
     >0.725589216d0 , 0.753636241d0 , 0.778558254d0 , 0.811260045d0 ,
     >0.830520391d0 , 0.856329501d0 , 0.879087269d0 , 0.905612588d0 ,
     >0.928626955d0 , 0.948813677d0 , 0.970829248d0 , 0.989941061d0 ,
     >1.0097903d0   , 1.02691281d0  , 1.04411256d0  , 1.06082714d0  ,
     >1.0750246d0   , 1.08283985d0  , 1.0899564d0   , 1.09645379d0  /
      data tabyb /
     >1.10352755d0  , 1.11475027d0  , 1.12564385d0  , 1.1306442d0   ,
     >1.13513422d0  , 1.13971806d0  , 1.14379156d0  , 1.14741969d0  ,
     >1.15103698d0  , 1.15455759d0  , 1.15733826d0  , 1.16005647d0  ,
     >1.16287541d0  , 1.16509759d0  , 1.16718769d0  , 1.16911888d0  ,
     >1.17075884d0  , 1.17225218d0  , 1.17350936d0  , 1.17428589d0  ,
     >1.17558432d0  , 1.17660713d0  , 1.17741513d0  , 1.17805469d0  ,
     >1.17856193d0  , 1.17896497d0  , 1.17928565d0  , 1.17954147d0  ,
     >1.17983139d0  , 1.1799767d0   , 1.18014216d0  , 1.18026078d0  ,
     >1.18034601d0  , 1.1804074d0   , 1.18045175d0  , 1.1804837d0   ,
     >1.18051291d0  , 1.18053186d0  , 1.18054426d0  , 1.18055236d0  ,
     >1.18055761d0  , 1.18056166d0  , 1.18056381d0  , 1.1805656d0   ,
     >1.18056655d0  , 1.18056703d0  , 1.18056726d0  , 1.1805675d0   ,
     >1.18056762d0  /
c
      data tabca /
     >-7.60090017d0, -6.90775537d0, -6.50229025d0, -5.99146461d0,
     >-5.52146101d0, -5.20300722d0, -4.96184492d0, -4.76768923d0,
     >-4.46540833d0, -4.19970512d0, -3.98998451d0, -3.86323285d0,
     >-3.70908213d0, -3.59356928d0, -3.50655794d0, -3.39620972d0,
     >-3.29683733d0, -3.20645332d0, -3.10109282d0, -3.0057826d0 ,
     >-2.9004221d0 , -2.80511189d0, -2.70306253d0, -2.60369015d0,
     >-2.50103593d0, -2.4024055d0 , -2.30258512d0, -2.20727491d0,
     >-2.12026358d0, -2.04022098d0, -1.89712d0   , -1.7719568d0 ,
     >-1.71479833d0, -1.60943794d0, -1.51412773d0, -1.38629436d0,
     >-1.30933332d0, -1.20397282d0, -1.10866261d0, -0.99425226d0,
     >-0.89159810d0, -0.79850775d0, -0.69314718d0, -0.59783697d0,
     >-0.49429631d0, -0.40047753d0, -0.30110508d0, -0.19845095d0,
     >-0.10536054d0, -0.05129330d0, 0.0d0        , 0.048790119d0/
      data tabcb /
     >0.104360029d0, 0.198850885d0, 0.300104618d0, 0.350656837d0,
     >0.398776114d0, 0.451075643d0, 0.500775278d0, 0.548121393d0,
     >0.598836541d0, 0.652325153d0, 0.69813472d0 , 0.746687889d0,
     >0.802001595d0, 0.850150883d0, 0.900161386d0, 0.951657832d0,
     >1.00063193d0 , 1.05082154d0 , 1.09861231d0 , 1.13140213d0 ,
     >1.1939224d0  , 1.25276291d0 , 1.3083328d0  , 1.36097658d0 ,
     >1.4109869d0  , 1.45861506d0 , 1.50407743d0 , 1.54756248d0 ,
     >1.60943794d0 , 1.64865863d0 , 1.70474803d0 , 1.75785792d0 ,
     >1.80828881d0 , 1.85629797d0 , 1.90210748d0 , 1.9459101d0  ,
     >2.0014801d0  , 2.05412364d0 , 2.10413408d0 , 2.15176225d0 ,
     >2.19722462d0 , 2.25129175d0 , 2.29253483d0 , 2.35137534d0 ,
     >2.40694523d0 , 2.45100522d0 , 2.501436d0   , 2.60268974d0 ,
     >2.64617491d0 /


c **********************************

c go to the different tasks
      go to (100, 200, 300) iflag




c * * * * * * * * * * * *
c **Compute the SR parameters values in each bending magnet**

 100  if (angle.eq.0.d0) return
      uc    = 2.218246911d-6 * (enom*enom*enom)*angle/alen
      nmean = 20.61203256d0 * enom * angle
      return

c * * * * * * * * * * * *
c ** Photons' Emission **

 200  syndel = 0.0d0
      if (angle.eq.0.d0) return
c find the number of photons to be 'emitted' according poisson's law
 201  call poissn (nmean/2.,nphot,ierror)
      if (ierror.ne.0) then
         write (iout,'(a)') '1 trouble with NMEAN in SYNRAD, so STOP!'
         write (iout,*) ' nmean   = ',nmean
         write (iout,*) ' nphot   = ',nphot
         write (iout,*) ' ierror  = ',ierror
         stop
      endif

      if (nphot.eq.0) go to 20
      x = 0.0d0
      do 10 i=1,nphot
c        find a uniform random number in the range  [ 0,3.256223 ]
         y = 3.256223d0 * urand (isynsd)


c        now look for the energy of the photon in the table TABY/TABCSI
         do 11 j = 2,maxtab
            if ( dlog(y) .le.  taby(j) ) go to 12
 11      continue

c        perform linear interpolation...
 12      res = (dlog(y) - taby(j-1)) / (taby(j) - taby(j-1))
         x   = dexp( tabcsi(j-1)  +  res * (tabcsi(j) - tabcsi(j-1)) )
c        x is the energy of the photon to be radiated, in units Uc

         syndel = syndel + x*uc/enom
 10   continue

c remove now the classical E_loss part to get only quantum excitation
 20   if (iff.eq.2) syndel=syndel-(nmean/2.0d0)*(0.307920143d0*uc)/enom

c because in TRACKT, we will consider SYNDEL/2.0 :
      syndel = 2.0d0 * syndel
      return

c * * * * * * * * * * * * * * * * * * * * * * * * * *
c **Radiation in quadrupoles -- includes Oide limit**

 300  syndel = 0.0d0
      if (angle.eq.0.d0) return
      uc    = 2.218246911d-6 * (enom*enom*enom)*angle/alen
      nmean = 20.61203256d0 * enom * angle
      go to 201

      end
C     ***********************
      SUBROUTINE TILTM(ILK,MATADR)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/PRODCT/KODEPR,NEL,NOF
      COMMON/BND/IAD
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      dimension trans(27,27)
      nof=6
      if(norder.eq.2)nof=27
      IADN=IADR(ILK+1)
      IF(KUNITS.EQ.2)ANGLE=ELDAT(IADN-1)*CRDEG
      IF(KUNITS.EQ.1) ANGLE = -ELDAT(IADN-1)
      IF(KUNITS.EQ.0) ANGLE = ELDAT(IADN-1)
      IF(ANGLE.EQ.0.0D0)RETURN
      call tiltmm(ilk,matadr,angle)
      end
C     ***********************
      SUBROUTINE TILTMm(ILK,MATADR,angle)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/PRODCT/KODEPR,NEL,NOF
      COMMON/BND/IAD
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      dimension trans(27,27)
      COST=0.0D0
      SINT=1.0D0
C     WRITE(IOUT,*)'IN TILTM ANGDIF;',DABS(ANGLE-(PI/2.0D0))
      IF(DABS(ANGLE-(PI/2.0D0)).LT.1.0D-12)GOTO 30
      COST=DCOS(ANGLE)
      SINT=DSIN(ANGLE)
C
C     SET UP THE TILT MATRIX IN TEMP
C
   30 DO 10 IX = 1,6
      DO 10 IY = 1,NOF
      TEMP(IX,IY)=0.0D0
   10 CONTINUE
      TEMP(1,1)=COST
      TEMP(1,3)=-SINT
      TEMP(2,2)=COST
      TEMP(2,4)=-SINT
      TEMP(3,1)=SINT
      TEMP(3,3)=COST
      TEMP(4,2)=SINT
      TEMP(4,4)=COST
      TEMP(5,5)=1.0D0
      TEMP(6,6)=1.0D0
C      CALL PROMAT(ILK,MATADR)
      DO 507 I=1,6
      DO 507 J=1,nof
 507  TRANS(I,J)=TEMP(I,J)
      IF (NORDER.EQ.1) GO TO 525
C   FIND TRANS--THE 27X27 MATRIX FOR MACHINE TO PRESENT ELEMENT
      DO 508 I=1,5
      DO 508 K=I, 6
      ICOEF=7*I-I*(I+1)/2+K
      DO 508 J=1, 6
      TRANS(ICOEF,J)=0
      DO 508 L1=J, 6
      TRANC=TRANS(I,J)*TRANS(K,L1)
      IF (J.NE.L1) TRANC=TRANC+TRANS(I,L1)*TRANS(K,J)
      TRANS(ICOEF,7*J-J*(J+1)/2+L1) = TRANC
 508  CONTINUE
      DO 510 I=1, NOF
 510  TRANS(27,I)=0
      TRANS(27,27)=1
 525  DO 560 IM=1,6
      DO 560 I=1,NOF
      TEMP(IM,I)=0.0D0
      DO 561 JM=1,NOF
      AMIJ=AMAT(JM,IM,MATADR)
      IF(AMIJ.EQ.0.0D0)GOTO 561
      TEMP(IM,I)=TEMP(IM,I)+AMIJ*TRANS(JM,I)
561   CONTINUE
560   CONTINUE

C
C  SET REVERSE TILT MATRIX IN AMAT
C
      DO 200 I=1,6
      DO 200 J=1,NOF
      AMAT(J,I,MATADR)=0.0D0
 200  CONTINUE
      AMAT(1,1,MATADR)=COST
      AMAT(3,1,MATADR)=SINT
      AMAT(2,2,MATADR)=COST
      AMAT(4,2,MATADR)=SINT
      AMAT(1,3,MATADR)=-SINT
      AMAT(3,3,MATADR)=COST
      AMAT(2,4,MATADR)=-SINT
      AMAT(4,4,MATADR)=COST
      AMAT(5,5,MATADR)=1.0D0
      AMAT(6,6,MATADR)=1.0D0
C      CALL PROMAT(ILK,MATADR)
      DO 607 I=1,6
      DO 607 J=1,nof
 607  TRANS(I,J)=TEMP(I,J)
      IF (NORDER.EQ.1) GO TO 625
C   FIND TRANS--THE 27X27 MATRIX FOR MACHINE TO PRESENT ELEMENT
      DO 608 I=1,5
      DO 608 K=I, 6
      ICOEF=7*I-I*(I+1)/2+K
      DO 608 J=1, 6
      TRANS(ICOEF,J)=0
      DO 608 L1=J, 6
      TRANC=TRANS(I,J)*TRANS(K,L1)
      IF (J.NE.L1) TRANC=TRANC+TRANS(I,L1)*TRANS(K,J)
      TRANS(ICOEF,7*J-J*(J+1)/2+L1) = TRANC
 608  CONTINUE
      DO 610 I=1, NOF
 610  TRANS(27,I)=0
      TRANS(27,27)=1
 625  DO 660 IM=1,6
      DO 660 I=1,NOF
      TEMP(IM,I)=0.0D0
      DO 661 JM=1,NOF
      AMIJ=AMAT(JM,IM,MATADR)
      IF(AMIJ.EQ.0.0D0)GOTO 661
      TEMP(IM,I)=TEMP(IM,I)+AMIJ*TRANS(JM,I)
661   CONTINUE
660   CONTINUE
C
C     PUT TEMP INTO AMAT(27,6,MATADR)
C
      DO 20 IX=1,6
      DO 20 IY=1,NOF
  20  AMAT(IY,IX,MATADR) = TEMP(IX,IY)
      RETURN
      END
C     ***********************
      SUBROUTINE TIMEL(TIME)
C     ***********************
C---- RETURN CPU TIME LEFT FOR JOB
C-----------------------------------------------------------------------
      TIME = 1.0E10
      RETURN
C-----------------------------------------------------------------------
      END
      SUBROUTINE TIMER(CC,COMAND)
C---- TIMING ROUTINE
C-----------------------------------------------------------------------
      CHARACTER*1       CC
      CHARACTER*(*)     COMAND
C-----------------------------------------------------------------------
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C-----------------------------------------------------------------------
      CALL TIMEX(TIME)
      WRITE (IECHO,910) CC, COMAND, TIME
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT(A1,'... END OF "',A,'" COMMAND, ELAPSED CPU TIME = ',
     +       F11.3,' SECONDS'/' ')
C-----------------------------------------------------------------------
      END
      SUBROUTINE TIMEX(TIME)
C---- RETURN CPU TIME USED SO FAR
C-----------------------------------------------------------------------
      TIME = 0.0
      RETURN
C-----------------------------------------------------------------------
      END
      SUBROUTINE TITLE
C---- PERFORM "TITLE" COMMAND
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
C-----------------------------------------------------------------------
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- FLAGS FOR I/O
      COMMON /IOFLAG/   SCAN,ERROR,SKIP,ENDFIL,INTER
      LOGICAL           SCAN,ERROR,SKIP,ENDFIL,INTER
C---- PAGE HEADER
      COMMON /PAGTIT/   KTIT,KVERS,KDATE,KTIME
      CHARACTER*8       KTIT*80,KVERS,KDATE,KTIME
C---- INPUT BUFFER
      COMMON /RDBUFF/   KLINE(81)
      CHARACTER*1       KLINE
      CHARACTER*80      KTEXT
      EQUIVALENCE       (KTEXT,KLINE(1))
C-----------------------------------------------------------------------
      CALL RDTEST(';',ERROR)
      IF (ERROR) RETURN
      IF (ICOL .NE. 81) THEN
        CALL RDWARN
        WRITE (IECHO,910)
      ENDIF
      CALL RDLINE
      IF (ENDFIL) THEN
        KTIT = ' '
      ELSE
        KTIT = KTEXT
      ENDIF
      call setup
      ICOL = 81
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT(' ** WARNING ** TEXT AFTER "TITLE" SKIPPED'/' ')
C-----------------------------------------------------------------------
      END
      SUBROUTINE TQL2(NM,N,D,E,Z,IERR)
C****************************************
      INTEGER I,J,K,L,M,N,II,L1,NM,MML,IERR
      REAL*8 D(N),E(N),Z(NM,N)
      REAL*8 B,C,F,G,H,P,R,S,MACHEP
      REAL*8 DSQRT,DABS,DSIGN,dpmpar
C      INTEGER MCHEPS(4)
C      EQUIVALENCE(MACHEP,MCHEPS(1))
C
C     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE TQL2,
C     NUM. MATH. 11, 293-306(1968) BY BOWDLER, MARTIN, REINSCH, AND
C     WILKINSON.
C     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 227-240(1971).
C
C     THIS SUBROUTINE FINDS THE EIGENVALUES AND EIGENVECTORS
C     OF A SYMMETRIC TRIDIAGONAL MATRIX BY THE QL METHOD.
C     THE EIGENVECTORS OF A FULL SYMMETRIC MATRIX CAN ALSO
C     BE FOUND IF  TRED2  HAS BEEN USED TO REDUCE THIS
C     FULL MATRIX TO TRIDIAGONAL FORM.
C
C     ON INPUT:
C
C        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
C          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
C          DIMENSION STATEMENT;
C
C        N IS THE ORDER OF THE MATRIX;
C
C        D CONTAINS THE DIAGONAL ELEMENTS OF THE INPUT MATRIX;
C
C        E CONTAINS THE SUBDIAGONAL ELEMENTS OF THE INPUT MATRIX
C          IN ITS LAST N-1 POSITIONS.  E(1) IS ARBITRARY;
C
C        Z CONTAINS THE TRANSFORMATION MATRIX PRODUCED IN THE
C          REDUCTION BY  TRED2, IF PERFORMED.  IF THE EIGENVECTORS
C          OF THE TRIDIAGONAL MATRIX ARE DESIRED, Z MUST CONTAIN
C          THE IDENTITY MATRIX.
C
C      ON OUTPUT:
C
C        D CONTAINS THE EIGENVALUES IN ASCENDING ORDER.  IF AN
C          ERROR EXIT IS MADE, THE EIGENVALUES ARE CORRECT BUT
C          UNORDERED FOR INDICES 1,2,...,IERR-1;
C
C        E HAS BEEN DESTROYED;
C
C        Z CONTAINS ORTHONORMAL EIGENVECTORS OF THE SYMMETRIC
C          TRIDIAGONAL (OR FULL) MATRIX.  IF AN ERROR EXIT IS MADE,
C          Z CONTAINS THE EIGENVECTORS ASSOCIATED WITH THE STORED
C          EIGENVALUES;
C
C        IERR IS SET TO
C          ZERO       FOR NORMAL RETURN,
C          J          IF THE J-TH EIGENVALUE HAS NOT BEEN
C                     DETERMINED AFTER 30 ITERATIONS.
C
C     QUESTIONS AND COMMENTS SHOULD BE DIRECTED TO B. S. GARBOW,
C     APPLIED MATHEMATICS DIVISION, ARGONNE NATIONAL LABORATORY
C
C     ------------------------------------------------------------------
C
C     :::::::::: MACHEP IS A MACHINE DEPENDENT PARAMETER SPECIFYING
C                THE RELATIVE PRECISION OF FLOATING POINT ARITHMETIC.
C                MACHEP = 16.0D0**(-13) FOR LONG FORM ARITHMETIC
C                ON S360 ::::::::::
C     DATA MACHEP/Z3410000000000000/
C      DATA MCHEPS(1),MCHEPS(2) /9472, 0 /
C
      IERR = 0
CC      write(6,*)' in tql2 at 1'
CC      write(6,*)' nm,n,d,e,z ',nm,n,d,e,z
      IF (N .EQ. 1) GO TO 1001
C
      DO 100 I = 2, N
  100 E(I-1) = E(I)
C
      F = 0.0D0
      B = 0.0D0
      E(N) = 0.0D0
C
      DO 240 L = 1, N
         J = 0
         MACHEP=DPMPAR(1)
CC          machep=1.0e-15
         H = MACHEP * (DABS(D(L)) + DABS(E(L)))
         IF (B .LT. H) B = H
C     :::::::::: LOOK FOR SMALL SUB-DIAGONAL ELEMENT ::::::::::
         DO 110 M = L, N
            IF (DABS(E(M)) .LE. B) GO TO 120
C     :::::::::: E(N) IS ALWAYS ZERO, SO THERE IS NO EXIT
C                THROUGH THE BOTTOM OF THE LOOP ::::::::::
  110    CONTINUE
C
  120    IF (M .EQ. L) GO TO 220
  130    IF (J .EQ. 30) GO TO 1000
         J = J + 1
C     :::::::::: FORM SHIFT ::::::::::
         L1 = L + 1
         G = D(L)
         P = (D(L1) - G) / (2.0D0 * E(L))
         R = DSQRT(P*P+1.0D0)
         D(L) = E(L) / (P + DSIGN(R,P))
         H = G - D(L)
C
         DO 140 I = L1, N
  140    D(I) = D(I) - H
C
         F = F + H
C     :::::::::: QL TRANSFORMATION ::::::::::
         P = D(M)
         C = 1.0D0
         S = 0.0D0
         MML = M - L
C     :::::::::: FOR I=M-1 STEP -1 UNTIL L DO -- ::::::::::
         DO 200 II = 1, MML
            I = M - II
            G = C * E(I)
            H = C * P
            IF (DABS(P) .LT. DABS(E(I))) GO TO 150
            C = E(I) / P
            R = DSQRT(C*C+1.0D0)
            E(I+1) = S * P * R
            S = C / R
            C = 1.0D0 / R
            GO TO 160
  150       C = P / E(I)
            R = DSQRT(C*C+1.0D0)
            E(I+1) = S * E(I) * R
            S = 1.0D0 / R
            C = C * S
  160       P = C * D(I) - S * G
            D(I+1) = H + S * (C * G + S * D(I))
C     :::::::::: FORM VECTOR ::::::::::
            DO 180 K = 1, N
               H = Z(K,I+1)
               Z(K,I+1) = S * Z(K,I) + C * H
               Z(K,I) = C * Z(K,I) - S * H
  180       CONTINUE
C
  200    CONTINUE
C
         E(L) = S * P
         D(L) = C * P
         IF (DABS(E(L)) .GT. B) GO TO 130
  220    D(L) = D(L) + F
  240 CONTINUE
C     :::::::::: ORDER EIGENVALUES AND EIGENVECTORS ::::::::::
      DO 300 II = 2, N
         I = II - 1
         K = I
         P = D(I)
C
         DO 260 J = II, N
            IF (D(J) .GE. P) GO TO 260
            K = J
            P = D(J)
  260    CONTINUE
C
         IF (K .EQ. I) GO TO 300
         D(K) = D(I)
         D(I) = P
C
         DO 280 J = 1, N
            P = Z(J,I)
            Z(J,I) = Z(J,K)
            Z(J,K) = P
  280    CONTINUE
C
  300 CONTINUE
C
      GO TO 1001
C     :::::::::: SET ERROR -- NO CONVERGENCE TO AN
C                EIGENVALUE AFTER 30 ITERATIONS ::::::::::
 1000 IERR = L
 1001 RETURN
C     :::::::::: LAST CARD OF TQL2 ::::::::::
      END

      SUBROUTINE TRACKT
C     **********************
        IMPLICIT REAL*8 (A-H,O-Z)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON /SYMMAP/ BSYMAT(6,6,MAXMAT),CSYMAT(6,27,MAXMAT)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/DETL/DENER(15),NH,NV,NVH,NHVP(105),MDPRT,NDENER,
     1NUXS(45),NUX(45),NUYS(45),NUY(45),NCO,NHNVHV,MULPRT,NSIG
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
       COMMON/V/AL,ALO2,VV(27),X1,X2,X3,X4,X5,X6,Y1,Y2,Y3,Y4,Y5,Y6
      COMMON/PLT/
     1XMIN,XMAX,YMIN,YMAX,XPMIN,XPMAX,YPMIN,YPMAX,ALMIN,ALMAX,
     >DELMIN,DELMAX,DNUMIN,DNUMAX,DBMIN,DBMAX,
     2MALL,NPLOT,NCCUM,NGRAPH,NCOL,NLINE
      COMMON/CHPLT/MXXPR,MYYPR,MXY,MALE
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      COMMON/TRI/WCO(15,6),GEN(5,4),PGEN(75,6),DIST,
     <A1(15),B1(15),A2(15),B2(15),XCOR(3,15),XPCOR(3,15),
     1AL1(15),AL2(15),MESH,NIT,NENER,NITX,NITS,NITM1,NANAL,NOPRT
      PARAMETER  (MXGACA = 15)
      PARAMETER  (MXGATR = 1030)
      COMMON/GEOM/XCO,XPCO,YCO,YPCO,NCASE,NJOB,
     <    EPSX(MXGACA),EPSY(MXGACA),XI(MXGACA),YI(MXGACA),
     <    XG(MXGATR,MXGACA),
     <    XPG(MXGATR,MXGACA),YG(MXGATR,MXGACA),YPG(MXGATR,MXGACA),
     <    LCASE(MXGACA)
      COMMON/MISSET/DX1,DX2,DXP1,DXP2,DY1,DY2,DYP1,DYP2,
     >DZ1,DZ2,DZC1,DZS1,DZC2,DZS2,DDEL,I,IEP,MNEL
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
      PARAMETER  (mxmis = 1000)
      COMMON/MIS/RMISA(8,MXMIS),MISELE(MXMIS),NMIS,NOPT,
     >NMISE,MISSEL(MXMIS),NMRNGE(MXMIS),
     >MSRNGE(2,10,MXMIS),MISFLG,MCHFLG
      PARAMETER    (MXMTR = 5000)
      COMMON/MISTRK/AKMIS(15,MXMTR),KMPOS(MXMTR),IMEXP,NMTOT,MISPTR
      COMMON/CSEEDS/ISEED,IXG,IXS,IXMSTP,IMSD,IMOSTP,ISYNSD,ISYSTP,
     >ISDBEG,IBGSTP,IXES,IXESTP,IESBEG,IESTBG,isdcol
      parameter   (mxerr = 25)
      parameter   (MXEREL = 500)
      parameter   (MXERRG = 6)
      COMMON/cERR/ERRVAL(mxerr,mxerel),erv(mxerr,mxerel),NERELE(mxerel),
     > NERPAR(mxerr,mxerel),NERR,NEROPT,NERRE,MERSEL(mxerel),
     > NERNGE(mxerel),MERNGE(2,mxerrg,mxerel),MERFLG
      PARAMETER  (MAXERR = 100)
      COMMON /ERRSRT/ ERRSRT(MAXERR),NERSRT,IERSRT,IERBEG
      COMMON/ERSAV/SAV(mxerr),SAVMAT(6,27),IERSET,IER,IDE,IEMSAV
      PARAMETER  (mxlcnd = 200)
      PARAMETER  (mxlvar = 100)
      COMMON/FITL/COEF(MXLVAR,6),VALF(MXLCND),
     >  WGHT(MXLCND),RVAL(MXLCND),XM(MXLVAR)
     >  ,EM(MXLVAR),WV,NELF(MXLVAR,6),NPAR(MXLVAR,6),
     >  IND(MXLVAR,6),NPVAR(MXLVAR),NVAL(MXLCND)
     >  ,NSTEP,NVAR,NCOND,ISTART,NDIV,IFITM,IFITD,IFITBM
      COMMON/MONIT/VALMON(MXLCND,4,3)
      COMMON/MONFIT/VALFA(MXLCND),WGHTA(MXLCND),ERRA(MXLCND),
     >AMULTA(MXLVAR,6),ADDA(MXLVAR,6),DELA(MXLVAR)
     >,NPARA(MXLVAR,6),NELFA(MXLVAR,6),
     >NPVARA(MXLVAR),INDA(MXLVAR,6),VALR(MXLCND),RMOSIG,
     >NMONA(MXLCND),NVALA(MXLCND),NVARA,NCONDA
     >,IALFLG,MONFLG,MONLST,NOPTER,
     >IAFRST,IMOOPT,IMSBEG,NALPRT
      PARAMETER     (MAXCOR = 600)
      COMMON/CORR/CORVAL(MAXCOR,4),ICRID(MAXCOR),
     >ICRPOS(MAXCOR),ICRSET(MAXCOR),
     >ICROPT(MAXCOR),NCORR,NCURCR,ICRFLG,ICRCHK,ALMNEL,ICRPTR,NPARC
      COMMON/ORBIT/SIZEX,SIZEY,RMSX,RMSY,RMSIX,RMSIY,
     >RTEMPX,RTEMPY,RMSPX(5),RMSPY(5),RPX,RPY,
     >RMAXX,RMAXY,RMINX,RMINY,MAXX,MAXY,MINX,MINY,PLENG,
     >IRNG,IRANGE(5),NPRORB,IORB,IREF,IPAGE,IPOINT
      COMMON/SYNCH/ENOM,SYNDEL,EMITGR,EMITK,EMITK2,ISYNFL,ISYNQD,IRND,iff
      PARAMETER    (MXADIV = 15)
      PARAMETER    (MXADIP = 100)
      COMMON/ADIA/VPARM(mxadiv,2*mxadip),IADFLG,IADCAV,NADVAR,
     >ivid(mxadiv),IVPAR(mxadiv),IVOPT(mxadiv)
      COMMON/SYM/ENERLI,GAMMLI,BETALI,bili,b2li,b2ili,
     >ISYOPT,ISYFLG,MATTOT,KANVAR
      COMMON/LNGTH/TLENG,ALENG(MXELMD),ACLENG(MAXPOS)
      COMMON/COLL/COLENG, XSIZE, YSIZE, ISHAPE
      CHARACTER*1 MALE(101,51),MXXPR(101,51),MYYPR(101,51),MXY(101,51)
      COMMON/CTRMAT/ AM1(27),AM2(27),AM3(27),AM4(27),AM5(27),AM6(27),
     >ZI(6),ZF(6),NEL,IMSAV,
     >M1(27),M2(27),M3(27),M4(27),M5(27),M6(27),N1,N2,N3,N4,N5,N6
      common /ctrsym/
     >bs11,bs12,bs13,bs14,bs15,bs16,bs21,bs22,bs23,bs24,bs25,bs26,
     >bs31,bs32,bs33,bs34,bs35,bs36,bs41,bs42,bs43,bs44,bs45,bs46,
     >bs51,bs52,bs53,bs54,bs55,bs56,
     >cs17,cs18,cs19,cs110,cs111,cs112,cs113,cs114,cs115,cs116,cs117,
     >cs118,cs119,cs120,cs121,cs122,cs123,cs124,cs125,cs126,cs127,
     >cs27,cs28,cs29,cs210,cs211,cs212,cs213,cs214,cs215,cs216,cs217,
     >cs218,cs219,cs220,cs221,cs222,cs223,cs224,cs225,cs226,cs227,
     >cs37,cs38,cs39,cs310,cs311,cs312,cs313,cs314,cs315,cs316,cs317,
     >cs318,cs319,cs320,cs321,cs322,cs323,cs324,cs325,cs326,cs327,
     >cs47,cs48,cs49,cs410,cs411,cs412,cs413,cs414,cs415,cs416,cs417,
     >cs418,cs419,cs420,cs421,cs422,cs423,cs424,cs425,cs426,cs427,
     >cs57,cs58,cs59,cs510,cs511,cs512,cs513,cs514,cs515,cs516,cs517,
     >cs518,cs519,cs520,cs521,cs522,cs523,cs524,cs525,cs526,cs527,
     >isysav
      COMMON/CRDMON/MONAME(8),MOBEG,MOEND,MRDFLG
     >,MRDCHK
      CHARACTER*1 MONAME
      COMMON/CSEIS/XLAMBS,AXSEIS,PHIXS,YLAMBS,
     >AYSEIS,PHIYS,XSEIS,YSEIS,ISEIFL,IBEGSE,IENDSE
      COMMON/CRMAT/ACIN(6),AINC(6),ACOUT(6),eps1,eps2,
     >betix,alphix,epsix,betiy,alphiy,epsiy,
     >  IFLMAT,NRMPRT,NRMORD,nmopt
      common/cspch/delspx(mxpart),delspy(mxpart),
     >dpmax,dkxmax,dkymax,ispopt,ispchf
      COMMON/CAV/FREQ,ALC,AML,CAVPHI,DEOVE,CPHI(MXPART),
     >PINGAM,PBETA,PCLENG,DTN,DAML,DTNA(MXPART),
     >CTF,CLP,DPHI,F0CAV,F1CAV,PERCAV,APHIAD,ICOPT,IAML,
     >N0CAV,N1CAV,INCAV
      COMMON/LINCAV/LCAVIN,NUMCAV,ENJECT,IECAV(MAXMAT),
     &              EIDEAL(MAXPOS),EREAL(MAXPOS)
      LOGICAL LCAVIN
      common/cinter/inumel,niplot,intflg,iprpl,jherr,itrap,
     > numel(20),iscx(20),iscy(20),
     > iscsx(20),iscsy(20),avx(11,101),avy(11,101),axis(101)
      character*1 avx,avy,axis
      parameter    (MXBLOC = 100)
      common/cblock/
     >bx(mxbloc),bxp(mxbloc),by(mxbloc),byp(mxbloc),
     >bz(mxbloc),bzr(mxbloc),bdel(mxbloc),
     >sx(mxbloc),sxp(mxbloc),sy(mxbloc),syp(mxbloc),
     >sz(mxbloc),szr(mxbloc),sdel(mxbloc),sal(mxbloc),
     >dblx,dblxp,dbly,dblyp,dblz,dblzr,dbldel,dblal,
     >iebl(mxbloc),nel1(mxbloc),nel2(mxbloc),
     >ibt,ixbls,ixblstp,iblflg,iblchk,iblopt,iblsopt
      parameter    (MXCEB = 2000)
      common/cebcav/cebmat(6,6,mxceb),estart,ecav(mxceb),
     >ipos(mxceb),icavtot,icebflg,iestflg,icurcav
      DIMENSION Y(6),X(6)
      EQUIVALENCE (Y1,Y(1)),(X1,X(1))
C
C   PRINT INITIAL POSITIONS
C
      NORDER=2
        IF(NPRINT.NE.-2)CALL TRAKPR(-1,1)
      IF(NPLOT.EQ.0) THEN
             LSTREQ=NCTURN+NTURN
             NXREQ=NCTURN+NTURN
                     ELSE
             NXREQ = NPLOT +NCTURN
             LSTREQ = NTURN/NPLOT*NPLOT
      ENDIF
C
C   TURN LOOP NCTURN -> NTURN
C
      NCHECK=0
      PINGAM=0.0D0
      PBETA=1.0D0
      CTF=0.0D0
   10 NCTURN=NCTURN+1
      ntbeg=1
      if(ncturn.eq.1)then
         DO 11011 IPT=1,MXPART
         cphi(ipt)=0.0d0
c11011    DTNA(IPT)=part(ipt,5)
11011    DTNA(IPT)=0.0d0
         PCLENG=0
ccc         INCAV=0
         DTN=0
         isyfl=0
      endif
         if(ispchf.eq.1) then
          do 811 ipart=1,npart
          delspx(ipart)=-dkxmax*dmax1(0.0d0,
     >     (dabs(part(ipart,6))+dpmax-dabs(del(ipart)))/dpmax)
          delspy(ipart)=-dkymax*dmax1(0.0d0,
     >     (dabs(part(ipart,6))+dpmax-dabs(del(ipart)))/dpmax)
  811     continue
         endif
      if(isyfl.eq.1)syphip=syphi
      IF(IADFLG.EQ.1)CALL ADICHK
      MONFLG=0
      IF((IALFLG.EQ.0).and.(intflg.eq.0))GOTO 601
      IF((IALFLG.EQ.1).or.(intflg.eq.1))GOTO 602
      ITRBEG=IAFRST
      ITREND=MONLST
      IF(IXMSTP.NE.0) THEN
           IXS=ISDBEG
           IXMSTP=IBGSTP
                      ELSE
           IXS=ISDBEG
      ENDIF
      IF(IXESTP.NE.0) THEN
           IXES=IESBEG
           IXESTP=IESTBG
                      ELSE
           IXES=IESBEG
      ENDIF
      if(ixblstp.ne.0)then
       ixbls=ibsbeg
       ixblstp=ibstbg
                      else
       ixbls=ibsbeg
      endif
      IERSRT = IERBEG
      GOTO 603
  601 ITRBEG=1
      ITREND=NELM
      IF(IXMSTP.NE.0) THEN
           IXS=1
           IXMSTP=1
                      ELSE
           IXS=ISEED
      ENDIF
      IF(IXESTP.NE.0) THEN
           IXES=1
           IXESTP=1
                      ELSE
           IXES=ISEED
      ENDIF
      if(ixblstp.ne.0)then
       ixbls=1
       ixblstp=1
                      else
       ixbls=iseed
      endif
      IERSRT = 1
      GOTO 603
  602 ITRBEG=1
      ITREND=IAFRST-1
      IF(IXMSTP.NE.0) THEN
           IXS=1
           IXMSTP=1
                      ELSE
           IXS=ISEED
      ENDIF
      IF(IXESTP.NE.0) THEN
           IXES=1
           IXESTP=1
                      ELSE
           IXES=ISEED
      ENDIF
      if(ixblstp.ne.0)then
       ixbls=1
       ixblstp=1
                      else
       ixbls=iseed
      endif
      IERSRT = 1
  603 ILIST=1
      MISPTR = 1
      ICRPTR = 1
      ITCHCK = (NCTURN-1)*(ITREND-ITRBEG+1)
      DO 110 IE=ITRBEG,ITREND
      icurcav=0
       IEP=IE
      NEL=NORLST(IE)
      MNEL=NEL
      IAD=IADR(NEL)
      MATADR=MADR(NEL)
      NT=KODE(NEL)
      if(iblflg.eq.1)call blockchk(ie,nel)
      NTP1=NT+1
CCCC      CLP=CTF*ALENG(NEL)*PINGAM*PINGAM
      IF(ISEIFL.EQ.1) THEN
       IF((IE.GE.IBEGSE).AND.(IE.LE.IENDSE)) THEN
        DXS=-XSEIS
        XSEIS=AXSEIS*DSIN(PHIXS+ACLENG(IE)*TWOPI/XLAMBS)
        DXS=DXS+XSEIS
        DYS=-YSEIS
        YSEIS=AYSEIS*DSIN(PHIYS+ACLENG(IE)*TWOPI/YLAMBS)
        DYS=DYS+YSEIS
        DO 333 IP=1,NPART
        IF(.NOT.LOGPAR(IP))GOTO 333
        PART(IP,1)=PART(IP,1)+DXS
        PART(IP,3)=PART(IP,3)+DYS
  333   CONTINUE
       ENDIF
      ENDIF
      if(iblchk.eq.1) call blin
      GOTO(10000,1000,4000,4000,4000,5000,6000,7000,8000,
     >9000,9000,99888,12000,13000,99888,9000,110,9500,
     >18000,9000,20000),NTP1
C
C (SKIP OVER ELEMENT IF KODE=16 - NO CODE 16 ELEMENTS)
C
C
C    TREATING DRIFTS : CODE 0 , NO ERRORS ,ALIGNMENTS, PARTICLE CHECK
C
10000 AL=ALENG(NEL)
      IF(AL.EQ.0.0D0) GOTO 99888
      ALO2=0.5D0*AL
      CALL TRFDR
      GOTO 99888
C
C  TREATING BENDS : CODE 1 ,ERRORS,MISALIGNEMENTS,PARTICLE CHECK
C       CORRECTOR ELEMENTS  AND SYNCHROTON RADIATION
C
 1000 MCHFLG=0
      ICRCHK=0
      ierset=0
      IF(ISYNFL.NE.0) CALL SYNPRE(IAD,NEL)
      IF(ICRFLG.EQ.1) CALL CORCHK(IE)
      IF(MISFLG.EQ.1) CALL MISCHK
      IF((MERFLG.EQ.1).OR.(ICRCHK.EQ.2)) CALL ESET(NEL,MATADR)
      IMSAV=0
      isysav=0
c      IF((NCPART.GT.2).AND.(ISYOPT.LT.1)) THEN
      IF(NCPART.GT.2) THEN
          IMSAV=1
          CALL TRSAV(MATADR)
      ENDIF
c     prepare data for synchrotron radiation with new method.
      if (iff.ge.1) then
         alen = dabs(aleng(nel))
         angle = dabs(eldat(iad+1))
         if (kunits.eq.2) angle = angle * crdeg
         call synrad(1, alen, angle)
      endif
      DO 1001 ICPART=1,NPART
      IF(.NOT.LOGPAR(ICPART)) GO TO 1001
      X1=PART(ICPART,1)
      X2=PART(ICPART,2)
      X3=PART(ICPART,3)
      X4=PART(ICPART,4)
      X5=PART(ICPART,5)
      X6=PART(ICPART,6)
      TEST=(X1)**2+(X3)**2
      IF(TEST.LT.EXPEL2) GO TO 1002
      WRITE(IOUT,10024)ICPART,IE,(NAME(IZ,NEL),IZ=1,8),NCTURN
      IF(ISO.NE.0)WRITE(ISOUT,10024)ICPART,IE,(NAME(IZ,NEL),IZ=1,8)
     <,NCTURN
      NCPART=NCPART-1
      LOGPAR(ICPART)=.FALSE.
      WRITE(IOUT,10300)ICPART,(PART(ICPART,J),J=1,6)
      GOTO 1001
 1002 IF(ISYNFL.EQ.0)GOTO 1008
      IF(ISYNFL.EQ.2)GOTO 1009
      if(iff.ge.1) call synrad(2,alen,angle)
      X6=X6-0.5D0*SYNDEL
      IF(ISYNFL.EQ.1)GOTO 1008
 1009 X6=X6+0.707D0*EMITGR*RANNUM(ISYNSD,IRND,6.0D0,ISYSTP)
 1008 IF(ICRCHK.EQ.1) CALL CSET
      IF(MCHFLG.EQ.1) CALL MSET
      CALL TRMAT(MATADR,ICPART)
      IF(MCHFLG.EQ.1) CALL MRESET
      IF(ICRCHK.EQ.1) CALL CRESET
      IF(ISYNFL.EQ.0)GOTO 1006
      IF(ISYNFL.EQ.2)GOTO 1007
      if(iff.ge.1) call synrad(2,alen,angle)
      Y6=Y6-0.5D0*SYNDEL
      IF(ISYNFL.EQ.1)GOTO 1006
 1007 Y6=Y6+0.707D0*EMITGR*RANNUM(ISYNSD,IRND,6.0D0,ISYSTP)
 1006 PART(ICPART,1)=Y1
      PART(ICPART,2)=Y2
      PART(ICPART,3)=Y3
      PART(ICPART,4)=Y4
      PART(ICPART,5)=Y5
      PART(ICPART,6)=Y6
      DX5=Y5-X5
CCCC      CPHI(ICPART)=CPHI(ICPART)+CTF*DX5-CLP*X6
 1001 CONTINUE
      GOTO 99888
C
C  TREATING QUADS : CODE 2,SEXTUPOLES : CODE 3,QUADSEXT : CODE 4
C        ERRORS,MISALIGNEMENTS,PARTICLE CHECK
C       CORRECTOR ELEMENTS
C
 4000 MCHFLG=0
      ICRCHK=0
      ierset=0
      isptst=0
      if((ispchf.eq.1).and.(ntp1.eq.3))isptst=1
      alen=dabs(aleng(nel))
      IF(ISYNQD.EQ.1) CALL SYNPRE(IAD,NEL)
      IF(ICRFLG.EQ.1) CALL CORCHK(IE)
      IF(MISFLG.EQ.1) CALL MISCHK
      IF((MERFLG.EQ.1).OR.(ICRCHK.EQ.2)) CALL ESET(NEL,MATADR)
      IMSAV=0
      isysav=0
c      IF((NCPART.GT.2).AND.(ISYOPT.LT.1)) THEN
      IF(NCPART.GT.2) THEN
          IMSAV=1
          CALL TRSAV(MATADR)
      ENDIF
      DO 4001 ICPART=1,NPART
      IF(.NOT.LOGPAR(ICPART)) GO TO 4001
      X1=PART(ICPART,1)
      X2=PART(ICPART,2)
      X3=PART(ICPART,3)
      X4=PART(ICPART,4)
      X5=PART(ICPART,5)
c old statement replaced by the one following
c      if(eldat(iad+1).gt.0) then
      if(eldat(iad+1).ne.0) then
       X6=PART(ICPART,6)+isptst*delspx(icpart)
                            else
       X6=PART(ICPART,6)+isptst*delspy(icpart)
      endif
      TEST=(X1)**2+(X3)**2
c change particle check for a check vs 1/2-aperture rather than expel2
c      aperture = eldat (iadr(nel+1) - 2)
c      if (aperture.le.0.d0 .or. aperture.gt.expel2) aperture=expel2
c      if (test.lt.aperture) go to 4002
      IF(TEST.LT.EXPEL2) GO TO 4002
      WRITE(IOUT,10024)ICPART,IE,(NAME(IZ,NEL),IZ=1,8),NCTURN
      IF(ISO.NE.0)WRITE(ISOUT,10024)ICPART,IE,(NAME(IZ,NEL),IZ=1,8)
     <,NCTURN
      NCPART=NCPART-1
      LOGPAR(ICPART)=.FALSE.
      WRITE(IOUT,10300)ICPART,(PART(ICPART,J),J=1,6)
      GOTO 4001
 4002 IF(ICRCHK.EQ.1) CALL CSET
      IF(MCHFLG.EQ.1) CALL MSET
      IF(ISYNQD.EQ.1) THEN
c       first save the entrance coordinates for second pass of tracking
        xs1=x1
        XS2=X2
        xs3=x3
        XS4=X4
        xs5=x5
        xs6=x6
      ENDIF
      CALL TRMAT(MATADR,ICPART)
      IF(ISYNQD.EQ.1) THEN
        D1=DSQRT(1.0D0-XS2**2-XS4**2)
        D2=DSQRT(1.0D0-Y2**2-Y4**2)
        COSEX=XS2*Y2+XS4*Y4+D1*D2
        ANGLE=DABS(DACOS(COSEX))
        if (iff.ge.1) then
c           restore initial coordinates...
            x1 = xs1
            x2 = xs2
            x3 = xs3
            x4 = xs4
            x5 = xs5
            x6 = xs6
c          option 3 is quad specific (see routine SYNRAD)
            call synrad(3, alen, angle)
            x6 = x6 - syndel/2.0d0
c          perform new tracking same quad
            call trmat(matadr)
c          option 2 saves time here!
            call synrad(2, alen, angle)
            y6 = y6 - syndel/2.0d0
        else
        EMITGR=DSQRT(EMITK*ANGLE*ANGLE*ANGLE)
        Y6=Y6+EMITGR*RANNUM(ISYNSD,IRND,6.0D0,ISYSTP)
     >       -EMITK2*ANGLE*ANGLE
        endif
      ENDIF
      IF(MCHFLG.EQ.1) CALL MRESET
      IF(ICRCHK.EQ.1) CALL CRESET
      PART(ICPART,1)=Y1
      PART(ICPART,2)=Y2
      PART(ICPART,3)=Y3
      PART(ICPART,4)=Y4
      PART(ICPART,5)=Y5
c next is old statement replaced by the next one
c      if(eldat(iad+1).gt.0) then
      if(eldat(iad+1).ne.0) then
       part(icpart,6)=y6-isptst*delspx(icpart)
                            else
       part(icpart,6)=y6-isptst*delspy(icpart)
      endif
      DX5=Y5-X5
CCCC      CPHI(ICPART)=CPHI(ICPART)+CTF*DX5-CLP*PART(ICPART,6)
 4001 CONTINUE
      GOTO 99888
C
C  TREAT MULTIPOLES : CODE 5 . MISALIGNMENTS AND ERRORS
C
 5000 AL = 0.5D0*ALENG(NEL)
CCCC      clp=clp*0.5d0
      ALO2=0.5D0*AL
      MCHFLG=0
      ierset=0
      IF(MISFLG.EQ.1)CALL MISCHK
      IF(MERFLG.EQ.1)CALL ESET(NEL,MATADR)
      CALL MULTIT(NEL)
      IF(AL.NE.0.0D0)THEN
       IMSAV=0
      isysav=0
c       IF((NCPART.GT.2).AND.(ISYOPT.LT.1))THEN
      IF(NCPART.GT.2) THEN
       IMSAV=1
       CALL TRSAV(MATADR)
       ENDIF
      ENDIF
      DO 5001 ICPART=1,NPART
      IF(.NOT.LOGPAR(ICPART)) GO TO 5001
      X1=PART(ICPART,1)
      X2=PART(ICPART,2)
      X3=PART(ICPART,3)
      X4=PART(ICPART,4)
      X5=PART(ICPART,5)
      X6=PART(ICPART,6)
      TEST=(X1)**2+(X3)**2
      IF(TEST.LT.EXPEL2) GO TO 5002
      WRITE(IOUT,10024)ICPART,IE,(NAME(IZ,NEL),IZ=1,8),NCTURN
      IF(ISO.NE.0)WRITE(ISOUT,10024)ICPART,IE,(NAME(IZ,NEL),IZ=1,8)
     <,NCTURN
      NCPART=NCPART-1
      LOGPAR(ICPART)=.FALSE.
      WRITE(IOUT,10300)ICPART,(PART(ICPART,J),J=1,6)
      GOTO 5001
 5002 IF(MCHFLG.EQ.1)CALL MSET
      IF(AL.NE.0.0d0) THEN
       CALL TRMAT(MATADR,ICPART)
      DX5=Y5-X5
CCCC      CPHI(ICPART)=CPHI(ICPART)+CTF*DX5-CLP*X6
       X1=Y1
       X2=Y2
       X3=Y3
       X4=Y4
       X5=Y5
       X6=Y6
      ENDIF
      CALL MULTTR(X1,X2,X3,X4,X5,X6,Y1,Y2,Y3,Y4,Y5,Y6)
      IF(AL.NE.0.0d0) THEN
       X1=Y1
       X2=Y2
       X3=Y3
       X4=Y4
       X5=Y5
       X6=Y6
       CALL TRMAT(MATADR,ICPART)
      DX5=Y5-X5
CCCC      CPHI(ICPART)=CPHI(ICPART)+CTF*DX5-CLP*X6
      ENDIF
      IF(MCHFLG.EQ.1)CALL MRESET
      PART(ICPART,1)=Y1
      PART(ICPART,2)=Y2
      PART(ICPART,3)=Y3
      PART(ICPART,4)=Y4
      PART(ICPART,5)=Y5
      PART(ICPART,6)=Y6
 5001 CONTINUE
      GOTO 99888
C
C   TREAT COLLIMATORS : CODE 6 . NO MISALIGNEMENTS NO ERRORS
C
 6000 AL = ALENG(NEL)
      CALL COLPRE(IAD)
      DO 6001 ICPART=1,NPART
      IF(.NOT.LOGPAR(ICPART)) GO TO 6001
      X1=PART(ICPART,1)
      X2=PART(ICPART,2)
      X3=PART(ICPART,3)
      X4=PART(ICPART,4)
      X5=PART(ICPART,5)
      X6=PART(ICPART,6)
C    CHECK COORDINATES AT ENTRY, BOTH RECTANGULAR AND ELLIPTIC CASES
      IF(ISHAPE.EQ.1) THEN
        IF(DABS(X1).GT.XSIZE.OR.DABS(X3).GT.YSIZE) GO TO 6002
      ELSE
        ALIM = (X1/XSIZE)**2 + (X3/YSIZE)**2
        IF(ALIM.GT.1.0) GO TO 6002
      ENDIF
C     IF ZERO LENGTH, THEN JOB IS DONE
      IF(AL.EQ.0.0) GOTO 6001
      CALL TRDRIF
      PART(ICPART,1)=Y1
      PART(ICPART,3)=Y3
      PART(ICPART,5)=Y5
C     IF(ISYFLG.EQ.1) THEN         REDUNDANT STATEMENTS
C      PART(ICPART,2)=Y2           DRIFT DOES NOT CHANGE
C      PART(ICPART,4)=Y4           MOMENTUM OR ANGLE
C     ENDIF
C   NOW CHECK COORDINATES AT EXIT
      IF(ISHAPE.EQ.2) THEN
        IF((DABS(Y1).GT.XSIZE).OR.(DABS(Y3).GT.YSIZE)) GO TO 6002
      ELSE
        ALIM = (Y1/XSIZE)**2 + (Y3/YSIZE)**2
        IF(ALIM.GT.1.0) GO TO 6002
      ENDIF
      GO TO 6001
6002  WRITE(IOUT,10024)ICPART,IE,(NAME(IZ,NEL),IZ=1,8),NCTURN
      IF(ISO.NE.0)WRITE(ISOUT,10024)ICPART,IE,(NAME(IZ,NEL),IZ=1,8)
     <,NCTURN
10024 FORMAT(//,'  PARTICLE #',I6,' IS LOST BEFORE ELEMENT',I6,
     +  '(',8A1,')',
     +  ' DURING TURN:',I6,/,' ITS POSITION IS :',//)
      NCPART=NCPART-1
      LOGPAR(ICPART)=.FALSE.
      WRITE(IOUT,10300)ICPART,(PART(ICPART,J),J=1,6)
      IF(ISO.NE.0)WRITE(ISOUT,10300)ICPART,(PART(ICPART,J),J=1,6)
10300 FORMAT(' ',I4,6(E14.5))
      DX5=Y5-X5
CCCC      CPHI(ICPART)=CPHI(ICPART)+CTF*DX5-CLP*X6
 6001 CONTINUE
      GOTO 99888
 7000 CALL CAVPRE(IAD,NEL,NCTURN,IE)
      DO 7001 ICPART=1,NPART
      IF(.NOT.LOGPAR(ICPART)) GO TO 7001
      X1=PART(ICPART,1)
      X2=PART(ICPART,2)
      X3=PART(ICPART,3)
      X4=PART(ICPART,4)
      X5=PART(ICPART,5)
      X6=PART(ICPART,6)
      if(kanvar.eq.1) then
        call ncvar(x1,y1,gammli,betali)
        CALL CAVITY(y1,y2,y3,y4,y5,y6,x1,x2,x3,x4,x5,x6,ICPART,NCTURN)
        call  cvar(x1,y1,gammli,betali)
                      else
        CALL CAVITY(X1,X2,X3,X4,X5,X6,Y1,Y2,Y3,Y4,Y5,Y6,ICPART,NCTURN)
      endif
      PART(ICPART,1)=Y1
      PART(ICPART,2)=Y2
      PART(ICPART,3)=Y3
      PART(ICPART,4)=Y4
      PART(ICPART,5)=Y5
      PART(ICPART,6)=Y6
      DX5=Y5-X5
CCCC      CPHI(ICPART)=CPHI(ICPART)+CTF*DX5-CLP*X6
 7001 CONTINUE
ccc      IF(INCAV.EQ.1)INCAV=2
      GOTO 99888
C
C
C  TREAT KICKS : CODE 8 . NO MISALIGNMENT , ERRORS (FOR POSSIBLE ROLL
C  STUDY), CORRECTORS OPTION 3 ONLY.
C
 8000 AL=0.5D0*ALENG(NEL)
CCCC      clp=clp*0.5d0
      ALO2=0.5D0*AL
      ICRCHK=0
      IF(AL.NE.0.0D0) CALL TRFDR
      IF(ICRFLG.EQ.1) CALL CORCHK(IE)
      IF(KUNITS.EQ.2) ANGKIK=ELDAT(IAD+7)*CRDEG
      IF(KUNITS.EQ.1) ANGKIK = -ELDAT(IAD+7)
      IF(KUNITS.EQ.0) ANGKIK = ELDAT(IAD+7)
      COSK=DCOS(ANGKIK)
      SINK=DSIN(ANGKIK)
      IF(MERFLG.EQ.1)CALL ESET(NEL,MATADR)
      IKI=DABS(ELDAT(IAD+9))+.01
      IKM=MOD(NCTURN,IKI)
      IF(IKM.NE.0)GO TO 8002
      MSYN=ELDAT(IAD+10)
      IF(MSYN.LT.0) THEN
         NSYN=ABS(FLOAT(MSYN))
        if(isyfl.eq.0) then
           syphip=-twopi/nsyn
           isyfl=1
         endif
         if(ntbeg.eq.1) then
           syphi=syphip+twopi/nsyn
           ntbeg=0
         endif
         SYNFAC=DCOS(TWOPI*(ACLENG(IE)/TLENG)/NSYN+syphi)
      ENDIF
      IFACTK=ELDAT(IAD+10)
      DXK=ELDAT(IAD+1)
      IF(KUNITS.EQ.1) THEN
           DXPK=-ELDAT(IAD+2)
                      ELSE
           DXPK=ELDAT(IAD+2)
      ENDIF
      DYK=ELDAT(IAD+3)
      DYPK=ELDAT(IAD+4)
      DALK=ELDAT(IAD+5)
      DDELK=ELDAT(IAD+6)
C
C  SCALE MOMENTA KICKS BY RATIO OF IDEAL TO REAL MOMENTA IF CAVITIES
C  ARE PRESENT AND ERRORS ARE ACTIVATED
C
      IF((LCAVIN).AND.(MERFLG.EQ.1)) THEN
      CPIDEAL=DSQRT(EIDEAL(IE)**2-EMASS**2)
      CPREAL =DSQRT(EREAL(IE)**2-EMASS**2)
      RATMOM=(CPIDEAL/CPREAL)
      DXPK=RATMOM*DXPK
      DYPK=RATMOM*DYPK
      DDELK=RATMOM*DDELK
      END IF
      DO 8001 ICPART=1,NPART
      IF(.NOT.LOGPAR(ICPART)) GO TO 8001
      X1=PART(ICPART,1)
      X2=PART(ICPART,2)
      X3=PART(ICPART,3)
      X4=PART(ICPART,4)
      X5=PART(ICPART,5)
      X6=PART(ICPART,6)
      IF(ICRCHK.EQ.2) CALL CSET
      FACTE=1.0D0
      IF(IFACTK.EQ.1)FACTE=1.0D0/(1.0D0+X6)
      SX1=X1*COSK+X3*SINK
      X3=-X1*SINK+X3*COSK
      X1=SX1
      SX2=X2*COSK+X4*SINK
      X4=-X2*SINK+X4*COSK
      X2=SX2
      Y1=X1+DXK
      Y2=X2+DXPK*FACTE
      Y3=X3+DYK
      Y4=X4+DYPK*FACTE
      Y5=X5+DALK
      DX5=DALK
cccc      CPHI(ICPART)=CPHI(ICPART)+CTF*(DX5-DALK*PINGAM*PINGAM*X6)
      Y6=X6+DDELK
      IF(MSYN.LT.0) Y6=DEL(ICPART)*SYNFAC
      PART(ICPART,1)=Y1
      PART(ICPART,2)=Y2
      PART(ICPART,3)=Y3
      PART(ICPART,4)=Y4
      PART(ICPART,5)=Y5
      PART(ICPART,6)=Y6
 8001 CONTINUE
 8002 IF(AL.NE.0.0D0)CALL TRFDR
      GOTO 99888
C
C  TREATING
C   TWISS : CODE 9,GENERAL MATRIX : CODE 10, SOLQUA : CODE 15
C   quadac : code 19
C        ERRORS,MISALIGNEMENTS,PARTICLE CHECK
C       CORRECTOR ELEMENTS
C
 9000 MCHFLG=0
      ICRCHK=0
      ierset=0
      IF(ICRFLG.EQ.1) CALL CORCHK(IE)
      IF(MISFLG.EQ.1) CALL MISCHK
      IF((MERFLG.EQ.1).OR.(ICRCHK.EQ.2)) CALL ESET(NEL,MATADR)
      IMSAV=0
      isysav=0
c      IF((NCPART.GT.2).AND.(ISYOPT.LT.1)) THEN
      IF(NCPART.GT.2) THEN
          IMSAV=1
          CALL TRSAV(MATADR)
      ENDIF
      DO 9001 ICPART=1,NPART
      IF(.NOT.LOGPAR(ICPART)) GO TO 9001
      X1=PART(ICPART,1)
      X2=PART(ICPART,2)
      X3=PART(ICPART,3)
      X4=PART(ICPART,4)
      X5=PART(ICPART,5)
      X6=PART(ICPART,6)
      TEST=(X1)**2+(X3)**2
      IF(TEST.LT.EXPEL2) GO TO 9002
      WRITE(IOUT,10024)ICPART,IE,(NAME(IZ,NEL),IZ=1,8),NCTURN
      IF(ISO.NE.0)WRITE(ISOUT,10024)ICPART,IE,(NAME(IZ,NEL),IZ=1,8)
     <,NCTURN
      NCPART=NCPART-1
      LOGPAR(ICPART)=.FALSE.
      WRITE(IOUT,10300)ICPART,(PART(ICPART,J),J=1,6)
      GOTO 9001
 9002 IF(ICRCHK.EQ.1) CALL CSET
      IF(MCHFLG.EQ.1) CALL MSET
      CALL TRMAT(MATADR,ICPART)
      IF(MCHFLG.EQ.1) CALL MRESET
      IF(ICRCHK.EQ.1) CALL CRESET
      PART(ICPART,1)=Y1
      PART(ICPART,2)=Y2
      PART(ICPART,3)=Y3
      PART(ICPART,4)=Y4
      PART(ICPART,5)=Y5
      PART(ICPART,6)=Y6
      DX5=Y5-X5
CCCC      CPHI(ICPART)=CPHI(ICPART)+CTF*DX5-CLP*X6
 9001 CONTINUE
      GOTO 99888
C-----------------------------------------------------------------------
C
C   TREAT LINAC CAVITY: CODE 17
C        ERRORS,MISALIGNEMENTS,PARTICLE CHECK
C       CORRECTOR ELEMENTS
C
 9500 MCHFLG=0
      ICRCHK=0
      ierset=0
      IF(ICRFLG.EQ.1) CALL CORCHK(IE)
      IF(MISFLG.EQ.1) CALL MISCHK
      IF((MERFLG.EQ.1).OR.(ICRCHK.EQ.2)) CALL ESET(NEL,MATADR)
      IMSAV=0
      isysav=0
c      IF((NCPART.GT.2).AND.(ISYOPT.LT.1)) THEN
      IF(NCPART.GT.2) THEN
          IMSAV=1
          CALL TRSAV(MATADR)
      ENDIF
C
C GET KICK PARAMETERS FROM ELEMENT DATA
C
      DELTAE=ELDAT(IAD+2)
      PHI0  =ELDAT(IAD+3)*CRDEG
      AKICK =ELDAT(IAD+5)
      KONOFF=ELDAT(IAD+6)
C DEFAULTS (USED IF KONOFF=0)
      ENOW=1.D0
      SHIFT=0.D0
C GET ENERGY IF KICK BEFORE CAVITY
      IF(KONOFF.LT.0) THEN
        IF(IE.EQ.1) THEN
           ENOW=ENJECT
        ELSE
           ENOW=EREAL(IE-1)
        END IF
      END IF
C GET ENERGY IF KICK AFTER CAVITY
      IF(KONOFF.GT.0) THEN
        ENOW=EREAL(IE)
      END IF
C GET KICK MAGNITUDE IF NONZERO
      IF(KONOFF.NE.0) THEN
        CPNOW=DSQRT(ENOW**2-EMASS**2)
        SHIFT=(DELTAE*AKICK*DCOS(PHI0))/CPNOW
      END IF
      DO 9501 ICPART=1,NPART
      IF(.NOT.LOGPAR(ICPART)) GO TO 9501
      X1=PART(ICPART,1)
      X2=PART(ICPART,2)
      X3=PART(ICPART,3)
      X4=PART(ICPART,4)
      X5=PART(ICPART,5)
      X6=PART(ICPART,6)
      TEST=(X1)**2+(X3)**2
      IF(TEST.LT.EXPEL2) GO TO 9502
      WRITE(IOUT,10024)ICPART,IE,(NAME(IZ,NEL),IZ=1,8),NCTURN
      IF(ISO.NE.0)WRITE(ISOUT,10024)ICPART,IE,(NAME(IZ,NEL),IZ=1,8)
     <,NCTURN
      NCPART=NCPART-1
      LOGPAR(ICPART)=.FALSE.
      WRITE(IOUT,10300)ICPART,(PART(ICPART,J),J=1,6)
      GOTO 9501
 9502 IF(ICRCHK.EQ.1) CALL CSET
      IF(MCHFLG.EQ.1) CALL MSET
C
C  CHECK KICK PARAMETERS; PROCESS KICK IF REQUIRED
C
      IF(KONOFF.EQ.(-2)) X4=X4+SHIFT
      IF(KONOFF.EQ.(-1)) X2=X2+SHIFT
      CALL TRMAT(MATADR,ICPART)
C
C  CHECK KICK PARAMETERS; PROCESS KICK IF REQUIRED
C
      IF(KONOFF.EQ.1)    Y2=Y2+SHIFT
      IF(KONOFF.EQ.2)    Y4=Y4+SHIFT
      IF(MCHFLG.EQ.1) CALL MRESET
      IF(ICRCHK.EQ.1) CALL CRESET
      PART(ICPART,1)=Y1
      PART(ICPART,2)=Y2
      PART(ICPART,3)=Y3
      PART(ICPART,4)=Y4
      PART(ICPART,5)=Y5
      PART(ICPART,6)=Y6
      DX5=Y5-X5
CCCC      CPHI(ICPART)=CPHI(ICPART)+CTF*DX5-CLP*X6
 9501 CONTINUE
      GOTO 99888
C-----------------------------------------------------------------------
C TREAT ARBITRARY ELEMENT : CODE 12 MISALIGNEMENT ERRORS CORRECTORS
C
C                IF (ISYOPT.NE.0) IE IF SYMPLECTIC TRACING IS DONE
C                SEE COMMENTS IN SUBROUTINE TRAFCT HEADING
C                REGARDING CHOICE OF VARIABLES
C
12000 MCHFLG = 0
      ICRCHK = 0
      IERSET = 0
      al=aleng(nel)
c      write(iout,*) ' in trackt, calling trafct '
      IF (ICRCHK.EQ.1) CALL CORCHK(IE)
      IF (MISFLG.EQ.1) CALL MISCHK
      IF ( (MERFLG.EQ.1).OR.(ICRCHK.EQ.2) ) CALL ESET(NEL,MATADR)
      CALL ARBIT(IAD,NEL)
      DO 12001 ICPART=1,NPART
      IF(.NOT.LOGPAR(ICPART)) GO TO 12001
      X1=PART(ICPART,1)
      X2=PART(ICPART,2)
      X3=PART(ICPART,3)
      X4=PART(ICPART,4)
      X5=PART(ICPART,5)
      X6=PART(ICPART,6)
      IF (ICRCHK.NE.1) THEN
         IF (MCHFLG.NE.1) THEN
      CALL TRAFCT(X1,X2,X3,X4,X5,X6,Y1,Y2,Y3,Y4,Y5,Y6,ICPART)
         ELSE
            CALL MSET
      CALL TRAFCT(X1,X2,X3,X4,X5,X6,Y1,Y2,Y3,Y4,Y5,Y6,ICPART)
            CALL MRESET
         END IF
      ELSE
         CALL CSET
         IF (MCHFLG.NE.1) THEN
      CALL TRAFCT(X1,X2,X3,X4,X5,X6,Y1,Y2,Y3,Y4,Y5,Y6,ICPART)
         ELSE
            CALL MSET
      CALL TRAFCT(X1,X2,X3,X4,X5,X6,Y1,Y2,Y3,Y4,Y5,Y6,ICPART)
            CALL MRESET
         END IF
         CALL CRESET
      END IF
      PART(ICPART,1)=Y1
      PART(ICPART,2)=Y2
      PART(ICPART,3)=Y3
      PART(ICPART,4)=Y4
      PART(ICPART,5)=Y5
      PART(ICPART,6)=Y6
12001 CONTINUE
      GOTO 99888
C
C TREAT MONITORS : THEY CAN BE MISALIGNED BUT HAVE NO ERRORS
C
13000 MCHFLG=0
      IF(MISFLG.EQ.1)CALL MISCHK
      IF(MRDFLG.EQ.1)CALL RMOCHK(IE)
      IF(IALFLG.EQ.2)CALL MONCHK(IE)
        IF((MONFLG.NE.0).OR.(MRDCHK.EQ.1)) THEN
          AL=0.5D0*ALENG(NEL)
CCCC          clp=clp*0.5d0
          ALO2=0.5D0*AL
          DO 13001 ICPART=1,NPART
          IF(.NOT.LOGPAR(ICPART))GOTO 13001
          X1=PART(ICPART,1)
          X3=PART(ICPART,3)
          X5=PART(ICPART,5)
          X2=PART(ICPART,2)
          X4=PART(ICPART,4)
          X6=PART(ICPART,6)
          IF(MCHFLG.EQ.1) CALL MSET
          CALL TRDRIF
          PART(ICPART,1)=Y1
          PART(ICPART,3)=Y3
          PART(ICPART,5)=Y5
          PART(ICPART,2)=Y2
          PART(ICPART,4)=Y4
          PART(ICPART,6)=Y6
          DX5=Y5-X5
CCCC          CPHI(ICPART)=CPHI(ICPART)+CTF*DX5-CLP*X6
13001     CONTINUE
          IF(IALFLG.EQ.2)CALL DETLPR(IE,ILIST)
          IF(MRDFLG.EQ.1)CALL READMO(IE)
          DO 13002 ICPART=1,NPART
          IF(.NOT.LOGPAR(ICPART))GOTO 13002
          X1=PART(ICPART,1)
          X3=PART(ICPART,3)
          X5=PART(ICPART,5)
          X2=PART(ICPART,2)
          X4=PART(ICPART,4)
          X6=PART(ICPART,6)
          CALL TRDRIF
          IF(MCHFLG.EQ.1) CALL MRESET
          PART(ICPART,1)=Y1
          PART(ICPART,3)=Y3
          PART(ICPART,5)=Y5
          PART(ICPART,2)=Y2
          PART(ICPART,4)=Y4
          PART(ICPART,6)=Y6
          DX5=Y5-X5
cccc          CPHI(ICPART)=CPHI(ICPART)+CTF*DX5-CLP*X6
13002     CONTINUE
          GOTO 13010
        ENDIF
      AL=ALENG(NEL)
      ALO2=0.5D0*AL
      CALL TRFDR
13010 GOTO 99888
18000 continue
C
C     HVcollimator not implemented as such yet
C
      goto 99888
C treating the cebaf type cavities
20000 CONTINUE
c added 1/18/95 to misalign cebaf cavities V
      mchflg=0
      if (misflg.eq.1) call mischk
c added 1/18/95 to misalign cebaf cavities A
20001 icurcav=icurcav+1
      if(icurcav.gt.icavtot) then
       write(iout,20101)
20101 format('  error in cebaf type cavities identification, ',/,
     >' this is a programming error. Job is stopped ')
      endif
      if(ipos(icurcav).lt.ie) goto 20001
          DO 20002 ICPART=1,NPART
          IF(.NOT.LOGPAR(ICPART))GOTO 20002
          X1=PART(ICPART,1)
          X3=PART(ICPART,3)
          X5=PART(ICPART,5)
          X2=PART(ICPART,2)
          X4=PART(ICPART,4)
          X6=PART(ICPART,6)
c added 1/18/95 to misalign cebaf cavities V
          if (mchflg.eq.1) call mset
c added 1/18/95 to misalign cebaf cavities A
      y1=cebmat(1,1,icurcav)*x1+cebmat(2,1,icurcav)*x2+
     >   cebmat(3,1,icurcav)*x3+cebmat(4,1,icurcav)*x4+
     >   cebmat(5,1,icurcav)*x5+cebmat(6,1,icurcav)*x6
      y2=cebmat(1,2,icurcav)*x1+cebmat(2,2,icurcav)*x2+
     >   cebmat(3,2,icurcav)*x3+cebmat(4,2,icurcav)*x4+
     >   cebmat(5,2,icurcav)*x5+cebmat(6,2,icurcav)*x6
      y3=cebmat(1,3,icurcav)*x1+cebmat(2,3,icurcav)*x2+
     >   cebmat(3,3,icurcav)*x3+cebmat(4,3,icurcav)*x4+
     >   cebmat(5,3,icurcav)*x5+cebmat(6,3,icurcav)*x6
      y4=cebmat(1,4,icurcav)*x1+cebmat(2,4,icurcav)*x2+
     >   cebmat(3,4,icurcav)*x3+cebmat(4,4,icurcav)*x4+
     >   cebmat(5,4,icurcav)*x5+cebmat(6,4,icurcav)*x6
      y5=cebmat(1,5,icurcav)*x1+cebmat(2,5,icurcav)*x2+
     >   cebmat(3,5,icurcav)*x3+cebmat(4,5,icurcav)*x4+
     >   cebmat(5,5,icurcav)*x5+cebmat(6,5,icurcav)*x6
      y6=cebmat(1,6,icurcav)*x1+cebmat(2,6,icurcav)*x2+
     >   cebmat(3,6,icurcav)*x3+cebmat(4,6,icurcav)*x4+
     >   cebmat(5,6,icurcav)*x5+cebmat(6,6,icurcav)*x6
c added 1/18/95 to misalign cebaf cavities V
          if (mchflg.eq.1) call mreset
c added 1/18/95 to misalign cebaf cavities A
          PART(ICPART,1)=Y1
          PART(ICPART,3)=Y3
          PART(ICPART,5)=Y5
          PART(ICPART,2)=Y2
          PART(ICPART,4)=Y4
          PART(ICPART,5)=Y5
          PART(ICPART,6)=Y6
20002     CONTINUE
99888 continue
      if(iblchk.eq.2) call blout
      IF(IFLMAT.NE.0)CALL RMAT(IE,ILIST)
      IF(NANAL.EQ.0)GO TO 63
      DO 64 IEN=1,NENER
      XCOR(NCTURN,IEN)=PART(IEN,1)
      XPCOR(NCTURN,IEN)=PART(IEN,2)
   64 CONTINUE
   63 IF (NJOB .EQ. 0) GO TO 62
      NCP = 1
      DO 61 IC = 1, NCASE
      XG (NCTURN,IC) = PART(NCP, 1) - XCO
      XPG(NCTURN,IC) = PART(NCP, 2) - XPCO
      IF (NJOB .EQ. 2) NCP = NCP + 1
      YG (NCTURN,IC) = PART(NCP, 3) - YCO
      YPG(NCTURN,IC) = PART(NCP, 4) - YPCO
      NCP=NCP+1
   61 CONTINUE
   62 CONTINUE
      IF(NCPART.EQ.0) THEN
        NCTURN=NTURN
        NXREQ=NTURN
      ENDIF
      IF(IREF.EQ.1)CALL PLPORB(IE,NEL,NELM)
      IF((MDPRT.EQ.-2).AND.(IFITD.NE.1))GOTO 76
      IF(MDPRT.EQ.0)GOTO75
      IF((MDPRT.LE.-1).AND.(IE.NE.NELM))GOTO76
      IF(IE.EQ.NELM)GOTO75
      CALL PRTTST(IE,ILIST,IPRT)
      IF(IPRT.NE.1)GOTO76
   75 CALL DETLPR(IE,ILIST)
   76 IF(NPRINT.EQ.0)CALL TRAKPR(0,IEP)
      IF(NPLOT.EQ.0) THEN
              NZERO=0
              NCCUM=1
              CALL PLOTPR(IEP,NZERO)
      ENDIF
C
C   PRINT AFTER N TURNS AT M LOCATIONS
C
   90 MODPR=1
      MODPL=1
      IF(NPRINT.GT.0)MODPR=MOD(NCTURN,NPRINT)
      IF(NPLOT.GT.0)MODPL=MOD(NCTURN,NPLOT)
      IF((MODPR.EQ.0).OR.(MODPL.EQ.0)) THEN
                  CALL PRTTST(IE,ILIST,IPRT)
                  IF(IPRT.EQ.1)THEN
                          IF(MODPR.EQ.0)CALL TRAKPR(0,IEP)
                          IF((MODPL.EQ.0).AND.(MLOCAT.NE.0)) THEN
                             NZERO=0
                             NCCUM=1
                             CALL PLOTPR(IEP,NZERO)
                           ENDIF
                   ENDIF
      ENDIF
      IF(IERSET.EQ.1)CALL ERESET(NEL,MATADR)
      IF(MONFLG.EQ.2)GOTO112
      IF(NCPART.NE.0) THEN
      ICHECK=(ITCHCK+(IE-ITRBEG+1))*NCPART-NCHECK
      IF(ICHECK.GE.100000) THEN
         WRITE(ISOUT,99110)IE,NCTURN
         NCHECK=NCHECK+100000
      ENDIF
99110 FORMAT('    AT ELEMENT ',I6,' DURING TURN ',I6)
      ENDIF
  110 CONTINUE
  112 IF((IALFLG.EQ.1).or.(intflg.eq.1))THEN
           IF(IXMSTP.NE.0) THEN
                 ISDBEG=IXS
                 IBGSTP=IXMSTP
                           ELSE
                 ISDBEG=IXS
           ENDIF
           IF(IXESTP.NE.0) THEN
                 IESBEG=IXES
                 IESTBG=IXESTP
                           ELSE
                 IESBEG=IXES
           ENDIF
           if(ixblstp.ne.0)then
            ibsbeg=ixbls
            ibstbg=ixblstp
                           else
            ibsbeg=ixbls
           endif
           IERBEG=IERSRT
      ENDIF
      IF(IALFLG.EQ.1)CALL DETLPR(ITREND,ILIST)
C
C   CHECK THE PLOT REQUESTED FOR THIS TURN
C
      IF(NCTURN.LT.NTURN) GO TO 300
      IF(((NPRINT.NE.-2).AND.(MLOCAT.EQ.0).AND.(NPRINT.NE.0))
     >.OR.(NPRINT.EQ.-1))
     >CALL TRAKPR(0,NELM)
  300 IF((NPLOT.LE.0).OR.(MLOCAT.NE.0)) GO TO 200
      IF(NCTURN.NE.NXREQ) GO TO 200
      NZERO = 1
      IF(NCTURN.EQ.NPLOT) NZERO = 0
      IF(NCCUM.EQ.1) NZERO = 0
      IF(NCTURN.EQ.LSTREQ) NCCUM = 1
      CALL PLOTPR(NELM,NZERO)
      NXREQ = NXREQ+NPLOT
  200 IF(NCTURN.LT.NTURN) GO TO 10
      RETURN
      END

c*********************************************************************
      SUBROUTINE TRAFCT(XI,XPI,YI,YPI,ALI,DELI,XO,XPO,YO,YPO,
     > ALO,DELO,IPART)
C
      IMPLICIT REAL*8 (A-H,O-Z), INTEGER (I-N)
C
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON/ARB/PARA(20),NT(MXPART),NARBP
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      dimension csrint(200)
      data (csrint(k),k=1,200) /
     & -0.1175687E-20, -0.3766249E-20, -0.1047312E-19, -0.2787077E-19,
     & -0.7265111E-19, -0.1868151E-18, -0.4749732E-18, -0.1194988E-17,
     & -0.2975912E-17, -0.7336409E-17, -0.1790484E-16, -0.4326003E-16,
     & -0.1034748E-15, -0.2450268E-15, -0.5744130E-15, -0.1333110E-14,
     & -0.3062940E-14, -0.6966922E-14, -0.1568820E-13, -0.3497309E-13,
     & -0.7718329E-13, -0.1686321E-12, -0.3647410E-12, -0.7810075E-12,
     & -0.1655586E-11, -0.3474348E-11, -0.7218040E-11, -0.1484530E-10,
     & -0.3022605E-10, -0.6092507E-10, -0.1215715E-09, -0.2401531E-09,
     & -0.4696388E-09, -0.9091976E-09, -0.1742490E-08, -0.3305969E-08,
     & -0.6209302E-08, -0.1154519E-07, -0.2125068E-07, -0.3872190E-07,
     & -0.6984755E-07, -0.1247255E-06, -0.2204790E-06, -0.3858212E-06,
     & -0.6683591E-06, -0.1146139E-05, -0.1945657E-05, -0.3269607E-05,
     & -0.5439049E-05, -0.8956670E-05, -0.1460038E-04, -0.2355993E-04,
     & -0.3763339E-04, -0.5950587E-04, -0.9313885E-04, -0.1443058E-03,
     & -0.2213175E-03, -0.3359877E-03, -0.5048979E-03, -0.7510221E-03,
     & -0.1105776E-02, -0.1611547E-02, -0.2324746E-02, -0.3319408E-02,
     & -0.4691299E-02, -0.6562478E-02, -0.9086133E-02, -0.1245147E-01,
     & -0.1688831E-01, -0.2267087E-01, -0.3012028E-01, -0.3960503E-01,
     & -0.5153864E-01, -0.6637384E-01, -0.8459240E-01, -0.1066901E+00,
     & -0.1331565E+00, -0.1644491E+00, -0.2009628E+00, -0.2429948E+00,
     & -0.2907073E+00, -0.3440889E+00, -0.4029179E+00, -0.4667305E+00,
     & -0.5347965E+00, -0.6061059E+00, -0.6793696E+00, -0.7530361E+00,
     & -0.8253252E+00, -0.8942799E+00, -0.9578346E+00, -0.1013897E+01,
     & -0.1060440E+01, -0.1095601E+01, -0.1117773E+01, -0.1125701E+01,
     & -0.1118550E+01, -0.1095965E+01, -0.1058102E+01, -0.1005635E+01,
     & -0.9397324E+00, -0.8620102E+00, -0.7744584E+00, -0.6793509E+00,
     & -0.5791405E+00, -0.4763489E+00, -0.3734567E+00, -0.2728015E+00,
     & -0.1764891E+00, -0.8632266E-01, -0.3752591E-02,  0.7015081E-01,
     &  0.1347033E+00,  0.1895926E+00,  0.2348469E+00,  0.2707908E+00,
     &  0.2979917E+00,  0.3172024E+00,  0.3293026E+00,  0.3352435E+00,
     &  0.3359980E+00,  0.3325188E+00,  0.3257046E+00,  0.3163758E+00,
     &  0.3052585E+00,  0.2929760E+00,  0.2800475E+00,  0.2668919E+00,
     &  0.2538349E+00,  0.2411195E+00,  0.2289172E+00,  0.2173398E+00,
     &  0.2064514E+00,  0.1962784E+00,  0.1868195E+00,  0.1780534E+00,
     &  0.1699454E+00,  0.1624529E+00,  0.1555292E+00,  0.1491266E+00,
     &  0.1431984E+00,  0.1377003E+00,  0.1325910E+00,  0.1278329E+00,
     &  0.1233919E+00,  0.1192377E+00,  0.1153431E+00,  0.1116841E+00,
     &  0.1082395E+00,  0.1049903E+00,  0.1019200E+00,  0.9901377E-01,
     &  0.9625839E-01,  0.9364216E-01,  0.9115459E-01,  0.8878626E-01,
     &  0.8652868E-01,  0.8437419E-01,  0.8231585E-01,  0.8034734E-01,
     &  0.7846290E-01,  0.7665729E-01,  0.7492567E-01,  0.7326363E-01,
     &  0.7166710E-01,  0.7013231E-01,  0.6865581E-01,  0.6723438E-01,
     &  0.6586505E-01,  0.6454504E-01,  0.6327180E-01,  0.6204292E-01,
     &  0.6085618E-01,  0.5970950E-01,  0.5860091E-01,  0.5752860E-01,
     &  0.5649086E-01,  0.5548609E-01,  0.5451278E-01,  0.5356950E-01,
     &  0.5265494E-01,  0.5176783E-01,  0.5090699E-01,  0.5007130E-01,
     &  0.4925971E-01,  0.4847123E-01,  0.4770490E-01,  0.4695984E-01,
     &  0.4623520E-01,  0.4553018E-01,  0.4484401E-01,  0.4417598E-01,
     &  0.4352540E-01,  0.4289162E-01,  0.4227401E-01,  0.4167198E-01,
     &  0.4108498E-01,  0.4051246E-01,  0.3995391E-01,  0.3940886E-01/
c
c above is table of longitudinal electric field (scaled) vs
c longitudinal offset. grid spacing is 0.1*sigmadl
c
c parameters for arbitrary element:
c
c para(1) - on/off; on if > 0, off if < 0
c para(2) - single bunch charge, in coulombs
c para(3) - bend radius in m
c para(4) - bend angle step size, degrees
c para(5) - beam energy, MeV
c
c added "memory" of bunch length and centroid  6-14-2014
c
c para(19) = dlave = centroid position
C para(20) = sigmadl = rms bunch length
c if first particle, get rms bunch length "sigmadl"
c
c     if (ipart.eq.1) write(iout,*) (para(k),k=1,5) 
      if (ipart.eq.1) then
      dlave=0.d0
      kpart=0
      do 1 k=1,npart
        if (logpar(k)) then
          kpart=kpart+1
          dlave=dlave+part(k,5)
        endif
    1 continue
      dlave=dlave/dfloat(kpart)
      para(19)=dlave
      sigsq=0.d0
      do 2 k=1,npart
        if (logpar(k)) then
          sigsq=sigsq+(part(k,5)-dlave)**2
        endif
    2 continue
      sigmadl=dsqrt(sigsq/dfloat(kpart))
      para(20)=sigmadl
      endif
c 
c scale dl0 and search for space on grid (csrint(1) is at -4.9 sigma,
c csrint(100) is at +5.0 sigma)
c
c modified 06-10-2014 to be observant in shifts in longitudinal
c position relative to reference particle
c     spos=-1.d0*ali/sigmadl
      dlave=para(19)
      sigmadl=para(20)
      spos=-1.d0*(ali-dlave)/sigmadl 
C      write(iout,*) ipart,'spos=',spos,'sigmadl=',sigmadl,para(1),
C     &para(2),para(3),para(4),para(5),para(19),para(20)
c
c note - minus sign due to fact that DIMAD has head of bunch at negative
c numbers, tail at positive, while R. Li has conventional head is positive
c tail is negative
c
c 6/20/2014 - superceded, see comment immediately above. Note as well 
c             that scan is now from -10 to +10 sigma
      posgrid=-10.0d0
      deltapos=0.1d0
      kgrid=1000
      do 3 k=1,200
      if ((spos.ge.posgrid).and.(spos.lt.(posgrid+deltapos))) then
         kgrid=k
         go to 4
      endif 
      if(kgrid.eq.1000) posgrid=posgrid+deltapos
    3 continue
    4 continue
      if (kgrid.eq.1000) then
      write(iout,*) ' particle ',ipart,' out of range in trafct ',spos
      return
      endif
C      write(iout,*) ipart,kgrid
c
c interpolate for field value "valcsr"
c
      if (kgrid.eq.1) then 
      valcsr = csrint(1)-((csrint(2)-csrint(1))/(0.1d0))*(-9.9d0-spos)
      else
      valcsr = csrint(kgrid-1) 
     & + ((csrint(kgrid)-csrint(kgrid-1))/(0.1d0))*(spos-posgrid)
      endif
C      write(iout,*) ipart,valcsr
c 
c get energy kick
c
      if (para(1).gt.0) then
C      write(iout,*) ipart,valcsr,para(2),para(3),para(4),para(5),
C     &crdeg,twopi,sigmadl
C      rt3para3=para(3)**(1.d0/3.d0)
C      rt43sigz=sigmadl**(4.d0/3.d0)
C      checkde=(86.899949*para(2)*rt3para3*para(4))/(rt43sigz*para(5))
C      write(iout,*)rt3para3,rt43sigz,checkde
c23456789x123456789x123456789x123456789x123456789x123456789x123456789x
      deone=(86.899949*para(2)*(para(3)**(1.d0/3.d0))*para(4)*valcsr)/
     &((sigmadl**(4.d0/3.d0))*para(5))
c     deone=(18000*para(2)*(para(3)**(1/3))*(para(4)*crdeg)*valcsr)
c    &                            /
c    &((3.d0**(1.d0/3.d0))*dsqrt(twopi)*(sigmadl**(4.d0/3.d0))*para(5))

      else
      deone=0.d0
      endif
c
c push particle
c
C      write(iout,*) ipart,valcsr,deone
      xo  =xi
      xpo =xpi 
      yo  =yi
      ypo =ypi
      alo =ali
      delo=deli+deone
      RETURN
      END
C     ************************
      SUBROUTINE TRAKPR(ICODE,IE)
C     ************************
      IMPLICIT REAL*8 (A-H,O-Z)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      COMMON/CAV/FREQ,ALC,AML,CAVPHI,DEOVE,CPHI(MXPART),
     >PINGAM,PBETA,PCLENG,DTN,DAML,DTNA(MXPART),
     >CTF,CLP,DPHI,F0CAV,F1CAV,PERCAV,APHIAD,ICOPT,IAML,
     >N0CAV,N1CAV,INCAV
C
C   WHAT KIND OF PRINTING?
C
        NEL = NORLST(IE)
      IF(ICODE)10,30,30
C
C   INITIAL POSITIONS PRINTING
C
10    IF(NOUT.LT.4) THEN
           WRITE(IOUT,10301)
10301 FORMAT(//,' INITIAL POSITIONS OF PARTICLES ',/)
           DO 20 I=1,NPART
           IF(.NOT.LOGPAR(I)) GO TO 20
           WRITE(IOUT,10300)I,(PART(I,K),K=1,6)
c10300 FORMAT(1x,I4,6(E14.5))
10300 FORMAT(1x,I6,1x,6(E14.5))
20         CONTINUE
                   ELSE
           IF(NOUT.EQ.4) THEN
           DO 22 I=1,NPART
           IF(.NOT.LOGPAR(I)) GO TO 22
           WRITE(IOUT,10320)NCTURN,(NAME(IN,NEL),IN=1,8)
     >,I,(PART(I,K),K=1,6)
22         CONTINUE
           ENDIF
10320 FORMAT(I6,1x,8A1,I6,1x,6(E13.5))
c10320 FORMAT(I4,8A1,I4,6(E17.9))
      ENDIF
      RETURN
C
C   OTHER PRINTING
C
30    IF(NOUT.LT.4) THEN
            WRITE(IOUT,10302)IE,(NAME(IZ,NEL),IZ=1,8),NCTURN
10302 FORMAT(/,' PARTICLE POSITIONS AFTER ELEMENT',2X,I6,'(',8A1,')',
     >  2X,'DURING TURN',I6,/)
             DO 40 I=1,NPART
             IF(.NOT.LOGPAR(I)) GO TO 40
             WRITE(IOUT,10300) I,(PART(I,K),K=1,6)
40           CONTINUE
                     ELSE
           IF(NOUT.EQ.4) THEN
           DO 42 I=1,NPART
           IF(.NOT.LOGPAR(I)) GO TO 42
           WRITE(IOUT,10320)NCTURN,(NAME(IN,NEL),IN=1,8)
     >,I,(PART(I,K),K=1,6)
42         CONTINUE
           ENDIF
           IF(NOUT.EQ.14) THEN
           DO 23 I=1,NPART
           IF(.NOT.LOGPAR(I)) GO TO 23
           WRITE(IOUT,10321)NCTURN,I,(PART(I,K),K=1,4),
     >     CPHI(I),PART(I,6)
c10321 FORMAT(I4,I4,6(E13.5))
c10321 FORMAT(I4,I4,6(E17.9))
10321 FORMAT(I7,I7,1x,6(E13.5))
23         CONTINUE
           ENDIF
      ENDIF
      RETURN
      END
C     ***********************
      subroutine trapre(iend)
C     ***********************
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      PARAMETER    (mxpart = 128000)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      COMMON/PLT/
     1XMIN,XMAX,YMIN,YMAX,XPMIN,XPMAX,YPMIN,YPMAX,ALMIN,ALMAX,
     >DELMIN,DELMAX,DNUMIN,DNUMAX,DBMIN,DBMAX,
     2MALL,NPLOT,NCCUM,NGRAPH,NCOL,NLINE
      common/cprt/prnam(8,10),kodprt(2),
     >   iprtfl,intfl,itypfl,namfl,inam,itkod
      character*1 prnam
      PARAMETER    (MXLIST = 40)
      COMMON/MAT/TEMP(6,27),NORDER,MPRINT,IMAT,NMAT,IFITE(2),NELM,NOP,
     <NLIST(2*MXLIST)
C
C   PARTICLE TRACING OPERATION, GET PARAMETERS
C
      NOP=4
      NCHAR=0
      NIPR=1
      CALL INPUT(ICHAR,NCHAR,DATA,MXINP,IEND,NOP,NIPR)
      NPLOT=DATA(1)
      NPRINT=DATA(2)
      NATURN=DATA(4)
C
C   NOPA - NUMBER OF PARTICLES ADDED
C
      NOPA=0
      IF(DATA(3))3010,3030,3020
C
C   NEGATIVE NPART, NPART PARTICLES ARE ADDED
C
3010  NOPA=DABS(DATA(3))
      NTURN=NTURN+NATURN
C
C   GET PARTICLE DATA FOR NEW PARTICLES
C
      DO 315 I=1,NOPA
      I1=NPART+I
      NOP=6
      CALL INPUT(ICHAR,NCHAR,DATA,MXINP,IEND,NOP,NIPR)
      PART(I1,1)=DATA(1)
      PART(I1,2)=DATA(2)
      PART(I1,3)=DATA(3)
      PART(I1,4)=DATA(4)
      PART(I1,5)=DATA(5)
      PART(I1,6)=DATA(6)
      DEL(I1)=DATA(6)
315   CONTINUE
      NPART=NPART+NOPA
      NCPART=NCPART+NOPA
      GO TO 3040
C
C   POSITIVE NPART, OLD PARTICLES DELETED, NPART PARTICLES ADDED
C
3020  NPART=DATA(3)
      NCTURN=0
      NTURN=NATURN
      DO 3022 I=1,MXPART
3022  LOGPAR(I)=.TRUE.
      NCPART=NPART
      DO 3025 I=1,NPART
      NOP=6
      CALL INPUT(ICHAR,NCHAR,DATA,MXINP,IEND,NOP,NIPR)
      PART(I,1)=DATA(1)
      PART(I,2)=DATA(2)
      PART(I,3)=DATA(3)
      PART(I,4)=DATA(4)
      PART(I,5)=DATA(5)
      PART(I,6)=DATA(6)
      DEL(I)=DATA(6)
3025  CONTINUE
      GO TO 3040
C
C   NPART=0, EXISTING PARTICLES KEPT, NONE ADDED
C
3030  CONTINUE
      NTURN=NTURN+NATURN
      if((nplot.le.-1).and.(nprint.le.-2)) goto 3006
C
C   PLOTTING PARAMETERS
C
 3040 NTENT = 1
      NOP=-1
      CALL INPUT(ICHAR,NCHAR,DATA,MXINP,IEND,NOP,NIPR)
      IF((NPRINT.LE.0).OR.(NPLOT.GT.0)) THEN
               NTENT = NTENT+2*DATA(NTENT)+1
      ENDIF
 3070 IF(NPLOT.LT.0) GO TO 3050
C
C   SET UP PARAMETERS
C
      NGRAPH = DATA(NTENT)
      XMIN = DATA(NTENT+1)
      XMAX = DATA(NTENT+2)
      XPMIN = DATA(NTENT+3)
      XPMAX = DATA(NTENT+4)
      YMIN = DATA(NTENT+5)
      YMAX = DATA(NTENT+6)
      YPMIN = DATA(NTENT+7)
      YPMAX = DATA(NTENT+8)
      ALMIN = DATA(NTENT+11)
      ALMAX = DATA(NTENT+12)
      DELMIN = DATA(NTENT+13)
      DELMAX = DATA(NTENT+14)
      NCOL = DATA(NTENT+9)
      NLINE = DATA(NTENT+10)
      IF((NCOL.GT.0.AND.NCOL.LT.102). AND .
     +           (NLINE.GT.0.AND.NLINE.LT.52)) GO TO 3060
      WRITE(IOUT,10310)
10310 FORMAT(' ERROR IN NUMBER OF LINES OR COLUMNS: DEFAULT VALUES'
     +         ,'USED: 101,51')
      NCOL = 101
      NLINE = 51
      GO TO 3060
C
C   SET PARAMETERS FOR NO PLOTTING
C
 3050 XMIN = 0.0
      XMAX = 0.0
      XPMIN = 0.0
      XPMAX = 0.0
      YMIN = 0.0
      YMAX = 0.0
      YPMIN = 0.0
      YPMAX = 0.0
      NCOL = 0
      NLINE = 0
C
C   DETERMINE MODE OF PLOTTING
C
 3060 MALL = 1
      NCCUM = 1
      IF(NGRAPH.GT.10) NCCUM = 0
      IF(NGRAPH.GT.10) NGRAPH = NGRAPH-10
      IF((NGRAPH.EQ.4).OR.(NGRAPH.EQ.7)) MALL = 0
      IF(NGRAPH.EQ.7)NGRAPH=6
C
C   PRINTING PARAMETERS
C
      IF((NPRINT.GT.0).OR.(NPLOT.GT.0)) THEN
             if(iprtfl.ne.1) then
               MLOCAT=DATA(1)
               IF(MLOCAT.NE.0) THEN
                 IF(MLOCAT.GT.MXLIST) THEN
                       WRITE(IOUT,30301)MLOCAT
30301 FORMAT(' **** TOO MANY INTERVALS ',I4,/,
     >' CHANGE MXLIST PARAMETER TO VALUE NEEDED')
                       CALL HALT(2)
                 ENDIF
                 DO 3005 JM=1,MLOCAT
                 INDJM=2*JM
                 NLIST(INDJM-1)=DATA(INDJM)
                 NLIST(INDJM)=DATA(INDJM+1)
3005             CONTINUE
               ENDIF
             endif
      ENDIF
3006  CALL TRACKT
      IF(NCPART.NE.0) return
      WRITE(IOUT,10066)
      IF(ISO.NE.0)WRITE(ISOUT,10066)
10066 FORMAT('  WARNING--RUN STOPPED DUE TO LOSS OF PARTICLES')
      CALL HALT(302)
      return
      end
C     ***********************
      SUBROUTINE TRDRIF
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
       COMMON/V/AL,ALO2,VV(27),X1,X2,X3,X4,X5,X6,Y1,Y2,Y3,Y4,Y5,Y6
      COMMON/SYM/ENERLI,GAMMLI,BETALI,bili,b2li,b2ili,
     >ISYOPT,ISYFLG,MATTOT,KANVAR
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXMAT = 500)
      COMMON /SYMMAP/ BSYMAT(6,6,MAXMAT),CSYMAT(6,27,MAXMAT)
      DIMENSION ZI(6),ZF(6)
C
C        IF (ISYFLG.EQ.1)THEN   DISABLE THIS - ISYFLG IS FLAG ON
C                               MATRICES, NOT VARIABLES
         IF (KANVAR.EQ.1)      THEN
C
C  IN THIS CASE, INTERNAL VARIABLES ARE CANONICAL (KANVAR = 1)
C  AND MUST BE SWITCHED TO GEOMETRIC VARIABLES BEFORE DOING RAY TRACE
C
                         CALL NCVAR(X1,ZI,GAMMLI,BETALI)
                         ZF(1)=ZI(2)*AL+ZI(1)
                         ZF(2)=ZI(2)
                         ZF(3)=ZI(4)*AL+ZI(3)
                         ZF(4)=ZI(4)
                         ZF(5)=ALO2*(ZI(2)*ZI(2)+ZI(4)*ZI(4))+ZI(5)
                         ZF(6)=ZI(6)
                         CALL CVAR(ZF,Y1,GAMMLI,BETALI)
                               ELSE
C
C  IN THIS CASE, EITHER ISYFLG=0 (NO SYMPLECTIFICATION) OR THINGS ARE
C  SYMPLECTIFIED BUT ISYOPT=1 OR 3, SO THAT INTERNAL VARIABLES ARE THE
C  GEOMETRIC VARIABLES (KANVAR = 0).  JUST DO THE RAY TRACE
C
                         Y1=X2*AL+X1
                         Y2=X2
                         Y3=X4*AL+X3
                         Y4=X4
                         Y5=ALO2*(X2*X2+X4*X4)+X5
                         Y6=X6
         END IF
      RETURN
      END
      SUBROUTINE TRFDR
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      PARAMETER    (mxpart = 128000)
       COMMON/V/AL,ALO2,VV(27),X1,X2,X3,X4,X5,X6,Y1,Y2,Y3,Y4,Y5,Y6
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/SYM/ENERLI,GAMMLI,BETALI,bili,b2li,b2ili,
     >ISYOPT,ISYFLG,MATTOT,KANVAR
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      COMMON/CAV/FREQ,ALC,AML,CAVPHI,DEOVE,CPHI(MXPART),
     >PINGAM,PBETA,PCLENG,DTN,DAML,DTNA(MXPART),
     >CTF,CLP,DPHI,F0CAV,F1CAV,PERCAV,APHIAD,ICOPT,IAML,
     >N0CAV,N1CAV,INCAV
      DO 13003 ICPART=1,NPART
      IF(.NOT.LOGPAR(ICPART))GOTO 13003
      X1=PART(ICPART,1)
      X3=PART(ICPART,3)
      X5=PART(ICPART,5)
      X2=PART(ICPART,2)
      X4=PART(ICPART,4)
C
      X6=PART(ICPART,6)
C                           MUST DO ENERGY DEVIATION ALSO - SO THAT
C                           TRANSFORMATION FROM CANONICAL TO GEOMETRIC
C                           VARIABLES IS POSSIBLE
      CALL TRDRIF
      DX5=Y5-X5
cccc      CPHI(ICPART)=CPHI(ICPART)+CTF*DX5-CLP*X6
      PART(ICPART,1)=Y1
      PART(ICPART,3)=Y3
      PART(ICPART,5)=Y5
C      IF(ISYFLG.EQ.1) THEN   DISABLE - THIS IS REDUNDANT, AS
C       PART(ICPART,2)=Y2     DRIFT DOES NOT CHANGE MOMENTA IN
C       PART(ICPART,4)=Y4     ANY EVENT
C      ENDIF
13003     CONTINUE
      RETURN
      END
      SUBROUTINE TRMAT(MATADR,ICPART)
C     *******************************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      PARAMETER    (mxpart = 128000)
       COMMON/V/AL,ALO2,VV(27),X1,X2,X3,X4,X5,X6,Y1,Y2,Y3,Y4,Y5,Y6
      COMMON/CTRMAT/ AM1(27),AM2(27),AM3(27),AM4(27),AM5(27),AM6(27),
     >ZI(6),ZF(6),NEL,IMSAV,
     >M1(27),M2(27),M3(27),M4(27),M5(27),M6(27),N1,N2,N3,N4,N5,N6
      COMMON/SYM/ENERLI,GAMMLI,BETALI,bili,b2li,b2ili,
     >ISYOPT,ISYFLG,MATTOT,KANVAR
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/CAV/FREQ,ALC,AML,CAVPHI,DEOVE,CPHI(MXPART),
     >PINGAM,PBETA,PCLENG,DTN,DAML,DTNA(MXPART),
     >CTF,CLP,DPHI,F0CAV,F1CAV,PERCAV,APHIAD,ICOPT,IAML,
     >N0CAV,N1CAV,INCAV
      DIMENSION Y(6)
      EQUIVALENCE (Y(1),Y1)
      IF(ISYOPT.LT.1) THEN
           IF (IMSAV.EQ.0) THEN
                                     CALL COMPL
                                     DO 50 IM=1,6
                                       SUM=0.0D0
                                       DO 51 JM=1,27
                                         AMIJ=AMAT(JM,IM,MATADR)
                                         IF (AMIJ.EQ.0D0)GOTO 51
                                         SUM=SUM+AMIJ*VV(JM)
   51                                  CONTINUE
   50                                Y(IM)=SUM
                           ELSE
      CALL COMPL
      SUM=0.0D0
      DO 211 JM=1,N1
  211 SUM = SUM + AM1(JM)*VV(M1(JM))
      Y1=SUM
      SUM=0.0D0
      DO 212 JM=1,N2
  212 SUM = SUM + AM2(JM)*VV(M2(JM))
      Y2=SUM
      SUM=0.0D0
      DO 213 JM=1,N3
  213 SUM = SUM + AM3(JM)*VV(M3(JM))
      Y3=SUM
      SUM=0.0D0
      DO 214 JM=1,N4
  214 SUM = SUM + AM4(JM)*VV(M4(JM))
      Y4=SUM
      SUM=0.0D0
      DO 215 JM=1,N5
  215 SUM = SUM + AM5(JM)*VV(M5(JM))
      Y5=SUM
      SUM=0.0D0
      DO 216 JM=1,N6
  216 SUM = SUM + AM6(JM)*VV(M6(JM))
      Y6=SUM
           ENDIF
                      ELSE
           IF(KANVAR.EQ.0) THEN
                                       CALL CVAR(X1,ZI,GAMMLI,BETALI)
                                       IF(ISYOPT.EQ.1) THEN
                                    CALL SYMRTX(icpart,MATADR,ZI,ZF)
                                                       ELSE
                                    CALL SYMRAT(icpart,MATADR,ZI,ZF)
                                       END IF
                                       CALL NCVAR(ZF,Y1,GAMMLI,BETALI)
                         ELSE
                                       IF (ISYOPT.EQ.2) THEN
                                     CALL SYMRTX(icpart,MATADR,X1,Y1)
                                                        ELSE
                                     CALL SYMRAT(icpart,MATADR,X1,Y1)
                                       END IF
           END IF
C
C REPLACED (2/7/86)
C
C        IF(ISYOPT.EQ.1) THEN
C                                    CALL CVAR(X1,ZI,GAMMLI,BETALI)
C                                    CALL SYMRTX(icpart,MATADR,ZI,ZF)
C                                    CALL NCVAR(ZF,Y1,GAMMLI,BETALI)
C                        ELSE
C           IF(ISYOPT.EQ.2) THEN
C                                    CALL SYMRTX(icpart,MATADR,X1,Y1)
C                           ELSE
C              IF(ISYOPT.EQ.3) THEN
C                                    CALL CVAR(X1,ZI,GAMMLI,BETALI)
C                                    CALL SYMRAT(icpart,MATADR,ZI,ZF)
C                                    CALL NCVAR(ZF,Y1,GAMMLI,BETALI)
C                              ELSE
C                 IF(ISYOPT.GT.3)    CALL SYMRAT(icpart,MATADR,X1,Y1)
C              END IF
C           END IF
C        END IF
      END IF
      RETURN
      END
      SUBROUTINE TRSAV(MATADR)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      PARAMETER    (mxpart = 128000)
       COMMON/V/AL,ALO2,VV(27),X1,X2,X3,X4,X5,X6,Y1,Y2,Y3,Y4,Y5,Y6
      COMMON/CTRMAT/ AM1(27),AM2(27),AM3(27),AM4(27),AM5(27),AM6(27),
     >ZI(6),ZF(6),NEL,IMSAV,
     >M1(27),M2(27),M3(27),M4(27),M5(27),M6(27),N1,N2,N3,N4,N5,N6
      COMMON/SYM/ENERLI,GAMMLI,BETALI,bili,b2li,b2ili,
     >ISYOPT,ISYFLG,MATTOT,KANVAR
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON /SYMMAP/ BSYMAT(6,6,MAXMAT),CSYMAT(6,27,MAXMAT)
      common /ctrsym/
     >bs11,bs12,bs13,bs14,bs15,bs16,bs21,bs22,bs23,bs24,bs25,bs26,
     >bs31,bs32,bs33,bs34,bs35,bs36,bs41,bs42,bs43,bs44,bs45,bs46,
     >bs51,bs52,bs53,bs54,bs55,bs56,
     >cs17,cs18,cs19,cs110,cs111,cs112,cs113,cs114,cs115,cs116,cs117,
     >cs118,cs119,cs120,cs121,cs122,cs123,cs124,cs125,cs126,cs127,
     >cs27,cs28,cs29,cs210,cs211,cs212,cs213,cs214,cs215,cs216,cs217,
     >cs218,cs219,cs220,cs221,cs222,cs223,cs224,cs225,cs226,cs227,
     >cs37,cs38,cs39,cs310,cs311,cs312,cs313,cs314,cs315,cs316,cs317,
     >cs318,cs319,cs320,cs321,cs322,cs323,cs324,cs325,cs326,cs327,
     >cs47,cs48,cs49,cs410,cs411,cs412,cs413,cs414,cs415,cs416,cs417,
     >cs418,cs419,cs420,cs421,cs422,cs423,cs424,cs425,cs426,cs427,
     >cs57,cs58,cs59,cs510,cs511,cs512,cs513,cs514,cs515,cs516,cs517,
     >cs518,cs519,cs520,cs521,cs522,cs523,cs524,cs525,cs526,cs527,
     >isysav
      dimension bsy(6,5),csy(21,5)
      equivalence(bsy(1,1),bs11),(csy(1,1),cs17)
      if(isyopt.lt.1) then
      IJM=1
      DO 202 JM=1,27
      AMIJ=AMAT(JM,1,MATADR)
      IF(AMIJ.NE.0.0D0)THEN
             M1(IJM)=JM
             AM1(IJM)=AMIJ
             IJM=IJM+1
      ENDIF
  202 CONTINUE
      N1=IJM-1
      IJM=1
      DO 203 JM=1,27
      AMIJ=AMAT(JM,2,MATADR)
      IF(AMIJ.NE.0.0D0)THEN
             M2(IJM)=JM
             AM2(IJM)=AMIJ
             IJM=IJM+1
      ENDIF
  203 CONTINUE
      N2=IJM-1
      IJM=1
      DO 204 JM=1,27
      AMIJ=AMAT(JM,3,MATADR)
      IF(AMIJ.NE.0.0D0)THEN
             M3(IJM)=JM
             AM3(IJM)=AMIJ
             IJM=IJM+1
      ENDIF
  204 CONTINUE
      N3=IJM-1
      IJM=1
      DO 205 JM=1,27
      AMIJ=AMAT(JM,4,MATADR)
      IF(AMIJ.NE.0.0D0)THEN
             M4(IJM)=JM
             AM4(IJM)=AMIJ
             IJM=IJM+1
      ENDIF
  205 CONTINUE
      N4=IJM-1
      IJM=1
      DO 206 JM=1,27
      AMIJ=AMAT(JM,5,MATADR)
      IF(AMIJ.NE.0.0D0)THEN
             M5(IJM)=JM
             AM5(IJM)=AMIJ
             IJM=IJM+1
      ENDIF
  206 CONTINUE
      N5=IJM-1
      IJM=1
      DO 207 JM=1,27
      AMIJ=AMAT(JM,6,MATADR)
      IF(AMIJ.NE.0.0D0)THEN
             M6(IJM)=JM
             AM6(IJM)=AMIJ
             IJM=IJM+1
      ENDIF
  207 CONTINUE
      N6=IJM-1
                      else
      do 301 ibs=1,5
      do 301 jbs=1,6
  301 bsy(jbs,ibs)=bsymat(ibs,jbs,matadr)
      do 302 ibs=1,5
      do 302 jbs=1,21
  302 csy(jbs,ibs)=csymat(ibs,jbs+6,matadr)
      isysav=1
      endif
      RETURN
      END
C     *************************
      SUBROUTINE TUNE(IEND)
C     *************************
      IMPLICIT REAL*8(A-H,O-Z), INTEGER (I-N)
      PARAMETER    (mxpart = 128000)
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/LNGTH/TLENG,ALENG(MXELMD),ACLENG(MAXPOS)
      COMMON/CSEEDS/ISEED,IXG,IXS,IXMSTP,IMSD,IMOSTP,ISYNSD,ISYSTP,
     >ISDBEG,IBGSTP,IXES,IXESTP,IESBEG,IESTBG,isdcol
C CINTAK : COMMON CONTAINING ARRAYS NEEDED FOR INPUT
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      COMMON /CTUNE/DNU0X,DNU0Y,DBETX,DBETY,DALPHX,DALPHY,
     >DXCO,DXPCO,DYCO,DYPCO,DDELCO
      CHARACTER*1 ICHAR
      NCHAR=0
      NDATA=1
      NIPR=1
      CALL INPUT(ICHAR,NCHAR,DATA,MXINP,IEND,NDATA,NIPR)
      IOPT=DATA(1)
      NCHAR=8
      NDATA=0
      CALL INPUT(ICHAR,NCHAR,DATA,MXINP,IEND,NDATA,NIPR)
      CALL ELID(ICHAR,NELID)
      CALL INPUT(ICHAR,NCHAR,DATA,MXINP,IEND,NDATA,NIPR)
      CALL DIMPAR(NELID,ICHAR,NPAR)
      NCHAR=0
      NDATA=2
      CALL INPUT(ICHAR,NCHAR,DATA,MXINP,IEND,NDATA,NIPR)
      DNUX=DATA(1)
      FACTOR=DATA(2)
      IAD=IADR(NELID)
      ELDAT(IAD+NPAR-1)=ELDAT(IAD+NPAR-1)+FACTOR*(DNUX-DNU0X)
      call matgen(nelid)
      IF(NOUT.GE.3)
     >WRITE(IOUT,99999)DNU0X,DNU0Y,DNUX,ELDAT(IAD+NPAR-1)
99999 FORMAT(' ',4E16.5)
      IADP1=IADR(NELID+1)
      RETURN
      END
      SUBROUTINE TVBGN(IUNIT)
C-----DUMMY ROUTINE FOR TV
      RETURN
      END
      SUBROUTINE TVEND
C-----DUMMY ROUTINE FOR TV
      RETURN
      END
      SUBROUTINE TVRNG(A,B,C,D,E)
C-----DUMMY ROUTINE FOR TV
      RETURN
      END

      subroutine twan(kod,ikod,iend)
C     *****************************
      IMPLICIT REAL*8 (A-H,O-Z)
      PARAMETER    (MXINP = 100)
      COMMON/CINTAK/DATA(MXINP),ICHAR(8)
      CHARACTER*1 ICHAR
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      COMMON/TRI/WCO(15,6),GEN(5,4),PGEN(75,6),DIST,
     <A1(15),B1(15),A2(15),B2(15),XCOR(3,15),XPCOR(3,15),
     1AL1(15),AL2(15),MESH,NIT,NENER,NITX,NITS,NITM1,NANAL,NOPRT
      COMMON/PLT/
     1XMIN,XMAX,YMIN,YMAX,XPMIN,XPMAX,YPMIN,YPMAX,ALMIN,ALMAX,
     >DELMIN,DELMAX,DNUMIN,DNUMAX,DBMIN,DBMAX,
     2MALL,NPLOT,NCCUM,NGRAPH,NCOL,NLINE
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      PARAMETER    (mxpart = 128000)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/TRACE/PART(MXPART,6),DEL(MXPART),NPART,NCPART,NPRINT,
     <  NCTURN,MLOCAT,NTURN
      COMMON/CLSQ/ALSQ(15,2,4),IXY,NCOEF,NAPLT,JENER,LENER(15)
      logical lener
      NOP=-1
      NCHAR=0
      NIPR=1
      CALL INPUT(ICHAR,NCHAR,DATA,MXINP,IEND,NOP,NIPR)
      NTURN=DATA(2)
      NOPRT=DATA(1)
      NPLOT=-2
      NPRINT=-2
      MLOCAT=0
      DO 3 I=1,MXPART
 3    LOGPAR(I)=.TRUE.
      DO 214 ILE=1,15
  214 LENER(ILE)=.TRUE.
      NANAL=DATA(3)
      NITS=DATA(4)-.1
      NIT=DABS(DATA(4))+.1
      NITM1=NIT-1
      NENER=DATA(5)+.01
      IF(NENER.GT.15)GO TO 221
      NCOEF=DATA(6)
      IF(NCOEF.GT.9)GO TO 222
      GO TO 223
  221 WRITE(IOUT,10004)
      IF(ISO.NE.0)WRITE(ISOUT,10004)
      return
10004 FORMAT(' *****TOO MANY ENERGIES:OPERATION STOPPED******')
  222 WRITE(IOUT,10005)
      IF(ISO.NE.0)WRITE(ISOUT,10005)
10005 FORMAT(' *TOO MANY COEFS REQUESTED:VALUE DEFAULTED TO 9***')
      NCOEF=9
  223 DIST=DATA(7)
      DO 42 I=1,NENER
      DO 208 J=1,5
  208 WCO(I,J)=DATA(7+J)
   42 WCO(I,6)=DATA(12+I)
      NAPLT = DATA(13+NENER)
      DELMIN = DATA(14+NENER)
      DELMAX = DATA(15+NENER)
      DNUMIN = DATA(16+NENER)
      DNUMAX = DATA(17+NENER)
      DBMIN = DATA(18+NENER)
      DBMAX = DATA(19+NENER)
      NCOL = DATA(20+NENER)
      NLINE = DATA(21+NENER)
      NITX=0
      CALL ENANAL
      NANAL=0
      return
      end
C     ***********************
      SUBROUTINE TWISS(IELM,MATADR)
C     ***********************
      IMPLICIT REAL*8(A-H,O-Z),INTEGER(I-N)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      COMMON/CONST/PI,TWOPI,CRDEG,CMAGEN,CLIGHT,EMASS,ERAD,ECHG
     >,TOLLSQ,ETAFAC,SIGFAC,MAXFAC,IPTYP
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      COMMON/CHINP/NAME(8,MXELMD),LABEL(14,MXELMD)
      CHARACTER*1 NAME,LABEL
      COMMON/PRODCT/KODEPR,NEL,NOF
      IAD=IADR(IELM)
C
C     CLEAR AMAT(27,6,MATADR)
C
      DO 10 I=1,6
      DO 10 J=1,NOF
      AMAT(J,I,MATADR)=0.0D0
      IF(I.EQ.J) AMAT(J,I,MATADR)=1.0D0
10    CONTINUE
      IF(KUNITS.EQ.2) THEN
        ANG=ELDAT(IAD+1)*CRDEG
      ELSE
        ANG = ELDAT(IAD+1)
      ENDIF
      CH=DCOS(ANG)
      SH=DSIN(ANG)
      IF(KUNITS.EQ.2) THEN
        ANG=ELDAT(IAD+4)*CRDEG
      ELSE
        ANG = ELDAT(IAD+4)
      ENDIF
      CV=DCOS(ANG)
      SV=DSIN(ANG)
      AMAT(1,1,MATADR)=CH+ELDAT(IAD+3)*SH
      AMAT(2,1,MATADR)=SH*ELDAT(IAD+2)
      AMAT(1,2,MATADR)=-(1.0+ELDAT(IAD+3)*ELDAT(IAD+3))*SH/ELDAT(IAD+2)
      AMAT(2,2,MATADR)=CH-ELDAT(IAD+3)*SH
      AMAT(3,3,MATADR)=CV+ELDAT(IAD+6)*SV
      AMAT(4,3,MATADR)=SV*ELDAT(IAD+5)
      AMAT(3,4,MATADR)=-(1.0D0+ELDAT(IAD+6)*ELDAT(IAD+6))*SV
     >       /ELDAT(IAD+5)
      AMAT(4,4,MATADR)=CV-ELDAT(IAD+6)*SV
      RETURN
      END
C     ***********************
C        THE FOLLOWING IS A REASONABLE PORTABLE GENERATOR
C        IF YOU HAVE ANY DOUBTS ABOUT IT CAN BE REPLACED
C        BY ONE OF THE FOLLOWING AS THE CASE MAY BE
ccC  **********************
      FUNCTION URAND(IX)
ccC  **********************
      IMPLICIT REAL*8(A-H,O-Z)
      DATA M2/0/,ITWO/2/
      IF(M2.NE.0)GOTO 20
C     M2=262144
      M2=524288
      HALFM=DFLOAT(M2)
      IA=8*IDINT(HALFM*DATAN(1.0D0)/8.0D0) + 5
      IC=2*IDINT(HALFM*(0.5D0-DSQRT(3.0D0)/6.0D0))+1
      M=M2*ITWO
   20 IX=MOD(IX,M)
      IX=IX*IA+IC
      IX=MOD(IX,M)
      IF(IX.LT.0.0D0)IX=IX+M
      URAND=DFLOAT(IX)/M
      RETURN
      END
C        THE FOLLOWING FUNCTION SHOULD BE USED FOR THE VAX COMPUTER
C        using "some" unix system and Decstation under Ultrix
C  **********************
c
cC  **********************
c       IMPLICIT REAL*8(A-H,O-Z)
c       real fr,ran
c       fr=ran(ix)
c       URAND=fr
c       RETURN
c       END
C        THE FOLLOWING FUNCTION SHOULD BE USED FOR THE VAX COMPUTER
C  **********************
c      FUNCTION URAND(IX)
C  **********************
c      IMPLICIT REAL*8(A-H,O-Z)
c      URAND=RAN(IX)
c      RETURN
c      END
C        THE FOLLOWING IS A VERY VERY SLOW GENERATOR AVAILABLE ON THE
C        SUN COMPUTER
C  **********************
C     FUNCTION URAND(IX)
C  **********************
C     IMPLICIT REAL*8(A-H,O-Z)
C     URAND=DRAND(IX)
C     IX=URAND*1.0D08
C     RETURN
C     END
C  **********************
C  USE FOLLOWING URAND FOR VAX RUNNING "some other" UNIX system
C  **********************
c      FUNCTION URAND(IX)
C  **********************
c      IMPLICIT REAL*8(A-H,O-Z)
c      IX=IRAND(IX)
c      URAND = IX/2147483647.0
c      IF (URAND.GT.1.0D0) WRITE(6,10) IX
c 10    FORMAT('  RANDMAX IS WRONG PLEASE CORRECT :', I12)
c      RETURN
c      END
C  **********************
C  USE FOLLOWING URAND FOR IBM
C  **********************
c     FUNCTION URAND(IX)
C  **********************
c     IMPLICIT REAL*8(A-H,O-Z)
c     DATA M2/0/,ITWO/2/
c     IF(M2.NE.0)GOTO 20
c     M=1
c  10 M2=M
c     M=ITWO*M2
c     IF(M.GT.M2)GOTO 10
c     HALFM=M2
c     IA=8*IDINT(HALFM*DATAN(1.0D0)/8.0D0) + 5
c     IC=2*IDINT(HALFM*(0.5D0-DSQRT(3.0D0)/6.0D0))+1
c     S=0.5D0/HALFM
c  20 IX=IX*IA+IC
c     IF(IX/2.GT.M2)IX=(IX-M2)-M2
c     IF(IX.LT.0)IX=(IX+M2)+M2
c     URAND=DFLOAT(IX)*S
c     RETURN
c     END
C*******************************
      SUBROUTINE USE
C*******************************
C---- SET BEAM LINE TO BE USED
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
C-----------------------------------------------------------------------
C---- ELEMENT TABLE
      PARAMETER         (MAXELM = 5000)
      COMMON /ELMNAM/   KELEM(MAXELM),KETYP(MAXELM),KELABL(MAXELM)
      CHARACTER*8       KELEM,KELABL*14
      CHARACTER*4       KETYP
C---- MACHINE STRUCTURE FLAGS
      COMMON /FLAGS/    INVAL,NEWCON,NEWPAR,PERI,STABX,STABZ,SYMM
      LOGICAL           INVAL,NEWCON,NEWPAR,PERI,STABX,STABZ,SYMM
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- FLAGS FOR I/O
      COMMON /IOFLAG/   SCAN,ERROR,SKIP,ENDFIL,INTER
      LOGICAL           SCAN,ERROR,SKIP,ENDFIL,INTER
C---- MACHINE PERIOD DEFINITION
      COMMON /PERIOD/   IPERI,IACT,NSUP,NELM,NFREE,NPOS1,NPOS2
C---- SEQUENCE TABLE
      PARAMETER         (MAXPOS = 10000)
      COMMON /SEQNUM/   ITEM(MAXPOS)
      COMMON /SEQFLG/   PRTFLG(MAXPOS)
      LOGICAL           PRTFLG
C-----------------------------------------------------------------------
      PARAMETER         (NDICT = 2)
      CHARACTER*8       DICT(NDICT)
      LOGICAL           SEEN(NDICT)
      INTEGER           ITYPE(NDICT),IVAL(NDICT)
      DIMENSION         RVAL(NDICT)
C-----------------------------------------------------------------------
      DATA DICT(1)      / 'SYMM    ' /
      DATA DICT(2)      / 'SUPER   ' /
C-----------------------------------------------------------------------
C---- COMMA?
      CALL RDTEST(',',ERROR)
      IF (ERROR) GO TO 800
      CALL RDNEXT
C---- BEAM LINE REFERENCE
      CALL DECUSE(IPERI,IACT,ERROR)
      IF (ERROR) GO TO 800
C---- DEFAULT SYMMETRY FLAG AND SUPER-PERIOD
      ITYPE(1) = 3
      ITYPE(2) = 1
      IVAL(2) = 1
C---- DECODE SYMMETRY FLAG AND SUPER-PERIOD COUNT
      CALL RDPARA(NDICT,DICT,ITYPE,SEEN,IVAL,RVAL,ERROR)
      IF (SCAN .OR. ERROR) GO TO 800
      SYMM = SEEN(1)
      NSUP = MAX(IVAL(2),1)
C---- EXPAND THE BEAM LINE
      NFREE = 0
      CALL EXPAND(IPERI,IACT,NELM,NFREE,NPOS1,NPOS2,ERROR)
      IF (ERROR) GO TO 800
      PERI = .TRUE.
C---- CLEAR PRINT FLAGS
      DO 30 IPOS = NPOS1, NPOS2
        PRTFLG(IPOS) = .FALSE.
   30 CONTINUE
      PRTFLG(NPOS1) = .TRUE.
      PRTFLG(NPOS2) = .TRUE.
      CALL TIMER(' ','USE')
      RETURN
C---- ERROR EXIT --- CLEAR LINE DATA
  800 ERROR = .TRUE.
      PERI  = .FALSE.
      SYMM  = .FALSE.
      NSUP  = 1
      RETURN
C-----------------------------------------------------------------------
      END
      SUBROUTINE VALUE
C---- PRINT VALUE OF AN EXPRESSION
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
C-----------------------------------------------------------------------
C---- MACHINE STRUCTURE FLAGS
      COMMON /FLAGS/    INVAL,NEWCON,NEWPAR,PERI,STABX,STABZ,SYMM
      LOGICAL           INVAL,NEWCON,NEWPAR,PERI,STABX,STABZ,SYMM
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- FLAGS FOR I/O
      COMMON /IOFLAG/   SCAN,ERROR,SKIP,ENDFIL,INTER
      LOGICAL           SCAN,ERROR,SKIP,ENDFIL,INTER
C---- PARAMETER TABLE
      PARAMETER         (MAXPAR = 19000)
      COMMON /PARDAT/   IPARM1,IPARM2,IPTYP(MAXPAR),IPDAT(MAXPAR,2),
     +                  IPLIN(MAXPAR)
      COMMON /PARVAL/   PDATA(MAXPAR)
C-----------------------------------------------------------------------
C---- COMMA?
      CALL RDTEST(',',ERROR)
      IF (ERROR) RETURN
      CALL RDNEXT
C---- ALLOCATE PARAMETER SPACE
      IPARM2 = IPARM2 - 1
      IF (IPARM1 .GE. IPARM2) CALL OVFLOW(2,MAXPAR)
      IPARM = IPARM2
C---- DECODE EXPRESSION
      CALL DECEXP(IPARM,ERROR)
      IF (ERROR) RETURN
C---- SEMICOLON?
      CALL RDTEST(';',ERROR)
      IF (ERROR) RETURN
C---- EVALUATE EXPRESSION
      IF (NEWPAR) THEN
        NEWPAR = .FALSE.
        CALL PARORD(ERROR)
        IF (ERROR) RETURN
        CALL PAREVL
      ENDIF
C---- PRINT AND DISCARD EXPRESSION
      WRITE (IECHO,910) PDATA(IPARM)
      IPARM2 = IPARM + 1
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT('0... "VALUE" --- VALUE OF EXPRESSION IS ',F16.8/' ')
C-----------------------------------------------------------------------
      END
      SUBROUTINE VARY(JV,NVPAR,VARVAL,IVOPT)
C  **********************
      IMPLICIT REAL*8 (A-H,O-Z)
      PARAMETER    (mxpart = 128000)
      COMMON/INOUT/IIN,IOUT,ISOUT,ISO,NOUT,NSLC
      PARAMETER    (MXELMD = 3000)
      PARAMETER    (MAXPOS = 10000)
      PARAMETER    (MAXMAT = 500)
      COMMON AMAT(27,6,MAXMAT),NORLST(MAXPOS),
     1EXPEL2,N,LOGPAR(MXPART)
      LOGICAL LOGPAR
      PARAMETER  (MAXDAT = 16000)
      COMMON /INPUTT/ KODE(MXELMD),IADR(MXELMD),ELDAT(MAXDAT)
     +,MADR(MXELMD),KCOUNT,NA,KUNITS
      NVEL = IADR(JV)
      NV = JV
      VAR0=ELDAT(NVEL+NVPAR-1)
      IF(IVOPT.EQ.0)ELDAT(NVEL+NVPAR-1) = VARVAL
      IF(IVOPT.EQ.1)ELDAT(NVEL+NVPAR-1) = VAR0+VARVAL
      IF(IVOPT.EQ.2)ELDAT(NVEL+NVPAR-1) = VAR0*VARVAL
      IF(NVPAR.EQ.1)CALL LENG
C
C     RECOMPUTE MATRIX
C
      CALL MATGEN(NV)
      RETURN
      END
      SUBROUTINE XCALL
C---- PERFORM "CALL" COMMAND
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
C-----------------------------------------------------------------------
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- FLAGS FOR I/O
      COMMON /IOFLAG/   SCAN,ERROR,SKIP,ENDFIL,INTER
      LOGICAL           SCAN,ERROR,SKIP,ENDFIL,INTER
C-----------------------------------------------------------------------
      CALL RDFILE(IFILE,ERROR)
      IF (ERROR) RETURN
      IF (IDATA .NE. 5) THEN
        CALL RDWARN
        WRITE (IECHO,910)
      ELSE
        IF (ICOL .NE. 81) THEN
          CALL RDWARN
          WRITE (IECHO,920)
          ICOL = 81
        ENDIF
        IDATA = IFILE
        ENDFIL = .FALSE.
        REWIND (IDATA)
        WRITE (IECHO,930) IFILE
      ENDIF
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT(' ** WARNING ** "CALL"S CANNOT BE NESTED --- ',
     +       '"CALL" IGNORED'/' ')
  920 FORMAT(' ** WARNING ** TEXT AFTER "CALL" COMMAND SKIPPED'/' ')
  930 FORMAT('0... READING LOGICAL UNIT NUMBER ',I2,/' ')
C-----------------------------------------------------------------------
      END
      SUBROUTINE XCLOSE
C---- CLOSE A FILE
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
C-----------------------------------------------------------------------
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- FLAGS FOR I/O
      COMMON /IOFLAG/   SCAN,ERROR,SKIP,ENDFIL,INTER
      LOGICAL           SCAN,ERROR,SKIP,ENDFIL,INTER
C-----------------------------------------------------------------------
      CALL RDFILE(ICLOSE,ERROR)
      IF (SCAN .OR. ERROR) RETURN
      CLOSE (UNIT = ICLOSE)
      RETURN
C-----------------------------------------------------------------------
      END
      SUBROUTINE XOPEN
C---- OPEN A FILE
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
C-----------------------------------------------------------------------
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- FLAGS FOR I/O
      COMMON /IOFLAG/   SCAN,ERROR,SKIP,ENDFIL,INTER
      LOGICAL           SCAN,ERROR,SKIP,ENDFIL,INTER
C---- INPUT BUFFER
      COMMON /RDBUFF/   KLINE(81)
      CHARACTER*1       KLINE
      CHARACTER*80      KTEXT
      EQUIVALENCE       (KTEXT,KLINE(1))
C-----------------------------------------------------------------------
      CHARACTER*80      FILNAM
C-----------------------------------------------------------------------
      CALL RDFILE(IOPEN,ERROR)
      IF (ERROR) RETURN
      IF (ICOL .NE. 81) THEN
        CALL RDWARN
        WRITE (IECHO,910)
        ICOL = 81
      ENDIF
      CALL RDLINE
      IF (ENDFIL) THEN
        CALL RDFAIL
        WRITE (IECHO,920)
        ERROR = .TRUE.
        RETURN
      ENDIF
      FILNAM = KTEXT
      ICOL = 81
      OPEN (UNIT=IOPEN,FILE=FILNAM,STATUS='UNKNOWN',ERR=800)
      WRITE (IECHO,930) FILNAM
      RETURN
  800 CALL RDWARN
      WRITE (IECHO,940) FILNAM
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT(' ** WARNING ** TEXT AFTER "OPEN" SKIPPED'/' ')
  920 FORMAT(' *** ERROR *** END OF FILE SEEN WHEN READING FILE NAME'/
     +       ' ')
  930 FORMAT('0... SUCCESSFUL TO OPEN FILE:',A)
  940 FORMAT(' ** WARNING ** FAIL TO OPEN FILE: ',A/' ')
C-----------------------------------------------------------------------
      END
       SUBROUTINE XPLODE
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER(I-N)
C---- SEQUENCE TABLE
      PARAMETER         (MAXPOS = 10000)
      COMMON /SEQNUM/   ITEM(MAXPOS)
      COMMON /SEQFLG/   PRTFLG(MAXPOS)
      LOGICAL           PRTFLG
C---- MACHINE PERIOD DEFINITION
      COMMON /PERIOD/   IPERI,IACT,NSUP,NELM,NFREE,NPOS1,NPOS2
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- ELEMENT TABLE
      PARAMETER         (MAXELM = 5000)
      PARAMETER         (MXLINE = 1000)
      COMMON /ELMNAM/   KELEM(MAXELM),KETYP(MAXELM),KELABL(MAXELM)
      CHARACTER*8       KELEM,KELABL*14
      CHARACTER*4       KETYP
C-----------------------------------------------------------------------
C    VARIABLE FORMAT STRINGS FOR IBM
      CHARACTER*17 FMT1
      CHARACTER*15 FMT2
      CHARACTER*15 FMT3
      DATA FMT1/'(5X,  X,  (A8,X))'/
      DATA FMT2/'(1X,  X,1H@,A8)'/
      DATA FMT3/'(1X,  X,1H*,A8)'/
C-----------------------------------------------------------------------
      NUMBL=0
      NUMEL=0
      NBEG=0
      INBL=0
      DO 100 I=NPOS1, NPOS2
C---- ELEMENT
        IF(ITEM(I).LE.MAXELM) THEN
          IF(INBL.NE.0) THEN
            NUMEL = NUMEL+1
          ELSE
            WRITE(IPRNT,900) KELEM(ITEM(I))
          ENDIF
C--- START OF BEAMLINE
        ELSE IF(ITEM(I).LE.(MAXELM+MXLINE)) THEN
          INBL=1
C         IF(NUMEL.NE.0) WRITE(IPRNT,901)
          IFM11=2*NUMBL
          IFM12=(75-2*NUMBL)/8
          CALL FORM(IFM11,5,FMT1)
          CALL FORM(IFM12,9,FMT1)
          IF(NUMEL.NE.0) WRITE(IPRNT,FMT1)
     +                  (KELEM(ITEM(J)), J=NBEG+1,NBEG+NUMEL)
          NUMEL = 0
          NUMBL = NUMBL+1
          NBEG = I
          IBEG=ITEM(NBEG)-MAXELM
C------FORMAT SET UP FOR IBM AND VAX--------------
          IFM23=2*(NUMBL-1)
          CALL FORM(IFM23,5,FMT2)
C         WRITE(IPRNT,902) KELEM(IBEG)
          WRITE(IPRNT,FMT2) KELEM(IBEG)
C---- END OF BEAMLINE
        ELSE IF(ITEM(I).GE.(MAXELM+MXLINE)) THEN
C         IF(NUMEL.NE.0) WRITE(IPRNT,901)
          IFM11=2*NUMBL
          IFM12=(75-2*NUMBL)/8
          CALL FORM(IFM11,5,FMT1)
          CALL FORM(IFM12,9,FMT1)
          IF(NUMEL.NE.0) WRITE(IPRNT,FMT1)
     +                  (KELEM(ITEM(J)), J=NBEG+1,NBEG+NUMEL)
          IEND=ITEM(I)-(MAXELM+MXLINE)
C         WRITE(IPRNT,903) KELEM(IEND)
          IFM23=2*(NUMBL-1)
          CALL FORM(IFM23,5,FMT3)
          WRITE(IPRNT,FMT3) KELEM(IEND)
          NUMBL = NUMBL-1
          NUMEL=0
          IF(NUMBL.EQ.0) THEN
            INBL=0
            NBEG=0
          ELSE
            NBEG = I
          ENDIF
        ENDIF
  100 CONTINUE
  900 FORMAT(' ',A8)
C---GENERAL VERSION, UNCOMMENT THESE FORMAT STATEMENTS
C 901 FORMAT('     ',9A8)
C 902 FORMAT(' BEAMLINE ',A8)
C 903 FORMAT(' END BEAMLINE ',A8)
      RETURN
      END
      SUBROUTINE XRETRN
C---- PERFORM "RETURN" COMMAND
C-----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z), INTEGER (I-N)
C-----------------------------------------------------------------------
C---- LOGICAL UNITS, POINTERS AND COUNTERS FOR I/O
      COMMON /IODATA/   IDATA,IPRNT,IECHO,ILINE,ILCOM,ICOL,IMARK,
     +                  NWARN,NFAIL
C---- FLAGS FOR I/O
      COMMON /IOFLAG/   SCAN,ERROR,SKIP,ENDFIL,INTER
      LOGICAL           SCAN,ERROR,SKIP,ENDFIL,INTER
C-----------------------------------------------------------------------
      CALL RDTEST(';',ERROR)
      IF (ERROR) RETURN
      IF (IDATA .EQ. 5) THEN
        CALL RDWARN
        WRITE (IECHO,910)
      ELSE
        IF (ICOL .NE. 81) THEN
          CALL RDWARN
          WRITE (IECHO,920)
          ICOL = 81
        ENDIF
        IDATA = 5
        ENDFIL = .FALSE.
        WRITE (IECHO,930)
      ENDIF
      RETURN
C-----------------------------------------------------------------------
  910 FORMAT(' ** WARNING ** "RETURN" NOT PERMITTED ON STANDARD ',
     +       'INPUT FILE --- "RETURN" IGNORED')
  920 FORMAT(' ** WARNING ** TEXT AFTER "RETURN" SKIPPED'/' ')
  930 FORMAT('0... READING STANDARD INPUT FILE'/' ')
C-----------------------------------------------------------------------
      END
C*******************
C LMDIF PACKAGE ROUTINES
C********************
C     ***************************************************************
      SUBROUTINE LMDIF(FCN,M,N,X,FVEC,FTOL,XTOL,GTOL,MAXFEV,EPSFCN,
     *                 DIAG,MODE,FACTOR,NPRINT,INFO,NFEV,FJAC,LDFJAC,
     *                 IPVT,QTF,WA1,WA2,WA3,WA4)
      INTEGER M,N,MAXFEV,MODE,NPRINT,INFO,NFEV,LDFJAC
      INTEGER IPVT(N)
      DOUBLE PRECISION FTOL,XTOL,GTOL,EPSFCN,FACTOR
      DOUBLE PRECISION X(N),FVEC(M),DIAG(N),FJAC(LDFJAC,N),QTF(N),
     *                 WA1(N),WA2(N),WA3(N),WA4(M)
      EXTERNAL FCN
C     ***************************************************************
C
C     SUBROUTINE LMDIF
C
C     THE PURPOSE OF LMDIF IS TO MINIMIZE THE SUM OF THE SQUARES OF
C     M NONLINEAR FUNCTIONS IN N VARIABLES BY A MODIFICATION OF
C     THE LEVENBERG-MARQUARDT ALGORITHM. THE USER MUST PROVIDE A
C     SUBROUTINE WHICH CALCULATES THE FUNCTIONS. THE JACOBIAN IS
C     THEN CALCULATED BY A FORWARD-DIFFERENCE APPROXIMATION.
C
C     THE SUBROUTINE STATEMENT IS
C
C       SUBROUTINE LMDIF(FCN,M,N,X,FVEC,FTOL,XTOL,GTOL,MAXFEV,EPSFCN,
C                        DIAG,MODE,FACTOR,NPRINT,INFO,NFEV,FJAC,
C                        LDFJAC,IPVT,QTF,WA1,WA2,WA3,WA4)
C
C     WHERE
C
C       FCN IS THE NAME OF THE USER-SUPPLIED SUBROUTINE WHICH
C         CALCULATES THE FUNCTIONS. FCN MUST BE DECLARED
C         IN AN EXTERNAL STATEMENT IN THE USER CALLING
C         PROGRAM, AND SHOULD BE WRITTEN AS FOLLOWS.
C
C         SUBROUTINE FCN(M,N,X,FVEC,IFLAG)
C         INTEGER M,N,IFLAG
C         DOUBLE PRECISION X(N),FVEC(M)
C         ----------
C         CALCULATE THE FUNCTIONS AT X AND
C         RETURN THIS VECTOR IN FVEC.
C         ----------
C         RETURN
C         END
C
C         THE VALUE OF IFLAG SHOULD NOT BE CHANGED BY FCN UNLESS
C         THE USER WANTS TO TERMINATE EXECUTION OF LMDIF.
C         IN THIS CASE SET IFLAG TO A NEGATIVE INTEGER.
C
C       M IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
C         OF FUNCTIONS.
C
C       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
C         OF VARIABLES. N MUST NOT EXCEED M.
C
C       X IS AN ARRAY OF LENGTH N. ON INPUT X MUST CONTAIN
C         AN INITIAL ESTIMATE OF THE SOLUTION VECTOR. ON OUTPUT X
C         CONTAINS THE FINAL ESTIMATE OF THE SOLUTION VECTOR.
C
C       FVEC IS AN OUTPUT ARRAY OF LENGTH M WHICH CONTAINS
C         THE FUNCTIONS EVALUATED AT THE OUTPUT X.
C
C       FTOL IS A NONNEGATIVE INPUT VARIABLE. TERMINATION
C         OCCURS WHEN BOTH THE ACTUAL AND PREDICTED RELATIVE
C         REDUCTIONS IN THE SUM OF SQUARES ARE AT MOST FTOL.
C         THEREFORE, FTOL MEASURES THE RELATIVE ERROR DESIRED
C         IN THE SUM OF SQUARES.
C
C       XTOL IS A NONNEGATIVE INPUT VARIABLE. TERMINATION
C         OCCURS WHEN THE RELATIVE ERROR BETWEEN TWO CONSECUTIVE
C         ITERATES IS AT MOST XTOL. THEREFORE, XTOL MEASURES THE
C         RELATIVE ERROR DESIRED IN THE APPROXIMATE SOLUTION.
C
C       GTOL IS A NONNEGATIVE INPUT VARIABLE. TERMINATION
C         OCCURS WHEN THE COSINE OF THE ANGLE BETWEEN FVEC AND
C         ANY COLUMN OF THE JACOBIAN IS AT MOST GTOL IN ABSOLUTE
C         VALUE. THEREFORE, GTOL MEASURES THE ORTHOGONALITY
C         DESIRED BETWEEN THE FUNCTION VECTOR AND THE COLUMNS
C         OF THE JACOBIAN.
C
C       MAXFEV IS A POSITIVE INTEGER INPUT VARIABLE. TERMINATION
C         OCCURS WHEN THE NUMBER OF CALLS TO FCN IS AT LEAST
C         MAXFEV BY THE END OF AN ITERATION.
C
C       EPSFCN IS AN INPUT VARIABLE USED IN DETERMINING A SUITABLE
C         STEP LENGTH FOR THE FORWARD-DIFFERENCE APPROXIMATION. THIS
C         APPROXIMATION ASSUMES THAT THE RELATIVE ERRORS IN THE
C         FUNCTIONS ARE OF THE ORDER OF EPSFCN. IF EPSFCN IS LESS
C         THAN THE MACHINE PRECISION, IT IS ASSUMED THAT THE RELATIVE
C         ERRORS IN THE FUNCTIONS ARE OF THE ORDER OF THE MACHINE
C         PRECISION.
C
C       DIAG IS AN ARRAY OF LENGTH N. IF MODE = 1 (SEE
C         BELOW), DIAG IS INTERNALLY SET. IF MODE = 2, DIAG
C         MUST CONTAIN POSITIVE ENTRIES THAT SERVE AS
C         MULTIPLICATIVE SCALE FACTORS FOR THE VARIABLES.
C
C       MODE IS AN INTEGER INPUT VARIABLE. IF MODE = 1, THE
C         VARIABLES WILL BE SCALED INTERNALLY. IF MODE = 2,
C         THE SCALING IS SPECIFIED BY THE INPUT DIAG. OTHER
C         VALUES OF MODE ARE EQUIVALENT TO MODE = 1.
C
C       FACTOR IS A POSITIVE INPUT VARIABLE USED IN DETERMINING THE
C         INITIAL STEP BOUND. THIS BOUND IS SET TO THE PRODUCT OF
C         FACTOR AND THE EUCLIDEAN NORM OF DIAG*X IF NONZERO, OR ELSE
C         TO FACTOR ITSELF. IN MOST CASES FACTOR SHOULD LIE IN THE
C         INTERVAL (.1,100.). 100. IS A GENERALLY RECOMMENDED VALUE.
C
C       NPRINT IS AN INTEGER INPUT VARIABLE THAT ENABLES CONTROLLED
C         PRINTING OF ITERATES IF IT IS POSITIVE. IN THIS CASE,
C         FCN IS CALLED WITH IFLAG = 0 AT THE BEGINNING OF THE FIRST
C         ITERATION AND EVERY NPRINT ITERATIONS THEREAFTER AND
C         IMMEDIATELY PRIOR TO RETURN, WITH X AND FVEC AVAILABLE
C         FOR PRINTING. IF NPRINT IS NOT POSITIVE, NO SPECIAL CALLS
C         OF FCN WITH IFLAG = 0 ARE MADE.
C
C       INFO IS AN INTEGER OUTPUT VARIABLE. IF THE USER HAS
C         TERMINATED EXECUTION, INFO IS SET TO THE (NEGATIVE)
C         VALUE OF IFLAG. SEE DESCRIPTION OF FCN. OTHERWISE,
C         INFO IS SET AS FOLLOWS.
C
C         INFO = 0  IMPROPER INPUT PARAMETERS.
C
C         INFO = 1  BOTH ACTUAL AND PREDICTED RELATIVE REDUCTIONS
C                   IN THE SUM OF SQUARES ARE AT MOST FTOL.
C
C         INFO = 2  RELATIVE ERROR BETWEEN TWO CONSECUTIVE ITERATES
C                   IS AT MOST XTOL.
C
C         INFO = 3  CONDITIONS FOR INFO = 1 AND INFO = 2 BOTH HOLD.
C
C         INFO = 4  THE COSINE OF THE ANGLE BETWEEN FVEC AND ANY
C                   COLUMN OF THE JACOBIAN IS AT MOST GTOL IN
C                   ABSOLUTE VALUE.
C
C         INFO = 5  NUMBER OF CALLS TO FCN HAS REACHED OR
C                   EXCEEDED MAXFEV.
C
C         INFO = 6  FTOL IS TOO SMALL. NO FURTHER REDUCTION IN
C                   THE SUM OF SQUARES IS POSSIBLE.
C
C         INFO = 7  XTOL IS TOO SMALL. NO FURTHER IMPROVEMENT IN
C                   THE APPROXIMATE SOLUTION X IS POSSIBLE.
C
C         INFO = 8  GTOL IS TOO SMALL. FVEC IS ORTHOGONAL TO THE
C                   COLUMNS OF THE JACOBIAN TO MACHINE PRECISION.
C
C       NFEV IS AN INTEGER OUTPUT VARIABLE SET TO THE NUMBER OF
C         CALLS TO FCN.
C
C       FJAC IS AN OUTPUT M BY N ARRAY. THE UPPER N BY N SUBMATRIX
C         OF FJAC CONTAINS AN UPPER TRIANGULAR MATRIX R WITH
C         DIAGONAL ELEMENTS OF NONINCREASING MAGNITUDE SUCH THAT
C
C                T     T           T
C               P *(JAC *JAC)*P = R *R,
C
C         WHERE P IS A PERMUTATION MATRIX AND JAC IS THE FINAL
C         CALCULATED JACOBIAN. COLUMN J OF P IS COLUMN IPVT(J)
C         (SEE BELOW) OF THE IDENTITY MATRIX. THE LOWER TRAPEZOIDAL
C         PART OF FJAC CONTAINS INFORMATION GENERATED DURING
C         THE COMPUTATION OF R.
C
C       LDFJAC IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN M
C         WHICH SPECIFIES THE LEADING DIMENSION OF THE ARRAY FJAC.
C
C       IPVT IS AN INTEGER OUTPUT ARRAY OF LENGTH N. IPVT
C         DEFINES A PERMUTATION MATRIX P SUCH THAT JAC*P = Q*R,
C         WHERE JAC IS THE FINAL CALCULATED JACOBIAN, Q IS
C         ORTHOGONAL (NOT STORED), AND R IS UPPER TRIANGULAR
C         WITH DIAGONAL ELEMENTS OF NONINCREASING MAGNITUDE.
C         COLUMN J OF P IS COLUMN IPVT(J) OF THE IDENTITY MATRIX.
C
C       QTF IS AN OUTPUT ARRAY OF LENGTH N WHICH CONTAINS
C         THE FIRST N ELEMENTS OF THE VECTOR (Q TRANSPOSE)*FVEC.
C
C       WA1, WA2, AND WA3 ARE WORK ARRAYS OF LENGTH N.
C
C       WA4 IS A WORK ARRAY OF LENGTH M.
C
C     SUBPROGRAMS CALLED
C
C       USER-SUPPLIED ...... FCN
C
C       MINPACK-SUPPLIED ... DPMPAR,ENORM,FDJAC2,LMPAR,QRFAC
C
C       FORTRAN-SUPPLIED ... DABS,DMAX1,DMIN1,DSQRT,MOD
C
C     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
C     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
C
C     **********
      INTEGER I,IFLAG,ITER,J,L
      DOUBLE PRECISION ACTRED,DELTA,DIRDER,EPSMCH,FNORM,FNORM1,GNORM,
     *                 ONE,PAR,PNORM,PRERED,P1,P5,P25,P75,P0001,RATIO,
     *                 SUM,TEMP,TEMP1,TEMP2,XNORM,ZERO
      DOUBLE PRECISION DPMPAR,ENORM
      DATA ONE,P1,P5,P25,P75,P0001,ZERO
     *     /1.0D0,1.0D-1,5.0D-1,2.5D-1,7.5D-1,1.0D-4,0.0D0/
C
C     EPSMCH IS THE MACHINE PRECISION.
C
C-----------------------------------------------------------------
C-----------------------------------------------------------------
      EPSMCH = DPMPAR(1)
C
      INFO = 0
      IFLAG = 0
      NFEV = 0
C
C     CHECK THE INPUT PARAMETERS FOR ERRORS.
C
      IF (N .LE. 0 .OR. M .LT. N .OR. LDFJAC .LT. M
     *    .OR. FTOL .LT. ZERO .OR. XTOL .LT. ZERO .OR. GTOL .LT. ZERO
     *    .OR. MAXFEV .LE. 0 .OR. FACTOR .LE. ZERO) GO TO 300
      IF (MODE .NE. 2) GO TO 20
      DO 10 J = 1, N
         IF (DIAG(J) .LE. ZERO) GO TO 300
   10    CONTINUE
   20 CONTINUE
C
C     EVALUATE THE FUNCTION AT THE STARTING POINT
C     AND CALCULATE ITS NORM.
C
      IFLAG = 1
      CALL FCN(M,N,X,FVEC,IFLAG)
      NFEV = 1
      IF (IFLAG .LT. 0) GO TO 300
      FNORM = ENORM(M,FVEC)
C
C     INITIALIZE LEVENBERG-MARQUARDT PARAMETER AND ITERATION COUNT
C
      PAR = ZERO
      ITER = 1
C
C     BEGINNING OF THE OUTER LOOP.
C
   30 CONTINUE
C
C        CALCULATE THE JACOBIAN MATRIX.
C
         IFLAG = 2
         CALL FDJAC2(FCN,M,N,X,FVEC,FJAC,LDFJAC,IFLAG,EPSFCN,WA4)
         NFEV = NFEV + N
         IF (IFLAG .LT. 0) GO TO 300
C
C        IF REQUESTED, CALL FCN TO ENABLE PRINTING OF ITERATES.
C
         IF (NPRINT .LE. 0) GO TO 40
         IFLAG = 0
         IF (MOD(ITER-1,NPRINT) .EQ. 0) CALL FCN(M,N,X,FVEC,IFLAG)
         IF (IFLAG .LT. 0) GO TO 300
   40    CONTINUE
C
C        COMPUTE THE QR FACTORIZATION OF THE JACOBIAN.
C
         CALL QRFAC(M,N,FJAC,LDFJAC,.TRUE.,IPVT,N,WA1,WA2,WA3)
C
C        ON THE FIRST ITERATION AND IF MODE IS 1, SCALE ACCORDING
C        TO THE NORMS OF THE COLUMNS OF THE INITIAL JACOBIAN.
C
         IF (ITER .NE. 1) GO TO 80
         IF (MODE .EQ. 2) GO TO 60
         DO 50 J = 1, N
            DIAG(J) = WA2(J)
            IF (WA2(J) .EQ. ZERO) DIAG(J) = ONE
   50       CONTINUE
   60    CONTINUE
C
C        ON THE FIRST ITERATION, CALCULATE THE NORM OF THE SCALED X
C        AND INITIALIZE THE STEP BOUND DELTA.
C
         DO 70 J = 1, N
            WA3(J) = DIAG(J)*X(J)
   70       CONTINUE
         XNORM = ENORM(N,WA3)
         DELTA = FACTOR*XNORM
         IF (DELTA .EQ. ZERO) DELTA = FACTOR
   80    CONTINUE
C
C        FORM (Q TRANSPOSE)*FVEC AND STORE THE FIRST N COMPONENTS IN
C        QTF.
C
         DO 90 I = 1, M
            WA4(I) = FVEC(I)
   90       CONTINUE
         DO 130 J = 1, N
            IF (FJAC(J,J) .EQ. ZERO) GO TO 120
            SUM = ZERO
            DO 100 I = J, M
               SUM = SUM + FJAC(I,J)*WA4(I)
  100          CONTINUE
            TEMP = -SUM/FJAC(J,J)
            DO 110 I = J, M
               WA4(I) = WA4(I) + FJAC(I,J)*TEMP
  110          CONTINUE
  120       CONTINUE
            FJAC(J,J) = WA1(J)
            QTF(J) = WA4(J)
  130       CONTINUE
C
C        COMPUTE THE NORM OF THE SCALED GRADIENT.
C
         GNORM = ZERO
         IF (FNORM .EQ. ZERO) GO TO 170
         DO 160 J = 1, N
            L = IPVT(J)
            IF (WA2(L) .EQ. ZERO) GO TO 150
            SUM = ZERO
            DO 140 I = 1, J
               SUM = SUM + FJAC(I,J)*(QTF(I)/FNORM)
  140          CONTINUE
            GNORM = DMAX1(GNORM,DABS(SUM/WA2(L)))
  150       CONTINUE
  160       CONTINUE
  170    CONTINUE
C
C        TEST FOR CONVERGENCE OF THE GRADIENT NORM.
C
         IF (GNORM .LE. GTOL) INFO = 4
         IF (INFO .NE. 0) GO TO 300
C
C        RESCALE IF NECESSARY.
C
         IF (MODE .EQ. 2) GO TO 190
         DO 180 J = 1, N
            DIAG(J) = DMAX1(DIAG(J),WA2(J))
  180       CONTINUE
  190    CONTINUE
C
C        BEGINNING OF THE INNER LOOP.
C
  200    CONTINUE
C
C           DETERMINE THE LEVENBERG-MARQUARDT PARAMETER.
C
            CALL LMPAR(N,FJAC,LDFJAC,IPVT,DIAG,QTF,DELTA,PAR,WA1,WA2,
     *                 WA3,WA4)
C
C           STORE THE DIRECTION P AND X + P. CALCULATE THE NORM OF P.
C
            DO 210 J = 1, N
               WA1(J) = -WA1(J)
               WA2(J) = X(J) + WA1(J)
               WA3(J) = DIAG(J)*WA1(J)
  210          CONTINUE
            PNORM = ENORM(N,WA3)
C
C           ON THE FIRST ITERATION, ADJUST THE INITIAL STEP BOUND.
C
            IF (ITER .EQ. 1) DELTA = DMIN1(DELTA,PNORM)
C
C           EVALUATE THE FUNCTION AT X + P AND CALCULATE ITS NORM.
C
            IFLAG = 1
            CALL FCN(M,N,WA2,WA4,IFLAG)
            NFEV = NFEV + 1
            IF (IFLAG .LT. 0) GO TO 300
            FNORM1 = ENORM(M,WA4)
C
C           COMPUTE THE SCALED ACTUAL REDUCTION.
C
            ACTRED = -ONE
            IF (P1*FNORM1 .LT. FNORM) ACTRED = ONE - (FNORM1/FNORM)**2
C
C           COMPUTE THE SCALED PREDICTED REDUCTION AND
C           THE SCALED DIRECTIONAL DERIVATIVE.
C
            DO 230 J = 1, N
               WA3(J) = ZERO
               L = IPVT(J)
               TEMP = WA1(L)
               DO 220 I = 1, J
                  WA3(I) = WA3(I) + FJAC(I,J)*TEMP
  220             CONTINUE
  230          CONTINUE
            TEMP1 = ENORM(N,WA3)/FNORM
            TEMP2 = (DSQRT(PAR)*PNORM)/FNORM
            PRERED = TEMP1**2 + TEMP2**2/P5
            DIRDER = -(TEMP1**2 + TEMP2**2)
C
C           COMPUTE THE RATIO OF THE ACTUAL TO THE PREDICTED
C           REDUCTION.
C
            RATIO = ZERO
            IF (PRERED .NE. ZERO) RATIO = ACTRED/PRERED
C
C           UPDATE THE STEP BOUND.
C
            IF (RATIO .GT. P25) GO TO 240
               IF (ACTRED .GE. ZERO) TEMP = P5
               IF (ACTRED .LT. ZERO)
     *            TEMP = P5*DIRDER/(DIRDER + P5*ACTRED)
               IF (P1*FNORM1 .GE. FNORM .OR. TEMP .LT. P1) TEMP = P1
               DELTA = TEMP*DMIN1(DELTA,PNORM/P1)
               PAR = PAR/TEMP
               GO TO 260
  240       CONTINUE
               IF (PAR .NE. ZERO .AND. RATIO .LT. P75) GO TO 250
               DELTA = PNORM/P5
               PAR = P5*PAR
  250          CONTINUE
  260       CONTINUE
C
C           TEST FOR SUCCESSFUL ITERATION.
C
            IF (RATIO .LT. P0001) GO TO 290
C
C           SUCCESSFUL ITERATION. UPDATE X, FVEC, AND THEIR NORMS.
C
            DO 270 J = 1, N
               X(J) = WA2(J)
               WA2(J) = DIAG(J)*X(J)
  270          CONTINUE
            DO 280 I = 1, M
               FVEC(I) = WA4(I)
  280          CONTINUE
            XNORM = ENORM(N,WA2)
            FNORM = FNORM1
            ITER = ITER + 1
  290       CONTINUE
C
C           TESTS FOR CONVERGENCE.
C
            IF (DABS(ACTRED) .LE. FTOL .AND. PRERED .LE. FTOL
     *          .AND. P5*RATIO .LE. ONE) INFO = 1
            IF (DELTA .LE. XTOL*XNORM) INFO = 2
            IF (DABS(ACTRED) .LE. FTOL .AND. PRERED .LE. FTOL
     *          .AND. P5*RATIO .LE. ONE .AND. INFO .EQ. 2) INFO = 3
            IF (INFO .NE. 0) GO TO 300
C
C           TESTS FOR TERMINATION AND STRINGENT TOLERANCES.
C
            IF (NFEV .GE. MAXFEV) INFO = 5
            IF (DABS(ACTRED) .LE. EPSMCH .AND. PRERED .LE. EPSMCH
     *          .AND. P5*RATIO .LE. ONE) INFO = 6
            IF (DELTA .LE. EPSMCH*XNORM) INFO = 7
            IF (GNORM .LE. EPSMCH) INFO = 8
            IF (INFO .NE. 0) GO TO 300
C
C           END OF THE INNER LOOP. REPEAT IF ITERATION UNSUCCESSFUL.
C
            IF (RATIO .LT. P0001) GO TO 200
C
C        END OF THE OUTER LOOP.
C
         GO TO 30
  300 CONTINUE
C
C     TERMINATION, EITHER NORMAL OR USER IMPOSED.
C
      IF (IFLAG .LT. 0) INFO = IFLAG
      IFLAG = 0
      IF (NPRINT .GT. 0) CALL FCN(M,N,X,FVEC,IFLAG)
      RETURN
C
C     LAST CARD OF SUBROUTINE LMDIF.
C
      END

C     **************************************
      DOUBLE PRECISION FUNCTION ENORM(N,X)
      INTEGER N
      DOUBLE PRECISION X(N)
C     ***************************************
C
C     FUNCTION ENORM
C
C     GIVEN AN N-VECTOR X, THIS FUNCTION CALCULATES THE
C     EUCLIDEAN NORM OF X.
C
C     THE EUCLIDEAN NORM IS COMPUTED BY ACCUMULATING THE SUM OF
C     SQUARES IN THREE DIFFERENT SUMS. THE SUMS OF SQUARES FOR THE
C     SMALL AND LARGE COMPONENTS ARE SCALED SO THAT NO OVERFLOWS
C     OCCUR. NON-DESTRUCTIVE UNDERFLOWS ARE PERMITTED. UNDERFLOWS
C     AND OVERFLOWS DO NOT OCCUR IN THE COMPUTATION OF THE UNSCALED
C     SUM OF SQUARES FOR THE INTERMEDIATE COMPONENTS.
C     THE DEFINITIONS OF SMALL, INTERMEDIATE AND LARGE COMPONENTS
C     DEPEND ON TWO CONSTANTS, RDWARF AND RGIANT. THE MAIN
C     RESTRICTIONS ON THESE CONSTANTS ARE THAT RDWARF**2 NOT
C     UNDERFLOW AND RGIANT**2 NOT OVERFLOW. THE CONSTANTS
C     GIVEN HERE ARE SUITABLE FOR EVERY KNOWN COMPUTER.
C
C     THE FUNCTION STATEMENT IS
C
C       DOUBLE PRECISION FUNCTION ENORM(N,X)
C
C     WHERE
C
C       N IS A POSITIVE INTEGER INPUT VARIABLE.
C
C       X IS AN INPUT ARRAY OF LENGTH N.
C
C     SUBPROGRAMS CALLED
C
C       FORTRAN-SUPPLIED ... DABS,DSQRT
C
C     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
C     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
C
C     **********
      INTEGER I
      DOUBLE PRECISION AGIANT,FLOATN,ONE,RDWARF,RGIANT,S1,S2,S3,XABS,
     *                 X1MAX,X3MAX,ZERO
      DATA ONE,ZERO,RDWARF,RGIANT /1.0D0,0.0D0,3.834D-20,1.304D19/
      S1 = ZERO
      S2 = ZERO
      S3 = ZERO
      X1MAX = ZERO
      X3MAX = ZERO
      FLOATN = N
      AGIANT = RGIANT/FLOATN
      DO 90 I = 1, N
         XABS = DABS(X(I))
         IF (XABS .GT. RDWARF .AND. XABS .LT. AGIANT) GO TO 70
            IF (XABS .LE. RDWARF) GO TO 30
C
C              SUM FOR LARGE COMPONENTS.
C
               IF (XABS .LE. X1MAX) GO TO 10
                  S1 = ONE + S1*(X1MAX/XABS)**2
                  X1MAX = XABS
                  GO TO 20
   10          CONTINUE
                  S1 = S1 + (XABS/X1MAX)**2
   20          CONTINUE
               GO TO 60
   30       CONTINUE
C
C              SUM FOR SMALL COMPONENTS.
C
               IF (XABS .LE. X3MAX) GO TO 40
                  S3 = ONE + S3*(X3MAX/XABS)**2
                  X3MAX = XABS
                  GO TO 50
   40          CONTINUE
                  IF (XABS .NE. ZERO) S3 = S3 + (XABS/X3MAX)**2
   50          CONTINUE
   60       CONTINUE
            GO TO 80
   70    CONTINUE
C
C           SUM FOR INTERMEDIATE COMPONENTS.
C
            S2 = S2 + XABS**2
   80    CONTINUE
   90    CONTINUE
C
C     CALCULATION OF NORM.
C
      IF (S1 .EQ. ZERO) GO TO 100
         ENORM = X1MAX*DSQRT(S1+(S2/X1MAX)/X1MAX)
         GO TO 130
  100 CONTINUE
         IF (S2 .EQ. ZERO) GO TO 110
            IF (S2 .GE. X3MAX)
     *         ENORM = DSQRT(S2*(ONE+(X3MAX/S2)*(X3MAX*S3)))
            IF (S2 .LT. X3MAX)
     *         ENORM = DSQRT(X3MAX*((S2/X3MAX)+(X3MAX*S3)))
            GO TO 120
  110    CONTINUE
            ENORM = X3MAX*DSQRT(S3)
  120    CONTINUE
  130 CONTINUE
      RETURN
C
C     LAST CARD OF FUNCTION ENORM.
C
      END
C     **************************************************************
      SUBROUTINE FDJAC2(FCN,M,N,X,FVEC,FJAC,LDFJAC,IFLAG,EPSFCN,WA)
      INTEGER M,N,LDFJAC,IFLAG
      DOUBLE PRECISION EPSFCN
      DOUBLE PRECISION X(N),FVEC(M),FJAC(LDFJAC,N),WA(M)
C     ***************************************************************
C
C     SUBROUTINE FDJAC2
C
C     THIS SUBROUTINE COMPUTES A FORWARD-DIFFERENCE APPROXIMATION
C     TO THE M BY N JACOBIAN MATRIX ASSOCIATED WITH A SPECIFIED
C     PROBLEM OF M FUNCTIONS IN N VARIABLES.
C
C     THE SUBROUTINE STATEMENT IS
C
C       SUBROUTINE FDJAC2(FCN,M,N,X,FVEC,FJAC,LDFJAC,IFLAG,EPSFCN,WA)
C
C     WHERE
C
C       FCN IS THE NAME OF THE USER-SUPPLIED SUBROUTINE WHICH
C         CALCULATES THE FUNCTIONS. FCN MUST BE DECLARED
C         IN AN EXTERNAL STATEMENT IN THE USER CALLING
C         PROGRAM, AND SHOULD BE WRITTEN AS FOLLOWS.
C
C         SUBROUTINE FCN(M,N,X,FVEC,IFLAG)
C         INTEGER M,N,IFLAG
C         DOUBLE PRECISION X(N),FVEC(M)
C         ----------
C         CALCULATE THE FUNCTIONS AT X AND
C         RETURN THIS VECTOR IN FVEC.
C         ----------
C         RETURN
C         END
C
C         THE VALUE OF IFLAG SHOULD NOT BE CHANGED BY FCN UNLESS
C         THE USER WANTS TO TERMINATE EXECUTION OF FDJAC2.
C         IN THIS CASE SET IFLAG TO A NEGATIVE INTEGER.
C
C       M IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
C         OF FUNCTIONS.
C
C       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
C         OF VARIABLES. N MUST NOT EXCEED M.
C
C       X IS AN INPUT ARRAY OF LENGTH N.
C
C       FVEC IS AN INPUT ARRAY OF LENGTH M WHICH MUST CONTAIN THE
C         FUNCTIONS EVALUATED AT X.
C
C       FJAC IS AN OUTPUT M BY N ARRAY WHICH CONTAINS THE
C         APPROXIMATION TO THE JACOBIAN MATRIX EVALUATED AT X.
C
C       LDFJAC IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN M
C         WHICH SPECIFIES THE LEADING DIMENSION OF THE ARRAY FJAC.
C
C       IFLAG IS AN INTEGER VARIABLE WHICH CAN BE USED TO TERMINATE
C         THE EXECUTION OF FDJAC2. SEE DESCRIPTION OF FCN.
C
C       EPSFCN IS AN INPUT VARIABLE USED IN DETERMINING A SUITABLE
C         STEP LENGTH FOR THE FORWARD-DIFFERENCE APPROXIMATION. THIS
C         APPROXIMATION ASSUMES THAT THE RELATIVE ERRORS IN THE
C         FUNCTIONS ARE OF THE ORDER OF EPSFCN. IF EPSFCN IS LESS
C         THAN THE MACHINE PRECISION, IT IS ASSUMED THAT THE RELATIVE
C         ERRORS IN THE FUNCTIONS ARE OF THE ORDER OF THE MACHINE
C         PRECISION.
C
C       WA IS A WORK ARRAY OF LENGTH M.
C
C     SUBPROGRAMS CALLED
C
C       USER-SUPPLIED ...... FCN
C
C       MINPACK-SUPPLIED ... DPMPAR
C
C       FORTRAN-SUPPLIED ... DABS,DMAX1,DSQRT
C
C     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
C     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
C
C     **********
      EXTERNAL FCN
      INTEGER I,J
      DOUBLE PRECISION EPS,EPSMCH,H,TEMP,ZERO
      DOUBLE PRECISION DPMPAR
      DATA ZERO /0.0D0/
C
C     EPSMCH IS THE MACHINE PRECISION.
C
      EPSMCH = DPMPAR(1)
C
      EPS = DSQRT(DMAX1(EPSFCN,EPSMCH))
      DO 20 J = 1, N
         TEMP = X(J)
         H = EPS*DABS(TEMP)
         IF (H .EQ. ZERO) H = EPS
         X(J) = TEMP + H
         CALL FCN(M,N,X,WA,IFLAG)
         IF (IFLAG .LT. 0) GO TO 30
         X(J) = TEMP
         DO 10 I = 1, M
            FJAC(I,J) = (WA(I) - FVEC(I))/H
   10       CONTINUE
   20    CONTINUE
   30 CONTINUE
      RETURN
C
C     LAST CARD OF SUBROUTINE FDJAC2.
C
      END
C     *************************************
      DOUBLE PRECISION FUNCTION DPMPAR(I)
      INTEGER I
C     **********
C
C     FUNCTION DPMPAR
C
C     THIS FUNCTION PROVIDES DOUBLE PRECISION MACHINE PARAMETERS
C     WHEN THE APPROPRIATE SET OF DATA STATEMENTS IS ACTIVATED (BY
C     REMOVING THE C FROM COLUMN 1) AND ALL OTHER DATA STATEMENTS ARE
C     RENDERED INACTIVE. MOST OF THE PARAMETER VALUES WERE OBTAINED
C     FROM THE CORRESPONDING BELL LABORATORIES PORT LIBRARY FUNCTION.
C
C     THE FUNCTION STATEMENT IS
C
C       DOUBLE PRECISION FUNCTION DPMPAR(I)
C
C     WHERE
C
C       I IS AN INTEGER INPUT VARIABLE SET TO 1, 2, OR 3 WHICH
C         SELECTS THE DESIRED MACHINE PARAMETER. IF THE MACHINE HAS
C         T BASE B DIGITS AND ITS SMALLEST AND LARGEST EXPONENTS ARE
C         EMIN AND EMAX, RESPECTIVELY, THEN THESE PARAMETERS ARE
C
C         DPMPAR(1) = B**(1 - T), THE MACHINE PRECISION,
C
C         DPMPAR(2) = B**(EMIN - 1), THE SMALLEST MAGNITUDE,
C
C         DPMPAR(3) = B**EMAX*(1 - B**(-T)), THE LARGEST MAGNITUDE.
C
C     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. JUNE 1983.
C     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
C
C     **********
      INTEGER MCHEPS(4)
      INTEGER MINMAG(4)
      INTEGER MAXMAG(4)
      DOUBLE PRECISION DMACH(3)
      EQUIVALENCE (DMACH(1),MCHEPS(1))
      EQUIVALENCE (DMACH(2),MINMAG(1))
      EQUIVALENCE (DMACH(3),MAXMAG(1))
C
C     MACHINE CONSTANTS FOR THE IBM 360/370 SERIES,
C     THE AMDAHL 470/V6, THE ICL 2900, THE ITEL AS/6,
C     THE XEROX SIGMA 5/7/9 AND THE SEL SYSTEMS 85/86.
C
C        DATA MCHEPS(1),MCHEPS(2) / Z'34100000', Z'00000000' /
C        DATA MINMAG(1),MINMAG(2) / Z'00100000', Z'00000000' /
C        DATA MAXMAG(1),MAXMAG(2) / Z'7FFFFFFF', Z'FFFFFFFF' /
C
C    My IBM constants as of July 1989
c      DATA DMACH /1.0D-15,1.0D-78,1.0D75/
C    My VAX constants as of July 1989
C       DATA DMACH /1.0D-15,1.0D-38,1.0D38/
C    My DEC/ULTRIX constants as of July 1989
       DATA DMACH /1.0D-15,1.0D-300,1.0D300/
C
C     MACHINE CONSTANTS FOR THE HONEYWELL 600/6000 SERIES.
C
C     DATA MCHEPS(1),MCHEPS(2) / O606400000000, O000000000000 /
C     DATA MINMAG(1),MINMAG(2) / O402400000000, O000000000000 /
C     DATA MAXMAG(1),MAXMAG(2) / O376777777777, O777777777777 /
C
C     MACHINE CONSTANTS FOR THE CDC 6000/7000 SERIES.
C
C     DATA MCHEPS(1) / 15614000000000000000B /
C     DATA MCHEPS(2) / 15010000000000000000B /
C
C     DATA MINMAG(1) / 00604000000000000000B /
C     DATA MINMAG(2) / 00000000000000000000B /
C
C     DATA MAXMAG(1) / 37767777777777777777B /
C     DATA MAXMAG(2) / 37167777777777777777B /
C
C     MACHINE CONSTANTS FOR THE PDP-10 (KA PROCESSOR).
C
C     DATA MCHEPS(1),MCHEPS(2) / "114400000000, "000000000000 /
C     DATA MINMAG(1),MINMAG(2) / "033400000000, "000000000000 /
C     DATA MAXMAG(1),MAXMAG(2) / "377777777777, "344777777777 /
C
C     MACHINE CONSTANTS FOR THE PDP-10 (KI PROCESSOR).
C
C     DATA MCHEPS(1),MCHEPS(2) / "104400000000, "000000000000 /
C     DATA MINMAG(1),MINMAG(2) / "000400000000, "000000000000 /
C     DATA MAXMAG(1),MAXMAG(2) / "377777777777, "377777777777 /
C
C     MACHINE CONSTANTS FOR THE PDP-11.
C
C     DATA MCHEPS(1),MCHEPS(2) /   9472,      0 /
C     DATA MCHEPS(3),MCHEPS(4) /      0,      0 /
C
C     DATA MINMAG(1),MINMAG(2) /    128,      0 /
C     DATA MINMAG(3),MINMAG(4) /      0,      0 /
C
C     DATA MAXMAG(1),MAXMAG(2) /  32767,     -1 /
C     DATA MAXMAG(3),MAXMAG(4) /     -1,     -1 /
C
C     MACHINE CONSTANTS FOR THE BURROUGHS 6700/7700 SYSTEMS.
C
C     DATA MCHEPS(1) / O1451000000000000 /
C     DATA MCHEPS(2) / O0000000000000000 /
C
C     DATA MINMAG(1) / O1771000000000000 /
C     DATA MINMAG(2) / O7770000000000000 /
C
C     DATA MAXMAG(1) / O0777777777777777 /
C     DATA MAXMAG(2) / O7777777777777777 /
C
C     MACHINE CONSTANTS FOR THE BURROUGHS 5700 SYSTEM.
C
C     DATA MCHEPS(1) / O1451000000000000 /
C     DATA MCHEPS(2) / O0000000000000000 /
C
C     DATA MINMAG(1) / O1771000000000000 /
C     DATA MINMAG(2) / O0000000000000000 /
C
C     DATA MAXMAG(1) / O0777777777777777 /
C     DATA MAXMAG(2) / O0007777777777777 /
C
C     MACHINE CONSTANTS FOR THE BURROUGHS 1700 SYSTEM.
C
C     DATA MCHEPS(1) / ZCC6800000 /
C     DATA MCHEPS(2) / Z000000000 /
C
C     DATA MINMAG(1) / ZC00800000 /
C     DATA MINMAG(2) / Z000000000 /
C
C     DATA MAXMAG(1) / ZDFFFFFFFF /
C     DATA MAXMAG(2) / ZFFFFFFFFF /
C
C     MACHINE CONSTANTS FOR THE UNIVAC 1100 SERIES.
C
C     DATA MCHEPS(1),MCHEPS(2) / O170640000000, O000000000000 /
C     DATA MINMAG(1),MINMAG(2) / O000040000000, O000000000000 /
C     DATA MAXMAG(1),MAXMAG(2) / O377777777777, O777777777777 /
C
C     MACHINE CONSTANTS FOR THE DATA GENERAL ECLIPSE S/200.
C
C     NOTE - IT MAY BE APPROPRIATE TO INCLUDE THE FOLLOWING CARD -
C     STATIC DMACH(3)
C
C     DATA MINMAG/20K,3*0/,MAXMAG/77777K,3*177777K/
C     DATA MCHEPS/32020K,3*0/
C
C     MACHINE CONSTANTS FOR THE HARRIS 220.
C
C     DATA MCHEPS(1),MCHEPS(2) / '20000000, '00000334 /
C     DATA MINMAG(1),MINMAG(2) / '20000000, '00000201 /
C     DATA MAXMAG(1),MAXMAG(2) / '37777777, '37777577 /
C
C     MACHINE CONSTANTS FOR THE CRAY-1.
C
C     DATA MCHEPS(1) / 0376424000000000000000B /
C     DATA MCHEPS(2) / 0000000000000000000000B /
C
C     DATA MINMAG(1) / 0200034000000000000000B /
C     DATA MINMAG(2) / 0000000000000000000000B /
C
C     DATA MAXMAG(1) / 0577777777777777777777B /
C     DATA MAXMAG(2) / 0000007777777777777776B /
C
C     MACHINE CONSTANTS FOR THE PRIME 400.
C
C     DATA MCHEPS(1),MCHEPS(2) / :10000000000, :00000000123 /
C     DATA MINMAG(1),MINMAG(2) / :10000000000, :00000100000 /
C     DATA MAXMAG(1),MAXMAG(2) / :17777777777, :37777677776 /
C
C     MACHINE CONSTANTS FOR THE VAX-11.
C
c     DATA MCHEPS(1),MCHEPS(2) /   9472,  0 /
c     DATA MINMAG(1),MINMAG(2) /    128,  0 /
c     DATA MAXMAG(1),MAXMAG(2) / -32769, -1 /
C
      DPMPAR = DMACH(I)
      RETURN
C
C     LAST CARD OF FUNCTION DPMPAR.
C
      END
C     **************************************************************
      SUBROUTINE LMPAR(N,R,LDR,IPVT,DIAG,QTB,DELTA,PAR,X,SDIAG,WA1,
     *                 WA2)
      INTEGER N,LDR
      INTEGER IPVT(N)
      DOUBLE PRECISION DELTA,PAR
      DOUBLE PRECISION R(LDR,N),DIAG(N),QTB(N),X(N),SDIAG(N),WA1(N),
     *                 WA2(N)
C     ***************************************************************
C
C     SUBROUTINE LMPAR
C
C     GIVEN AN M BY N MATRIX A, AN N BY N NONSINGULAR DIAGONAL
C     MATRIX D, AN M-VECTOR B, AND A POSITIVE NUMBER DELTA,
C     THE PROBLEM IS TO DETERMINE A VALUE FOR THE PARAMETER
C     PAR SUCH THAT IF X SOLVES THE SYSTEM
C
C           A*X = B ,     SQRT(PAR)*D*X = 0 ,
C
C     IN THE LEAST SQUARES SENSE, AND DXNORM IS THE EUCLIDEAN
C     NORM OF D*X, THEN EITHER PAR IS ZERO AND
C
C           (DXNORM-DELTA) .LE. 0.1*DELTA ,
C
C     OR PAR IS POSITIVE AND
C
C           ABS(DXNORM-DELTA) .LE. 0.1*DELTA .
C
C     THIS SUBROUTINE COMPLETES THE SOLUTION OF THE PROBLEM
C     IF IT IS PROVIDED WITH THE NECESSARY INFORMATION FROM THE
C     QR FACTORIZATION, WITH COLUMN PIVOTING, OF A. THAT IS, IF
C     A*P = Q*R, WHERE P IS A PERMUTATION MATRIX, Q HAS ORTHOGONAL
C     COLUMNS, AND R IS AN UPPER TRIANGULAR MATRIX WITH DIAGONAL
C     ELEMENTS OF NONINCREASING MAGNITUDE, THEN LMPAR EXPECTS
C     THE FULL UPPER TRIANGLE OF R, THE PERMUTATION MATRIX P,
C     AND THE FIRST N COMPONENTS OF (Q TRANSPOSE)*B. ON OUTPUT
C     LMPAR ALSO PROVIDES AN UPPER TRIANGULAR MATRIX S SUCH THAT
C
C            T   T                   T
C           P *(A *A + PAR*D*D)*P = S *S .
C
C     S IS EMPLOYED WITHIN LMPAR AND MAY BE OF SEPARATE INTEREST.
C
C     ONLY A FEW ITERATIONS ARE GENERALLY NEEDED FOR CONVERGENCE
C     OF THE ALGORITHM. IF, HOWEVER, THE LIMIT OF 10 ITERATIONS
C     IS REACHED, THEN THE OUTPUT PAR WILL CONTAIN THE BEST
C     VALUE OBTAINED SO FAR.
C
C     THE SUBROUTINE STATEMENT IS
C
C       SUBROUTINE LMPAR(N,R,LDR,IPVT,DIAG,QTB,DELTA,PAR,X,SDIAG,
C                        WA1,WA2)
C
C     WHERE
C
C       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE ORDER OF R.
C
C       R IS AN N BY N ARRAY. ON INPUT THE FULL UPPER TRIANGLE
C         MUST CONTAIN THE FULL UPPER TRIANGLE OF THE MATRIX R.
C         ON OUTPUT THE FULL UPPER TRIANGLE IS UNALTERED, AND THE
C         STRICT LOWER TRIANGLE CONTAINS THE STRICT UPPER TRIANGLE
C         (TRANSPOSED) OF THE UPPER TRIANGULAR MATRIX S.
C
C       LDR IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN N
C         WHICH SPECIFIES THE LEADING DIMENSION OF THE ARRAY R.
C
C       IPVT IS AN INTEGER INPUT ARRAY OF LENGTH N WHICH DEFINES THE
C         PERMUTATION MATRIX P SUCH THAT A*P = Q*R. COLUMN J OF P
C         IS COLUMN IPVT(J) OF THE IDENTITY MATRIX.
C
C       DIAG IS AN INPUT ARRAY OF LENGTH N WHICH MUST CONTAIN THE
C         DIAGONAL ELEMENTS OF THE MATRIX D.
C
C       QTB IS AN INPUT ARRAY OF LENGTH N WHICH MUST CONTAIN THE FIRST
C         N ELEMENTS OF THE VECTOR (Q TRANSPOSE)*B.
C
C       DELTA IS A POSITIVE INPUT VARIABLE WHICH SPECIFIES AN UPPER
C         BOUND ON THE EUCLIDEAN NORM OF D*X.
C
C       PAR IS A NONNEGATIVE VARIABLE. ON INPUT PAR CONTAINS AN
C         INITIAL ESTIMATE OF THE LEVENBERG-MARQUARDT PARAMETER.
C         ON OUTPUT PAR CONTAINS THE FINAL ESTIMATE.
C
C       X IS AN OUTPUT ARRAY OF LENGTH N WHICH CONTAINS THE LEAST
C         SQUARES SOLUTION OF THE SYSTEM A*X = B, SQRT(PAR)*D*X = 0,
C         FOR THE OUTPUT PAR.
C
C       SDIAG IS AN OUTPUT ARRAY OF LENGTH N WHICH CONTAINS THE
C         DIAGONAL ELEMENTS OF THE UPPER TRIANGULAR MATRIX S.
C
C       WA1 AND WA2 ARE WORK ARRAYS OF LENGTH N.
C
C     SUBPROGRAMS CALLED
C
C       MINPACK-SUPPLIED ... DPMPAR,ENORM,QRSOLV
C
C       FORTRAN-SUPPLIED ... DABS,DMAX1,DMIN1,DSQRT
C
C     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
C     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
C
C     **********
      INTEGER I,ITER,J,JM1,JP1,K,L,NSING
      DOUBLE PRECISION DXNORM,DWARF,FP,GNORM,PARC,PARL,PARU,P1,P001,
     *                 SUM,TEMP,ZERO
      DOUBLE PRECISION DPMPAR,ENORM
      DATA P1,P001,ZERO /1.0D-1,1.0D-3,0.0D0/
C
C     DWARF IS THE SMALLEST POSITIVE MAGNITUDE.
C
      DWARF = DPMPAR(2)
C
C     COMPUTE AND STORE IN X THE GAUSS-NEWTON DIRECTION. IF THE
C     JACOBIAN IS RANK-DEFICIENT, OBTAIN A LEAST SQUARES SOLUTION.
C
      NSING = N
      DO 10 J = 1, N
         WA1(J) = QTB(J)
         IF (R(J,J) .EQ. ZERO .AND. NSING .EQ. N) NSING = J - 1
         IF (NSING .LT. N) WA1(J) = ZERO
   10    CONTINUE
      IF (NSING .LT. 1) GO TO 50
      DO 40 K = 1, NSING
         J = NSING - K + 1
         WA1(J) = WA1(J)/R(J,J)
         TEMP = WA1(J)
         JM1 = J - 1
         IF (JM1 .LT. 1) GO TO 30
         DO 20 I = 1, JM1
            WA1(I) = WA1(I) - R(I,J)*TEMP
   20       CONTINUE
   30    CONTINUE
   40    CONTINUE
   50 CONTINUE
      DO 60 J = 1, N
         L = IPVT(J)
         X(L) = WA1(J)
   60    CONTINUE
C
C     INITIALIZE THE ITERATION COUNTER.
C     EVALUATE THE FUNCTION AT THE ORIGIN, AND TEST
C     FOR ACCEPTANCE OF THE GAUSS-NEWTON DIRECTION.
C
      ITER = 0
      DO 70 J = 1, N
         WA2(J) = DIAG(J)*X(J)
   70    CONTINUE
      DXNORM = ENORM(N,WA2)
      FP = DXNORM - DELTA
      IF (FP .LE. P1*DELTA) GO TO 220
C
C     IF THE JACOBIAN IS NOT RANK DEFICIENT, THE NEWTON
C     STEP PROVIDES A LOWER BOUND, PARL, FOR THE ZERO OF
C     THE FUNCTION. OTHERWISE SET THIS BOUND TO ZERO.
C
      PARL = ZERO
      IF (NSING .LT. N) GO TO 120
      DO 80 J = 1, N
         L = IPVT(J)
         WA1(J) = DIAG(L)*(WA2(L)/DXNORM)
   80    CONTINUE
      DO 110 J = 1, N
         SUM = ZERO
         JM1 = J - 1
         IF (JM1 .LT. 1) GO TO 100
         DO 90 I = 1, JM1
            SUM = SUM + R(I,J)*WA1(I)
   90       CONTINUE
  100    CONTINUE
         WA1(J) = (WA1(J) - SUM)/R(J,J)
  110    CONTINUE
      TEMP = ENORM(N,WA1)
      PARL = ((FP/DELTA)/TEMP)/TEMP
  120 CONTINUE
C
C     CALCULATE AN UPPER BOUND, PARU, FOR THE ZERO OF THE FUNCTION.
C
      DO 140 J = 1, N
         SUM = ZERO
         DO 130 I = 1, J
            SUM = SUM + R(I,J)*QTB(I)
  130       CONTINUE
         L = IPVT(J)
         WA1(J) = SUM/DIAG(L)
  140    CONTINUE
      GNORM = ENORM(N,WA1)
      PARU = GNORM/DELTA
      IF (PARU .EQ. ZERO) PARU = DWARF/DMIN1(DELTA,P1)
C
C     IF THE INPUT PAR LIES OUTSIDE OF THE INTERVAL (PARL,PARU),
C     SET PAR TO THE CLOSER ENDPOINT.
C
      PAR = DMAX1(PAR,PARL)
      PAR = DMIN1(PAR,PARU)
      IF (PAR .EQ. ZERO) PAR = GNORM/DXNORM
C
C     BEGINNING OF AN ITERATION.
C
  150 CONTINUE
         ITER = ITER + 1
C
C        EVALUATE THE FUNCTION AT THE CURRENT VALUE OF PAR.
C
         IF (PAR .EQ. ZERO) PAR = DMAX1(DWARF,P001*PARU)
         TEMP = DSQRT(PAR)
         DO 160 J = 1, N
            WA1(J) = TEMP*DIAG(J)
  160       CONTINUE
         CALL QRSOLV(N,R,LDR,IPVT,WA1,QTB,X,SDIAG,WA2)
         DO 170 J = 1, N
            WA2(J) = DIAG(J)*X(J)
  170       CONTINUE
         DXNORM = ENORM(N,WA2)
         TEMP = FP
         FP = DXNORM - DELTA
C
C        IF THE FUNCTION IS SMALL ENOUGH, ACCEPT THE CURRENT VALUE
C        OF PAR. ALSO TEST FOR THE EXCEPTIONAL CASES WHERE PARL
C        IS ZERO OR THE NUMBER OF ITERATIONS HAS REACHED 10.
C
         IF (DABS(FP) .LE. P1*DELTA
     *       .OR. PARL .EQ. ZERO .AND. FP .LE. TEMP
     *            .AND. TEMP .LT. ZERO .OR. ITER .EQ. 10) GO TO 220
C
C        COMPUTE THE NEWTON CORRECTION.
C
         DO 180 J = 1, N
            L = IPVT(J)
            WA1(J) = DIAG(L)*(WA2(L)/DXNORM)
  180       CONTINUE
         DO 210 J = 1, N
            WA1(J) = WA1(J)/SDIAG(J)
            TEMP = WA1(J)
            JP1 = J + 1
            IF (N .LT. JP1) GO TO 200
            DO 190 I = JP1, N
               WA1(I) = WA1(I) - R(I,J)*TEMP
  190          CONTINUE
  200       CONTINUE
  210       CONTINUE
         TEMP = ENORM(N,WA1)
         PARC = ((FP/DELTA)/TEMP)/TEMP
C
C        DEPENDING ON THE SIGN OF THE FUNCTION, UPDATE PARL OR PARU.
C
         IF (FP .GT. ZERO) PARL = DMAX1(PARL,PAR)
         IF (FP .LT. ZERO) PARU = DMIN1(PARU,PAR)
C
C        COMPUTE AN IMPROVED ESTIMATE FOR PAR.
C
         PAR = DMAX1(PARL,PAR+PARC)
C
C        END OF AN ITERATION.
C
         GO TO 150
  220 CONTINUE
C
C     TERMINATION.
C
      IF (ITER .EQ. 0) PAR = ZERO
      RETURN
C
C     LAST CARD OF SUBROUTINE LMPAR.
C
      END
C     ***********************
      SUBROUTINE QRFAC(M,N,A,LDA,PIVOT,IPVT,LIPVT,RDIAG,ACNORM,WA)
      INTEGER M,N,LDA,LIPVT
      INTEGER IPVT(LIPVT)
      LOGICAL PIVOT
      DOUBLE PRECISION A(LDA,N),RDIAG(N),ACNORM(N),WA(N)
C     **************************************************************
C
C     SUBROUTINE QRFAC
C
C     THIS SUBROUTINE USES HOUSEHOLDER TRANSFORMATIONS WITH COLUMN
C     PIVOTING (OPTIONAL) TO COMPUTE A QR FACTORIZATION OF THE
C     M BY N MATRIX A. THAT IS, QRFAC DETERMINES AN ORTHOGONAL
C     MATRIX Q, A PERMUTATION MATRIX P, AND AN UPPER TRAPEZOIDAL
C     MATRIX R WITH DIAGONAL ELEMENTS OF NONINCREASING MAGNITUDE,
C     SUCH THAT A*P = Q*R. THE HOUSEHOLDER TRANSFORMATION FOR
C     COLUMN K, K = 1,2,...,MIN(M,N), IS OF THE FORM
C
C                           T
C           I - (1/U(K))*U*U
C
C     WHERE U HAS ZEROS IN THE FIRST K-1 POSITIONS. THE FORM OF
C     THIS TRANSFORMATION AND THE METHOD OF PIVOTING FIRST
C     APPEARED IN THE CORRESPONDING LINPACK SUBROUTINE.
C
C     THE SUBROUTINE STATEMENT IS
C
C       SUBROUTINE QRFAC(M,N,A,LDA,PIVOT,IPVT,LIPVT,RDIAG,ACNORM,WA)
C
C     WHERE
C
C       M IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
C         OF ROWS OF A.
C
C       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
C         OF COLUMNS OF A.
C
C       A IS AN M BY N ARRAY. ON INPUT A CONTAINS THE MATRIX FOR
C         WHICH THE QR FACTORIZATION IS TO BE COMPUTED. ON OUTPUT
C         THE STRICT UPPER TRAPEZOIDAL PART OF A CONTAINS THE STRICT
C         UPPER TRAPEZOIDAL PART OF R, AND THE LOWER TRAPEZOIDAL
C         PART OF A CONTAINS A FACTORED FORM OF Q (THE NON-TRIVIAL
C         ELEMENTS OF THE U VECTORS DESCRIBED ABOVE).
C
C       LDA IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN M
C         WHICH SPECIFIES THE LEADING DIMENSION OF THE ARRAY A.
C
C       PIVOT IS A LOGICAL INPUT VARIABLE. IF PIVOT IS SET TRUE,
C         THEN COLUMN PIVOTING IS ENFORCED. IF PIVOT IS SET FALSE,
C         THEN NO COLUMN PIVOTING IS DONE.
C
C       IPVT IS AN INTEGER OUTPUT ARRAY OF LENGTH LIPVT. IPVT
C         DEFINES THE PERMUTATION MATRIX P SUCH THAT A*P = Q*R.
C         COLUMN J OF P IS COLUMN IPVT(J) OF THE IDENTITY MATRIX.
C         IF PIVOT IS FALSE, IPVT IS NOT REFERENCED.
C
C       LIPVT IS A POSITIVE INTEGER INPUT VARIABLE. IF PIVOT IS FALSE,
C         THEN LIPVT MAY BE AS SMALL AS 1. IF PIVOT IS TRUE, THEN
C         LIPVT MUST BE AT LEAST N.
C
C       RDIAG IS AN OUTPUT ARRAY OF LENGTH N WHICH CONTAINS THE
C         DIAGONAL ELEMENTS OF R.
C
C       ACNORM IS AN OUTPUT ARRAY OF LENGTH N WHICH CONTAINS THE
C         NORMS OF THE CORRESPONDING COLUMNS OF THE INPUT MATRIX A.
C         IF THIS INFORMATION IS NOT NEEDED, THEN ACNORM CAN COINCIDE
C         WITH RDIAG.
C
C       WA IS A WORK ARRAY OF LENGTH N. IF PIVOT IS FALSE, THEN WA
C         CAN COINCIDE WITH RDIAG.
C
C     SUBPROGRAMS CALLED
C
C       MINPACK-SUPPLIED ... DPMPAR,ENORM
C
C       FORTRAN-SUPPLIED ... DMAX1,DSQRT,MIN0
C
C     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
C     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
C
C     **********
      INTEGER I,J,JP1,K,KMAX,MINMN
      DOUBLE PRECISION AJNORM,EPSMCH,ONE,P05,SUM,TEMP,ZERO
      DOUBLE PRECISION DPMPAR,ENORM
      DATA ONE,P05,ZERO /1.0D0,5.0D-2,0.0D0/
C
C     EPSMCH IS THE MACHINE PRECISION.
C
      EPSMCH = DPMPAR(1)
C
C     COMPUTE THE INITIAL COLUMN NORMS AND INITIALIZE SEVERAL ARRAYS.
C
      DO 10 J = 1, N
         ACNORM(J) = ENORM(M,A(1,J))
         RDIAG(J) = ACNORM(J)
         WA(J) = RDIAG(J)
         IF (PIVOT) IPVT(J) = J
   10    CONTINUE
C
C     REDUCE A TO R WITH HOUSEHOLDER TRANSFORMATIONS.
C
      MINMN = MIN0(M,N)
      DO 110 J = 1, MINMN
         IF (.NOT.PIVOT) GO TO 40
C
C        BRING THE COLUMN OF LARGEST NORM INTO THE PIVOT POSITION.
C
         KMAX = J
         DO 20 K = J, N
            IF (RDIAG(K) .GT. RDIAG(KMAX)) KMAX = K
   20       CONTINUE
         IF (KMAX .EQ. J) GO TO 40
         DO 30 I = 1, M
            TEMP = A(I,J)
            A(I,J) = A(I,KMAX)
            A(I,KMAX) = TEMP
   30       CONTINUE
         RDIAG(KMAX) = RDIAG(J)
         WA(KMAX) = WA(J)
         K = IPVT(J)
         IPVT(J) = IPVT(KMAX)
         IPVT(KMAX) = K
   40    CONTINUE
C
C        COMPUTE THE HOUSEHOLDER TRANSFORMATION TO REDUCE THE
C        J-TH COLUMN OF A TO A MULTIPLE OF THE J-TH UNIT VECTOR.
C
         AJNORM = ENORM(M-J+1,A(J,J))
         IF (AJNORM .EQ. ZERO) GO TO 100
         IF (A(J,J) .LT. ZERO) AJNORM = -AJNORM
         DO 50 I = J, M
            A(I,J) = A(I,J)/AJNORM
   50       CONTINUE
         A(J,J) = A(J,J) + ONE
C
C        APPLY THE TRANSFORMATION TO THE REMAINING COLUMNS
C        AND UPDATE THE NORMS.
C
         JP1 = J + 1
         IF (N .LT. JP1) GO TO 100
         DO 90 K = JP1, N
            SUM = ZERO
            DO 60 I = J, M
               SUM = SUM + A(I,J)*A(I,K)
   60          CONTINUE
            TEMP = SUM/A(J,J)
            DO 70 I = J, M
               A(I,K) = A(I,K) - TEMP*A(I,J)
   70          CONTINUE
            IF (.NOT.PIVOT .OR. RDIAG(K) .EQ. ZERO) GO TO 80
            TEMP = A(J,K)/RDIAG(K)
            RDIAG(K) = RDIAG(K)*DSQRT(DMAX1(ZERO,ONE-TEMP**2))
            IF (P05*(RDIAG(K)/WA(K))**2 .GT. EPSMCH) GO TO 80
            RDIAG(K) = ENORM(M-J,A(JP1,K))
            WA(K) = RDIAG(K)
   80       CONTINUE
   90       CONTINUE
  100    CONTINUE
         RDIAG(J) = -AJNORM
  110    CONTINUE
      RETURN
C
C     LAST CARD OF SUBROUTINE QRFAC.
C
      END
C     **************************************************************
      SUBROUTINE QRSOLV(N,R,LDR,IPVT,DIAG,QTB,X,SDIAG,WA)
      INTEGER N,LDR
      INTEGER IPVT(N)
      DOUBLE PRECISION R(LDR,N),DIAG(N),QTB(N),X(N),SDIAG(N),WA(N)
C     ***************************************************************
C
C     SUBROUTINE QRSOLV
C
C     GIVEN AN M BY N MATRIX A, AN N BY N DIAGONAL MATRIX D,
C     AND AN M-VECTOR B, THE PROBLEM IS TO DETERMINE AN X WHICH
C     SOLVES THE SYSTEM
C
C           A*X = B ,     D*X = 0 ,
C
C     IN THE LEAST SQUARES SENSE.
C
C     THIS SUBROUTINE COMPLETES THE SOLUTION OF THE PROBLEM
C     IF IT IS PROVIDED WITH THE NECESSARY INFORMATION FROM THE
C     QR FACTORIZATION, WITH COLUMN PIVOTING, OF A. THAT IS, IF
C     A*P = Q*R, WHERE P IS A PERMUTATION MATRIX, Q HAS ORTHOGONAL
C     COLUMNS, AND R IS AN UPPER TRIANGULAR MATRIX WITH DIAGONAL
C     ELEMENTS OF NONINCREASING MAGNITUDE, THEN QRSOLV EXPECTS
C     THE FULL UPPER TRIANGLE OF R, THE PERMUTATION MATRIX P,
C     AND THE FIRST N COMPONENTS OF (Q TRANSPOSE)*B. THE SYSTEM
C     A*X = B, D*X = 0, IS THEN EQUIVALENT TO
C
C                  T       T
C           R*Z = Q *B ,  P *D*P*Z = 0 ,
C
C     WHERE X = P*Z. IF THIS SYSTEM DOES NOT HAVE FULL RANK,
C     THEN A LEAST SQUARES SOLUTION IS OBTAINED. ON OUTPUT QRSOLV
C     ALSO PROVIDES AN UPPER TRIANGULAR MATRIX S SUCH THAT
C
C            T   T               T
C           P *(A *A + D*D)*P = S *S .
C
C     S IS COMPUTED WITHIN QRSOLV AND MAY BE OF SEPARATE INTEREST.
C
C     THE SUBROUTINE STATEMENT IS
C
C       SUBROUTINE QRSOLV(N,R,LDR,IPVT,DIAG,QTB,X,SDIAG,WA)
C
C     WHERE
C
C       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE ORDER OF R.
C
C       R IS AN N BY N ARRAY. ON INPUT THE FULL UPPER TRIANGLE
C         MUST CONTAIN THE FULL UPPER TRIANGLE OF THE MATRIX R.
C         ON OUTPUT THE FULL UPPER TRIANGLE IS UNALTERED, AND THE
C         STRICT LOWER TRIANGLE CONTAINS THE STRICT UPPER TRIANGLE
C         (TRANSPOSED) OF THE UPPER TRIANGULAR MATRIX S.
C
C       LDR IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN N
C         WHICH SPECIFIES THE LEADING DIMENSION OF THE ARRAY R.
C
C       IPVT IS AN INTEGER INPUT ARRAY OF LENGTH N WHICH DEFINES THE
C         PERMUTATION MATRIX P SUCH THAT A*P = Q*R. COLUMN J OF P
C         IS COLUMN IPVT(J) OF THE IDENTITY MATRIX.
C
C       DIAG IS AN INPUT ARRAY OF LENGTH N WHICH MUST CONTAIN THE
C         DIAGONAL ELEMENTS OF THE MATRIX D.
C
C       QTB IS AN INPUT ARRAY OF LENGTH N WHICH MUST CONTAIN THE FIRST
C         N ELEMENTS OF THE VECTOR (Q TRANSPOSE)*B.
C
C       X IS AN OUTPUT ARRAY OF LENGTH N WHICH CONTAINS THE LEAST
C         SQUARES SOLUTION OF THE SYSTEM A*X = B, D*X = 0.
C
C       SDIAG IS AN OUTPUT ARRAY OF LENGTH N WHICH CONTAINS THE
C         DIAGONAL ELEMENTS OF THE UPPER TRIANGULAR MATRIX S.
C
C       WA IS A WORK ARRAY OF LENGTH N.
C
C     SUBPROGRAMS CALLED
C
C       FORTRAN-SUPPLIED ... DABS,DSQRT
C
C     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
C     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
C
C     **********
      INTEGER I,J,JP1,K,KP1,L,NSING
      DOUBLE PRECISION COS,COTAN,P5,P25,QTBPJ,SIN,SUM,TAN,TEMP,ZERO
      DATA P5,P25,ZERO /5.0D-1,2.5D-1,0.0D0/
C
C     COPY R AND (Q TRANSPOSE)*B TO PRESERVE INPUT AND INITIALIZE S.
C     IN PARTICULAR, SAVE THE DIAGONAL ELEMENTS OF R IN X.
C
      DO 20 J = 1, N
         DO 10 I = J, N
            R(I,J) = R(J,I)
   10       CONTINUE
         X(J) = R(J,J)
         WA(J) = QTB(J)
   20    CONTINUE
C
C     ELIMINATE THE DIAGONAL MATRIX D USING A GIVENS ROTATION.
C
      DO 100 J = 1, N
C
C        PREPARE THE ROW OF D TO BE ELIMINATED, LOCATING THE
C        DIAGONAL ELEMENT USING P FROM THE QR FACTORIZATION.
C
         L = IPVT(J)
         IF (DIAG(L) .EQ. ZERO) GO TO 90
         DO 30 K = J, N
            SDIAG(K) = ZERO
   30       CONTINUE
         SDIAG(J) = DIAG(L)
C
C        THE TRANSFORMATIONS TO ELIMINATE THE ROW OF D
C        MODIFY ONLY A SINGLE ELEMENT OF (Q TRANSPOSE)*B
C        BEYOND THE FIRST N, WHICH IS INITIALLY ZERO.
C
         QTBPJ = ZERO
         DO 80 K = J, N
C
C           DETERMINE A GIVENS ROTATION WHICH ELIMINATES THE
C           APPROPRIATE ELEMENT IN THE CURRENT ROW OF D.
C
            IF (SDIAG(K) .EQ. ZERO) GO TO 70
            IF (DABS(R(K,K)) .GE. DABS(SDIAG(K))) GO TO 40
               COTAN = R(K,K)/SDIAG(K)
               SIN = P5/DSQRT(P25+P25*COTAN**2)
               COS = SIN*COTAN
               GO TO 50
   40       CONTINUE
               TAN = SDIAG(K)/R(K,K)
               COS = P5/DSQRT(P25+P25*TAN**2)
               SIN = COS*TAN
   50       CONTINUE
C
C           COMPUTE THE MODIFIED DIAGONAL ELEMENT OF R AND
C           THE MODIFIED ELEMENT OF ((Q TRANSPOSE)*B,0).
C
            R(K,K) = COS*R(K,K) + SIN*SDIAG(K)
            TEMP = COS*WA(K) + SIN*QTBPJ
            QTBPJ = -SIN*WA(K) + COS*QTBPJ
            WA(K) = TEMP
C
C           ACCUMULATE THE TRANFORMATION IN THE ROW OF S.
C
            KP1 = K + 1
            IF (N .LT. KP1) GO TO 70
            DO 60 I = KP1, N
               TEMP = COS*R(I,K) + SIN*SDIAG(I)
               SDIAG(I) = -SIN*R(I,K) + COS*SDIAG(I)
               R(I,K) = TEMP
   60          CONTINUE
   70       CONTINUE
   80       CONTINUE
   90    CONTINUE
C
C        STORE THE DIAGONAL ELEMENT OF S AND RESTORE
C        THE CORRESPONDING DIAGONAL ELEMENT OF R.
C
         SDIAG(J) = R(J,J)
         R(J,J) = X(J)
  100    CONTINUE
C
C     SOLVE THE TRIANGULAR SYSTEM FOR Z. IF THE SYSTEM IS
C     SINGULAR, THEN OBTAIN A LEAST SQUARES SOLUTION.
C
      NSING = N
      DO 110 J = 1, N
         IF (SDIAG(J) .EQ. ZERO .AND. NSING .EQ. N) NSING = J - 1
         IF (NSING .LT. N) WA(J) = ZERO
  110    CONTINUE
      IF (NSING .LT. 1) GO TO 150
      DO 140 K = 1, NSING
         J = NSING - K + 1
         SUM = ZERO
         JP1 = J + 1
         IF (NSING .LT. JP1) GO TO 130
         DO 120 I = JP1, NSING
            SUM = SUM + R(I,J)*WA(I)
  120       CONTINUE
  130    CONTINUE
         WA(J) = (WA(J) - SUM)/SDIAG(J)
  140    CONTINUE
  150 CONTINUE
C
C     PERMUTE THE COMPONENTS OF Z BACK TO COMPONENTS OF X.
C
      DO 160 J = 1, N
         L = IPVT(J)
         X(L) = WA(J)
  160    CONTINUE
      RETURN
C
C     LAST CARD OF SUBROUTINE QRSOLV.
C
      END



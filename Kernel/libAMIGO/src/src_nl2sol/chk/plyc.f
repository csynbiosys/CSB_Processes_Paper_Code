C$TEST PLYC
C TO RUN AS A MAIN PROGRAM REMOVE NEXT LINE
      SUBROUTINE PLYC
C***********************************************************************
C
C  TEST OF THE PORT ORTHOGONAL POLYNOMIAL ROUTINES
C
C***********************************************************************
      INTEGER IWRITE
      REAL COEF1(1001),COEF2(1001),A(1001),B(1001),C(1001),X,X0,X1,Y0,
     1Y1,Y2,RHO
      DOUBLE PRECISION T0(2),T1(2),T2(2)
      REAL TCHBP,ORTHP,TRIGP
      IWRITE = I1MACH(2)
      GO TO 1
 1    WRITE(IWRITE,5)
 5    FORMAT(10X,11HTCHEBYCHEFF,14X,5HTCHBP,19X,5HORTHP)
      DO 23000 I=1,20
      A(I) = 2.0
      B(I) = 0.0
      C(I) = -1.0
23000 CONTINUE
      A(1) = 1.0
      DO 23002 I=1,20
      DO 23004 K=1,I
      COEF1(K) = 0.0
23004 CONTINUE
      COEF1(I) = 1.0
      X=-1.0
23006 IF(.NOT.(X.LE.1.0))GOTO 23008
      IF(.NOT.(I.EQ.1))GOTO 23009
      Y0 = 1.0
      GOTO 23010
23009 CONTINUE
      IF(.NOT.(I.EQ.2))GOTO 23011
      Y0 = X
      GOTO 23012
23011 CONTINUE
      Y2 = 1.0
      Y1 = X
      DO 23013 K=3,I
      Y0 = 2.0*X*Y1 - Y2
      Y2 = Y1
      Y1 = Y0
23013 CONTINUE
23012 CONTINUE
23010 CONTINUE
      IM1 = I-1
      Y1 = TCHBP(IM1,COEF1,X,-1.0,1.0)
      Y2 = ORTHP(IM1,COEF1,X,A,B,C)
      WRITE(IWRITE,10) IM1,Y0,Y1,Y2
 10   FORMAT(I5,1P4E25.17)
       X=X+0.25
      GOTO 23006
23008 CONTINUE
23002 CONTINUE
 15   WRITE(IWRITE,20)
20    FORMAT(10X,8HLEGENDRE,17X,5HORTHP)
      A(1) = 1.0
      B(1) = 0.0
      C(1) = 0.0
      DO 23015 I=1,19
      A(I+1) = FLOAT(2*I+1)/FLOAT(I+1)
      B(I+1) = 0.0
      C(I+1) = -FLOAT(I)/FLOAT(I+1)
23015 CONTINUE
      DO 23017 I=1,20
      DO 23019 K=1,20
      COEF1(K) = 0.0
23019 CONTINUE
      COEF1(I) = 1.0
      X=-1.0
23021 IF(.NOT.(X.LE.1.0))GOTO 23023
      IF(.NOT.(I.EQ.1))GOTO 23024
      Y0 = 1.0
      GOTO 23025
23024 CONTINUE
      IF(.NOT.(I.EQ.2))GOTO 23026
      Y0 = X
      GOTO 23027
23026 CONTINUE
      Y2 = 1.0
      Y1 = X
      DO 23028 K=3,I
      Y0 = A(K-1)*X*Y1 + C(K-1)*Y2
      Y2 = Y1
      Y1 = Y0
23028 CONTINUE
23027 CONTINUE
23025 CONTINUE
      IM1 = I-1
      Y1 = ORTHP(IM1,COEF1,X,A,B,C)
      WRITE(IWRITE,10) IM1,Y0,Y1
       X=X+0.25
      GOTO 23021
23023 CONTINUE
23017 CONTINUE
25    WRITE(IWRITE,30)
30    FORMAT(10X,8HLAGUERRE,17X,5HORTHP)
      A(1) = -1.0
      B(1) = 1.0
      C(1) = 0.0
      DO 23030 I=1,19
      A(I+1) = -1.0
      B(I+1) = FLOAT(2*I+1)
      C(I+1) = -FLOAT(I*I)
23030 CONTINUE
      DO 23032 I=1,20
      DO 23034 K=1,20
      COEF1(K) = 0.0
23034 CONTINUE
      COEF1(I) = 1.0
      X=0.0
23036 IF(.NOT.(X.LE.1.0D1))GOTO 23038
      IF(.NOT.(I.EQ.1))GOTO 23039
      Y0 = 1.0
      GOTO 23040
23039 CONTINUE
      IF(.NOT.(I.EQ.2))GOTO 23041
      Y0 = -X + 1.0
      GOTO 23042
23041 CONTINUE
      Y2 = 1.0
      Y1 = -X + 1.0
      DO 23043 K=3,I
      Y0 = (A(K-1)*X+B(K-1))*Y1 + C(K-1)*Y2
      Y2 = Y1
      Y1 = Y0
23043 CONTINUE
23042 CONTINUE
23040 CONTINUE
      IM1 = I-1
      Y1 = ORTHP(IM1,COEF1,X,A,B,C)
      WRITE(IWRITE,10) IM1,Y0,Y1
       X=X+0.5
      GOTO 23036
23038 CONTINUE
23032 CONTINUE
35    WRITE(IWRITE,40)
40    FORMAT(10X,3HCOS,22X,3HSIN,22X,5HTRIGP,19X,5HTRIGP)
      DO 23045 I=1,20
      COEF1(I) = 0.0
      COEF2(I) = 0.0
23045 CONTINUE
      DO 23047 I=1,20
      IM1 = I-1
      X=-1.0
23049 IF(.NOT.(X.LE.1.0))GOTO 23051
      X0 = COS(FLOAT(IM1)*X)
      X1 = SIN(FLOAT(IM1)*X)
      COEF1(I) = 1.0
      Y1 = TRIGP(IM1,COEF1,COEF2,X)
      COEF1(I) = 0.0
      COEF2(I) = 1.0
      Y2 = TRIGP(IM1,COEF1,COEF2,X)
      COEF2(I) = 0.0
      WRITE(IWRITE,10) IM1,X0,X1,Y1,Y2
       X=X+0.25
      GOTO 23049
23051 CONTINUE
23047 CONTINUE
50    CONTINUE
      RHO=1.0
23052 IF(.NOT.(RHO.GE.0.5E0))GOTO 23054
      WRITE(IWRITE,55) RHO
55    FORMAT(F5.2,5X,7HCOS SUM,18X,7HSIN SUM,18X,5HTRIGP,19X,5HTRIGP)
      I=10
23055 IF(.NOT.(I.LE.1000))GOTO 23057
      IM1 = I-1
      X=-1.0
23058 IF(.NOT.(X.LE.1.0))GOTO 23060
      T0(1) = 1.0 - RHO**(I)*COS(FLOAT(I)*X)
      T0(2) = -RHO**(I)*SIN(FLOAT(I)*X)
      T1(1) = 1.0 - RHO*COS(X)
      T1(2) = -RHO*SIN(X)
      IF(.NOT.(T1(1) .EQ. 0.0 .AND. T1(2) .EQ. 0.0))GOTO 23061
      T2(1) =FLOAT(I)
      T2(2) = 0.0
      GOTO 23062
23061 CONTINUE
      CALL CDDIV(T0,T1,T2)
23062 CONTINUE
      COEF1(1) = 1.0
      COEF2(1) = 0.0
      DO 23063 J=2,I
      COEF1(J) = RHO*COEF1(J-1)
      COEF2(J) = 0.0
23063 CONTINUE
      Y0 = TRIGP(IM1,COEF1,COEF2,X)
      COEF1(1) = 0.0
      COEF2(1) = 1.0
      DO 23065 J=2,I
      COEF1(J) = 0.0
      COEF2(J) = RHO*COEF2(J-1)
23065 CONTINUE
      COEF2(1) = 0.0
      Y1 = TRIGP(IM1,COEF1,COEF2,X)
      WRITE(IWRITE,10) IM1,T2(1),T2(2),Y0,Y1
       X=X+0.25E0
      GOTO 23058
23060 CONTINUE
       I=I*10
      GOTO 23055
23057 CONTINUE
       RHO=RHO-0.25E0
      GOTO 23052
23054 CONTINUE
      STOP
      END
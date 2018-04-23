      SUBROUTINE SRECAP(IWUNIT)
C
C  WRITES LOUT, LNOW, LUSED AND LMAX ON LOGICAL UNIT IWUNIT.
C
      COMMON /CSTAK/DSTAK
C
      DOUBLE PRECISION DSTAK(500)
      INTEGER ISTAK(1000)
      INTEGER ISTATS(4)
      LOGICAL INIT
C
      EQUIVALENCE (DSTAK(1),ISTAK(1))
      EQUIVALENCE (ISTAK(1),ISTATS(1))
C
      DATA INIT/.TRUE./
C
      CALL I0TK01
      IF (INIT) CALL I0TK00(INIT,500,4)
C
      WRITE(IWUNIT,9000) ISTATS
C
 9000 FORMAT(20H0STACK STATISTICS...//
     1       24H OUTSTANDING ALLOCATIONS,I8/
     1       24H CURRENT ACTIVE LENGTH  ,I8/
     3       24H MAXIMUM LENGTH USED    ,I8/
     4       24H MAXIMUM LENGTH ALLOWED ,I8)
C
      RETURN
C
      END
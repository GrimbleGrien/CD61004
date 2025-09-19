PROGRAM VEC_ADD_SECTIONS
    use omp_lib
    implicit none

    INTEGER N, I
    PARAMETER (N=1000)
    REAL A(N), B(N), C(N), D(N)

! Some initializations
    DO I = 1, N
      A(I) = I * 1.5
      B(I) = I + 22.35
    ENDDO

!$OMP PARALLEL SHARED(A,B,C,D), PRIVATE(I)

!$OMP SECTIONS

!$OMP SECTION
    DO I = 1, N
       C(I) = A(I) + B(I)
    ENDDO

!$OMP SECTION
    DO I = 1, N
       D(I) = A(I) * B(I)
    ENDDO

!$OMP END SECTIONS NOWAIT

!$OMP END PARALLEL

END


! !$OMP SECTIONS [clause ...] 
!                PRIVATE (list) 
!                FIRSTPRIVATE (list) 
!                LASTPRIVATE (list) 
!                REDUCTION (operator | intrinsic : list) 

! !$OMP  SECTION 

!    block

! !$OMP  SECTION 

!     block 

! !$OMP END SECTIONS  [ NOWAIT ]
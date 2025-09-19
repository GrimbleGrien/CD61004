! non-trivial example of omp critical
PROGRAM Parallel_Hello
    USE OMP_LIB
    IMPLICIT NONE
    
    INTEGER :: thread_id

    !$OMP PARALLEL
        ! $OMP CRITICAL
            thread_id = OMP_GET_THREAD_NUM()
            PRINT *, "Hello from process: ", thread_id
        ! $OMP END CRITICAL
    !$OMP END PARALLEL

END PROGRAM Parallel_Hello

! critical ensures only one thread at a time 
! touches enclosed code during execution

!  Hello from process:            0
!  Hello from process:            1
!  Hello from process:            3
!  Hello from process:            2

! without critical

!  Hello from process:            3
!  Hello from process:            3
!  Hello from process:            3
!  Hello from process:            3
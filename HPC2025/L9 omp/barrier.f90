! minimal barrier code (ignores good practices but works)
PROGRAM Parallel_Ordered_Hello
    USE OMP_LIB
    
    INTEGER :: thread_id
    
    !$OMP PARALLEL PRIVATE(thread_id)
        thread_id = OMP_GET_THREAD_NUM()
    
        DO i=0,OMP_GET_NUM_THREADS()
            IF (i == thread_id) THEN
                PRINT *, "Hello from process: ", thread_id
            END IF
            !$OMP BARRIER
        END DO
    !$OMP END PARALLEL
    
END


! after each iteration all threads wait at 
! barrier for slowest thread (one that prints)

!  Hello from process:            0
!  Hello from process:            1
!  Hello from process:            2
!  Hello from process:            3

! without barrier
!  Hello from process:            2
!  Hello from process:            0
!  Hello from process:            3
!  Hello from process:            1
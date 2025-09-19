program hello
    use omp_lib
    implicit none
    integer :: msg, id
    msg=10
    !$omp parallel private(id)
    !$omp master
    call sleep(1)
    msg=20
    !$omp end master
    ! $omp barrier
    id = omp_get_thread_num()
    write(*,*) id, "==>", msg
    !$omp end parallel

end program hello

! msg private
! 0 ==>          20
! 2 ==> -1079392575
! 3 ==> -1079392575
! 1 ==> -1079392575

! msg shared
! 0 ==>          20
! 2 ==>          20
! 1 ==>          20
! 3 ==>          20

! msg shared master sleep
! sleep before assigning
! 2 ==>          10
! 1 ==>          10
! 3 ==>          10
! 0 ==>          20
! use barrier to ensure broadcast
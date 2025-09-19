! program hello
!     use omp_lib
!     implicit none

!     !$omp parallel
!     write(*,*) "hello"
!     !$omp end parallel

! end program hello

! hello
! hello
! hello
! hello

program hello_world
    use omp_lib
    implicit none
    integer :: num_threads, thread_id

    num_threads = omp_get_max_threads()
    thread_id = 42
    !$omp parallel private(thread_id)
      thread_id = omp_get_thread_num()
      write(*,*) thread_id, '/', num_threads
    !$omp end parallel
    write(*,*) thread_id, '/', num_threads
    ! end parallel section 
end program hello_world 


! var init inside directive are scoped inside directive only.
! !$omp parallel shared(svar1, svar2,...) private(pvar1, pvar1, ...)
! each core spawns 2 threads so default 12 threads

! init
!  2 /           4
!  3 /           4
!  0 /           4
!  1 /           4
! 42 /           4

! not init
!            1 /           4
!            2 /           4
!            0 /           4
!            3 /           4
!   -918537536 /           4
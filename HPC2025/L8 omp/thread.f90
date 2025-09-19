program hello
    use omp_lib
    implicit none

    ! integer::id

    !$omp parallel
    write(*,"(a,i2,a,i2)") "hello ", omp_get_thread_num(), " / ", omp_get_num_threads()
    !$omp end parallel

end program hello

! hello  0 /  4
! hello  2 /  4
! hello  3 /  4
! hello  1 /  4

program hello_world
    use omp_lib
    implicit none
    integer :: num_threads, thread_id
    num_threads = omp_get_max_threads()

    !$omp parallel private(thread_id)
    thread_id = omp_get_thread_num()
    write(*,*) 'id', thread_id, '/', num_threads
    !$omp end parallel

    ! thread_id returns garbage outside omp block
    write(*,*) 'Hello, from thread', thread_id, '/', num_threads

end program hello_world

! id           0 /           4
! id           2 /           4
! id           3 /           4
! id           1 /           4
! Hello, from thread         110 /           4

program hello
    use omp_lib
    implicit none
    integer :: msg, id

    !$omp parallel private(msg,id)
    !$omp master
    msg=20
    !$omp end master
    id = omp_get_thread_num()
    write(*,*) id, "==>", msg
    !$omp end parallel

end program hello

! correct output of private id
! 0 ==>          20
! 1 ==>           0
! 3 ==>           0
! 2 ==>           0

! if id not made private (separate memory) then all threads 
! modify same memory location. hence all threads see value
! set be last thread ==> RACE CONDITION

! wrong output of shared id
! 3 ==>          20
! 3 ==>           0
! 3 ==>           0
! 3 ==>           0

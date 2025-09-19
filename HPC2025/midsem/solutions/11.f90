program seq
    use omp_lib
    implicit none

    integer:: i,np
    np = omp_get_max_threads()
    print *, "total  ", np
    !$omp parallel
    do i=0,np-1
        if(i==omp_get_thread_num()) then
            print *, "thread ", i
        endif
        !$omp barrier
    enddo
    !$omp end parallel
end

! total             4
! thread            0
! thread            1
! thread            2
! thread            3

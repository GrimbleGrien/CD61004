program test_rank_print
    implicit none
    include 'mpif.h'
    integer :: pid, numproc, ierr

    call MPI_INIT(ierr)
    call MPI_COMM_SIZE(MPI_COMM_WORLD, numproc, ierr)
    call MPI_COMM_RANK(MPI_COMM_WORLD, pid, ierr)

    if (pid == 0) then
        print *, "Hello from only rank 0 of", numproc, "processes"
    end if

    call MPI_FINALIZE(ierr)
end program test_rank_print

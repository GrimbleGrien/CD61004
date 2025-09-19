program mpi
    implicit none
    include 'mpif.h'
    integer:: pid, numproc, ierr

    call MPI_INIT(ierr)
    call MPI_COMM_SIZE(MPI_COMM_WORLD, numproc, ierr)
    call MPI_COMM_RANK(MPI_COMM_WORLD, pid, ierr)

    write(*,"(a, i2, a3, i2)") "hello from process", pid, "of", numproc
    
    call MPI_FINALIZE(ierr)
end program mpi


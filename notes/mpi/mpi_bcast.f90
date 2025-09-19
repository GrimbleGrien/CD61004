! MPI_Bcast(data, count, MPI_Datatype, root, MPI_Comm, ierr)
! MPI_Datatype: MPI_LOGICAL, MPI_INTEGER, MPI_REAL, MPI_DOUBLE_PRECISION

! MPI_Reduce(send_data, recv_data, count, MPI_Datatype, MPI_Op, root, MPI_Comm, ierr)
! MPI_Op: MPI_MAX, MPI_MIN, MPI_SUM, MPI_PROD , etc

program mpi_broadcast
    implicit none
    include 'mpif.h'
    integer:: pid, numproc, ierr
    integer:: i

    call MPI_INIT(ierr)
    call MPI_COMM_SIZE(MPI_COMM_WORLD, numproc, ierr)
    call MPI_COMM_RANK(MPI_COMM_WORLD, pid, ierr)

    ! write(*,"(a, i2, , a, i2,)") "hello from process", pid, "of", numproc
    if (pid == 0) then
        i = 0
    end if

    call MPI_BCAST(i, 1, MPI_INTEGER, 0, MPI_COMM_WORLD, ierr)

    i = i + pid
    write(*,"(i2, a, i2, a, i2)") pid, "/", numproc, "i=", i
    
    call MPI_FINALIZE(ierr)
end program mpi_broadcast
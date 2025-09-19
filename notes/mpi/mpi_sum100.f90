program mpi_sum100
    implicit none
    include 'mpif.h'
    integer :: pid, numproc, ierr
    integer :: i, N, local_sum, global_sum
    integer :: shuru, samapt, batch_size

    call MPI_INIT(ierr)
    call MPI_COMM_SIZE(MPI_COMM_WORLD, numproc, ierr)
    call MPI_COMM_RANK(MPI_COMM_WORLD, pid, ierr)

    ! Only root sets N
    if (pid == 0) then
        N = 100
    end if

    ! Broadcast N to all processes
    call MPI_BCAST(N, 1, MPI_INTEGER, 0, MPI_COMM_WORLD, ierr)

    local_sum = 0

    ! Divide the work
    batch_size = (N + numproc - 1) / numproc
    shuru = min(1 + batch_size * pid, N)
    samapt  = min(batch_size * (pid + 1), N)

    do i = shuru, samapt
        local_sum = local_sum + i
    end do
    write(*,"(a, i2, a, i4)") "pid:", pid, " local sum = ", local_sum

    ! Reduce all local sums into global_sum at root
    call MPI_REDUCE(local_sum, global_sum, 1, MPI_INTEGER, MPI_SUM, 0, MPI_COMM_WORLD, ierr)

    ! Only root prints the final sum
    if (pid == 0) then
        write(*,"(a, i3, a, i4)") "Sum of 1..", N, " = ", global_sum
    end if

    call MPI_FINALIZE(ierr)
end program mpi_sum100

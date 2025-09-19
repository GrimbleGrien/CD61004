program bar
    use mpi
    implicit none
    integer:: rank, size, err, i

    call mpi_init(err)
    call mpi_comm_rank(mpi_comm_world, rank, err)
    call mpi_comm_size(mpi_comm_world, size, err)

    do i=0,size-1
    if(i==rank) then
        print *, "hello", rank
        call flush()    ! I/O is async in fortran
    endif
    call mpi_barrier(mpi_comm_world, err)
    enddo

    call mpi_finalize(err)
end

! flush and barrier
!  hello           0
!  hello           1
!  hello           2
!  hello           3
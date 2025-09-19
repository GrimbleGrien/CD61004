program mpi_random
    implicit none
    include 'mpif.h'

    integer,parameter :: N=300
    integer:: nproc, rank, ierr
    real :: r(N,N), local_sum, global_sum
    integer :: i, istart, iend, batch_size

    call MPI_INIT(ierr)
    call MPI_COMM_SIZE(MPI_COMM_WORLD, nproc, ierr)
    call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)

    open(unit=1,file='random_numbers.dat',action='read') 

    local_sum=0
    batch_size = (N + nproc - 1)/nproc
    istart = batch_size*rank + 1
    iend = min(istart + batch_size - 1, N)

    if(rank==0) then
        global_sum = 0
        do i = 1, N
            read(1,*) r(i,:)
        enddo
    endif

    call MPI_BCAST(r, N*N, MPI_REAL, 0, MPI_COMM_WORLD, ierr)

    do i = istart, iend
        local_sum = local_sum + sum(r(i,:))
    enddo    
    write(*,"(i2, f10.4)") rank, local_sum

    call MPI_REDUCE(local_sum, global_sum, 1, MPI_REAL, MPI_SUM, 0, MPI_COMM_WORLD, ierr)

    if(rank==0) then
        write(*,*) "Final results:"
        write(*,*) global_sum/real(N*N) 
    endif

    call MPI_FINALIZE(ierr)

end program mpi_random
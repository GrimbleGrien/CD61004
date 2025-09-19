program test
    use mpi
    implicit none
   
    integer,parameter :: N=10000
    integer :: total,i, size, rank, ierr, batch_size, tag, gtotal, istart, iend

    call MPI_INIT(ierr)
	call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierr)
	call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
   
    total=0; tag=0
    batch_size = (N + size - 1)/size
    istart = rank*batch_size + 1
    iend = min(istart + batch_size - 1, N)

    do i=istart, iend
      total=total+i 
    enddo

    if(rank > 0) then
        call mpi_send(total,1,mpi_int,0,tag,mpi_comm_world,ierr)
    else
        gtotal = total
        do i=1,size-1
            call mpi_recv(total,1,mpi_int,i,tag, mpi_comm_world, mpi_status_ignore, ierr)
            write(*,*) total, " <== ",i 
            gtotal = gtotal + total
        enddo
        write(*,*) "Sum: ",gtotal
    endif

    call mpi_finalize(ierr)
   
end program test 
   

! user@acer:~/Desktop/HPC2025/L7$ mpif90 p2p_sum.f90 -o sum
! user@acer:~/Desktop/HPC2025/L7$ mpirun ./sum
!      4169167  <==            1
!      6948056  <==            2
!      9726945  <==            3
!     12505834  <==            4
!     15264720  <==            5
!  Sum:     50005000

! root pings each process in sequence
program test
    use mpi
    implicit none
   
    integer,parameter :: N=10000
    integer :: i, size, rank, ierr, tag, msg

    call MPI_INIT(ierr)
	call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierr)
	call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
    tag = 0
    if(rank==0) then
        msg = 101
        write(*,*) "hello from process: ", rank, msg
        do i=1,size-1
            call mpi_ssend(msg,1,mpi_int,i,tag,mpi_comm_world,ierr)
            call mpi_recv(msg,1,mpi_int,i,tag,mpi_comm_world,mpi_status_ignore,ierr)
        enddo
    else
        call mpi_recv(msg,1,mpi_int,0,tag,mpi_comm_world,mpi_status_ignore,ierr)
        write(*,*) "hello from process: ", rank, msg
        call mpi_ssend(msg,1,mpi_int,0,tag,mpi_comm_world,ierr)
    endif

    call mpi_finalize(ierr)
   
end program test 
   

! user@acer:~/Desktop/HPC2025/L7$ mpif90 p2p_seq.f90 -o seq
! user@acer:~/Desktop/HPC2025/L7$ mpirun ./seq
!  hello from process:            0         101
!  hello from process:            1         101
!  hello from process:            2         101
!  hello from process:            3         101
!  hello from process:            4         101
!  hello from process:            5         101


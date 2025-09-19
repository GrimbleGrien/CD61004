program bar
	use mpi
	implicit none

	integer:: rank, size, ierr, tag, i
    real(kind=8):: t1,t2,msg
	
	call MPI_INIT(ierr)
	call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierr)
	call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)

    t1 = mpi_wtime()
    call sleep(rank*2)

	! send may behave as non-blocking; ssend forces blocking
	! ssend waits for recv to post
	tag=0
    msg=10
	if(rank==0) then
        do i=1, size-1
            call mpi_ssend(msg,1,mpi_int,i,tag,mpi_comm_world,ierr)
            write(*,"(a,i1)") "0 ==> ",i
		enddo
		
        do i=1, size-1
            call mpi_recv(msg, 1, mpi_int, i, tag, mpi_comm_world, mpi_status_ignore, ierr)
            write(*,"(a,i1)") "0 <== ",i
		enddo
	else
		call mpi_recv(msg, 1, mpi_int, 0, tag, mpi_comm_world, mpi_status_ignore, ierr)
		write(*,"(i1,a)") rank, " <== 0"
		call mpi_ssend(msg,1,mpi_int,0,tag,mpi_comm_world,ierr)
		write(*,"(i1, a)") rank, " ==> 0"
	endif
	
	call mpi_finalize(ierr)
        
end program bar

! user@acer:~/Desktop/HPC2025/L6$ mpif90 mpi_ssend.f90 -o ssend
! user@acer:~/Desktop/HPC2025/L6$ mpirun ./ssend 
! 0 ==> 1
! 0 ==> 2
! 0 ==> 3
! 0 ==> 4
! 0 ==> 5
! 0 <== 1
! 1 <== 0
! 1 ==> 0
! 0 <== 2
! 2 <== 0
! 2 ==> 0
! 0 <== 3
! 3 <== 0
! 3 ==> 0
! 0 <== 4
! 4 <== 0
! 4 ==> 0
! 5 <== 0
! 5 ==> 0
! 0 <== 5



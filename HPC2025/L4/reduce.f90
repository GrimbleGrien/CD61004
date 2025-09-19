program reduce
	implicit none
	include 'mpif.h'

	integer:: nproc, rank, ierr
	integer:: i, N, local_sum, global_sum
	integer, parameter :: root_process = 0

	call MPI_INIT(ierr)
	call MPI_COMM_SIZE(MPI_COMM_WORLD, nproc, ierr)
	call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)

	N = 100; local_sum = 0;

	! start stop step
	do i = 1 + rank, N, nproc
		local_sum = local_sum + i
	end do

	! int MPI_Reduce(const void *sendbuf, void *recvbuf, 
	! 				int count, MPI_Datatype datatype, 
	! 				MPI_Op op, int root, MPI_Comm comm, err);
	call MPI_Reduce(local_sum, global_sum, 1, MPI_INTEGER, &
		 MPI_SUM, root_process, MPI_COMM_WORLD, ierr)

	if (rank == root_process) then
    	write(*,*) 'Global Sum:', global_sum
  	end if

	call MPI_FINALIZE(ierr)

end program reduce
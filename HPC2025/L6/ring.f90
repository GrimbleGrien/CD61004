program ring
	use mpi
	implicit none
	integer:: rank, size, ierr, root, msg, tag
	
	call MPI_INIT(ierr)
	call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierr)
	call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
	
	root=0; tag=0
	if(rank==root) then
		msg=10
		call mpi_send(msg,1,mpi_int,1,tag,mpi_comm_world,ierr)
		call mpi_recv(msg, 1, mpi_int, size-1, tag, mpi_comm_world, mpi_status_ignore, ierr)
		write(*,"(i2,a,i2)") rank, " <==", size-1
	else
		call mpi_recv(msg, 1, mpi_int, rank-1, tag, mpi_comm_world, mpi_status_ignore, ierr)
		write(*,"(i2,a,i2)") rank, " <==", rank-1
		call mpi_send(msg,1,mpi_int,mod(rank+1,size),tag,mpi_comm_world,ierr)
	endif
	
	call mpi_finalize(ierr)
	
	
	
        
end program ring

program hellompi
	use mpi
	implicit none
	integer :: id, np, ierr

	call MPI_Init(ierr)
	call MPI_Comm_Size(MPI_Comm_World, np, ierr)
	call MPI_Comm_Rank(MPI_Comm_World, id, ierr)

	write(*, "(a, i1, a, i1)") "Hello, world. - rank/totproc = ", id, "/", np

	call MPI_Finalize(ierr)
	
end program hellompi
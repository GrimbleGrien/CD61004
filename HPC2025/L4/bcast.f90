program broadcast
	implicit none
	include 'mpif.h'

	integer:: size, rank, ierr
	integer:: i, num

	call MPI_INIT(ierr)
	call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierr)
	call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)

	if(rank==0) then
		num=1
	end if

	! blocking func: program waits until 'num' is avl
	call MPI_BCAST(num,1,MPI_INT,0,MPI_COMM_WORLD,ierr)

	num = num + rank
	write(*, '(a,i1,a,i2)') '[', rank, '] =', num

	call MPI_FINALIZE(ierr)

end program broadcast	
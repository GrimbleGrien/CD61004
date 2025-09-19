program mpisum
	implicit none
	include 'mpif.h'
	integer :: rank, nproc, ierr
	integer :: i
	real :: randnum, local_sum

	call MPI_INIT(ierr)
	call MPI_COMM_SIZE(MPI_COMM_WORLD, nproc, ierr)
	call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)

	write(*,'(i2,a1,i1)') rank, '/', nproc

	! if(MOD(rank,2) == 1) then
	! 	write(*,*) 'odd id!'
	! end if
	local_sum=0.0
	do i = 1, 5
		randnum = rand()
		write(*,*) randnum
		local_sum = local_sum + randnum
	end do
	write(*,*) 'avg =', real(local_sum)/5.0

	call MPI_FINALIZE(ierr)

end program mpisum
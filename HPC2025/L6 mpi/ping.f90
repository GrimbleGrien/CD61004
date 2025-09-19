! root pings each process in sequence
program bar
	use mpi
	implicit none

	integer:: rank, size, ierr, tag, i, msg
    real(kind=8):: t1,t2
	
	call MPI_INIT(ierr)
	call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierr)
	call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)

    t1 = mpi_wtime()
    ! call sleep(rank*2)

	! send may behave as non-blocking; ssend forces blocking
	
	tag=0
    msg=10
	if(rank==0) then
        do i=1, size-1
            call mpi_ssend(msg,1,mpi_int,i,tag,mpi_comm_world,ierr)
            write(*,"(a,i1, i3)") "0 ==> ",i, msg
		! enddo
		
        ! do i=1, size-1
            call mpi_recv(msg, 1, mpi_int, i, tag, mpi_comm_world, mpi_status_ignore, ierr)
            ! write(*,"(a,i1, i3)") "0 <== ",i, msg
		enddo
	else
		! do i=1,size-1
		! if(i==rank) then
			call mpi_recv(msg, 1, mpi_int, 0, tag, mpi_comm_world, mpi_status_ignore, ierr)
			! write(*,"(i1,a, i3)") rank, " <== 0", msg
			call mpi_ssend(msg,1,mpi_int,0,tag,mpi_comm_world,ierr)
			write(*,"(i1, a, i3)") rank, " ==> 0", msg
		! endif
		! enddo
	endif


	t2 = mpi_wtime()
	call mpi_finalize(ierr)
        
end program bar

! do loop in non root does not affect output
! 0 ==> 1 10
! 0 ==> 2 10
! 0 ==> 3 10
! 1 ==> 0 10
! 2 ==> 0 10
! 3 ==> 0 10

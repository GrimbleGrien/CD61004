program seq

        implicit none
        include 'mpif.h'
        
        integer :: ierr, np, id, i

        call MPI_INIT(ierr)
        call MPI_Comm_Size(MPI_Comm_World, np, ierr)
        call MPI_Comm_Rank(MPI_Comm_World, id, ierr)

        do i = 0, np-1
                call MPI_Barrier(MPI_Comm_World, ierr)
                if(id==i) then
                        write(*,*) 'hello- ', id
                endif
        end do
        
        call MPI_Finalize(ierr)


end program seq


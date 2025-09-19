! MPI program to calculate the sum of N numbers, using p2p functions 

program te
    implicit none
    include 'mpif.h'

    integer,parameter :: N=1000
    integer :: rank,np,ierr,sum,i, final_sum 


    ! init MPI environment
    call MPI_Init(ierr)
    call MPI_Comm_Size(MPI_Comm_World,np,ierr)
    call MPI_Comm_Rank(MPI_Comm_World,rank,ierr)

    ! parallelization
    sum=0
    do i=1+rank, N,np
        sum=sum+i
    enddo 

    ! collect the results from all processes and store it in 0 process 
    write(*,*) rank,sum 
    if(rank/=0) then
        call MPI_Send(sum,1,MPI_Int,0,0,MPI_Comm_World,ierr)
    else 
        final_sum=sum 
        do i=1,np-1
            call MPI_Recv(sum,1,MPI_Int,i,MPI_Any_Tag,MPI_Comm_World,MPI_Status_Ignore,ierr) 
            final_sum=final_sum+sum 
        enddo 
    endif 

    ! barrier is not necessary, but useful to print the statement below after the execution of above statement by all processes

    call MPI_Barrier(MPI_Comm_World,ierr)
    
    if(rank==0) then
        write(*,*) "Final Sum: ", final_sum 
    endif

    call MPI_Finalize(Ierr)

end program te

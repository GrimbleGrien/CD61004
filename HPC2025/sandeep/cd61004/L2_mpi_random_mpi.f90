program te
    implicit none
    include 'mpif.h'

    integer,parameter :: N=1000
    real :: r(N),minr,maxr,avgr
    real :: mingr,maxgr,avggr
    
    integer :: i 
    integer :: id,np,ierr

    ! initialize MPI env
    call MPI_Init(ierr)
    call MPI_Comm_Size(MPI_Comm_World,np,ierr)
    call MPI_Comm_Rank(MPI_Comm_World,id,ierr)

    ! generate random numbers
    do i=1, N
        r(i)=rand()+id
    enddo    

    minr=minval(r)
    maxr=maxval(r)
    avgr=sum(r)/real(N)

    write(*,*) id,minr,maxr,avgr

    ! collect results

    call MPI_Reduce(minr,mingr,1,MPI_Real,MPI_min,0,MPI_Comm_World,ierr)
    call MPI_Reduce(maxr,maxgr,1,MPI_Real,MPI_max,0,MPI_Comm_World,ierr)
    call MPI_Reduce(avgr,avggr,1,MPI_Real,MPI_sum,0,MPI_Comm_World,ierr)

    if(id==0) then
        write(*,*) "Final results:"
        write(*,*) mingr,maxgr,avggr/real(np) 
    endif

    call MPI_Finalize(ierr) 

end program te

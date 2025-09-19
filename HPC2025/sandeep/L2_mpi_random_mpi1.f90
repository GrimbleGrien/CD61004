program te
    implicit none
    include 'mpif.h'

    integer,parameter :: N=1000
    real :: r(N), newrsum(N), newrmax(N),newrmin(N), minr,maxr,avgr
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


    ! collect results

    call MPI_Reduce(r,newrsum,N,MPI_Real,MPI_sum,0,MPI_Comm_World,ierr)
    call MPI_Reduce(r,newrmin,N,MPI_Real,MPI_min,0,MPI_Comm_World,ierr)
    call MPI_Reduce(r,newrmax,N,MPI_Real,MPI_max,0,MPI_Comm_World,ierr)

    if(id==0) then
      minr=minval(newrmin)
      maxr=maxval(newrmax)
      avgr=sum(newrsum)/real(N)

       write(*,*) "Final results:"
       write(*,*) minr,maxr,avgr/real(np) 
    endif

    call MPI_Finalize(ierr) 

end program te

!mpi program to create the barrier using point-to-point communication functions 

program printing
  implicit none
  include 'mpif.h'
  
  integer :: ierr, p, id, tag, i, msg, temp
  
  call MPI_Init(ierr)
  call MPI_Comm_Size(MPI_Comm_World,p,ierr)
  call MPI_Comm_Rank(MPI_Comm_World,id,ierr)

  msg=0
  tag=0
! sequential print
  if(id/=0) then
    call MPI_Recv(msg,1,MPI_Integer,id-1,MPI_Any_Tag,MPI_Comm_World,MPI_Status_Ignore,ierr)
  endif

! print on console
  write(*,*) "Process ID:", id

  if(id/=p-1) then 
    call MPI_Send(msg,1,MPI_Integer,mod(id+1,p),tag,MPI_Comm_World,ierr)
  endif

  call MPI_Finalize(ierr)
end program printing

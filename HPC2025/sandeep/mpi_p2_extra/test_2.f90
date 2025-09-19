program q1
  implicit none
  include 'mpif.h'
  
  real(kind=8) :: t1,t2,msg
  integer :: ierr, p, id, tag, i
  
  call MPI_Init(ierr)
  call MPI_Comm_Size(MPI_Comm_World,p,ierr)
  call MPI_Comm_Rank(MPI_Comm_World,id,ierr)

  t1=MPI_wtime()
  call sleep(id*2) 

  msg=0 
! root process - send and children processes - recv 
  if(id==0) then 
    do i=1,p-1 
      call MPI_SSend(id,1,MPI_Double_precision,i,tag,MPI_Comm_World,ierr)
      call MPI_Recv(msg,1,MPI_Double_Precision,i,MPI_Any_Tag,MPI_Comm_World,MPI_Status_Ignore,ierr)
    enddo
  else 
      call MPI_Recv(msg,1,MPI_Double_Precision,0,MPI_Any_Tag,MPI_Comm_World,MPI_Status_Ignore,ierr)
      call MPI_SSend(id,1,MPI_Double_precision,0,tag,MPI_Comm_World,ierr)
  endif

  t2=MPI_wtime()
  
  write(*,"(a5,1x,i2,1x,a5,1x,f5.2,a4)") 'rank: ',id,'time: ',t2-t1,'sec' 

  call MPI_Finalize(ierr)
end program q1

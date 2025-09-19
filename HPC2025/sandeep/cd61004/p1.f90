program test
  implicit none
  include 'mpif.h'
  
  integer :: irrr

  call mpi_init(irrr)
  call mpi_comm_size(mpi_comm_world,np,irrr)
  call mpi_comm_rank(mpi_comm_world,id,irrr) 

  write(*,*) "Hello, World!"


  call mpi_finalize(irrr) 
  
end program test 



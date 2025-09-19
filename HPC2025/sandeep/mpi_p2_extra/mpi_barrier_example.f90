program mpi_barrier_example
  implicit none
  include 'mpif.h'

  integer :: rank, nproc, ierr
  integer :: data, i

  call MPI_INIT(ierr)
  call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
  call MPI_COMM_SIZE(MPI_COMM_WORLD, nproc, ierr)

  data = rank

  ! Each process sends its rank to the next process
  call MPI_SEND(data, 1, MPI_INTEGER, mod(rank + 1, nproc), 0, MPI_COMM_WORLD, ierr)

  ! Each process receives data from the previous process
  call MPI_RECV(data, 1, MPI_INTEGER, mod(rank - 1 + nproc, nproc), 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)


  do id=0,nproc-1

    call MPI_BARRIER(MPI_COMM_WORLD,ierr)

    call MPI_SEND(data, 1, MPI_INTEGER, mod(rank + 1, nproc), 0, MPI_COMM_WORLD, ierr)

  enddo 


  if(x) then
    write(*,*) "Process", rank, "received data:", data
  endif 

  call MPI_FINALIZE(ierr)
end program mpi_barrier_example


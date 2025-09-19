program mpi_diag
  implicit none
  include 'mpif.h'

  integer :: ierr, rank, size, len
  character(len=MPI_MAX_LIBRARY_VERSION_STRING) :: libver

  ! Initialize MPI
  call MPI_Init(ierr)

  ! Get rank & size
  call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
  call MPI_Comm_size(MPI_COMM_WORLD, size, ierr)

  ! Get MPI library version
  call MPI_Get_library_version(libver, len, ierr)

  print *, 'Rank', rank, 'of', size, 'running on MPI library:'
  print *, trim(libver)

  call MPI_Finalize(ierr)
end program mpi_diag

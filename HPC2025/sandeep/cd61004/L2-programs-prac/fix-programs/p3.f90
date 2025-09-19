program test
  use omp_lib
  implicit none
  integer :: i, id
  integer, parameter :: n = 5

  ! Parallel region
  !$omp parallel private(id)
    id = omp_get_thread_num()
  !$omp end parallel

  !$omp parallel
    write(*,*) "Thread ID:", id
  !$omp end parallel
end program test


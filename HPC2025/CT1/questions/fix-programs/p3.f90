program test
  use omp_lib
  implicit none
  integer :: id
  integer, parameter :: n = 5

  ! Parallel region
  !$omp parallel private(id)
    id = omp_get_thread_num()

    write(*,*) "Thread ID:", id
  !$omp end parallel
end program test


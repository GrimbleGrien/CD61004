program parallel_sum
  use omp_lib
  implicit none

  integer, parameter :: n = 10000000
  real :: array(n), sum
  integer :: i
  real(8) :: t_start, t_end

  ! Initialize the array
  array = 1.0

  t_start = omp_get_wtime()
  sum = 0.0
  do i = 1, n
     sum = sum + array(i)
  end do

  t_end = omp_get_wtime()

  write(*,*) "Sum : ",sum,"elapsed time: ", t_end-t_start

end program parallel_sum


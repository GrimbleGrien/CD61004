program parallel_sum
  use omp_lib
  implicit none

  integer, parameter :: n = 10000000
  real :: array(n), sum, partial_sum
  integer :: i
  real(8) :: t_start, t_end

  ! Initialize the array
  array = 1.0
  sum = 0.0

  !$omp parallel private(i,partial_sum)
  partial_sum = 0
  t_start = omp_get_wtime()
  !$omp do
  do i = 1, n
    partial_sum = partial_sum + array(i)
  end do
  !$omp enddo
  !$omp critical
  sum = sum + partial_sum
  !$omp end critical 

  t_end = omp_get_wtime()
  !$omp end parallel  
  write(*,*) "Sum : ",sum,"elapsed time: ", t_end-t_start

end program parallel_sum

! user@acer:~/Desktop/HPC2025/CT1/questions$ gfortran -fopenmp sum_array.f90 -o sum.x
! user@acer:~/Desktop/HPC2025/CT1/questions$ ./sum.x 
!  Sum :    10000000.0     elapsed time:    4.9020979995475500E-003


! user@acer:~/Desktop/HPC2025/CT1/questions$ gfortran -fopenmp sum_array.f90 -o sum.x
! user@acer:~/Desktop/HPC2025/CT1/questions$ ./sum.x 
!  Sum :    10000000.0     elapsed time:    1.7738322000241169E-002

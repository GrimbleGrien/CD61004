program omp_monte_carlo_pi
   use omp_lib
  implicit none

  integer, parameter :: num_samples = 10000000
  integer :: i
  real(8) :: x, y, pi_estimate, t1, t2

  ! Initialize the random number generator
  call random_seed()
  ! Initialize the pi estimate
  pi_estimate = 0.0d0
  
   !$omp parallel reduction(+:pi_estimate)
   t1 = omp_get_wtime()

      !$omp do
         do i = 1,num_samples
            call random_number(x)
            call random_number(y)
            if (x**2 + y**2 <= 1.0d0) then
               pi_estimate = pi_estimate + 1.0d0
            end if
         enddo
      !$omp enddo

   t2 = omp_get_wtime()
   !$omp end parallel

  ! Calculate the final estimate of Pi and write it to the console
  write(*, "(a, i10, a,f8.6,a,f6.4)") "trials: ", num_samples, " Pi: ", 4*pi_estimate/real(num_samples), " time: ", t2-t1

end program omp_monte_carlo_pi

! user@acer:~/Desktop/HPC2025/tasks$ export OMP_NUM_THREADS=1
! user@acer:~/Desktop/HPC2025/tasks$ ./pi 
!  Estimated Pi:    3.1413780000000000      time  0.17633752000074310     
! user@acer:~/Desktop/HPC2025/tasks$ export OMP_NUM_THREADS=10
! user@acer:~/Desktop/HPC2025/tasks$ ./pi 
!  Estimated Pi:    3.1407080000000001      time  0.30166427499989368     
! user@acer:~/Desktop/HPC2025/tasks$ export OMP_NUM_THREADS=4
! user@acer:~/Desktop/HPC2025/tasks$ ./pi 
!  Estimated Pi:    3.1419028000000000      time  0.11206265600048937  

! trials:   10000000 Pi: 3.141723 time: 0.1088

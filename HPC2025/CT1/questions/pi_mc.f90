program serial_monte_carlo_pi
  implicit none

  integer, parameter :: num_samples = 1000000
  integer :: i
  real :: x, y, pi_estimate

  ! Initialize the random number generator
  call random_seed()
!   call random_number(x)
!   call random_number(y)
  
  ! Initialize the pi estimate
  pi_estimate = 0.0d0
   !$omp parallel reduction(+: pi_estimate)
  !$omp do
  do i = 1, num_samples
     call random_number(x)
     call random_number(y)
     if (x**2 + y**2 <= 1.0d0) then
        pi_estimate = pi_estimate + 1.0d0
     end if
  end do
  !$omp enddo
  !$omp end parallel 

  ! Calculate the final estimate of Pi and write it to the console
  write(*, *) "Estimated Pi: ", 4*pi_estimate/real(num_samples)

end program serial_monte_carlo_pi


! user@acer:~/Desktop/HPC2025/CT1/questions$ gfortran -fopenmp pi_mc.f90 -o pi.x
! user@acer:~/Desktop/HPC2025/CT1/questions$ ./pi.x 
!  Estimated Pi:    3.14134789    


! user@acer:~/Desktop/HPC2025/CT1/questions$ gfortran pi_mc.f90 -o pi
! user@acer:~/Desktop/HPC2025/CT1/questions$ ./pi
!  Estimated Pi:    3.13961601    

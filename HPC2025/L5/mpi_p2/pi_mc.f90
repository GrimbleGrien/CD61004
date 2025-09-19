program serial_monte_carlo_pi
  implicit none

  integer, parameter :: num_samples = 1000000
  integer :: i
  real :: x, y, pi_estimate

  ! Initialize the random number generator
  call random_seed()
  call random_number(x)
  call random_number(y)
  
  ! Initialize the pi estimate
  pi_estimate = 0.0d0

  do i = 1, num_samples
     call random_number(x)
     call random_number(y)
     if (x**2 + y**2 <= 1.0d0) then
        pi_estimate = pi_estimate + 1.0d0
     end if
  end do

  ! Calculate the final estimate of Pi and write it to the console
  write(*, *) "Estimated Pi: ", 4*pi_estimate/real(num_samples)

end program serial_monte_carlo_pi


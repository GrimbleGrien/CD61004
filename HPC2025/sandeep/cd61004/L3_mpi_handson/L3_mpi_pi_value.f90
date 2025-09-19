program mpi_monte_carlo_pi
  implicit none

  integer, parameter :: num_points = 1000000
  integer :: local_count, i
  real :: x, y, distance
  real :: estimated_pi

  local_count=0
  do i = 1, num_points
    ! Generate random points within the unit square
    call random_number(x)  ! Random value between 0 and 1
    call random_number(y)

    ! Calculate distance from the origin
    distance = x**2 + y**2

    ! Check if the point is inside the quarter circle
    if (distance <= 1.0) then
      local_count = local_count + 1
    end if
  end do

  estimated_pi = real(local_count) / (num_points) * 4.0
  write(*,*) "Estimated value of pi:", estimated_pi
  write(*,*) "Actual value of pi:", acos(-1.0)

end program mpi_monte_carlo_pi


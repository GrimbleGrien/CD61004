program matrix_multiplication
  use omp_lib
  implicit none

  integer, parameter :: N = 1000
  real :: A(N, N), B(N, N), C(N, N)
  integer :: i, j, k
  real(kind=8) :: t_start, t_end, time_serial, time_parallel, speedup

  ! Initialize matrices A and B with random values
  call random_number(A)
  call random_number(B)
  C = 0.0

  ! Serial matrix multiplication
  call cpu_time(t_start)
  do i = 1, N
     do j = 1, N
        do k = 1, N
           C(i, j) = C(i, j) + A(i, k) * B(k, j)
        end do
     end do
  end do
  call cpu_time(t_end)
  time_serial = t_end - t_start

  write(*,*) "Time: ",time_serial 

end program matrix_multiplication


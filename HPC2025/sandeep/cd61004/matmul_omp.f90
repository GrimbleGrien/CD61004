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
  t_start=omp_get_wtime()
  do i = 1, N
     do j = 1, N
        do k = 1, N
           C(i, j) = C(i, j) + A(i, k) * B(k, j)
        end do
     end do
  end do
  t_end=omp_get_wtime()
  time_serial = t_end - t_start

  write(*,*) "C matrix: ",C(1,1:5)

  ! Reset matrix C
  C = 0.0

  ! Parallel matrix multiplication using OpenMP
 t_start=omp_get_wtime()
  !$OMP PARALLEL PRIVATE(i, j, k) SHARED(A, B, C) 
  !$OMP DO 
  do i = 1, N
     do j = 1, N
        do k = 1, N
           C(i, j) = C(i, j) + A(i, k) * B(k, j)
        end do
     end do
  end do
  !$OMP END DO
  !$OMP END PARALLEL 
 t_end=omp_get_wtime()
  time_parallel = t_end - t_start

  write(*,*) "C matrix with threads: ",C(1,1:5)

  ! Calculate and display the speedup
  speedup = time_serial / time_parallel
  write(*, *) 'Serial Time: ', time_serial, ' seconds'
  write(*, *) 'Parallel Time: ', time_parallel, ' seconds'
  write(*, *) 'Speedup: ', speedup

end program matrix_multiplication


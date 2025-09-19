program matrix_multiplication
  implicit none

  integer, parameter :: m = 100, n = 100, k = 100
  integer :: i, j, l

  real :: matrix_a(m,k)
  real :: matrix_b(k,n)
  real :: matrix_c(m,n)

  ! Initialize matrices - using random numbers here 
  do i = 1, m
    do j = 1, k
      call random_number(matrix_a(i, j))
    enddo
  enddo

  do i = 1, k
    do j = 1, n
      call random_number(matrix_b(i, j))
    enddo
  enddo

  ! Perform matrix multiplication
  do i = 1, m
    do j = 1, n
      matrix_c(i, j) = 0.0
      do l = 1, k
        matrix_c(i, j) = matrix_c(i, j) + matrix_a(i, l) * matrix_b(l, j)
      enddo
    enddo
  enddo

  ! result 
   write(*,*) matrix_c

end program matrix_multiplication

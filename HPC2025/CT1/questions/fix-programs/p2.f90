program test
  implicit none
  integer :: i, a
  integer, parameter :: n = 10
  integer :: arr(n)

  ! Initialize array
  arr = 1
  a = 0

  ! Parallel region
  !$omp parallel 
  !$omp do
  do i = 1, n
    a = a + arr(i)
  end do
  !$omp enddo
  !$omp end parallel 
  write(*,*) "Sum:", a
end program test


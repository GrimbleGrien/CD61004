program test
  implicit none
  integer :: i, a
  integer, parameter :: n = 10
  integer :: arr(n)

  ! Initialize array
  arr = 1
  a = 0

  ! Parallel region
  !$omp parallel do
  do i = 1, n
    a = a + arr(i)
  end do

  write(*,*) "Sum:", a
end program test


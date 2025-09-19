
program fix_this
    use omp_lib
    implicit none
    integer, parameter :: n = 1000
    integer :: i, index
    integer :: x(10), y(10)
    integer :: sum_x, sum_y
    x = 0; y = 0
    ! $omp parallel do private(index)
    do i = 1, n
      index = mod(i, 10) + 1
      x(index) = x(index) + 1
      y(index) = y(index) + 1
    end do
    ! $omp end parallel do
    ! compute sums
    sum_x = sum(x)
    sum_y = sum(y)
    write(*,*) 'sum_x:', sum_x
    write(*,*) 'sum_y:', sum_y
  end program 

! bad parallel: same index value can result 
! from different n (of different thread)
!  sum_x:         634
!  sum_y:         658

! serial

!  sum_x:        1000
!  sum_y:        1000

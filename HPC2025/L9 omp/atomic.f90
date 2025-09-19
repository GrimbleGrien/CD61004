
program fix_this
    use omp_lib
    implicit none
    integer, parameter :: n = 1000
    integer :: i, index
    integer :: x(10), y(10)
    integer :: sum_x, sum_y
    x = 0; y = 0
    ! assign arrays
    !$omp parallel do private(index)
    do i = 1, n
      index = mod(i, 10) + 1
      !$omp atomic
      x(index) = x(index) + 1
      !$omp atomic
      y(index) = y(index) + 1
    end do
    !$omp end parallel do
    ! compute sums
    sum_x = sum(x)
    sum_y = sum(y)
    write(*,*) 'sum_x:', sum_x
    write(*,*) 'sum_y:', sum_y
end program 


! serial
! critical (basically serial)
! atomic (best option)

!  sum_x:        1000
!  sum_y:        1000

! rajad@Osgiliath2126:/mnt/c/Users/rajad/ACADEMIC/CD61004/HPC2025/L9 omp$ ./bug
!  sum_x:         732
!  sum_y:         736
! rajad@Osgiliath2126:/mnt/c/Users/rajad/ACADEMIC/CD61004/HPC2025/L9 omp$ ./bug
!  sum_x:         794
!  sum_y:         799
! rajad@Osgiliath2126:/mnt/c/Users/rajad/ACADEMIC/CD61004/HPC2025/L9 omp$ ./bug
!  sum_x:         914
!  sum_y:         919
! rajad@Osgiliath2126:/mnt/c/Users/rajad/ACADEMIC/CD61004/HPC2025/L9 omp$ ./bug
!  sum_x:         834
!  sum_y:         826
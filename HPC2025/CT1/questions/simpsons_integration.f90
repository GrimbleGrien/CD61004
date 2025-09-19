! Program to compute the integration of a function using Simpson's formula

program simpsons_integration
    use omp_lib
    implicit none
    
    ! Constants
    integer, parameter :: n = 100000  ! Number of subintervals (even)
    real :: a, b                      ! Interval limits
    real :: h, x, sum                 ! Step size, current x value, integral sum
    integer :: i
    real(8)::t1,t2
    
    ! Subroutine declaration
    real :: f_value
    external :: func_subroutine

    ! Initialize interval limits
    a = 0.0
    b = 1.0
    
    ! Calculate step size
    h = (b - a) / n
    
    ! Initialize sum
    call func_subroutine(a, f_value)
    sum = f_value
    call func_subroutine(b, f_value)
    sum = sum + f_value
    t1 = omp_get_wtime()
    ! Calculate the sum of function values
    !$omp parallel reduction(+:sum)
    !$omp do
    do i = 1, n-1, 2
        x = a + i * h
        call func_subroutine(x, f_value)
        sum = sum + 4.0 * f_value
    end do
    !$omp enddo
    
    !$omp do
    do i = 2, n-2, 2
        x = a + i * h
        call func_subroutine(x, f_value)
        sum = sum + 2.0 * f_value
    end do
    !$omp enddo
    
    !$omp end parallel
    t2 = omp_get_wtime()
    
    ! Calculate integral
    sum = sum * h / 3.0
    
    ! Output result
    write(*,*) 'integral: ', sum, t2-t1
    
end program simpsons_integration

! Subroutine to define the function
subroutine func_subroutine(x, f_value)
    real, intent(in) :: x
    real, intent(out) :: f_value
    ! Define your function 
    f_value = x**2
end subroutine func_subroutine


! serial
!  integral:   0.333328336       7.8476800081261899E-004

! -np 4
!  integral:   0.332931489       8.0575989995850250E-003

! -np 12
!  integral:   0.333595991       6.1570367999593145E-002

! user@acer:~/Desktop/HPC2025/CT1/questions$ gfortran -fopenmp simpsons_integration.f90 -o sim.x
! user@acer:~/Desktop/HPC2025/CT1/questions$ ./sim.x 
!  Result of Simpson's integration:   0.333328336  
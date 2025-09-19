! Program to compute the integration of a function using Simpson's formula

program simpsons_integration
use omp_lib
    implicit none
    
    ! Constants
    integer, parameter :: n = 100000  ! Number of subintervals (even)
    real :: a, b                      ! Interval limits
    real :: h, x, sum                 ! Step size, current x value, integral sum
    integer :: i
    
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
    
    ! Calculate the sum of function values
    !$omp parallel do reduction(+:sum) private(x, f_value)
    !do i = 1, n-1, 2
    do i = 1, n-1
        x = a + i * h
        call func_subroutine(x, f_value)
        !sum = sum + 4.0 * f_value
        sum = sum + 2.0 * f_value * (1.0 + real(mod(i,2)))
    end do
    !$omp end parallel do
    
    !do i = 2, n-2, 2
    !    x = a + i * h
    !    call func_subroutine(x, f_value)
    !    sum = sum + 2.0 * f_value
    !end do
    
    ! Calculate integral
    sum = sum * h / 3.0
    
    ! Output result
    write(*,*) 'Result of Simpson''s integration: ', sum
    
end program simpsons_integration

! Subroutine to define the function
subroutine func_subroutine(x, f_value)
    real, intent(in) :: x
    real, intent(out) :: f_value
    ! Define your function 
    f_value = x**2
end subroutine func_subroutine

! Result of Simpson's integration:   0.333333403      

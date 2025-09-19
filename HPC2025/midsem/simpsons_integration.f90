! Program to compute the integration of a function using Simpson's formula

program simpsons_integration
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
    do i = 1, n-1, 2
        x = a + i * h
        call func_subroutine(x, f_value)
        sum = sum + 4.0 * f_value
    end do
    
    do i = 2, n-2, 2
        x = a + i * h
        call func_subroutine(x, f_value)
        sum = sum + 2.0 * f_value
    end do
    
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


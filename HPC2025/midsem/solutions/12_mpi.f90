! Program to compute the integration of a function using Simpson's formula

program simpsons_integration
    use mpi
    implicit none
    
    ! Constants
    integer, parameter :: n = 100000  ! Number of subintervals (even)
    real :: a, b                      ! Interval limits
    real :: h, x, sum                 ! Step size, current x value, integral sum
    integer :: i
    integer:: size, rank, err
    real :: localsum, globalsum

    ! Subroutine declaration
    real :: f_value
    external :: func_subroutine

    call mpi_init(err)
    call mpi_comm_size(mpi_comm_world, size, err)
    call mpi_comm_rank(mpi_comm_world, rank, err)
    

    ! Initialize interval limits
    a = 0.0
    b = 1.0
    
    ! Calculate step size
    h = (b - a) / n
    
    if(rank==0) then
        ! Initialize sum
        call func_subroutine(a, f_value)
        sum = f_value
        call func_subroutine(b, f_value)
        sum = sum + f_value
    else
        sum = 0.0
    endif
    
    ! Calculate the sum of function values
    do i = rank, n-1, size
        x = a + i * h
        call func_subroutine(x, f_value)
        !sum = sum + 4.0 * f_value
        sum = sum + 2.0 * f_value * (1.0 + real(mod(i,2)))
    end do

    call mpi_reduce(sum, globalsum, 1, mpi_real, mpi_sum, 0, mpi_comm_world, err)

    !do i = 2, n-2, 2
    !    x = a + i * h
    !    call func_subroutine(x, f_value)
    !    sum = sum + 2.0 * f_value
    !end do
    
    if(rank==0) then
        ! Calculate integral
        globalsum = globalsum * h / 3.0
        
        ! Output result
        write(*,*) 'Result of Simpson''s integration: ', globalsum
    endif
    call mpi_finalize(err)
    
end program simpsons_integration

! Subroutine to define the function
subroutine func_subroutine(x, f_value)
    real, intent(in) :: x
    real, intent(out) :: f_value
    ! Define your function 
    f_value = x**2
end subroutine func_subroutine

! Result of Simpson's integration:   0.333333403    


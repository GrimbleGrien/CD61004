program reduce_sum
    use omp_lib
    implicit none
    integer::i, n, sum

    n = 1000 
    sum = 0
    !$omp parallel do reduction(+:sum)
    do i = 1,n
        sum = sum + i
    enddo
    !$omp end parallel do

    print '(a, i7)', "sum(1000) =", sum 
end

! $ gfortran -fopenmp reduce.f90 -o red
! $ ./red
!  sum(1000) = 500500
program factorial
    use omp_lib
    implicit none
    integer::i, n, fact

    n = 10 
    fact = 1
    !$omp parallel do reduction(*:fact)
    do i = 1,n
        fact = fact * i
    enddo
    !$omp end parallel do

    print '(a, i8)', "fact(10) = ", fact
end

! fact(10) =  3628800
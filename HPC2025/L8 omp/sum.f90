program sum
    use omp_lib
    implicit none
    integer, parameter:: N = 10000
    integer :: total, i, partial_sum

    ! total = 0
    
    !$omp parallel private(i, partial_sum)
    total = 0
    partial_sum = 0

        !$omp do
        do i = 1,N
            partial_sum = partial_sum + i
        enddo
        !$omp enddo

        !$omp critical
            total = total + partial_sum
        !$omp end critical    

    !$omp end parallel

    write(*,*) "Sum of", N, "=", total

end program sum

! Sum of       10000 =    50005000

! int(kind=2) default
! int(kind=4) long
! iterator i made private by compiler by default
! reduction sets vars in arg to private
! reduction operation uses original init value also
! critical prevents RACE CONDITION (here trivial)
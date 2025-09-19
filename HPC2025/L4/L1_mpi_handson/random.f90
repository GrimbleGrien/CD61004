program te
    implicit none

    integer,parameter :: N=300
    real :: r(300,300),total
    integer :: i 

    open(unit=1,file='random_numbers.dat',action='read') 

    total=0
    do i=1, N
        read(1,*) r(i,:)
        total=total+sum(r(i,:))
    enddo    

    write(*,*) "Final results:"
    write(*,*) total/real(N*N) 

end program te

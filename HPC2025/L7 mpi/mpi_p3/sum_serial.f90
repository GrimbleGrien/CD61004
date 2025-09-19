program test
 implicit none

 integer,parameter :: N=10000
 integer :: total,i

 total=0 
 do i=1,N
   total=total+i 
 enddo 

 write(*,*) "Sum: ",total

end program test 

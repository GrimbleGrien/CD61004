!program to calculate the intra-molecular distance of CO2 molecule; each frame has several CO2 molecules and each CO2 molecule has
! two C-O bonds 

program test
 implicit none

 integer :: count, nlines, i, k, j, natoms, frame, mol_index
 character(len=1) :: c1
 real :: dist(2), sum_dist(2)

 integer,parameter :: nframe=20
 real :: X(nframe,1000,3,3) 
 
 open(unit=1, file ='co2.xyz', action='read')


 count=0; sum_dist=0.0 
 !starting infinite loop and exit when there is no data to read 
 do frame=1,nframe 
   read(1,*) natoms 
   read(1,*)
   mol_index=0
   do k=1, natoms,3   ! molecule index 
     mol_index=mol_index+1 
     do j=1,3         ! atom index 
       read(1,*) c1, X(frame,mol_index,j,:)
     enddo
   enddo 
 enddo 


 do frame=1,nframe 
   do k=1, mol_index
     call distance(X(frame,k,:,:),dist)
     sum_dist=sum_dist+dist 
   end do
   count=count+1
 enddo


 sum_dist=sum_dist/(real(count)*mol_index)
 write(*,*) "The average distance between C and O atoms are",sum_dist(1),"and",sum_dist(2)

end program
 
subroutine distance(vec, d)
 implicit none

 real :: vec(3,3),d(2),dr(3)


!first C-O
 dr=vec(1,:)-vec(2,:)
 d(1)=sqrt(dot_product(dr,dr))
!second C-O 
 dr=vec(1,:)-vec(3,:) 
 d(2)=sqrt(dot_product(dr,dr))
 
end subroutine distance



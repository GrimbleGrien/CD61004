program main
  use omp_lib
  implicit none

  integer :: nprint=15,nsample=10000
  integer :: pr_number, i, pr_sum, j
  real :: pr_av
  
  pr_sum = 0
  do i=1,nprint
  !$omp parallel private(j, pr_number)
  !$omp do 
   do j=1,nsample 
     pr_number = int(rand()*10) 
     pr_sum = pr_sum+pr_number
   enddo 
  !$omp enddo
  !$omp end parallel

   pr_av = (1.d0*pr_sum) / real(i*nsample)
   write(*,*) i*nsample,pr_av 
 enddo

end program main

! user@acer:~/Desktop/HPC2025/CT1/questions$ gfortran -fopenmp ./print_samples.f90 -o print.x
! user@acer:~/Desktop/HPC2025/CT1/questions$ ./print.x 
!        10000   4.40280008    
!        20000   4.39764977    
!        30000   4.39626646    
!        40000   4.39540005    
!        50000   4.40138006    
!        60000   4.40528345    
!        70000   4.40441418    
!        80000   4.40488768    
!        90000   4.40859985    
!       100000   4.40257978    
!       110000   4.40311813    
!       120000   4.40520811    
!       130000   4.40596151    
!       140000   4.40765715    
!       150000   4.40532684 

! user@acer:~/Desktop/HPC2025/CT1/questions$ gfortran print_samples.f90 -o print
! user@acer:~/Desktop/HPC2025/CT1/questions$ ./print 
!        10000   4.51529980    
!        20000   4.49714994    
!        30000   4.49749994    
!        40000   4.49464989    
!        50000   4.50093985    
!        60000   4.50374985    
!        70000   4.50305700    
!        80000   4.50392485    
!        90000   4.50594425    
!       100000   4.50119019    
!       110000   4.50162745    
!       120000   4.50270844    
!       130000   4.50290012    
!       140000   4.50337124    
!       150000   4.50144672   
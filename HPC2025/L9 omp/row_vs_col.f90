program aaa
    use omp_lib
    implicit none 
    integer,parameter :: n=800
    integer :: i,j,k,A(n,n,n)
    real(kind=8) :: tstart,tend
    tstart=omp_get_wtime()
    !$OMP parallel 
    !$OMP DO
    do i = 1, n
     do j = 1, n
      do k = 1, n
       A(i,j,k)=i*j*k
      enddo
     enddo
    enddo
    !$OMP END DO
    !$OMP end parallel 
    tend=omp_get_wtime()
    write(*,*) "Time i,j,k: ",tend-tstart

    tstart=omp_get_wtime()
    !$OMP parallel 
    !$OMP DO
    do k = 1, n
     do j = 1, n
      do i = 1, n
       A(i,j,k)=i*j*k
      enddo
     enddo
    enddo
    !$OMP END DO
    !$OMP end parallel 
    tend=omp_get_wtime()
    write(*,*) "Time k,j,i: ",tend-tstart 
end 

! user@acer:~/Desktop/HPC2025/L9 omp$ gfortran row_vs_col.f90 -o row -fopenmp
! user@acer:~/Desktop/HPC2025/L9 omp$ ./row 
!  Time i,j,k:    4.0611994939999931     
!  Time k,j,i:   0.30437844299922290  

! fortran array stored in column major vs c/c++ store as row major
! fortran memory access in adjacent indices of smaller idx axis faster

program test
    use omp_lib
    implicit none
    integer :: i, A(100)
    do i=1,100; A(i)=i; enddo
    !$omp parallel
    !$omp do 
    ! do i = 1, 999
    !   A(i) = A(i+1)
    !   write(*,*) omp_get_thread_num(), i
    ! enddo
    do i = 2, 100
      A(i) = A(i-1)
      write(*,*) omp_get_thread_num(), i
    enddo
    !$omp end do 
    !$omp end parallel 
    write(*,*) "------------------------"
    ! do i=1,999
    !   if(A(i)/=i+1) write(*,*) i,A(i)
    ! enddo 
    do i=2,100
      if(A(i)/=i-1) write(*,*) i,A(i)
    enddo 
   end 

! parallelize inplace array shift by 1 item
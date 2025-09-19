! program parallel_sum
!   use omp_lib
!   implicit none

!   integer, parameter :: n = 10000000
!   real :: array(n), sum
!   integer :: i
!   real(8) :: t_start, t_end

!   ! Initialize the array
!   array = 1.0

!   t_start = omp_get_wtime()
!   sum = 0.0
!   do i = 1, n
!      sum = sum + array(i)
!   end do

!   t_end = omp_get_wtime()

!   write(*,*) "Sum : ",sum,"elapsed time: ", t_end-t_start

! end program parallel_sum

! Sum :    10000000.0     elapsed time:    1.7931426999894029E-002
! wtime returns unix time

program parallel_sum
  use omp_lib
  implicit none

  integer, parameter :: n = 10000000
  real :: array(n), total
  integer :: i
  real(8) :: t_start, t_end

  ! Initialize the array
  array = 1.0
  !$omp parallel reduction(+:total)
    t_start = omp_get_wtime()

    !$omp do
      do i = 1,N
        total = total + array(i)
      enddo
    !$omp enddo

    t_end = omp_get_wtime()
  !$omp end parallel

  write(*,*) "Sum :", total,"elapsed time: ", t_end-t_start

end program parallel_sum

! Sum :   10000000.0     elapsed time:    4.8300309999831370E-003

! observe scope of i,j in c(i,j) loop
! order j,i,k or i,j,k is important
! ensure private vars i j k temp
program test
  use omp_lib 
  implicit none 
  integer :: i,j,k
  integer,parameter ::n=100
  real :: a(n,n), b(n,n), c(n,n), d(n,n), temp
  real(kind=8):: tstart,tend 

  a=1.0
  b=2.0 
  c=0.0
  d=0.0
  tstart=omp_get_wtime()
  !$omp parallel do private(i,j,k,temp) collapse(2)
    do j = 1, n
      do i = 1, n
        temp = 0.0
        do k = 1, n
          temp = temp + a(i, k) * b(k, j)
        end do
        c(i,j) = temp 
      end do
    end do
  !$omp end parallel do
  tend=omp_get_wtime()

  write(*,*) 'omp time: ',tend-tstart 

  tstart = omp_get_wtime()
  d = matmul(a,b)
  tend = omp_get_wtime()
  print *, 'matmul time: ', tend-tstart

  write(*,*) 'max difference = ', maxval(abs(c - d))

end 


! Each thread works on a different (i,j) pair, so c(i,j) accumulators don’t conflict.
! The collapse(2) makes OpenMP flatten the i,j loops for better load balancing.
! No need for reduction on scalars.

!! N=10 (parallel is slower)
! -np 12
!  omp time:    3.4824669999579783E-002
!  matmul time:    3.4708999919530470E-005
!  max difference =    0.00000000

! serial
!  omp time:    5.6257999858644325E-005
!  matmul time:    1.2877600056526717E-004
!  max difference =    0.00000000

! -np 4
!  omp time:    1.1794539996117237E-003
!  matmul time:    5.1258999519632198E-005
!  max difference =    0.00000000
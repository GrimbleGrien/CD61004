! this code calculates the value of pi using Monte Carlo method 

program serial_monte_carlo_pi
  implicit none
  include 'mpif.h'

  integer, parameter :: num_samples = 1000000
  integer :: i
  real(8) :: x, y, pi_estimate, new_pi_estimate

  integer :: nproc,rank,ierr

  call MPI_Init(ierr)
  call MPI_Comm_Size(MPI_Comm_World,nproc,ierr)
  call MPI_Comm_Rank(MPI_Comm_World,rank,ierr)


  ! Initialize the random number generator
  call random_seed()
  call random_number(x)
  call random_number(y)
  
  ! Initialize the pi estimate
  pi_estimate = 0.0d0

  do i = 1, num_samples
     call random_number(x)
     call random_number(y)
     if (x**2 + y**2 <= 1.0d0) then
        pi_estimate = pi_estimate + 1.0d0
     end if
  end do

  call MPI_Reduce(pi_estimate,new_pi_estimate,1,MPI_Double_Precision,MPI_Sum,nproc-1,MPI_Comm_World,ierr) 

  if(rank==nproc-1) then 

  ! Calculate the final estimate of Pi and write it to the console
    write(*, *) "Estimated Pi: ", 4*new_pi_estimate/real(num_samples)/real(nproc)

  endif 

  call MPI_Finalize(ierr)
end program serial_monte_carlo_pi


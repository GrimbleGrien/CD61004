program serial_monte_carlo_pi
   implicit none
   include 'mpif.h'

   integer, parameter :: num_samples = 1000000
   integer :: i, istart, iend, batch_size
   integer:: size, rank, ierr
   real :: x, y, pi_local, pi_global

   call MPI_INIT(ierr)
   call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierr)
   call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)


   ! Initialize the random number generator
   call random_seed()
   call random_number(x)
   call random_number(y)

   pi_local=0
   batch_size = (num_samples + size - 1)/size
   istart = batch_size*rank + 1
   iend = min(istart + batch_size - 1, num_samples)

   do i = istart, iend
     call random_number(x)
     call random_number(y)
     if (x**2 + y**2 <= 1.0d0) then
        pi_local = pi_local + 1.0d0
     end if
   end do
   write(*,"(i1, i8, i8, f15.4)") rank, istart, iend, pi_local !/(iend - istart + 1)

   call MPI_REDUCE(pi_local, pi_global, 1, MPI_REAL, MPI_SUM, 0, MPI_COMM_WORLD, ierr)

   if(rank==0) then
      write(*, *) "Estimated Pi: ", 4*pi_global/real(num_samples)
   endif

   ! Calculate the final estimate of Pi and write it to the console
   ! write(*, *) "Estimated Pi: ", 4*pi_estimate/real(num_samples)

   call MPI_FINALIZE(ierr)

end program serial_monte_carlo_pi


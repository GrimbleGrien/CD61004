program example
  use omp_lib
  implicit none

  integer :: i, id, num_threads
  integer, dimension(:), allocatable :: partial_sums
  integer :: total_sum

  num_threads = omp_get_max_threads()

  ! Allocate memory for partial sums
  allocate(partial_sums(num_threads))

  partial_sums = 0
  id = omp_get_thread_num()

  do i =  1, 1000
    partial_sums(id+1) = partial_sums(id+1) + i  
  end do


  write(*,*) "Partial sums from each thread:"
  do i = 1, num_threads
    write(*,*)  "Thread ", i-1, ": ", partial_sums(i) 
  end do
  
  total_sum = sum(partial_sums)
  write(*,*) "Total sum: ", total_sum

  ! Deallocate memory
  deallocate(partial_sums)

end program example

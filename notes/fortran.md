# fortran
## `PRINT` and `WRITE`
`PRINT` is basically shorthand for `WRITE(*,format)` and `*` means standard output. So:
```fortran
PRINT *, "Hi"
!is equivalent to
WRITE(*,*) "Hi"
```
Print in Fortran is asynchronous: the text is buffered, and different ranks can flush to the terminal in unpredictable order, even though your barriers are correct.
## file handling
open close read write
```f90
open(unit=10, file="input.xyz", action="read")
open(unit=11, file="output.xyz", action="write")
read(10,*) var1, var2, ...
write(11, *) var1, var2, ...
close(10)
close(11)
```
## stck and heap
```f90
integer,parameter ::n=100
real :: a(n,n), b(n,n), c(n,n), d(n,n), temp
>>> Segmentation fault (core dumped)
```
By default, Fortran puts local arrays (static) on the **stack**. 
- For n=1000, each 1000×1000 REAL array needs about:
1000 * 1000 * 4 bytes ≈ 4 MB
- You have 4 arrays (a,b,c,d) -> 16 MB.
- Stack limits are much smaller (8 MB per thread), so you crash.

Allocate big arrays on **heap**.
```f90
integer, parameter :: n = 1000
real, allocatable :: a(:,:), b(:,:), c(:,:), d(:,:)
allocate(a(n,n), b(n,n), c(n,n), d(n,n))
```

## utils
```f90
x = call rand()
call random_seed()
call random_number(x)
```
# open mp
## `atomic` and `critical`
```f90
    !$omp parallel do private(index)
    do i = 1, 1000
      index = mod(i, 10) + 1
      !$omp critical
      x(index) = x(index) + 1
      y(index) = y(index) + 1
      !$omp end critical
    end do
```
- Only one thread at a time can enter the whole block.
- Even if two threads want to update different elements `x(3)` vs `x(7)`, they still wait because the entire block is locked.

```f90
!$omp atomic
x(index) = x(index) + 1

!$omp atomic
y(index) = y(index) + 1
```
- Only the memory update itself `x(index) = x(index)+1` is guaranteed atomic.
- Different threads updating different elements can proceed in parallel with no blocking.
- Only threads targeting the same element (same index) contend.

On modern CPUs, ATOMIC is much faster because it maps directly to machine instructions (LOCK XADD etc.), whereas CRITICAL uses a heavier OpenMP runtime lock.

## barrier
https://curc.readthedocs.io/en/latest/programming/OpenMP-Fortran.html

## `master` and `single`
block executed only once ever
- single: one arbitrary thread executes the block 
- master: specifically thread 0 executes block

## parallel block memory
- PRIVATE: Local copies, discarded after region.
- SHARED: Single global copy, persists after region.
- FIRSTPRIVATE: Like PRIVATE, but initialized from the outer variable’s value.
- LASTPRIVATE: Like PRIVATE, but one thread’s value (usually the last iteration of a loop) is copied back to the outer variable at the end.
## `omp_get_wtime()`
omp_get_wtime() is an executable statement — you can’t place it inside the !$omp parallel do directive line.
## array reduction
```f90
!$omp parallel do reduction(+:x, y) private(index)
do i = 1, n
  index = mod(i, 10) + 1
  x(index) = x(index) + 1
  y(index) = y(index) + 1
end do
!$omp end parallel do
```
- In OpenMP, reduction(+:var) is defined only for scalars (like sum_x), not whole arrays.
- Some compilers (e.g., Intel, newer GCC) support array reductions as an extension. Even then, the semantics are: each thread has a private copy of the whole array, and at the end the arrays are reduced element-wise.

Case 1: (unsafe) Inside the loop, multiple iterations across different threads may update the same element x(index) simultaneously. \
Case 2: (safe) If x is a true reduction array, that’s safe (each thread has its own copy).

If the compiler doesn’t implement array reduction, then x is shared, and your increments are racy.
# mpi
## send ssend and isend
1. *mpi_send:* copies msg from application buffer to internal buffer (if space available) and return before receiving process has posted receive. may skip buffer for small msg. **blocking**
2. *mpi_ssend:* always waits (never buffered) until receive is posted by receiving process. (implicit barrier) may cause deadlock if receive not called on receiving end OR ssend called before receive. **blocking**
3. *mpi_isend:* does not wait for receive to be posted or for send buffer to be safe for reuse. user is responsible to ensure `send buffer` is not modified or deallocated until `mpi_isend` has completed. Completion can be checked with `mpi_wait` or `mpi_test`. 
- standard send mode: mpi implementation decides whether to buffer or send synchronously.
## index batches and index hopping
**batches:** more lines of code. faster execution for array data. 
```f90
    batch_size = (N + size - 1)/size
    istart = batch_size*rank + 1
    iend = min(istart + batch_size - 1, N)
    do i=istart,iend
      ...
    enddo
```
**hops:** no extra code. slower execution for array data
```f90
    do i=1+rank,N,size
      ...
    enddo
```
## stdin
Standard input is only accessible to the root process (rank=0) 

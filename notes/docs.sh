# compile vanilla fortran
gfortran hello.f90 -o hello
hello
# compile with OpenMP
mpif90 hello_mpi.f90 -o hello_mpi.x
mpirun -n 4 hello_mpi
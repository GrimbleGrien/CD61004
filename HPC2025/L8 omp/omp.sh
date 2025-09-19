export OMP_NUM_THREADS=4
gfortran -fopenmp test.f90 -o text.x
./test.x

gfortran parallel_hello_world.f90 -o parallel_hello_world.exe -fopenmp

user@acer:~/Desktop/HPC2025/L8$ export OMP_NUM_THREADS=4
user@acer:~/Desktop/HPC2025/L8$ gfortran -fopenmp hello_omp.f90 -o hello
user@acer:~/Desktop/HPC2025/L8$ ./hello 
 hello
 hello
 hello
 hello

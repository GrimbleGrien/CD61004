
## MPI
### Bcast & Reduce Syntax
>MPI_Bcast(data, count, MPI_Datatype, root, MPI_Comm, ierr)

- count: count of members of MPI_datatype
- MPI_Datatype: MPI_LOGICAL, MPI_INTEGER, MPI_REAL, MPI_DOUBLE_PRECISION
- root: root pid, usu. 0

>MPI_Reduce(send_data, recv_data, count, MPI_Datatype, MPI_Op, root, MPI_Comm, ierr)

- MPI_Op: MPI_MAX, MPI_MIN, MPI_SUM, MPI_PROD , etc

### Notes to Remember
- `include 'mpif.h'` (after `implicit none`) OR `use mpi` (before `implicit none`)
- MPI functions are callable using `call`
- Standard input is only accessible to the root process (rank=0) 
- Reduce should be called on all pid, NOT only root.
- Reduce enters inf loop for illegal indices

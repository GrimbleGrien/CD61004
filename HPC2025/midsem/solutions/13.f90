program m
    use mpi
    implicit none
    
    ! Constants
    integer, parameter:: len=1000
    integer :: i, msg(len), N
    integer:: size, rank, err
    real(8):: t1,t2
    N=10001
    msg=42

    call mpi_init(err)
    call mpi_comm_size(mpi_comm_world, size, err)
    call mpi_comm_rank(mpi_comm_world, rank, err)

    t1=mpi_wtime()
    if(rank==0) then
    do i=1,N
        call mpi_ssend(msg, len, mpi_int, 1, 0, mpi_comm_world, err)
        call mpi_recv(msg, len, mpi_int, 1, 0, mpi_comm_world, mpi_status_ignore, err)
    enddo
    endif

    if(rank==1) then
    do i=1,N
        call mpi_recv(msg, len, mpi_int, 0, 0, mpi_comm_world, mpi_status_ignore, err)
        call mpi_ssend(msg, len, mpi_int, 0, 0, mpi_comm_world, err)
    enddo
    endif
    t2=mpi_wtime()
    if(rank==0) then
        print *, "time: ", t2-t1, len
    endif
    
    call mpi_finalize(err)
end


! time:    5.2656430000000004E-003           1
! time:    7.1086910000000003E-003          10
! time:    7.8849860000000001E-003         100
! time:    1.7537553000000001E-002        1000
! time:    9.7984903999999998E-002       10000


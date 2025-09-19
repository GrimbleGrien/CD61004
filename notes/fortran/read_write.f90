program ethanol
    implicit none

    integer, parameter :: natoms=9

    ! harcode static array
    real(kind=8) :: atom_xyz(natoms, 3)
    character(len=10) :: atom_name(natoms)
    integer :: i

    open(unit=100, file='ethanol.xyz', action='read')

    read(10, *)
    read(10, '(a)')

    do i = 1, natoms
        read(10,*) atom_name(i), atom_xyz(i, 1), atom_xyz(i, 2), atom_xyz(i, 3)
        write(*,*) trim(atom_name(i)), atom_xyz(i, 1), atom_xyz(i, 2), atom_xyz(i, 3)
    end do

    close(100)
    
end program

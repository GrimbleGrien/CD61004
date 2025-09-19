program ethanol
	implicit none

	! hardcode
	integer, parameter	:: natoms=9

	! fixe size array
	real(kind=8)		:: atom_xyz(natoms, 3)
	character(len=10)	:: atom_name(natoms)

	! other vars
	integer :: i
	character(len=256) :: comment_line

	open(unit=10, file='ethanol.xyz', action='read')
	!open(unit=11, file='output.xyz', action='write')

	! read & discard
	read(10, *)
	read(10, '(a)') comment_line

	! read
	do i = 1, natoms
		read(10,*) atom_name(i), atom_xyz(i, 1), atom_xyz(i, 2), atom_xyz(i, 3)
	end do

	close(10)

	do i = 1, natoms
		write(*,*) trim(atom_name(i)), ":", atom_xyz(i, 1), atom_xyz(i, 2), atom_xyz(i, 3)
	end do


end program ethanol
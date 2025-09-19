program ethanol
	implicit none

	! hardcode
	! check lines using $ wc input.xyz $ bc -l 
	integer, parameter	:: natoms=13

	! fixe size array
	real(kind=8)		:: x, y, z
	character(len=10)	:: atom_name

	! other vars
	integer :: i, h1, h2

	open(unit=10, file='input3.xyz', action='read')
	open(unit=11, file='output3.xyz', action='write')

	! read
	do
		read(10, *, end=100) h1
		read(10, *) h2
		write(11, *) h1
		write(11, *) h2
		do i = 1, natoms

			read(10,*) atom_name, x, y, z
			x = x+3.0
			write(11, *) atom_name, x, y, z
		end do
	end do

100 continue

	close(10)
	close(11)


end program ethanol
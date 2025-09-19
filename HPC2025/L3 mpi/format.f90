!CRYST1    0.000    0.000    0.000  90.00  90.00  90.00 P 1           1
!      1      X   1      -0.138   1.391   0.001  0.00  0.00           O


program format
	implicit none

	integer:: int1, int2, i
	real:: float(6)
	character:: char1, char2
	character(len=7):: word1

	open(unit=100, file='input4.pdb', action='read')
	open(unit=101, file='output4.pdb', action='write')

	read(100,*) word1, float(1), float(2), float(3),float(4), float(5), float(6), char1, int1, int2
	write(101,"(a6, f9.3, f9.3, f9.3, f7.3, f7.3, f7.3, a2, i2, i12)") word1, float(1), float(2), float(3), &
	&float(4), float(5), float(6), char1, int1, int2

	do i = 1,10
		read(100,*) int1, char1, int2, float(1), float(2), float(3), float(4), float(5), char2
		write(101,"(i7, a7, i4, f12.3, f8.3, f8.3, f6.2, f6.2, a12)") int1, char1, int2, float(1), float(2), &
		&float(3), float(4), float(5), char2
	end do

	close(100)
	close(101)

end program format

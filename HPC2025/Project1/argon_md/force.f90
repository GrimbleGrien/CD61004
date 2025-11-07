subroutine force_calc(TotAtom, Box, Rcut, Sig, Eps, r, nlist, n_neigh, Force, PE)
  implicit none
  integer, intent(in) :: TotAtom
  real(kind=8), intent(in) :: Box, Rcut, Sig, Eps
  real(kind=8), intent(in) :: r(TotAtom,3)
  integer, intent(in) :: nlist(TotAtom, *), n_neigh(TotAtom)
  real(kind=8), intent(out) :: Force(TotAtom,3), PE

  integer :: i, j, n
  real(kind=8) :: dx, dy, dz, r2, r6, r12, ffac, rcut2
  real(kind=8) :: f(3)

  Force = 0.d0
  PE = 0.d0
  rcut2 = Rcut*Rcut

  do i = 1, TotAtom
     do n = 1, n_neigh(i)
        j = nlist(i,n)
        if (j <= i) cycle

        dx = r(i,1) - r(j,1)
        dy = r(i,2) - r(j,2)
        dz = r(i,3) - r(j,3)

        if (dx > 0.5d0*Box) dx = dx - Box
        if (dx < -0.5d0*Box) dx = dx + Box
        if (dy > 0.5d0*Box) dy = dy - Box
        if (dy < -0.5d0*Box) dy = dy + Box
        if (dz > 0.5d0*Box) dz = dz - Box
        if (dz < -0.5d0*Box) dz = dz + Box

        r2 = dx*dx + dy*dy + dz*dz
        if (r2 > rcut2) cycle

        r6 = (Sig**2 / r2)**3
        r12 = r6*r6
        ffac = 48.d0*Eps*(r12 - 0.5d0*r6)/r2
        f = ffac * (/dx, dy, dz/)

        Force(i,:) = Force(i,:) + f
        Force(j,:) = Force(j,:) - f
        PE = PE + 4.d0*Eps*(r12 - r6)
     enddo
  enddo
end subroutine force_calc

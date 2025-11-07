subroutine build_neighbor_list(TotAtom, Box, Rcut, Rskin, r, nlist, n_neigh)
  use general, only: dp
  implicit none
  integer, intent(in) :: TotAtom
  real(kind=dp), intent(in) :: Box, Rcut, Rskin
  real(kind=dp), intent(in) :: r(TotAtom,3)
  integer, intent(out) :: nlist(TotAtom, :)
  integer, intent(out) :: n_neigh(TotAtom)
  integer :: i, j
  real(kind=dp) :: dr(3), r2, Rlist2

  Rlist2 = (Rcut + Rskin)**2
  n_neigh = 0

  do i = 1, TotAtom-1
    do j = i+1, TotAtom
      dr = r(i,:) - r(j,:)
      dr = dr - Box*anint(dr/Box)
      r2 = dot_product(dr, dr)
      if (r2 <= Rlist2) then
        n_neigh(i) = n_neigh(i) + 1
        nlist(i, n_neigh(i)) = j
      endif
    end do
  end do
end subroutine build_neighbor_list

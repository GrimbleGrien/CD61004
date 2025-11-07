subroutine integrate(t, EQMDStep, TotAtom, Mass, Box, Temp, Rcut, Sig, Eps, AtomLabel, TimeStep, r, v, Force, KE, PE)
  implicit none
  integer, intent(in) :: TotAtom, EQMDStep
  real(kind=8), intent(in) :: Mass, Box, Temp, Rcut, Sig, Eps, TimeStep
  character(len=*), intent(in) :: AtomLabel(:)
  real(kind=8), intent(inout) :: t, r(TotAtom,3), v(TotAtom,3), Force(TotAtom,3)
  real(kind=8), intent(out) :: KE, PE

  ! Verlet list parameters
  real(kind=8), parameter :: Rskin = 0.3d0
  integer, parameter :: maxneigh = 200

  ! --- Persistent neighbor data
  integer, allocatable, save :: nlist(:,:), n_neigh(:)
  real(kind=8), allocatable, save :: old_r(:,:), disp(:,:)
  logical, save :: list_built = .false.

  integer :: i, j
  real(kind=8) :: sumv, sumv2, Tins

  ! --- Allocate neighbor list arrays once ---
  if (.not. allocated(nlist)) then
     allocate(nlist(TotAtom, maxneigh))
     allocate(n_neigh(TotAtom))
     allocate(old_r(TotAtom,3))
     allocate(disp(TotAtom,3))
     nlist = 0
     n_neigh = 0
     old_r = r
     disp = 0.d0
     call build_neighbor_list(TotAtom, Box, Rcut, Rskin, r, nlist, n_neigh)
     list_built = .true.
  endif

  ! --- Compute displacement since last neighbor build ---
  disp = disp + abs(r - old_r)
  if (any(disp > Rskin*0.5d0)) then
     call build_neighbor_list(TotAtom, Box, Rcut, Rskin, r, nlist, n_neigh)
     old_r = r
     disp = 0.d0
  endif

  ! --- Force calculation with neighbor list ---
  call force_calc(TotAtom, Box, Rcut, Sig, Eps, r, nlist, n_neigh, Force, PE)

  ! --- Velocity update ---
  sumv = 0.d0
  sumv2 = 0.d0
  do i = 1, TotAtom
     v(i,:) = v(i,:) + 0.5d0 * TimeStep * (Force(i,:) / Mass)
     sumv2 = sumv2 + dot_product(v(i,:), v(i,:))
  enddo

  sumv2 = Mass * sumv2
  KE = sumv2 / 2.d0

  ! --- Periodic boundary check ---
  do i = 1, TotAtom
     do j = 1, 3
        if (r(i,j) > Box) r(i,j) = r(i,j) - Box
        if (r(i,j) < 0.d0) r(i,j) = r(i,j) + Box
     enddo
  enddo

end subroutine integrate


subroutine build_neighbor_list(TotAtom, Box, Rcut, Rskin, r, nlist, n_neigh)
  implicit none
  integer, intent(in) :: TotAtom
  real(kind=8), intent(in) :: Box, Rcut, Rskin
  real(kind=8), intent(in) :: r(TotAtom,3)
  integer, intent(out) :: nlist(TotAtom, *), n_neigh(TotAtom)

  integer :: i, j, n
  real(kind=8) :: dx, dy, dz, r2, rcut2

  rcut2 = (Rcut + Rskin)**2
  n_neigh = 0

  do i = 1, TotAtom - 1
     do j = i + 1, TotAtom
        dx = r(i,1) - r(j,1)
        dy = r(i,2) - r(j,2)
        dz = r(i,3) - r(j,3)

        ! Minimum image convention
        if (dx > 0.5d0*Box) dx = dx - Box
        if (dx < -0.5d0*Box) dx = dx + Box
        if (dy > 0.5d0*Box) dy = dy - Box
        if (dy < -0.5d0*Box) dy = dy + Box
        if (dz > 0.5d0*Box) dz = dz - Box
        if (dz < -0.5d0*Box) dz = dz + Box

        r2 = dx*dx + dy*dy + dz*dz
        if (r2 < rcut2) then
           n_neigh(i) = n_neigh(i) + 1
           nlist(i, n_neigh(i)) = j
           n_neigh(j) = n_neigh(j) + 1
           nlist(j, n_neigh(j)) = i
        endif
     enddo
  enddo
end subroutine build_neighbor_list


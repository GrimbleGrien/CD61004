subroutine integrate(t, EQMDStep, TotAtom, Mass, Box, Temp, Rcut, Sig, Eps, AtomLabel, TimeStep, r, v, Force, KE, PE)
  use general, only: dp
  use conversions, only: LengthConv
  implicit none

  integer, intent(in) :: TotAtom, EQMDStep
  real(kind=dp), intent(in) :: Mass, Box, Temp, Rcut, Sig, Eps, TimeStep
  real(kind=dp), intent(inout) :: t
  real(kind=dp), intent(inout) :: r(TotAtom,3), v(TotAtom,3), Force(TotAtom,3)
  character(len=*), intent(in) :: AtomLabel(:)
  real(kind=dp), intent(out) :: KE, PE

  ! Parameters for auto-estimation and rebuild frequency
  integer, parameter :: Nupdate_target = 20    ! target timesteps between list rebuilds
  integer, parameter :: check_interval = 5     ! check rebuild every N steps (saves cost)
  real(kind=dp), parameter :: Rskin_min_A = 0.2d0  ! minimum Rskin in Angstrom
  real(kind=dp), parameter :: Rskin_max_A = 1.0d0  ! maximum Rskin in Angstrom
  integer, parameter :: safety_buffer = 20        ! extra neighbors to add

  ! Persistent neighbor-list storage (allocated once)
  integer, allocatable, save :: nlist(:,:), n_neigh(:)
  integer, save :: maxneigh_alloc = 0
  real(kind=dp), allocatable, save :: old_r(:,:), disp(:,:)
  real(kind=dp), save :: Rskin = 0.d0
  logical, save :: list_initialized = .false.

  ! Local temporaries
  integer :: i, j, step, n, maxneigh_est
  real(kind=dp) :: TimeStep2, sumv2, v_rms, density, Rlist, max_disp
  real(kind=dp) :: Rskin_min, Rskin_max

  ! --- convert Rskin min/max to internal units (atomic units) ---
  Rskin_min = Rskin_min_A / LengthConv
  Rskin_max = Rskin_max_A / LengthConv

  ! --- First-time allocation and initial neighbor-list build ---
  if (.not. list_initialized) then
     ! estimate an initial Rskin (small value, will be replaced below)
     Rskin = 0.3d0 / LengthConv   ! default 0.3 A -> a.u.

     ! estimate maxneigh conservatively (temporary)
     maxneigh_est = 200

     allocate(nlist(TotAtom, maxneigh_est))
     allocate(n_neigh(TotAtom))
     allocate(old_r(TotAtom,3))
     allocate(disp(TotAtom,3))

     nlist = 0
     n_neigh = 0
     old_r = r
     disp = 0.d0
     maxneigh_alloc = maxneigh_est

     ! build initial neighbor list with this default
     call build_neighbor_list(TotAtom, Box, Rcut, Rskin, r, nlist, n_neigh)
     list_initialized = .true.
  endif

  ! --- Estimate optimal Rskin from current velocities ---
  ! compute v_rms from current velocities (velocities expected in same units as r/time)
  sumv2 = 0.d0
  do i = 1, TotAtom
     sumv2 = sumv2 + dot_product(v(i,:), v(i,:))
  end do
  v_rms = sqrt(sumv2 / real(TotAtom, dp))

  ! Rskin chosen so list stays valid for ~Nupdate_target timesteps:
  Rskin = 0.5d0 * v_rms * TimeStep * real(Nupdate_target, dp)

  ! clamp Rskin to reasonable bounds
  if (Rskin < Rskin_min) Rskin = Rskin_min
  if (Rskin > Rskin_max) Rskin = Rskin_max

  ! --- Estimate max neighbors per atom (and reallocate if needed) ---
  density = real(TotAtom, dp) / (Box**3)
  Rlist = Rcut + Rskin
  maxneigh_est = int(4.18879020478639d0 * density * (Rlist**3)) + safety_buffer
  if (maxneigh_est < 10) maxneigh_est = 10

  if (maxneigh_est > maxneigh_alloc) then
     ! need larger allocation: deallocate and reallocate with new size
     deallocate(nlist)
     maxneigh_alloc = maxneigh_est
     allocate(nlist(TotAtom, maxneigh_alloc))
     nlist = 0
     ! reinitialize n_neigh and others
     n_neigh = 0
     old_r = r
     disp = 0.d0
     ! build neighbor list with new size
     call build_neighbor_list(TotAtom, Box, Rcut, Rskin, r, nlist, n_neigh)
  endif

  ! --- Determine current MD step (integer) and perform position update ---
  step = int(t / TimeStep)
  TimeStep2 = TimeStep * TimeStep

  do i = 1, TotAtom
     r(i,:) = r(i,:) + TimeStep * v(i,:) + 0.5d0 * TimeStep2 * (Force(i,:) / Mass)
  end do

!   ! (optional) scale velocities during equilibration - keep your existing logic
!   if (step < EQMDStep) then
!      call compute_temp(TotAtom, Mass, v, sumv2)   ! sumv2 reused for Tins if compute_temp sets it
!      ! compute_temp should set Tins internally or return; if it returns Tins replace accordingly.
!      ! Here we assume compute_temp sets a common variable or you can compute ScaleTemp externally.
!      ! For safety, do a no-op if compute_temp is not present:
!   end if

  ! --- Rebuild check every 'check_interval' timesteps to save cost ---
  if (mod(step, check_interval) == 0) then
     disp = r - old_r
     max_disp = maxval(sqrt(sum(disp**2, dim=2)))
     if (2.d0 * max_disp > Rskin) then
        call build_neighbor_list(TotAtom, Box, Rcut, Rskin, r, nlist, n_neigh)
        old_r = r
        disp = 0.d0
     end if
  end if

  ! --- Force calculation using neighbor list ---
  call force_calc(TotAtom, Box, Rcut, Sig, Eps, r, nlist, n_neigh, Force, PE)

  ! --- Final velocity update and diagnostics ---
  sumv2 = 0.d0
  do i = 1, TotAtom
     v(i,:) = v(i,:) + 0.5d0 * TimeStep * (Force(i,:) / Mass)
     sumv2 = sumv2 + dot_product(v(i,:), v(i,:))
  end do
  sumv2 = Mass * sumv2
  KE = sumv2 / 2.d0

  ! --- Apply periodic boundary conditions ---
  do i = 1, TotAtom
     do j = 1, 3
        if (r(i,j) > Box) r(i,j) = r(i,j) - Box
        if (r(i,j) < 0.d0) r(i,j) = r(i,j) + Box
     end do
  end do

  return
end subroutine integrate


!-----------------------------------------
! build_neighbor_list subroutine
!-----------------------------------------
subroutine build_neighbor_list(TotAtom, Box, Rcut, Rskin, r, nlist, n_neigh)
  use general, only: dp
  implicit none
  integer, intent(in) :: TotAtom
  real(kind=dp), intent(in) :: Box, Rcut, Rskin
  real(kind=dp), intent(in) :: r(TotAtom,3)
  integer, intent(inout) :: nlist(TotAtom, *), n_neigh(TotAtom)

  integer :: i, j
  real(kind=dp) :: dx, dy, dz, r2, Rlist2

  Rlist2 = (Rcut + Rskin)**2
  n_neigh = 0

  do i = 1, TotAtom - 1
     do j = i + 1, TotAtom
        dx = r(i,1) - r(j,1); dy = r(i,2) - r(j,2); dz = r(i,3) - r(j,3)

        ! minimum image
        if (dx > 0.5d0*Box) dx = dx - Box
        if (dx < -0.5d0*Box) dx = dx + Box
        if (dy > 0.5d0*Box) dy = dy - Box
        if (dy < -0.5d0*Box) dy = dy + Box
        if (dz > 0.5d0*Box) dz = dz - Box
        if (dz < -0.5d0*Box) dz = dz + Box

        r2 = dx*dx + dy*dy + dz*dz
        if (r2 <= Rlist2) then
           n_neigh(i) = n_neigh(i) + 1
           nlist(i, n_neigh(i)) = j
           n_neigh(j) = n_neigh(j) + 1
           nlist(j, n_neigh(j)) = i
        end if
     end do
  end do
end subroutine build_neighbor_list

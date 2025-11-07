
# CD61004: Project 1

## Task
Implement **Verlet neighbour list** algorithm in the given MD code and check for its
performance by plotting the CPU/wall time for different system size. Also include a note on
changes in wall time before and after implementing the neighbour lists. 
## Deliverable(s)
Project report: write the list of changes (maximum five page) you have done for code.
Include plots (if any).
## van der waal force
- short range force
- cutoff distance (sigma)
- TC $O(N^2)$
$$V(r) = 4\varepsilon \left[ \left( \frac{\sigma}{r} \right)^{12} - \left( \frac{\sigma}{r} \right)^6 \right]
$$

```f90
 ! VdW force calc 
 R2cut=Rcut*Rcut 
 ! calculating Ecut at Rcut 
 fac2=Sig*Sig/R2cut
 fac6=fac2*fac2*fac2
 Ecut=4.d0*Eps*fac6*(fac6-1)
```
## verlet neighbor list
- add displacement contraint to Rcut
- store atoms inside $r_v = r_{cut} + r_{skin}$
- rskin (buffer distance) accounts for small displacements
- During several timesteps, forces are computed only using this list.
- list is rebuilt only when an atom has moved more than $r_{skin}/2$
- tune r_skin for optimal TC $O(N*N_v)$

## further optimise (cell list)
Combined Optimization: Cell Lists

- To build neighbor lists efficiently, the system is divided into cells of size >= r_list
- Each atom only checks neighbors in its cell and adjacent cells.
- List build cost O(N)
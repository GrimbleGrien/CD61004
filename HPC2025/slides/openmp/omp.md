# OpenMP (Open Multi-Processing)

## Overview
### Shared Memory Parallelism:
OpenMP is designed for shared-memory systems, where multiple processor cores can directly access the same memory. This is typical of a single multi-core processor or a node within a cluster.
### Thread-based:
It utilizes threads to achieve parallelism. A master thread forks a team of slave threads to execute parallel regions of code.
### Compiler Directives:
Parallelism is typically expressed using compiler directives (pragmas in C/C++, directives in Fortran) inserted into the code, instructing the compiler on how to parallelize loops or sections.
### Implicit Communication:
Communication between threads is implicit through shared memory, requiring careful management of data races and synchronization.
### Ease of Use:
Generally considered easier to learn and implement for shared-memory parallelism due to its directive-based approach.


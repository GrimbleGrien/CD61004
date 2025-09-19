# MPI (Message Passing Interface)

## Overview
### Distributed Memory Parallelism:
MPI is designed for distributed-memory systems, such as networked clusters or supercomputers, where each processing unit (node or core) has its own independent memory space.
### Process-based:
It utilizes separate processes, each with its own memory space, to achieve parallelism.
### Explicit Communication:
Communication between processes is explicit and achieved through message passing routines (e.g., send, receive, broadcast). Programmers must explicitly manage data transfer.
### Scalability:
Highly scalable and suitable for large-scale parallel applications running across many nodes.
### Complexity:
Can be more complex to program due to the explicit handling of communication and data distribution.
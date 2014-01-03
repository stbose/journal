
Memory bandwidth limited operations 
============


(N.B. This performance analysis was motivated from a 
 talk by W. Gropp on Blue Waters at NCSA.) 


We want to construct the upper bound for the 
flop count of an operation that is memory bandwidth 
limited.  Suppose we want to perform a naive 
dot product

~~~~
double alpha = 0.0; 
for (int i=0 ; i < n ; ++i) 
  alpha += x[i] * y[i] ; 
~~~~

where $x,y \in R^n$ are two scalar vectors.  This 
operation requires $2n$ flops ($n$ multiply and 
$n$ add) and $2n$ loads from memory.  We ignore the 
cost of the store of $\alpha$ assuming that $n$ is 
large.  The throughput (flops/sec), $R$,  can be written as 

(@through) $R = \frac{2n}{T_{dp}}$

where $T_{dp}$ is the time of the operation.  The 
exact pipelining is hardware dependent the total 
time must be greater than either the time of the 
flops, $T_{fl}$ or the time to load the memory, $T_{read}$

(@time_est) $T_{dp} \geq \max(T_{fl}, T_{read})$

Let $B_{mem}$ denote the memory bandwidth.  Assuming 
a perfect cache (where data is only loaded once from 
memory), 

(@time_read) $T_{read} = \frac{2nS_{double}}{B_{mem}}$

If the operation is limited by the memory bandwidth 
of the system, then the rate in (@through) is bounded from above by

(@upper_bound_dp) $R \leq \frac{2n}{T_{read}} = 
   \frac{B_{mem}}{S_{double}}$ 


I ran a few sample tests on a Intel Sandy Bridge 
workstation (E5-2620) on a single core.  The quoted 
max flop rate for this architecture is approximately 
16 GFlops/sec for a single core.  Using the perf suite 
of tools, the flop count for this simple dot product
was approximately $1.1 GFlops/sec$ for $n = 32^3$; a paltry 7% of the 
peak.  The memory bandwidth, $B_{mem}$, was measured 
using a simple copy operation 

~~~~
for (int i=0 ; i < n; ++i)
  a[i] = b[i] 
~~~~

yielding $B_{mem} = 9.9 GB/sec$.  Running the STREAM benchmark 
with vector sizes, $n = 10^4 - 10^6$, yielded $7.7 GB/sec \leq 
B_{mem} \leq 12.1 GB/sec$, so our estimate is within the STREAM 
range.  (The max memory bandwidth is 43 GB/sec.)  The memory 
bandwidth limited throughput is $R \leq 1.25 GFlops/sec$; so, 
we the simple dot product operation is nearly at the peak (88%).


We can also consider the case of the sparse-matrix vector 
multiply that arises from a second-order edge-based differencing 
operator, $y = Dx$.  The 3d differencing operator, $D$, involves $6$ neighbors, so 
each row of the differencing matrix has $6$ nonzeros. The 
total number of reads is then 

(@grad_read) $\underbrace{6n}_{matrix} + \underbrace{n}_{vector} = 7n$


We also have $n$ stores for the vector, $y$, and assuming that 
the memory bandwidth for the writes is the same as the reads (likely slower), 
the total time for the memory is then 

(@grad_mem_time) $T_{mem} = T_{write} + T_{read} = \frac{8nS_{double}}{B_{mem}}$

The total number of flops for teh sparse matrix-vector product 
per row is $6$ multiplications and $6$ adds (can be reduced to $5$ 
adds if a tree like reduction is done).  Then the bandwidth limited 
throughput for this operation is 

(@grad_through_bound) $R \leq \frac{12n}{T_{mem}} = \frac{3B_{mem}}{2S_{double}}$

Using the bandwidth measurements above for the size of the matrix arising 
from $n = 32^3$ on an orthogonal Cartesian mesh 
(each row has roughly 27 neighbors from the mesh connectivity and 
$B_{mem} \approx 8 GB/sec$ for this size), the MV product peaks at 
$1.5 GFlops/sec$ or about 9% of the peak throughput.  
Using a variety of matrix storage techniques and other optimizations, 
I was able to achieve anywhere from $1.0-1.2 GFlops/sec$.  This is 
67%-80% of bandwidth limited upper bound; the inefficiencies likely 
due to cache misses and non-overlapped floating point and memory related
instructions.





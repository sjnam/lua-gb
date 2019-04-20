--[[
Introduction.
This demonstration program uses graphs
constructed by the |raman| procedure in the {\sc GB\_\,RAMAN} module to produce
an interactive program called \.{girth}, which computes the girth and
diameter of a class of Ramanujan graphs.

The girth of a graph is the length of its shortest cycle; the diameter
is the maximum length of a shortest path between two vertices.
A Ramanujan graph is a connected, undirected graph in which every vertex
@^Ramanujan graphs@>
has degree~|p+1|, with the property that every eigenvalue of its adjacency
matrix is either $\pm(p+1)$ or has absolute value $\le2\sqrt{\mathstrut p}$.

Exact values for the girth are of interest because the bipartite graphs
produced by |raman| apparently have larger girth than any other known
family of regular graphs, even if we consider graphs whose existence
is known only by nonconstructive methods, except for the cubic ``sextet''
graphs of Biggs, Hoare, and Weiss [{\sl Combinatorica\/ \bf3} (1983),
153--165; {\bf4} (1984), 241--245].

Exact values for the diameter are of interest because the diameter of
any Ramanujan graph is at most twice the minimum possible diameter
of any regular graph.

The program will prompt you for two numbers, |p| and |q|. These should
be distinct prime numbers, not too large, with |q>2|.  A graph is
constructed in which each vertex has degree~|p+1|. The number of
vertices is $(q^3-q)/2$ if |p| is a quadratic residue modulo~|q|, or
$q^3-q$ if |p| is not a quadratic residue. In the latter case, the
graph is bipartite and it is known to have rather large girth.

If |p=2|, the value of |q| is further restricted to be of the form
$104k+(1,3,9,17,25,27,35,43,49,\allowbreak51,75,81)$. This means that the only
feasible values of |q| to go with |p=2| are probably 3, 17, and 43;
the next case, |q=107|, would generate a bipartite graph with
1,224,936 vertices and 3,674,808 arcs, thus requiring approximately
113 megabytes of memory (not to mention a nontrivial amount of
computer time). If you want to compute the girth and diameter
of Ramanujan graphs for large |p| and/or~|q|, much better methods are
available based on number theory; the present program is merely a
demonstration of how to interface with the output of |raman|.
Incidentally, the graph for |p=2| and |q=43| turns
out to have 79464 vertices, girth 20, and diameter~22.

The program will examine the graph and compute its girth and its diameter,
then will prompt you for another choice of |p| and |q|.
--]]


local bit = require "bit"
local ffi = require "ffi"
local sgb = require "sgb"
local gb = sgb.gb
local band, bxor = bit.band, bit.bxor
local floor = math.floor
local io_write = io.write
local printf = sgb.printf


-- main

print("This program explores the girth and diameter of Ramanujan graphs.")
print("The bipartite graphs have q^3-q vertices, and the non-bipartite")
print("graphs have half that number. Each vertex has degree p+1.")
print("Both p and q should be odd prime numbers;")
print("  or you can try p = 2 with q = 17 or 43.")

while true do
   io_write("\nChoose a branching factor, p: ")
   local p = tonumber(io.read())
   if not p then break end
   io_write("OK, now choose the cube root of graph size, q: ");
   local q = tonumber(io.read())
   if not q then break end

   local g = gb.raman(p, q, 0, 0)
   if g == nil then
      local panic_code = gb.panic_code
      printf(" Sorry, I couldn't make that graph (%s).\n",
             panic_code == 40 and "q is out of range" or
                panic_code == 41 and "p is out of range" or
                panic_code == 35 and "q is too big" or
                panic_code == 36 and "p is too big" or
                panic_code == 31 and "q isn't prime" or
                panic_code == 37 and "p isn't prime" or
                panic_code == 33 and "p is a multiple of q" or
                panic_code == 32 and "q isn't compatible with p=2" or
                "not enough memory")
   else
      local bipartite = false
      local n = tonumber(g.n)
      if n == (q+1) * q * (q-1) then
         bipartite = true
      end

      printf("The graph has %d vertices, each of degree %d, "
                .."and it is %sbipartite.\n", n, p+1, bipartite and "" or "not ")

      local s, dl, pp, gu = p+2, 1, p, 3
      while s < n do
         s = s + pp
         if s <= n then gu = gu + 1 end
         dl = dl + 1
         pp = pp * p
         s = s + pp
         if s <= n then gu = gu + 1 end
      end

      printf("Any such graph must have diameter >= %d and girth <= %d;\n",
             dl, gu)

      local du
      do
         local nn = (bipartite and n or 2*n)
         du = 0
         pp = 1
         while pp < nn do
            du = du + 2
            pp = pp * p
         end

         do
            local qq = floor(pp/nn)
            if qq * qq > p then
               du = du - 1
            elseif (qq+1) * (qq+1) > p then
               local aa = qq
               local bb = p - aa*aa
               local parity = 0
               pp = pp - qq*nn
               while true do
                  local x = floor((aa+qq) / bb)
                  local y = nn - x*pp
                  if y <= 0 then break end
                  aa = bb*x - aa
                  bb = floor((p - aa*aa) / bb)
                  nn = pp
                  pp = y
                  parity = bxor(parity, 1)
               end
               if parity == 0 then du = du - 1 end
            end
         end
         if bipartite then du = du + 1 end
      end

      printf("theoretical considerations tell us that "
                .."this one's diameter is <= %d", du)

      if p == 2 then
         print(".")
      else
         if bipartite then
            local b = q * q
            gl = 1
            pp = p
            while pp <= b do
               gl = gl + 1
               pp = pp * p
            end
            gl = gl + gl
         else
            local b1, b2 = 1 + 4*q*q, 4 + 3*q*q
            gl = 1
            pp = p
            while pp < b1 do
               if pp >= b2 and band(gl, 1) ~= 0 and band(p, 2) ~= 0 then
                  break
               end
               gl = gl + 1
               pp = pp * p
            end
         end
         printf(",\nand its girth is >= %d.\n", gl)
      end

      print("Starting at any given vertex, there are")

      do
         local k, c = 0, 1
         local sentinel, girth = g.vertices+n, 999
         local u = g.vertices
         u.w.V = sentinel
         while c ~= 0 do
            local v = u
            u = sentinel
            c = 0
            k = k + 1
            while v ~= sentinel do
               for a in sgb.arcs(v) do
                  local w = a.tip
                  if w.w.V == nil then
                     w.w.V = u
                     w.v.I = k
                     w.u.V = v
                     u = w;
                     c = c + 1
                  elseif w.v.I+k < girth and w ~= v.u.V then
                     girth = w.v.I + k
                  end
               end
               v = v.w.V
            end
            printf("%8d vertices at distance %d%s\n", c, k,
                   (c > 0 and "," or "."))
         end
         printf("So the diameter is %d, and the girth is %d.\n",
                k-1, tonumber(girth))
      end

      gb.gb_recycle(g)
   end
end

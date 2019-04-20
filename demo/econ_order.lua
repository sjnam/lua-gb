--[[
   @* Near-triangular ordering.
   This demonstration program takes a matrix of data
   constructed by the {\sc GB\_\,ECON} module and permutes the economic sectors
   so that the first sectors of the ordering tend to be producers of
   primary materials for other industries, while the last sectors
   tend to be final-product
   industries that deliver their output mostly to end users.

   More precisely, suppose the rows of the matrix represent the outputs
   of a sector and the columns represent the inputs. This program attempts
   to find a permutation of rows and columns that minimizes the sum of
   the elements below the main diagonal. (If this sum were zero, the
   matrix would be upper triangular; each supplier of a sector would precede
   it in the ordering, while each customer of that sector would follow it.)

   The general problem of finding a minimizing permutation is NP-complete;
   it includes, as a very special case, the {\sc FEEDBACK ARC SET} problem
   discussed in Karp's classic paper [{\sl Complexity of Computer
   Computations} (Plenum Press, 1972), 85--103].
   But sophisticated ``branch and cut'' methods have been developed that work
   well in practice on problems of reasonable size.
   Here we use a simple heuristic downhill method
   to find a permutation that is locally optimum, in the sense that
   the below-diagonal sum does not decrease if any individual
   sector is moved to another position while preserving the relative order
   of the other sectors. We start with a random permutation and repeatedly
   improve it, choosing the improvement that gives the least positive
   gain at each step. A primary motive for the present implementation
   was to get further experience with this method of cautious descent, which
   was proposed by A. M. Gleason in {\sl AMS Proceedings of Symposia in Applied
   Mathematics\/ \bf10} (1958), 175--178. (See the comments following
   the program below.)

   @ As explained in {\sc GB\_\,ECON}, the subroutine call |econ(n,2,0,s)|
   constructs a graph whose |n<=79| vertices represent sectors of the
   U.S. economy and whose arcs $u\to v$ are assigned numbers corresponding to the
   flow of products from sector~|u| to sector~|v|. When |n<79|, the
   |n| sectors are obtained from a basic set of 79 sectors by
   combining related commodities. If |s=0|, the combination is done in
   a way that tends to equalize the row sums, while if |s>0|, the combination
   is done by choosing a random subtree of a given 79-leaf tree;
   the ``randomness'' is fully determined by the value of~|s|.

   This program uses two random number seeds, one for |econ| and one
   for choosing the random initial permutation. The former is called~|s|
   and the latter is called~|t|. A further parameter, |r|, governs the
   number of repetitions to be made; the machine will try |r|~different
   starting permutations
   on the same matrix. When |r>1|, new solutions are displayed only when
   they improve on the previous best.

   By default, |n=79|, |r=1|, and |s=t=0|. The user can change these
   default parameters by specifying options
   on the command line, at least in a \UNIX/ implementation, thereby
   obtaining a variety of special effects. The relevant
   command-line options are \.{-n}\<number>, \.{-r}\<number>,
   \.{-s}\<number>, and/or \.{-t}\<number>. Additional options
   \.{-v} (verbose), \.{-V} (extreme verbosity), and \.{-g}
   (greedy or steepest descent instead of cautious descent) are also provided.
--]]


local ffi = require "ffi"
local sgb = require "sgb"
local gb = sgb.gb
local ffi_new = ffi.new
local str = ffi.string
local ipairs = ipairs
local io_write = io.write
local io_flush = io.flush
local tonumber = tonumber
local sformat = string.format
local printf = sgb.printf

local INF = 0x7fffffff
local best_score = INF
local mat = ffi_new("int32_t[79][79]")
local del = ffi_new("int32_t[79][79]")
local mapping = ffi_new("int32_t[79]")
local g


-- main

local n, s, t, r, greedy = 79, 0, 0, 1, false
for _, a in ipairs(arg) do
   local k, v = a:match("-(%a)(%d+)")
   if k == "n" then
      n = tonumber(v)
   elseif k == "r" then
      r = tonumber(v)
   elseif k == "s" then
      s = tonumber(v)
   elseif k == "t" then
      t = tonumber(v)
   else
      k, v = a:match("-(%a)")
      if k == "v" then
         gb.verbose = 1
      elseif k == "V" then
         gb.verbose = 2
      elseif k == "g" then
         greedy = true
      else
         printf("Usage: luajit %s [-nN][-rN][-sN][-tN][-g][-v][-V]\n", arg[0])
         return
      end
   end
end

g = gb.econ(n, 2, 0, s)
if not g then
   printf("Sorry, can't create the matrix! (error code %d)\n",
          tonumber(gb.panic_code))
   return
end

local gvertices = g.vertices
local function sec_name (k)
   return str(gvertices[mapping[k]]['name'])
end

printf("Ordering the sectors of %s, using seed %d:\n", str(g.id), t)
printf(" (%s descent method)\n", greedy and "Steepest" or "Cautious")

for v in sgb.vertices(g) do
   for a in sgb.arcs(v) do
      mat[v-gvertices][a.tip-gvertices] = a.a.I
   end
end

n = tonumber(g.n)
for j=0,n-1 do
   for k=0,n-1 do
      del[j][k] = mat[j][k] - mat[k][j]
   end
end

local sum = 0
for j=1,n-1 do
   for k=0,j-1 do
      if mat[j][k] <= mat[k][j] then
         sum = sum + mat[j][k]
      else
         sum = sum + mat[k][j]
      end
   end
end
printf("(The amount of feed-forward must be at least %d.)\n", sum)

gb.gb_init_rand(t)

local steps, score = 0, 0
local best_d, best_k, best_j = 0, 0, 0
while r > 0 do
   for k=0,n-1 do
      local j = gb.gb_unif_rand(k+1)
      mapping[k] = mapping[j]
      mapping[j] = k
   end
   for j=1,n-1 do
      for k=0,j-1 do
         score = score + mat[mapping[j]][mapping[k]]
      end
   end
   if gb.verbose > 1 then
      io_write("\nInitial permutation:\n")
      for k=0,n-1 do
         printf(" %s\n", sec_name(k))
      end
   end
   while true do
      best_d = greedy and 0 or INF
      best_k = -1
      for k=0,n-1 do
         local d = 0
         for j=k-1,0,-1 do
            d = d + del[mapping[k]][mapping[j]]
            if d > 0 and (greedy and d > best_d or d < best_d) then
               best_k = k
               best_j = j
               best_d = d
            end
         end
         d = 0
         for j=k+1,n-1 do
            d = d + del[mapping[j]][mapping[k]]
            if d > 0 and (greedy and d > best_d or d < best_d) then
               best_k = k
               best_j = j
               best_d = d
            end
         end
      end
      if best_k < 0 then break end
      if gb.verbose > 0 then
         printf("%8d after step %d\n", score, steps)
      elseif steps % 1000 == 0 and steps > 0 then
         io_write(".")
         io_flush()
      end
      if gb.verbose > 1 then
         printf("Now move %s to the %s, past\n", sec_name(best_k),
                best_j < best_k and "left" or "right")
      end
      j = best_k
      k = mapping[j]
      repeat
         if best_j < best_k then
            mapping[j] = mapping[j-1]
            j = j - 1
         else
            mapping[j] = mapping[j+1]
            j = j + 1
         end
         if gb.verbose > 1 then
            printf("    %s (%d)\n", sec_name(j),
                   best_j < best_k and del[mapping[j+1]][k] or
                      del[k][mapping[j-1]])
         end
      until j == best_j
      mapping[j] = k
      score = score - best_d
      steps = steps + 1
   end
   printf("\n%s is %d, found after %d step%s.\n",
          best_score == INF and "Local minimum feed-forward" or
          "Another local minimum", score,
          steps, steps == 1 and "" or "s")
   if gb.verbose > 0 or score < best_score then
      io_write("The corresponding economic order is:\n")
      for k=0,n-1 do
         printf(" %s\n", sec_name(k))
         if score < best_score then
            best_score = score
         end
      end
   end
   r = r - 1
end

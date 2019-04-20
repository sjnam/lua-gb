--[[
@* Introduction. This demonstration program uses graphs
constructed by the {\sc GB\_WORDS} module to produce
an interactive program called \.{ladders}, which finds shortest paths
between two given five-letter words of English.

The program assumes that \UNIX/ conventions are being used. Some code in
sections listed under `\UNIX/ dependencies' in the index might need to change
if this program is ported to other operating systems.

\def\<#1>{$\langle${\rm#1}$\rangle$}
To run the program under \UNIX/, say `\.{ladders} \<options>', where \<options>
consists of zero or more of the following specifications in any order:

-v Verbosely print all words encountered during the shortest-path
   computation, showing also their distances from the goal word.
-a Use alphabetic distance instead of considering adjacent words to be one
   unit apart; for example, the alphabetic distance from `\.{words}' to
   `\.{woods}' is~3, because `\.r' is three places from `\.o' in the
   alphabet.
-f Use distance based on frequency (see below), instead of considering
   adjacent words to be one unit apart. This option is ignored if either
   \.{-a} or \.{-r} has been specified.
-h Use a lower-bound heuristic to shorten the search (see below). This option
   is ignored if option \.{-f} has been selected.
-e Echo the input to the output (useful if input comes from a file instead
   of from the terminal).
-n<number> Limit the graph to the |n| most common English words, where |n|
   is the given \<number>.
-r<number> Limit the graph to \<number> randomly selected words. This option
   is incompatible with~\.{-n}.
-s<number> Use \<number> instead of 0 as the seed for random numbers, to get
     different random samples or to explore words of equal frequency in
     a different order.

\noindent Option \.{-f} assigns a cost of 0 to the most common words and a
cost of 16 to the least common words; a cost between 0 and~16 is assigned to
words of intermediate frequency. The word ladders that are found will then have
minimum total cost by this criterion. Experience shows that the \.{-f} option
tends to give the ``friendliest,'' most intuitively appealing ladders.
\smallskip
Option \.{-h} attempts to focus the search by giving priority to words that
are near the goal. (More precisely, it modifies distances between adjacent
words by using a heuristic function $\\{hh}(v)$, which would be the shortest
possible distance between $v$ and the goal if every five-letter combination
happened to be an English word.) The {\sc GB\_\,DIJK} module explains more
about such heuristics; this option is most interesting to watch when used in
conjunction with \.{-v}.

@ The program will prompt you for a starting word. If you simply type
\<return>, it exits; otherwise you should enter a five-letter word
(with no uppercase letters) before typing \<return>.

Then the program will prompt you for a goal word. If you simply type
\<return> at this point, it will go back and ask for a new starting word;
otherwise you should specify another five-letter word.

Then the program will find and display an optimal word ladder from the start
to the goal, if there is a path from one to the other
that changes only one letter at a time.

And then you have a chance to start all over again, with another starting word.

The start and goal words need not be present in the program's graph of
``known'' words. They are temporarily added to that graph, but removed
again whenever new start and goal words are given. (Thus you can go
from \.{sturm} to \.{drang} even though those words aren't English.)
If the \.{-f} option is being used, the cost of the goal word will be 20
when it is not in the program's dictionary.
--]]


local bit = require "bit"
local ffi = require "ffi"
local sgb = require "sgb"
local gb = sgb.gb
local ffi_new = ffi.new
local NULL = ffi.null
local str = ffi.string
local rshift = bit.rshift
local arcs = sgb.arcs
local vertices = sgb.vertices
local printf = sgb.printf

local g, gg, uu, vv
local start, goal, min_dist
local n, seed = 0, 0
local zero_vector = ffi_new("long[9]")
local alph, freq, heur, echo, randm = false, false, false, false, false


local function a_dist (p, q, k)
   return p[k] < q[k] and q[k] - p[k] or p[k] - q[k]
end


local function h_dist (p, q, k)
   return p[k] == q[k] and 0 or 1
end


local function freq_cost (v)
   local acc = v.u.I -- weight
   local k = 16
   while acc ~= 0 do
      k = k - 1
      acc = rshift(acc, 1)
   end
   return k < 0 and 0 or k
end


local function alph_dist (p, q)
   return a_dist(p, q, 0) + a_dist(p, q, 1)
      + a_dist(p, q, 2) + a_dist(p, q, 3)
      + a_dist(p, q, 4)
end


local function plant_new_edge (v)
   local u = gg.vertices + gg.n
   gb_new_edge(u, v, 1)
   if alph then
      u.arcs.len = alph_dist(u.name, v.name)
      local a = u.arcs - 1
      a.len = u.arcs.len
   elseif freq then
      u.arcs.len = freq_cost(v)
      local a = u.arcs - 1
      a.len = 20
   end
end


local function hamm_dist (p, q)
   return h_dist(p, q, 0) + h_dist(p, q, 1)
      + h_dist(p, q, 2) + h_dist(p, q, 3)
      + h_dist(p, q, 4)
end


local function alph_heur (v)
   return alph_dist(v.name, goal)
end


local function hamm_heur (v)
   return hamm_dist(v.name, goal)
end


local function prompt_for_five (sg)
   local iword, word
   repeat
      io.write(sg.." word: ")
      iword = io.read()
      word = ffi.new("char[6]", iword)
      if word[0] == 0 then return nil end
      if #iword ~= 5 then
         print("(Please type five lowercase letters and RETURN.)")
      end
   until #iword == 5
   if echo then print(iword) end
   return word
end


-- main

for _, a in ipairs(arg) do
   local k, v = a:match("-(%a)")
   if k == "v" then
      gb.verbose = 1
   elseif k == "a" then
      alph = true
   elseif k == "f" then
      freq = true
   elseif k == "h" then
      heur = true
   elseif k == "e" then
      echo = true
   else
      k, v = a:match("-(%a)(%d+)")
      if k == "n" then
         n = tonumber(v)
         randm = false
      elseif k == "r" then
         n = tonumber(v)
         randm = true
      elseif k == "s" then
         seed = tonumber(v)
      else
         printf("Usage: luajit %s [-v][-a][-f][-h][-e][-nN][-rN][-sN]\n", arg[0])
         return
      end
   end
end

if alph or randm then freq = false end
if freq then heur = false end

local g = gb.words(n, randm and zero_vector or NULL, 0, seed)
if g == NULL then
   printf("Sorry, I couldn't build a dictionary (trouble code %d)!\n",
          gb.panic_code)
   return
end

if gb.verbose == 1 then
   if alph then print("(alphabetic distance selected)") end
   if freq then print("(frequency-based distances selected)") end
   if heur then
      print("(lowerbound heuristic will be used to focus the search)")
   end
   if randm then
      printf("(random selection of %d words with seed %d)\n",
             tonumber(g.n), seed)
   else
      printf("(the graph has %d words)\n", tonumber(g.n))
   end
end

if alph then
   for u in vertices(g) do
      local p = u.name
      for a in arcs(u) do
         local q = a.tip.name
         a.len = a_dist(p, q, a.a.I) -- loc
      end
   end
elseif freq then
   for u in vertices(g) do
      for a in arcs(u) do
         a.len = freq_cost(a.tip)
      end
   end
end

if alph or freq or heur then
   init_queue, del_min, enqueue, requeue = init_128, del_128, enq_128, req_128
end


while true do
   print()
   start = prompt_for_five("Starting")
   if not start then break end
   goal = prompt_for_five("    Goal")
   if not goal then break end

   gg = gb.gb_new_graph(0)
   if gg == NULL then
      printf("Sorry, I couldn't build a dictionary (trouble code %d)!\n",
             gb.panic_code)
      return
   end
   gg.vertices = g.vertices
   gg.n = g.n

   local a = gg.vertices + gg.n
   a.name = start
   uu = gb.find_word(start, plant_new_edge)
   if uu == NULL then
      uu = gg.vertices + gg.n
      gg.n = gg.n + 1
   end
   if start == goal then
      vv = uu
   else
      local a = gg.vertices + gg.n
      a.name = goal
      vv = gb.find_word(goal, plant_new_edge)
      if vv == NULL then
         vv = gg.vertices + gg.n
         gg.n = gg.n + 1
      end
   end

   if gg.n == g.n + 2 then
      if hamm_dist(start, goal) == 1 then
         gg.n = gg.n - 1
         plant_new_edge(uu)
         gg.n = gg.n + 1
      end
   end

   if gb.gb_trouble_code ~= 0 then
      print("Sorry, I couldn't build a dictionary (trouble code 7)!")
      return
   end

   if not heur then
      min_dist = gb.dijkstra(uu, vv, gg, NULL)
   elseif alph then
      min_dist = gb.dijkstra(uu, vv, gg, alph_heur)
   else
      min_dist = gb.dijkstra(uu, vv, gg, hamm_heur)
   end

   if min_dist < 0 then
      printf("Sorry, there's no ladder from %s to %s.\n",
            str(start), str(goal))
   else
      gb.print_dijkstra_result(vv)
   end

   uu = g.vertices + gg.n - 1
   while uu >= g.vertices+g.n do
      for a in arcs(uu) do
         vv = a.tip
         vv.arcs = vv.arcs.next
      end
      uu.arcs = NULL
      uu = uu - 1
   end

   gb.gb_recycle(gg)
end

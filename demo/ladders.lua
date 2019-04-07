--[[
Introduction.
This demonstration program uses graphs
constructed by the {\sc GB\_WORDS} module to produce
an interactive program called \.{ladders}, which finds shortest paths
between two given five-letter words of English.
--]]


local bit = require "bit"
local ffi = require "ffi"
local gb_graph = require "gb.graph"
local gb_words = require "gb.words"
local gb_dijk = require "gb.dijk"
local gb = ffi.load "gb"
local ffi_new = ffi.new
local str = ffi.string
local rshift = bit.rshift
local words = gb_words.words
local find_word = gb_words.find_word
local arcs = gb_graph.arcs
local vertices = gb_graph.vertices
local gb_recycle = gb_graph.gb_recycle
local gb_new_edge = gb_graph.gb_new_edge
local gb_new_graph = gb_graph.gb_new_graph
local dijkstra = gb_dijk.dijkstra
local print_dijkstra_result = gb_dijk.print_dijkstra_result


local verbose, alph, freq, heur, echo = false, false, false, false, false
local n, randm, seed = 0, 0, 0
local g
local zero_vector = ffi_new("long[9]")
local gg
local start, goal
local uu, vv
local min_dist


local function printf (...)
   io.write(string.format(...))
end


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
   if alph ~= 0 then
      u.arcs.len = alph_dist(u.name, v.name)
      local a = u.arcs - 1
      a.len = alph_dist(u.name, v.name)
   elseif freq ~= 0 then
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


-- main

for _, a in ipairs(arg) do
   local k, v = a:match("-(%a)")
   if k == "v" then
      verbose = true
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

if alph or randm then
   freq = false
end

if freq then
   heur = false
end

local g = words(n, randm and zero_vector or nil, 0, seed)
if g == nil then
   printf("Sorry, I couldn't build a dictionary (trouble code %d)!\n",
          gb.panic_code)
   return
end

if verbose then
   if alph then
      print("(alphabetic distance selected)")
   end
   if freq then
      print("(frequency-based distances selected)")
   end
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
   gb_dijk.init_queue = gb_dijk.init_128
   gb_dijk.del_min = gb_dijk.del_128
   gb_dijk.enqueue = gb_dijk.enq_128
   gb_dijk.requeue = gb_dijk.req_128
end

while true do
   print()
   io.write("Starting word: ")
   start = ffi.new("char[6]", io.read())
   if start[0] == 0 then break end
   io.write("    Goad word: ")
   goal = ffi.new("char[6]", io.read())
   if goal[0] == 0 then break end

   gg = gb_new_graph(0)
   if gg == nil then
      printf("Sorry, I couldn't build a dictionary (trouble code %d)!\n",
             gb.panic_code)
      return
   end
   gg.vertices = g.vertices
   gg.n = g.n

   local a = gg.vertices + gg.n
   a.name = start
   uu = find_word(start, plant_new_edge)
   if uu == nil then
      uu = gg.vertices + gg.n
      gg.n = gg.n + 1
   end
   if start == goal then
      vv = uu
   else
      local a = gg.vertices + gg.n
      a.name = goal
      vv = find_word(goal, plant_new_edge)
      if vv == nil then
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
      min_dist = dijkstra(uu, vv, gg, nil)
   elseif alph then
      min_dist = dijkstra(uu, vv, gg, alph_heur)
   else
      min_dist = dijkstra(uu, vv, gg, hamm_heur)
   end

   if min_dist < 0 then
      printf("Sorry, there's no ladder from %s to %s.\n",
            str(start), str(goal))
   else
      print_dijkstra_result(vv)
   end

   uu = g.vertices + gg.n - 1
   while uu > g.vertices + g.n do
      for a in arcs(uu) do
         vv = a.tip
         vv.arcs = vv.arcs.next
      end
      uu.arcs = nil
   end

   gb_recycle(gg)
end

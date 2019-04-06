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
local str = ffi.string
local rshift = bit.rshift
local words = gb_words.words
local find_word = gb_words.find_word
local arcs = gb_graph.arcs
local gb_recycle = gb_graph.gb_recycle
local gb_new_edge = gb_graph.gb_new_edge
local gb_new_graph = gb_graph.gb_new_graph
local dijkstra = gb_dijk.dijkstra
local print_dijkstra_result = gb_dijk.print_dijkstra_result


local function printf (...)
   io.write(string.format(...))
end


local function a_dist (p, q, k)
   return p[k] < q[k] and q[k] - p[k] or p[k] - q[k]
end


local function h_dist (p, q, k)
   return p[k] == q[k] and 0 or 1
end


local function alph_dist (p, q)
   return a_dist(p, q, 0) + a_dist(p, q, 1)
      + a_dist(p, q, 2) + a_dist(p, q, 3)
      + a_dist(p, q, 4)
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


local function freq_cost (v)
   local acc = v.u.I -- weight
   local k = 16
   while acc ~= nil do
      k = k - 1
      acc = rshift(acc, 1)
   end
   return k < 0 and 0 or k
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


-- main

local g = words(0, nil, 0, 0)
if g == nil then
   printf("Sorry, I couldn't build a dictionary (trouble code %d)!\n",
          gb.panic_code)
   return
end

while true do
   print()
   io.write("Starting word: ")
   local start = ffi.new("char[6]", io.read())
   if start[0] == 0 then break end
   io.write("    Goad word: ")
   local goal = ffi.new("char[6]", io.read())
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

   min_dist = dijkstra(uu, vv, gg, nil)
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

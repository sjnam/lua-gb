local ffi = require "ffi"
local gb_graph = require "gb.graph"
local gb_save = require "gb.save"
local gb_basic = require "gb.basic"
local str = ffi.string

local g = gb_basic.board(3, 4, 0, 0, -1, 0, 0)
local gg = gb_basic.board(3, 4, 0, 0, -2, 0, 0)
local ggg = gb_basic.gunion(g, gg, 0, 0)
gb_save.save_graph(ggg, "queen.gb")

print("Queen Moves on a 3x4 Board\n")
print("  The graph whose official name is\n"..str(ggg.id))
print("  has "..tonumber(ggg.n).." vertices and "..tonumber(ggg.m).." arcs:\n")

for v in gb_graph.vertices(ggg) do
   print(str(v.name))
   for a in gb_graph.arcs(v) do
      print("  -> "..str(a.tip.name)..", length "..tonumber(a.len))
   end
end

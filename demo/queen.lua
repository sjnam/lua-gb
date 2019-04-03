local ffi = require "ffi"
local gb_save = require "gb.save"
local gb_basic = require "gb.basic"
local str = ffi.string

local g = gb_basic.board(3, 4, 0, 0, -1, 0, 0)
local gg = gb_basic.board(3, 4, 0, 0, -2, 0, 0)
local ggg = gb_basic.gunion(g, gg, 0, 0)
gb_save.save_graph(ggg, "queen.gb")

local vertices = ggg.vertices
local n, m = tonumber(ggg.n), tonumber(ggg.m)
print("Queen Moves on a 3x4 Board\n")
print("  The graph whose official name is\n"..str(ggg.id))
print("  has "..n.." vertices and "..m.." arcs:\n")

for i=0,n-1 do
   local v = vertices + i
   print(str(v.name))
   local a = v.arcs
   while a ~= ffi.null do
      print("  -> "..str(a.tip.name)..", length "..tonumber(a.len))
      a = a.next
   end
end

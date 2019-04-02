local ffi = require "ffi"
local gb_save = require "gb.save"
local gb_basic = require "gb.basic"
local NULL = ffi.null
local str = ffi.string
local tonumber = tonumber
local board = gb_basic.board
local gunion = gb_basic.gunion
local save_graph = gb_save.save_graph


local function printf (...)
    io.write(string.format(...))
end


local g = board(3, 4, 0, 0, -1, 0, 0)
local gg = board(3, 4, 0, 0, -2, 0, 0)
local ggg = gunion(g, gg, 0, 0)

save_graph(ggg, "queen.gb")

print("Queen Moves on a 3x4 Board\n")
printf("  The graph whose official name is\n%s\n", ggg.id)
printf("  has %d vertices and %d arcs:\n\n", ggg.n, ggg.m)

for _, v in ipairs(ggg.vertices) do
   print(str(v.name))
   local a = v.arcs
   while a ~= NULL do
      printf("  -> %s, length %d\n", str(a.tip.name), tonumber(a.len))
      a = a.next
   end
end

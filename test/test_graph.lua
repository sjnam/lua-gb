local gb_graph = require "gb.graph"
local ffi = require "ffi"

local s = ffi.new("Area")

local g = gb_graph.gb_new_graph(2)
if g == ffi.null then
  print("Oops, I couldn't even create a trivial graph!")
  return
end

local u = g.vertices
local v = u[2]
u.name = gb_graph.gb_save_string("vertex 0")
v.name = ffi.cast("char*", gb_graph.gb_save_string("vertex 1"))

if gb_graph.gb_alloc(0, s) ~= ffi.null then
    print("Allocation error 2 wasn't reported properly!")
    return
end

for i=1,100 do
    if gb_graph.gb_alloc(100000, s) ~= ffi.null then
        io.write(".")
    end
end

gb_graph.gb_free(s)

print("Hey, I allocated 10000000 bytes successfully. Terrific...")

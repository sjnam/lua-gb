local sgb = require "sgb"
local ffi = require "ffi"
local gb = sgb.gb


local s = ffi.new("Area")

local g = gb.gb_new_graph(2)
if not g then
  print("Oops, I couldn't even create a trivial graph!")
  return
end

g.vertices.name = ffi.cast("char*", sgb.gb_save_string("vertex 0"))
g.vertices[2].name = ffi.cast("char*", sgb.gb_save_string("vertex 1"))

if gb.gb_alloc(0, s) ~= ffi.null then
    print("Allocation error 2 wasn't reported properly!")
    return
end

for i=1,100 do
    if gb.gb_alloc(100000, s) then
       io.write(".")
    end
end

gb.gb_free(s)

print("Hey, I allocated 10000000 bytes successfully. Terrific...")

local sgb = require "sgb"
local bit = require "bit"
local ffi = require "ffi"
local C = ffi.C
local gb = sgb.gb
local sformat = string.format

ffi.cdef[[
int strncmp(const char *s1, const char *s2, size_t n);
]]

local s = ffi.new("Area")

local g = gb.gb_new_graph(2)
if not g then
  print("Oops, I couldn't even create a trivial graph!")
  return
end

local u = g.vertices
local v = u + 1
u.name = ffi.cast("char*", sgb.gb_save_string("vertex 0"))
v.name = ffi.cast("char*", sgb.gb_save_string("vertex 1"))

if gb.gb_alloc(0, s) ~= ffi.null or gb.gb_trouble_code ~= 2 then
    print("Allocation error 2 wasn't reported properly!")
    return
end

while g.vv.I < 100 do
   if gb.gb_alloc(100000, s) then
      g.uu.I = g.uu.I + 1
      io.write(".")
      io.flush()
   end
   g.vv.I = g.vv.I + 1
end

if g.uu.I < 100 and gb.gb_trouble_code ~= 3 then
   print("Allocation error 1 wasn't reported properly!")
   return
end

if g.uu.I == 0 then
   print("I couldn't allocate any memory!")
   return
end

gb.gb_free(s)

io.write(sformat("Hey, I allocated %d00000 bytes successfully. Terrific...\n",
                 tonumber(g.uu.I)))

gb.gb_trouble_code = 0

if C.strncmp(u.name, v.name, 7) ~= 0 then
   print("Something is fouled up in the string storage machinery!")
   return
end

gb.gb_new_edge(v, u, -1)
gb.gb_new_edge(u, u, 1)
gb.gb_new_arc(v, u, -1)

if bit.band(gb.edge_trick, ffi.cast("unsigned long", u.arcs)) ~= 0 or
   bit.band(gb.edge_trick, ffi.cast("unsigned long", u.arcs.next.next)) ~= 0 or
   bit.band(gb.edge_trick, ffi.cast("unsigned long", v.arcs.next)) == 0 then
   print("Warning: The \"edge trick\" failed!")
end

if v.name[7]+g.n ~= v.arcs.next.tip.name[7]+g.m-2 then
   print("Sorry, the graph data structures aren't working yet.")
   return
end

print("OK, the gb_graph routines seem to work!")

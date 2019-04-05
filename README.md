Stanford GraphBase
==========================================================
by Donald E. Knuth, Stanford University

A highly portable collection of programs and data is now
available to researchers who study combinatorial algorithms and data
structures.

Status
======
This library is still experimental and under early development.

Installation
============
To install lua-gb you need to install [libgb](https://www-cs-faculty.stanford.edu/~knuth/sgb.html) with **shared libraries** firtst. Then you can install it by placing `gb/*.lua` to your lua library path.

Samples
=======
````lua
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
````

Author
======
Soojin Nam jsunam@gmail.com

License
=======
Public Domain

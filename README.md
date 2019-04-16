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
- queen.lua
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

- ladders.lua
````
$ luajit ladders.lua 

Starting word: flour
    Goal word: bread
         0 flour
         1 floor
         2 flood
         3 blood
         4 brood
         5 broad
         6 bread

Starting word: chaos
    Goal word: order
         0 chaos
         1 choos
         2 chops
         3 coops
         4 comps
         5 comes
         6 comer
         7 coder
         8 cider
         9 aider
        10 adder
        11 odder
        12 order

Starting word: pound
    Goal word: marks
Sorry, there's no ladder from pound to marks.

````

Author
======
Soojin Nam jsunam@gmail.com

License
=======
Public Domain

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
local gb_save = require "gb.save"
local gb_basic = require "gb.basic"
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
    print(v.name)
    for _, a in ipairs(v.arcs) do
        printf("  -> %s, length %d\n", a.tip.name, a.len)
    end
end
````

Author
======
Soojin Nam jsunam@gmail.com

License
=======
Public Domain

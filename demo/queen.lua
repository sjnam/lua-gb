--[[
   @* Queen moves.
   This is a short demonstration of how to generate and traverse graphs
   with the Stanford GraphBase. It creates a graph with 12 vertices,
   representing the cells of a $3\times4$ rectangular board; two
   cells are considered adjacent if you can get from one to another
   by a queen move. Then it prints a description of the vertices and
   their neighbors, on the standard output file.

   An ASCII file called \.{queen.gb} is also produced. Other programs
   can obtain a copy of the queen graph by calling |restore_graph("queen.gb")|.
   You might find it interesting to compare the output of {\sc QUEEN} with
   the contents of \.{queen.gb}; the former is intended to be readable
   by human beings, the latter by computers.
--]]


local ffi = require "ffi"
require "gb.basic"
local gb_graph = require "gb.graph"
local gb_save = require "gb.save"
local print = print
local tonumber = tonumber
local str = ffi.string

local gb = ffi.load "gb"

local g = gb.board(3, 4, 0, 0, -1, 0, 0)
local gg = gb.board(3, 4, 0, 0, -2, 0, 0)
local ggg = gb.gunion(g, gg, 0, 0)

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

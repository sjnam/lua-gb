
-- Stanford GraphBase ffi bounding
-- Written by Soojin Nam. Public Domain.

local gb_graph = require "gb.graph"
local ffi = require "ffi"
local ffi_load = ffi.load
local graph = gb_graph.graph


ffi.cdef[[
extern Graph*random_graph(unsigned long,unsigned long,long,long,long,long*,long*,long,long,long);
extern Graph*random_bigraph(unsigned long,unsigned long,unsigned long,long,long*,long*,long,long,long);
extern long random_lengths(Graph*,long,long,long,long*,long);
]]


local gb = ffi_load "gb"


local _M = {}


function _M.random_graph (...)
    return graph(gb.random_graph(...))
end


function _M.random_bigraph (...)
    return graph(gb.random_bigraph(...))
end


function _M.random_lengths (g, ...)
    return gb.random_lengths(g._g, ...)
end


return _M

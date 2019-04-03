
-- Stanford GraphBase ffi bounding
-- Written by Soojin Nam. Public Domain.

require "gb.graph"
local ffi = require "ffi"


ffi.cdef[[
extern Graph*random_graph(unsigned long,unsigned long,long,long,long,long*,long*,long,long,long);
extern Graph*random_bigraph(unsigned long,unsigned long,unsigned long,long,long*,long*,long,long,long);
extern long random_lengths(Graph*,long,long,long,long*,long);
]]


local gb = ffi.load "gb"


local _M = {}


_M.random_graph = gb.random_graph
_M.random_bigraph = gb.random_bigraph
_M.random_lengths = gb.random_lengths


return _M


-- Stanford GraphBase ffi bounding
-- Written by Soojin Nam. Public Domain.

local gb_graph = require "gb.graph"
local ffi = require "ffi"
local ffi_load = ffi.load
local ffi_cast = ffi.cast
local graph = gb_graph.graph
local vertex = gb_graph.vertex


ffi.cdef[[
extern Graph*words(unsigned long,long[],long,long);
extern Vertex*find_word(char*,void[](*)());
]]


local gb = ffi_load "gb"


local _M = {}


function _M.words (...)
    return graph(gb.words(...))
end


function _M.find_word (q, f)
   return vertex(gb.find_word(ffi_cast("char*", q), f))
end


return _M

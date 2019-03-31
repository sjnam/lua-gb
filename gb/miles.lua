
-- Stanford GraphBase ffi bounding
-- Written by Soojin Nam. Public Domain.

local gb_graph = require "gb.graph"
local ffi = require "ffi"
local ffi_load = ffi.load
local graph = gb_graph.graph


ffi.cdef[[
extern Graph*miles(unsigned long,long,long,long,unsigned long,unsigned long,long);
extern long miles_distance(Vertex*,Vertex*);
]]


local gb = ffi_load "gb"


local _M = {}


function _M.miles (...)
    return graph(gb.miles(...))
end


function _M.miles_distance (u, v)
   return gb.miles_distance(u._v, v._v)
end


return _M

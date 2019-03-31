
-- Stanford GraphBase ffi bounding
-- Written by Soojin Nam. Public Domain.

local gb_graph = require "gb.graph"
local ffi = require "ffi"
local ffi_load = ffi.load
local graph = gb_graph.graph


ffi.cdef[[
extern Graph*plane(unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,long);
extern Graph*plane_miles(unsigned long,long,long,long,unsigned long,unsigned long,long);
extern void delaunay(Graph*,void[](*)());
]]


local gb = ffi_load "gb"


local _M = {}


function _M.plane (...)
    return graph(gb.plane(...))
end


function _M.plane_miles (...)
    return graph(gb.plane_miles(...))
end


function _M.delaunay (g, f)
   gb.delaunay(g._g, f)
end


return _M

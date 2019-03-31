
-- Stanford GraphBase ffi bounding
-- Written by Soojin Nam. Public Domain.

local gb_graph = require "gb.graph"
local ffi = require "ffi"
local ffi_load = ffi.load
local graph = gb_graph.graph


ffi.cdef[[
extern long*lisa(unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,Area);
extern Graph*plane_lisa(unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long);
extern Graph*bi_lisa(unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,long);
extern char lisa_id[];
]]


local gb = ffi_load "gb"


local _M = {}


_M.lisa = gb.lisa


function _M.plane_lisa (...)
    return graph(gb.plane_lisa(...))
end


function _M.bi_lisa (...)
    return graph(gb.bi_lisa(...))
end


return _M

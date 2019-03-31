
-- Stanford GraphBase ffi bounding
-- Written by Soojin Nam. Public Domain.

local gb_graph = require "gb.graph"
local ffi = require "ffi"
local ffi_load = ffi.load
local graph = gb_graph.graph


ffi.cdef[[
extern Graph*raman(long,long,unsigned long,unsigned long);
]]


local gb = ffi_load "gb"


local _M = {}


function _M.raman (...)
    return graph(gb.raman(...))
end


return _M

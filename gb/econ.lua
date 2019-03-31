
-- Stanford GraphBase ffi bounding
-- Written by Soojin Nam. Public Domain.

local gb_graph = require "gb.graph"
local ffi = require "ffi"
local ffi_load = ffi.load
local graph = gb_graph.graph


ffi.cdef[[
extern Graph*econ(unsigned long,unsigned long,unsigned long,long);
]]


local gb = ffi_load "gb"


local _M = {}


function _M.econ (...)
    return graph(gb.econ(...))
end


return _M

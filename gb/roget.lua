
-- Stanford GraphBase ffi bounding
-- Written by Soojin Nam. Public Domain.

local gb_graph = require "gb.graph"
local ffi = require "ffi"
local ffi_load = ffi.load
local graph = gb_graph.graph


ffi.cdef[[
extern Graph*roget(unsigned long,unsigned long,unsigned long,long);
]]


local gb = ffi_load "gb"


local _M = {}


function _M.roget (...)
    return graph(gb.roget(...))
end


return _M

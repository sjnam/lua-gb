
-- Stanford GraphBase ffi bounding
-- Written by Soojin Nam. Public Domain.

local ffi = require "ffi"
local ffi_cast = ffi.cast
local ffi_load = ffi.load


ffi.cdef[[
extern long save_graph(Graph*,char*);
extern Graph*restore_graph();
]]


local gb = ffi_load "gb"


local _M = {}


function _M.save_graph (g, f)
    return gb.save_graph(g._g, ffi_cast("char*", f))
end


function _M.restore_graph (f)
    return sgb.graph(gb.restore_graph(ffi_cast("char*", f)))
end


return _M

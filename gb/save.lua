
-- Stanford GraphBase ffi binding
-- Written by Soojin Nam. Public Domain.


require "gb.graph"
local ffi = require "ffi"


ffi.cdef[[
extern long save_graph(Graph*,char*);
extern Graph*restore_graph(char*);
]]


local gb = ffi.load "gb"


local _M = {}


function _M.save_graph (g, f)
   return gb.save_graph(g, ffi.cast("char*", f))
end


function _M.restore_graph (f)
   return gb.restore_graph(ffi.cast("char*", f))
end


return _M

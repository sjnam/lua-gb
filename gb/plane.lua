
-- Stanford GraphBase ffi bounding
-- Written by Soojin Nam. Public Domain.

require "gb.graph"
local ffi = require "ffi"


ffi.cdef[[
extern Graph*plane(unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,long);
extern Graph*plane_miles(unsigned long,long,long,long,unsigned long,unsigned long,long);
extern void delaunay(Graph*,void[](*)());
]]


local gb = ffi.load "gb"


local _M = {}


_M.plane = gb.plane
_M.plane_miles = gb.plane_miles
_M.delaunay = gb.delaunay


return _M

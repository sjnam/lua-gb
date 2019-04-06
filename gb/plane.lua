
-- Stanford GraphBase ffi binding
-- Written by Soojin Nam. Public Domain.

require "gb.graph"
local ffi = require "ffi"


ffi.cdef[[
extern Graph*plane(unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,long);
extern Graph*plane_miles(unsigned long,long,long,long,unsigned long,unsigned long,long);
extern void delaunay(Graph*,void(*)());
]]


local gb = ffi.load "gb"


local _M = {
   INFTY = 0x10000000,
   plane = gb.plane,
   plane_miles = gb.plane_miles,
   delaunay = gb.delaunay
}


function _M.x_coord (v)
   return tonumber(v.x.I)
end


function _M.y_coord (v)
   return tonumber(v.y.I)
end


function _M.z_coord (v)
   return tonumber(v.z.I)
end


return _M

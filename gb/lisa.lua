
-- Stanford GraphBase ffi binding
-- Written by Soojin Nam. Public Domain.

require "gb.graph"
local ffi = require "ffi"


ffi.cdef[[
extern long*lisa(unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,Area);
extern Graph*plane_lisa(unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long);
extern Graph*bi_lisa(unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,long);
extern char lisa_id[];
]]


local gb = ffi.load "gb"


local _M = {
   lisa = gb.lisa,
   plane_lisa = gb.plane_lisa,
   bi_lisa = gb.bi_lisa
}


function _M.pixel_value (v)
   return tonumber(v.x.I)
end


function _M.first_pixel (v)
   return tonumber(v.y.I)
end


function _M.last_pixel (v)
   return tonumber(v.z.I)
end


function _M.matrix_rows (g)
   return tonumber(g.uu.I)
end


function _M.matrix_cols (g)
   return tonumber(g.vv.I)
end


return _M

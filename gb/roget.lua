
-- Stanford GraphBase ffi bounding
-- Written by Soojin Nam. Public Domain.

require "gb.graph"
local ffi = require "ffi"


ffi.cdef[[
extern Graph*roget(unsigned long,unsigned long,unsigned long,long);
]]


local gb = ffi.load "gb"


local _M = {
   roget = gb.roget
}


function _M.cat_no (v)
   return tonumber(v.u.I)
end


return _M

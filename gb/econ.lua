
-- Stanford GraphBase ffi binding
-- Written by Soojin Nam. Public Domain.

require "gb.graph"
local ffi = require "ffi"


ffi.cdef[[
extern Graph*econ(unsigned long,unsigned long,unsigned long,long);
]]


local gb = ffi.load "gb"


local _M = {
   econ = gb.econ
}


function _M.flow (a)
   return tonumber(a.a.I)
end


function _M.SIC_codes (v)
   return v.z.A
end


function _M.sector_total (v)
   return tonumber(v.y.I)
end


return _M

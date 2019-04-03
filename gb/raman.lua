
-- Stanford GraphBase ffi bounding
-- Written by Soojin Nam. Public Domain.

require "gb.graph"
local ffi = require "ffi"


ffi.cdef[[
extern Graph*raman(long,long,unsigned long,unsigned long);
]]


local gb = ffi.load "gb"


return {
   raman = gb.raman
}

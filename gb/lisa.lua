
-- Stanford GraphBase ffi bounding
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


return {
   lisa = gb.lisa,
   plane_lisa = gb.plane_lisa,
   bi_lisa = gb.bi_lisa
}


-- Stanford GraphBase ffi bounding
-- Written by Soojin Nam. Public Domain.

require "gb.graph"
local ffi = require "ffi"


ffi.cdef[[
extern Graph*miles(unsigned long,long,long,long,unsigned long,unsigned long,long);
extern long miles_distance(Vertex*,Vertex*);
]]


local gb = ffi.load "gb"


return {
   miles = gb.miles,
   miles_distance = gb.miles_distance
}


-- Stanford GraphBase ffi binding
-- Written by Soojin Nam. Public Domain.

require "gb.graph"
local ffi = require "ffi"


ffi.cdef[[
extern Graph*miles(unsigned long,long,long,long,unsigned long,unsigned long,long);
extern long miles_distance(Vertex*,Vertex*);
]]


local gb = ffi.load "gb"


local _M = {
   miles = gb.miles,
   miles_distance = gb.miles_distance
}

function _M.x_coord (v)
   return tonumber(v.x.I)
end


function _M.y_coord (v)
   return tonumber(v.y.I)
end


function _M.index_no (v)
   return tonumber(v.z.I)
end


function _M.people (v)
   return tonumber(v.w.I)
end


return _M

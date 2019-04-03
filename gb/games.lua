
-- Stanford GraphBase ffi bounding
-- Written by Soojin Nam. Public Domain.

require "gb.graph"
local ffi = require "ffi"


ffi.cdef[[
extern Graph*games(unsigned long,long,long,long,long,long,long,long);
]]


local gb = ffi.load "gb"


return {
   games = gb.games
}

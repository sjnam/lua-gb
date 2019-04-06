
-- Stanford GraphBase ffi binding
-- Written by Soojin Nam. Public Domain.

require "gb.graph"
local ffi = require "ffi"


ffi.cdef[[
extern Graph*games(unsigned long,long,long,long,long,long,long,long);
]]


local gb = ffi.load "gb"


local _M = {
   HOME = 1,
   NEUTRAL = 2,
   AWAY = 3,
   games = gb.games
}


function _M.ap (v)
   return tonumber(v.u.I)
end


function _M.upi (v)
   return tonumber(v.v.I)
end


function _M.abbr (v)
   return ffi.string(v.x.S)
end


function _M.nickname (v)
   return ffi.string(v.y.S)
end


function _M.conference (v)
   return ffi.string(v.z.S)
end


function _M.venue (a)
   return tonumber(a.a.I)
end


function _M.date (a)
   return tonumber(a.b.I)
end


return _M


-- Stanford GraphBase ffi binding
-- Written by Soojin Nam. Public Domain.

require "gb.graph"
local ffi = require "ffi"


ffi.cdef[[
extern Graph*words(unsigned long,long[],long,long);
extern Vertex*find_word(char*,void(*)(Vertex*));
]]


local gb = ffi.load "gb"


local _M = {
   words = gb.words
}


function _M.find_word (q, f)
   return gb.find_word(ffi.cast("char*", q), f)
end


function _M.weight (v)
   return tonumber(v.u.I)
end


function _M.loc (v)
   return tonumber(v.a.I)
end


return _M

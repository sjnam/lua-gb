
-- Stanford GraphBase ffi bounding
-- Written by Soojin Nam. Public Domain.

require "gb.graph"
local ffi = require "ffi"


ffi.cdef[[
extern Graph*book(char*,unsigned long,unsigned long,unsigned long,unsigned long,long,long,long);
extern Graph*bi_book(char*,unsigned long,unsigned long,unsigned long,unsigned long,long,long,long);
extern long chapters;
extern char*chap_name[];
]]


local gb = ffi.load "gb"


local _M = {
   book = gb.book,
   bi_book = gb.bi_book
}


function _M.desc (v)
   return ffi.string(v.z.S)
end


function _M.in_count (v)
   return tonumber(v.y.I)
end


function _M.out_count (v)
   return tonumber(v.x.I)
end


function _M.short_code (v)
   return tonumber(v.u.I)
end


function _M.chap_no (a)
   return tonumber(a.a.I)
end


return _M

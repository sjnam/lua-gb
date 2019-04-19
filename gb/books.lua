
-- Stanford GraphBase ffi binding
-- Written by Soojin Nam. Public Domain.


local ffi = require "ffi"


local gb = ffi.load "gb"


local _M = {}


function _M.book (title, ...)
   return gb.book(ffi.cast("char*", title), ...)
end


function _M.bi_book (title, ...)
   return gb.bi_book(ffi.cast("char*", title), ...)
end


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

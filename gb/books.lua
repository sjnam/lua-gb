
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


return {
   book = gb.book,
   bi_book = gb.bi_book
}

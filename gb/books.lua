
-- Stanford GraphBase ffi bounding
-- Written by Soojin Nam. Public Domain.

local gb_graph = require "gb.graph"
local ffi = require "ffi"
local ffi_load = ffi.load
local graph = gb_graph.graph


ffi.cdef[[
extern Graph*book(char*,unsigned long,unsigned long,unsigned long,unsigned long,long,long,long);
extern Graph*bi_book(char*,unsigned long,unsigned long,unsigned long,unsigned long,long,long,long);
extern long chapters;
extern char*chap_name[];
]]


local gb = ffi_load "gb"


local _M = {}


function _M.book (...)
    return graph(gb.book(...))
end


function _M.bi_book (...)
    return graph(gb.bi_book(...))
end


return _M

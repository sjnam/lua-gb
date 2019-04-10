
-- Stanford GraphBase ffi binding
-- Written by Soojin Nam. Public Domain.

local ffi = require "ffi"


ffi.cdef[[
typedef struct node_struct {
  long key;
  struct node_struct *link;
} node;
extern void gb_linksort(node*);
extern char*gb_sorted[];
]]


local gb = ffi.load "gb"


local _M = {}


_M.gb_linksort = gb.gb_linksort


return _M


-- Stanford GraphBase ffi bounding
-- Written by Soojin Nam. Public Domain.


require "gb.graph"
local ffi = require "ffi"


ffi.cdef[[
extern Graph*board(long,long,long,long,long,long,long);
extern Graph*simplex(unsigned long,long,long,long,long,long,long);
extern Graph*subsets(unsigned long,long,long,long,long,long,unsigned long,long);
extern Graph*perms(long,long,long,long,long,unsigned long,long);
extern Graph*parts(unsigned long, unsigned long, unsigned long, long);
extern Graph*binary(unsigned long, unsigned long, long);
extern Graph*complement(Graph*,long,long,long);
extern Graph*gunion(Graph*,Graph*,long,long);
extern Graph*intersection(Graph*,Graph*,long,long);
extern Graph*lines(Graph*,long);
extern Graph*product(Graph*,Graph*,long,long);
extern Graph*induced(Graph*,char*,long,long,long);
extern Graph*bi_complete(unsigned long,unsigned long,long);
extern Graph*wheel(unsigned long,unsigned long,long);
]]


local gb = ffi.load "gb"


local _M = {}


_M.board = gb.board
_M.simplex = gb.simplex
_M.subsets = gb.subsets
_M.perms = gb.perms
_M.parts = gb.parts
_M.binary = gb.binary
_M.complement = gb.complement
_M.gunion = gb.gunion
_M.intersecton = gb.intersection
_M.lines = gb.lines
_M.product = gb.product
_M.bi_complete = gb.bi_complete
_M.wheel = gb.wheel


function _M.induced (g, f, ...)
   return gb.induced(g, ffi.cast("char*", f), ...)
end


return _M

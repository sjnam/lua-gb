
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
_M.cartesian = 0
_M.direct = 1
_M.strong = 2
_M.IND_GRAPH = 1000000000


function _M.induced (g, f, ...)
   return gb.induced(g, ffi.cast("char*", f), ...)
end


function _M.complete (n)
   return gb.board(n, 0, 0, 0, -1, 0, 0)
end


function _M.transitive (n)
   return gb.board(n, 0, 0, 0, -1, 0, 1)
end


function _M.empty (n)
   return gb.board(n, 0, 0, 0, 2, 0, 0)
end


function circuit (n)
   return gb.board(n, 0, 0, 0, 1, 1, 0)
end


function cycle (n)
   return gb.board(n, 0, 0, 0, 1, 1, 1)
end


function _M.disjoint_subsets (n, k)
   return gb.subsets(k, 1, 1-n, 0, 0, 0, 1, 0)
end


function _M.petersen ()
   return gb.subsets(2, 1, -4, 0, 0, 0, 1, 0)
end


function _M.all_perms (n, directed)
   return gb.perms(1-n, 0, 0, 0, 0, 0, directed)
end


function _M.all_parts (n, directed)
   return gb.parts(n, 0, 0, directed)
end


function _M.all_trees (n, directed)
   return gb.binary(n, 0, directed)
end


function _M.ind (v)
   return tonumber(v.z.I)
end


function _M.subst (v)
   return v.y.G
end


return _M

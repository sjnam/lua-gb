
-- Stanford GraphBase ffi binding
-- Written by Soojin Nam. Public Domain.


local ffi = require "ffi"
local gb = ffi.load "gb"


local _M = {}


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

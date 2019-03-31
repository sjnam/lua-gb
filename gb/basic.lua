
-- Stanford GraphBase ffi bounding
-- Written by Soojin Nam. Public Domain.


local gb_graph = require "gb.graph"
local ffi = require "ffi"
local ffi_cast = ffi.cast
local ffi_load = ffi.load
local graph = gb_graph.graph


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


local gb = ffi_load "gb"


local _M = {}


function _M.board (...)
    return graph(gb.board(...))
end


function _M.simplex (...)
    return graph(gb.simplex(...))
end


function _M.subsets (...)
    return graph(gb.subsets(...))
end


function _M.perms (...)
    return graph(gb.perms(...))
end


function _M.parts (...)
    return graph(gb.parts(...))
end


function _M.binary (...)
    return graph(gb.binary(...))
end


function _M.complement (g, ...)
    return graph(gb.complement(g._g, ...))
end


function _M.gunion (g, gg, ...)
    return graph(gb.gunion(g._g, gg._g, ...))
end


function _M.intersection (g, gg, ...)
    return graph(gb.intersection(g._g, gg._g, ...))
end


function _M.lines (g, ...)
    return graph(gb.lines(g._g, ...))
end


function _M.product (g, gg, ...)
    return graph(gb.product(g._g, gg._g, ...))
end


function _M.induced (g, f, ...)
    return graph(gb.induced(g._g, ffi_cast("char*", f), ...))
end


function _M.bi_complete (...)
    return graph(gb.bi_complete(...))
end


function _M.wheel (...)
    return graph(gb.wheel(...))
end


return _M

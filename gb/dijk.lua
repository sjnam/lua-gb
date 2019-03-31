
-- Stanford GraphBase ffi bounding
-- Written by Soojin Nam. Public Domain.

local gb_graph = require "gb.graph"
local ffi = require "ffi"
local ffi_load = ffi.load
local vertex = gb_graph.vertex


ffi.cdef[[
extern long dijkstra(Vertex*,Vertex*,Graph*,long(*)());
extern void print_dijkstra_result(Vertex*);
extern void(*init_queue)();
extern void(*enqueue)();
extern void(*requeue)();
extern Vertex*(*del_min)();
extern void init_dlist(long);
extern void enlist(Vertex*,long);
extern void reenlist(Vertex*,long);
extern Vertex*del_first();
extern void init_128();
extern Vertex*del_128();
extern void enq_128(Vertex*,long);
extern void req_128(Vertex*,long);
]]


local gb = ffi_load "gb"


local _M = {}


_M.init_dlist = gb.init_dlist
_M.init_128 = gb.init_128

function _M.dijkstra (uu, vv, gg, hh)
    return gb.dijkstra(uu._v, vv._v, gg._g, hh)
end


function _M.print_dijkstra_result (vv)
   gb.print_dijkstra_result(vv._v)
end


function _M.enlist (v, d)
   gb.enlist(v._v, d)
end


function _M.reenlist (v, d)
   gb.reenlist(v._v, d)
end


function _M.del_first ()
   return vertex(gb.del_first())
end


function _M.del_128 ()
   return vertex(gb.del_128())
end


function _M.enq_128 (v, d)
   gb.enq_128(v._v, d)
end


function _M.req_128 (v, d)
   gb.req_128(v._v, d)
end


return _M

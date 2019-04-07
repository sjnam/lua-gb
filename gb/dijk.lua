
-- Stanford GraphBase ffi binding
-- Written by Soojin Nam. Public Domain.

require "gb.graph"
local ffi = require "ffi"


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


local gb = ffi.load "gb"


local _M = {}

_M.init_queue = gb.init_queue
_M.enqueue = gb.enqueue
_M.requeue = gb.requeue
_M.del_min = gb.del_min
_M.init_dlist = gb.init_dlist
_M.init_128 = gb.init_128
_M.dijkstra = gb.dijkstra
_M.print_dijkstra_result = gb.print_dijkstra_result
_M.enlist = gb.enlist
_M.reenlist =gb.reenlist
_M.del_first = gb.del_first
_M.del_128 = gb.del_128
_M.enq_128 = gb.enq_128
_M.req_128 = gb.req_128


function _M.dist (v)
   return tonumber(v.z.I)
end


function _M.backlink (v)
   return v.y.V
end


function _M.hh_val (v)
   return tonumber(v.x.I)
end


return _M

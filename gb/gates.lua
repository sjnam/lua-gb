
-- Stanford GraphBase ffi bounding
-- Written by Soojin Nam. Public Domain.

local gb_graph = require "gb.graph"
local ffi = require "ffi"
local ffi_load = ffi.load
local ffi_cast = ffi.cast
local graph = gb_graph.graph


ffi.cdef[[
extern Graph*risc(unsigned long);
extern Graph*prod(unsigned long,unsigned long);
extern void print_gates(Graph*);
extern long gate_eval(Graph*,char*,char*);
extern Graph*partial_gates(Graph*,unsigned long,unsigned long,long,char*);
extern long run_risc(Graph*,unsigned long[],unsigned long,unsigned long);
extern unsigned long risc_state[];
]]


local gb = ffi_load "gb"


local _M = {}


function _M.risc (...)
    return graph(gb.risc(...))
end


function _M.prod (...)
    return graph(gb.prod(...))
end


function _M.print_gates (g)
    return graph(gb.print_gates(g._g))
end


function _M.gate_eval (g, in_vec, out_vec)
   return gb.gate_eval(g._g, ffi_cast("char*", in_vec), ffi_cast("char*", out_vec))
end


function _M.partial_gates (g, r, prob, seed, buf)
    return graph(gb.partial_gates(g._g, r, prob, seed, ffi_cast("char*", buf)))
end


function _M.run_risc (g, ...)
   return gb.run_risc(g._g, ...)
end


return _M

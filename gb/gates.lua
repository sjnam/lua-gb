
-- Stanford GraphBase ffi bounding
-- Written by Soojin Nam. Public Domain.

require "gb.graph"
local ffi = require "ffi"


ffi.cdef[[
extern Graph*risc(unsigned long);
extern Graph*prod(unsigned long,unsigned long);
extern void print_gates(Graph*);
extern long gate_eval(Graph*,char*,char*);
extern Graph*partial_gates(Graph*,unsigned long,unsigned long,long,char*);
extern long run_risc(Graph*,unsigned long[],unsigned long,unsigned long);
extern unsigned long risc_state[];
]]


local gb = ffi.load "gb"


local _M = {}


_M.risc = gb.risc
_M.prod = gb.prod
_M.print_gates = gb.print_gates
_M.run_risc = gb.run_risc
_M.AND = '&'
_M.OR = '|'
_M.NOT = '~'
_M.XOR = '^'


function _M.gate_eval (g, in_vec, out_vec)
   return gb.gate_eval(g, ffi.cast("char*", in_vec), ffi.cast("char*", out_vec))
end


function _M.partial_gates (g, r, prob, seed, buf)
   return gb.partial_gates(g, r, prob, seed, ffi.cast("char*", buf))
end


function _M.val (v)
    return tonumber(v.x.I)
end


function _M.typ (v)
    return tonumber(v.y.I)
end


function _M.alt (v)
    return v.z.V
end


function _M.outs (g)
    return g.zz.A
end


function _M.is_boolean (v)
    return v <= 1
end


function _M.the_boolean (v)
    return v ~= 0
end


function _M.tip_value (v)
    if v <= 1 then
        return v ~= 0
    end
    return v.val
end


function _M.bit (v)
    return tonumber(v.z.I)
end


return _M


-- Stanford GraphBase ffi binding
-- Written by Soojin Nam. Public Domain.


local ffi = require "ffi"
require "sgb_hdr"
local gb = ffi.load "gb"

local str_byte = string.byte
local str_char = string.char
local co_yield = coroutine.yield
local co_wrap = coroutine.wrap
local NULL = ffi.null
local ffi_cast = ffi.cast
local str = ffi.string
local ffi_sizeof = ffi.sizeof
local tonumber = tonumber
local io_write = io.write
local sformat = string.format


local _M = {
   gb = gb,
   version = '0.0.3'
}


-- gb_flip.w
function _M.gb_next_rand ()
   local r = gb.gb_fptr[0]
   if r >= 0 then
      gb.gb_fptr = gb.gb_fptr - 1
      return r
   end
   return gb.gb_flip_cycle()
end


-- gb_graph.w
function _M.gb_typed_alloc (n, t, s)
   return gb.gb_alloc(n * ffi_sizeof(t), s)
end

function _M.n_1 (g)
   return tonumber(g.uu.I)
end

function _M.mark_bipartite (g, n1)
   g.uu.I = n1
   g.util_types[8] = str_byte('I')
end

function _M.make_compound_id (g, s1, gg, s2)
   gb.make_compound_id(g._g, ffi_cast("char*", s1),
                       gg._g, ffi_cast("char*", s2))
end

function _M.make_double_compound_id (g, s1, g, s2, ggg, s3)
   gb.make_double_compound_id(g._g, ffi_cast("char*", s1),
                              gg._g, ffi_cast("char*", s2),
                              ggg._g, ffi_cast("char*", s3))
end

function _M.gb_save_string (s)
   return gb.gb_save_string(ffi_cast("char*", s))
end

function _M.hash_out (s)
   return gb.hash_out(ffi_cast("char*", s))
end

function _M.hash_lookup (s, g)
   return gb.hash_lookup(ffi_cast("char*", s), g)
end

function _M.vertices (g)
   return co_wrap(function ()
         local v = g.vertices
         local n = tonumber(g.n) - 1
         for i=0,n do
            co_yield(v+i)
         end
   end)
end

function _M.iter_vertices (vertices, fn)
   return co_wrap(function ()
         local v = vertices
         while v ~= NULL do
            co_yield(v)
            v = fn(v)
         end
   end)
end

function _M.arcs (v)
   return co_wrap(function ()
         local a = v.arcs
         while a ~= NULL do
            co_yield(a)
            a = a.next
         end
   end)
end


-- gb_io.w
function _M.gb_char ()
   return str_char(gb.gb_char())
end

function _M.new_checksum (s, old_checksum)
   return gb.new_checksum(ffi_cast("char*", s), old_checksum)
end

function _M.gb_string (p, c)
   return gb.gb_string(p, str_byte(c))
end

function _M.gb_raw_open (f)
   gb.gb_raw_open(ffi_cast("char*", f))
end

function _M.gb_open (f)
   return gb.gb_open(ffi_cast("char*", f)) == 0
end

function _M.gb_close ()
   return gb.gb_close() == 0
end

function _M.gb_eof ()
   return gb.gb_eof() ~= 0
end


-- gb_basic.w
function _M.induced (g, f, ...)
   return gb.induced(g, ffi_cast("char*", f), ...)
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


-- gb_books.w
function _M.book (title, ...)
   return gb.book(ffi_cast("char*", title), ...)
end

function _M.bi_book (title, ...)
   return gb.bi_book(ffi_cast("char*", title), ...)
end

function _M.desc (v)
   return str(v.z.S)
end

function _M.in_count (v)
   return tonumber(v.y.I)
end

function _M.out_count (v)
   return tonumber(v.x.I)
end

function _M.short_code (v)
   return tonumber(v.u.I)
end

function _M.chap_no (a)
   return tonumber(a.a.I)
end


-- gb_games.w
function _M.ap (v)
   return tonumber(v.u.I)
end

function _M.upi (v)
   return tonumber(v.v.I)
end

function _M.abbr (v)
   return str(v.x.S)
end

function _M.nickname (v)
   return str(v.y.S)
end

function _M.conference (v)
   return str(v.z.S)
end

function _M.venue (a)
   return tonumber(a.a.I)
end

function _M.date (a)
   return tonumber(a.b.I)
end


-- gb_gates.w
function _M.gate_eval (g, in_vec, out_vec)
   return gb.gate_eval(g, ffi_cast("char*", in_vec), ffi_cast("char*", out_vec))
end

function _M.partial_gates (g, r, prob, seed, buf)
   return gb.partial_gates(g, r, prob, seed, ffi_cast("char*", buf))
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
   local v = ffi_cast("unsigned long", v)
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


-- gb_save.w
function _M.save_graph (g, f)
   return gb.save_graph(g, ffi_cast("char*", f))
end

function _M.restore_graph (f)
   return gb.restore_graph(ffi_cast("char*", f))
end


-- common
function _M.printf (...)
   io_write(sformat(...))
end


return _M

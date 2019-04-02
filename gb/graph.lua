
-- Stanford GraphBase ffi bounding
-- Written by Soojin Nam. Public Domain.

local ffi = require "ffi"
local NULL = ffi.null
local tonumber = tonumber
local ffi_load = ffi.load
local ffi_cast = ffi.cast
local ffi_string = ffi.string


ffi.cdef[[
typedef union{
struct vertex_struct*V;
struct arc_struct*A;
struct graph_struct*G;
char*S;
long I;
}util;

typedef struct vertex_struct{
struct arc_struct*arcs;
char*name;
util u,v,w,x,y,z;
}Vertex;

typedef struct arc_struct{
struct vertex_struct*tip;
struct arc_struct*next;
long len;
util a,b;
}Arc;

struct area_pointers{
char*first;
struct area_pointers*next;
};

typedef struct area_pointers*Area[1];

typedef struct graph_struct{
Vertex*vertices;
long n;
long m;
char id[161];
char util_types[15];
Area data;
Area aux_data;
util uu,vv,ww,xx,yy,zz;
}Graph;

extern long verbose;
extern long panic_code;
extern long gb_trouble_code;
extern char*gb_alloc(long, Area);
extern void gb_free(Area);
extern long extra_n;
extern char null_string[];
extern void make_compound_id(Graph*,char*,Graph*,char*);
extern void make_double_compound_id(Graph*,char*,Graph*,char*,Graph*,char*);
extern Graph*gb_new_graph(long);
extern void gb_new_arc(Vertex*,Vertex*,long);
extern Arc*gb_virgin_arc();
extern void gb_new_edge(Vertex*,Vertex*,long);
extern char*gb_save_string(char*);
extern void switch_to_graph(Graph*);
extern void gb_recycle(Graph*);
extern void hash_in(Vertex*);
extern Vertex*hash_out(char*);
extern void hash_setup(Graph*);
extern Vertex*hash_lookup(char*,Graph*);
]]


local gb = ffi_load "gb"


local _M = {
   version = '0.0.1'
}


local graph = function (cdata)
   if cdata == NULL then
      return NULL
   end
   local g = {
      _g = cdata,
      n = tonumber(cdata.n),
      m = tonumber(cdata.m),
      id = ffi_string(cdata.id)
   }
   local vertices = {}
   for i=0,g.n-1 do
      vertices[#vertices+1] = cdata.vertices + i
   end
   g.vertices = vertices
   return g
end


_M.graph = graph

_M.gb_alloc = gb.gb_alloc
_M.gb_free = gb.gb_free


function _M.make_compound_id (g, s1, gg, s2)
   gb.make_compound_id(g._g, ffi_cast("char*", s1),
                       gg._g, ffi_cast("char*", s2))
end


function _M.make_double_compound_id (g, s1, g, s2, ggg, s3)
   gb.make_double_compound_id(g._g, ffi_cast("char*", s1),
                              gg._g, ffi_cast("char*", s2),
                              ggg._g, ffi_cast("char*", s3))
end


function _M.gb_new_graph (n)
   return graph(gb.gb_new_graph(n))
end


function _M.gb_new_arc (u, v, len)
   gb.gb_new_arc(u._v, v._v, len)
end


function _M.gb_virgin_arc ()
   return arc(gb.gb_virgin_arc())
end


function _M.gb_new_arc (u, v, len)
   gb.gb_new_arc(u._v, v._v, len)
end


function _M.gb_save_string (s)
   return ffi_string(gb.gb_save_string(ffi_cast("char*", s)))
end


function _M.switch_to_graph (g)
   gb.switch_to_graph(g._g)
end


function _M.gb_recycle (g)
   gb.gb_recycle(g._g)
end


function _M.hash_in (v)
   gb.hash_in(v._v)
end


function _M.hash_out (s)
   return gb.hash_out(ffi_cast("char*", s))
end


function _M.hash_setup (g)
   gb.hash_setup(g._g)
end


function _M.hash_lookup (s, g)
   return gb.hash_lookup(ffi_cast("char*", s), g._g)
end


return _M

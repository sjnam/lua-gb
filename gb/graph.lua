
-- Stanford GraphBase ffi bounding
-- Written by Soojin Nam. Public Domain.

local ffi = require "ffi"


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


local gb = ffi.load "gb"


local _M = {
   version = '0.0.1'
}


_M.gb_free = gb.gb_free
_M.gb_alloc = gb.gb_alloc
_M.gb_new_graph = gb.gb_new_graph
_M.gb_new_arc = gb.gb_new_arc
_M.gb_virgin_arc = gb.gb_virgin_arc
_M.gb_new_arc = gb.gb_new_arc
_M.switch_to_graph = gb.switch_to_graph
_M.gb_recycle = gb.gb_recycle
_M.hash_in = gb.hash_in
_M.hash_setup = gb.hash_setup


function _M.gb_typed_alloc (n, t, s)
   return gb.gb_alloc(n * ffi.sizeof(t), s)
end


function _M.n_1 (g)
   return tonumber(g.uu.I)
end


function _M.mark_bipartite (g, n1)
   g.uu.I = n1
   g.util_types[8] = string.byte('I')
end


function _M.make_compound_id (g, s1, gg, s2)
   gb.make_compound_id(g._g, ffi.cast("char*", s1),
                       gg._g, ffi.cast("char*", s2))
end


function _M.make_double_compound_id (g, s1, g, s2, ggg, s3)
   gb.make_double_compound_id(g._g, ffi.cast("char*", s1),
                              gg._g, ffi.cast("char*", s2),
                              ggg._g, ffi.cast("char*", s3))
end


function _M.gb_save_string (s)
   return gb.gb_save_string(ffi.cast("char*", s))
end


function _M.hash_out (s)
   return gb.hash_out(ffi.cast("char*", s))
end


function _M.hash_lookup (s, g)
   return gb.hash_lookup(ffi.cast("char*", s), g)
end


return _M

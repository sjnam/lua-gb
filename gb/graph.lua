
-- Stanford GraphBase ffi binding
-- Written by Soojin Nam. Public Domain.

local ffi = require "ffi"
local co_yield = coroutine.yield
local co_wrap = coroutine.wrap
local NULL = ffi.null

-- graph
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


-- basic
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


-- books
ffi.cdef[[
extern Graph*book(char*,unsigned long,unsigned long,unsigned long,unsigned long,long,long,long);
extern Graph*bi_book(char*,unsigned long,unsigned long,unsigned long,unsigned long,long,long,long);
extern long chapters;
extern char*chap_name[];
]]


-- dijk
ffi.cdef[[
extern long dijkstra(Vertex*,Vertex*,Graph*,long(*)(Vertex*));
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


-- econ
ffi.cdef[[
extern Graph*econ(unsigned long,unsigned long,unsigned long,long);
]]


-- games
ffi.cdef[[
extern Graph*games(unsigned long,long,long,long,long,long,long,long);
]]


-- gates
ffi.cdef[[
extern Graph*risc(unsigned long);
extern Graph*prod(unsigned long,unsigned long);
extern void print_gates(Graph*);
extern long gate_eval(Graph*,char*,char*);
extern Graph*partial_gates(Graph*,unsigned long,unsigned long,long,char*);
extern long run_risc(Graph*,unsigned long[],unsigned long,unsigned long);
extern unsigned long risc_state[];
]]


-- lisa
ffi.cdef[[
extern long*lisa(unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,Area);
extern Graph*plane_lisa(unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long);
extern Graph*bi_lisa(unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,long);
extern char lisa_id[];
]]


-- miles
ffi.cdef[[
extern Graph*miles(unsigned long,long,long,long,unsigned long,unsigned long,long);
extern long miles_distance(Vertex*,Vertex*);
]]


-- plain
ffi.cdef[[
extern Graph*plane(unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,long);
extern Graph*plane_miles(unsigned long,long,long,long,unsigned long,unsigned long,long);
extern void delaunay(Graph*,void(*)());
]]


-- raman
ffi.cdef[[
extern Graph*raman(long,long,unsigned long,unsigned long);
]]


-- rand
ffi.cdef[[
extern Graph*random_graph(unsigned long,unsigned long,long,long,long,long*,long*,long,long,long);
extern Graph*random_bigraph(unsigned long,unsigned long,unsigned long,long,long*,long*,long,long,long);
extern long random_lengths(Graph*,long,long,long,long*,long);
]]


-- roget
ffi.cdef[[
extern Graph*roget(unsigned long,unsigned long,unsigned long,long);
]]


-- save
ffi.cdef[[
extern long save_graph(Graph*,char*);
extern Graph*restore_graph(char*);
]]


-- sort
ffi.cdef[[
typedef struct node_struct {
  long key;
  struct node_struct *link;
} node;
extern void gb_linksort(node*);
extern char*gb_sorted[];
]]


-- words
ffi.cdef[[
extern Graph*words(unsigned long,long[],long,long);
extern Vertex*find_word(char*,void(*)(Vertex*));
]]



local gb = ffi.load "gb"


local _M = {
   version = '0.0.2'
}


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


return _M

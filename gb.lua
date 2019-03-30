local ffi = require "ffi"
local C = ffi.C
local NULL = ffi.null
local ffi_cast = ffi.cast
local ffi_load = ffi.load
local ffi_string = ffi.string
local tonumber = tonumber

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

extern Graph*board(long,long,long,long,long,long,long);
extern Graph*simplex();
extern Graph*subsets();
extern Graph*perms();
extern Graph*parts();
extern Graph*binary();
extern Graph*complement();
extern Graph*gunion(Graph*,Graph*,long,long);
extern Graph*intersection();
extern Graph*lines();
extern Graph*product();
extern Graph*induced();
extern Graph*bi_complete();
extern Graph*wheel();

extern long save_graph(Graph*,char*);
extern Graph*restore_graph();
]]


local gb = ffi_load "gb"


local _M = {
    version = '0.0.1'
}


local arc, vertex, graph

arc = function (cdata)
    if cdata == NULL then
        return NULL
    end
    return {
        _a = cdata,
        tip = vertex(cdata.tip, true),
        len = tonumber(cdata.len)
    }
end


vertex = function (cdata, tip)
    if cdata == NULL then
        return NULL
    end
    local v = {
        _v = cdata,
        name = ffi_string(cdata.name)
    }
    if tip then
        return v
    end
    local arcs = {}
    local a = cdata.arcs
    while a ~= NULL do
        arcs[#arcs+1] = arc(a)
        a = a.next
    end
    v.arcs = arcs
    return v
end


graph = function (cdata)
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
        vertices[#vertices+1] = vertex(cdata.vertices[i])
    end
    g.vertices = vertices
    return g
end


function _M.board (...)
    return graph(gb.board(...))
end


function _M.gunion (g, gg, n1, n2)
    return graph(gb.gunion(g._g, gg._g, n1, n2))
end


function _M.save_graph (g, f)
    return gb.save_graph(g._g, ffi_cast("char*", f))
end


return _M

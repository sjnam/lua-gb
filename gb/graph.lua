
-- Stanford GraphBase ffi bounding
-- Written by Soojin Nam. Public Domain.

local ffi = require "ffi"
local NULL = ffi.null
local tonumber = tonumber
local ffi_load = ffi.load
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


_M.arc = arc
_M.vertex = vertex
_M.graph = graph


return _M

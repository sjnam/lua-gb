
-- Stanford GraphBase ffi binding
-- Written by Soojin Nam. Public Domain.


local ffi = require "ffi"

local ffi_cdef = ffi.cdef


-- gb_flip.h
ffi_cdef[[
extern long*gb_fptr;
extern long gb_flip_cycle();
extern void gb_init_rand(long);
extern long gb_unif_rand(long);
]]


-- gb_graph.h
ffi_cdef[[
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
extern unsigned long edge_trick;
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


-- gb_io.h
ffi_cdef[[
extern long io_errors;
extern char imap_chr(long);
extern long imap_ord(char);
extern void gb_newline();
extern long new_checksum();
extern long gb_eof();
extern char gb_char();
extern void gb_backup();
extern long gb_digit(char);
extern unsigned long gb_number(char);
extern char str_buf[];
extern char*gb_string(char*,char);
extern void gb_raw_open(char*);
extern long gb_open(char*);
extern long gb_close();
extern long gb_raw_close();
]]


-- gb_sort.h
ffi_cdef[[
typedef struct node_struct {
  long key;
  struct node_struct *link;
} node;
extern void gb_linksort(node*);
extern char*gb_sorted[];
]]


-- gb_basic.h
ffi_cdef[[
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


-- gb_books.h
ffi_cdef[[
extern Graph*book(char*,unsigned long,unsigned long,unsigned long,unsigned long,long,long,long);
extern Graph*bi_book(char*,unsigned long,unsigned long,unsigned long,unsigned long,long,long,long);
extern long chapters;
extern char*chap_name[];
]]


-- gb_dijk.h
ffi_cdef[[
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


-- gb_econ.h
ffi_cdef[[
extern Graph*econ(unsigned long,unsigned long,unsigned long,long);
]]


-- gb_games.h
ffi_cdef[[
extern Graph*games(unsigned long,long,long,long,long,long,long,long);
]]


-- gb_gates.h
ffi_cdef[[
extern Graph*risc(unsigned long);
extern Graph*prod(unsigned long,unsigned long);
extern void print_gates(Graph*);
extern long gate_eval(Graph*,char*,char*);
extern Graph*partial_gates(Graph*,unsigned long,unsigned long,long,char*);
extern long run_risc(Graph*,unsigned long[],unsigned long,unsigned long);
extern unsigned long risc_state[];
]]



-- gb_lisa.h
ffi_cdef[[
extern long*lisa(unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,Area);
extern Graph*plane_lisa(unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long);
extern Graph*bi_lisa(unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,long);
extern char lisa_id[];
]]


-- gb_miles.h
ffi_cdef[[
extern Graph*miles(unsigned long,long,long,long,unsigned long,unsigned long,long);
extern long miles_distance(Vertex*,Vertex*);
]]


-- gb_plain.h
ffi_cdef[[
extern Graph*plane(unsigned long,unsigned long,unsigned long,unsigned long,unsigned long,long);
extern Graph*plane_miles(unsigned long,long,long,long,unsigned long,unsigned long,long);
extern void delaunay(Graph*,void(*)());
]]


-- gb_raman.h
ffi_cdef[[
extern Graph*raman(long,long,unsigned long,unsigned long);
]]


-- gb_rand.h
ffi_cdef[[
extern Graph*random_graph(unsigned long,unsigned long,long,long,long,long*,long*,long,long,long);
extern Graph*random_bigraph(unsigned long,unsigned long,unsigned long,long,long*,long*,long,long,long);
extern long random_lengths(Graph*,long,long,long,long*,long);
]]


-- gb_roget.h
ffi_cdef[[
extern Graph*roget(unsigned long,unsigned long,unsigned long,long);
]]


-- gb_save.h
ffi_cdef[[
extern long save_graph(Graph*,char*);
extern Graph*restore_graph(char*);
]]


-- gb_words.h
ffi_cdef[[
extern Graph*words(unsigned long,long[],long,long);
extern Vertex*find_word(char*,void(*)(Vertex*));
]]

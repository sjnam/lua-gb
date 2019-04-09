--[[
   Strong components.
   This demonstration program computes the
   strong components of GraphBase graphs derived from Roget's Thesaurus,
   using a variant of Tarjan's algorithm [R. E. Tarjan, ``Depth-first
   @^Tarjan, Robert Endre@>
   search and linear graph algorithms,'' {\sl SIAM Journal on Computing\/
   \bf1} (1972), 146--160]. We also determine the relationships
   between strong components.

   Two vertices belong to the same strong component if and only if they
   are reachable from each other via directed paths.

   We will print the strong components in ``reverse topological order'';
   that is, if |v| is reachable from~|u| but |u| is not reachable
   from~|v|, the strong component containing~|v| will be listed before
   the strong component containing~|u|.

   Vertices from the |roget| graph are identified both by name and by
   category number.
--]]


local ffi = require "ffi"
local gb_graph = require "gb.graph"
local gb_roget = require "gb.roget"
local gb_save = require "gb.save"
local gb = ffi.load "gb"
local str = ffi.string
local ipairs = ipairs
local print = print
local tonumber = tonumber
local cat_no = gb_roget.cat_no
local arcs = gb_graph.arcs
local vertices = gb_graph.vertices
local iter_vertices = gb_graph.iter_vertices
local restore_graph = gb_save.restore_graph


local function printf (...)
   io.write(string.format(...))
end


local function specs (v)
   return cat_no(v), str(v.name)
end


local function rank (v)
   return tonumber(v.z.I)
end
local function set_rank (v, n)
   v.z.I = n
end


local function parent (v)
   return v.y.V
end
local function set_parent (v, v1)
   v.y.V = v1
end


local function untagged (v)
   return v.x.A
end
local function set_untagged (v, v1)
   v.x.A = v1
end


local function link (v)
   return v.w.V
end
local function set_link (v, v1)
   v.w.V = v1
end


local function min (v)
   return v.v.V
end
local function set_min (v, v1)
   v.v.V = v1
end


local function arc_from (v)
   return v.x.V
end
local function set_arc_from (v, v1)
   v.x.V = v1
end


local function roget_component (n, d, p, s, filename)
   local g = filename and restore_graph(filename) or gb_roget.roget(n, d, p, s)
   if g == nil then
      printf("Sorry, can't create the graph! (error code %d)\n",
             tonumber(gb.panic_code))
      return
   end
   printf("Reachability analysis of %s\n\n", str(g.id))

   for v in vertices(g) do
      set_rank(v, 0)
      set_untagged(v, v.arcs)
   end

   local nn = 0
   local active_stack, settled_stack

   for vv in vertices(g) do
      if rank(vv) == 0 then
         local v = vv
         v.y.V = nil
         nn = nn + 1
         set_rank(v, nn)
         set_link(v, active_stack)
         active_stack = v
         set_min(v, v)
         repeat
            local u, a
            a = untagged(v)
            if a ~= nil then
               u = a.tip
               set_untagged(v, a.next)
               if rank(u) ~= 0 then
                  if rank(u) < rank(min(v)) then set_min(v, u) end
               else
                  set_parent(u, v)
                  v = u
                  nn = nn + 1
                  set_rank(v, nn)
                  set_link(v, active_stack)
                  active_stack = v
                  set_min(v, v)
               end
            else
               u = parent(v)
               if min(v) == v then
                  local t = active_stack
                  active_stack = link(v)
                  set_link(v, settled_stack)
                  settled_stack = t
                  printf("Strong component `%d %s'", specs(v))
                  if t == v then print()
                  else
                     print(" also includes:")
                     while t ~= v do
                        printf(" %d %s ", specs(t))
                        printf("(from %d %s;", specs(parent(t)))
                        printf(" ..to %d %s)\n", specs(min(t)))
                        set_rank(t, g.n)
                        set_parent(t, v)
                        t = link(t)
                     end
                  end
                  set_rank(v, g.n)
                  set_parent(v, v)
               else
                  if rank(min(v)) < rank(min(u)) then set_min(u, min(v)) end
               end
               v = u
            end
         until v == nil
      end
   end

   print("\nLinks between components:")
   for v in iter_vertices(settled_stack, link) do
      local u = parent(v)
      set_arc_from(u, u)
      for a in arcs(v) do
         local w = parent(a.tip)
         if arc_from(w) ~= u then
            set_arc_from(w, u)
            printf("%d %s ->", specs(u))
            printf(" %d %s ", specs(w))
            printf("(e.g., %d %s ->", specs(v))
            printf(" %d %s)\n", specs(a.tip))
         end
      end
   end
end


-- main

local filename
local n, d, p, s = 0, 0, 0, 0
for _, a in ipairs(arg) do
   local k, v = a:match("-(%a)(%d+)")
   if k == "n" then
      n = tonumber(v)
   elseif k == "d" then
      d = tonumber(v)
   elseif k == "p" then
      p = tonumber(v)
   elseif k == "s" then
      s = tonumber(v)
   else
      filename = a:match("-g(%a+)")
      if not filename then
         printf("Usage: luajit %s [-nN][-dN][-pN][-sN][-gfoo]\n", arg[0])
         return
      end
   end
end

roget_component(n, d, p, s, filename)

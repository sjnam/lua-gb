local ffi = require "ffi"
local gb_graph = require "gb.graph"
local gb_roget = require "gb.roget"
local gb_save = require "gb.save"
local gb = ffi.load "gb"

local NULL = ffi.null
local cat_no = gb_roget.cat_no


local function specs (v)
   return cat_no(v), ffi.string(v.name)
end


local function rank (v, n)
   if n then
      v.z.I = n
      return
   end
   return tonumber(v.z.I)
end


local function parent (v, v1)
   if v1 then
      v.y.V = v1
      return
   end
   return v.y.V
end


local function untagged (v, v1)
   if v1 then
      v.x.A = v1
      return
   end
   return v.x.A
end


local function link (v, v1)
   if v1 then
      v.w.V = v1
      return
   end
   return v.w.V
end


local function min (v, v1)
   if v1 then
      v.v.V = v1
      return
   end
   return v.v.V
end


local function arc_from (v, v1)
   if v1 then
      v.x.V = v1
      return
   end
   return v.x.V
end


-- main
local n, d, p, s = 0, 0, 0, 0

local g = gb_roget.roget(n, d, p, s)
if g == NULL then
   print("Sorry, can't create the graph! (error code "..tonumber(gb.panic_code))
   return
end

print("Reachability analysis of "..ffi.string(g.id).."\n")

local v = g.vertices + g.n - 1
while v >= g.vertices do
   rank(v, 0)
   untagged(v, v.arcs)
   v = v - 1
end

local nn = 0
local active_stack, settled_stack = NULL, NULL

local vv = g.vertices
while vv < g.vertices + g.n do
   if rank(vv) == 0 then
      v = vv
      parent(v, NULL)
      nn = nn + 1
      rank(v, nn)
      link(v, active_stack)
      active_stack = v
      min(v, v)

      repeat
         local u, a
         a = untagged(v)
         if a ~= NULL then
            u = a.tip
            untagged(v, a.next)
            if rank(u) ~= 0 then
               if rank(u) < rank(min(v)) then min(v, u) end
            else
               parent(u, v)
               v = u
               nn = nn + 1
               rank(v, nn)
               link(v, active_stack)
               active_stack = v
               min(v, v)
            end
         else
            u = parent(v)
            if min(v) == v then
               local t = active_stack
               active_stack = link(v)
               link(v, settled_stack)
               settled_stack = t
               io.write(string.format("Strong component `%d %s'", specs(v)))
               if t == v then print()
               else
                  print(" also includes:")
                  while t ~= v do
                     io.write(string.format(" %d %s ", specs(t)))
                     io.write(string.format("(from %d %s;", specs(parent(t))))
                     io.write(string.format(" ..to %d %s)\n", specs(min(t))))
                     rank(t, g.n)
                     parent(t, v)
                     t = link(t)
                  end
               end
               rank(v, g.n)
               parent(v, v)
            else
               if rank(min(v)) < rank(min(u)) then min(u, min(v)) end
            end
            v = u
         end
      until v == NULL
   end
   vv = vv + 1
end

print("\nLinks between components:")
v = settled_stack
while v ~= NULL do
   local u, a = parent(v), v.arcs
   arc_from(u, u)
   while a ~= NULL do
      local w = parent(a.tip)
      if arc_from(w) ~= u then
         arc_from(w, u)
         io.write(string.format("%d %s ->", specs(u)))
         io.write(string.format(" %d %s ", specs(w)))
         io.write(string.format("(e.g., %d %s ->", specs(v)))
         io.write(string.format(" %d %s)\n", specs(a.tip)))
      end
      a = a.next
   end
   v = link(v)
end

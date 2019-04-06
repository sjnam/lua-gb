--[[
This simple demonstration program computes the connected
components of the GraphBase graph of five-letter words. It prints the
words in order of decreasing weight, showing the number of edges,
components, and isolated vertices present in the graph defined by the
first $n$ words for all~$n$.
--]]


local gb_graph = require "gb.graph"
local gb_words = require "gb.words"
local ffi = require "ffi"
local NULL = ffi.null
local io_write = io.write
local str = ffi.string
local words = gb_words.words
local weight = gb_words.weight
local vertices = gb_graph.vertices


local function printf (...)
   io_write(string.format(...))
end


local function link (vx, v)
   -- link to next vertex in component (occupies utility field |z|)
   if v then
      vx.z.V = v
   else
      return vx.z.V
   end
end


local function master (vx, v)
   -- pointer to master vertex in component
   if v then
      vx.y.V = v
   else
      return vx.y.V
   end
end


local function size (vx, v)
   -- size of component, kept up to date for master vertices only
   if v then
      vx.x.I = v
   else
      return tonumber(vx.x.I)
   end
end


-- main

local g = words(0, NULL, 0, 0)
local n, isol, comp, m = 0, 0, 0, 0

print("Component analysis of "..str(g.id))
for v in vertices(g) do
   n = n + 1
   printf("%4d: %5d %s", n, weight(v), str(v.name))
   link(v, v)
   master(v, v)
   size(v, 1)
   isol = isol + 1
   comp = comp + 1
   local a = v.arcs
   while a ~= NULL and a.tip > v do
      a = a.next
   end
   if a == NULL then
      io_write("[1]")
   else
      local c = 0
      while a ~= NULL do
         local u = a.tip
         m = m + 1
         u = master(u)
         if u ~= master(v) then
            local w, t = master(v)
            if size(u) < size(w) then
               if c > 0 then
                  c = c + 1
                  printf("%s %s[%d]", (c==2 and " with" or ","),
                         str(u.name), size(u))
               else
                  c = c + 1
               end
               size(w, size(w) + size(u))
               if size(u) == 1 then isol = isol - 1 end
               t = link(u)
               while t ~= u do
                  master(t, w)
                  t = link(t)
               end
               u.y.V = w
            else
               if c > 0 then
                  c = c + 1
                  printf("%s %s[%d]", (c==2 and " with" or ","),
                         str(w.name), size(w))
               else
                  c = c + 1
               end
               if size(u) == 1 then isol = isol - 1 end
               size(u, size(u) + size(w))
               if size(w) == 1 then isol = isol - 1 end
               t = link(w)
               while t ~= w do
                  master(t, u)
                  t = link(t)
               end
               master(w, u)
            end
            t = link(u)
            link(u, link(w))
            link(w, t)
            comp = comp - 1
         end
         a = a.next
      end
      printf(" in %s[%d]", str(master(v).name), size(master(v)))
   end
   printf("; c=%d,i=%d,m=%d\n", comp, isol, m)
end

print("\nThe following non-isolated words didn't join the giant component:")
for v in vertices(g) do
   if master(v) == v and size(v) > 1 and size(v) + size(v) < g.n then
      io_write(str(v.name))
      local c = 1
      local u = link(v)
      while u ~= v do
         if c == 12 then
            print()
            c = 1
         else
            c = c + 1
         end
         io_write(" "..str(u.name))
         u = link(u)
      end
      print()
   end
end

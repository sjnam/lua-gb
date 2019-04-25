--[[
This simple demonstration program computes the connected
components of the GraphBase graph of five-letter words. It prints the
words in order of decreasing weight, showing the number of edges,
components, and isolated vertices present in the graph defined by the
first $n$ words for all~$n$.
--]]


local ffi = require "ffi"
local sgb = require "sgb"
local NULL = ffi.null
local io_write = io.write
local str = ffi.string
local gb = sgb.gb
local printf = sgb.printf


local function link (v)
   -- link to next vertex in component (occupies utility field |z|)
   return v.z.V
end
local function set_link (v, v1)
   v.z.V = v1
end


local function master (v)
   -- pointer to master vertex in component
   return v.y.V
end
local function set_master (v, v1)
   v.y.V = v1
end


local function size (v)
   -- size of component, kept up to date for master vertices only
   return tonumber(v.x.I)
end
local function set_size (v, n)
   v.x.I = n
end


-- main

local g = gb.words(0, NULL, 0, 0)
local n, isol, comp, m = 0, 0, 0, 0

io_write("Component analysis of "..str(g.id).."\n")
for v in sgb.vertices(g) do
   n = n + 1
   printf("%4d: %5d %s", n, tonumber(v.u.I), str(v.name))
   set_link(v, v)
   set_master(v, v)
   set_size(v, 1)
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
               set_size(w, size(w) + size(u))
               if size(u) == 1 then isol = isol - 1 end
               t = link(u)
               while t ~= u do
                  set_master(t, w)
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
               set_size(u, size(u) + size(w))
               if size(w) == 1 then isol = isol - 1 end
               t = link(w)
               while t ~= w do
                  set_master(t, u)
                  t = link(t)
               end
               set_master(w, u)
            end
            t = link(u)
            set_link(u, link(w))
            set_link(w, t)
            comp = comp - 1
         end
         a = a.next
      end
      printf(" in %s[%d]", str(master(v).name), size(master(v)))
   end
   printf("; c=%d,i=%d,m=%d\n", comp, isol, m)
end

print("\nThe following non-isolated words didn't join the giant component:")
for v in sgb.vertices(g) do
   if master(v) == v and size(v) > 1 and size(v) + size(v) < g.n then
      io_write(str(v.name))
      local c = 1
      local u = link(v)
      while u ~= v do
         if c == 12 then
            io_write("\n")
            c = 1
         else
            c = c + 1
         end
         io_write(" "..str(u.name))
         u = link(u)
      end
      io_write("\n")
   end
end

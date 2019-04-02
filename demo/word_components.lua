local ffi = require "ffi"
local gb_graph = require "gb.graph"
local gb_words = require "gb.words"
local NULL = ffi.null
local print = print
local ipairs = ipairs
local tonumber = tonumber
local sformat = string.format
local io_write = io.write
local str = ffi.string
local words = gb_words.words


local function printf (...)
   io_write(sformat(...))
end


local function link (vx)
   -- link to next vertex in component (occupies utility field |z|)
   return vx.z.V
end


local function master (vx)
   -- pointer to master vertex in component
   return vx.y.V
end


local function size (vx)
   -- size of component, kept up to date for master vertices only
   return vx.x.I
end


-- main

local g = words(0, NULL, 0, 0)
local n, isol, comp, m = 0, 0, 0, 0

print("Component analysis of "..g.id)
for _, v in ipairs(g.vertices) do
   n = n + 1
   printf("%4d: %5d %s", n, tonumber(v.u.I), str(v.name))
   v.z.V = v
   v.y.V = v
   v.x.I = 1
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
                         str(u.name), tonumber(size(u)))
               else
                  c = c + 1
               end
               w.x.I = size(w) + size(u)
               if size(u) == 1 then isol = isol - 1 end
               t = link(u)
               while t ~= u do
                  t.y.V = w
                  t = link(t)
               end
               u.y.V = w
            else
               if c > 0 then
                  c = c + 1
                  printf("%s %s[%d]", (c==2 and " with" or ","),
                         str(w.name), tonumber(size(w)))
               else
                  c = c + 1
               end
               if size(u) == 1 then isol = isol - 1 end
               u.x.I = size(u) + size(w)
               if size(w) == 1 then isol = isol - 1 end
               t = link(w)
               while t ~= w do
                  t.y.V = u
                  t = link(t)
               end
               w.y.V = u
            end
            t = link(u)
            u.z.V = link(w)
            w.z.V = t
            comp = comp - 1
         end
         a = a.next
      end
      printf(" in %s[%d]", str(master(v).name), tonumber(size(master(v))))
   end
   printf("; c=%d,i=%d,m=%d\n", comp, isol, m)
end

print("\nThe following non-isolated words didn't join the giant component:")
for _, v in ipairs(g.vertices) do
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

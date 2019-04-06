local bit = require "bit"
local ffi = require "ffi"
local gb = ffi.load "gb"
local gb_graph = require "gb.graph"
local gb_raman = require "gb.raman"
local raman = gb_raman.raman
local arcs = gb_graph.arcs
local gb_recycle = gb_graph.gb_recycle

local function printf (...)
   io.write(string.format(...))
end


-- main

print("This program explores the girth and diameter of Ramanujan graphs.")
print("The bipartite graphs have q^3-q vertices, and the non-bipartite")
print("graphs have half that number. Each vertex has degree p+1.")
print("Both p and q should be odd prime numbers;")
print("  or you can try p = 2 with q = 17 or 43.")

while true do
   io.write("\nChoose a branching factor, p: ")
   local p = tonumber(io.read())
   if not p then break end
   io.write("OK, now choose the cube root of graph size, q: ");
   local q = tonumber(io.read())
   if not q then break end

   local g = raman(p, q, 0, 0)
   if g == nil then
      local panic_code = gb.panic_code
      printf(" Sorry, I couldn't make that graph (%s).\n",
             panic_code == 40 and "q is out of range" or
                (panic_code == 41 and "p is out of range" or
                    (panic_code == 35 and "q is too big" or
                        (panic_code == 36 and "p is too big" or
                            (panic_code == 31 and "q isn't prime" or
                                (panic_code == 37 and "p isn't prime" or
                                    (panic_code == 33 and "p is a multiple of q" or
                                        (panic_code == 32 and "q isn't compatible with p=2" or "not enough memory"))))))))
   else
      local bipartite = false
      local n = tonumber(g.n)
      if n == (q+1) * q * (q-1) then
         bipartite = true
      end

      printf("The graph has %d vertices, each of degree %d, "
                .."and it is %sbipartite.\n", n, p+1, bipartite and "" or "not ")
      
      local s, dl, pp, gu = p+2, 1, p, 3
      while s < n do
         s = s + pp
         if s <= n then gu = gu + 1 end
         dl = dl + 1
         pp = pp * p
         s = s + pp
         if s <= n then gu = gu + 1 end
      end

      printf("Any such graph must have diameter >= %d and girth <= %d;\n", dl, gu)

      local du
      do
         local nn = (bipartite and n or 2*n)
         du = 0
         pp = 1
         while pp < nn do
            du = du + 2
            pp = pp * p
         end

         do
            local qq = math.floor(pp/nn)
            if qq * qq > p then
               du = du - 1
            elseif (qq+1) * (qq+1) > p then
               local aa = qq
               local bb = p - aa*aa
               local parity = 0
               pp = pp - qq*nn
               while true do
                  local x = math.floor((aa+qq) / bb)
                  local y = nn - x*pp
                  if y <= 0 then break end
                  aa = bb*x - aa
                  bb = math.floor((p - aa*aa) / bb)
                  nn = pp
                  pp = y
                  parity = bit.bxor(parity, 1)
               end
               if parity == 0 then du = du - 1 end
            end
         end
         if bipartite then du = du + 1 end
      end

      printf("theoretical considerations tell us that "
                .."this one's diameter is <= %d", du)

      if p == 2 then
         print(".")
      else
         if bipartite then
            local b = q * q
            gl = 1
            pp = p
            while pp <= b do
               gl = gl + 1
               pp = pp * p
            end
            gl = gl + gl
         else
            local b1, b2 = 1 + 4*q*q, 4 + 3*q*q
            gl = 1
            pp = p
            while pp < b1 do
               if pp >= b2 and bit.band(gl, 1) ~= 0 and bit.band(p, 2) ~= 0 then
                  break
               end
               gl = gl + 1
               pp = pp * p
            end
         end
         printf(",\nand its girth is >= %d.\n", gl)
      end

      print("Starting at any given vertex, there are")

      do
         local sentinel = g.vertices + n
         local girth = 999
         local k = 0
         local u = g.vertices
         u.w.V = sentinel
         local c = 1
         while c ~= 0 do
            local v = u
            u = sentinel
            c = 0
            k = k + 1
            while v ~= sentinel do
               for a in arcs(v) do
                  local w = a.tip
                  if w.w.V == nil then
                     w.w.V = u
                     w.v.I = k
                     w.u.V = v
                     u = w;
                     c = c + 1
                  elseif w.v.I+k < girth and w ~= v.u.V then
                     girth = w.v.I + k
                  end
               end
               v = v.w.V               
            end
            printf("%8d vertices at distance %d%s\n", c, k, (c > 0 and "," or "."))
         end
         printf("So the diameter is %d, and the girth is %d.\n",
                k-1, tonumber(girth))
      end

      gb_recycle(g)
   end
end

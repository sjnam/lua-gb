-- ladders.html

local cjson = require "cjson"
local ffi = require "ffi"
local sgb = require "sgb"
local gb = sgb.gb

local tonumber = tonumber
local NULL = ffi.null
local str = ffi.string
local ffi_new = ffi.new
local ngx_var = ngx.var
local ngx_say = ngx.say
local cjson_encode = cjson.encode


local gg


local function plant_new_edge (v)
   gb.gb_new_edge(gg.vertices+gg.n, v, 1)
end


local function print_dijkstra_result (vv)
   local t = NULL
   local p = vv
   if p.y.V == nil then
      return 404, "Sorry, '"..str(p.name).."' is unreachable.", -1
   end
   repeat
      local q = p.y.V
      p.y.V = t
      t = p
      p = q
   until t == p

   local tab = {}
   repeat
      tab[#tab+1] = str(t.name)
      t = t.y.V
   until t == nil

   t = p
   repeat
      local q = t.y.V
      t.y.V = p
      p = t
      t = q
   until p == vv

   return 200, tab, #tab
end


local function ladders (g, start, goal)
   local start = start or ""
   if #start ~= 5 then
      return 400, "'start' should be a five-letter word."
   end
   local goal = goal or ""
   if #goal ~= 5 then
      return 400, "'goal' should be a five-letter word."
   end
   gg = gb.gb_new_graph(0)
   if gg == NULL then
      return 500, "Sorry, I couldn't build a dictionary!"
   end
   gg.vertices = g.vertices
   gg.n = g.n

   local a = gg.vertices + gg.n
   a.name = ffi.new("char[6]", start)
   local vv
   local uu = gb.find_word(ffi.cast("char*", start), plant_new_edge)
   if uu == NULL then
      uu = gg.vertices + gg.n
      gg.n = gg.n + 1
   end
   if start == goal then
      vv = uu
   else
      local a = gg.vertices + gg.n
      a.name = ffi.new("char[6]", goal)
      vv = gb.find_word(ffi.cast("char*", goal), plant_new_edge)
      if vv == NULL then
         vv = gg.vertices + gg.n
         gg.n = gg.n + 1
      end
   end

   if gb.gb_trouble_code ~= 0 then
      return 500, "Sorry, I couldn't build a dictionary!" 
   end

   local min_dist = gb.dijkstra(uu, vv, gg, NULL)
   if min_dist < 0 then
      return 404, "Sorry, there's no ladder from '"
         ..start.."' to '"..goal.."'.", -1
   end

   local ok, path, length = print_dijkstra_result(vv)

   uu = g.vertices + gg.n - 1
   while uu >= g.vertices+g.n do
      for a in sgb.arcs(uu) do
         vv = a.tip
         vv.arcs = vv.arcs.next
      end
      uu.arcs = NULL
      uu = uu - 1
   end
   gb.gb_recycle(gg)

   return ok, path, length
end


-- main

local ok, path, length
local n = tonumber(ngx_var.arg_n or "0") or 0
if n > 5757 or n < 0 then
   n = 0
end

local g = gb.words(n, NULL, 0, 0)
if g == NULL then
   ok = 500
   path = "Sorry, I couldn't build a dictionary!"
else
   ok, path, length = ladders(g, ngx_var.arg_start, ngx_var.arg_goal)
end

ngx_say(cjson_encode{ status = ok, ladders = path, length = length })

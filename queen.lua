local gb = require "gb"


local function printf (...)
    io.write(string.format(...))
end


local g = gb.board(3, 4, 0, 0, -1, 0, 0)
local gg = gb.board(3, 4, 0, 0, -2, 0, 0)
local ggg = gb.gunion(g, gg, 0, 0)

gb.save_graph(ggg, "queen.gb")

print("Queen Moves on a 3x4 Board\n")
print("  The graph whose official name is\n"..ggg.id)
printf("  has %d vertices and %d arcs:\n\n", ggg.n, ggg.m)

for _, v in ipairs(ggg.vertices) do
    print(v.name)
    for _, a in ipairs(v.arcs) do
        printf("  -> %s, length %d\n", a.tip.name, a.len)
    end
end

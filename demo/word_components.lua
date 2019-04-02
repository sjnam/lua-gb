local ffi = require "ffi"
local gb_graph = require "gb.graph"
local gb_words = require "gb.words"
local NULL = ffi.null
local words = gb_words.words


local function printf (...)
    io.write(string.format(...))
end


local g = words(0, NULL, 0, 0)
local n = 0
local isol = 0
local comp = 0
local m = 0

printf("Component analysis of %s\n", g.id)

for _, v in ipairs(g.vertices) do
    n = n + 1
    printf("%4d: %5d %s", n, tonumber(v._v.u.I), v.name)

    v._v.z.V = v._v
    v._v.y.V = v._v
    v._v.x.I = 1
    isol = isol + 1
    comp = comp + 1

    local a = v._v.arcs
    while a ~= ffi.null and a.tip >ffi.cast("struct vertex_struct*", v._v) do
        a = a.next
    end
    if a == ffi.null then
        printf("[1]")
    else
        local c = 0
        while a ~= ffi.null do
            m = m + 1
            local u = a.tip
            u = u.y.V
            if u ~= v._v.y.V then
                local w, t = v._v.y.V
                if u.x.I < w.x.I then
                    if c > 0 then
                        c = c + 1
                        printf("%s %s[%d]",(c==2 and " with" or ","),
                               ffi.string(u.name), tonumber(u.x.I))
                    else
                        c = c + 1
                    end
                    w.x.I = w.x.I + u.x.I
                    if u.x.I == 1 then isol = isol - 1 end
                    t = u.z.V
                    while t ~= u do
                        t.y.V = w
                        t = t.z.V
                    end
                    u.y.V = w
                else
                    if c > 0 then
                        c = c + 1
                        printf("%s %s[%d]",(c==2 and " with" or ","),
                               ffi.string(u.name), tonumber(u.x.I))
                    else
                        c = c + 1
                    end
                    if u.x.I == 1 then isol = isol - 1 end
                    u.x.I = u.x.I + w.x.I
                    if w.x.I == 1 then isol = isol - 1 end
                    t = w.z.V
                    while t ~= w do
                        t.y.V = u
                        t = t.z.V
                    end
                    w.y.V = u
                end
                t = u.z.V
                u.z.V = w.z.V
                w.z.V = t
                comp = comp - 1
            end
            a = a.next
        end
        printf(" in %s[%d]",ffi.string(v._v.y.V.name),tonumber(v._v.y.V.x.I))
    end
    printf("; c=%d,i=%d,m=%d\n", comp, isol, m)
end

print("\nThe following non-isolated words didn't join the giant component:")
for _, v in ipairs(g.vertices) do
    if v._v.y.V == v._v and v._v.x.I > 1 and v._v.x.I + v._v.x.I < g.n then
        local u
        local c = 1
        printf("%s", ffi.string(v.name))
        u = v._v.z.V
        while u ~= v._v do
            if c == 12 then
                print()
                c = 1
            else
                c = c + 1
            end
            printf(" %s", ffi.string(u.name))
            u = u.z.V
        end
        print()
    end
end

local gb = require "gb"

gb.gb_init_rand(-314159)

if gb.gb_next_rand() ~= 119318998 then
    print("Failure on the first try!")
    return
end

for j=1,133 do
    gb.gb_next_rand()
end
if gb.gb_unif_rand(0x55555555) ~= 748103812 then
    print("Failure on the second try!")
    return
end

print("OK, the gb_flip routines seem to work!")

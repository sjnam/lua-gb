local gb = require "gb"
local error = error
local gb_init_rand = gb.gb_init_rand
local gb_next_rand = gb.gb_next_rand
local gb_unif_rand = gb.gb_unif_rand


gb_init_rand(-314159)

if gb_next_rand() ~= 119318998 then
    error("Failure on the first try!")
end

for j=1,133 do
    gb_next_rand()
end
if gb_unif_rand(0x55555555) ~= 748103812 then
    error("Failure on the second try!")
end

print("OK, the gb_flip routines seem to work!")

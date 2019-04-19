local ffi = require "ffi"
local gb_io = require "gb.io"
local error = error

local gb = ffi.load "gb"

if not gb_io.gb_open("test.dat") then
    error("Can't open test.dat")
end

if gb.gb_number(10) ~= 123456789 then
    error("fail to gb_number")
end

if gb.gb_digit(16) ~= 10 then
    error("fail to gb_digit")
end

gb.gb_backup()
gb.gb_backup()

if gb.gb_number(16) ~= 0x9ABCDEF then
    error("fail to gb_number")
end

if gb_io.gb_char() ~= '\n' then
    error("fail to gb_char")
end

gb.gb_newline()

if gb_io.gb_char() ~= '\n' then
    error("fail to gb_char")
end

if gb_io.gb_char() ~= '\n' then
    error("fail to gb_char")
end

if gb.gb_number(60) ~= 0 then
    error("fail to gb_number")
end

local temp = ffi.new("char[?]", 100)
gb_io.gb_string(temp, '\n')
gb.gb_newline()
gb_io.gb_string(temp, ':')

if ffi.string(temp) ~= "Oops" then
    error("fail to gb_string")
end

if gb.gb_digit(10) ~= -1 then
    error("Digit error not detected")
end

if gb_io.gb_char() ~= ':' then
    error("fail to gb_char")
end

if gb_io.gb_eof() then
    error("premature eof")
end

gb.gb_newline()

if not gb_io.gb_eof() then
    error("fail to gb_eof")
end

if not gb_io.gb_close() then
    error("fail to gb_close")
end

print("OK, the gb_io routines seem to work!");

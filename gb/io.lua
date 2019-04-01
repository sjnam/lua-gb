
-- Stanford GraphBase ffi bounding
-- Written by Soojin Nam. Public Domain.

local ffi = require "ffi"
local ffi_cast = ffi.cast
local ffi_load = ffi.load
local ffi_string = ffi.string
local str_byte = string.byte
local str_char = string.char


ffi.cdef[[
extern long io_errors;
extern char imap_chr(long);
extern long imap_ord(char);
extern void gb_newline();
extern long new_checksum();
extern long gb_eof();
extern char gb_char();
extern void gb_backup();
extern long gb_digit(char);
extern unsigned long gb_number(char);
extern char str_buf[];
extern char*gb_string(char*,char);
extern void gb_raw_open(char*);
extern long gb_open(char*);
extern long gb_close();
extern long gb_raw_close();
]]


local gb = ffi_load "gb"


local _M = {}


_M.imap_chr = gb.imap_chr
_M.imap_ord = gb.imap_ord
_M.gb_newline = gb.gb_newline
_M.gb_backup = gb.gb_backup
_M.gb_digit = gb.gb_digit
_M.gb_number = gb.gb_number
_M.gb_raw_close = gb.gb_raw_close


function _M.gb_char ()
    return str_char(gb.gb_char())
end


function _M.new_checksum (s, old_checksum)
    return gb.new_checksum(ffi_cast("char*", s), old_checksum)
end


function _M.gb_string (p, c)
    return gb.gb_string(p, str_byte(c))
end


function _M.gb_raw_open (f)
    gb.gb_raw_open(ffi_cast("char*", f))
end


function _M.gb_open (f)
    return gb.gb_open(ffi_cast("char*", f)) == 0
end


function _M.gb_close ()
    return gb.gb_close() == 0
end


function _M.gb_eof ()
    return gb.gb_eof() ~= 0
end


return _M

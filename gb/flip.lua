
-- Stanford GraphBase ffi bounding
-- Written by Soojin Nam. Public Domain.

local ffi = require "ffi"


ffi.cdef[[
extern long*gb_fptr;
extern long gb_flip_cycle();
extern void gb_init_rand(long);
extern long gb_unif_rand(long);
]]


local gb = ffi.load "gb"


local _M = {}


function _M.gb_next_rand()
   if gb.gb_fptr[0] >= 0 then
      local r = gb.gb_fptr[0]
      gb.gb_fptr = gb.gb_fptr - 1
      return r
   else
      gb.gb_flip_cycle()
   end
end


_M.gb_flip_cycle = gb.gb_flip_cycle
_M.gb_init_rand = gb.gb_init_rand
_M.gb_unif_rand = gb.gb_unif_rand


return _M

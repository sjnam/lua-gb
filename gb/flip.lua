
-- Stanford GraphBase ffi binding
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


function _M.gb_next_rand ()
   local r = gb.gb_fptr[0]
   if r >= 0 then
      gb.gb_fptr = gb.gb_fptr - 1
      return r
   end
   return gb.gb_flip_cycle()
end


return _M

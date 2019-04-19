
-- Stanford GraphBase ffi binding
-- Written by Soojin Nam. Public Domain.

require "gb.graph"


local _M = {}


function _M.weight (v)
   return tonumber(v.u.I)
end


function _M.loc (v)
   return tonumber(v.a.I)
end


return _M


-- Stanford GraphBase ffi binding
-- Written by Soojin Nam. Public Domain.


local _M = {}


function _M.dist (v)
   return tonumber(v.z.I)
end


function _M.backlink (v)
   return v.y.V
end


function _M.hh_val (v)
   return tonumber(v.x.I)
end


return _M

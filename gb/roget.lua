
-- Stanford GraphBase ffi binding
-- Written by Soojin Nam. Public Domain.


local _M = {}


function _M.cat_no (v)
   return tonumber(v.u.I)
end


return _M

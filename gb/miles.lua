
-- Stanford GraphBase ffi binding
-- Written by Soojin Nam. Public Domain.


local _M = {}

function _M.x_coord (v)
   return tonumber(v.x.I)
end


function _M.y_coord (v)
   return tonumber(v.y.I)
end


function _M.index_no (v)
   return tonumber(v.z.I)
end


function _M.people (v)
   return tonumber(v.w.I)
end


return _M

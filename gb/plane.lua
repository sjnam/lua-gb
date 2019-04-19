
-- Stanford GraphBase ffi binding
-- Written by Soojin Nam. Public Domain.


local _M = {
   INFTY = 0x10000000,
}


function _M.x_coord (v)
   return tonumber(v.x.I)
end


function _M.y_coord (v)
   return tonumber(v.y.I)
end


function _M.z_coord (v)
   return tonumber(v.z.I)
end


return _M

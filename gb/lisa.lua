
-- Stanford GraphBase ffi binding
-- Written by Soojin Nam. Public Domain.


local _M = {}


function _M.pixel_value (v)
   return tonumber(v.x.I)
end


function _M.first_pixel (v)
   return tonumber(v.y.I)
end


function _M.last_pixel (v)
   return tonumber(v.z.I)
end


function _M.matrix_rows (g)
   return tonumber(g.uu.I)
end


function _M.matrix_cols (g)
   return tonumber(g.vv.I)
end


return _M

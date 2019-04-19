
-- Stanford GraphBase ffi binding
-- Written by Soojin Nam. Public Domain.


local _M = {}


function _M.flow (a)
   return tonumber(a.a.I)
end


function _M.SIC_codes (v)
   return v.z.A
end


function _M.sector_total (v)
   return tonumber(v.y.I)
end


return _M


-- Stanford GraphBase ffi bounding
-- Written by Soojin Nam. Public Domain.

local basic = require "gb.basic"
local flip = require "gb.flip"
local save = require "gb.save"


local _M = {
    version = '0.0.1'
}


-- gb_basic
_M.board = basic.board
_M.gunion = basic.gunion


-- gb_save
_M.save_graph = save.save_graph


-- gb_flip
_M.gb_next_rand = flip.gb_next_rand
_M.gb_flip_cycle = flip.gb_flip_cycle
_M.gb_init_rand = flip.gb_init_rand
_M.gb_unif_rand = flip.gb_unif_rand


return _M

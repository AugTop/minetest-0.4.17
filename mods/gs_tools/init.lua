-- tool mods, by gsmanners
-- license: WTFPL

--------------------------------------------------

-- tool mods are Minetest modifications that add useful devices
--
-- the aim of this mod is to make tools that are simple, powerful, and fast
-- to be coherent, visually appealing, and as user friendly as possible

--------------------------------------------------
-- def

gs_tools = {}

local modpath = minetest.get_modpath("gs_tools")
gs_tools.modpath = modpath
gs_tools.player_inv_width = 8

--------------------------------------------------
-- modules

dofile(modpath.."/crafts.lua")

dofile(modpath.."/anvils.lua")
dofile(modpath.."/axes.lua")
dofile(modpath.."/ladders.lua")
dofile(modpath.."/sledges.lua")
dofile(modpath.."/torches.lua")
dofile(modpath.."/workbench.lua")

--------------------------------------------------
-- support

-- get player inventory width
-- this is set dynamically, so I have to detect this dynamically

gs_tools.get_player_inv_width = function()
	local p = minetest.get_connected_players()
	if p and #p > 0 then
		local i,v = next(p)
		-- I'm kind of assuming that the player inventory has 4 rows, here
		gs_tools.player_inv_width = math.floor( v:get_inventory():get_size("main") / 4 )
	else
		-- just keep waiting till we get this info
		minetest.after(1.5, gs_tools.get_player_inv_width)
	end
end

minetest.after(1.5, gs_tools.get_player_inv_width)

-- break a node and give the default drops

-- make a list of the 8 neighboring blocks around the pos a digger has targeted

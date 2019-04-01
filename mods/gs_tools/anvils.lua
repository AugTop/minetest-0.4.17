-- tool mods, by gsmanners
-- license: WTFPL

--------------------------------------------------

-- anvils let you repair weapons/armor/tools
-- you provide the item to repair and some raw material
-- and the anvil reduces the wear on that item
-- depending on your experience with the anvil

--------------------------------------------------

-- smithing skill
--
-- steel ingots = smithing I, bronze ingots = smithing II
-- mese = smithing III, diamonds = smithing IV

local mats = { "default:steel_ingot", "default:bronze_ingot",
	"default:mese_crystal", "default:diamond" }

-- this verifies that the anvil is in use

gs_tools.anvils_in_use = {}

function gs_tools.get_smithing(player)
	local s = player:get_inventory():get_stack("smithing", 1)
	local r = 0
	local p = 0
	for _,v in ipairs(mats) do
		if s:get_name() == v then
			r = p + s:get_count()
		else
			p = p + 100
		end
	end
	return r	-- 0..399
end

function gs_tools.improve_smithing(player, amount)
	local r = gs_tools.get_smithing(player) + amount
	if r > 399 then r = 399 end
	local t = math.floor(r / 100) 
	local c = r - (t * 100)
	if c == 0 then c = 1 end	-- level up bonus ;)
	local s = ItemStack(mats[t + 1])
	s:set_count(c)
	player:get_inventory():set_stack("smithing", 1, s)
end

minetest.register_on_joinplayer(function(player)
	local player_inv = player:get_inventory()
	player_inv:set_size("smithing", 1)
end)

-- examine the current task

function gs_tools.get_anvil_task(pos)
	local tiers = { wood=1, stone=1, steel=2, bronze=3, mese=4, obsidian=4,
		diamond=5, silver=2, mithril=5 }
	
	local m_names = { wood="default:wood", stone="default:cobble",
		steel="default:steel_ingot", bronze="default:bronze_ingot",
		mese="default:mese_crystal", diamond="default:diamond",
		obsidian="default:obsidian", silver="moreores:silver_ingot",
		mithril="moreores:mithril_ingot" }

	local tools = { pick=3, shovel=1, axe=3, sword=2, hoe=2,
		helmet=5, chestplate=8, leggings=7, boots=4, shield=7 }

	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local r = { valid = false }

	r.t = inv:get_stack("main", 1)
	r.m = inv:get_stack("main", 2)
	if not minetest.registered_tools[r.t:get_name()] then
		r.m = inv:get_stack("main", 1)
		r.t = inv:get_stack("main", 2)
	end
	if minetest.registered_tools[r.t:get_name()] then
		local tt = string.match(r.t:get_name(), ".*:(.+)_.+")
		local mt = string.match(r.t:get_name(), ".*:.+_(.+)")
		if mt == "sledge" then
			r.tr = tiers[tt]
			r.mn = m_names[tt]
			r.tn = 6
		elseif r.t:get_name() == "gs_tools:lumberaxe" then
			r.tr = 2
			r.mn = m_names.steel
			r.tn = 7
		else
			r.tr = tiers[mt]
			r.mn = m_names[mt]
			r.tn = tools[tt]
		end
		if r.tn and r.tr and r.mn and r.m:get_name() == r.mn and
			r.t:get_wear() > 0 then
			r.valid = true
		end
	end

	return r
end

-- determine the result of the indicated anvil task

function gs_tools.anvil_preview(pos, clicker)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local p = ItemStack("")

	inv:set_stack("skill", 1, clicker:get_inventory():get_stack("smithing", 1))

	local r = gs_tools.get_anvil_task(pos)

	-- an approved anvil task is queued?
	if r.valid then
		local a = (gs_tools.get_smithing(clicker) + 180) / (r.tr * 100.0)
		local w = r.t:get_wear() - math.floor(a / r.tn * 65536.0)
		if w < 0 then w = 0 end
		p:add_item(ItemStack(r.t:get_name()))
		p:set_wear(w)
	end

	inv:set_stack("preview", 1, p)
end

-- perform the anvil task (remove 1 item from each input)

function gs_tools.do_anvil(pos, clicker, auto)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	if auto > 0 and inv:is_empty("preview") then return end

	local r = gs_tools.get_anvil_task(pos)

	if r.valid then
		local s = inv:get_stack("main", 1)
		s:take_item()
		inv:set_stack("main", 1, s)
		s = inv:get_stack("main", 2)
		s:take_item()
		inv:set_stack("main", 2, s)

		if auto > 0 then
			-- move the result back into the input
			if inv:get_stack("main", 1):is_empty() then
				inv:set_stack("main", 1, inv:get_stack("preview", 1))
			else
				inv:set_stack("main", 2, inv:get_stack("preview", 1))
			end
		end

		-- learn by doing
		gs_tools.improve_smithing(clicker, r.tr)

		-- update preview (and skill)
		gs_tools.anvil_preview(pos, clicker)
	end
end

-- note: the anvil can only be used by one player at a time, this is by design

function gs_tools.get_anvil_formspec(pos, clicker)
	local spos = pos.x .. "," .. pos.y .. "," ..pos.z
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	local fs = "size[" .. gs_tools.player_inv_width .. ",8]"..
		default.gui_bg .. default.gui_bg_img .. default.gui_slots ..
		"list[nodemeta:" .. spos .. ";main;1.5,1;2,1;]"..
		"item_image_button[4,1;1,1;gs_tools:anvil;anvil;]"..
		"list[nodemeta:" .. spos .. ";preview;5.5,1;1,1;]"..
		"label[1.5,2;Skill:]list[nodemeta:" .. spos .. ";skill;2.5,2;1,1;]" ..
		"list[current_player;main;0,3.85;" .. gs_tools.player_inv_width .. ",1;]" ..
		"list[current_player;main;0,5.08;" .. gs_tools.player_inv_width .. ",3;" ..
			gs_tools.player_inv_width .. "]" ..
		default.get_hotbar_bg(0,3.85)
	return fs
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if string.sub(formname, 1, 14) == "gs_tools:anvil" then
		local pos = minetest.string_to_pos( string.sub(formname, 16) )
		local meta = minetest.get_meta(pos)
		if fields then
			if fields.anvil then
				gs_tools.do_anvil(pos, player, 1)
			end
			if fields.quit then
				gs_tools.anvils_in_use[minetest.hash_node_position(pos)] = false
			end
		end
	end
end)

minetest.register_node("gs_tools:anvil", {
	description = "Anvil",
	drawtype = "nodebox",
	tiles = {"gs_anvil.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = true,
	node_box = {
		type = "fixed",
		fixed = {
			{ -0.5, 0.5,-0.3,  0.5, 0.1, 0.3 },
			{ -0.2, 0.1,-0.1,  0.2,-0.2, 0.1 },
			{ -0.3,-0.2,-0.3,  0.3,-0.3, 0.3 },
			{ -0.4,-0.3,-0.4,  0.4,-0.5, 0.4 },
		}
	},
	groups = { cracky=1, level=2 },
	sounds = default.node_sound_stone_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("main", 2)
		inv:set_size("preview", 1)
		inv:set_size("skill", 1)
	end,
	can_dig = function(pos, player)
		local meta = minetest.get_meta(pos)
		if gs_tools.anvils_in_use[minetest.hash_node_position(pos)] then
			return false
		end
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
	on_rightclick = function(pos, node, clicker)
		local meta = minetest.get_meta(pos)
		if gs_tools.anvils_in_use[minetest.hash_node_position(pos)] then
			return
		end
		gs_tools.anvils_in_use[minetest.hash_node_position(pos)] = true
		gs_tools.anvil_preview(pos, clicker)
		minetest.show_formspec( clicker:get_player_name(),
			"gs_tools:anvil_" .. minetest.pos_to_string(pos),	-- embed pos into the fn
			gs_tools.get_anvil_formspec(pos, clicker) )
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, 
			count, player)
		if from_list == "preview" or to_list == "preview" or
			from_list == "skill" or to_list == "skill" then
			return 0
		else
			return count
		end
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if listname == "preview" or listname == "skill" then
			return 0
		else
			return stack:get_count()
		end
	end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if listname == "skill" then
			return 0
		else
			return stack:get_count()
		end
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, 
			count, player)
		gs_tools.anvil_preview(pos, player)
	end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
		gs_tools.anvil_preview(pos, player)
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		if listname == "preview" then
			gs_tools.do_anvil(pos, player, 0)
		else
			gs_tools.anvil_preview(pos, player)
		end
	end,
})

minetest.register_craft({
	output = "gs_tools:anvil",
	recipe = {
		{"default:steelblock", "default:steelblock", "default:steelblock"},
		{"", "default:steel_ingot", ""},
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"}
	}
})

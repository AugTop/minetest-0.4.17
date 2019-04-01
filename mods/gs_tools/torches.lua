-- tool mods, by gsmanners
-- license: WTFPL

--------------------------------------------------

-- torches give you light
-- the material used gives you varying durability and light spread

--------------------------------------------------

minetest.register_node("gs_tools:stone_torch", {
	description = "Stone Torch",
	drawtype = "torchlike",
	tiles = {
		{name="gs_stone_torch_anim.png", 
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}},
		{name="gs_stone_torch_anim2.png", 
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}},
		{name="gs_stone_torch_anim3.png", 
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}}
	},
	inventory_image = "gs_stone_torch.png",
	wield_image = "gs_stone_torch.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	is_ground_content = false,
	walkable = false,
	light_source = 13,
	selection_box = {
		type = "wallmounted",
		wall_top =    { -0.1,-0.1,-0.1,  0.1,0.5,0.1 },
		wall_bottom = { -0.1,-0.5,-0.1,  0.1,0.1,0.1 },
		wall_side =   { -0.5,-0.4,-0.1, -0.2,0.2,0.1 },
	},
	groups = { cracky=3, oddly_breakable_by_hand=3, attached_node=1, hot=2 },
	legacy_wallmounted = true,
	sounds = default.node_sound_stone_defaults(),
})

function gs_tools.torch_radiate(pos, w, on)
	local p = {x=pos.x,y=pos.y,z=pos.z}
	for x=-w,w do
	for z=-w,w do
		if x ~= 0 or z ~= 0 then
			p.x = pos.x + x
			p.z = pos.z + z
			local n = minetest.get_node_or_nil(p)
			if n then
				if on > 0 then
					if n.name == "air" then
						minetest.set_node(p, {name="gs_tools:light"})
					end
				else
					if n.name == "gs_tools:light" then
						minetest.remove_node(p)
					end
				end
			end
		end
	end
	end
end

minetest.register_node("gs_tools:clay_torch", {
	description = "Clay Torch",
	drawtype = "torchlike",
	tiles = {
		{name="gs_clay_torch_anim.png", 
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}},
		{name="gs_clay_torch_anim2.png", 
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}},
		{name="gs_clay_torch_anim3.png", 
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}}
	},
	inventory_image = "gs_clay_torch.png",
	wield_image = "gs_clay_torch.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	is_ground_content = false,
	walkable = false,
	light_source = 14,
	selection_box = {
		type = "wallmounted",
		wall_top =    { -0.1,-0.1,-0.1,  0.1,0.5,0.1 },
		wall_bottom = { -0.1,-0.5,-0.1,  0.1,0.1,0.1 },
		wall_side =   { -0.5,-0.4,-0.1, -0.2,0.2,0.1 },
	},
	groups = { cracky=3, oddly_breakable_by_hand=3, attached_node=1, hot=2 },
	legacy_wallmounted = true,
	sounds = default.node_sound_stone_defaults(),
	on_construct = function(pos)
		gs_tools.torch_radiate(pos, 2, 1)
	end,
	on_destruct = function(pos)
		gs_tools.torch_radiate(pos, 2, 0)
	end,
})

minetest.register_node("gs_tools:steel_torch", {
	description = "Steel Torch",
	drawtype = "torchlike",
	tiles = {
		{name="gs_steel_torch_anim.png", 
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}},
		{name="gs_steel_torch_anim2.png", 
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}},
		{name="gs_steel_torch_anim3.png", 
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}}
	},
	inventory_image = "gs_steel_torch.png",
	wield_image = "gs_steel_torch.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	is_ground_content = false,
	walkable = false,
	light_source = 14,
	selection_box = {
		type = "wallmounted",
		wall_top =    { -0.1,-0.1,-0.1,  0.1,0.5,0.1 },
		wall_bottom = { -0.1,-0.5,-0.1,  0.1,0.1,0.1 },
		wall_side =   { -0.5,-0.4,-0.1, -0.2,0.2,0.1 },
	},
	groups = { cracky=2, oddly_breakable_by_hand=2, attached_node=1, hot=2 },
	legacy_wallmounted = true,
	sounds = default.node_sound_stone_defaults(),
	on_construct = function(pos)
		gs_tools.torch_radiate(pos, 3, 1)
	end,
	on_destruct = function(pos)
		gs_tools.torch_radiate(pos, 3, 0)
	end,
})

minetest.register_node("gs_tools:light", {
	drawtype = "glasslike",
	tiles = {"gs_light.png"},
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	pointable = false,
	buildable_to = true,
	light_source = 14,
})

minetest.register_craft({
	output = "gs_tools:stone_torch 4",
	recipe = {
		{ "default:coal_lump" },
		{ "gs_tools:stone_rod" },
	}
})

minetest.register_craft({
	output = "gs_tools:stone_torch 4",
	recipe = {
		{ "gs_tools:charcoal" },
		{ "gs_tools:stone_rod" },
	}
})

minetest.register_craft({
	output = "gs_tools:clay_torch 4",
	recipe = {
		{ "default:coal_lump" },
		{ "gs_tools:clay_rod" },
	}
})

minetest.register_craft({
	output = "gs_tools:clay_torch 4",
	recipe = {
		{ "gs_tools:charcoal" },
		{ "gs_tools:clay_rod" },
	}
})

minetest.register_craft({
	output = "gs_tools:steel_torch 4",
	recipe = {
		{ "default:coal_lump" },
		{ "gs_tools:steel_rod" },
	}
})

minetest.register_craft({
	output = "gs_tools:steel_torch 4",
	recipe = {
		{ "gs_tools:charcoal" },
		{ "gs_tools:steel_rod" },
	}
})

if minetest.get_modpath("shields") then
dofile(minetest.get_modpath("rainbow_armor").."/rainbow_shield.lua")
end

--Define Rainbow Armor
minetest.register_tool("rainbow_armor:rainbow_helmet", {
	description = "Rainbow Helmet",
	inventory_image = "3d_armor_helmet_inv.png",
	groups = {armor_head=15, armor_heal=12, armor_use=30},
	wear = 0,
})
minetest.register_tool("rainbow_armor:rainbow_chestplate", {
	description = "Rainbow Chestplate",
	inventory_image = "3d_armor_chestplate_inv.png",
	groups = {armor_torso=20, armor_heal=12, armor_use=30},
	wear = 0,
})
minetest.register_tool("rainbow_armor:rainbow_leggings", {
	description = "Rainbow Leggings",
	inventory_image = "3d_armor_leggings_inv.png",
	groups = {armor_legs=20, armor_heal=12, armor_use=30},
	wear = 0,
})
minetest.register_tool("rainbow_armor:rainbow_boots", {
	description = "Rainbow Boots",
	inventory_image = "3d_armor_boots_inv.png",
	groups = {armor_feet=15, armor_heal=12, armor_use=30, physics_speed=1, physics_jump=0.5},
	wear = 0,
})
 
 
--Define Rainbow Armor crafting recipe
minetest.register_craft({
	output = "rainbow_armor:rainbow_helmet",
	recipe = {
		{"default:nyancat_rainbow", "default:nyancat_rainbow", "default:nyancat_rainbow"},
		{"default:nyancat_rainbow", "", "default:nyancat_rainbow"},
		{"", "", ""},
	},
})
minetest.register_craft({
	output = "rainbow_armor:rainbow_chestplate",
	recipe = {
		{"default:nyancat_rainbow", "", "default:nyancat_rainbow"},
		{"default:nyancat_rainbow", "default:nyancat_rainbow", "default:nyancat_rainbow"},
		{"default:nyancat_rainbow", "default:nyancat_rainbow", "default:nyancat_rainbow"},
	},
})
minetest.register_craft({
	output = "rainbow_armor:rainbow_leggings",
	recipe = {
		{"default:nyancat_rainbow", "default:nyancat_rainbow", "default:nyancat_rainbow"},
		{"default:nyancat_rainbow", "", "default:nyancat_rainbow"},
		{"default:nyancat_rainbow", "", "default:nyancat_rainbow"},
	},
})
minetest.register_craft({
	output = "rainbow_armor:rainbow_boots",
	recipe = {
		{"default:nyancat_rainbow", "", "default:nyancat_rainbow"},
		{"default:nyancat_rainbow", "", "default:nyancat_rainbow"},
	},
})

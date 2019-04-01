--Define Rainbow shield
minetest.register_tool("rainbow_armor:rainbow_shield", {
	description = "Rainbow Shield",
	inventory_image = "rainbow_armor_shield_inv.png",
	groups = {armor_shield=15, armor_heal=12, armor_use=30},
	wear = 0,
})


--Define Rainbow shield crafting recipe
minetest.register_craft({
	output = "rainbow_armor:rainbow_shield",
	recipe = {
		{"default:nyancat_rainbow", "default:nyancat_rainbow", "default:nyancat_rainbow"},
		{"default:nyancat_rainbow", "default:nyancat_rainbow", "default:nyancat_rainbow"},
		{"", "default:nyancat_rainbow", ""},
	},
})
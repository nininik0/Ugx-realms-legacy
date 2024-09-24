-- Load support for intllib.
local path = minetest.get_modpath(minetest.get_current_modname()) .. "/"

-- Translation support
local S = minetest.get_translator("mobs_monster")

-- Check for custom mob spawn file
local input = io.open(path .. "spawn.lua", "r")

if input then
	mobs.custom_spawn_monster = true
	input:close()
	input = nil
end


-- helper function
local function ddoo(mob)

	if minetest.settings:get_bool("mobs_monster." .. mob) == false then
		print("[Mobs_Monster] " .. mob .. " disabled!")
		return
	end

	dofile(path .. mob .. ".lua")
end

-- Monsters
ddoo("dirt_monster") -- PilzAdam
ddoo("dungeon_master")
ddoo("sand_monster")
ddoo("stone_monster")
ddoo("spider") -- AspireMint


-- Load custom spawning
if mobs.custom_spawn_monster then
	dofile(path .. "spawn.lua")
end

-- Register the UGX Cola item

-- Register the UGX Cola craft recipe
minetest.register_craft({
    output = 'ugx:cola',
    recipe = {
        {'', 'default:apple', ''},
        {'default:steel_ingot', 'default:water_source', 'default:steel_ingot'},
        {'', 'default:apple', ''},
    }
})

-- Lucky Blocks
if minetest.get_modpath("lucky_block") then
	dofile(path .. "lucky_block.lua")
end

-- Initialize mod

local timer = 0

minetest.register_globalstep(function(dtime)
    -- Track the elapsed time
    timer = timer + dtime
    -- Check every 300 seconds (5 minutes)
    if timer >= 10800 then
        -- Reset the timer
        timer = 0
        -- Get the number of connected players
        local players = minetest.get_connected_players()
        if players then
            local player_count = #players
            -- Play the sound if there are fewer than 2 players
            if player_count < 2 then
                minetest.sound_play("distortedtrumpets", {
                    gain = 1.0, -- Volume
                    max_hear_distance = 5000, -- Distance the sound can be heard
                })
            end
        else
            -- Handle case where players is nil (no players connected)
            return
        end
    end
end)



mobs:register_mob("mobs_monster:sam", {
   type = "monster",
   passive = false,
   attacks_monsters = true,
   attacks_npcs = true,
   damage = 1,
   reach = 1,
   attack_type = "dogfight",
   hp_min = 30,
   hp_max = 45,
   armor = 80,
   collisionbox = {-0.25, 0.35, -0.25, 0.25, 0.9, 0.25},
   physical = false,
   visual = "mesh",
   mesh = "character.b3d",
   textures = {
      {"deadsam.png"},
   },
   blood_amount = 1,
   blood_texture = "character_1.png",
   visual_size = {x=1, y=1},
   makes_footstep_sound = false,
   walk_velocity = 0.01,
   run_velocity = 5,
   jump = false,
   water_damage = 2,
   lava_damage = 0,
   light_damage = 0,
   view_range = 20,
   animation = {
      speed_normal = 1,
      speed_run = 1,
      walk_start = 1,
      walk_end = 1,
      stand_start = 1,
      stand_end = 1,
      run_start = 1,
      run_end = 1,
      punch_start = 1,
      punch_end = 1,
   },
})

minetest.register_abm({
	nodenames = {"soundstuff:wind"},
	interval = 14,
	chance = 1,
	action = function(...)
		minetest.sound_play({name="wind"}, 
		{max_hear_distance = 2, loop = false})
	end
})



minetest.register_node(":soundstuff:wind", {
  drawtype = "torchlike",
  use_texture_alpha = "clip",
	tiles = {"tree_form.png"},
   walkable = false,

	groups = { dig_immediate = 2},
})

-- Register the UGX Cola item
minetest.register_craftitem(":ugx:cola", {
    description = "UGX Cola",
    inventory_image = "ugx_cola.png", -- Ensure you have an image named ugx_cola.png in the textures folder
    on_use = function(itemstack, user, pointed_thing)
        -- Normal eating action
        if user:is_player() then
            local player_name = user:get_player_name()
            minetest.chat_send_player(player_name, "UGX COLA ESPUMA")

            -- Heal the player (normal eating effect)
            user:set_hp(user:get_hp() + 4)

            -- Get the player's position
            local pos = user:get_pos()
            if pos then
                pos.y = pos.y + 1  -- Adjust to the player's head level

                -- Trigger the eating sound and particles
                minetest.sound_play("hunger_eat", {pos = pos, gain = 1.0, max_hear_distance = 32})
                minetest.add_particlespawner({
                    amount = 10,
                    time = 0.1,
                    minpos = vector.subtract(pos, 0.5),
                    maxpos = vector.add(pos, 0.5),
                    minvel = {x=-2, y=-2, z=-2},
                    maxvel = {x=2, y=2, z=2},
                    minacc = {x=0, y=-9.81, z=0},
                    maxacc = {x=0, y=-9.81, z=0},
                    minexptime = 1,
                    maxexptime = 1.5,
                    minsize = 1,
                    maxsize = 3,
                    collisiondetection = true,
                    texture = "tnt_smoke.png"
                })

                -- Check for protection and trigger the explosion after a delay
                minetest.after(0.5, function()
                    if minetest.is_protected(pos) then
                        minetest.chat_send_player(player_name, "You are in a protected area. No explosion.")
                    else
                        tnt.boom(pos, {radius = 1, damage_radius = 1})
                    end
                end)
            end
        end
        itemstack:take_item()
        return itemstack
    end,
})

-- Register the UGX Cola craft recipe
minetest.register_craft({
    output = 'ugx:cola',
    recipe = {
        {'', 'default:apple', ''},
        {'default:steel_ingot', 'default:water_source', 'default:steel_ingot'},
        {'', 'default:apple', ''},
    }
})

-- Register the crafting recipe for default:geodeglass
minetest.register_craft({
    output = 'default:geodeglass',
    recipe = {
        {'', 'dye:red', ''},
        {'dye:red', 'default:glass', 'dye:red'},
        {'', 'dye:red', ''},
    }
})

mobs:register_mob("mobs_monster:sphere", {
   type = "npc",
   passive = false,
   attacks_monsters = true,
   attack_npcs = false,
   damage = 10,
   reach = 3,
   attack_type = "dogfight",
   group_attack = true, --you going to be mugged by spheres
   hp_min = 69,
   hp_max = 100,
   collisionbox = {-0.7, -1, -0.7, 0.7, 1.6, 0.7},
   armor = 70,
   physical = true,
   visual = "mesh",
   mesh = "testnodes_marble_metal.obj",
   textures = {
      {"default_cloud.png"},
   },
   blood_amount = 1,
   blood_texture = "default_cloud.png",
   visual_size = {x=25, y=25},
   makes_footstep_sound = true,
   walk_velocity = 5,
   run_velocity = 10,
   jump = false,
   water_damage = 0,
   lava_damage = 0,
   light_damage = 0,
   view_range = 40,
   follow = {"default:mese_crystal"},
	on_rightclick = function(self, clicker)
		if mobs:feed_tame(self, clicker, 8, true, true) then return end
		if mobs:protect(self, clicker) then return end
		if mobs:capture_mob(self, clicker, 0, 5, 50, false, nil) then return end
	end,
})


minetest.register_craft({
    output = 'ugx:fence_tree 4', -- Added quantity (6 fences per craft)
    recipe = {
        {'default:tree', '', 'default:tree'},
        {'default:tree', 'group:stick', 'default:tree'},
        {'', 'group:stick', ''}
    }
})

mobs:register_mob("mobs_monster:_", {
	type = "monster",
	hp_min = 20,
    show_on_minimap = true,
	hp_max = 200,
   damage = 11,
  jump_height = 50,
	visual = "upright_sprite",
   collisionbox = {-0.5, -1.5, -0.5, 0.5, 0.5, 0.5},
	textures = {"yikes.png", "yikes1.png" },
   visual_size = { x = 5, y = 5, z = 5 },
	walk_velocity = 5,
   jump_height = 15.55,
	run_velocity = 22,
	view_range = 321,
	pathfinding = 1222,
	sounds = {
		random = "spooky_noise",
	},
	drops = {
		{name = "air", chance = 11, min = 0, max = 1},
		{name = "default:portal2", chance = 100, min = 0, max = 1},
	},
	attack_type = "dogfight",
	reach = 5,
	damage = 11,
})


minetest.register_node(":ugx:spectre", {
	description = "".. core.colorize("#ff0000", "R")..core.colorize("#ff9900", "e")..core.colorize("#ffd000", "a")..core.colorize("#fffb00", "l")..core.colorize("#aaff00", "m ")..core.colorize("#04ff00", "L")..core.colorize("#00ffee", "a")..core.colorize("#005eff", "m")..core.colorize("#8400ff", "p"),
	tiles = {{
		    name = "spectre.png",
		    animation = {type = "vertical_frames", aspect_w = 1, aspect_h = 1, length = 12}
	}},
	paramtype2 = "facedir",
	place_param2 = 0,
	is_ground_content = false,
	stack_max= 69,
	groups = {cracky = 3},
	light_source = 14,
	on_blast = function() end,
	sounds = default.node_sound_glass_defaults(),
})

-- UNKOWN OBJCECT FINAL BOSS by nininik

mobs:register_mob("mobs_monster:UNKNOWN", {
	type = "monster",
	passive = false,
	damage = 15,
	attack_type = "shoot",
--	dogshoot_switch = 1,
--	dogshoot_count_max = 30, -- nah bro
--	dogshoot_count2_max = 1, -- bruh  
--	reach = 40,
	shoot_interval = 1,
	arrow = "mobs_monster:item",
	shoot_offset = 0,
  blood_amount = 100,
  blood_size = 9,
  blood_texture = "no_texture.png",
	hp_min = 500,
	hp_max = 1000,
	armor = 90,
	knock_back = true,
	collisionbox = {-4, -4, -4, 4, 4.6, 4},
	visual = "sprite",
	textures = {
		"unknown_object.png",
	},
	visual_size = {x=9, y=9},
	makes_footstep_sound = true,
	sounds = {
		random = "shut",
		shoot_attack = "mobs_fireball",
	},
	walk_velocity = 5,
	run_velocity = 22,
	jump = true,
	view_range = 100,
	drops = {
		{name = "util_commands:unkown", chance = 1, min = 1, max = 2},
	},
	water_damage = 0,
	lava_damage = 0,
	light_damage = 0,
	fear_height = 20
})


mobs:spawn({
	name = "mobs_flat:UNKNOWN",
	nodes = {"util_commands:unkown"},
	neighbors = {"default:mese", "default:stone_with_mese", "air", "default:mossycobble"},
	chance = 1,
	active_object_count = 1,
})




-- ITEM (weapon)
mobs:register_arrow("mobs_monster:item", {
	visual = "sprite",
	visual_size = {x = 2, y = 2},
	textures = {"unknown_item.png"},
	velocity = 6,
	tail = 1,
	tail_texture = "unknown_node.png",
	tail_size = 8,
	glow = 8,
	expire = 1,

	-- direct hit, no fire... just plenty of pain
	hit_player = function(self, player)
		player:punch(self.object, 1.0, {
			full_punch_interval = 1.0,
			damage_groups = {fleshy = 100},
		}, nil)
	end,

	hit_mob = function(self, player)
		player:punch(self.object, 1.0, {
			full_punch_interval = 1.0,
			damage_groups = {fleshy = 100},
		}, nil)
	end,

	-- node hit
	hit_node = function(self, pos, node)
		mobs:boom(self, pos, 10)
	end
})

-- support for MT game translation.
local S = minetest.get_translator("mobs_monster")

-- eye boss by nininik

mobs:register_mob("mobs_monster:eyeboss", {
	type = "monster",
	passive = false,
	damage = 4,
	attack_type = "shoot",
--	dogshoot_switch = 1,
--	dogshoot_count_max = 30, -- nah bro
--	dogshoot_count2_max = 1, -- bruh  
--	reach = 40,
	shoot_interval = 3,
	arrow = "mobs_monster:eyeball",
	shoot_offset = 0.1,
	hp_min = 50,
	hp_max = 70,
	armor = 60,
	knock_back = true,
	collisionbox = {-0.7, -1, -0.7, 0.7, 1.6, 0.7},
	visual = "upright_sprite",
	textures = {
		"mobs_flat_eyeboss.png",
	},
	visual_size = {x=2, y=2},
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_spider",
		shoot_attack = "tnt_ignite",
	},
	walk_velocity = 4,
	run_velocity = 9,
	jump = true,
	view_range = 50,
	drops = {
		{name = "c", chance = 0.5, min = 0, max = 1},
	},
	water_damage = 0,
	lava_damage = 0,
	light_damage = 0,
	fear_height = 8,
})


mobs:spawn({
	name = "mobs_monster:eyeboss",
	nodes = {"default:placeholder"},
	neighbors = {"default:mese", "default:stone_with_mese", "air", "default:mossycobble"},
	chance = 1,
	active_object_count = 1,
})


mobs:register_egg("mobs_monster:eyeboss", ("eye boss"), "mobs_flat_eyeboss.png", 1)


-- Register the crafting recipe for ugx:tree_fence
minetest.register_craft({
    output = 'ugx:tree_fence',
    recipe = {
        {'group:tree', '', 'group:tree'},
        {'group:tree', 'group:stick', 'group:tree'},
        {'', 'group:stick', ''}
    }
})

-- Register the crafting recipe for ugx:fan_block
minetest.register_craft({
    output = 'ugx:fan_block',
    recipe = {
        {'default:steel_ingot', '', 'default:steel_ingot'},
        {'group:stick', 'basetools:metal_pipe_tool', 'group:stick'},
        {'group:stick', '', 'group:stick'}
    }
})


-- fireball (weapon)
mobs:register_arrow("mobs_monster:eyeball", {
	visual = "sprite",
	visual_size = {x = 1, y = 1},
	textures = {"eyeball.png"},
	velocity = 6,
	tail = 1,
	tail_texture = "horror_portal.png",
	tail_size = 10,
	glow = 8,
	expire = 0.5,

	-- direct hit, no fire... just plenty of pain
	hit_player = function(self, player)
		player:punch(self.object, 1.0, {
			full_punch_interval = 1.0,
			damage_groups = {fleshy = 5},
		}, nil)
	end,

	hit_mob = function(self, player)
		player:punch(self.object, 1.0, {
			full_punch_interval = 1.0,
			damage_groups = {fleshy = 10},
		}, nil)
	end,

	-- node hit
	hit_node = function(self, pos, node)
		mobs:boom(self, pos, 3)
	end
})

-- support for MT game translation.


-- starcursed_mass by nininik

mobs:register_mob("mobs_monster:starcursed_mass", {
	type = "monster",
	passive = false,
	damage = 3,
	attack_type = "shoot",
	shoot_interval = 2,
  use_texture_alpha = true,
	arrow = "mobs_monster:arrow",
	shoot_offset = 0.1,
	hp_min = 20,
	hp_max = 50,
	armor = 50,
	knock_back = true,
	collisionbox = {-0.7, -1, -0.7, 0.7, 1.6, 0.7},
	visual = "upright_sprite",
	textures = {
		"starcursed_mass.png",
	},
	visual_size = {x=2, y=2},
	makes_footstep_sound = true,
	sounds = {
		random = "soundstuff_sinus",
		shoot_attack = "p",
	},
	walk_velocity = 5,
	run_velocity = 11,
	jump = true,
  jump_height = 16,
	view_range = 100,
	drops = {
		{name = "default:diamond", chance = 0.5, min = 0, max = 7},
	},
	water_damage = 0,
	lava_damage = 0,
	light_damage = 0,
	fear_height = 3,
})


mobs:spawn({
	name = "mobs_monster:starcursed_mass",
	nodes = {"default:stone_with_diamond", "default:stone_with_mese", "default:stone_with_mese"},
	neighbors = {"default:stone", "default:stone_with_mese", "air", "default:stone_with_diamond"},
	chance = 111,
	active_object_count = 1,
})


mobs:register_egg("mobs_monster:starcursed_mass", ("Starcursed Mass"), "starcursed_mass.png", 1)


-- fireball (weapon)
mobs:register_arrow("mobs_monster:arrow", {
	visual = "sprite",
	visual_size = {x = 1, y = 1},
	textures = {"starcursed_mass.png"},
	velocity = 11,
	tail = 1,
	tail_texture = "starcursed_mass.png",
	tail_size = 1,
	glow = 8,
	expire = 1,

	-- direct hit, no fire... just plenty of pain
	hit_player = function(self, player)
		player:punch(self.object, 1.0, {
			full_punch_interval = 1.0,
			damage_groups = {fleshy = 5},
		}, nil)
	end,

	hit_mob = function(self, player)
		player:punch(self.object, 1.0, {
			full_punch_interval = 1.0,
			damage_groups = {fleshy = 10},
		}, nil)
	end,

	-- node hit
	hit_node = function(self, pos, node)
		mobs:boom(self, pos, 1)
	end
})



mobs:spawn({
	name = "slimes:lavabig",
	nodes = {"default:lava_source"},
	chance = 500,
	active_object_count = 4,
	max_height = -10,
})

mobs:spawn({
	name = "slimes:lavamedium",
	nodes = {"caverealms:constant_flame"},
	chance = 100,
	active_object_count = 4,
	max_height = -10,
})

-- Mese Monster

mobs:spawn({
	name = "slimes:greenbig",
	nodes = {"default:jungletree"},
	min_light = 0,
	chance = 99,
	active_object_count = 2,
	max_height = 200,
})

-- slimy

mobs:spawn({
	name = "slimes:greenbig",
	nodes = {"default:junglegrass"},
	min_light = 0,
	chance = 99,
	max_height = 100,
})

mobs:register_mob("mobs_monster:crane_monster", {
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	pathfinding = true,
	reach = 1,
	damage = 2,
  use_texture_alpha = true,
	hp_min = 12,
	hp_max = 32,
	armor = 100,
  blood_amount = 666,
  blood_texture = "default_steel_ingot.png",
	collisionbox = {-0.4, -1, -0.4, 0.4, 0.9, 0.4},
	visual = "upright_sprite",
	visual_size = {x=2, y=4.1},
	textures = {
		"crane_monster.png",
	},
	makes_footstep_sound = true,
	sounds = {
		random = "pipe",
	},
	walk_velocity = 0.5,
	run_velocity = 9,
	view_range = 100,
	jump = true,
	drops = {
		{name = "default:steelblock", chance = 0.5, min = 0, max = 1},
	},
	water_damage = 0,
	lava_damage = 0,
	light_damage = 0,
	fear_height = 50,
	replace_rate = 9,
	replace_what = {"default:torch"},
	replace_with = "ugx:waste",
	replace_offset = 0,
	floats = 1,
})

mobs:spawn({
	name = "mobs_monster:crane_monster",
	nodes = {"oresplus:stone_with_emerald", "default:stone_with_diamond", "default:stone_with_mese"},
	neighbors = {"air", "default:stone"},
	chance = 100,
	active_object_count = 1,
})

mobs:spawn({
	name = "mobs_monster:crane_monster",
	nodes = {"default:stone"},
	chance = 10000,
	active_object_count = 1,
	max_height = -1
})

mobs:spawn({
	name = "mobs_monster:starcursed_mass",
	nodes = {"default:stone"},
	chance = 11111,
	active_object_count = 1,
	max_height = -1
})


mobs:register_egg("mobs_monster:crane_monster", ("CRANE MONSTER"), "crane_monster.png", 1)

mobs:register_mob(":aerozoic", {
	type = "npc",
  attacks_monsters = true,
  attack_npcs = false,
	passive = false,
  jump_height = 15.55,
	attack_type = "dogfight",
  blood_amount = 222,
  blood_texture = "heart.png",
	pathfinding = true,
	reach = 2,
	damage = 777,
  show_on_minimap = true,
  nametag = "aerozoic",
	hp_min = 65535,
	hp_max = 65535,
	armor = 2,
	collisionbox = {-0.4, -1, -0.4, 0.4, 0.9, 0.4},
	visual = "upright_sprite",
	visual_size = {x=1, y=2},
	textures = {
		"aerozoic.png",
		"aerozoic_back.png",
	},
	makes_footstep_sound = true,
	sounds = {
		random = "ugx",
	},
	walk_velocity = 5,
	run_velocity = 10,
	view_range = 111,
	jump = true,
	drops = {
		{name = "testnodes:aerozic", chance = 1, min = 1, max = 1},
	},
	water_damage = 0,
	lava_damage = 0,
	light_damage = 0,
	fear_height = 0,
	replace_rate = 5,
	replace_what = {"default:stone"},
	replace_with = "default:stone_with_iron",
	replace_offset = -1,
	floats = 1,
})

mobs:register_mob("mobs_monster:tree_form", {
	type = "npc",
  attacks_monsters = true,
  attacks_npcs = false,
	passive = true,
  jump_height = 5.55,
	attack_type = "dogfight",
  blood_amount = 100,
  blood_texture = "default_leaves.png",
	pathfinding = true,
	reach = 2,
	damage = 7,
  show_on_minimap = true,
	hp_min = 66,
	hp_max = 69,
	armor = 10,
	collisionbox = {-0.4, -1, -0.4, 0.4, 0.9, 0.4},
	visual = "upright_sprite",
	visual_size = {x=1.2, y=1.2},
	textures = {
		"tree_form.png",
	},
	makes_footstep_sound = true,
	sounds = {
		random = "wind",
	},
	walk_velocity = 5,
	run_velocity = 8,
	view_range = 50,
	jump = true,
	drops = {
		{name = "default:sapling", chance = 1, min = 1, max = 1},
	},
	water_damage = 0,
	lava_damage = 0,
	light_damage = 0,
	fear_height = 0,
	replace_rate = 5,
	replace_what = {"default:dirt_with_grass"},
	replace_with = "default:dirt_with_grass_footsteps",
	replace_offset = -1,
   follow = {"default:leaves"},
	floats = 1,
  	on_rightclick = function(self, clicker)
		if mobs:feed_tame(self, clicker, 8, true, true) then return end
		if mobs:protect(self, clicker) then return end
		if mobs:capture_mob(self, clicker, 0, 5, 50, false, nil) then return end
	end,
})


mobs:spawn({
	name = "mobs_monster:tree_form",
	nodes = {"default:leaves"},
	chance = 5555,
	active_object_count = 1,
})


minetest.register_node(":ugx:softyellowglass", {
	description = ("soft yellow glass"),
	drawtype = "glasslike",
  sunlight_propagates = true,
  use_texture_alpha = true,
  paramtype = "light",
	tiles = { "softyellowglass.png" },
groups = { cracky = 1, not_cuttable=1},
})

mobs:spawn({
	name = "mobs_monster:sphere",
	nodes = {"default:leaves"},
	chance = 9999,
	active_object_count = 1,
})




mobs:register_mob("mobs_monster:the_dark", {
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	pathfinding = true,
	reach = 2,
	damage = 5,
	hp_min = 20,
	hp_max = 100,
	armor = 100,
	collisionbox = {-0.4, -1, -0.4, 0.4, 0.9, 0.4},
	visual = "mesh",
	mesh = "mobs_stone_monster.b3d",
	textures = {
		{"darkmonster2.png"},
		{"darkmonster.png"} -- by nininik
	},
	makes_footstep_sound = true,
	sounds = {
		random = "dark",
	},
	walk_velocity = 2,
	run_velocity = 19,
	jump_height = 8,
	stepheight = 9,
	floats = 0,
	view_range = 66,
	drops = {
		{name = "util_commands:apple_iron", chance = 2, min = 1, max = 2},
		{name = "default:dirt_with_grass_footsteps", chance = 3, min = 1, max = 2},
		{name = "default:diamond", chance = 4, min = 1, max = 7}
	},
	water_damage = 0,
	lava_damage = 0,
	light_damage = 0,
	animation = {
		speed_normal = 15,
		speed_run = 15,
		stand_start = 0,
		stand_end = 14,
		walk_start = 15,
		walk_end = 38,
		run_start = 40,
		run_end = 63,
		punch_start = 40,
		punch_end = 63,
	}
})

mobs:spawn({
	name = "mobs_monster:the_dark",
	nodes = {"default:stone"},
	chance = 19321,
	active_object_count = 1,
	max_height = -1
})


minetest.register_node(":testnodes:RLR", {
	description = ("RED LEAGUE OF RECLAMATION flag").."\n"..
		("R.L.R."),
	drawtype = "signlike",
	paramtype = "light",
  on_blast = function() end,
	paramtype2 = "wallmounted",
	tiles = { "rlr.png" },


	walkable = false,
	groups = { dig_immediate = 3 },
	sunlight_propagates = true,
})

minetest.register_node(":testnodes:RLR_double", {
	description = ("RED LEAGUE OF RECLAMATION flag").."\n"..
		("R.L.R."),
	drawtype = "signlike",
  visual_scale = 2.2,
	paramtype = "light",
  on_blast = function() end,
	paramtype2 = "wallmounted",
	tiles = { "rlr.png" },


	walkable = false,
	groups = { dig_immediate = 3 },
	sunlight_propagates = true,
})

minetest.register_node(":testnodes:RLR_big", {
	description = ("RED LEAGUE OF RECLAMATION flag").."\n"..
		("R.L.R."),
	drawtype = "signlike",
	paramtype = "light",
  on_blast = function() end,
	paramtype2 = "wallmounted",
	tiles = { "rlr.png" },


	walkable = false,
	groups = { dig_immediate = 3 },
  visual_scale = 15,
	sunlight_propagates = true,
})

minetest.register_node(":testnodes:RLR_GIANT", {
	description = ("RED LEAGUE OF RECLAMATION flag").."\n"..
		("R.L.R."),
	drawtype = "signlike",
	paramtype = "light",
  on_blast = function() end,
  visual_scale = 30,
	paramtype2 = "wallmounted",
	tiles = { "rlr.png" },


	walkable = false,
	groups = { dig_immediate = 3 },
	sunlight_propagates = true,
})

minetest.register_node(":testnodes:RLR_tiny", {
	description = ("RED LEAGUE OF RECLAMATION flag").."\n"..
		("R.L.R."),
	drawtype = "signlike",
	paramtype = "light",
  visual_scale = 0.5,
	paramtype2 = "wallmounted",
	tiles = { "rlr.png" },


	walkable = false,
	groups = { dig_immediate = 3 },
	sunlight_propagates = true,
})


-- Register lava ore
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "mts_liquids:lava_still",
    wherein        = {"default:stone", "default:sandstone", "default:desert_stone"},
    clust_scarcity = 29 * 29 * 29,
    clust_num_ores = 2,
    clust_size     = 2,
    y_max          = 10,
    y_min          = -30900,
})
-- Register lava ore
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:noclip_glass",
    wherein        = {"default:stone", "default:sandstone", "default:desert_stone"},
    clust_scarcity = 27 * 28 * 29,
    clust_num_ores = 2,
    clust_size     = 2,
    y_max          = 10,
    y_min          = -30900,
})

-- Register magma ore
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "util_commands:pitch_source",
    wherein        = {"default:stone", "default:sandstone", "default:desert_stone"},
    clust_scarcity = 39 * 49 * 69,
    clust_num_ores = 2,
    clust_size     = 2,
    y_max          = 10,
    y_min          = -30900,
})

-- Register plasmatic ore
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "specialblocks:liquid_pain_source",
    wherein        = {"default:stone", "default:sandstone", "default:desert_stone"},
    clust_scarcity = 33 * 33 * 33,
    clust_num_ores = 1,
    clust_size     = 1,
    y_max          = 1,
    y_min          = -30900,
})

-- Register cryolava ore
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "ugx:corium",
    wherein        = {"default:stone", "default:sandstone", "default:desert_stone"},
    clust_scarcity = 40 * 40 * 40,
    clust_num_ores = 1,
    clust_size     = 1,
    y_max          = 10,
    y_min          = -30900,
})

-- Register light ore
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:placeholder",
    wherein        = {"default:stone", "default:sandstone", "default:desert_stone"},
    clust_scarcity = 69 * 69 * 60,
    clust_num_ores = 1,
    clust_size     = 1,
    y_max          = 10,
    y_min          = -30900,
})

-- Register magma ore
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "mts_liquids:magma_still",
    wherein        = {"default:stone", "default:sandstone", "default:desert_stone"},
    clust_scarcity = 29 * 29 * 29,
    clust_num_ores = 1,
    clust_size     = 1,
    y_max          = 10,
    y_min          = -30900,
})

-- Register plasmatic ore
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "mts_liquids:plasmatic_still",
    wherein        = {"default:stone", "default:sandstone", "default:desert_stone"},
    clust_scarcity = 33 * 33 * 33,
    clust_num_ores = 1,
    clust_size     = 1,
    y_max          = 1,
    y_min          = -30900,
})

-- Register cryolava ore
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "caverealms:cryolava_source",
    wherein        = {"default:stone", "default:sandstone", "default:desert_stone"},
    clust_scarcity = 40 * 40 * 40,
    clust_num_ores = 1,
    clust_size     = 1,
    y_max          = 10,
    y_min          = -30900,
})

-- Register light ore
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "testnodes:light14",
    wherein        = {"default:stone", "default:sandstone", "default:desert_stone"},
    clust_scarcity = 29 * 29 * 29,
    clust_num_ores = 1,
    clust_size     = 1,
    y_max          = 10,
    y_min          = -30900,
})


function find_reactor(pos, radius)
	for dx = -radius, radius do
		for dy = -radius, radius do
			for dz = -radius, radius do
				local node_pos = vector.add(pos, {x = dx, y = dy, z = dz})
				local node = minetest.get_node(node_pos)
				if node.name == "ugx:nuclear_reactor" then
					return node_pos
				end
			end
		end
	end
	return nil
end

minetest.register_node("mobs_monster:nuclear_fueler", {
	description = "Nuclear Reactor Fueler",
	tiles = {"rerere.png"},
	drawtype = "mesh",
  visual_scale = 2,
	mesh = "testnodes_marble_glass.obj", -- Replace with your mesh file path
	groups = {cracky = 2, not_in_creative_inventory=1},
	
	on_construct = function(pos)
		minetest.after(10, function()
			local reactor_pos = find_reactor(pos, 3)
			if not reactor_pos then
				minetest.chat_send_all("Nuclear reactor WILL EXPLODE!!! IN 3 SECONDS!!!")
				minetest.set_node(pos, {name = "ugx:testwarn"}) -- Remove the fueler
				minetest.sound_play("24", {pos = pos, gain = 1.0, max_hear_distance = 10000})
				minetest.after(1, function() 
					minetest.set_node(pos, {name = "ugx:nuclear_reactor"}) -- Ignite the fueler
					minetest.after(1, function() 
						minetest.set_node(pos, {name = "ugx:corium"}) -- Remove the flame
						tnt.boom(pos, {damage_radius = 50, radius = 50, ignore_protection = true, explode_center = true})
						replace_air_with_waste(pos, 50)
						remove_leaves(pos, 50)
					end)
				end)
			end
		end)
	end
})

function replace_air_with_waste(center_pos, radius)
	local corium_center = vector.add(center_pos, {x = 25, y = 0, z = 25})
	for dx = -radius, radius do
		for dy = -radius, radius do
			for dz = -radius, radius do
				local pos = vector.add(center_pos, {x = dx, y = dy, z = dz})
				if vector.distance(pos, corium_center) > 10 then -- Ensure corium center is not affected
					local node = minetest.get_node(pos)
					if node.name == "air" then
						minetest.set_node(pos, {name = "ugx:waste"})
					end
				end
			end
		end
	end
end

function remove_leaves(center_pos, radius)
	for dx = -radius, radius do
		for dy = -radius, radius do
			for dz = -radius, radius do
				local pos = vector.add(center_pos, {x = dx, y = dy, z = dz})
				local node = minetest.get_node(pos)
				if minetest.get_item_group(node.name, "leaves") > 0 then
					minetest.set_node(pos, {name = "ugx:corium"})
				end
			end
		end
	end
end


print ("[MOD] Mobs Monster loaded")
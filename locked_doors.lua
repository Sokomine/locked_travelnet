-- Doors that are especially useful for travelnet elevators but can also be used in other situations.
-- All doors (not only these here) in front of a travelnet or elevator are opened automaticly when a player arrives
-- and are closed when a player departs from the travelnet or elevator.
-- Autor: Sokomine

locked_travelnet_doors_transform = function( pos, node, puncher, transform_into )

   if( not( locks:lock_allow_use( pos, puncher ))) then
      minetest.chat_send_player( puncher:get_player_name(), "This door is locked. It can only be opened by its owner or people with a key that fits.");
      return;
   end

   local olddata = locks:get_lockdata( pos );

   minetest.add_node(pos, {name = transform_into, param2 = node.param2})
   locks:set_lockdata( pos, olddata );
end



minetest.register_node("locked_travelnet:elevator_door_steel_open", {
		description = "elevator door (open)",
		drawtype = "nodebox",
                -- top, bottom, side1, side2, inner, outer
		tiles = {"default_stone.png"},
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = true,
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,not_in_creative_inventory=1},
                -- larger than one node but slightly smaller than a half node so that wallmounted torches pose no problem
		node_box = {
			type = "fixed",
			fixed = {
				{-0.90, -0.5,  0.4, -0.49, 1.5,  0.5},
				{ 0.49, -0.5,  0.4,  0.9, 1.5,  0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.9, -0.5,  0.4,  0.9, 1.5,  0.5},
			},
		},
		drop = "locked_travelnet:elevator_door_steel_closed",
                on_rightclick = function(pos, node, puncher)

                    locked_travelnet_doors_transform( pos, node, puncher, "locked_travelnet:elevator_door_steel_closed" );
                end,

                on_construct = function(pos)
                        locks:lock_init( pos,
                               "size[8,2]"..
                               "field[0.3,0.6;6,0.7;locks_sent_lock_command;Locked door. Type /help for help:;]"..
                               "button_exit[6.3,1.2;1.7,0.7;locks_sent_input;Proceed]" );
                end,

                after_place_node  = function(pos, placer, itemstack)
                   locks:lock_set_owner( pos, placer, "Shared locked door" );
                end,

                on_receive_fields = function(pos, formname, fields, sender)
                        locks:lock_handle_input( pos, formname, fields, sender );
                end,

                can_dig = function(pos,player)
                        return locks:lock_allow_dig( pos, player );
                end,
})

minetest.register_node("locked_travelnet:elevator_door_steel_closed", {
		description = "elevator door (closed)",
		drawtype = "nodebox",
                -- top, bottom, side1, side2, inner, outer
		tiles = {"default_stone.png"},
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = true,
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5,  -0.5,  0.4, -0.01, 1.5,  0.5},
				{ 0.01, -0.5,  0.4,  0.5,  1.5,  0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5,  0.4,  0.5, 1.5,  0.5},
			},
		},
                on_rightclick = function(pos, node, puncher)
                    locked_travelnet_doors_transform( pos, node, puncher, "locked_travelnet:elevator_door_steel_open" );
                end,
                on_construct = function(pos)
                        locks:lock_init( pos,
                               "size[8,2]"..
                               "field[0.3,0.6;6,0.7;locks_sent_lock_command;Locked door. Type /help for help:;]"..
                               "button_exit[6.3,1.2;1.7,0.7;locks_sent_input;Proceed]" );
                end,

                after_place_node  = function(pos, placer, itemstack)
                   locks:lock_set_owner( pos, placer, "Shared locked door" );
                end,

                on_receive_fields = function(pos, formname, fields, sender)
                        locks:lock_handle_input( pos, formname, fields, sender );
                end,

                can_dig = function(pos,player)
                        return locks:lock_allow_dig( pos, player );
                end,
})




minetest.register_node("locked_travelnet:elevator_door_glass_open", {
		description = "elevator door (open)",
		drawtype = "nodebox",
                -- top, bottom, side1, side2, inner, outer
		tiles = {"travelnet_elevator_door_glass.png"},
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = true,
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,not_in_creative_inventory=1},
                -- larger than one node but slightly smaller than a half node so that wallmounted torches pose no problem
		node_box = {
			type = "fixed",
			fixed = {
				{-0.99, -0.5,  0.4, -0.49, 1.5,  0.5},
				{ 0.49, -0.5,  0.4,  0.99, 1.5,  0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.9, -0.5,  0.4,  0.9, 1.5,  0.5},
			},
		},
		drop = "locked_travelnet:elevator_door_glass_closed",
                on_rightclick = function(pos, node, puncher)
                    locked_travelnet_doors_transform( pos, node, puncher, "locked_travelnet:elevator_door_glass_closed" );
                end,
                on_construct = function(pos)
                        locks:lock_init( pos,
                               "size[8,2]"..
                               "field[0.3,0.6;6,0.7;locks_sent_lock_command;Locked door. Type /help for help:;]"..
                               "button_exit[6.3,1.2;1.7,0.7;locks_sent_input;Proceed]" );
                end,

                after_place_node  = function(pos, placer, itemstack)
                   locks:lock_set_owner( pos, placer, "Shared locked door" );
                end,

                on_receive_fields = function(pos, formname, fields, sender)
                        locks:lock_handle_input( pos, formname, fields, sender );
                end,

                can_dig = function(pos,player)
                        return locks:lock_allow_dig( pos, player );
                end,
})

minetest.register_node("locked_travelnet:elevator_door_glass_closed", {
		description = "elevator door (closed)",
		drawtype = "nodebox",
                -- top, bottom, side1, side2, inner, outer
		tiles = {"travelnet_elevator_door_glass.png"},
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = true,
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5,  -0.5,  0.4, -0.01, 1.5,  0.5},
				{ 0.01, -0.5,  0.4,  0.5,  1.5,  0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5,  0.4,  0.5, 1.5,  0.5},
			},
		},
                on_rightclick = function(pos, node, puncher)
                    locked_travelnet_doors_transform( pos, node, puncher, "locked_travelnet:elevator_door_glass_open" );
                end,
                on_construct = function(pos)
                        locks:lock_init( pos,
                               "size[8,2]"..
                               "field[0.3,0.6;6,0.7;locks_sent_lock_command;Locked door. Type /help for help:;]"..
                               "button_exit[6.3,1.2;1.7,0.7;locks_sent_input;Proceed]" );
                end,

                after_place_node  = function(pos, placer, itemstack)
                   locks:lock_set_owner( pos, placer, "Shared locked door" );
                end,

                on_receive_fields = function(pos, formname, fields, sender)
                        locks:lock_handle_input( pos, formname, fields, sender );
                end,

                can_dig = function(pos,player)
                        return locks:lock_allow_dig( pos, player );
                end,
})

minetest.register_craft({
	        output = "locked_travelnet:elevator_door_glass_closed",
	        recipe = {{'travelnet:elevator_door_glass_closed','locks:lock'},
		        }
	})

minetest.register_craft({
	        output = "locked_travelnet:elevator_door_steel_closed",
	        recipe = {
		        {'travelnet:elevator_door_steel_closed','locks:lock'},
		        }
	})


print( "[Mod] locked_travelnet: loading locked_travelnet:elevator_door_xxx_closed (steel and glass)");


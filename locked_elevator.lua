-- This version of the travelnet box allows to move up or down only.
-- The network name is determined automaticly from the position (x/z coordinates).
-- Autor: Sokomine

minetest.register_node("locked_travelnet:elevator", {
    description = "Shared locked elevator",

    drawtype = "nodebox",
    sunlight_propagates = true,
    paramtype = 'light',
    paramtype2 = "facedir",

    selection_box = {
                type = "fixed",
                fixed = { -0.5, -0.5, -0.5, 0.5, 1.5, 0.5 }
    },

    node_box = {
	    type = "fixed",
	    fixed = {

                { 0.48, -0.5,-0.5,  0.5,  0.5, 0.5},
                {-0.5 , -0.5, 0.48, 0.48, 0.5, 0.5}, 
                {-0.5,  -0.5,-0.5 ,-0.48, 0.5, 0.5},

                --groundplate to stand on
                { -0.5,-0.5,-0.5,0.5,-0.48, 0.5}, 
            },
    },
    

    tiles = {
          
             "travelnet_elevator_inside_floor.png",  -- view from top
             "default_stone.png",  -- view from bottom
	     "travelnet_elevator_inside_bottom.png", -- left side
	     "travelnet_elevator_inside_bottom.png", -- right side
	     "travelnet_elevator_inside_bottom.png",   -- front view
	     "travelnet_elevator_inside_bottom.png",  -- backward view
             },
    inventory_image = "travelnet_elevator_inv.png",
    wield_image     = "travelnet_elevator_wield.png",

    groups = {}, --cracky=1,choppy=1,snappy=1},


    light_source = 10,

    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        --- prepare the lock of the travelnet
        locks:lock_init( pos, 
                            "size[12,10]"..
                            "field[0.3,5.6;6,0.7;station_name;Name of this station:;]"..
--                            "button_exit[6.3,6.2;1.7,0.7;station_set;Store]".. 
			    "button_exit[8.0,0.0;2.2,0.7;station_dig;Remove station]"..
                            "field[0.3,3.0;6,0.7;locks_sent_lock_command;Locked travelnet. Type /help for help:;]"..
                            "button_exit[6.3,3.2;1.7,0.7;locks_sent_input;Store]" );
    end,

    after_place_node  = function(pos, placer, itemstack)
	local meta = minetest.get_meta(pos);
        meta:set_string("infotext",       "Elevator (unconfigured)");
        meta:set_string("station_name",   "");
        meta:set_string("station_network","");
        meta:set_string("owner",          placer:get_player_name() );
        -- request initinal data

       local p = {x=pos.x, y=pos.y+1, z=pos.z}
       local p2 = minetest.dir_to_facedir(placer:get_look_dir())
       minetest.add_node(p, {name="locked_travelnet:elevator_top", paramtype2="facedir", param2=p2})

       locks:lock_set_owner( pos, placer, "Shared locked elevator" );
    end,
    
    on_receive_fields = function(pos, formname, fields, sender)

 	 	          -- abort if no input has been sent
		          if( fields.quit ) then
		              return;
                          end

                          -- if the user already has the right to use this and did input text
                          if(      (not(fields.locks_sent_lock_command) 
                                     or fields.locks_sent_lock_command=="")
                              and locks:lock_allow_use( pos, sender )) then

                              travelnet.on_receive_fields( pos, formname, fields, sender );
                  
                          -- a command for the lock?
                          else
                             locks:lock_handle_input( pos, formname, fields, sender );
                          end
    end,

    on_punch          = function(pos, node, puncher)
                          travelnet.update_formspec(pos, puncher:get_player_name())
    end,

    can_dig = function( pos, player )
                          if( not(locks:lock_allow_dig( pos, player ))) then
                             return false;
                          end
                          return travelnet.can_dig( pos, player, 'elevator' )
    end,

    after_dig_node = function(pos, oldnode, oldmetadata, digger)
			  travelnet.remove_box( pos, oldnode, oldmetadata, digger )
    end,

    -- taken from VanessaEs homedecor fridge
    on_place = function(itemstack, placer, pointed_thing)
       local pos  = pointed_thing.above;
       local node = minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z});
       -- leftover elevator_top nodes can be removed by placing a new elevator underneath
       if( node ~= nil and node.name ~= "air" and node.name ~= 'locked_travelnet:elevator_top') then
          minetest.chat_send_player( placer:get_player_name(), 'Not enough vertical space to place the travelnet box!' )
          return;
       end
       return minetest.item_place(itemstack, placer, pointed_thing);
    end,

    on_destruct = function(pos)
            local p = {x=pos.x, y=pos.y+1, z=pos.z}
	    minetest.remove_node(p)
    end
})

minetest.register_node("locked_travelnet:elevator_top", {
    description = "Elevator Top",

    drawtype = "nodebox",
    sunlight_propagates = true,
    paramtype = 'light',
    paramtype2 = "facedir",

    selection_box = {
                type = "fixed",
                fixed = { 0, 0, 0,  0, 0, 0 }
--                fixed = { -0.5, -0.5, -0.5,  0.5, 0.5, 0.5 }
    },

    node_box = {
	    type = "fixed",
	    fixed = {

                { 0.48, -0.5,-0.5,  0.5,  0.5, 0.5},
                {-0.5 , -0.5, 0.48, 0.48, 0.5, 0.5}, 
                {-0.5,  -0.5,-0.5 ,-0.48, 0.5, 0.5},

                --top ceiling
                { -0.5, 0.48,-0.5,0.5, 0.5, 0.5}, 
            },
    },
    

    tiles = {
          
             "default_stone.png",  -- view from top
             "travelnet_elevator_inside_ceiling.png",  -- view from bottom
	     "travelnet_elevator_inside_top_control.png", -- left side
	     "travelnet_elevator_inside_top.png", -- right side
	     "travelnet_elevator_inside_top.png",   -- front view
	     "travelnet_elevator_inside_top.png",  -- backward view
             },
    inventory_image = "travelnet_elevator_inv.png",
    wield_image     = "travelnet_elevator_wield.png",

    light_source = 10,

    groups = {}, --cracky=1,choppy=1,snappy=1,not_in_creative_inventory=1},
})



minetest.register_craft({
   output = 'locked_travelnet:elevator',
   recipe = {
      { 'travelnet:elevator', 'locks:lock' },
   },
})

print( "[Mod] locked_travelnet: loading locked_travelnet:elevator");

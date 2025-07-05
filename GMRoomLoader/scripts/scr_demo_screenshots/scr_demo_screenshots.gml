
function DemoScreenshots() : DemoPar("Screenshots") constructor {
	// Shared:
	static init = function() {
		RoomLoader.data_init_tag(tag);
		take_random();
		
		// Interface:
		DEMOS.info = dbg_section("Info");
		dbg_text("This demo shows an example of taking room screenshots with adjustable\nparameters, pulling rooms from the Base demo.");
		dbg_text_separator("Shortcuts", 1);
		dbg_text("- [PRESS 1] to take a screenshot of a random room.");
		dbg_text("- [HOLD SHIFT+1] to take a screenshot of a random room every frame.");
		
		DEMOS.controls = dbg_section("Controls");
		dbg_button("Take Random", function() {
			take_random();
		});
		dbg_same_line();
		dbg_button("Retake", function() {
			retake();
		});
		dbg_same_line();
		dbg_button("Export", function() {
			var _prefix = $"{game_project_name} Room Screenshot";
			var _path = get_save_filename_ext($"PNG Image File|*.png", $"{_prefix}.png", "", window_get_caption());
			if (_path == "") return;
			
			sprite_save(sprite, 0, _path);
		});
		dbg_slider(ref_create(self, "scale"), 0, 2, "Scale", 0.05);
		
		origin.init_dbg();
		flags.init_dbg();
	};
	static update = function() {
		var _checker = (keyboard_check(vk_shift) ? keyboard_check : keyboard_check_pressed);
		if (_checker(ord("1"))) {
			take_random();
		}
	};
	static draw = function() {
		var _x = DEMOS.xcenter;
		var _y = DEMOS.ycenter;
		draw_sprite(sprite, 0, _x, _y);
		demo_draw_frame(rm, _x, _y, origin);
		if (scale != 1) {
			demo_draw_frame(rm, _x, _y, origin, scale, c_orange);
		}
	};
	static cleanup = function() {
		RoomLoader.data_remove_tag(tag);
		clear();
	};
	
	// Custom:
	tag = "base_rooms";
	rooms = tag_get_asset_ids(tag, asset_room);
	rm = undefined;
	sprite = undefined;
	scale = 1;
	origin = new DemoModuleOrigin();
	flags = new DemoModuleFlags();
	
	static take_random = function() {
		var _prev = rm;
		do {
			rm = script_execute_ext(choose, rooms);
		} until (rm != _prev);
		retake();
	};
	static retake = function() {
		clear();
		sprite = RoomLoader.take_screenshot(rm, origin.x, origin.y, scale, flags.get());
	};
	static clear = function() {
		if (sprite == undefined) return;
		sprite_delete(sprite);
		sprite = undefined;
	};
}

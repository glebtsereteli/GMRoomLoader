
function DemoScreenshots() : DemoPar("Screenshots") constructor {
	// Shared:
	static Init = function() {
		RoomLoader.DataInitTag(tag);
		ShuffleRoom();
		
		// Interface:
		dbg_section("Info");
		dbg_text("This demo shows an example of taking room screenshots with adjustable\nparameters, pulling rooms from the Base demo.");
		dbg_text_separator("Shortcuts", 1);
		dbg_text("- [PRESS 1] to take a screenshot of a random room.");
		dbg_text("- [HOLD SHIFT+1] to take a screenshot of a random room every frame.");
		
		dbg_section("Controls");
		dbg_button("Take Random", function() {
			TakeRandom();
		});
		dbg_same_line();
		dbg_button("Take", function() {
			Take();
		});
		dbg_same_line();
		dbg_button("Export", function() {
			var _prefix = $"{game_project_name} Room Screenshot";
			var _path = get_save_filename_ext($"PNG Image File|*.png", $"{_prefix}.png", "", window_get_caption());
			if (_path == "") return;
			
			sprite_save(sprite, 0, _path);
		});
		dbg_slider(ref_create(self, "left"), 0, 1, "Left %", 0.05);
		dbg_slider(ref_create(self, "top"), 0, 1, "Top %", 0.05);
		dbg_slider(ref_create(self, "w"), 0.1, 1, "Width %", 0.05);
		dbg_slider(ref_create(self, "h"), 0.1, 1, "Height %", 0.05);
		dbg_slider(ref_create(self, "scale"), 0.1, 2, "Scale", 0.05);
		
		origin.InitDbg();
		flags.InitDbg();
		
		// Reloader:
		owner.reloader
		.AddVariables(self, ["left", "top", "w", "h", "scale"])
		.AddModules([origin, flags])
		.OnTrigger(function() {
			Take();
		});
	};
	static Draw = function() {
		var _x1 = DEMOS.xCenter;
		var _y1 = DEMOS.yCenter;
		if (sprite != undefined) {
			draw_sprite(sprite, 0, _x1, _y1);
		}
		
		var _w = RoomLoader.DataGetWidth(rm) * w * scale;
		var _h = RoomLoader.DataGetHeight(rm) * h * scale;
		var _x = floor(_x1 - (_w * origin.x));
		var _y = floor(_y1 - (_h * origin.y));
		
		draw_sprite_stretched(sprDemoFrame, 0, _x, _y, _w * (1 - left), _h * (1 - top));
		draw_sprite(sprDemoCross, 0, _x1, _y1);
	};
	
	static OnUpdate = function() {
		var _checker = (keyboard_check(vk_shift) ? keyboard_check : keyboard_check_pressed);
		if (_checker(ord("1"))) {
			TakeRandom();
		}
	};
	static OnCleanup = function() {
		RoomLoader.DataRemoveTag(tag);
		Clear();
	};
	
	// Custom:
	tag = "BaseRooms";
	rooms = tag_get_asset_ids(tag, asset_room);
	rm = undefined;
	sprite = undefined;
	left = 0;
	top = 0;
	w = 1;
	h = 1;
	scale = 1;
	origin = new DemoModuleOrigin();
	flags = new DemoModuleFlags();
	
	static ShuffleRoom = function() {
		var _prev = rm;
		do {
			rm = script_execute_ext(choose, rooms);
		} until (rm != _prev);
	};
	static TakeRandom = function() {
		ShuffleRoom();
		Take();
	};
	static Take = function() {
		Clear();
		sprite = RoomLoader
		.Origin(origin.x, origin.y)
		.Flags(flags.get())
		.ScreenshotPart(rm, left, top, w, h,,, scale);
	};
	static Clear = function() {
		if (sprite == undefined) return;
		
		sprite_delete(sprite);
		sprite = undefined;
	};
}

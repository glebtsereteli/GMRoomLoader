// feather ignore all

function DemoScreenshots() : DemoPar("Screenshots") constructor {
	// Shared:
	static Init = function() {
		RoomLoader.DataInitTag(tag);
		ShuffleRoom();
		
		// Interface:
		dbg_section("Info");
		dbg_text("This is an example using \"RoomLoader.ScreenshotSprite()\" to take room\nScreenshots, pulling rooms from the Base demo.\n\nUse the controls below to adjust Origin, Flags, Left/Top position,\nWidth/Height of the sprite area to capture (in 0-1 percentages), and the\nfinal sprite Scale.");
		dbg_text_separator("Shortcuts", 1);
		dbg_text("- [PRESS 1] to take a screenshot of a random room.");
		dbg_text("- [HOLD SHIFT+1] to take a screenshot of a random room every frame.");
		
		dbg_section("Controls");
		dbg_button("Take", function() {
			TakeRandom();
		});
		dbg_same_line();
		dbg_button("Export", function() {
			var _prefix = $"{game_project_name} Room Screenshot";
			var _path = get_save_filename_ext($"PNG Image File|*.png", $"{_prefix}.png", "", window_get_caption());
			if (_path == "") return;
			
			sprite_save(sprite, 0, _path);
		});
		dbg_same_line();
		dbg_button("Export All", function() {
			show_message("This is an example of exporting screenshots of all rooms in the project into a ZIP archive. It is not a part of the library. See the \"RoomLoaderExportScreenshots\" script in the demo project for reference.");
			RoomLoaderExportScreenshots();
		});
		
		origin.InitDbg();
		flags.InitDbg();
		
		dbg_text_separator("Area & Scale", 1);
		dbg_slider(ref_create(self, "left"), 0, 1, "Left %", 0.05);
		dbg_slider(ref_create(self, "top"), 0, 1, "Top %", 0.05);
		dbg_slider(ref_create(self, "w"), 0.1, 1, "Width %", 0.05);
		dbg_slider(ref_create(self, "h"), 0.1, 1, "Height %", 0.05);
		dbg_slider(ref_create(self, "scale"), 0.1, 2, "Scale", 0.05);
		
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
		
		var _w = RoomLoader.DataGetWidth(rm) * w * scale;
		var _h = RoomLoader.DataGetHeight(rm) * h * scale;
		if (sprite != undefined) {
			_w = sprite_get_width(sprite);
			_h = sprite_get_height(sprite);
			draw_sprite(sprite, 0, _x1, _y1);
					
			//var _surf = RoomLoader
			//.Origin(origin.x, origin.y)
			//.Flags(flags.Get())
			//.Scale(scale)
			//.Part(left, top, w, h)
			//.ScreenshotSurface(rm);
			//draw_surface(_surf, mouse_x, mouse_y);
			//surface_free(_surf);
			
			//screen = RoomLoader
			//.Origin(origin.x, origin.y)
			//.Flags(flags.Get())
			//.Scale(scale)
			//.Part(left, top, w, h)
			//.ScreenshotBuffer(rm);
		}
		var _x = floor(_x1 - (_w * origin.x));
		var _y = floor(_y1 - (_h * origin.y));
		
		draw_sprite_stretched(sprDemoFrame, 0, _x, _y, _w, _h);
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
			rm = method_call(choose, rooms);
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
		.Flags(flags.Get())
		.Scale(scale)
		.Part(left, top, w, h)
		.ScreenshotSprite(rm);
	};
	static Clear = function() {
		if (sprite == undefined) return;
		
		sprite_delete(sprite);
		sprite = undefined;
	};
}

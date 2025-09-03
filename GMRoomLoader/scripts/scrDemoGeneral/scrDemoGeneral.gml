
function DemoGeneral() : DemoPar("General") constructor {
	// Shared:
	static Init = function() {
		RoomLoader.DataInit(rm);
		
		// Whitelist & Blacklist:
		var _layerNames = RoomLoader.DataGetLayerNames(rm);
		whitelist = array_map(_layerNames, function(_layer) {
			return {
				name: _layer,
				enabled: false,
			};
		});
		blacklist = variable_clone(whitelist);
		
		// Interface:
		dbg_section("Info");
		dbg_text("This demo shows the main \"RoomLoader.Load()\" methods for full\nroom loading. Use the controls below to adjust the loading position,\norigin, Flags, layer Whitelist and Blacklist.");
		dbg_text_separator("Shortcuts", 1);
		dbg_text("- [PRESS 1] to load the room.");
		dbg_text("- [PRESS 2] to clean up the room.");
		
		dbg_section("Controls");
		dbg_button("Load", function() {
			Load();
		});
		dbg_same_line();
		dbg_button("Clean Up", function() {
			Unload();
		});
		
		pos.InitDbg();
		origin.InitDbg();
		DemoDbgTransform("Transform");
		flags.InitDbg();
		
		dbg_text_separator("Layer Whitelist", 1);
		array_foreach(whitelist, function(_layer) {
			dbg_checkbox(ref_create(_layer, "enabled"), _layer.name);
		});
		
		dbg_text_separator("Layer Blacklist", 1);
		array_foreach(blacklist, function(_layer) {
			dbg_checkbox(ref_create(_layer, "enabled"), _layer.name);
		});
	
		// Reloader:
		owner.reloader
		.AddVariables(self, ["xScale", "yScale", "angle"])
		.AddModules([pos, origin, flags])
		.OnTrigger(function() {
			Load();
		});
		array_foreach(whitelist, function(_layer) {
			owner.reloader.AddVariable(_layer, "enabled");
		});
		array_foreach(blacklist, function(_layer) {
			owner.reloader.AddVariable(_layer, "enabled");
		});
	};
	static Draw = function() {
		var _frame = sprDemoFrame;
		var _w = RoomLoader.DataGetWidth(rm) * xScale;
		var _h = RoomLoader.DataGetHeight(rm) * yScale;
		var _xOrigin = _w * origin.x;
		var _yOrigin = _h * origin.y;
		var _xScale = _w / sprite_get_width(_frame);
		var _yScale = _h / sprite_get_height(_frame);
		DrawSpriteOrigin(_frame, 0, pos.x, pos.y, _xOrigin, _yOrigin, _xScale, _yScale, angle);
		
		draw_sprite(sprDemoCross, 0, pos.x, pos.y);
	};
	
	static OnUpdate = function() {
		if (keyboard_check_pressed(ord("1"))) Load();
		if (keyboard_check_pressed(ord("2"))) Unload();
	};
	static OnCleanup = function() {
		RoomLoader.DataRemove(rm);
		Unload();
	};
	
	// Custom:
	rm = rmDemoGeneral01;
	pos = new DemoModulePos();
	origin = new DemoModuleOrigin();
	xScale = 1;
	yScale = 1;
	angle = 0;
	flags = new DemoModuleFlags();
	whitelist = undefined;
	blacklist = undefined;
	
	static Load = function() {
		Unload();
		array_foreach(whitelist, function(_layer) {
			if (_layer.enabled) {
				RoomLoader.LayerWhitelistAdd(_layer.name);
			}
		});
		array_foreach(blacklist, function(_layer) {
			if (_layer.enabled) {
				RoomLoader.LayerBlacklistAdd(_layer.name);
			}
		});
			
		DEMO_PAYLOAD = RoomLoader
		.Origin(origin.x, origin.y)
		.AddAngle(false)
		.Flags(flags.get())
		.Scale(xScale, yScale).Angle(angle)
		.Load(rm, pos.x, pos.y);
		
		//DEMO_PAYLOAD = RoomLoader.Load(rm, pos.x, pos.y, origin.x, origin.y, flags.get(), xScale, yScale, angle);
		
		RoomLoader.LayerWhitelistReset().LayerBlacklistReset();
	};
	static Unload = function() {
		if (DEMO_PAYLOAD == undefined) return;
		
		DEMO_PAYLOAD.Cleanup();
		delete DEMO_PAYLOAD;
	};
}

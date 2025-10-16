/// feather ignore all

function DemoInstancesBatch() : DemoPar("Instances Batch") constructor {
	// Shared:
	static Init = function() {
		RoomLoader.DataInit(rm);
		
		// Interface:
		dbg_section("Info");
		dbg_text("This is an example of using \"RoomLoader.LoadInstances()\" to load all room\nInstances at a single depth.\n\nUse the controls below to adjust Position, Origin, Scaling and Rotation.");
		dbg_text_separator("Shortcuts", 1);
		dbg_text("- [PRESS 1] to Load instances.");
		dbg_text("- [PRESS 2] to Destroy instances.");
		
		dbg_section("Controls");
		dbg_button("Load", function() {
			Load();
		});
		dbg_same_line();
		dbg_button("Destroy", function() {
			Destroy();
		});
		
		pos.InitDbg();
		origin.InitDbg();
		DemoDbgTransform("Room Transform");
	
		// Reloader:
		owner.reloader
		.AddVariables(self, ["xScale", "yScale", "angle"])
		.AddModules([pos, origin])
		.OnTrigger(function() {
			Load();
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
		if (keyboard_check_pressed(ord("2"))) Destroy();
	};
	static OnCleanup = function() {
		RoomLoader.DataRemove(rm);
		Destroy();
	};
	
	// Custom:
	pos = new DemoModulePos();
	origin = new DemoModuleOrigin();
	xScale = 1;
	yScale = 1;
	angle = 0;
	
	rm = rmDemoInstancesBatch;
	batch = new RoomLoaderBatchInstances(rm);
	instances = undefined;
	
	static Load = function() {
		
	};
	static Destroy = function() {
		
	};
}

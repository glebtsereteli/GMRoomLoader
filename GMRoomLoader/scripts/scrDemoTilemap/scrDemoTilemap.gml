
function DemoTilemap() : DemoPar("Tilemap") constructor {
	// Shared:
	static Init = function() {
		RoomLoader.DataInit(rm);
		
		// Interface:
		DEMOS.info = dbg_section("Info");
		dbg_text("This is an example of using \"RoomLoader.LoadTilemap()\" to load\ntilemaps with optional mirroring, flipping, rotation and tileset.");
		dbg_text_separator("Shortcuts", 1);
		dbg_text("- [PRESS 1] to Load the tilemap.");
		dbg_text("- [PRESS 2] to Destroy the tilemap.");
		
		DEMOS.controls = dbg_section("Controls");
		dbg_button("Load", function() {
			Load();
		});
		dbg_same_line();
		dbg_button("Destroy", function() {
			Destroy();
		});
		
		pos.InitDbg();
		origin.InitDbg();
		dbg_text_separator("Transform", 1);
		dbg_checkbox(ref_create(self, "mirror"), "Mirror");
		dbg_checkbox(ref_create(self, "flip"), "Flip");
		dbg_slider_int(ref_create(self, "angle"), -180, 180, "Angle", 90);
		
		static _tilesetIds = [tsDemoTilemapNumbers, tsDemoTilemapLetters, tsDemoTilemapShapes];
		static _tilesetNames = ["Numbers", "Letters", "Shapes"];
		dbg_drop_down(ref_create(self, "tileset"), _tilesetIds, _tilesetNames, "Tileset");
		
		// Interface:
		owner.reloader
		.AddVariables(self, ["mirror", "flip", "angle", "tileset"])
		.AddModules([pos, origin])
		.OnTrigger(function() {
			Load();
		});
	};
	static Draw = function() {
		DemoDrawFrame(rm, pos.x, pos.y, origin);
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
	mirror = false;
	flip = false;
	angle = 0;
	tileset = undefined;
	
	rm = rmDemoTilemap;
	layer = layer_create(CONTROL.depth + 1);
	tilemap = undefined;
	
	static Load = function() {
		Destroy();
		tilemap = RoomLoader.LoadTilemap(rm, pos.x, pos.y, "Tiles", layer, origin.x, origin.y, mirror, flip, angle, tileset);
	};
	static Destroy = function() {
		if (tilemap == undefined) return;
		
		layer_tilemap_destroy(tilemap);
		tilemap = undefined;
	};
}

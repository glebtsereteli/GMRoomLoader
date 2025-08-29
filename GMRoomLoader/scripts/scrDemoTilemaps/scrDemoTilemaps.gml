
function DemoTilemaps() : DemoPar("Tilemaps") constructor {
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
		dbg_same_line();
		dbg_button("Randomize", function() {
			base.Randomize();
			details.Randomize();
			Load();
		});
		
		pos.InitDbg();
		origin.InitDbg();
		dbg_text_separator("Transform", 1);
		dbg_checkbox(ref_create(self, "mirror"), "Mirror");
		dbg_checkbox(ref_create(self, "flip"), "Flip");
		dbg_slider_int(ref_create(self, "angle"), -180, 180, "Angle", 90);
		
		dbg_text_separator("Tilesets", 1);
		base.InitDbg();
		details.InitDbg();
		
		// Interface:
		owner.reloader
		.AddVariables(self, ["mirror", "flip", "angle"])
		.AddVariables(base, ["tileset"])
		.AddVariables(details, ["tileset"])
		.AddModules([pos, origin])
		.OnTrigger(function() {
			Load();
		});
	};
	static Draw = function() {
		var _angle = angle - (floor(angle / 360) * 360);
		var _transposed = ((_angle mod 180) == 90);
		DemoDrawFrame(rm, pos.x, pos.y, origin,, _transposed);
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
	base = new DemoTilemapsPart("Base", 2);
	details = new DemoTilemapsPart("Details", 1);
	
	rm = rmDemoTilemaps;
	
	static Load = function() {
		static _LoadPart = function(_part) {
			_part.tilemap = RoomLoader.LoadTilemap(
				rm, pos.x, pos.y,
				$"Tiles{_part.name}", _part.layer,
				origin.x, origin.y, mirror, flip, angle, 
				_part.tileset
			);
		};
		
		Destroy();
		_LoadPart(base);
		_LoadPart(details);
	};
	static Destroy = function() {
		base.Destroy();
		details.Destroy();
	};
}
function DemoTilemapsPart(_name, _depthOffset) constructor {
	owner = other;
	name = _name;
	layer = layer_create(CONTROL.depth + _depthOffset);
	tilemap = undefined;
	tileset = undefined;
	tilesetNames = ["Grass", "Sand", "Snow"];
	tilesetIds = array_map(tilesetNames, function(_name) {
		return asset_get_index($"tsDemoTilemaps{_name}");
	});
	n = array_length(tilesetIds);
	
	static InitDbg = function() {
		dbg_drop_down(ref_create(self, "tileset"), tilesetIds, tilesetNames, $"{name}");
		dbg_same_line();
		dbg_button("-", function() { Cycle(-1); }, 20, 20);
		dbg_same_line();
		dbg_button("+", function() { Cycle(+1); }, 20, 20);
	};
	static Cycle = function(_dir) {
		_index = Mod2(GetTilesetIndex() + _dir, n);
		tileset = tilesetIds[_index];
		owner.Load();
	};
	static Randomize = function() {
		var _prevIndex = GetTilesetIndex();
		do {
			var _index = irandom(n - 1);
		}
		until (_index != _prevIndex);
		
		tileset = tilesetIds[_index];
	};
	static Destroy = function() {
		if (tilemap == undefined) return;
		
		layer_tilemap_destroy(tilemap);
		tilemap = undefined;
	};
	
	static GetTilesetIndex = function() {
		return array_get_index(tilesetIds, tileset);
	};
}

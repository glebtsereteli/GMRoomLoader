/// feather ignore all

function DemoMergeTilemaps() : DemoPar("Merge Tilemaps") constructor {
	// Shared:
	static Init = function() {
		RoomLoader.DataInitTag("MergeTilemaps")
		
		var _x = RoundTo(DEMOS.xCenter - (RoomLoader.DataGetWidth(hostRoom) / 2), tileSize);
		var _y = RoundTo(DEMOS.yCenter - (RoomLoader.DataGetHeight(hostRoom) / 2), tileSize);
		layer = layer_create(0, "Tiles");
		tilemap = RoomLoader.LoadTilemap(rmDemoMergeTilemapsHost, _x, _y, "Tiles");
		
		newScreenshot = RoomLoader.MiddleCenter().Screenshot(newRoom);
	};
	static Draw = function() {
		var _x = tilemap_get_x(tilemap);
		var _y = tilemap_get_y(tilemap);
		var _w = tilemap_get_width(tilemap) * tilemap_get_tile_width(tilemap);
		var _h = tilemap_get_height(tilemap) * tilemap_get_tile_height(tilemap);
		draw_sprite_stretched(sprDemoFrame, 0, _x, _y, _w, _h);
		
		if (not is_mouse_over_debug_overlay()) {
			if (placing) {
				var _x = RoundTo(mouse_x, tileSize);
				var _y = RoundTo(mouse_y, tileSize);
				draw_sprite_ext(newScreenshot, 0, _x, _y, 1, 1, angle, c_white, 0.5);
			}
			else {
				var _x = FloorTo(mouse_x, tileSize);
				var _y = FloorTo(mouse_y, tileSize);
				var _collision = position_meeting(mouse_x, mouse_y, tilemap);
				var _color = (_collision ? c_white : c_dkgray);
				draw_sprite_stretched_ext(sprDemoFrame, 0, _x, _y, tileSize, tileSize, _color, 1);
			}
		}
	};
	
	static OnUpdate = function() {
		if (is_mouse_over_debug_overlay()) return;
		
		placing ^= keyboard_check_pressed(vk_space);
		if (placing) {
			var _rotationInput = keyboard_check_pressed(ord("E")) - keyboard_check_pressed(ord("Q"));
			if (_rotationInput != 0) {
				var _nextAngle = angle - (90 * _rotationInput);
				angle = Mod2(_nextAngle, 360);
			}
			if (mouse_check_button_pressed(mb_left)) {
				RoomLoader.MiddleCenter().Angle(angle).LoadTilemap(newRoom, mouse_x, mouse_y, "Tiles");
			}
		}
		else {
			if (mouse_check_button(mb_left)) {
				tilemap_set_at_pixel(tilemap, 1, mouse_x, mouse_y);
			}
			if (mouse_check_button(mb_right)) {
				tilemap_set_at_pixel(tilemap, 0, mouse_x, mouse_y);
			}
		}
	};
	static OnCleanup = function() {
		layer_destroy(layer);
		layer_tilemap_destroy(tilemap);
		sprite_delete(newScreenshot);
		RoomLoader.DataRemoveTag("MergeTilemaps");
	};
	
	// Custom:
	hostRoom = rmDemoMergeTilemapsHost;
	hostPayload = undefined;
	newRoom = rmDemoMergeTilemapsNew;
	newScreenshot = undefined;
	layer = undefined;
	tilemap = undefined;
	tileSize = 32;
	angle = 0;
	placing = true;
}

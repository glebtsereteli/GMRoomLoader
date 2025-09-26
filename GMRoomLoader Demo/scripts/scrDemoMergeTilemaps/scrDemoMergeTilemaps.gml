/// feather ignore all

function DemoMergeTilemaps() : DemoPar("Merge Tilemaps") constructor {
	// Shared:
	static Init = function() {
		RoomLoader.DataInitTag("MergeTilemaps")
		
		var _x = RoundTo(DEMOS.xCenter - (RoomLoader.DataGetWidth(hostRoom) / 2), tileSize);
		var _y = RoundTo(DEMOS.yCenter - (RoomLoader.DataGetHeight(hostRoom) / 2), tileSize);
		hostPayload = RoomLoader.Load(rmDemoMergeTilemapsHost, _x, _y);
		
		newScreenshot = RoomLoader.MiddleCenter().Screenshot(newRoom);
	};
	static Draw = function() {
		if (is_mouse_over_debug_overlay()) return;
		
		var _x = RoundTo(mouse_x, tileSize);
		var _y = RoundTo(mouse_y, tileSize);
		draw_sprite_ext(newScreenshot, 0, _x, _y, 1, 1, angle, c_white, 0.5);
	};
	
	static OnUpdate = function() {
		if (is_mouse_over_debug_overlay()) return;
		
		var _rotationInput = keyboard_check_pressed(ord("E")) - keyboard_check_pressed(ord("Q"));
		if (_rotationInput != 0) {
			var _nextAngle = angle - (90 * _rotationInput);
			angle = Mod2(_nextAngle, 360);
		}
		if (mouse_check_button_pressed(mb_left)) {
			RoomLoader.MiddleCenter().Angle(angle).LoadTilemap(newRoom, mouse_x, mouse_y, "Tiles");
		}
	};
	static OnCleanup = function() {
		hostPayload.Cleanup();
		sprite_delete(newScreenshot);
		RoomLoader.DataRemoveTag("MergeTilemaps");
	};
	
	// Custom:
	hostRoom = rmDemoMergeTilemapsHost;
	hostPayload = undefined;
	newRoom = rmDemoMergeTilemapsNew;
	newScreenshot = undefined;
	tileSize = 32;
	angle = 0;
}

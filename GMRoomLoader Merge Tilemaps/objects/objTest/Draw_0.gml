
if (placing) {
	var _x = round(mouse_x / TILE_SIZE) * TILE_SIZE;
	var _y = round(mouse_y / TILE_SIZE) * TILE_SIZE;
	draw_sprite_ext(screenshot, 0, _x, _y, 1, 1, angle, c_white, 0.5);
}
else if (position_meeting(mouse_x, mouse_y, hostTilemap)) {
	var _x = mouse_x div TILE_SIZE * TILE_SIZE;
	var _y = mouse_y div TILE_SIZE * TILE_SIZE;
	draw_sprite_stretched(sprTestOutline, 0, _x, _y, TILE_SIZE, TILE_SIZE);
}

var _x = tilemap_get_x(hostTilemap);
var _y = tilemap_get_y(hostTilemap);
var _w = tilemap_get_width(hostTilemap) * tilemap_get_tile_width(hostTilemap);
var _h = tilemap_get_height(hostTilemap) * tilemap_get_tile_height(hostTilemap);
draw_sprite_stretched(sprTestOutline, 0, _x, _y, _w, _h);

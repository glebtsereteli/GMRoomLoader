
var _x = tilemap_get_x(hostTilemap);
var _y = tilemap_get_y(hostTilemap);
var _w = tilemap_get_width(hostTilemap) * tilemap_get_tile_width(hostTilemap);
var _h = tilemap_get_height(hostTilemap) * tilemap_get_tile_height(hostTilemap);
draw_sprite_stretched(sprTestOutline, 0, _x, _y, _w, _h);

if (position_meeting(mouse_x, mouse_y, hostTilemap)) {
	draw_set_font(fntTest);
	draw_text(mouse_x + 20, mouse_y, "Collision!");
	draw_set_font(-1);
}

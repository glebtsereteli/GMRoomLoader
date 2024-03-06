/// @desc Methods

init = function() {
	window_set_caption($"GMRoomLoader {__ROOMLOADER_VERSION} Demo");
	randomize();
	show_debug_overlay(true, true);
	texture_prefetch("Default");
};

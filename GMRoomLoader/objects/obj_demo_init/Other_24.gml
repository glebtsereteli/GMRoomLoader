/// @desc Methods

init = function() {
	window_set_caption($"GMRoomLoader {__ROOMLOADER_VERSION} ({__ROOMLOADER_DATE}) Demo");
	randomize();
	show_debug_overlay(true, true);
	texture_prefetch("Default");
};

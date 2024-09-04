/// @desc Methods

init = function() {
	window_set_caption($"{__ROOMLOADER_NAME} {__ROOMLOADER_VERSION} ({__ROOMLOADER_DATE}) Demo");
	randomize();
	show_debug_overlay(true, true);
	texture_prefetch("Default");
	
	instance_create_depth(0, 0, -15000, obj_demo_control);
};

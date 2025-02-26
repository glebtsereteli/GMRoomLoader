
function demo_init() {
	window_set_caption($"{__ROOMLOADER_NAME} {__ROOMLOADER_VERSION} ({__ROOMLOADER_DATE}) Demo");
	randomize();
	texture_prefetch("Default");
	instance_create_depth(0, 0, -15000, obj_demo_control);
}

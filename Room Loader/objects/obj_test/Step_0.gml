
if (keyboard_check_pressed(vk_space)) {
	for (var _i = 0; _i < array_length(instances); _i++) {
		instance_destroy(instances[_i]);
	}
	instances = room_load_instances(rm_load_test_01, 128, 128, 0);
}

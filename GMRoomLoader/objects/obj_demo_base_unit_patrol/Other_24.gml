/// @desc Methods

init = function() {
	path = path_duplicate(vd_path);
	path_shift(path, vd_room.x, vd_room.y);
	path_start(path, random_range(0.8, 1), path_action_continue, true);
};
update = function() {
	image_angle = lerp_angle(image_angle, direction, 0.2);
};
cleanup = function() {
	path_delete(path);
};

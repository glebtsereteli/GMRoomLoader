event_inherited();

path = path_duplicate(vd_path);
var _slot = DEMOS.get_current().host.data.get_instance(vd_slot);
path_shift(path, _slot.x, _slot.y);
path_start(path, random_range(0.8, 1), path_action_continue, true);

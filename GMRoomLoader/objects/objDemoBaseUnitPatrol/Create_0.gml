event_inherited();

path = path_duplicate(vdPath);
var _slot = DEMOS.GetCurrent().host.data.GetInstance(vdSlot);
path_shift(path, _slot.x, _slot.y);
path_start(path, random_range(0.8, 1), path_action_continue, true);

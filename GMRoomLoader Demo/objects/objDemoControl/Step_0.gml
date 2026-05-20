
if (prevIndex != index) {
	Change(prevIndex);
}
		
var _input = keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left);
if (_input != 0) {
	Change(index + _input);
}
		
reloader.Update();
GetCurrent().Update();

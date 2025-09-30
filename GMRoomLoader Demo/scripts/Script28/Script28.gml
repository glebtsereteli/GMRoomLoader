
var _xInput = keyboard_check(vk_right) - keyboard_check(vk_left); // Grab our horizontal input. This will be -1, 0 or 1.
var _yInput = keyboard_check(vk_down) - keyboard_check(vk_up); // Grab our vertical input. This will be -1, 0 or 1.
if ((_xInput != 0) or (_yInput != 0)) { // Are we moving?
    var _dir = point_direction(0, 0, _xInput, _yInput); // Calculate the input direction to move in.
    var _xSpd = lengthdir_x(moveSpd, _dir); // Grab the horizontal component of our movement vector using speed and direction.
    var _ySpd = lengthdir_y(moveSpd, _dir); // Grab the vertical component of our movement vector using speed and direction.
    move_and_collide(_xSpd, _ySpd, yourColliders); // Move using our calculated speeds and collide with stuff in yourColliders array.
}

if ((_xInput != 0) and (_yInput != 0)) {
	// We're moving diagonally.
}


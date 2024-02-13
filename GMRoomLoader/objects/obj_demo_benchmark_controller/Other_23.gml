/// @desc Constructors

Flag = function(_name, _value) constructor {
	name = _name;
	value = _value;
	enabled = true;
	key = undefined;
	
	static init = function(_i) {
		key = ord(string(_i + 1));
	};
	static update = function() {
		enabled ^= keyboard_check_pressed(key);	
	};
};

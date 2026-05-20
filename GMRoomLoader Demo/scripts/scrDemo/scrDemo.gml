// feather ignore all

function Demo(_name) constructor {
	owner = other;
	name = _name;
	iname = undefined;
	index = undefined;
	
	static Setup = function(_index) {
		index = _index;
		iname = $"0{index + 1}. {name}";
	};
	static Init = Noop;
	static Update = function() {
		OnUpdate();
	};
	static Draw = Noop;
	static Cleanup = function() {
		OnCleanup();
	};

	static OnUpdate = Noop;
	static OnCleanup = Noop;
}

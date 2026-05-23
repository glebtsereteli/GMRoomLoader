
function DemoReloader() constructor {
	pool = [];
	callbackOnTrigger = Noop;
	
	static Update = function() {
		static _check = function(_var) {
			var _new = _var.scope[$ _var.name];
			if (_new != _var.def) {
				_var.def = _new;
				return true;
			}
			return false;
		};
		
		if (array_any(pool, _check)) {
			callbackOnTrigger();
		}
	};
	
	static AddVariable = function(_scope, _name) {
		array_push(pool, {
			def: _scope[$ _name],
			scope: _scope,
			name: _name,
		});
		return self;
	};
	static AddVariables = function(_scope, _pool) {
		for (var _i = 0; _i < array_length(_pool); _i++) {
			AddVariable(_scope, _pool[_i]);
		}
		return self;
	};
	static AddModules = function(_pool) {
		array_foreach(_pool, function(_module) {
			AddVariables(_module, _module.reloaderNames);
		});
		return self;
	};
	static Clear = function() {
		pool = [];
		return self;
	};
	
	static OnTrigger = function(_callback) {
		callbackOnTrigger = _callback;
		return self;
	};
}


/// @func RoomLoaderBatchInstances() constructor
/// @param {Asset.GMRoom} room The room to batch-load instances from.
/// @desc TODO
function RoomLoaderBatchInstances(_room) constructor {
	#region __private
	
	__data = RoomLoader.DataGetInstances(_room);
	__n = array_length(__data);
	
	__loading = false;
	__nPerFrame = 1;
	__index = undefined;
	__instances = [];
	
	#endregion
	#region Core
	
	/// @param {Real} amount The amount of instances to load per frame.
	/// @returns {Struct.RoomLoaderBatchInstances self}
	/// @desc TODO
	static PerFrame = function(_amount) {
		if (not __loading) {
			__nPerFrame = _amount;
		}
		
		return self;
	};
	
	/// @param {Real} frames The amount of frames to spread loading over.
	/// @returns {Struct.RoomLoaderBatchInstances self}
	/// @desc TODO
	static OverTime = function(_frames) {
		if (not __loading) {
			__nPerFrame = ceil(__n / _frames);
		}
		
		return self;
	};
	
	/// @returns {Struct.RoomLoaderBatchInstances self}
	/// @desc TODO
	static Start = function() {
		if (__loading) {
			// TODO restart
		}
		
		__loading = true;
		__index = 0;
		__instances = array_create(__n, noone);
		
		return self;
	};
	
	/// @returns {Bool}
	/// @desc TODO
	static Update = function() {
		
		return IsDone();
	};
	
	#endregion
	#region Status & Getters
	
	/// @returns {Bool}
	/// @desc TODO
	static IsDone = function() {
		return (__loading ? (__index == (__n - 1)) : undefined);
	};
	
	/// @returns {Real}
	/// @desc TODO
	static GetProgress = function() {
		return (__loading ? (__index / __n) : undefined);
	};
	
	/// @returns {Array<Id.Instance>}
	/// @desc TODO
	static GetInstances = function() {
		return (__loading ? __instances : undefined);
	};
}

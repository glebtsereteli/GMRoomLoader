/// @feather ignore all

/// @func RoomLoaderReturnData()
/// @param {Asset.GMRoom} room
/// @desc Returned by RoomLoader's .load() method. Stores all layers and elements created on load, 
/// and handles element fetching and cleanup.
/// 
/// NOTE: This constructor is only used by RoomLoader's .load() method, it should NOT be explicitly instantiated.
function RoomLoaderReturnData(_room) constructor {
	#region __private
	
	static __Container = function(_on_destroy) constructor {
		__ids = [];
		__names = [];
		
		__on_destroy = _on_destroy;
		static __add = function(_id, _name) {
			array_push(__ids, _id);
			array_push(__names, _name);
		};
		static __get = function(_name) {
			var _index = array_get_index(__names, _name);
			return ((_index == -1) ? undefined : __ids[_index]);
		};
		static __destroy = function() {
			static _callback = function(_element) { __on_destroy(_element); };
			array_foreach(__ids, _callback);
		};
	};
	static __message_prefix = "RoomLoaderReturnData";

	__room = _room;
	__layers = new __Container(layer_destroy);
	__instances = {
		__ids: undefined,
		__index: 0,
		__destroy: function() {
			array_foreach(__ids, instance_destroy);
		},
	};
	__tilemaps = new __Container(layer_tilemap_destroy);
	__sprites = new __Container(layer_sprite_destroy);
	__particle_systems = new __Container(part_system_destroy);
	__sequences = new __Container(layer_sequence_destroy);
	__texts = new __Container(layer_text_destroy);
	__backgrounds = new __Container(layer_background_destroy);
	__cleaned_up = false;
	
	#endregion
	#region getters
	
	/// @param {String} layer_name Thes layer name to search for.
	/// @returns {Id.Layer,undefined}
	/// @desc Returns the layer ID matching the given name or undefined if not found.
	/// @context RoomLoaderReturnData
	static get_layer = function(_name) {
		__roomloader_catch_string(__message_prefix, "get_layer", _name, "get a Layer ID from the", "name");
		return __layers.__get(_name);
	};
	
	/// @returns {Array<Id.Layer>}
	/// @desc Returns an array of created layers.
	/// @context RoomLoaderReturnData
	static get_layers = function() {
		return __layers.__ids;
	};
	
	/// @returns {Array<Id.Instance>}
	/// @desc Returns an array of created Instances.
	/// @context RoomLoaderReturnData
	static get_instances = function() {
		return __instances.__ids;
	};
	
	/// @param {String} layer_name The Tilemap layer name to search for.
	/// @returns {Id.Tilemap,undefined}
	/// @desc Returns the Tilemap ID matching the given layer name or undefined if not found.
	/// @context RoomLoaderReturnData
	static get_tilemap = function(_layer_name) {
		__roomloader_catch_string(__message_prefix, "get_tilemap", _layer_name, "get a Tilemap ID from the", "layer name");
		return __tilemaps.__get(_layer_name);
	};
	
	/// @returns {Array<Id.Tilemap>}
	/// @desc Returns an array of created Tilemaps.
	/// @context RoomLoaderReturnData
	static get_tilemaps = function() {
		return __tilemaps.__ids;
	};
	
	/// @param {String} name The Sprite name to search for.
	/// @returns {Id.Sprite,undefined}
	/// @desc Returns the Sprite ID matching the given name or undefined if not found.
	/// @context RoomLoaderReturnData
	static get_sprite = function(_name) {
		__roomloader_catch_string(__message_prefix, "_name", _name, "get a Sprite ID from the", "name");
		return __sprites.__get(_name);
	};
	
	/// @returns {Array<Id.Sprite>}
	/// @desc Returns an array of created Sprites.
	/// @context RoomLoaderReturnData
	static get_sprites = function() {
		return __sprites.__ids;
	};
	
	/// @param {String} name The Particle System name to search for.
	/// @returns {Id.ParticleSystem,undefined}
	/// @desc Returns the created Particle System ID matching the given name or undefined if not found.
	/// @context RoomLoaderReturnData
	static get_particle_system = function(_name) {
		__roomloader_catch_string(__message_prefix, "get_particle_system", _name, "get a Particle System ID from the", "name");
		return __particle_systems.__get(_name);
	};
	
	/// @returns {Array<Id.ParticleSystem>}
	/// @desc Returns an array of created Particle Systems.
	/// @context RoomLoaderReturnData
	static get_particle_systems = function() {
		return __particle_systems.__ids;
	};
	
	/// @param {String} name The Sequence name to search for.
	/// @returns {Id.Sequence,undefined}
	/// @desc Returns the created Sequence ID matching the given name or undefined if not found.
	/// @context RoomLoaderReturnData
	static get_sequence = function(_name) {
		__roomloader_catch_string(__message_prefix, "get_sequence", _name, "get a Sequence ID from the", "name");
		return __sequences.__get(_name);
	};
	
	/// @returns {Array<Id.Sequence>}
	/// @desc Returns an array of created Sequences.
	/// @context RoomLoaderReturnData
	static get_sequences = function() {
		return __sequences.__ids;
	};
	
	/// @param {String} layer_name The Background layer name to search for.
	/// @returns {Id.Background}
	/// @desc Returns the created Background ID matching the given layer name or undefined if not found.
	/// @context RoomLoaderReturnData
	static get_background = function(_layer_name) {
		__roomloader_catch_string(__message_prefix, "get_background", _layer_name, "get a Background ID from the", "layer name");
		return __backgrounds.__get(_layer_name);
	};
	
	/// @returns {Array<Id.Background>}
	/// @desc Returns an array of created Backgrounds.
	/// @context RoomLoaderReturnData
	static get_backgrounds = function() {
		return __backgrounds.__ids;
	};
	
	#endregion
	#region cleanup
	
	/// @returns {Undefined}
	/// @desc Destroys created layers and their elements. After calling this method, the instance becomes practically 
	/// useless and should be dereferenced to be picked up by the Garbage Collector.
	/// @context RoomLoaderReturnData
	static cleanup = function() {
		static _method_name = "cleanup";
		
		if (__cleaned_up) {
			__roomloader_log_method(__message_prefix, _method_name, $"data for \<{room_get_name(__room)}\> is already cleaned up");
			return;
		}
		
		RoomLoader.__benchmark.__start();
		__instances.__destroy();
		__tilemaps.__destroy();
		__sprites.__destroy();
		__particle_systems.__destroy();
		__sequences.__destroy();
		__texts.__destroy();
		__backgrounds.__destroy();
		__layers.__destroy();
		__cleaned_up = true;
		
		__roomloader_log_method_timed(__message_prefix, _method_name, "cleaned up data for", __room);
	};

	#endregion
};

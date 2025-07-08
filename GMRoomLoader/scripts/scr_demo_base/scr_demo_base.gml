
function DemoBase() : DemoPar("Base") constructor {
	// Shared:
	static init = function() {
		host.init();
		slots.init();
		
		DEMOS.info = dbg_section("Info");
		dbg_text("This demo shows an enemy base composed of multiple Room Slots,\neach filled with randomized GameMaker rooms to create a unique level.");
		dbg_text("\nFirst we load a Host room, then fill each Slot with a random room.\nThis shows 2 \"layers\" of room loading working together.");
		dbg_text_separator("Shortcuts", 1);
		dbg_text("- [PRESS 1] to load random rooms for all Slots.");
		dbg_text("  [HOLD SHIFT+1] to load random rooms for all Slots every frame.");
		dbg_text("- [PRESS 2] to clean up rooms for all Slots.");
		dbg_text("- [PRESS LMB] on a Slot to load a random room for it.");
		dbg_text("  [HOLD SHIFT+LMB] on a Slot to load a random room for it every frame.");
		dbg_text("- [PRESS RMB] on a Slot to clean up its room.");
		
		DEMOS.controls = dbg_section("Controls");
		dbg_button("Load All", function() {
			slots.load_all();
		});
		dbg_same_line();
		dbg_button("Cleanup All", function() {
			slots.cleanup_all();
		});
		
		flags.init_dbg();
	};
	static cleanup = function() {
		slots.cleanup();
		host.cleanup();
	};
	
	static on_update = function() {
		slots.update();
	};
	
	// Custom:
	host = {
		ref: rm_demo_base_host,
		data: undefined,
		
		init: function() {
			RoomLoader.data_init(ref);
			data = RoomLoader.load(ref, DEMOS.xcenter, DEMOS.ycenter, 0.5, 0.5);
		},
		cleanup: function() {
			RoomLoader.data_remove(ref);
			data.cleanup();
		},
	};
	slots = {
		owner: other,
		tag: "base_rooms",
		obj: obj_demo_base_slot_parent,
		
		init: function() {
			RoomLoader.data_init_tag(tag);
		},
		update: function() {
			var _hovered_slot = noone;
			var _fast = keyboard_check(vk_shift);
			
			// Update hover:
			with (obj) {
				update();
				if (hovered) {
					_hovered_slot = id;
				}
			}
			
			// Load/cleanup hovered slot:
			with (_hovered_slot) {
				var _checker = (_fast ? mouse_check_button : mouse_check_button_pressed);
				if (_checker(mb_left)) {
					load(false, other.owner.flags.get());
				}
				if (mouse_check_button_pressed(mb_right)) {
					cleanup(false);
				}
			}
			
			// Load all rooms:
			var _checker = (_fast ? keyboard_check : keyboard_check_pressed);
			if (_checker(ord("1"))) {
				load_all();
			}
			
			// Cleanup all rooms:
			if (keyboard_check_pressed(ord("2"))) {
				cleanup_all();
			}
		},
		cleanup: function() {
			RoomLoader.data_remove_tag(tag);
			cleanup_all();
		},
		
		load_all: function() {
			var _flags = owner.flags.get();
			with (obj) {
				load(true, _flags);
			}
		},
		cleanup_all: function() {
			with (obj) {
				cleanup(true);
			}
		},
	};
	flags = new DemoModuleFlags();

	reloader
	.add_modules([flags])
	.on_trigger(function() {
		slots.load_all();
	});
}

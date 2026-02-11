// feather ignore all

function DemoBase() : DemoPar("Base") constructor {
	// shared
	static Init = function() {
		host.Init();
		slots.Init();
		
		dbg_section("Info");
		dbg_text("This demo shows an enemy base composed of multiple Room Slots, each\nfilled with randomized GameMaker rooms to create a unique level.");
		dbg_text("\nFirst we load a Host room, then fill each Slot with a random room.\nThis shows 2 \"layers\" of room loading working together.");
		dbg_text_separator("Shortcuts", 1);
		dbg_text("- [PRESS 1] to load random rooms for all Slots.");
		dbg_text("  [HOLD SHIFT+1] to load random rooms for all Slots every frame.");
		dbg_text("- [PRESS 2] to clean up rooms for all Slots.");
		dbg_text("- [PRESS LMB] on a Slot to load a random room for it.");
		dbg_text("  [HOLD SHIFT+LMB] on a Slot to load a random room for it every frame.");
		dbg_text("- [PRESS RMB] on a Slot to clean up its room.");
		
		dbg_section("Controls");
		dbg_button("Load All", function() {
			slots.LoadAll();
		});
		dbg_same_line();
		dbg_button("Cleanup All", function() {
			slots.CleanupAll();
		});
		
		flags.InitDbg();
		
		// Reloader:
		owner.reloader
		.AddModules([flags])
		.OnTrigger(function() {
			slots.LoadAll();
		});
	};
	
	static OnUpdate = function() {
		slots.Update();
	};
	static OnCleanup = function() {
		slots.Cleanup();
		host.Cleanup();
	};
	
	// custom
	host = {
		ref: rmDemoBaseHost,
		data: undefined,
		
		Init: function() {
			RoomLoader.DataInit(ref);
			data = RoomLoader.Load(ref, DEMOS.xCenter, DEMOS.yCenter, 0.5, 0.5);
		},
		Cleanup: function() {
			RoomLoader.DataRemove(ref);
			data.Cleanup();
		},
	};
	slots = {
		owner: other,
		tag: "BaseRooms",
		obj: objDemoBaseSlotParent,
		
		Init: function() {
			RoomLoader.DataInitTag(tag);
		},
		Update: function() {
			var _hoveredSlot = noone;
			var _fast = keyboard_check(vk_shift);
			
			// Update hover:
			with (obj) {
				Update();
				if (hovered) {
					_hoveredSlot = id;
				}
			}
			
			// Load/cleanup hovered slot:
			with (_hoveredSlot) {
				var _checker = (_fast ? mouse_check_button : mouse_check_button_pressed);
				if (_checker(mb_left)) {
					Load(false, other.owner.flags.Get());
				}
				if (mouse_check_button_pressed(mb_right)) {
					Cleanup(false);
				}
			}
			
			// Load all rooms:
			var _checker = (_fast ? keyboard_check : keyboard_check_pressed);
			if (_checker(ord("1"))) {
				LoadAll();
			}
			
			// Cleanup all rooms:
			if (keyboard_check_pressed(ord("2"))) {
				CleanupAll();
			}
		},
		Cleanup: function() {
			RoomLoader.DataRemoveTag(tag);
			CleanupAll();
		},
		
		LoadAll: function() {
			var _flags = owner.flags.Get();
			with (obj) {
				Load(true, _flags);
			}
		},
		CleanupAll: function() {
			with (obj) {
				Cleanup(true);
			}
		},
	};
	flags = new DemoModuleFlags();
}

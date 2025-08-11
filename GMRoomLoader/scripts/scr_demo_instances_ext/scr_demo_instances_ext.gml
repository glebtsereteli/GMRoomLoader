
function DemoInstances() : DemoPar("Instances") constructor {
	// Shared:
	static init = function() {
		RoomLoader.data_init(rm);
		
		DEMOS.info = dbg_section("Info");
		dbg_text("This is an example of using \"RoomLoader.load_instances()\" to load\nroom instances with optional scale and rotation.");
		dbg_text_separator("Shortcuts", 1);
		dbg_text("- [PRESS 1] to load the room.");
		dbg_text("- [PRESS 2] to clean up the room.");
		
		DEMOS.controls = dbg_section("Controls");
		dbg_button("Load", function() {
			load();
		});
		dbg_same_line();
		dbg_button("Clean Up", function() {
			unload();
		});
		
		pos.init_dbg();
		origin.init_dbg();
		dbg_text_separator("Room Transform", 1);
		dbg_slider(ref_create(self, "xscale"), -2, 2, "X Scale", 0.05);
		dbg_slider(ref_create(self, "yscale"), -2, 2, "Y Scale", 0.05);
		dbg_slider_int(ref_create(self, "angle"), -180, 180, "Angle", 5);
		
		dbg_text_separator("Instance Transform", 1)
		dbg_checkbox(ref_create(self, "scale_multiplicative"), "Multiplicative Scale");
		dbg_text(" - When enabled, individual instance \"image_x/yscale\" is multiplied by\n the overall load xscale/yscale. Change the X/Y Scale parameters above\n and toggle this on/off to see it in action.");
		dbg_text("");
		dbg_checkbox(ref_create(self, "angle_additive"), "Additive Angle");
		dbg_text(" - When enabled, individual instance \"image_angle\" is combined with\n the overall angle. Change the Angle parameter above and toggle this\n on/off to see it in action.");
	};
	static draw = function() {
		var _frame = spr_demo_frame;
		var _w = RoomLoader.data_get_width(rm) * xscale;
		var _h = RoomLoader.data_get_height(rm) * yscale;
		var _xOrigin = _w * origin.x;
		var _yOrigin = _h * origin.y;
		var _xscale = _w / sprite_get_width(_frame);
		var _yscale = _h / sprite_get_height(_frame);
		draw_sprite_origin(_frame, 0, pos.x, pos.y, _xOrigin, _yOrigin, _xscale, _yscale, angle);
		
		draw_sprite(spr_demo_cross, 0, pos.x, pos.y);
	};
	static cleanup = function() {
		RoomLoader.data_remove(rm);
		unload();
	};
	
	static on_update = function() {
		if (keyboard_check_pressed(ord("1"))) load();
		if (keyboard_check_pressed(ord("2"))) unload();
	};
	
	// Custom:
	pos = new DemoModulePos();
	origin = new DemoModuleOrigin();
	xscale = 1;
	yscale = 1;
	angle = 0;
	scale_multiplicative = true;
	angle_additive = true;
	
	rm = rm_demo_instances_ext_01;
	instances = undefined;
	
	static load = function() {
		unload();
		instances = RoomLoader.load_instances(rm, pos.x, pos.y, 0, xscale, yscale, angle, scale_multiplicative, angle_additive, origin.x, origin.y);
	};
	static unload = function() {
		if (instances == undefined) return;
		
		array_foreach(instances, function(_inst) {
			instance_destroy(_inst);
		});
		delete instances;
	};
	
	reloader
	.add_variables(self, ["xscale", "yscale", "angle", "scale_multiplicative", "angle_additive"])
	.add_modules([pos, origin])
	.on_trigger(function() {
		load();
	});
}

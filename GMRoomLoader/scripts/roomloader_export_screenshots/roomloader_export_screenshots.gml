
/// @func roomloader_export_screenshots()
/// @param {Array<Asset.GMRoom>} rooms=[all rooms] An array of rooms to export screenshots of.
/// @param {String} path=[prompt] The path to export the .zip to.
/// @descr Takes screenshots of all given rooms and exports them into a .zip archive at the given path.
/// Note: make sure to have the "Disable file system sandbox" setting disabled for your target platform.
function roomloader_export_screenshots(_rooms = asset_get_ids(asset_room), _path = undefined) {
	with ({}) {
		path = _path;
		if (path == undefined) {
			var _prefix = $"{game_project_name} Room Screenshots";
			var _title = $"{__ROOMLOADER_NAME}: {_prefix} Export";
			path = get_save_filename_ext($"zip|*.zip", $"{_prefix}.zip", "", _title);
			if (path == "") return;
		}
		dir = $"{game_save_id}__gmroomloader_screenshots_export";
		zip = zip_create();
		
		array_foreach(_rooms, function(_room) {
			var _initialized = RoomLoader.data_is_initialized(_room);
			RoomLoader.data_init(_room);
			var _screenshot = RoomLoader.take_screenshot(_room);
			if (not _initialized) {
				RoomLoader.data_remove(_room);
			}
			
			var _local_path = $"{room_get_name(_room)}.png";
			var _path = $"{dir}/{_local_path}";
			sprite_save(_screenshot, 0, path);
			sprite_delete(_screenshot);
			
			zip_add_file(zip, _local_path, path);
		});
		
		zip_save(zip, path);
		timer = call_later(1, time_source_units_frames, function() {
			if (not file_exists(path)) return;
			directory_destroy(dir);
			call_cancel(timer);
		}, true);
	}
}

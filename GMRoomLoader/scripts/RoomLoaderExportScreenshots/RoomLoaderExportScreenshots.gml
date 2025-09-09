
/// @func RoomLoaderExportScreenshots()
/// @param {Array<Asset.GMRoom>} rooms An array of rooms to export screenshots of. [Default: all rooms]
/// @param {String} path The path to export the .zip to. [Default: undefined, prompt]
/// @descr Takes screenshots of all given rooms and exports them into a .zip archive at the given path.
/// Note: make sure to have the "Disable file system sandbox" setting disabled for your target platform.
function RoomLoaderExportScreenshots(_rooms = asset_get_ids(asset_room), _path = undefined) {
	with ({}) {
		path = _path;
		if (path == undefined) {
			var _prefix = $"{game_project_name} Room Screenshots";
			var _title = $"{game_project_name}: {_prefix} Export";
			path = get_save_filename_ext($"zip|*.zip", $"{_prefix}.zip", "", _title);
			if (path == "") return;
		}
		dir = $"{game_save_id}__GMRoomLoaderScreenshotsExport";
		zip = zip_create();
		
		array_foreach(_rooms, function(_room) {
			var _initialized = RoomLoader.DataIsInitialized(_room);
			RoomLoader.DataInit(_room);
			var _screenshot = RoomLoader.Screenshot(_room);
			if (not _initialized) {
				RoomLoader.DataRemove(_room);
			}
			
			var _localPath = $"{room_get_name(_room)}.png";
			var _tempPath = $"{dir}/{_localPath}";
			sprite_save(_screenshot, 0, _tempPath);
			sprite_delete(_screenshot);
			zip_add_file(zip, _localPath, _tempPath);
		});
		
		zip_save(zip, path);
		timer = call_later(1, time_source_units_frames, function() {
			if (not file_exists(path)) return;
			directory_destroy(dir);
			call_cancel(timer);
		}, true);
	}
}

/// feather ignore all

function DemoMergeTilemaps() : DemoPar("Merge Tilemaps") constructor {
	// Shared:
	static Init = function() {
		RoomLoader.DataInitTag("MergeTilemaps")
		hostPayload = RoomLoader.MiddleCenter().Load(rmDemoMergeTilemapsHost, DEMOS.xCenter, DEMOS.yCenter);
	};
	static Draw = function() {
		
	};
	
	static OnUpdate = function() {
		
	};
	static OnCleanup = function() {
		hostPayload.Cleanup();
		RoomLoader.DataRemoveTag("MergeTilemaps");
	};
	
	// Custom:
	hostPayload = undefined;
	
	static Load = function() {
		
	};
}

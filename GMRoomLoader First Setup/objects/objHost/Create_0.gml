/// @desc Setup

rm = rmExample; // The room we'll load.
payload = undefined; // The variable to hold our Payload after loading.

RoomLoader.DataInit(rm); // Initialize the data for our room.

Cleanup = function() { // The method we'll use to unload the loaded room.
    if (payload != undefined) { // Only do this when a Payload exists.
        payload.Cleanup(); // Destroy all loaded layers and their elements.
        delete payload; // We're done here, dereference the payload so it can be picked up by the Garbage Collector.
    }
};

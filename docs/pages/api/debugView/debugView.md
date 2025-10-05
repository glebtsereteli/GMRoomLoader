# Debug View

The Debug View module offers an easy way to test room loading features directly in your game using a :Debug Overlay: view, without writing any code.

## Setup

You can enable Debug View by setting the :ROOMLOADER_DEBUG_VIEW_ENABLED: config macro to `true`.

If :ROOMLOADER_DEBUG_VIEW_START_VISIBLE: is also set to `true`, the Debug View will appear automatically when the game starts. Otherwise, you can open the :Debug Overlay: by calling `show_debug_overlay(true);`, then navigate to the **Views** menu in the top bar and select the `RoomLoader Debug` view.
![debugViewOpen](debugViewOpen.png)

Once open, you will see this window on your screen.
![debugViewMain](debugViewMain.png)

Now that the :Debug View: is enabled, you can start loading rooms at the mouse coordinates by pressing :ROOMLOADER_DEBUG_VIEW_KEY:. You can also pick which room to load and configure loading parameters, that's all described in the [Controls](#controls) section below.

## Controls

* The **Enabled** checkbox lets you control whether room loading is active when you press the designated key. If unchecked, pressing :ROOMLOADER_DEBUG_VIEW_KEY: will not load rooms. This toggle is useful for temporarily disabling room loading, since GameMaker doesn't provide a built-in way to detect if a :Debug Overlay: view is open.
* The **Cleanup** button unloads any rooms that were loaded via the :Debug View:.
* The **Room** dropdown allows you to select which room to load. The list of rooms shown is determined by the :ROOMLOADER_DEBUG_VIEW_ROOMS: config macro. If this macro is set to :Undefined:, all rooms in your project will be available for selection. Otherwise, only the rooms specified in the macro will appear.
* The next few sliders control :Origin:, :Scaling: and :Rotation: loading parameters.
* The **Flags** section lets you control :Asset Type Filtering:.
* The **Layer Whitelist** and **Layer Blacklist** sections let you control Whitelist and Blacklist :Layer Name Filtering:.

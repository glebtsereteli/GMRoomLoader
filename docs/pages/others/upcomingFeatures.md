# Upcoming Features

The following list of ideas includes features that might or might not be introduced in the future. If you have a feature you'd like to suggest, please open a :New Issue: with the `feature` label.

## Library
* Pre-load/screenshot state control.
```js
RoomLoader.Pos(room_width / 2, room_height / 2).Origin(0.5, 0.5).Load(rmExample);
RoomLoader.Scale(random_range(0.8, 1.2)).Angle(random(360)).Load(rmExample, someX, someY);
RoomLoader.Flags(ROOMLOADER_FLAGS.TILEMAPS).Load(rmExample, someX, someY);
```
* Deferred loading over time for large rooms with many elements.
    * `RoomLoader.LoadDeferred()`.
    * `RoomLoader.LoadInstancesDeferred()`.
* Particle systems support (GM bug?).
* In-layer Filters/Effects support (GM bug?).
* Debug view with initialized rooms display, screenshots and customizable loading.

## Demos
* Procedural generation.
* Drag'n'drop map.
* Endless runner.

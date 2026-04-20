# Getters

## Overview

This section covers two ways to retrieve created element IDs from :Payload:.
1. Individual ID `.Get<ElementType>` getters.
    * Instances, Sprites, Particle Systems, Sequences and Texts use their room IDs.
    * Tilemaps and Backgrounds use the name of the layer they're on.
2. Type-based `.Get<ElementType>s()` getters that return an array of element IDs, using layer names for lookup.

::: info NOTE
All code examples on this page assume you have an existing instance of :Payload: retrieved from :RoomLoader.Load(): and stored in a `payload` variable.
:::

## Methods

### `.GetLayer()`

> `payload.GetLayer(name)` ➜ :Id.Layer: or :Undefined:

Returns the ID of the created Layer matching the given name if found, or :Undefined: if not found.

| Parameter | Type | Description |
| --- | --- | --- |
| `name` | :String: | The layer name to search for |

:::code-group
```js [Example]
// Gets the created "Clouds" layer ID and randomizes its horizontal speed:
var _cloudsLayer = payload.GetLayer("Clouds"); // [!code highlight]
if (_cloudsLayer != undefined) {
    layer_hspeed(_cloudsLayer, random_range(5, 8));
}
```
:::

---
### `.GetLayers()`

> `payload.GetLayers()` ➜ :Array: of :Id.Layer: 

Returns an array of created Layers.

:::code-group
```js [Example]
// Gets an array of created Layers and randomly toggles their visibility:
array_foreach(payload.GetLayers(), function(_layer) { // [!code highlight]
    layer_set_visible(_layer, choose(true, false));
});
```
:::

---
### `.GetInstance()`

> `payload.GetInstance(roomId)` ➜ :Id.Instance: or :Noone:

Returns the ID of the created Instance from the given room ID if found, or :Noone: if not found.

| Parameter | Type | Description |
| --- | --- | --- |
| `roomId` | `Constant` | The Instance room ID to search for |

:::code-group
```js [Example]
// Grabs the created Instance ID from the InstWaypoint room ID and assigns it
// to objPlayer's waypointID:
objPlayer.waypointID = payload.GetInstance(InstWaypoint); // [!code highlight]
```
:::

---
### `.GetInstances()`

> `payload.GetInstances([object])` ➜ :Array: of :Id.Instance:

Returns an array of created Instances, optionally filtered by object.

| Parameter | Type | Description |
| --- | --- | --- |
| `[object]` | :Asset.GMObject: | The object to filter instances by. Only instances of this object will be returned [Default: `undefined` (no filter)] |

:::code-group
```js [Example]
// Gets an array of created Instances and targets a random one:
var _instances = payload.GetInstances(); // [!code highlight]
var _randomInstance = script_execute_ext(choose, _instances);

// Gets an array of created objDoor instances:
var _doors = payload.GetInstances(objDoor); // [!code highlight]
```
:::

---
### `.DetachInstances()`

> `payload.DetachInstances()` ➜ :Array: of :Id.Instance:

Detaches instances from the Payload and stops tracking them. Returns an array of the detached instance IDs, allowing their cleanup to be handled separately.

::: info
Useful when instances from a loaded room need to outlive the rest of the room's contents. For example, in chunk systems where an instance may move between chunks and should not be destroyed when its original chunk unloads.
:::

::: warning
If detached instances remain on their original layers and those layers are destroyed during :.Cleanup():, the instances will still be destroyed.
:::

:::code-group
```js [Example]
// Detaches loaded instances from the payload and stores them for manual cleanup:
var _instances = payload.DetachInstances(); // [!code highlight]

// Later, when needed:
array_foreach(_instances, function(_inst) {
    instance_destroy(_inst);
});
```
:::

---
### `.GetTilemap()`

> `payload.GetTilemap(layerName)` ➜ :Id.Tilemap: or :Undefined:

Returns the ID of the created Tilemap from the given layer name, or :Undefined: if not found.

| Parameter | Type | Description |
| --- | --- | --- |
| `layerName` | :String: | The Tile layer name to search for |

:::code-group
```js [Example]
// Gets the created Tilemap ID from the "TilesCollision" layer
// to use for collision:
var _collisionTilemap = payload.GetTilemap("TilesCollision"); // [!code highlight]
if (_collisionTilemap != undefined) {
    array_push(global.collisionTilemaps, _collisionTilemap);
}
```
:::

---
### `.GetTilemaps()`

> `payload.GetTilemaps()` ➜ :Array: of :Id.Tilemap:

Returns an array of created Tilemaps.

:::code-group
```js [Example]
// Gets an array of created Tilemaps and targets a random one:
var _tilemaps = payload.GetTilemaps(); // [!code highlight]
var _randomTilemap = script_execute_ext(choose, _tilemaps);
```
:::

---
### `.GetSprite()`

> `payload.GetSprite(roomId)` ➜ :Id.Sprite: or :Undefined:

Returns the ID of the created Sprite matching the given room ID if found, or :Undefined: if not found.

| Parameter | Type | Description |
| --- | --- | --- |
| `roomId` | :String: | The Sprite room ID to search for |

:::code-group
```js [Example]
// Gets the created Sprite ID using its "SpriteStar" room ID, and if found,
// rotates it randomly:
var _sprite = payload.GetSprite("SpriteStar"); // [!code highlight]
if (_sprite != undefined) {
    layer_sprite_angle(_sprite, irandom(360));
}
```
:::

---
### `.GetSprites()`

> `payload.GetSprites()` ➜ :Array: of :Id.Sprite:

Returns an array of created Sprites.

:::code-group
```js [Example]
// Gets an array of created Sprites and blends them red:
array_foreach(payload.GetSprites(), function(_sprite) { // [!code highlight]
    layer_sprite_blend(_sprite, c_red);
});
```
:::

---
### `.GetSequence()`

> `payload.GetSequence(roomId)` ➜ :Id.Sequence: or :Undefined:

Returns the created Sequence ID matching the given room ID if found, or :Undefined: if not found.

| Parameter | Type | Description |
| --- | --- | --- |
| `roomId` | :String: | The Sequence room ID to search for |

:::code-group
```js [Example]
// Gets the created Sequence ID using its "SequenceWindow" room ID, and if found,
// randomizes its playhead position:
var _sequence = payload.GetSequence("SequenceWindow"); // [!code highlight]
if (_sequence != undefined) {
    var _length = layer_sequence_get_length(_sequence);
    layer_sequence_headpos(_sequence, random(_length));
}
```
:::

---
### `.GetSequences()`

> `payload.GetSequences()` ➜ :Array: of :Id.Sequence: 

Returns an array of created Sequences.

:::code-group
```js [Example]
// Gets an array of created Sequences and randomizes their speed scales:
array_foreach(payload.GetSequences(), function(_sequence) { // [!code highlight]
    layer_sequence_speedscale(_sequence, random_range(0.75, 1.25));
});
```
:::

---
### `.GetParticleSystem()`

> `payload.GetParticleSystem(roomId)` ➜ :Id.ParticleSystem: or :Undefined:

Returns the ID of the created Particle System matching the given room ID if found, or :Undefined: if not found.

| Parameter | Type | Description |
| --- | --- | --- |
| `roomId` | :String: | The Particle System room ID to search for |

:::code-group
```js [Example]
// Gets the "Sparkles" Particle System, and if found, randomizes its color:
var _psSparkle = payload.GetParticleSystem("Sparkles"); // [!code highlight]
if (_psSparkle != undefined) {
    var _randomColor = make_color_hsv(irandom(0, 255), 200, 200);
    part_system_color(_psSparkle, _randomColor, 1);
}
```
:::

---
### `.GetParticleSystems()`

> `payload.GetParticleSystems()` ➜ :Array: of :Id.ParticleSystem:

Returns an array of created Particle Systems.

:::code-group
```js [Example]
// Gets all loaded Particle Systems and pre-updates them by 60 frames:
var _systems = payload.GetParticleSystems(); // [!code highlight]
if (array_length(_systems) > 0) {
    repeat (60) {
        array_foreach(_systems, function(_ps) {
            part_system_update(_ps);
        });
    }
}

```
:::

---
### `.GetText()`

> `payload.GetText(roomId)` ➜ :Id.Text: or :Undefined:

Returns the ID of the created Text matching the given room ID if found, or :Undefined: if not found.

| Parameter | Type | Description |
| --- | --- | --- |
| `roomId` | :String: | The Text room ID to search for |

:::code-group
```js [Example]
// Gets the created Text ID using its "TextTitle" room ID, and if found,
// randomizes its angle:
var _text = payload.GetText("TextTitle"); // [!code highlight]
if (_text != undefined) {
    layer_text_angle(_text, random(360));
}
```
:::

---
### `.GetTexts()`

> `payload.GetTexts()` ➜ :Array: of :Id.Text:

Returns an array of created Texts.

:::code-group
```js [Example]
// Gets an array of created Texts and randomizes their colors:
array_foreach(payload.GetTexts(), function(_text) { // [!code highlight]
    layer_text_color(_text, make_color_hsv(irandom(255), 200, 200));
});
```
:::

---
### `.GetBackground()`

> `payload.GetBackground(layerName)` ➜ :Id.Background: or :Undefined:

Returns the ID of the created Background matching the given layer name if found, or :Undefined: if not found.

| Parameter | Type | Description |
| --- | --- | --- |
| `layerName` | :String: | The Background layer name to search for |

:::code-group
```js [Example]
// Gets the created Background ID from the "BackgroundClouds" layer and if found,
// blends it orange:
var _bg = payload.GetBackground("BackgroundClouds"); // [!code highlight]
if (_bg != undefined) {
    layer_background_blend(_bg, c_orange);
}
```
:::

---
### `.GetBackgrounds()`

> `payload.GetBackgrounds()` ➜ :Array: of :Id.Background:

Returns an array of created Backgrounds.

:::code-group
```js [Example]
// Gets an array of created Backgrounds and randomizes their image indices:
array_foreach(payload.GetBackgrounds(), function(_bg) { // [!code highlight]
    var _frames = sprite_get_number(layer_background_get_sprite(_bg));
    layer_background_index(_bg, irandom(_frames - 1));
});
```
:::
# Getters

## Overview

This section covers two ways to retrieve created element IDs from :Payload:.
1. Individual ID `.Get<ElementType>` getters.
    * Instances, Sprites, Particle Systems and Sequences use their room IDs.
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

> `payload.GetInstance()` ➜ :Id.Instance: or :Noone:

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

> `payload.GetInstances()` ➜ :Array: of :Id.Instance:

Returns an array of created Instances.

:::code-group
```js [Example]
// Gets an array of created Instances and targets a random one:
var _instances = payload.GetInstances(); // [!code highlight]
var _randomInstance = script_execute_ext(choose, _instances);
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
    layer_sequence_speedscale(_sequence, random(0.75, 1.25));
});
```
:::

## `.GetParticleSystem()`

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

## `.GetParticleSystems()`

> `payload.GetParticleSystems()` ➜ :Array: of :Id.ParticleSystem:

Returns an array of created Particle Systems.

:::code-group
```js [Example]
// Gets all loaded Particle Systems and pre-updates them by 60 frames:
array_foreach(payload.GetParticleSystems(), function(_ps) { // [!code highlight]
    repeat (60) {
        part_system_update(_ps);
    }
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
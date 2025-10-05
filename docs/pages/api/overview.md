# API Overview

This section outlines the core GMRoomLoader APIs, organized into three main parts:
* :RoomLoader: is the central interface of the library, responsible for room :Data: handling, :Loading: and :Screenshotting:, :State: management, :Asset Type: and :Layer Name: filtering.
* :Payload: is returned from :RoomLoader.Load(): and is used to manage layer depths, retrieve loaded element IDs and cleaning up loaded contents.
* :Debug View: provides a quick way to test room loading through a :Debug Overlay: View.
* [Configuration](/pages/api/config) covers configuration macros for customizing various library behaviors.

---

All functionality in :RoomLoader: and :Payload: is exposed through public `PascalCase` methods - the intended way to interact with the library. No public variables are available.

Private methods and variables use the `__` prefix and should only be accessed if you know exactly what you're doing.

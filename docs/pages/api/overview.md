# API Overview

This section provides an overview of GMRoomLoader APIs. The library is organized into the following sections:
* :RoomLoader: is the core interface of the library. It handles everything related to room data, :Loading: and :Screenshotting:.
* :Payload: is returned from :Full Room Loading: methods. It's used for managing layer depths, fetching loaded element IDs and cleaning up loaded contents.
* [Configuration](/pages/api/config) covers configuration macros that allow you to customize numerous loading behaviors.

---

:RoomLoader: and :Payload: functionality is exposed entirely through public `PascalCase` methods, which are the intended way of working with the library. There are no public variables available.

Private methods and variables are prefixed with `__` and should not be accessed unless you know exactly what you're doing.

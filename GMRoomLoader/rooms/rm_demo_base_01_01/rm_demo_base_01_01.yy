{
  "resourceType": "GMRoom",
  "resourceVersion": "1.0",
  "name": "rm_demo_base_01_01",
  "creationCodeFile": "",
  "inheritCode": false,
  "inheritCreationOrder": false,
  "inheritLayers": false,
  "instanceCreationOrder": [
    {"name":"inst_2D7787CD","path":"rooms/rm_demo_base_01_01/rm_demo_base_01_01.yy",},
    {"name":"inst_56B9DD54","path":"rooms/rm_demo_base_01_01/rm_demo_base_01_01.yy",},
    {"name":"inst_2C16415","path":"rooms/rm_demo_base_01_01/rm_demo_base_01_01.yy",},
  ],
  "isDnd": false,
  "layers": [
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"units","depth":0,"effectEnabled":true,"effectType":null,"gridX":16,"gridY":16,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"instances":[
        {"resourceType":"GMRInstance","resourceVersion":"1.0","name":"inst_2D7787CD","colour":4294967295,"frozen":false,"hasCreationCode":false,"ignore":false,"imageIndex":0,"imageSpeed":1.0,"inheritCode":false,"inheritedItemId":null,"inheritItemSettings":false,"isDnd":false,"objectId":{"name":"obj_demo_base_unit","path":"objects/obj_demo_base_unit/obj_demo_base_unit.yy",},"properties":[
            {"resourceType":"GMOverriddenProperty","resourceVersion":"1.0","name":"","objectId":{"name":"obj_demo_base_unit","path":"objects/obj_demo_base_unit/obj_demo_base_unit.yy",},"propertyId":{"name":"vd_angle_to","path":"objects/obj_demo_base_unit/obj_demo_base_unit.yy",},"value":"-90",},
          ],"rotation":0.0,"scaleX":1.0,"scaleY":1.0,"x":48.0,"y":48.0,},
        {"resourceType":"GMRInstance","resourceVersion":"1.0","name":"inst_56B9DD54","colour":4294967295,"frozen":false,"hasCreationCode":false,"ignore":false,"imageIndex":0,"imageSpeed":1.0,"inheritCode":false,"inheritedItemId":null,"inheritItemSettings":false,"isDnd":false,"objectId":{"name":"obj_demo_base_unit","path":"objects/obj_demo_base_unit/obj_demo_base_unit.yy",},"properties":[
            {"resourceType":"GMOverriddenProperty","resourceVersion":"1.0","name":"","objectId":{"name":"obj_demo_base_unit","path":"objects/obj_demo_base_unit/obj_demo_base_unit.yy",},"propertyId":{"name":"vd_angle_to","path":"objects/obj_demo_base_unit/obj_demo_base_unit.yy",},"value":"270",},
            {"resourceType":"GMOverriddenProperty","resourceVersion":"1.0","name":"","objectId":{"name":"obj_demo_base_unit","path":"objects/obj_demo_base_unit/obj_demo_base_unit.yy",},"propertyId":{"name":"vd_angle_from","path":"objects/obj_demo_base_unit/obj_demo_base_unit.yy",},"value":"180",},
          ],"rotation":180.0,"scaleX":1.0,"scaleY":1.0,"x":176.0,"y":48.0,},
        {"resourceType":"GMRInstance","resourceVersion":"1.0","name":"inst_2C16415","colour":4294967295,"frozen":false,"hasCreationCode":false,"ignore":false,"imageIndex":0,"imageSpeed":1.0,"inheritCode":false,"inheritedItemId":null,"inheritItemSettings":false,"isDnd":false,"objectId":{"name":"obj_demo_base_unit","path":"objects/obj_demo_base_unit/obj_demo_base_unit.yy",},"properties":[
            {"resourceType":"GMOverriddenProperty","resourceVersion":"1.0","name":"","objectId":{"name":"obj_demo_base_unit","path":"objects/obj_demo_base_unit/obj_demo_base_unit.yy",},"propertyId":{"name":"vd_angle_from","path":"objects/obj_demo_base_unit/obj_demo_base_unit.yy",},"value":"20",},
            {"resourceType":"GMOverriddenProperty","resourceVersion":"1.0","name":"","objectId":{"name":"obj_demo_base_unit","path":"objects/obj_demo_base_unit/obj_demo_base_unit.yy",},"propertyId":{"name":"vd_angle_to","path":"objects/obj_demo_base_unit/obj_demo_base_unit.yy",},"value":"-30",},
          ],"rotation":0.0,"scaleX":1.0,"scaleY":1.0,"x":32.0,"y":144.0,},
      ],"layers":[],"properties":[],"userdefinedDepth":false,"visible":true,},
    {"resourceType":"GMRTileLayer","resourceVersion":"1.1","name":"tiles_top","depth":100,"effectEnabled":true,"effectType":null,"gridX":16,"gridY":16,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"properties":[],"tiles":{"SerialiseHeight":7,"SerialiseWidth":7,"TileCompressedData":[
-8,-2147483648,3,0,-2147483648,187,-10,
-2147483648,1,0,-3,-2147483648,1,0,
-10,-2147483648,1,239,-12,-2147483648,],"TileDataFormat":1,},"tilesetId":{"name":"ts_base","path":"tilesets/ts_base/ts_base.yy",},"userdefinedDepth":false,"visible":true,"x":0,"y":0,},
    {"resourceType":"GMRTileLayer","resourceVersion":"1.1","name":"tiles_walls","depth":200,"effectEnabled":true,"effectType":null,"gridX":16,"gridY":16,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"properties":[],"tiles":{"SerialiseHeight":7,"SerialiseWidth":7,"TileCompressedData":[
15,117,122,517,204,517,150,
118,123,0,1073742352,505,1879048720,0,
146,490,-5,0,29,144,204,
131,345,346,347,0,0,490,
0,0,99,0,0,117,149,
478,0,0,504,133,146,144,
119,118,0,117,119,145,],"TileDataFormat":1,},"tilesetId":{"name":"ts_base","path":"tilesets/ts_base/ts_base.yy",},"userdefinedDepth":false,"visible":true,"x":0,"y":0,},
    {"resourceType":"GMRTileLayer","resourceVersion":"1.1","name":"tiles_floor","depth":300,"effectEnabled":true,"effectType":null,"gridX":16,"gridY":16,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"properties":[],"tiles":{"SerialiseHeight":7,"SerialiseWidth":7,"TileCompressedData":[
-12,99,1,97,-3,99,1,
97,-5,99,1,97,-3,99,
1,97,-10,99,1,97,-11,
99,],"TileDataFormat":1,},"tilesetId":{"name":"ts_base","path":"tilesets/ts_base/ts_base.yy",},"userdefinedDepth":false,"visible":true,"x":0,"y":0,},
  ],
  "parent": {
    "name": "01",
    "path": "folders/Demo/02 - Base/Rooms/General/Rooms/01.yy",
  },
  "parentRoom": null,
  "physicsSettings": {
    "inheritPhysicsSettings": false,
    "PhysicsWorld": false,
    "PhysicsWorldGravityX": 0.0,
    "PhysicsWorldGravityY": 10.0,
    "PhysicsWorldPixToMetres": 0.1,
  },
  "roomSettings": {
    "Height": 224,
    "inheritRoomSettings": false,
    "persistent": false,
    "Width": 224,
  },
  "sequenceId": null,
  "views": [
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
  ],
  "viewSettings": {
    "clearDisplayBuffer": true,
    "clearViewBackground": false,
    "enableViews": false,
    "inheritViewSettings": false,
  },
  "volume": 1.0,
}
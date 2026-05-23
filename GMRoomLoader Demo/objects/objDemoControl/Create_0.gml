EVENT_METHOD;

randomize();
texture_prefetch("Default");

reloader = new DemoReloader();
pool = [
	new DemoGeneral(),
	new DemoInstances(),
	new DemoTilemaps(),
	new DemoMergeTilemaps(),
	new DemoScreenshots(),
	new DemoBase(),
];
n = array_length(pool);
index = array_length(pool) - 1;
prevIndex = 0;

x1 = undefined;
y1 = undefined;
x2 = undefined;
y2 = undefined;
centerX = undefined;
centerY = undefined;
w = undefined;
h = undefined;

Change(index);

layer_x("BackPattern", irandom(128));
layer_y("BackPattern", irandom(128));

EVENT_METHOD;

sprite_index = asset_get_index($"spr_demo_base_unit_0{irandom_range(1, 8)}");
image_index = irandom(image_number - 1);
duration = (FPS * irandom_range(2, 3));
t = irandom(duration);

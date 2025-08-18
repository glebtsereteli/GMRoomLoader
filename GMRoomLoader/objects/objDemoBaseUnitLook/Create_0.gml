event_inherited();

duration = irandom_range(FPS * 2, FPS * 3);
t = irandom(duration);

event_perform(ev_step, ev_step_normal);

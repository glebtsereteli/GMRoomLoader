
#macro TILE_SIZE 64
#macro TILE_HALFSIZE (TILE_SIZE / 2)

function Mod2(_value, _mod) {
    return (_value - (floor(_value / _mod) * _mod));
}


function Sine(_time, _period, _amplitude) {
	static _2pi = 2 * pi;
    return (sin(_time * _2pi / _period) * _amplitude);
}

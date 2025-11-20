extends Camera2D

var _rng = RandomNumberGenerator.new()
var _shake_amount = 0.0
var _shake_duration = 0.0

func shake(amount, duration):
	_shake_amount = amount
	_shake_duration = duration

func _process(delta):
	if _shake_duration > 0:
		_shake_duration -= delta
		if _shake_duration <= 0:
			offset = Vector2.ZERO
		else:
			offset.x = _rng.randf_range(-_shake_amount, _shake_amount)
			offset.y = _rng.randf_range(-_shake_amount, _shake_amount)
extends Node2D

signal scored

const MOVE_SPEED = 120.0 # Reduced from 150.0

func _process(delta):
	position.x -= MOVE_SPEED * delta

func _on_score_area_body_entered(body):
	if body is Player:
		emit_signal("scored")
		# Disable the area so it doesn't score again
		$ScoreArea.monitoring = false

func stop():
	set_process(false)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
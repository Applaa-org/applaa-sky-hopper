extends Node2D

signal scored

var move_speed = 120.0

@onready var top_pipe = $TopPipe
@onready var bottom_pipe = $BottomPipe
@onready var score_area_shape = $ScoreArea/CollisionShape2D

func _process(delta):
	position.x -= move_speed * delta

func set_gap(gap_size):
	var half_gap = gap_size / 2
	top_pipe.position.y = -half_gap - (top_pipe.get_node("CollisionShape2D").shape.size.y / 2)
	bottom_pipe.position.y = half_gap + (bottom_pipe.get_node("CollisionShape2D").shape.size.y / 2)
	score_area_shape.shape.size.y = gap_size

func _on_score_area_body_entered(body):
	if body is Player:
		emit_signal("scored")
		$ScoreArea.monitoring = false

func stop():
	set_process(false)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
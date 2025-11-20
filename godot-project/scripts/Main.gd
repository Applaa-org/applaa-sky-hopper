extends Node

@export var obstacle_scene: PackedScene

@onready var player = $Player
@onready var obstacle_timer = $ObstacleTimer
@onready var hud = $HUD
@onready var ground = $Ground
@onready var parallax_background = $ParallaxBackground

var score = 0
var is_playing = false

func _ready():
	hud.update_score(score)
	hud.show_start_screen()
	player.hit.connect(_on_player_hit)

func new_game():
	score = 0
	is_playing = true
	player.start()
	hud.update_score(score)
	hud.show_gameplay_ui()
	obstacle_timer.start()
	
	# Clear any existing obstacles
	for n in get_tree().get_nodes_in_group("obstacles"):
		n.queue_free()

func _on_obstacle_timer_timeout():
	var obstacle = obstacle_scene.instantiate()
	obstacle.position.x = get_viewport_rect().size.x + 100
	# Randomize vertical position of the gap
	obstacle.position.y = randf_range(200, 550)
	add_child(obstacle)
	obstacle.add_to_group("obstacles")

func _on_player_hit():
	is_playing = false
	obstacle_timer.stop()
	ground.stop()
	parallax_background.stop()
	
	for n in get_tree().get_nodes_in_group("obstacles"):
		n.set_process(false)
		
	hud.show_game_over_screen(score)

func _on_score_area_body_entered(body):
	if body is Player:
		score += 1
		hud.update_score(score)
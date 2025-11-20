extends Node

@export var obstacle_scene: PackedScene

@onready var player = $Player
@onready var obstacle_timer = $ObstacleTimer
@onready var hud = $HUD
@onready var ground1 = $Ground1
@onready var ground2 = $Ground2
@onready var level_manager = $LevelManager
@onready var camera = $Camera2D

var scroll_speed = 150.0
var score = 0
var ground_width = 0

func _ready():
	hud.start_game.connect(new_game)
	player.hit.connect(_on_player_hit)
	
	hud.show_start_screen()
	set_physics_process(false)
	ground_width = ground1.get_node("ColorRect").size.x

func new_game():
	score = 0
	level_manager.reset()
	update_level_parameters()
	
	player.start()
	hud.update_score(score)
	hud.update_level(level_manager.get_level_number())
	hud.show_gameplay_ui()
	
	obstacle_timer.start()
	set_physics_process(true)
	
	ground1.position.x = 0
	ground2.position.x = ground_width
	
	for n in get_tree().get_nodes_in_group("obstacles"):
		n.queue_free()

func update_level_parameters():
	var level_data = level_manager.get_current_level_data()
	scroll_speed = level_data.scroll_speed
	obstacle_timer.wait_time = level_data.spawn_time

func _physics_process(delta):
	ground1.position.x -= scroll_speed * delta
	ground2.position.x -= scroll_speed * delta
	
	if ground1.position.x < -ground_width:
		ground1.position.x += 2 * ground_width
	if ground2.position.x < -ground_width:
		ground2.position.x += 2 * ground_width

func _on_obstacle_timer_timeout():
	var level_data = level_manager.get_current_level_data()
	var obstacle = obstacle_scene.instantiate()
	obstacle.position.x = get_viewport_rect().size.x + 100
	obstacle.position.y = randf_range(250, 500)
	obstacle.move_speed = level_data.scroll_speed
	obstacle.set_gap(level_data.pipe_gap)
	obstacle.scored.connect(_on_obstacle_scored)
	add_child(obstacle)
	obstacle.add_to_group("obstacles")

func _on_player_hit():
	camera.shake(15, 0.3)
	set_physics_process(false)
	obstacle_timer.stop()
	
	for n in get_tree().get_nodes_in_group("obstacles"):
		n.stop()
		
	hud.show_game_over_screen(score)

func _on_obstacle_scored():
	score += 1
	hud.update_score(score)
	
	var level_data = level_manager.get_current_level_data()
	if score >= level_data.score_to_advance:
		if level_manager.advance_level():
			update_level_parameters()
			hud.update_level(level_manager.get_level_number())
			hud.show_level_complete()
		else:
			pass
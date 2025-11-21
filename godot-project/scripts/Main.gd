extends Node

@export var obstacle_scene: PackedScene

@onready var player = $Player
@onready var obstacle_timer = $ObstacleTimer
@onready var hud = $HUD
@onready var ground1 = $Ground1
@onready var ground2 = $Ground2
@onready var level_manager = $LevelManager

enum State { GET_READY, PLAYING, DEAD }
var state = GET_READY

var ground_width = 0
var time_passed = 0.0

func _ready():
	player.hit.connect(_on_player_hit)
	ground_width = ground1.get_node("ColorRect").size.x
	new_game()

func _unhandled_input(event):
	if state == GET_READY and event.is_action_pressed("flap"):
		state = PLAYING
		player.set_active(true)
		obstacle_timer.start()
		hud.hide_message()

func new_game():
	state = GET_READY
	GameManager.current_score = 0
	level_manager.reset()
	update_level_parameters()
	
	player.start()
	hud.update_score(GameManager.current_score)
	hud.update_level(level_manager.get_level_number())
	hud.show_get_ready()
	
	obstacle_timer.stop()
	set_physics_process(true)
	
	ground1.position.x = 0
	ground2.position.x = ground_width
	
	for n in get_tree().get_nodes_in_group("obstacles"):
		n.queue_free()

func update_level_parameters():
	var level_data = level_manager.get_current_level_data()
	obstacle_timer.wait_time = level_data.spawn_time

func _physics_process(delta):
	match state:
		GET_READY:
			# Hover the player up and down
			time_passed += delta
			player.position.y = 350 + sin(time_passed * 3.0) * 15
		PLAYING:
			# Scroll the ground
			var scroll_speed = level_manager.get_current_level_data().scroll_speed
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
	state = DEAD
	set_physics_process(false)
	obstacle_timer.stop()
	
	for n in get_tree().get_nodes_in_group("obstacles"):
		n.stop()
		
	get_tree().change_scene_to_file("res://scenes/DefeatScreen.tscn")

func _on_obstacle_scored():
	GameManager.current_score += 1
	hud.update_score(GameManager.current_score)
	
	var level_data = level_manager.get_current_level_data()
	if GameManager.current_score >= level_data.score_to_advance:
		if level_manager.advance_level():
			update_level_parameters()
			hud.update_level(level_manager.get_level_number())
			hud.show_level_complete()
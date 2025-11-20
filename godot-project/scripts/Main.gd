extends Node

@export var obstacle_scene: PackedScene

@onready var player = $Player
@onready var obstacle_timer = $ObstacleTimer
@onready var hud = $HUD
@onready var ground1 = $Ground1
@onready var ground2 = $Ground2

const SCROLL_SPEED = 150.0

var score = 0
var ground_width = 0

func _ready():
	# Connect to the HUD's signal. This is the core fix.
	hud.start_game.connect(new_game)
	
	hud.update_score(score)
	hud.show_start_screen()
	set_physics_process(false)
	ground_width = ground1.get_node("ColorRect").size.x

func new_game():
	score = 0
	player.start()
	hud.update_score(score)
	hud.show_gameplay_ui()
	obstacle_timer.start()
	set_physics_process(true)
	
	ground1.position.x = 0
	ground2.position.x = ground_width
	
	for n in get_tree().get_nodes_in_group("obstacles"):
		n.queue_free()

func _physics_process(delta):
	ground1.position.x -= SCROLL_SPEED * delta
	ground2.position.x -= SCROLL_SPEED * delta
	
	if ground1.position.x < -ground_width:
		ground1.position.x += 2 * ground_width
	if ground2.position.x < -ground_width:
		ground2.position.x += 2 * ground_width

func _on_obstacle_timer_timeout():
	var obstacle = obstacle_scene.instantiate()
	obstacle.position.x = get_viewport_rect().size.x + 100
	obstacle.position.y = randf_range(200, 550)
	obstacle.scored.connect(_on_obstacle_scored)
	add_child(obstacle)
	obstacle.add_to_group("obstacles")

func _on_player_hit():
	set_physics_process(false)
	obstacle_timer.stop()
	
	for n in get_tree().get_nodes_in_group("obstacles"):
		n.stop()
		
	hud.show_game_over_screen(score)
	player.hit.connect(_on_player_hit)

func _on_obstacle_scored():
	score += 1
	hud.update_score(score)
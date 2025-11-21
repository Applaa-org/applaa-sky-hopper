extends Control

@onready var player = $Player

var time_passed = 0.0
var initial_player_pos

func _ready():
	# Store the player's starting position from the editor
	initial_player_pos = player.position
	# The player's physics are off by default, so it won't fall
	# and its input is not processed until the game starts.

func _process(delta):
	# Animate the player's vertical position using a sine wave for a smooth hover
	time_passed += delta
	player.position.y = initial_player_pos.y + sin(time_passed * 3.0) * 15

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
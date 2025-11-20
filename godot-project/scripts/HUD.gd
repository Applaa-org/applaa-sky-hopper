extends CanvasLayer

@onready var score_label = $ScoreLabel
@onready var message_label = $MessageLabel
@onready var start_button = $StartButton
@onready var final_score_label = $GameOver/FinalScoreLabel
@onready var game_over_container = $GameOver

signal start_game

func _ready():
	start_button.pressed.connect(_on_start_button_pressed)
	game_over_container.get_node("RestartButton").pressed.connect(_on_start_button_pressed)

func update_score(new_score):
	score_label.text = str(new_score)

func show_start_screen():
	message_label.text = "Sky Hopper"
	message_label.show()
	start_button.text = "Start"
	start_button.show()
	score_label.hide()
	game_over_container.hide()

func show_gameplay_ui():
	message_label.hide()
	start_button.hide()
	score_label.show()
	game_over_container.hide()

func show_game_over_screen(final_score):
	message_label.text = "Game Over"
	message_label.show()
	final_score_label.text = "Score: " + str(final_score)
	game_over_container.show()
	score_label.hide()
	start_button.hide()

func _on_start_button_pressed():
	get_tree().get_root().get_node("Main").new_game()
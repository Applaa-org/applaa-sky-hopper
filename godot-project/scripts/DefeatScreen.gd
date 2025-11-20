extends Control

@onready var final_score_label = $VBoxContainer/FinalScoreLabel

func _ready():
	final_score_label.text = "Score: " + str(GameManager.current_score)

func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/StartScreen.tscn")
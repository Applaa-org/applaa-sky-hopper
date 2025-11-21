extends CanvasLayer

@onready var score_label = $ScoreLabel
@onready var level_label = $LevelLabel
@onready var message_label = $MessageLabel
@onready var level_complete_timer = $LevelCompleteTimer

func _ready():
	level_complete_timer.timeout.connect(hide_message)

func update_score(new_score):
	score_label.text = str(new_score)

func update_level(level_num):
	level_label.text = "Level: " + str(level_num)

func show_level_complete():
	message_label.text = "Level Complete!"
	message_label.show()
	level_complete_timer.start()

func show_get_ready():
	message_label.text = "Get Ready!"
	message_label.show()

func hide_message():
	message_label.hide()
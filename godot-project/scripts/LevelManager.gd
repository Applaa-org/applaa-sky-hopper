extends Node

var levels = [
	# Level 1
	{"scroll_speed": 120.0, "pipe_gap": 250.0, "spawn_time": 2.0, "score_to_advance": 5},
	# Level 2
	{"scroll_speed": 150.0, "pipe_gap": 220.0, "spawn_time": 1.7, "score_to_advance": 10},
	# Level 3
	{"scroll_speed": 180.0, "pipe_gap": 200.0, "spawn_time": 1.5, "score_to_advance": 999} # Last level
]

var current_level_index = 0

func get_current_level_data():
	return levels[current_level_index]

func advance_level():
	if not is_last_level():
		current_level_index += 1
		return true
	return false

func reset():
	current_level_index = 0

func is_last_level():
	return current_level_index >= len(levels) - 1

func get_level_number():
	return current_level_index + 1
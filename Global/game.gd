extends Node

var can_player_move: bool = true
var game_over: bool = false
var level_success: bool = false
var can_sonic_move: bool = true

func _process(_delta: float) -> void:
	if level_success or game_over:
		can_player_move = false
		can_sonic_move = false

func start_level():
	game_over = false
	level_success = false
	can_player_move = false
	can_sonic_move = false
	# start countdown
	AudioController.play_starting_sound()
	# wait for 2 seconds
	await get_tree().create_timer(3.0).timeout
	can_player_move = true
	can_sonic_move = true

func restart():
	game_over = false
	level_success = false
	can_player_move = true
	can_sonic_move = true
	get_tree().reload_current_scene()

func exit():
	get_tree().quit()

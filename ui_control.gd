extends Control


@onready var game_over_screen = $GameOverScreen;
@onready var success_screen = $SuccessScreen;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_over_screen.visible = false
	success_screen.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Game.level_success:
		success_screen.visible = true

	if Game.game_over:
		game_over_screen.visible = true


func _on_restart_pressed() -> void:
	Game.can_player_move = true
	Game.can_sonic_move = true
	Game.game_over = false
	get_tree().reload_current_scene()


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_next_level_pressed() -> void:
	pass # Replace with function body.

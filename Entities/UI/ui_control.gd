extends Control


@onready var game_over_screen = $GameOverScreen;
@onready var success_screen = $SuccessScreen;
@onready var text_box = $TextBox;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  visible = true
  game_over_screen.visible = false
  success_screen.visible = false
  text_box = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
  if Game.level_success:
    success_screen.visible = true

  if Game.game_over:
    game_over_screen.visible = true


func _on_restart_pressed() -> void:
  Game.restart()


func _on_exit_pressed() -> void:
  Game.exit()


func _on_next_level_pressed() -> void:
  pass # Replace with function body.

extends Node

var can_player_move: bool = true
var game_over: bool = false
var level_success: bool = false
var can_sonic_move: bool = true

# Transition system
var transition_overlay: ColorRect
var fade_duration: float = 0.5

func _ready() -> void:
  pass

func _process(_delta: float) -> void:
  if level_success or game_over:
    can_player_move = false
    can_sonic_move = false

func start_level():
  game_over = false
  level_success = false
  can_player_move = true
  can_sonic_move = true

func next_level():
  # get current level name
  var current_scene = get_tree().current_scene.name
  if current_scene == "LevelPrologue":
    get_tree().change_scene_to_file("res://Levels/Level1.tscn")
  elif current_scene == "Level1":
    get_tree().change_scene_to_file("res://Levels/Level2.tscn")
  elif current_scene == "Level2":
    get_tree().change_scene_to_file("res://Levels/Level3.tscn")
  elif current_scene == "Level3":
    get_tree().change_scene_to_file("res://Levels/LevelFinal.tscn")

func main_menu():
  get_tree().change_scene_to_file("res://Levels/MainMenu.tscn")

func restart():
  game_over = false
  level_success = false
  can_player_move = true
  can_sonic_move = true
  get_tree().reload_current_scene()

func exit():
  get_tree().quit()

extends Node

@onready var levelPrologue = preload("res://Levels/LevelPrologue.tscn")
@onready var level1 = preload("res://Levels/Level1.tscn")
@onready var level2 = preload("res://Levels/Level2.tscn")
@onready var level3 = preload("res://Levels/Level3.tscn")
@onready var levelFinal = preload("res://Levels/LevelFinal.tscn")

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

func restart():
  game_over = false
  level_success = false
  can_player_move = true
  can_sonic_move = true
  get_tree().reload_current_scene()

func exit():
  get_tree().quit()

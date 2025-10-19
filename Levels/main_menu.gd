extends Node2D

func _on_exit_pressed() -> void:
  Game.exit()

func _on_start_game_pressed() -> void:
  get_tree().change_scene_to_file("res://Levels/LevelPrologue.tscn")

func _on_test_level_pressed() -> void:
  get_tree().change_scene_to_file("res://Levels/TestLevel.tscn")

func _on_credits_pressed() -> void:
  pass

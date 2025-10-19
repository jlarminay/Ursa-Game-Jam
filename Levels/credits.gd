extends Node2D

@onready var child_labels: Node2D = $Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  child_labels.global_position.y -= 1



func _on_area_2d_area_entered(area: Area2D) -> void:
  print("pls")
  get_tree().change_scene_to_file("res://Levels/MainMenu.tscn")

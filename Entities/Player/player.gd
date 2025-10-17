extends CharacterBody2D

@export var SPEED:int = 300

func _physics_process(_delta: float) -> void:
  var vector = Vector2(
    Input.get_action_strength("Right") - Input.get_action_strength("Left"),
    Input.get_action_strength("Down") - Input.get_action_strength("Up")
  ).normalized()

  if Game.can_player_move:
    velocity = vector * SPEED
    move_and_slide()

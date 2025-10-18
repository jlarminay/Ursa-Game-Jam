extends CharacterBody2D

@export var SPEED: int = 300
@onready var player_camera: Camera2D = $PlayerCamera

func _ready() -> void:
  # Player camera starts disabled - path camera will activate it
  if player_camera:
    player_camera.enabled = false

func _process(_delta: float) -> void:
  var vector = Vector2(
    Input.get_action_strength("Right") - Input.get_action_strength("Left"),
    Input.get_action_strength("Down") - Input.get_action_strength("Up")
  ).normalized()

  if Game.can_player_move:
    velocity = vector * SPEED
    move_and_slide()

func get_player_camera() -> Camera2D:
  """Returns the player's camera for external access"""
  return player_camera

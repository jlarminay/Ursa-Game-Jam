extends Area2D

@export var line: Line2D
@export var speed: float = 100.0

var player: CharacterBody2D
var current_point_index: int = 1

func _ready() -> void:
  # Find the player by node name
  player = get_tree().current_scene.find_child("Player", true, false)

  # Set up collision detection for game over
  body_entered.connect(_on_body_entered)

  # Start at point 0 (first point)
  if line and line.get_point_count() > 0:
    global_position = line.get_point_position(0)

func _process(delta: float) -> void:
  if not line or line.get_point_count() < 2:
    return

  patrol_along_line(delta)

func patrol_along_line(delta: float) -> void:
  # Get target point
  var target_position = line.get_point_position(current_point_index)

  # Move towards target
  global_position = global_position.move_toward(target_position, speed * delta)

  # Check if reached target
  if global_position.distance_to(target_position) < 1.0:
    # Move to next point (always forward)
    current_point_index += 1

    # Loop back to beginning when reaching the end
    if current_point_index >= line.get_point_count():
      current_point_index = 0

func _on_body_entered(body: Node) -> void:
  if body.name == "Player":
    Game.game_over = true

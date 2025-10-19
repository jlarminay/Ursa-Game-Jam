extends Area2D

@export var line: Line2D
@export var speed: float = 100.0
@export var reverse: bool = false
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var player: CharacterBody2D
var current_point_index: int

func _ready() -> void:
  line.visible = false

  # Find the player by node name
  player = get_tree().current_scene.find_child("Player", true, false)

  # Set up collision detection for game over
  body_entered.connect(_on_body_entered)

  # Set starting position based on reverse direction
  if line and line.get_point_count() > 0:
    if reverse:
      # Start at last point when reverse is true
      current_point_index = line.get_point_count() - 2
      global_position = line.to_global(line.get_point_position(line.get_point_count() - 1))
    else:
      # Start at first point when reverse is false
      current_point_index = 1
      global_position = line.to_global(line.get_point_position(0))

func _process(delta: float) -> void:
  if not line or line.get_point_count() < 2:
    return
  patrol_along_line(delta)

func patrol_along_line(delta: float) -> void:
  # Get target point and convert to global coordinates
  var local_target = line.get_point_position(current_point_index)
  var target_position = line.to_global(local_target)

  # Calculate movement direction for animation
  var movement_direction = (target_position - global_position).normalized()
  update_animation(movement_direction)

  # Move towards target
  global_position = global_position.move_toward(target_position, speed * delta)

  # Check if reached target
  if global_position.distance_to(target_position) < 1.0:
    # Move to next point based on reverse direction
    if reverse:
      # Moving backwards through points
      current_point_index -= 1
      # Loop to end when reaching the beginning
      if current_point_index < 0:
        current_point_index = line.get_point_count() - 1
    else:
      # Moving forwards through points
      current_point_index += 1
      # Loop back to beginning when reaching the end
      if current_point_index >= line.get_point_count():
        current_point_index = 0

func update_animation(direction: Vector2) -> void:
  if not animated_sprite:
    return

  # Determine which animation to play based on movement direction
  # Horizontal movement takes priority over vertical
  if abs(direction.x) > abs(direction.y):
    animated_sprite.play("runSide")
    # Flip sprite based on direction (fixed)
    animated_sprite.flip_h = direction.x > 0 # Flip when moving right
  elif direction.y > 0:
    animated_sprite.play("runDown")
    animated_sprite.flip_h = false
  else:
    animated_sprite.play("runUp")
    animated_sprite.flip_h = false

func _on_body_entered(body: Node) -> void:
  if body.name == "Player":
    Game.game_over = true

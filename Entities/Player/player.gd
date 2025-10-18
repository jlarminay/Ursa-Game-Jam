extends CharacterBody2D

@export var SPEED: int = 300
@onready var player_camera: Camera2D = $PlayerCamera
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var held_item: String = "None"
var item_scene = preload("res://Entities/Item/Item.tscn")

# Animation state
var last_direction: String = "Down" # Down, Up, Side
var current_action: String = "idle" # idle, run

func _ready() -> void:
  pass

func _process(_delta: float) -> void:
  if Input.is_action_pressed("Drop") && not held_item == "None":
    var item_instance = item_scene.instantiate()
    get_tree().current_scene.add_child(item_instance)
    item_instance.item = held_item
    item_instance.global_position = global_position
    item_instance.recently_dropped = true
    held_item = "None"

  var vector = Vector2(
    Input.get_action_strength("Right") - Input.get_action_strength("Left"),
    Input.get_action_strength("Down") - Input.get_action_strength("Up")
  ).normalized()

  if Game.can_player_move:
    velocity = vector * SPEED
    move_and_slide()

    # Update direction and action based on movement
    update_direction(vector)
    current_action = "run" if vector != Vector2.ZERO else "idle"
  else:
    current_action = "idle"

  # Update animation
  play_animation()

func update_direction(movement_vector: Vector2) -> void:
  if movement_vector == Vector2.ZERO:
    return

  # Horizontal movement takes priority
  if abs(movement_vector.x) > abs(movement_vector.y):
    last_direction = "Side"
    animated_sprite.flip_h = movement_vector.x < 0
  elif movement_vector.y > 0:
    last_direction = "Down"
    animated_sprite.flip_h = false
  else:
    last_direction = "Up"
    animated_sprite.flip_h = false

func play_animation() -> void:
  if not animated_sprite:
    return

  var animation_name = current_action + last_direction

  # Check if animation exists before playing
  if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation(animation_name):
    animated_sprite.play(animation_name)

func set_action(action: String) -> void:
  """Set the current action"""
  current_action = action
  play_animation()

func get_player_camera() -> Camera2D:
  """Returns the player's camera for external access"""
  return player_camera

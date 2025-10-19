extends CharacterBody2D

signal item_dropped(item_instance: Node2D)

@onready var player_camera: Camera2D = $PlayerCamera
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var text_box: Control = $TextBox
@onready var hud_item: Area2D = $HUD/Item
var held_item: String = "None"
var item_scene = preload("res://Entities/Item/Item.tscn")
var speed: int = 150
var dead_animation_played: bool = false

# Animation state
var last_direction: String = "Down" # Down, Up, Side
var current_action: String = "idle" # idle, run

func _ready() -> void:
  text_box.visible = false
  hud_item.visible = false

func _process(_delta: float) -> void:
  # Check for game over state
  if Game.game_over and not dead_animation_played:
    dead_animation_played = true
    last_direction = ""
    current_action = "dead"
    play_animation()
    return

  if Input.is_action_pressed("Drop") && not held_item == "None":
    var item_instance = item_scene.instantiate()
    item_instance.item = held_item
    item_instance.global_position = global_position
    item_instance.recently_dropped = true
    get_tree().current_scene.add_child(item_instance)
    held_item = "None"
    item_dropped.emit(item_instance)

  var vector = Vector2(
    Input.get_action_strength("Right") - Input.get_action_strength("Left"),
    Input.get_action_strength("Down") - Input.get_action_strength("Up")
  ).normalized()

  if Game.can_player_move:
    velocity = vector * speed
    move_and_slide()

    # Update direction and action based on movement
    update_direction(vector)
    current_action = "run" if vector != Vector2.ZERO else "idle"
  else:
    current_action = "idle"

  # Update animation
  play_animation()
  update_held_item_hud()

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

  # Special case for dead animation - don't append direction
  if current_action == "dead":
    animation_name = "dead"

  # Check if animation exists before playing
  if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation(animation_name):
    animated_sprite.play(animation_name)

func set_action(action: String) -> void:
  """Set the current action"""
  current_action = action
  play_animation()

func _on_animated_sprite_2d_animation_finished() -> void:
  print("Animation finished: ", current_action)
  if current_action == "dead":
    # Stop the animation by setting speed to 0
    animated_sprite.speed_scale = 0

func update_held_item_hud() -> void:
  """Update the HUD to show the currently held item"""
  if not hud_item:
    return

  if held_item != "None":
    hud_item.visible = true
    hud_item.item = held_item
  else:
    hud_item.visible = false

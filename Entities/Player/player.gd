extends CharacterBody2D

signal item_dropped(item_instance: Node2D)

@export var sound_walking: AudioStream
@export var sound_hit: AudioStream
@export var sound_pickup: AudioStream
@export var sound_drop: AudioStream
@export var sound_game_over: AudioStream

@onready var sound_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var player_camera: Camera2D = $PlayerCamera
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var text_box: Control = $TextBox
@onready var hud_item: Area2D = $HUD/Item
@onready var crown: Sprite2D = $Crown
var held_item: String = "None"
var item_scene = preload("res://Entities/Item/Item.tscn")
var speed: int = 150
var dead_animation_played: bool = false
var block_animation_update: bool = false

# Animation state
var last_direction: String = "Down" # Down, Up, Side
var current_action: String = "idle" # idle, run

func _ready() -> void:
  crown.visible = false
  text_box.visible = false
  hud_item.visible = false

func _process(_delta: float) -> void:
  # Check for game over state
  if Game.game_over and not dead_animation_played:
    dead_animation_played = true
    last_direction = ""
    current_action = "dead"
    play_animation()
    # stop all music and play game over sound
    get_tree().current_scene.find_child("MusicPlayer", true, false).stop()
    sound_player.stream = sound_game_over
    sound_player.play()
    return

  # Drop item
  if Input.is_action_pressed("Drop") and held_item != "None":
    play_sound(sound_drop)
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

  var was_idle = current_action == "idle"

  if Game.can_player_move:
    velocity = vector * speed
    move_and_slide()

    # Update direction and action based on movement
    update_direction(vector)
    current_action = "run" if vector != Vector2.ZERO else "idle"
  else:
    current_action = "idle"

  # Play walking sound when starting to move
  if was_idle and current_action == "run":
    play_sound(sound_walking)

  if not block_animation_update:
    play_animation()
  update_held_item_hud()
func play_sound(stream: AudioStream) -> void:
  if sound_player and stream:
    sound_player.stream = stream
    sound_player.play()

func on_player_hit() -> void:
  # Call this when the player is hit
  play_sound(sound_hit)

func on_item_pickup(item_name: String) -> void:
  # Call this when the player picks up an item
  held_item = item_name
  play_sound(sound_pickup)
  update_held_item_hud()

func remove_item() -> void:
  # Remove the currently held item without dropping it
  held_item = "None"
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

func play_animation(force: bool = false) -> void:
  if not animated_sprite:
    return
  if block_animation_update and not force:
    return

  var animation_name = current_action + last_direction

  # Special case for dead animation - don't append direction
  if current_action == "dead":
    animation_name = "dead"

  # Check if animation exists before playing
  print("Playing animation: ", animation_name) # --- IGNORE ---
  if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation(animation_name):
    animated_sprite.play(animation_name)

func set_action(action: String) -> void:
  """Set the current action"""
  current_action = action
  play_animation()

func update_held_item_hud() -> void:
  """Update the HUD to show the currently held item"""
  if not hud_item:
    return

  if held_item != "None":
    hud_item.visible = true
    hud_item.item = held_item
  else:
    hud_item.visible = false

func show_crown() -> void:
  """Make the crown visible on the player"""
  crown.visible = true

func play_cutting_animation() -> void:
  """Play the cutting animation twice, with sound, and return when done (use with await)"""
  block_animation_update = true
  last_direction = "Down"
  current_action = "axe"
  for i in range(2):
    play_animation(true)
    play_sound(sound_hit)
    await get_tree().create_timer(1.3).timeout # short delay to separate sounds
  animated_sprite.stop()
  block_animation_update = false

extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var player: CharacterBody2D
var detection_distance: float = 100.0
var fly_speed: float = 200.0
var fly_duration: float = 3.0

var is_flying: bool = false
var fly_direction: Vector2
var fly_timer: float = 0.0

func _ready() -> void:
  player = get_tree().current_scene.find_child("Player", true, false)

  # Start with idle animation
  if animated_sprite:
    animated_sprite.play("idle")

func _process(delta: float) -> void:
  if is_flying:
    # Fly away behavior
    fly_away(delta)
  elif player:
    # Check for player detection
    check_player_detection()

func check_player_detection() -> void:
  var distance_to_player = global_position.distance_to(player.global_position)
  if distance_to_player < detection_distance:
    start_flying()

func start_flying() -> void:
  if is_flying:
    return

  is_flying = true
  fly_timer = fly_duration

  # Calculate direction away from player with random offset
  var direction_from_player = (global_position - player.global_position).normalized()
  var random_offset = Vector2(randf_range(-0.5, 0.5), randf_range(-0.5, 0.5))
  fly_direction = (direction_from_player + random_offset).normalized()

  # Switch to fly animation
  if animated_sprite:
    animated_sprite.play("fly")

func fly_away(delta: float) -> void:
  # Move in fly direction
  global_position += fly_direction * fly_speed * delta

  # Update timer
  fly_timer -= delta

  # Delete after timer expires
  if fly_timer <= 0:
    queue_free()

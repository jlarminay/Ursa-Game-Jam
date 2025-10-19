extends Node2D

@export var line: Line2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var speed: int = 200
var index: int = 1

# Animation state
var last_direction: String = "Side" # Up, Down, Side
var velocity: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  line.visible = false
  global_position = line.get_point_position(0)
  # Start with idle animation
  play_animation()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  if not Game.can_sonic_move:
    velocity = Vector2.ZERO
    play_animation()
    return

  var target: Vector2 = line.get_point_position(index)
  var old_position = global_position

  # Move towards target
  global_position = global_position.move_toward(target, speed * delta)

  # Calculate actual velocity
  velocity = (global_position - old_position) / delta

  # Update direction based on velocity
  if velocity.length() > 0:
    update_direction(velocity)

  # Update sprite flipping
  if velocity.x != 0:
    animated_sprite.flip_h = velocity.x < 0

  play_animation()

  if global_position.distance_to(target) == 0:
    index += 1

  if index >= line.get_point_count():
    index = line.get_point_count() - 1
    # turn to look at player ->
    animated_sprite.flip_h = false
    return

func update_direction(vel: Vector2) -> void:
  # Horizontal movement takes priority
  if abs(vel.x) > abs(vel.y):
    last_direction = "Side"
  elif vel.y > 0:
    last_direction = "Down"
  else:
    last_direction = "Up"

func play_animation() -> void:
  if not animated_sprite:
    return

  var animation_name: String

  # If moving, show directional animation, otherwise idle
  if velocity.length() > 0:
    animation_name = "run" + last_direction
  else:
    animation_name = "idle" + last_direction

  # Check if the specific animation exists
  if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation(animation_name):
    animated_sprite.play(animation_name)
  # Fall back to idleSide if nothing else exists
  elif animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("idleSide"):
    animated_sprite.play("idleSide")

extends Node2D

enum SpriteType {
  BIRD,
  BEE,
  BUTTERFLY,
  CATERPILLAR,
  SNAIL
}

@export var sprite_type: SpriteType = SpriteType.BIRD

var BIRD_SPEED: float = 50.0
var BIRD_ROAM: float = 200.0
var BEE_SPEED: float = 120.0
var BEE_ROAM: float = 20.0
var BUTTERFLY_SPEED: float = 30.0
var BUTTERFLY_ROAM: float = 80.0
var CATERPILLAR_SPEED: float = 2.0
var CATERPILLAR_ROAM: float = 60.0
var SNAIL_SPEED: float = 5.0
var SNAIL_ROAM: float = 40.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var initial_position: Vector2
var target_position: Vector2
var start_position: Vector2
var is_flipped: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  set_animation()
  initial_position = global_position

func _process(delta: float) -> void:
  # Pick new target if no target or reached target
  if not target_position or global_position.distance_to(target_position) < 5.0:
    pick_new_target()

  # Move towards target position
  var speed = get_selected_details().speed
  var direction = (target_position - global_position).normalized()
  global_position += direction * speed * delta

  # Update facing direction based on movement direction
  if direction.x < 0:
    animated_sprite.flip_h = not is_flipped # Moving left
  elif direction.x > 0:
    animated_sprite.flip_h = is_flipped # Moving right

func pick_new_target() -> void:
  var roam_distance = get_selected_details().roam
  var random_offset = Vector2(
    randf_range(-roam_distance, roam_distance),
    randf_range(-roam_distance, roam_distance)
  )
  target_position = initial_position + random_offset

func set_animation() -> void:
  match sprite_type:
    SpriteType.BIRD:
      is_flipped = true
      animated_sprite.animation = "bird"
    SpriteType.BEE:
      is_flipped = false
      animated_sprite.animation = "bee"
    SpriteType.BUTTERFLY:
      is_flipped = false
      animated_sprite.animation = "butterfly"
    SpriteType.CATERPILLAR:
      is_flipped = true
      animated_sprite.animation = "caterpillar"
    SpriteType.SNAIL:
      is_flipped = false
      animated_sprite.animation = "snail"
  animated_sprite.play()

func get_selected_details() -> Dictionary:
  match sprite_type:
    SpriteType.BIRD:
      return {"speed": BIRD_SPEED, "roam": BIRD_ROAM}
    SpriteType.BEE:
      return {"speed": BEE_SPEED, "roam": BEE_ROAM}
    SpriteType.BUTTERFLY:
      return {"speed": BUTTERFLY_SPEED, "roam": BUTTERFLY_ROAM}
    SpriteType.CATERPILLAR:
      return {"speed": CATERPILLAR_SPEED, "roam": CATERPILLAR_ROAM}
    SpriteType.SNAIL:
      return {"speed": SNAIL_SPEED, "roam": SNAIL_ROAM}
  return {}

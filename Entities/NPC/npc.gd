extends StaticBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  # pick a random skin from 1-4
  var skin_index = randi() % 4 + 1
  # play animation of name
  animated_sprite.play(str(skin_index))

  # set random starting frame (0-3)
  var starting_frame = randi() % 4
  animated_sprite.frame = starting_frame

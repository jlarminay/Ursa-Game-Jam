extends StaticBody2D

@onready var sprite1: Sprite2D = $Sprite2D
@onready var sprite2: Sprite2D = $Sprite2D2
@onready var sprite3: Sprite2D = $Sprite2D3
@onready var sprite4: Sprite2D = $Sprite2D4
@onready var sprite5: Sprite2D = $Sprite2D5
@onready var sprite6: Sprite2D = $Sprite2D6
@onready var sprite7: Sprite2D = $Sprite2D7
@onready var sprite8: Sprite2D = $Sprite2D8
@onready var sprite9: Sprite2D = $Sprite2D9
@onready var sprite10: Sprite2D = $Sprite2D10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  # Create array of all sprites
  var sprites = [sprite1, sprite2, sprite3, sprite4, sprite5, sprite6, sprite7, sprite8, sprite9, sprite10]

  # Disable all sprites first
  for sprite in sprites:
    sprite.visible = false

  # Pick a random sprite to enable (0-3)
  var random_sprite_index = randi() % sprites.size()
  sprites[random_sprite_index].visible = true

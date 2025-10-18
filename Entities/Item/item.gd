extends Area2D


@export_enum("Carrot", "Flowers", "Honey", "Apple") var item: String
@onready var _animated_sprite = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  match item:
    "Carrot": _animated_sprite.play("Carrot")
    "Flowers": _animated_sprite.play("Flowers")
    "Honey": _animated_sprite.play("Honey")
    "Apple": _animated_sprite.play("Apple")

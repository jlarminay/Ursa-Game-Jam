extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var sign_read: bool = false
@export var sign_text: Array[String] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  sign_read = false
  animated_sprite.play("default")

func _on_body_entered(body: Node2D) -> void:
  if body.name == "Player" and not sign_read:
    sign_read = true
    animated_sprite.visible = false
    Game.can_player_move = false
    await TextBox.show_text(sign_text)
    Game.can_player_move = true

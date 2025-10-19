extends Area2D


@export var regrab_threshold: int
@export_enum("Carrot", "Flowers", "Honey", "Apple", "Axe", "Pickaxe") var item: String
@onready var _animated_sprite = $AnimatedSprite2D
var player: CharacterBody2D
var recently_dropped = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  player = get_tree().current_scene.find_child("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
  _animated_sprite.play(item)

  # if distance > 5 then set rd false
  if global_position.distance_to(player.global_position) > regrab_threshold:
    recently_dropped = false

func _on_body_entered(body: Node2D) -> void:
  if recently_dropped:
    return

  if (not body.name == 'Player'):
    return

  if (body.held_item == "None"):
    body.held_item = item
    queue_free()

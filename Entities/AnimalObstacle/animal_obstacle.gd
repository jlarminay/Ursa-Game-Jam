extends RigidBody2D

@export_enum("Pig", "Bear", "Rabbit") var animal: String
@export_enum("Up", "Down", "Left", "Right") var direction: String
@export var speed: float = 10.0
@export var detection_distance: float = 100.0
@export var allowed_variance = 10
@onready var _animated_sprite = $AnimatedSprite2D
@onready var _collision_shape = $CollisionShape2D
var is_walking: bool = false
var player: CharacterBody2D
var animal_food_map = {
  Rabbit = "Carrot",
  Bear = "Honey",
  Pig = "Apple",
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  # Find the player by node name
  player = get_tree().current_scene.find_child("Player", true, false)
  if player:
    player.connect("item_dropped", _on_item_dropped)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
  if is_walking:
    if direction == "Up" || direction == "Down":
      _animated_sprite.play(animal + " Walk " + direction)
    else:
      if direction == "Right":
        _animated_sprite.flip_h = true
      _animated_sprite.play(animal + " Walk Side")
    return

  if direction == "Up" || direction == "Down":
    _animated_sprite.play(animal + " Idle " + direction)
  else:
    if direction == "Right":
      _animated_sprite.flip_h = true
    _animated_sprite.play(animal + " Idle Side")


func _on_item_dropped(item: Node2D):
  var difference_vector = Vector2(
    global_position.x - item.global_position.x,
    global_position.y - item.global_position.y
  )

  if not item.item == animal_food_map[animal]:
    return

  if direction == "Up":
    if difference_vector.y > 0 && abs(difference_vector.y) <= detection_distance && abs(difference_vector.x) <= allowed_variance:
      tween_and_move(item)

  if direction == "Down":
    if difference_vector.y < 0 && abs(difference_vector.y) <= detection_distance && abs(difference_vector.x) <= allowed_variance:
      tween_and_move(item)

  if direction == "Left":
    if difference_vector.x > 0 && abs(difference_vector.x) <= detection_distance && abs(difference_vector.y) <= allowed_variance:
      tween_and_move(item)

  if direction == "Right":
    if difference_vector.y < 0 && abs(difference_vector.x) <= detection_distance && abs(difference_vector.y) <= allowed_variance:
      tween_and_move(item)

func tween_and_move(target: Node2D):
  var tween = get_tree().create_tween()
  tween.tween_property(self, "global_position", target.global_position, 1.0)
  _collision_shape.disabled = true
  is_walking = true
  await tween.finished
  target.queue_free()
  is_walking = false

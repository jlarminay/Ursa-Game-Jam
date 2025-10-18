extends Area2D

@export var speed: float = 300.0
@export var lifetime: float = 10.0

var direction: Vector2
var player: CharacterBody2D
var lifetime_timer: float

func _ready() -> void:
  # Find player for collision detection
  player = get_tree().current_scene.find_child("Player", true, false)

  # Set up collision detection
  body_entered.connect(_on_body_entered)

  # Initialize lifetime timer
  lifetime_timer = lifetime

func _process(delta: float) -> void:
  # Move the egg
  if direction != Vector2.ZERO:
    global_position += direction * speed * delta

  # Update lifetime timer
  lifetime_timer -= delta
  if lifetime_timer <= 0:
    _on_lifetime_expired()

func set_target(_target_pos: Vector2, dir: Vector2) -> void:
  direction = dir

func _on_body_entered(body: Node) -> void:
  if body.name == "Player":
    Game.game_over = true
    queue_free()

func _on_lifetime_expired() -> void:
  queue_free()

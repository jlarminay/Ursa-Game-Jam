extends Node2D

@export var egg_scene: PackedScene
@onready var line: Line2D = $Line2D

var player: CharacterBody2D
var throw_cooldown_timer: float = 0.0
var throw_cooldown: float = 1
var detection_distance: float = 100.0
var line_visibility_distance: float = 200.0

func _ready() -> void:
    # Find the player by node name
    player = get_tree().current_scene.find_child("Player", true, false)

    # Setup line
    if line:
        line.width = 1.0
        line.default_color = Color.GREEN

func _process(delta: float) -> void:
    # Update throw cooldown timer
    if throw_cooldown_timer > 0:
        throw_cooldown_timer -= delta
    if not player:
        return

    update_line_to_player()
    check_distance_and_throw()

func update_line_to_player() -> void:
    if not line or not player:
        return

    var distance_to_player = global_position.distance_to(player.global_position)

    # Hide/show line based on distance
    if distance_to_player > line_visibility_distance:
        line.visible = false
        return
    else:
        line.visible = true

    # Update existing line points (convert global to local coordinates)
    # Point 0: Chicken position (local to line)
    # Point 1: Player position (local to line)
    if line.get_point_count() >= 2:
        line.set_point_position(0, line.to_local(global_position))
        line.set_point_position(1, line.to_local(player.global_position))

    # Change color based on distance
    if distance_to_player <= detection_distance:
        line.default_color = Color.RED
    else:
        line.default_color = Color.GREEN

func check_distance_and_throw() -> void:
    if not player:
        return

    var distance_to_player = global_position.distance_to(player.global_position)

    # If player is within range and cooldown is ready
    if distance_to_player <= detection_distance and can_throw_egg():
        throw_egg()

func can_throw_egg() -> bool:
    return throw_cooldown_timer <= 0

func throw_egg() -> void:
    if not egg_scene or not player:
        return

    # Create egg instance
    var egg = egg_scene.instantiate()
    get_tree().current_scene.add_child(egg)

    # Position egg at chicken
    egg.global_position = global_position

    # Calculate direction to player
    var direction = (player.global_position - global_position).normalized()

    # Set egg target (you'll need to implement this in the egg script)
    if egg.has_method("set_target"):
        egg.set_target(player.global_position, direction)

    # Start cooldown timer
    throw_cooldown_timer = throw_cooldown
